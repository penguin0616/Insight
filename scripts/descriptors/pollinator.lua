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

-- pollinator.lua
local function ProcessFlowers(flowers)
	local normal = {}
	local evil = {}

	for i,v in pairs(flowers) do
		if v.prefab == "flower_evil" then
			table.insert(evil, v)
		else
			table.insert(normal, v)
		end
	end

	return normal, evil
end

-- #764979 normal
-- #715147 evil

local function Describe(self, context)
	local description = nil

	local normal, evil = ProcessFlowers(self.flowers)
	local strs = {}

	if #normal > 0 then
		strs[#strs+1] = string.format("<color=SWEETENER>%s<sub>normal</sub></color>", #normal)
	end

	if #evil > 0 then
		strs[#strs+1] = string.format("<color=#764979>%s<sub>evil</sub></color>", #evil)
	end

	if #strs > 0 then
		description = string.format(context.lstr.pollination, table.concat(strs, " + "), self.collectcount) 
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}