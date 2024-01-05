--[[
Copyright (C) 2020, 2021 penguin0616

This file is part of Insight.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details
The source codes does not come with any warranty including
the implied warranty of merchandise.
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

-- oceanfishingrod.lua
-- oceanfishingrod:SetTarget() called by OceanFishable:SetRod() called by 
--[[
	Fishing process:
	1. Place oceanfishingbobber in rod
	2. Place oceanfishinglure in rod
	3. Cast line (rod.target = projectile)
	4. oceanfishinghook is spawned at landed pos (rod.target = "oceanfishingbobber_none_floater") (hook has oceanfishable component)
		-- hook is irrelevant to lure in terms of rod.target
	5. wait until something happens
	6. when fish takes the bait (rod.target = fish)
]]

-- oceanfishinghook's reelmod is 0 until the first reel and then lerps from 1 to 0 over a rather long time

--local text_entity = nil
local RichFollowText = import("widgets/richfollowtext")
local followtext = nil


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Server Logic ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local fishing_states = {}

--- Triggers whenever an oceanfishingrod is done fishing.
local function OnDoneFishing(rod, reason, lose_tackle, fisher, target)
	--mprint'ondonefishing'
	local state = fishing_states[fisher]
	if state then
		if reason == "success" then
			-- The fisher successfully caught the fish.
			rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "SetOceanFishingStatus"), fisher.userid, "fish_caught")
		else
			rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "SetOceanFishingStatus"), fisher.userid, "fish_lost")
		end

		if state.task then
			state.task:Cancel()
			state.task = nil
		end
	end

	fishing_states[fisher] = nil
end

--- Hooks a rod for OnDoneFishing tracking.
---@param rod EntityScript
---@return boolean @true if the rod has been hooked before.
local function HookDoneFnForRod(rod)
	if not rod._insighthooked then
		rod._insighthooked = true
		
		local old = rod.components.oceanfishingrod.ondonefishing
		rod.components.oceanfishingrod.ondonefishing = function(...)
			OnDoneFishing(...)
			if old then
				return old(...)
			end
		end

		return false
	end

	return true
end

local function SERVER_UpdateInterestedFish(player)
	local state = fishing_states[player]
	if not state then
		mprintf("[SERVER_UpdateInterestedFish] Missing fishing state for %s??", player)
		return
	end

	local count = 0
	local interested_fish = {}
	local interest_levels = {}
	for guid, interest in pairs(state.hook.components.oceanfishinghook.interest) do
		local fish = Ents[guid]
		if fish then
			count = count + 1
			interested_fish[count] = fish
			-- I just thought of this approach for truncating a decimal. It's probably already a known thing, but it feels cool right now.
			interest_levels[count] = (interest - interest % 0.01)
		end

		if #fish >= 48 then
			-- RPC limit
			break
		end
	end

	interest_levels = table.concat(interest_levels, ";")

	rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "SetOceanFishingStatus"), player.userid, "interested_fish", interest_levels, unpack(interested_fish))
end

local function SERVER_OnHookLanded(player, hook)
	--mprint'SERVER_OnHookLanded'
	local rod = hook.components.oceanfishable:GetRod()
	if not rod then
		-- Something's not right?
		mprintf("SERVER_OnHookLanded can't find the rod of hook [%s] for player %s", hook, player)
		return
	end

	HookDoneFnForRod(rod)

	local state = {
		rod = rod,
		hook = hook,
	}

	fishing_states[player] = state
	
	--indmprint'onhooklanded'
	-- This RPC is randomly not sending.
	player:DoTaskInTime(0.5, function()
		if fishing_states[player] ~= state then return end
		rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "SetOceanFishingStatus"), player.userid, "hook_landed", hook)
		player:DoTaskInTime(0.5, function()
			-- Make sure this is still the same state.
			if fishing_states[player] ~= state then return end
			-- It seems that the virtualocean (icefishing_hole) has the ability to instantly hook a fish,
			-- which removes the hook from the state.
			-- So starting the fish interest polling causes a crash.
			if fishing_states[player].hook ~= nil then
				fishing_states[player].task = player:DoPeriodicTask(0.1, SERVER_UpdateInterestedFish)
			end
		end)
	end)
end

