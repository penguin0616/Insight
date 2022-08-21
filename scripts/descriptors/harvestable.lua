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

-- harvestable.lua
local COLORS = setmetatable({
	honey = Insight.COLORS.SWEETENER,
	red_cap = "#A64E47",
	green_cap = "#446B4A",
	blue_cap = "#719BA5",
}, {
	__index = function(self, index)
		rawset(self, index, "#ffffff")
		return rawget(self, index)
	end
})

local function Describe(self, context)
	if not context.config["display_harvestable"] then
		return
	end
	
	local description = nil

	if not self.product then
		return
	end

	if context.usingIcons and PrefabHasIcon(self.product) then
		description = string.format(context.lstr.harvestable.product, self.product, self.produce, self.maxproduce)
	else
		local name = self.product--GetPrefabNameOrElse(self.product, "\"%s\"")
		name = string.format("<color=%s><prefab=%s></color>", COLORS[self.product], tostring(name)) -- workshop-356435289 has the product as a table. not going to bother right now.

		description = string.format(context.lstr.lang.harvestable.product, name, self.produce, self.maxproduce)

		if self.targettime then
			description = CombineLines(description, string.format(context.lstr.harvestable.grow, context.time:SimpleProcess(self.targettime - GetTime())))
		end
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}