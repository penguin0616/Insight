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

-- ghostlybond.lua
local LEVEL_COLORS = setmetatable({
	[1] = "#E9C5C4",
	[2] = "#CF7D7B",
	[3] = "#BD696B"
}, {
	__index = function(self, index)
		rawset(self, index, "#ffffff")
		return rawget(self, index)
	end
})

local function AbigailDescribe(self, context)
	local description = nil

	if type(self.bondlevel) ~= "number" or type(self.maxbondlevel) ~= "number" then
		-- People once again breaking things.
		return
	end
	
	local levelup_time = self.bondleveltimer and context.time:SimpleProcess(self.bondlevelmaxtime - self.bondleveltimer)

	if context.usingIcons then 
		description = string.format(context.lstr.ghostlybond.abigail, 
			ApplyColor(self.bondlevel, LEVEL_COLORS[self.bondlevel]), 
			ApplyColor(self.maxbondlevel, LEVEL_COLORS[self.maxbondlevel])
		)

		if levelup_time then
			description = description .. string.format(context.lstr.ghostlybond.levelup, levelup_time)
		end
	else
		description = string.format(context.lstr.lang.ghostlybond.abigail, 
			LEVEL_COLORS[self.bondlevel],
			ApplyColor(self.bondlevel, LEVEL_COLORS[self.bondlevel]), 
			ApplyColor(self.maxbondlevel, LEVEL_COLORS[self.maxbondlevel])
		)

		if levelup_time then
			description = description .. string.format(context.lstr.lang.ghostlybond.levelup, levelup_time)
		end
	end

	return {
		name = "ghostlybond_abigail",
		priority = 1,
		description = description
	}
end

local function FlowerDescribe(self, context)
	local description = nil
	local levelup_time = self.bondleveltimer and context.time:SimpleProcess(self.bondlevelmaxtime - self.bondleveltimer)

	if type(self.bondlevel) ~= "number" or type(self.maxbondlevel) ~= "number" then
		-- People once again breaking things.
		return
	end

	if context.usingIcons then 
		description = string.format(context.lstr.ghostlybond.flower, 
			ApplyColor(self.bondlevel, LEVEL_COLORS[self.bondlevel]), 
			ApplyColor(self.maxbondlevel, LEVEL_COLORS[self.maxbondlevel])
		)

		if levelup_time then
			description = description .. string.format(context.lstr.ghostlybond.levelup, levelup_time)
		end
	else
		description = string.format(context.lstr.lang.ghostlybond.flower, 
			LEVEL_COLORS[self.bondlevel],
			ApplyColor(self.bondlevel, LEVEL_COLORS[self.bondlevel]), 
			ApplyColor(self.maxbondlevel, LEVEL_COLORS[self.maxbondlevel])
		)

		if levelup_time then
			description = description .. string.format(context.lstr.lang.ghostlybond.levelup, levelup_time)
		end
	end

	return {
		name = "ghostlybond_flower",
		priority = 1,
		description = description
	}
end



return {
	Describe = nil,
	AbigailDescribe = AbigailDescribe,
	FlowerDescribe = FlowerDescribe
}