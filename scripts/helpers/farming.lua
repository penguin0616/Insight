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

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local GetTileDataAtPoint = util.getupvalue(TheWorld.components.farming_manager.IsSoilMoistAtPoint, "GetTileDataAtPoint") --[[
	belowsoiltile	7	
	soil_drinkers	table: 4D9E3B20	
	nutrients_overlay	100038 - nutrients_overlay	
	nutrients	2236454	
	soilmoisture	90.558837890625	
]]

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

return {
	GetTileDataAtPoint = GetTileDataAtPoint,
	GetTileMoistureAtPoint = GetTileMoistureAtPoint,
	GetWorldMoistureDelta = GetWorldMoistureDelta,
	GetTileMoistureDelta = GetTileMoistureDelta,
}