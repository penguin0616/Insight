--[[
Copyright (C) 2020 penguin0616

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
-- farmsoildrinker.lua

local farmingHelper = import("helpers/farming")

local function Describe(self, context)
	if not farmingHelper.GetTileDataAtPoint then
		return { priority=0; description = "Cannot find tile data information."}
	end

	local description = nil
	local verbosity = context.config.soil_moisture
	local tile_moisture = farmingHelper.GetTileMoistureAtPoint(self.inst.Transform:GetWorldPosition())


	if verbosity == 1 then
		-- tile moisture only
		-- Water: 33%
		description = string.format(context.lstr.farmsoildrinker.soil_only, Round(tile_moisture, 0))

	elseif verbosity == 2 then
		-- tile moisture and plant delta
		-- Water: 33% (-2/min)
		local plant_delta = self:GetMoistureRate() * 60
		description = string.format(context.lstr.farmsoildrinker.soil_plant, Round(tile_moisture, 1), Round(plant_delta, 1))

	elseif verbosity == 3 then
		-- tile moisture, plant delta, entire tile delta
		-- Water: 33% (-2 [-14])/min
		local plant_delta = self:GetMoistureRate() * 60
		local tile_delta = farmingHelper.GetTileMoistureDelta(self.inst.Transform:GetWorldPosition()) * 60
		description = string.format(context.lstr.farmsoildrinker.soil_plant_tile, Round(tile_moisture, 1), Round(plant_delta, 1), Round(tile_delta, 1))

	elseif verbosity == 4 then
		-- tile moisture, plant delta, entire tile delta
		-- Water: 33% (-2 [-14 + 3 = 11])/min
		local plant_delta = self:GetMoistureRate() * 60
		local tile_delta = farmingHelper.GetTileMoistureDelta(self.inst.Transform:GetWorldPosition()) * 60
		local world_delta = farmingHelper.GetWorldMoistureDelta() * 60
		description = string.format(context.lstr.farmsoildrinker.soil_plant_tile_net, 
			Round(tile_moisture, 1), 
			Round(plant_delta,  1), 
			Round(tile_delta, 1),
			Round(world_delta, 1),
			world_delta + tile_delta -- rounded by the string
		)
	end
	

	return {
		priority = 1,
		description = description
	}
end

return {
	Describe = Describe
}