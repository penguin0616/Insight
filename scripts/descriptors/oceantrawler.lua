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

-- oceantrawler.lua
local function Describe(self, context)
	if self.inst.components.container then
		local things = Insight.descriptors.container.DescribeItemAndPerishable(self.inst.components.container, context)
		if things then
			for i = 1, #things do
				things[i].name = "oceantrawler_" .. i
			end
			return unpack(things)
		end
	end
end

return {
	Describe = Describe
}