local function SERVER_UpdateFishingBattleState(player)
	local state = fishing_states[player]
	if not state then
		mprintf("[SERVER_UpdateFishingBattleState] Missing fishing state for %s??", player)
		return
	end

	local tension = {
		current = state.rod.components.oceanfishingrod.line_tension,
		--unreeling = TUNING.OCEAN_FISHING.START_UNREELING_TENSION, -- Hmmm.. is this really necessary?
		max = TUNING.OCEAN_FISHING.REELING_SNAP_TENSION
	}

	local slack = {
		current = state.rod.components.oceanfishingrod.line_slack,
		max = 1
	}

	local distance = {
		-- The presence of tag "catch_distance" chooses whether the fish can be caught or not.
		catch = state.target_fish.components.oceanfishable.catch_distance,
		flee = TUNING.OCEAN_FISHING.MAX_HOOK_DIST,
	}

	local data = {
		tension = tension,
		slack = slack,
		distance = distance,
	}

	rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "SetOceanFishingStatus"), player.userid, "battle_state", json.encode(data))
end

local function SERVER_OnFishHooked(player, fish)
	local context = GetPlayerContext(player)
	--[[
	if not context.config["display_oceanfishing"] then
		return
	end
	--]]

	local rod = fish.components.oceanfishable:GetRod()
	if not rod then
		-- Something's not right?
		mprintf("SERVER_OnFishHooked can't find the rod of the hooked fish [%s] for player %s", fish, player)
		return
	end

	local state = fishing_states[player]

	if not state then
		-- Something's not right?
		mprintf("SERVER_OnFishHooked can't find the state for player %s", player)
		return
	end

	state.hook = nil

	-- There's some funny stuff with the new ice fishing hole thing for Michael.
	if state.task then
		--mprint("Clear previous task")
		state.task:Cancel()
		state.task = nil
	end


	--mprint("SERVER_OnFishHooked", player, fish)

	state.target_fish = fish
	state.task = player:DoPeriodicTask(FRAMES, SERVER_UpdateFishingBattleState)

	-- For the sharkboimanager, the server is spawning a fish and it hasn't been replicated to the client yet.
	-- So this RPC never lands and the battle state doesn't have the fish tracked.
	-- Ugh. Fixing this is more trouble than it's worth, 
	-- And doing so provides little real value. The fish in the "virtualocean" hole
	-- Is pretty easy to catch and seems to be largely impossible to lose once it's been hooked.
	-- Which means that the information provided is basically useless.
	-- So I'll just have the client say data is missing.
	rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "SetOceanFishingStatus"), player.userid, "fish_hooked", fish, json.encode(fish.fish_def))
end

local function OnServerInit()
	if not IS_DST then return end

end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Client Logic ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local current_hook = nil
local target_fish = nil
local last_interested = nil

local GREEN = Color.fromHex("#00cc00")
local RED = Color.fromHex("#dd5555")
local COOL_GREEN = Color.fromHex("#66CC00")
local BLUE = Color.fromHex("#5B63D2")

local function AddLabel(inst)
	local label = inst.entity:AddLabel()
	label:SetWorldOffset(0, -2, 0)
	label:SetFont(CHATFONT_OUTLINE)
	label:SetFontSize(12)
	label:Enable(false)
	label:SetText("")

	return label
end

local function OnFishCaught(player)
	dprint'OnFishCaught'
	target_fish = nil
	--text_entity:Clear()
	followtext:SetTarget(nil)
	followtext:Hide()
end

local function OnFishLost(player)
	dprint'OnFishLost'
	target_fish = nil
	--text_entity:Clear()
	followtext:SetTarget(nil)
	followtext:Hide()
end

local function CLIENT_UpdateInterestedFish(player, data)
	if not current_hook then
		mprint("[CLIENT_UpdateInterestedFish] Missing hook?")
		return
	end

	local context = GetPlayerContext(player)

	local interested = data.interested

	if last_interested then
		for fish in pairs(last_interested) do
			fish.insight_interest_label:Enable(false)
		end
	end

	local count = 0
	for fish, amount in pairs(interested) do
		if not fish.insight_interest_label then fish.insight_interest_label = AddLabel(fish) end

		if amount > 0 then
			fish.insight_interest_label:SetText(string.format(context.lstr.oceanfishingrod.hook.interest, amount))
			fish.insight_interest_label:Enable(true)
			count = count + 1
		end
	end

	--mprint("UPDATE", followtext.text:GetString(), followtext.shown, followtext.target)
	followtext.text:SetString(string.format(context.lstr.oceanfishingrod.hook.num_interested, count))

	last_interested = interested
end

local function CLIENT_OnHookLanded(player, hook)
	current_hook = hook
	
	followtext:SetTarget(hook)
	followtext.text:SetString("?")
	followtext:Show()
end

