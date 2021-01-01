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

-- beard.lua
local icon = ResolvePrefabToImageTable("razor")

local function GetNextCallback(self, start)
	local index = nil

	for i,v in pairs(self.callbacks) do
		if i > start then
			--index = math.min(i, index or i)
			if index == nil or i < index then
				index = i
			end
		end
	end

	return index
end

local function Describe(self, context)
	local description = nil

	if not self.isgrowing then
		return
	end

	local next_growth

	if self.callbacks[self.daysgrowth] then -- we are on a callback, check next growth because beard doesn't actually look for the next callback until the day is over
		next_growth = GetNextCallback(self, self.daysgrowth + 1)
	else
		next_growth = GetNextCallback(self, self.daysgrowth)
	end

	if next_growth then
		description = string.format(context.lstr.beard, next_growth -  self.daysgrowth)
	end

	return {
		priority = 0,
		description = description,
		icon = icon,
		playerly = true
	}
end

return {
	Describe = Describe
}