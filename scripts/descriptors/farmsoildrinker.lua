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

local function DescribeMoisture(self, context, definition)
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
		name = "farmsoildrinker_moisture",
		priority = 1,
		description = description
	}
end

local function DescribeNutrients(self, context, definition)
	local description = nil
	local verbosity = context.config.soil_nutrients
	local tile_nutrients = farmingHelper.GetTileNutrientsAtPoint(self.inst.Transform:GetWorldPosition())
	local nutrient_consumption = definition.nutrient_consumption
	local nutrient_restoration = definition.nutrient_restoration

	if verbosity == 1 then
		-- tile nutrients only
		-- Nutrients: [2, 4, 8]
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_only, 
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure
		)

	elseif verbosity == 2 or verbosity == 3 then
		-- tile nutrients and plant delta
		-- Nutrients: [2, 4, 8] ([-1, +2, -3])
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_plant,
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure,
			-nutrient_consumption[1], -nutrient_consumption[2], -nutrient_consumption[3]	
		)

	elseif verbosity == 3 then
		--[[
		-- tile nutrients, plant delta, entire tile delta
		-- Nutrients: [2, 4, 8] ([-1, +2, -3] + [1, -2, 3] = [0, 0, 0])

		local total_restore_count = 0
		for n_type, count in ipairs(nutrient_consumption) do
			total_restore_count = total_restore_count + count
		end

		--amount of valid nutrient types to restore
		local nutrients_to_restore_count = GetTableSize(nutrient_restoration)
		--the amount of nutrients to restore to all nutrients in the restore table
		local nutrient_restore_count = math.floor(total_restore_count/nutrients_to_restore_count)

		--if the number doesn't divide evenly between the nutrients, randomly restore the excess nutrients to a valid type
		local excess_restore_count = total_restore_count - (nutrient_restore_count * nutrients_to_restore_count)
		--if excess_restore_count is 0 we do nothing
		--if excess_restore_count is 1, we add it to the nutrient determined by math.random
		--if excess_restore_count is 2, we add it to all other nutrients except the one determined by math.random
		---due to our total nutrient count, excess_restore_count will always come to be a valid number
		local excess_restore_rand = math.random(nutrients_to_restore_count)


		local net = {
			nutrient_consumption[1] + restore[1], 
			nutrient_consumption[2] + restore[2], 
			nutrient_consumption[3] + restore[3]
		}

		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_plant_tile, 
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure,
			nutrient_consumption[1], nutrient_consumption[2], nutrient_consumption[3],
			restore[1], restore[2], restore[3],
			net[1], net[2], net[3]
		)
		--]]
	end

	return {
		name = "farmsoildrinker_nutrients",
		priority = 1,
		description = description
	}
end

-- nutrient_consumption
-- local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS

local function Describe(self, context)
	if not farmingHelper.IsInitialized() then
		return { priority=0; description = "<color=#ff0000>Farming helper not initialized.</color>"}
	end

	local definition

	if self.inst.weed_def then
		-- weed
		definition = self.inst.weed_def
	elseif self.inst.plant_def then
		definition = self.inst.plant_def
	else
		return {
			priority = 0,
			description = "<color=#ff000>Can drink water but has no definition???</color>"
		}
	end

	return DescribeMoisture(self, context, definition), DescribeNutrients(self, context, definition)
end

return {
	Describe = Describe
}