local function CLIENT_UpdateFishingBattleState(player, data)
	if not target_fish then
		mprint("CLIENT UpdateFishingBattleState called with missing fish?")
		current_hook = nil
		if last_interested then
			for fish in pairs(last_interested) do
				fish.insight_interest_label:Enable(false)
			end
			last_interested = nil -- Not necessary anymore.
		end
		followtext:SetTarget(localPlayer)
		followtext.text:SetString("(Missing Fish Data)")
		-- followtext:Hide()
		return
	end

	local context = GetPlayerContext(player)

	-- Tension
	local tension_color = GREEN:Lerp(RED, data.tension.current / data.tension.max):ToHex()
	local tension_str = string.format(context.lstr.oceanfishingrod.battle.tension, tension_color, data.tension.current * 100, data.tension.max * 100)

	-- Slack
	local slack_color = GREEN:Lerp(RED, data.slack.current / data.slack.max):ToHex()
	local slack_str = string.format(context.lstr.oceanfishingrod.battle.slack, slack_color, data.slack.current * 100, data.slack.max * 100)

	-- Distance
	if target_fish:IsValid() then
		-- Someone had a case where target_fish was invalid. Don't know why, but 
		local distance = player:GetDistanceSqToInst(target_fish)
		local catch_distance_sq = data.distance.catch * data.distance.catch
		local distance_to_catch = math.max(0, distance - catch_distance_sq)
		local distance_to_flee = data.distance.flee * data.distance.flee

		--local distance_color = COOL_GREEN:Lerp(BLUE, distance_to_catch / distance_to_flee):ToHex()
		--local distance_str = string.format(context.lstr.oceanfishingrod.battle.distance, 0, distance_color, distance_to_catch, distance_to_flee)
	end

	local str = CombineLines(tension_str, slack_str)
	--text_entity:SetText(str)
	followtext.text:SetString(str)
end

local function CLIENT_OnFishHooked(player, fish, fish_def)
	current_hook = nil
	if last_interested then
		for fish in pairs(last_interested) do
			fish.insight_interest_label:Enable(false)
		end
		last_interested = nil -- Not necessary anymore.
	end

	followtext.text:SetString("")
	--mprint("haha fishy hook", player, fish, fish_def)
	target_fish = fish
	followtext:SetTarget(fish)
	followtext:Show()
	--text_entity:SetTarget(fish)
	--text_entity:SetText("fishy :)")
end

local function OnClientInit()
	if not IS_DST then return end
	
	OnLocalPlayerPostInit:AddListener("oceanfishingrod_client", function()
		--text_entity = text_entity or SpawnPrefab("insight_entitytext")
		followtext = localPlayer.HUD:AddChild(RichFollowText(CHATFONT_OUTLINE, 22))
		followtext:SetHUD(localPlayer.HUD.inst)
    	followtext:SetOffset(Vector3(0, 200, 0))
    	followtext:Hide()

		localPlayer:ListenForEvent("insight_fishinghooklanded", CLIENT_OnHookLanded)
		localPlayer:ListenForEvent("insight_fishinginterested", CLIENT_UpdateInterestedFish)

		localPlayer:ListenForEvent("insight_fishhooked", function(inst, data)
			CLIENT_OnFishHooked(inst, data.fish, data.fish_def)
		end)

		localPlayer:ListenForEvent("insight_fishcaught", OnFishCaught)
		localPlayer:ListenForEvent("insight_fishlost", OnFishLost)
		localPlayer:ListenForEvent("insight_fishingbattlestate", CLIENT_UpdateFishingBattleState)
	end)
end


--[[
local function Describe(self, context)
	local description = tostring(self.target) .. " | "

	local target = self.target
	if target and target.components.oceanfishinghook then
		local hook = target.components.oceanfishinghook
		local str = tostring(hook.reel_mod)
		description = CombineLines(description, str)
	end

	local tackle_data = self.gettackledatafn ~= nil and self.gettackledatafn(self.inst) or nil
	if tackle_data then
		local lure_data = tackle_data.lure and tackle_data.lure.components.oceanfishingtackle and tackle_data.lure.components.oceanfishingtackle.lure_data
		if lure_data then

		end
	end
	

	return {
		priority = 0,
		description = description
	}
end
--]]



return {
	Describe = Describe,

	SERVER_OnHookLanded = SERVER_OnHookLanded,
	SERVER_OnFishHooked = SERVER_OnFishHooked,

	OnServerInit = OnServerInit,
	OnClientInit = OnClientInit,
}