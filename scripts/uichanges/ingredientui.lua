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

-- This is for the IngredientUI used in both crafting menus!
local module = {}
local IngredientUI = require("widgets/ingredientui")

local function IngredientUI_OnGainFocus(self, ...)
	--dprint("ingredientui OnGainFocus", self.ing and self.ing.texture and string.match(self.ing.texture, '[^/]+$'):gsub('%.tex$', ''))
	--highlighting.SetActiveIngredientUI(self)
	SetHighlightIngredientFocus(self, self)
	

	if module.oldIngredientUI_OnGainFocus then
		return module.oldIngredientUI_OnGainFocus(self, ...)
	end
end

local function IngredientUI_OnLoseFocus(self, ...)
	--dprint("ingredientui OnLoseFocus", self.ing and self.ing.texture and string.match(self.ing.texture, '[^/]+$'):gsub('%.tex$', ''))
	--highlighting.SetActiveIngredientUI(nil)
	SetHighlightIngredientFocus(self, nil)

	if module.oldIngredientUI_OnLoseFocus then
		return module.oldIngredientUI_OnLoseFocus(self, ...)
	end
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.oldIngredientUI_OnGainFocus = IngredientUI.OnGainFocus
	module.oldIngredientUI_OnLoseFocus = IngredientUI.OnLoseFocus

	IngredientUI.OnGainFocus = IngredientUI_OnGainFocus
	IngredientUI.OnLoseFocus = IngredientUI_OnLoseFocus

	module.initialized = true
end

return module