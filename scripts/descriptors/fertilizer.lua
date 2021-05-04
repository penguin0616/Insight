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

-- fertilizer.lua
local Is_DS = IsDS()
local farmingHelper = import("helpers/farming")

local function Describe(self, context)
	local description
	local growth_value_string
	local nutrient_value_string

	local formula_value_string
	local compost_value_string
	local health_value_string

	if Is_DS or farmingHelper.WorldHasOldGrowers() then
		growth_value_string = string.format(context.lstr.fertilizer.growth_value, self.fertilizervalue)
	end

	if self.inst.GetFertilizerKey then
		local nutrient_value = farmingHelper.GetNutrientValue(self.inst:GetFertilizerKey())
		if nutrient_value then
			local missing = nil --"?"
			nutrient_value_string = string.format(context.lstr.fertilizer.nutrient_value, nutrient_value[1] or missing, nutrient_value[2] or missing, nutrient_value[3] or missing)
		else
			nutrient_value_string = "Does not have nutrients?"
		end
	end

	if not Is_DS and context.player:HasTag("self_fertilizable") then
		local formula, compost, manure = self.nutrients[TUNING.FORMULA_NUTRIENTS_INDEX], self.nutrients[TUNING.COMPOST_NUTRIENTS_INDEX], self.nutrients[TUNING.MANURE_NUTRIENTS_INDEX]

		if formula > 0 then
			-- bloomness
			formula_value_string = string.format(context.lstr.fertilizer.wormwood.formula_growth, formula)
		end

		if compost > 0 then
			-- healing over time
			local healing = TUNING.WORMWOOD_COMPOST_HEAL_VALUES[math.ceil(compost / 8)] or TUNING.WORMWOOD_COMPOST_HEAL_VALUES[1]
			local duration = healing * (TUNING.WORMWOOD_COMPOST_HEALOVERTIME_TICK / TUNING.WORMWOOD_COMPOST_HEALOVERTIME_HEALTH)
			compost_value_string = GetDescription(context.lstr.fertilizer.wormwood.compost_heal, healing, duration)
		end

		if manure > 0 then
			-- immediate heal
			local health_amount = TUNING.WORMWOOD_MANURE_HEAL_VALUES[math.ceil(manure / 8)] or TUNING.WORMWOOD_MANURE_HEAL_VALUES[1]
			health_value_string = string.format(context.lstr.heal, health_amount)
		end
	end

	description = CombineLines(growth_value_string, nutrient_value_string, formula_value_string, compost_value_string, health_value_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}