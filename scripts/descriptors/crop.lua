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

-- crop.lua
local function DS_GetGrowthRate(crop)
	local season = GetSeasonManager()
	local world_type = GetWorldType()
	local weather_rate = 1
	
	-- withered is nil, false, or true -> only true matters, so no world type check needed
	if crop.withered or season:GetTemperature() < TUNING.MIN_CROP_GROW_TEMP then
		weather_rate = 0
	else
		-- base game only
		local a = season:GetTemperature()
		local b = TUNING.CROP_BONUS_TEMP

		if not a or not b then
			--ReportToCustomLog("crop.lua ->", world_type, a, b)
		end
		-- attempt to compare nil with number: x < 5, 5 > x
		-- attempt to compare number with nil: 5 < x, x > 5
		-- < follows correct pattern, > flips

        if world_type == 0 and season:GetTemperature() > TUNING.CROP_BONUS_TEMP then
		  	weather_rate = weather_rate + TUNING.CROP_HEAT_BONUS
        end

        if season:IsRaining() then
			weather_rate = weather_rate + TUNING.CROP_RAIN_BONUS*season:GetPrecipitationRate()
		elseif world_type ~= 0 and ( season:IsSpring() or ( world_type >= 2 and season:IsGreenSeason() ) ) then -- rog, sw/ham
			-- 5/18/2020 Attempt to call method IsGreenSeason()
            weather_rate = weather_rate + (TUNING.SPRING_GROWTH_MODIFIER/3)
        end
    end

	return weather_rate
end

local function DST_GetGrowthRate(crop)
	local temp_rate =
        (TheWorld.state.temperature < TUNING.MIN_CROP_GROW_TEMP and 0) or
        (TheWorld.state.israining and 1 + TUNING.CROP_RAIN_BONUS * TheWorld.state.precipitationrate) or
        (TheWorld.state.isspring and 1 + TUNING.SPRING_GROWTH_MODIFIER / 3) or
		1
		
	return temp_rate
end

local function GetGrowthRate(crop)
	if IsDS() then
		return DS_GetGrowthRate(crop)
	else
		return DST_GetGrowthRate(crop)
	end
end




local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if self.product_prefab and self.task and self.task:NextTime() then -- nexttime isn't nil if task is running
		local name = STRINGS.NAMES[string.upper(self.product_prefab)] or self.product_prefab
		
		local nextUpdateIn = self.task:NextTime() - GetTime() -- used to give the illusion of growth, occurs every 2s in reality
		local rate = GetGrowthRate(self) * self.rate -- 2 very different things...
		local remaining_time = nil

		if rate > 0 then
			remaining_time = (1 - self.growthpercent) / rate + nextUpdateIn
			if remaining_time < 0 then
				--remaining_time = "negative time: " .. remaining_time
			else
				remaining_time = TimeToText(time.new(remaining_time, context))
			end
		else
			remaining_time = context.lstr.crop_paused
		end

		--[[
		local tex = self.product_prefab .. ".tex"
		if usingIcons and GetAtlasForTex(tex) then
			if not LookupIcon(self.product_prefab) then
				-- https://dontstarve.fandom.com/wiki/Farming#Farms
				-- .xml has them listed by prefab
				
				DefineIcon(self.product_prefab, tex, GetAtlasForTex(tex))
			end
			description = string.format(context.lstr.growth, self.product_prefab, remaining_time)
		else
			description = string.format(context.lstr.growth, name, remaining_time)
		end
		--]]

		if context.usingIcons and PrefabHasIcon(self.product_prefab) then
			description = string.format(context.lstr.growth, self.product_prefab, remaining_time)
		else
			description = string.format(context.lstr.lang.growth, name, remaining_time)
		end

		-- dst version: CROP_NAME: xx%
		
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}