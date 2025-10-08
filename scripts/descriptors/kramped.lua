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

-- kramped.lua [Worldly]
local module = {
	initialized = false,
	active_players = {},
	naughtiness_values = {},
}

--- Returns the naughtiness values for the player.
--- @param player EntityScript
--- @return table @{ actions=int, threshold=int }
local function GetPlayerNaughtinessData(player)
	if IS_DS then
		local kramped = player.components.kramped
		if kramped then
			if not kramped.actions or not kramped.threshold then
				kramped:OnNaughtyAction(0)
			end

			if not (kramped.actions and kramped.threshold) then
				-- It is possible for this to happen if Krampus is disabled (see #61).
				--error("[Insight]: Kramped stats missing after initialization?")
				return
			end

			return { actions=kramped.actions, threshold=kramped.threshold }
		end

		return
	end
	
	if not TheWorld.ismastersim then
		--error("[Insight]: GetPlayerNaughtinessData called on client")
		mprint("GetPlayerNaughtinessData called on client")
		return
	end

	local data = module.active_players[player]

	if not data or not data.threshold or data.threshold < 0 then 
		return
	end

	return { actions = data.actions, threshold = data.threshold }
end

--- [DST] Returns naughtiness value of a creature.
---@param inst EntityScript The living creature.
---@return number
local function DST_GetCreatureNaughtinessValue(inst, context)
	if not TheWorld.ismastersim then
		error("[Insight]: DST_GetCreatureNaughtinessValue called on client")
	end

	if inst.components.werebeast ~= nil and inst.components.werebeast:IsInWereState() then
		-- you can kill werebeasts all you want with no moral sin
		return 0
	end

	local res = module.naughtiness_values[inst.prefab]

	local fn_data = {
		victim = inst
	}

	-- I sure hope no one is doing anything funny like using this as a hook for OnKilledOther, 
	-- doing definitive things that shouldn't be happening for a simple query of naughtiness value! 
	-- Fix requested by Hornet, probably for IA or something
	res = FunctionOrValue(res, context.player, fn_data)

	if type(res) == "number" then
		return res
	end

	--[[
	if type(res) == "function" then
		-- their doydoys have naughtiness as a function, which is supported by gemcore. https://gitlab.com/IslandAdventures/IslandAdventures/-/blob/master/modmain.lua (September 19, 2020)
		res = res()
	end

	if type(res) == "number" then
		return res
	end
	--]]
	
	return 0
end

--- [DS] Returns naughtiness value of a creature.
---@param inst EntityScript The living creature.
---@return number
local function GetCreatureNaughtinessValue(inst, context)
	if IS_DST then
		return DST_GetCreatureNaughtinessValue(inst, context)
	end

	local name = inst.prefab

	if name ~= 'doydoy' and name ~= 'pigman' and name ~= 'ballphin' and module.naughtiness_values[name] then
		return module.naughtiness_values[name]
	end

	-- not DST
	local kramped = GetPlayer().components.kramped

	--local oldOnKilledOther = kramped.onkilledother
	local oldOnNaughtyAction = kramped.OnNaughtyAction

	kramped.OnNaughtyAction = function(self, value)
		module.naughtiness_values[name] = value
	end

	kramped:onkilledother(inst)

	kramped.OnNaughtyAction = oldOnNaughtyAction

	if not module.naughtiness_values[name] then
		module.naughtiness_values[name] = 0
	end

	return module.naughtiness_values[name]
end


--- yep
--- @param self kramped
local function OnKrampedPostInit(self)
	mprintf("Setting up kramped hooks for '%s'", self)
	if not self.GetDebugString then
		mprint("Unable to find GetDebugString from kramped. Exiting naughtiness early.")
		return
	--[[elseif debug.getinfo(kramped.GetDebugString, "S").source ~= "scripts/components/kramped.lua" then
		mprint("Unable to setup kramped with non-vanilla kramped file.")
		return
		--]]
	end

	-- We're grabbing the list of active players directly from the component to use for ours.
	local _activeplayers = util.getupvalue(self.GetDebugString, "_activeplayers")
	if not _activeplayers then
		local d = debug.getinfo(self.GetDebugString, "Sl")
		mprint("Kramped::GetDebugString ->", d.source, d.linedefined)
		return --assert(_activeplayers, "[Insight]: Kramped failed to load _activeplayers, are you using mods that affect krampii?")
	end

	module.active_players = _activeplayers

	-- i can't begin to describe how much this hurt me (Basements) https://steamcommunity.com/sharedfiles/filedetails/?id=1349799880 
	-- they call ms_playerjoined and ms_playerleft manually on functions that have an _activeplayers upvalue. 
	-- i shouldnt have to do this for a variety of reasons, but here we are...
	-- note: because of how this works, entering/leaving one of those basements no longer resets your naughtiness.
	
	for i,v in pairs(TheWorld.event_listening.ms_playerleft[TheWorld]) do 
		if debug.getinfo(v, "S").source == "scripts/components/kramped.lua" then 
			module.OnPlayerLeft = v;
			TheWorld.event_listening.ms_playerleft[TheWorld][i] = function(...)
				return module.OnPlayerLeft(...)
			end
			break;
		end 
	end 
	
	for i,v in pairs(TheWorld.event_listening.ms_playerjoined[TheWorld]) do 
		if debug.getinfo(v, "S").source == "scripts/components/kramped.lua" then 
			module.OnPlayerJoined = v;
			module.OnKilledOther = util.recursive_getupvalue(v, "OnKilledOther")

			TheWorld.event_listening.ms_playerjoined[TheWorld][i] = function(...)
				return module.OnPlayerJoined(...)
			end
			break;
		end 
	end

	if module.OnKilledOther then
		-- Zarklord's GemCore (https://steamcommunity.com/sharedfiles/filedetails/?id=1378549454) fiddles with OnKilledOther [September 6, 2020]
		module.oldOnNaughtyAction = util.recursive_getupvalue(module.OnKilledOther, "OnNaughtyAction")
	end

	for i,v in pairs({"OnPlayerLeft", "OnPlayerJoined", "OnKilledOther", "oldOnNaughtyAction"}) do
		if type(module[v]) ~= "function" then
			mprintf("Kramped failed to load -- could not find %s (got %s)", v, type(module[v]))
			return
		end
	end

	util.replaceupvalue(module.OnKilledOther, "OnNaughtyAction", function(how_naughty, playerdata)
		--dprint("onnaughtyaction", how_naughty, playerdata, playerdata.player)
		--mprint("ON NAUGHTY ACTION BEFORE", playerdata.player, GetNaughtiness(playerdata.player).actions, GetNaughtiness(playerdata.player).threshold)
		module.oldOnNaughtyAction(how_naughty, playerdata)
		--mprint("ON NAUGHTY ACTION AFTER", playerdata.player, GetNaughtiness(playerdata.player).actions, GetNaughtiness(playerdata.player).threshold)
		--mprint(playerdata.actions, playerdata.threshold)
		-- while i could just pass in the playerdata........ i dont feel like it
		if playerdata.player.components.insight then
			playerdata.player.components.insight:SendNaughtiness()
		end
	end)

	-- Load naughtiness values
	if tonumber(APP_VERSION) > 435626 then -- zark
		module.naughtiness_values = NAUGHTY_VALUE
	elseif module.OnKilledOther then
		module.naughtiness_values = util.getupvalue(module.OnKilledOther, "NAUGHTY_VALUE")
	end

	setmetatable(module.active_players, {
		__newindex = function(self, player, playerdata)
			mprintf("Kramped initialized player '%s'", player)
			--[[
			-- Hacky upvalue search, yay.
			if not module.OnKilledOther then
				-- this isn't annoying at all!
				local i = 2
				while true do
					local info = debug.getinfo(i)

					if not info then
						break
					end

					local func = util.getupvalue(info.func, "OnKilledOther")
					if type(func) == "function" then
						OnKilledOther = func
						if i > 2 then
							mprint("Got OnKilledOther at a level greater than two.")
						end
						break
					end
				end
			end
			--]]

			-- Insert the player and the data.
			rawset(self, player, playerdata)

			-- Register player's naughtiness threshold.
			-- We need to check to make sure kramped isn't disabled -- if it is and we trigger this, 
			-- then the player will get the noise each time they kill something. 
			if TUNING.KRAMPUS_THRESHOLD ~= -1 then
				module.OnKilledOther(player, {
					-- fake a victim
					victim = {
						prefab = "glommer",
						HasTag = function(...) return false end,
					},
					stackmult = 0, -- no naughtiness gained since it multiplies naughtiness by this value
				})
			else
				module.active_players[player].threshold = 0
			end

			if player.components.insight then
				--dprint'attempt to send naughtiness'
				-- Client initialized sends it now. Why did I do that again?
				--player.components.insight:SendNaughtiness()
				--dprint'attempt finished'
			else
				mprint("Unable to send initial naughtiness to:", player)
			end
		end,
		__metatable = "[Insight] The metatable is locked"
	})

	mprintf("Kramped hook setup is complete for '%s'", self)
end

local function OnServerLoad()
	mprint("Kramped OnServerLoad")
	if module.initialized then
		return
	end

	mprint("Kramped initialized")
	module.initialized = true

	if not IS_DST then
		mprint("Kramped not DST")
		return
	end

	if TheWorld and TheWorld.components.kramped then
		mprint("!!! KRAMPED CALLED LATE?")
	end

	AddComponentPostInit("kramped", OnKrampedPostInit)
end

local function DescribePlayer(inst, context)
	local description, naughtiness

	if not IsPrefab(inst) then
		return
	end

	if not inst:HasTag("player") then
		return
	end

	naughtiness = GetPlayerNaughtinessData(inst, context)

	if type(naughtiness) == "table" then
		local fmt_string = context.lstr.kramped.localplayer_naughtiness
		if inst ~= context.player then
			fmt_string = context.lstr.kramped.naughtiness .. " / %s" -- Too lazy to add a separate string atm.
		end

		description = string.format(fmt_string, naughtiness.actions, naughtiness.threshold)
	end

	return {
		name = "kramped_playernaughtiness",
		priority = 0,
		description = description,
		--naughtiness = naughtiness
	}
end

local function DescribeCreature(inst, context)
	local description, naughtiness

	if not IsPrefab(inst) then
		return
	end

	if not inst.components.health then
		return
	end
	
	naughtiness = GetCreatureNaughtinessValue(inst, context)

	if type(naughtiness) == "number" and naughtiness ~= 0 then
		description = string.format(context.lstr.kramped.naughtiness, naughtiness)
	end

	return {
		name = "kramped_creaturenaughtiness",
		priority = 0,
		description = description,
		--naughtiness = naughtiness
	}
end

return {
	OnServerLoad = OnServerLoad,
	DescribePlayer = DescribePlayer,
	DescribeCreature = DescribeCreature,
	GetPlayerNaughtinessData = GetPlayerNaughtinessData,
	--GetCreatureNaughtinessValue = GetCreatureNaughtinessValue
}