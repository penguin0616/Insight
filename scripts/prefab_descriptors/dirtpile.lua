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

-- dirtpile.lua [Prefab]
local function DescribeTrack(descriptor, inst, context)
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

	local hunt_data = descriptor:GetHuntDataFromTrack(inst)

	if not hunt_data then
		--dprintf("no hunt data found for track %s", inst)
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


local function Describe(inst, context)
	return DescribeTrack(Insight.descriptors.hunter, inst, context)
end

return {
	Describe = Describe,
	DescribeTrack = DescribeTrack
}