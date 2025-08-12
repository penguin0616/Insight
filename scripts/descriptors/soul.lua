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

-- soul.lua
local function CalculateSoulNutrition(wortox)
	-- prefabs/wortox.lua -> OnEatSoul
	local hungervalue = TUNING.CALORIES_MED
	local sanityvalue = -TUNING.SANITY_TINY
	local healthvalue = 0

	if wortox.wortox_inclination == "nice" then
		sanityvalue = -TUNING.SANITY_TINY * 2
	elseif wortox.wortox_inclination == "naughty" then
		sanityvalue = 0
	end

	return {
		hungervalue = hungervalue,
		sanityvalue = sanityvalue,
		healthvalue = healthvalue
	}
end

local function Describe(self, context)
	local description = nil

	if not context.player then
		return
	end

	if self.inst.prefab ~= "wortox_soul" then
		return
	end

	-- Range data
	local soul_heal_range = TUNING.WORTOX_SOULHEAL_RANGE
	local skilltreeupdater = context.player.components.skilltreeupdater
	if skilltreeupdater then
		if skilltreeupdater:IsActivated("wortox_soulprotector_1") then
			soul_heal_range = soul_heal_range + TUNING.SKILLS.WORTOX.WORTOX_SOULPROTECTOR_1_RANGE
		end

		if skilltreeupdater:IsActivated("wortox_soulprotector_2") then
			soul_heal_range = soul_heal_range + TUNING.SKILLS.WORTOX.WORTOX_SOULPROTECTOR_2_RANGE
		end
	end

	-- Edible data
	local edible_data = nil
	if context.player.components.souleater then
		local descriptor = Insight.descriptors.edible
		if descriptor then
			local stats = CalculateSoulNutrition(context.player)
			edible_data = descriptor.DescribeFoodStats(stats, context)
		end
	end

	-- Healing data
	local heal_string = string.format(context.lstr.wortox_soul_heal, TUNING.WORTOX_SOULHEAL_MINIMUM_HEAL, TUNING.HEALING_MED)
	local heal_range = string.format(context.lstr.wortox_soul_heal_range, soul_heal_range / WALL_STUDS_PER_TILE)

	description = CombineLines(heal_string, heal_range)

	return 
		{
			name = "soul",
			priority = 0,
			description = description,
			priority = 5
		}, 
		edible_data, 
		{
			name = "insight_ranged",
			priority = 0,
			description = nil,
			range = soul_heal_range,
			color = Insight.COLORS.HEALTH,
			attach_player = true
		}
end



return {
	Describe = Describe
}