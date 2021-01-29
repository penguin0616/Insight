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

-- domesticatable.lua
local function GetHighestTendency(self)
	if self.inst.tendency then
		return self.inst.tendency:sub(1,1):upper() .. self.inst.tendency:sub(2):lower()
	else
		return
	end

	local a, b = nil, 0
	for tendency, score in pairs(self.tendencies) do
		if score > b then
			a, b = tendency, score
		end 
	end

	if a then
		local name = TENDENCY[a] or (a .. "*")
		name = name:sub(1,1):upper() .. name:sub(2):lower()
		return name
	end
end

local function Describe(self, context)
	local description = nil

	if context.config["domestication_information"] then
		local domestication = Round(self.domestication * 100, 1)
		local obedience = Round(self.obedience * 100, 1)
		local tendency = GetHighestTendency(self)

		local x1 = domestication > 0 and string.format(context.lstr.domesticable.domestication, domestication) or nil
		local x2 = obedience > 0 and string.format(context.lstr.domesticable.obedience, obedience) or nil
		local x3 = tendency and string.format(context.lstr.domesticable.tendency, tendency) or nil

		description = CombineLines(x1, x2, x3)
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}