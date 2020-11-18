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


-- armor.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil
	local durabilityValue = Round(self.condition, 0)

	-- orange red #FF5926
	-- crimson #DC143C
	--[[
	local prefix1 = (usingIcons and "<icon=armorwood> ") or "<color=HEALTH>Protection</color>: "
	local prefix2 = (usingIcons and "<icon=health> ") or "<color=FEATHER>Durability</color>: "
	local protection = string.format(prefix1 .. "%s%%", (self.absorb_percent and self.absorb_percent * 100) or "?")
	local durability = string.format(prefix2 .. "%s / %s", durabilityValue, Round(self.maxcondition, 0))
	--]]

	local protection = string.format(context.lstr.protection, (self.absorb_percent and self.absorb_percent * 100) or "?")
	local durability = string.format(context.lstr.durability, durabilityValue, Round(self.maxcondition, 0))

	description = CombineLines(protection, durability)

	return {
		priority = 1,
		description = description,
		durabilityValue = durabilityValue
	}
end



return {
	Describe = Describe
}