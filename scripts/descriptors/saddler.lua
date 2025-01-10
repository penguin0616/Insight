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

-- saddler.lua
local function Describe(self, context)
	local description = nil

	local damage_string
	if self.bonusdamage and self.bonusdamage ~= 0 then
		damage_string = string.format(context.lstr.saddler.bonus_damage, self.bonusdamage)
	end

	local absorption_string
	if self.absorbpercent and self.absorbpercent ~= 0 then
		absorption_string = string.format(context.lstr.saddler.absorption, self.absorbpercent * 100)
	end

	local speed_string
	if self.speedmult and self.speedmult ~= 1 then
		speed_string = string.format(context.lstr.saddler.bonus_speed, Round((self.speedmult - 1) * 100, 0))
	end

	description = CombineLines(damage_string, absorption_string, speed_string)

	return {
		priority = 11, -- Just want it higher than finiteuses.
		description = description
	}
end



return {
	Describe = Describe
}