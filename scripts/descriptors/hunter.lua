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
local world_type = GetWorldType()
local function GetAlternateBeastChance()
	if world_type == 0 then
		return nil
	end

    local day = world_type == -1 and TheWorld.state.cycles or GetClock():GetNumCycles()
    local chance = Lerp(TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MIN, TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MAX, day/100)
    return math.clamp(chance, TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MIN, TUNING.HUNT_ALTERNATE_BEAST_CHANCE_MAX)
end

local function GetHuntFromTrack(inst)
	for i = 1, #Insight.active_hunts do
		local hunt = Insight.active_hunts[i]

		if hunt.lastdirt == inst then
			return hunt
		end
	end
end

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

local function Describe(self, context)
	if true then
		return nil
	end

	local description = nil

	return {
		priority = 0,
		description = description,
		worldly = true
	}
end



return {
	Describe = Describe,
	DescribeTrack = DescribeTrack,
}