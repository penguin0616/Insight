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

-- mightygym.lua
local function Describe(self, context)
	local description = nil

	local weight = self.weight or self:CalcWeight() -- man this function is kind of scuffed. heck all of the inventory interactions in this component are.
	local weight_string = string.format(context.lstr.mightygym.weight, weight)

	if weight > 0 then
		local gains, perfect_gains = (weight >= 7 and TUNING.GYM_RATE.MED) or TUNING.GYM_RATE.LOW, (weight >= 7 and TUNING.GYM_RATE.HIGH) or TUNING.GYM_RATE.MED
		local gains_string = string.format(context.lstr.mightygym.mighty_gains, Round(gains, 1), Round(perfect_gains, 1))

		local hunger_level = (weight > 6 and "HIGH") or (weight > 3 and "MED") or "LOW" 
		local hunger_rate_modifier = TUNING.MIGHTYGYM_WORKOUT_HUNGER[hunger_level] or "?"
		local hunger_string = string.format(context.lstr.mightygym.hunger_drain, hunger_rate_modifier)

		description = CombineLines(weight_string, gains_string, hunger_string)
	else
		description = weight_string
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}