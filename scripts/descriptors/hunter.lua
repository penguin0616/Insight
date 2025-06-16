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

-- hunter.lua
local module = {
	initialized = false,
	active_hunts = {},
}
local world_type = GetWorldType()

--- Calculates the chance of getting one of the alternate beasts, i.e. not a Koalefant.
--- @return number
local function GetAlternateBeastChance()
	if world_type == 0 then
		return nil
	end

    local day = world_type == -1 and TheWorld.state.cycles or GetClock():GetNumCycles()
    local chance = Lerp(TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MIN, TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MAX, day/100)
    return math.clamp(chance, TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MIN, TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MAX)
end

--- Fetches the active hunt data from the dirt track.
--- @param inst EntityScript The dirt track.
--- @return table @The hunt data.
local function GetHuntFromTrack(inst)
	for i = 1, #module.active_hunts do
		local hunt = module.active_hunts[i]

		if hunt.lastdirt == inst then
			return hunt
		end
	end
end

--- Fetches
local function GetHuntDataFromTrack(inst)
	local hunt = GetHuntFromTrack(inst)

	if not hunt then
		return
	end

	return {
		trackspawned = hunt.trackspawned,
		numtrackstospawn = hunt.numtrackstospawn,
		ambush_track_num = hunt.ambush_track_num,
		chance_of_alternate_beast = GetAlternateBeastChance() -- consider caching?
	}
end

local function DescribeTrack(inst, context)
	--[[
	for _, hunt in pairs(Insight.active_hunts) do
			if hunt.lastdirt == inst then
				local ambush_track_num = hunt.ambush_track_num
				description = string.format(context.lstr.hunt_progress, hunt.trackspawned + 1, hunt.numtrackstospawn)

				if ambush_track_num == hunt.trackspawned + 1 then
					description = CombineLines(description, "There is an ambush waiting on the next track.")
				end
				break
			end
		end
	--]]
	local hunt_data = GetHuntDataFromTrack(inst)

	if not hunt_data then
		return
	end

	local progress = string.format(context.lstr.hunter.hunt_progress, hunt_data.trackspawned + 1, hunt_data.numtrackstospawn) -- +1 to make it look better
	local ambush = nil
	if hunt_data.ambush_track_num and hunt_data.ambush_track_num == hunt_data.trackspawned + 1 then -- will it spawn on the next track?
		ambush = context.lstr.hunter.impending_ambush
	end
	local chance = hunt_data.chance_of_alternate_beast and (hunt_data.trackspawned+1 == hunt_data.numtrackstospawn) and string.format(context.lstr.hunter.alternate_beast_chance, Round(hunt_data.chance_of_alternate_beast * 100, 0)) or nil

	local description = CombineLines(progress, ambush, chance)

	return {
		name = "hunter",
		priority = 0,
		description = description
	}
end

--- Replacement for the OnDirtInvestigated function.
--- @param self hunter
--- @param pt Vector3
--- @param doer EntityScript The player/entity doing the investigation.
local function Hunter_OnDirtInvestigated(self, pt, doer, ...)
	local hunt = nil

	if IS_DST then
		-- find the hunt this pile belongs to
		for i,v in ipairs(module.active_hunts) do
			if v.lastdirt ~= nil and v.lastdirt:GetPosition() == pt then
				hunt = v
				--hunter.inst:RemoveEventCallback("onremove", v.lastdirt._ondirtremove, v.lastdirt)
				break
			end
		end

		if hunt == nil then
			-- we should probably do something intelligent here.
			--print("yikes, no matching hunt found for investigated dirtpile")
			return
		end
	else
		hunt = self -- has everything we need.. so......
	end

	-- No additional args but why not.
	module.oldOnDirtInvestigated(self, pt, doer, ...)

	local active_player = doer
	if IS_DS then
		active_player = GetPlayer()
	end

	if hunt.trackspawned < hunt.numtrackstospawn then
		--mprint('dirt?')
		if IS_DS then
			module.active_hunts = {self}
		end
	elseif hunt.trackspawned == hunt.numtrackstospawn then
		--mprint('animal?')
		if IS_DS then
			module.active_hunts = {}
		end
	else
		mprint("--------- WHAT ----------")
		table.foreach(hunt, mprint)
		--error("[Insight]: something weird happened during a hunt, please report")
		return
	end

	local context = active_player and GetPlayerContext(active_player)
	if not context or not context.config then
		mprint("player context is invalid. player:", active_player)
		if context then
			mprint(DataDumper(context))
		else
			mprint("\tcontext is nil")
		end
		return
	end

	if not context.config["hunt_indicator"] then
		return
	end

	local target = hunt.lastdirt or hunt.huntedbeast

	if not target then
		--dprint(string.format("Hunter '%s' missing target, aborting.", activeplayer.name))
		table.foreach(hunt, mprint)
		return
	else
		--dprint("Sending", activeplayer, "on a hunt for:", target, "|", hunt.trackspawned, hunt.numtrackstospawn)
	end

	if target.prefab == "claywarg" or target.prefab == "warg" or target.prefab == "spat" then
		mprint("skipped sending on a hunt for special hunt target:", target.prefab)
		return
	end

	--mprint"-----------------"

	active_player.components.insight:SetHuntTarget(target)
end

--- Component post init for the hunter component.
--- @param self hunter
local function OnHunterPostInit(self)
	if IS_DST then		
		module.active_hunts = util.recursive_getupvalue(self.OnDirtInvestigated, "_activehunts")
		if not module.active_hunts then
			assert(module.active_hunts, "[Insight]: Failed to load '_activehunts' from 'Hunter' component.") -- https://steamcommunity.com/sharedfiles/filedetails/?id=1991746508 overrided OnDirtInvestigated
			return
		end
	end

	module.oldOnDirtInvestigated = self.OnDirtInvestigated
	if IS_DST then
		local SpawnHuntedBeast = util.recursive_getupvalue(module.oldOnDirtInvestigated, "SpawnHuntedBeast") -- https://steamcommunity.com/sharedfiles/filedetails/?id=1991746508 messed with OnDirtInvestigated, October 20th 2020 (i just noticed the comment above, ironic)
		local oldEnv = getfenv(SpawnHuntedBeast)
		local SpawnPrefab = SpawnPrefab

		setfenv(SpawnHuntedBeast, setmetatable({
			SpawnPrefab = function(...) 
				local ent = SpawnPrefab(...)
				-- We need to track the hunted beast somehow.
				util.getlocal(2, "hunt").huntedbeast = ent
				return ent
			end
		}, {
			__index = oldEnv, 
			__metatable = "[Insight] The metatable is locked"
		}))
	end

	self.OnDirtInvestigated = Hunter_OnDirtInvestigated
end

-- TODO: There may be room to clean up this old hunter logic.
local function OnServerInit()
	if module.initialized then
		return
	end

	module.initialized = true

	AddComponentPostInit("hunter", OnHunterPostInit)
	AddComponentPostInit("whalehunter", OnHunterPostInit)
end



return {
	OnServerInit = OnServerInit,
	DescribeTrack = DescribeTrack,
}