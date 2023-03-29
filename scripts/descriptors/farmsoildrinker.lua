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

-- farmsoildrinker.lua
local farmingHelper = import("helpers/farming")

local function DescribeMoisture(self, context, definition)
	local description = nil
	local verbosity = context.config.soil_moisture

	if verbosity == 0 then
		return
	end

	local tile_moisture = farmingHelper.GetTileMoistureAtPoint(self.inst.Transform:GetWorldPosition())
	local plant_delta = self:GetMoistureRate() * 60
	local tile_delta = farmingHelper.GetTileMoistureDelta(self.inst.Transform:GetWorldPosition()) * 60
	local world_delta = farmingHelper.GetWorldMoistureDelta() * 60
	local alt_description

	if not tile_moisture then
		description = "Missing tile moisture data."
	else
		alt_description = string.format(context.lstr.farmsoildrinker.soil_plant_tile_net, 
			Round(tile_moisture, 1), 
			Round(plant_delta,  1), 
			Round(tile_delta, 1),
			Round(world_delta, 1),
			world_delta + tile_delta -- rounded by the string
		)
		
		if verbosity == 1 then
			-- tile moisture only
			-- Water: 33%
			description = string.format(context.lstr.farmsoildrinker.soil_only, Round(tile_moisture, 0))

		elseif verbosity == 2 then
			-- tile moisture and plant delta
			-- Water: 33% (-2/min)
			description = string.format(context.lstr.farmsoildrinker.soil_plant, Round(tile_moisture, 1), Round(plant_delta, 1))

		elseif verbosity == 3 then
			-- tile moisture, plant delta, entire tile delta
			-- Water: 33% (-2 [-14])/min
			description = string.format(context.lstr.farmsoildrinker.soil_plant_tile, Round(tile_moisture, 1), Round(plant_delta, 1), Round(tile_delta, 1))

		elseif verbosity == 4 then
			-- tile moisture, plant delta, entire tile delta, world delta w/ net
			-- Water: 33% (-2 [-14 + 3 = 11])/min
			description = alt_description
			alt_description = nil
		end
	end

	return {
		name = "farmsoildrinker_moisture",
		priority = 1,
		description = description,
		alt_description = alt_description
	}
end

local function DescribeNutrients(self, context, definition)
	local description = nil
	local verbosity = context.config["soil_nutrients"]

	-- soil_nutrients add config hat whatever check insight comments
	if verbosity == 0 or context.config["soil_nutrients_needs_hat"] == "none" then
		return
	end

	if context.config["soil_nutrients_needs_hat"] == "hatonly" then
		--if context.player.components.inventory:Has("nutrientsgoggleshat", 1) then
		if not (
			context.player.components.inventory:HasItemWithTag("nutrientsvision", 1) or 
			context.player.components.inventory:EquipHasTag("nutrientsvision")
			) 
		then
			return
		end
	end

	local x, y, z = self.inst.Transform:GetWorldPosition() 
	local tile_nutrients = farmingHelper.GetTileNutrientsAtPoint(x, y, z)
	local net_nutrients = farmingHelper.GetPlantNutrientModifier(definition)
	local tile_nutrient_delta = farmingHelper.GetTileNutrientDelta(x, y, z)
	
	local alt_description = string.format(context.lstr.farmsoildrinker_nutrients.soil_plant_tile,
		tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure,
		net_nutrients.formula, net_nutrients.compost, net_nutrients.manure,
		tile_nutrient_delta.formula, tile_nutrient_delta.compost, tile_nutrient_delta.manure
	)
	
	if verbosity == 1 then
		-- tile nutrients only
		-- Nutrients: [2, 4, 8]
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_only, 
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure
		)

	elseif verbosity == 2 then
		-- tile nutrients and plant delta
		-- Nutrients: [2, 4, 8] ([-1, +2, -3])
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_plant,
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure,
			net_nutrients.formula, net_nutrients.compost, net_nutrients.manure	
		)
	elseif verbosity == 3 then
		-- tile nutrients, plant delta, entire tile delta
		-- Nutrients: [2, 4, 8] ([-1, +2, -3] + [1, -2, 3])
		description = alt_description
		alt_description = nil
	end

	--[[
	if verbosity == 1 then
		-- tile nutrients only
		-- Nutrients: [2, 4, 8]
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_only, 
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure
		)

	elseif verbosity == 2 then
		-- tile nutrients and plant delta
		-- Nutrients: [2, 4, 8] ([-1, +2, -3])
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_plant,
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure,
			net_nutrients.formula, net_nutrients.compost, net_nutrients.manure	
		)
		--
	elseif verbosity == 3 then
		-- tile nutrients, plant delta, entire tile delta
		-- Nutrients: [2, 4, 8] ([-1, +2, -3] + [1, -2, 3])
		description = string.format(context.lstr.farmsoildrinker_nutrients.soil_plant_tile,
			tile_nutrients.formula, tile_nutrients.compost, tile_nutrients.manure,
			net_nutrients.formula, net_nutrients.compost, net_nutrients.manure,
			tile_nutrient_delta.formula, tile_nutrient_delta.compost, tile_nutrient_delta.manure
		)
	end
	--]]

	return {
		name = "farmsoildrinker_nutrients",
		priority = 1,
		description = description,
		alt_description = alt_description
	}
end

-- nutrient_consumption
-- local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS

local function Describe(self, context)
	if not farmingHelper.IsInitialized() then
		return { priority=0; description = "<color=#ff0000>Farming helper not initialized (farmsoildrinker).</color>"}
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