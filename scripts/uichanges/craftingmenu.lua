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

-- This is for the new crafting menu.
local module = {}

local CraftingMenuWidget = (IS_DST and CurrentRelease.GreaterOrEqualTo("R20_QOL_CRAFTING4LIFE") and require("widgets/redux/craftingmenu_widget")) or nil
local CraftingMenuHUD = (IS_DST and CurrentRelease.GreaterOrEqualTo("R20_QOL_CRAFTING4LIFE") and require("widgets/redux/craftingmenu_hud")) or nil

--[==[
local function CMW_OnGainFocus(self, ...)
	mprint'ongainfocus'
	if self.data and self.data.recipe and self.data.recipe.product then
		SetHighlightIngredientFocus({ prefab=self.data.recipe.product })
	end
	--[[
table.foreach(self.data.recipe, mprint)
[00:27:32]: [workshop-2189004162 (Insight)]:	nounlock	false	
[00:27:32]: [workshop-2189004162 (Insight)]:	atlas	images/inventoryimages2.xml	
[00:27:32]: [workshop-2189004162 (Insight)]:	build_distance	1	
[00:27:32]: [workshop-2189004162 (Insight)]:	is_deconstruction_recipe	false	
[00:27:32]: [workshop-2189004162 (Insight)]:	character_ingredients	table: 000000010A6B9610	
[00:27:32]: [workshop-2189004162 (Insight)]:	rpc_id	107	
[00:27:32]: [workshop-2189004162 (Insight)]:	min_spacing	3.2	
[00:27:32]: [workshop-2189004162 (Insight)]:	product	pickaxe	
[00:27:32]: [workshop-2189004162 (Insight)]:	build_mode	1	
[00:27:32]: [workshop-2189004162 (Insight)]:	image	pickaxe.tex	
[00:27:32]: [workshop-2189004162 (Insight)]:	name	pickaxe	
[00:27:32]: [workshop-2189004162 (Insight)]:	sortkey	107	
[00:27:32]: [workshop-2189004162 (Insight)]:	numtogive	1	
[00:27:32]: [workshop-2189004162 (Insight)]:	level	table: 00000000599BE800	
[00:27:32]: [workshop-2189004162 (Insight)]:	ingredients	table: 000000010A6B8990	
[00:27:32]: [workshop-2189004162 (Insight)]:	tech_ingredients	table: 000000010A6B92A0	
	]]
end
--]==]

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Menu Item Widgets ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--- This is what triggers when one of the item widgets is clicked on.
local function OnCellRootClick(self, widget)
	--dprint("oncellrootclick")
	if not localPlayer then return end;
	-- yikes.
	--local is_current = widget.data == localPlayer.HUD.controls.craftingmenu.craftingmenu.details_root.data
	--local details_root_data = table.getfield(localPlayer, "HUD.controls.craftingmenu.craftingmenu.details_root.data")
	local details_root_data = localPlayer.HUD.controls.craftingmenu:GetCurrentRecipeState()
	if not details_root_data then return end

	--[[
	local is_current = widget.data == details_root_data
	if is_current then
		-- assume we've already clicked this
		return
	end
	--]]

	if widget.data and widget.data.recipe and widget.data.recipe.product then
		SetHighlightIngredientFocus(self, { prefab = widget.data.recipe.product })
	end
end

--- These two focus functions are for hovering the item widgets. I stopped using them for fear of lag,
-- but with deferred highlighting updating, this might be viable now.
local function ItemWidgetOnGainFocus(self, ...)
	dprint('ongainfocus', self.data.recipe.product)
	if self.data and self.data.recipe and self.data.recipe.product then
		SetHighlightIngredientFocus(self, { prefab = self.data.recipe.product })
	end
end

local function ItemWidgetOnLoseFocus(self, ...)
	dprint('onlosefocus', self.data.recipe.product)
	SetHighlightIngredientFocus(self, nil)
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CraftingMenuWidget ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function HookCraftingMenuWidget()
	local oldTEMPLATES = util.getupvalue(CraftingMenuWidget.MakeRecipeList, "TEMPLATES")

	local fakeTemplates = setmetatable({
		ScrollingGrid = function(...)
			local items, opts = ...
			
			local oldItemCtorFn = opts.item_ctor_fn
			local oldApplyFn = opts.apply_fn

			opts.item_ctor_fn = function(...)
				--mprint("ReplacementCtor")
				local widget = oldItemCtorFn(...)
				--widget.OnGainFocus = ItemWidgetOnGainFocus;
				--widget.OnLoseFocus = ItemWidgetOnLoseFocus;
				
				
				local oldOnClick = widget.cell_root.onclick
				widget.cell_root:SetOnClick(function(...) -- normally no args
					OnCellRootClick(widget.cell_root, widget)
					if oldOnClick then -- should exist, but just in case...
						return oldOnClick(...)
					end
				end)
				

				return widget;
			end

			return oldTEMPLATES.ScrollingGrid(...)
		end,
	}, {
		__index = oldTEMPLATES;
		__newindex = oldTEMPLATES;
	})

	util.replaceupvalue(CraftingMenuWidget.MakeRecipeList, "TEMPLATES", fakeTemplates);
end
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CraftingMenuHUD ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function CraftingMenuHUD_Open(self, ...)
	if not localPlayer then return end
	local details_root_data = localPlayer.HUD.controls.craftingmenu:GetCurrentRecipeState()
	if details_root_data then
		if details_root_data and details_root_data.recipe and details_root_data.recipe.product then
			SetHighlightIngredientFocus(self, { prefab = details_root_data.recipe.product })
		end
	end
	return module.oldCraftingMenuHUD_Open(self, ...)
end

local function CraftingMenuHUD_Close(self, ...)
	SetHighlightIngredientFocus(self, nil)
	return module.oldCraftingMenuHUD_Close(self, ...)
end

local function HookCraftingMenuHUD()
	module.oldCraftingMenuHUD_Open = CraftingMenuHUD.Open
	module.oldCraftingMenuHUD_Close = CraftingMenuHUD.Close
 
	CraftingMenuHUD.Open = CraftingMenuHUD_Open
	CraftingMenuHUD.Close = CraftingMenuHUD_Close
end


module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.USING_NEW_CRAFTING_MENU = CraftingMenuWidget ~= nil and CraftingMenuHUD ~= nil

	if module.USING_NEW_CRAFTING_MENU then
		HookCraftingMenuWidget()
		HookCraftingMenuHUD()
	end

	module.initialized = true
end

return module