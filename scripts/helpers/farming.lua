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

-- This file is responsible for providing some common values where farming is concerned.
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local SOIL_RAIN_MOD = TUNING.SOIL_RAIN_MOD
local MIN_DRYING_TEMP = TUNING.SOIL_MIN_DRYING_TEMP
local MAX_DRYING_TEMP = TUNING.SOIL_MAX_DRYING_TEMP
local SOIL_MIN_TEMP_DRY_RATE = TUNING.SOIL_MIN_TEMP_DRY_RATE
local SOIL_MAX_TEMP_DRY_RATE = TUNING.SOIL_MAX_TEMP_DRY_RATE
local MAX_SOIL_MOISTURE = TUNING.SOIL_MAX_MOISTURE_VALUE

local FERTILIZER_DEFS = (IsDST() and CurrentRelease.GreaterOrEqualTo("R14_FARMING_REAPWHATYOUSOW") and require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS) or {}

local farming_manager = nil
local growers = {}
local lib = nil

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local GetTileDataAtPoint = nil --[[
	belowsoiltile	7	
	soil_drinkers	table: 4D9E3B20	
	nutrients_overlay	100038 - nutrients_overlay	
	nutrients	2236454	
	soilmoisture	90.558837890625	
]]

--- Check if we are initialized or not
local function IsInitialized()
	return farming_manager ~= nil
end

--- Hook
local function Initialize(self)
	farming_manager = self
	GetTileDataAtPoint = util.getupvalue(self.IsSoilMoistAtPoint, "GetTileDataAtPoint")
	lib.GetTileDataAtPoint = GetTileDataAtPoint
	mprint("Farming_Manager has been hooked")
end

local function RegisterOldGrower(grower)
	if not grower.inst:IsValid() then
		return
	end

	if table.contains(growers, grower.inst) then
		return
	end

	table.insert(growers, grower.inst)
	
	grower.inst:ListenForEvent("onremove", function(inst)
		local index = table.reverselookup(growers, inst)
		if index then
			table.remove(growers, index)
		end
	end)
end

local function WorldHasOldGrowers()
	return #growers > 0
end

--- Gets tile moisture at point
local function GetTileMoistureAtPoint(x, y, z)
	return GetTileDataAtPoint(false, x, y, z).soilmoisture
end

--- Returns the current world moisture rate.
local function GetWorldMoistureDelta()
	local rain_rate = TheWorld.state.israining and TheWorld.state.precipitationrate or 0
	--local world_wetness = TheWorld.state.wetness
	local world_temp = TheWorld.state.temperature
	local world_rate = rain_rate > 0 and (rain_rate * SOIL_RAIN_MOD) or Remap(Clamp(world_temp, MIN_DRYING_TEMP, MAX_DRYING_TEMP), MIN_DRYING_TEMP, MAX_DRYING_TEMP, SOIL_MIN_TEMP_DRY_RATE, SOIL_MAX_TEMP_DRY_RATE)

	return world_rate
end

--- Returns the total rate of all the soil drinkers.
local function GetTileMoistureDelta(x, y, z)
	local tile_data = GetTileDataAtPoint(false, x, y, z)
	
	local obj_rate = 0
	if tile_data.soil_drinkers ~= nil then
		for obj, _ in pairs(tile_data.soil_drinkers) do
			obj_rate = obj_rate + obj.components.farmsoildrinker:GetMoistureRate()
		end
	end

	return obj_rate
end

--- Gets fertilizer nutrient value for prefab
local function GetNutrientValue(prefab)
	for _prefab, data in pairs(FERTILIZER_DEFS) do
		if _prefab == prefab then
			return data.nutrients
		end
	end
end

local function GetTileNutrientsAtPoint(x, y, z)
	--local tile_data = GetTileDataAtPoint(false, x, y, z);
	-- farming_manager:GetTileNutrients

	local x, y = TheWorld.Map:GetTileCoordsAtPoint(x, y, z)
	local nutrients = {TheWorld.components.farming_manager:GetTileNutrients(x, y)}

	-- NUTRIENT_1 = "Growth Formula",
    -- NUTRIENT_2 = "Compost",
	-- NUTRIENT_3 = "Manure",
	
	--[[
		local nutrientlevels = inst.nutrientlevels:value()
        local nutrients = {
            bit.band(nutrientlevels, 7),
            bit.band(bit.rshift(nutrientlevels, 3), 7),
            bit.band(bit.rshift(nutrientlevels, 6), 7),
        }
        for num, nutrient in ipairs(nutrients) do
            local nutrient_name = nutrient_prefix..tostring(num)
	]]

	return {
		formula = nutrients[1],
		compost = nutrients[2],
		manure = nutrients[3]
	}
end

lib = {
	IsInitialized = IsInitialized,
	Initialize = Initialize,
	RegisterOldGrower = RegisterOldGrower,
	WorldHasOldGrowers = WorldHasOldGrowers,

	GetTileDataAtPoint = GetTileDataAtPoint,
	GetTileMoistureAtPoint = GetTileMoistureAtPoint,
	GetWorldMoistureDelta = GetWorldMoistureDelta,
	GetTileMoistureDelta = GetTileMoistureDelta,

	GetNutrientValue = GetNutrientValue,
	GetTileNutrientsAtPoint = GetTileNutrientsAtPoint,
}

return setmetatable({}, {__index = lib})