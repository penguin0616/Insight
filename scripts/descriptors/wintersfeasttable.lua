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

-- wintersfeasttable.lua
local function Describe(self, context)
	local description = nil

	local shelf = self.inst.components.shelf
	local item_on_shelf = shelf and shelf.itemonshelf 

	if item_on_shelf and item_on_shelf.components.finiteuses then
		context.finiteuses_forced = true
		description = Insight.descriptors.finiteuses.Describe(item_on_shelf.components.finiteuses, context).description
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}