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

-- soul.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if context.player.components.souleater and inst.prefab == "wortox_soul" then
		local edible_description
		local descriptor = Insight.descriptors.edible
		if descriptor then
			local stats = {
				fixed = true,
				hunger = TUNING.CALORIES_MEDSMALL,
				sanity = -TUNING.SANITY_TINY,
				health = 0,
			}
			context.stats = stats
			edible_description = descriptor.Describe(self, context).description
		end

		description = CombineLines(edible_description, context.lstr.wortox_soul_heal)
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}