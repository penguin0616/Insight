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

-- rainometer.lua [Prefab]
local world_type = GetWorldType()

local function Describe(inst, context)
	local description = nil

	local moistureManager = world_type >= 1 and GetWorld().components.moisturemanager or nil
	local seasonManager = world_type >= 0 and GetSeasonManager() or nil
	
	-- Wetness
	local wetness = nil
	local wetnessString = nil

	if world_type == -1 then
		wetness = TheWorld.state.wetness
	elseif world_type >= 1 then
		wetness = moistureManager and moistureManager:GetWorldMoisture() or nil
	end

	if wetness then
		wetnessString = string.format(context.lstr.global_wetness, Round(wetness, 1))
	end
	
	-- Precipitation rate
	local precipitationRate = nil
	local precipitationRateString = nil

	if world_type == -1 then
		precipitationRate = TheWorld.state.precipitationrate
	elseif world_type >= 0 then
		precipitationRate = seasonManager and seasonManager.precip_rate or nil
	end

	if precipitationRate and precipitationRate > 0 then
		precipitationRateString = string.format(context.lstr.precipitation_rate, Round(precipitationRate, 2))
	end

	-- Frog rain
	local frogRainChance = nil
	local frogRainChanceString = nil
	if world_type == -1 then
		local frogRainCmp = TheWorld.components.frograin
		if frogRainCmp and TheWorld.state.isspring then
			if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
				frogRainChance = Round(TUNING.FROG_RAIN_CHANCE * 100, 1)
			else
				frogRainChance = Round(frogRainCmp:OnSave().chance * 100, 1)
			end
			--[[
			if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
				frogRainChance = string.format(context.lstr.frog_rain_chance, Round(TUNING.FROG_RAIN_CHANCE * 100, 1))
			else
				frogRainChance = string.format(context.lstr.frog_rain_chance, Round(frogRainCmp:OnSave().chance * 100, 1))
			end
			--]]
		end
	else
		local frogRainCmp = GetWorld().components.frograin
		-- Meh.
	end

	if frogRainChance then
		frogRainChanceString = string.format(context.lstr.frog_rain_chance, frogRainChance)
	end

	description = CombineLines(wetnessString, precipitationRateString, frogRainChanceString)
	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}