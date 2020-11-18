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

-- domesticatable.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if context.config["domestication_information"] then
		local domestication = Round(self.domestication * 100, 1)
		local obedience = Round(self.obedience * 100, 1)

		local x1 = domestication > 0 and string.format(context.lstr.domestication, domestication) or nil
		local x2 = obedience > 0 and string.format(context.lstr.obedience, obedience) or nil

		description = CombineLines(x1, x2) 
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}