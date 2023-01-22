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

-- This is for the CraftSlot in the old crafting menu.
local module = {}
local CraftSlot = require("widgets/craftslot")


local function CraftSlot_OnGainFocus(self, ...)
	--highlighting.SetActiveIngredientUI({ prefab=self.recipename })
	SetHighlightIngredientFocus(self, { prefab=self.recipename })

	if module.oldCraftSlot_OnGainFocus then
		return module.oldCraftSlot_OnGainFocus(self, ...)
	end
end

local function CraftSlot_OnLoseFocus(self, ...)
	SetHighlightIngredientFocus(self, nil)
	
	if module.oldCraftSlot_OnLoseFocus then
		return module.oldCraftSlot_OnLoseFocus(self, ...)
	end
end


module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.oldCraftSlot_OnGainFocus = CraftSlot.OnGainFocus
	module.oldCraftSlot_OnLoseFocus = CraftSlot.OnLoseFocus

	CraftSlot.OnGainFocus = CraftSlot_OnGainFocus
	CraftSlot.OnLoseFocus = CraftSlot_OnLoseFocus

	module.initialized = true
end

return module