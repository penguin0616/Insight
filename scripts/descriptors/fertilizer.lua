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

-- fertilizer.lua
local FERTILIZER_DEFS = {}

local reap_and_sow = IsDST() and CurrentRelease.GreaterOrEqualTo("R14_FARMING_REAPWHATYOUSOW")
if reap_and_sow then
	FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS
end

local function GetNutrientValue(prefab)
	for _prefab, data in pairs(FERTILIZER_DEFS) do
		if _prefab == prefab then
			return data.nutrients
		end
	end
end

local function Describe(self, context)
	local description = nil

	local growth_value_string = string.format(context.lstr.fertilizer.growth_value, self.fertilizervalue)
	local nutrient_value_string

	if reap_and_sow then
		local nutrient_value = GetNutrientValue(self.inst:GetFertilizerKey())

		if nutrient_value then
			local missing = nil --"?"
			nutrient_value_string = string.format(context.lstr.fertilizer.nutrient_value, nutrient_value[1] or missing, nutrient_value[2] or missing, nutrient_value[3] or missing)
		else
			nutrient_value_string = "Does not have nutrients?"
		end
	end

	description = CombineLines(growth_value_string, nutrient_value_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}