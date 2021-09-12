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

-- propagator.lua
local function Describe(self, context)
	local alt_description = nil

	--alt_description = string.format("range: %.2f, output: %.2f, heat: %.2f / %.2f, flashpoint: %.2f", self.propagaterange, self.heatoutput, self.currentheat, self.max_heat_this_update, self.flashpoint)
	--alt_description = string.format("range: %.2f, output: %.2f, heat: %.2f / %.2f", self.propagaterange, self.heatoutput, self.currentheat, self.flashpoint)


	return {
		priority = 0,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}