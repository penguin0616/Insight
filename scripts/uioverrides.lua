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

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
--==========================================================================================================================
--==========================================================================================================================
--======================================== Basic ===========================================================================
--==========================================================================================================================
--==========================================================================================================================
local CraftSlot = require("widgets/craftslot")
local IngredientUI = require("widgets/ingredientui")
local InsightButton = import("widgets/insightbutton")
local RichText = import("widgets/RichText")
local RichFollowText = import("widgets/richfollowtext")
local Text = require"widgets/text"

local CraftingMenuWidget = (IS_DST and CurrentRelease.GreaterOrEqualTo("R20_QOL_CRAFTING4LIFE") and require("widgets/redux/craftingmenu_widget")) or nil
local CraftingMenuHUD = (IS_DST and CurrentRelease.GreaterOrEqualTo("R20_QOL_CRAFTING4LIFE") and require("widgets/redux/craftingmenu_hud")) or nil

local SHIF_TASK = nil
local SHIF_DELAY = IS_DST and 0 or 0.09
local function SetHighlightIngredientFocus(arg)
	--mprint("SetHighlightIngredientFocus", arg)
	if SHIF_TASK then
		--mprint("\tCANCEL")
		SHIF_TASK:Cancel()
		SHIF_TASK = nil
	end

	if arg == nil then
		highlighting.SetActiveIngredientUI(nil)
		return
	end

	SHIF_TASK = TheGlobalInstance:DoTaskInTime(SHIF_DELAY, function()
		--mprint("\tCOMMIT", arg)
		highlighting.SetActiveIngredientUI(arg)
	end)
end

local function GetControllerSelectedInventoryItem(inventoryBar)
	local inv_item = inventoryBar:GetCursorItem()
	local active_item = inventoryBar.cursortile ~= nil and inventoryBar.cursortile.item or nil

	if inv_item ~= nil and inv_item.components.inventoryitem == nil and (inv_item.replica == nil or inv_item.replica.inventoryitem == nil) then
		inv_item = nil
	end
	if active_item ~= nil and active_item.components.inventoryitem == nil and (active_item.replica == nil or active_item.replica.inventoryitem == nil) then
		active_item = nil
	end

	return inv_item, active_item
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Post Constructs =================================================================
--==========================================================================================================================
--==========================================================================================================================
--[[
local yes = MiniMap
AddClassPostConstruct("widgets/mapwidget", function(mapWidget)
	mprint("a b c d")
	local w, h = TheSim:GetScreenSize()

	local txt = mapWidget:AddChild(import("widgets/RichText")(UIFONT, 20))
	
	txt:SetPosition(w * 0.5, h * 0.5)

	local oldOffset = mapWidget.Offset
	mapWidget.Offset = function(self, dx, dy)
		oldOffset(self, dx, dy)
		local a, b = txt:GetPosition():Get()
		local scale = self:GetScale()

		txt:SetPosition(a + dx, b + dy)
	end

	txt:SetString("hello there!")
end)
--]]

AddClassPostConstruct("widgets/controls", function(controls)
	local InsightButton = import("widgets/insightbutton")
	local InsightMenu = import("widgets/insightmenu")

	local menu = InsightMenu()
	menu:SetPosition(0, -400)
	menu:Hide()
	
	controls.insight_menu = controls.top_root:AddChild(menu)

	local mb = InsightButton()
	function mb:ResetPosition()
		self:SetPosition(-60 -64 -30, 40, 0) -- -60, 70, 0 is map button
	end
	mb:ResetPosition()
	mb:SetDraggable(true)
	mb.allowcontroller = IS_DS -- false
	mb:SetOnDragFinish(function(oldpos, newpos)
		TheSim:SetPersistentString("insightmenubutton", json.encode({ position=newpos }), false, function(...)
			dprint("InsightButton -> DragFinish -> Save -> Callback:", ...)
		end) -- i wonder if this will cause lag. ¯\_(ツ)_/¯
	end)

	TheSim:GetPersistentString("insightmenubutton", function(load_success, str)
		if not load_success then
			mprint("Failed to load old menu button position:", str)
			return
		end

		local safe, pos = pcall(function() return json.decode(str).position end)
		if not safe then
			mprint("Invalid JSON persistentstring in 'insightmenubutton'")
			mprint(str)
			return
		end
		
		dprint("Loaded old position:", pos.x, pos.y, pos.z)
		mb:SetPosition(pos.x, pos.y, pos.z)
	end)

	controls.insight_menu_toggle = controls.bottomright_root:AddChild(mb)

	mb:SetOnClick(function()
		if menu.shown then
			menu:Hide()
		else
			menu:Show()
		end
	end)

	AddLocalPlayerPostInit(function(insight, context)
		if not context.config["display_insight_menu_button"] then
			dprint("Display Insight Menu Button is disabled.")
			mb:Kill()
			return
		end
		insight:MaintainMenu(menu)
	end)

	--[[
	local Insight_Clock = import("widgets/insight_clock")

	local c = Insight_Clock()
	c:SetPosition(0, -400)
	controls.top_root:AddChild(c)
	--]]

	dprint("Insight Menu Button added")
end)

AddClassPostConstruct("widgets/text", function(text)
	text.InsightGetSize = widgetLib.text.GetSize
	text.InsightSetSize = widgetLib.text.SetSize
end)

--========================================================================================================================--
--= Item Tile ============================================================================================================--
--========================================================================================================================--
import("uichanges/itemtile").Initialize()

--==========================================================================================================================
--==========================================================================================================================
--======================================== Crafting Menu ===================================================================
--==========================================================================================================================
--==========================================================================================================================
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

function OnCellRootClick(self, widget)
	dprint("oncellrootclick")
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
		SetHighlightIngredientFocus({ prefab = widget.data.recipe.product })
	end
end

function ItemWidgetOnGainFocus(self, ...)
	dprint('ongainfocus', self.data.recipe.product)
	if self.data and self.data.recipe and self.data.recipe.product then
		SetHighlightIngredientFocus({ prefab = self.data.recipe.product })
	end
end

function ItemWidgetOnLoseFocus(self, ...)
	dprint('onlosefocus', self.data.recipe.product)
	SetHighlightIngredientFocus(nil)
end

if CraftingMenuWidget and CraftingMenuHUD then
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


	local oldOpen = CraftingMenuHUD.Open
	function CraftingMenuHUD:Open(...)
		if not localPlayer then return end
		local details_root_data = localPlayer.HUD.controls.craftingmenu:GetCurrentRecipeState()
		if details_root_data then
			if details_root_data and details_root_data.recipe and details_root_data.recipe.product then
				SetHighlightIngredientFocus({ prefab = details_root_data.recipe.product })
			end
		end
		return oldOpen(self, ...)
	end

	local oldClose = CraftingMenuHUD.Close
	function CraftingMenuHUD:Close(...)
		SetHighlightIngredientFocus(nil)
		return oldClose(self, ...)
	end
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Ingredient UI ===================================================================
--==========================================================================================================================
--==========================================================================================================================
if IngredientUI then

local oldIngredientUI_OnGainFocus = IngredientUI.OnGainFocus
local oldIngredientUI_OnLoseFocus = IngredientUI.OnLoseFocus

function IngredientUI:OnGainFocus(...)
	--highlighting.SetActiveIngredientUI(self)
	SetHighlightIngredientFocus(self)
	

	if oldIngredientUI_OnGainFocus then
		return oldIngredientUI_OnGainFocus(self, ...)
	end
end

function IngredientUI:OnLoseFocus(...)
	--highlighting.SetActiveIngredientUI(nil)
	SetHighlightIngredientFocus(nil)

	if oldIngredientUI_OnLoseFocus then
		return oldIngredientUI_OnLoseFocus(self, ...)
	end
end

end
--==========================================================================================================================
--==========================================================================================================================
--======================================== Craft Slot ======================================================================
--==========================================================================================================================
--==========================================================================================================================
-- Removed in new crafting menu
if CraftSlot then

local oldCraftSlot_OnGainFocus = CraftSlot.OnGainFocus
local oldCraftSlot_OnLoseFocus = CraftSlot.OnLoseFocus

function CraftSlot:OnGainFocus(...)
	--highlighting.SetActiveIngredientUI({ prefab=self.recipename })
	SetHighlightIngredientFocus({ prefab=self.recipename })

	if oldCraftSlot_OnGainFocus then
		return oldCraftSlot_OnGainFocus(self, ...)
	end
end

function CraftSlot:OnLoseFocus(...)
	SetHighlightIngredientFocus(nil)
	
	if oldCraftSlot_OnLoseFocus then
		return oldCraftSlot_OnLoseFocus(self, ...)
	end
end

end
--==========================================================================================================================
--==========================================================================================================================
--======================================== Stat Meter Inspection ===========================================================
--==========================================================================================================================
--==========================================================================================================================
local meterInspectModule = import("uichanges/meterinspect")
meterInspectModule.Initialize()

--==========================================================================================================================
--==========================================================================================================================
--======================================== Recipe Popup ====================================================================
--==========================================================================================================================
--==========================================================================================================================
import("uichanges/recipelookup").Initialize()

--==========================================================================================================================
--==========================================================================================================================
--======================================== WX-78 Charge Timer ==============================================================
--==========================================================================================================================
--==========================================================================================================================
local wxChargeDisplayModule = import("uichanges/wxchargedisplay")
if wxChargeDisplayModule.CanHookUpgradeModuleDisplay() then
	wxChargeDisplayModule.HookUpgradeModuleDisplay()
end



--==========================================================================================================================
--==========================================================================================================================
--======================================== Craft Pot =======================================================================
--==========================================================================================================================
--==========================================================================================================================
if KnownModIndex:IsModEnabled("workshop-727774324") or KnownModIndex:IsModEnabled("workshop-662872357") then -- Craft Pot (DST) https://steamcommunity.com/sharedfiles/filedetails/?id=727774324
	local FoodIngredientUI = require("widgets/foodingredientui")

	local oldOnGainFocus = FoodIngredientUI.OnGainFocus
	local oldOnLoseFocus = FoodIngredientUI.OnLoseFocus
	
	function FoodIngredientUI:OnGainFocus(...)
		local arg, typ = self:GetIngredient()
		-- arg = prefab || category
		-- typ = "name" || "tag"

		if typ == "name" then
			if type(arg) ~= "string" then
				mprint("foodingredientui hook error", arg, type(arg), typ)
			else
				SetHighlightIngredientFocus({ prefab=arg })
			end
		elseif typ == "tag" then
			if type(arg) ~= "string" then
				mprint("foodingredientui hook error", arg, type(arg), typ)
			else
				SetHighlightIngredientFocus({ prefab=nil, ingredient_tag=arg })
			end
		end
		
		if oldOnGainFocus then
			return oldOnGainFocus(self, ...)
		end
	end

	function FoodIngredientUI:OnLoseFocus(...)
		SetHighlightIngredientFocus(nil)

		if oldOnLoseFocus then
			return oldOnLoseFocus(self, ...)
		end
	end
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Hoverer =========================================================================
--==========================================================================================================================
--==========================================================================================================================
import("uichanges/hoverer").Initialize()

--==========================================================================================================================
--==========================================================================================================================
--======================================== InventoryBar ====================================================================
--==========================================================================================================================
--==========================================================================================================================

AddClassPostConstruct("widgets/inventorybar", function(inventoryBar)
	inventoryBar.insightText = inventoryBar.actionstring:AddChild(RichText())
	inventoryBar.insightText:SetSize(25)

	local oldActionStringTitle_SetString = inventoryBar.actionstringtitle.SetString
	inventoryBar.actionstringtitle.SetString = function(self, str)
		local inv_item, active_item = GetControllerSelectedInventoryItem(inventoryBar)

		if (inv_item or active_item) and GetModConfigData("DEBUG_SHOW_PREFAB", true) then
			str = str .. string.format(" [%s]", (inv_item or active_item).prefab)
        end
		
		oldActionStringTitle_SetString(self, str)
	end

	--[[
	local oldOnUpdate = inventoryBar.OnUpdate
	inventoryBar.OnUpdate = function(self, dt)
		oldOnUpdate(self, dt)
	end
	--]]

	local oldActionStringBody_SetString = inventoryBar.actionstringbody.SetString
	inventoryBar.actionstringbody.SetString = function(self, text)
		if not localPlayer then
			return
		end
		
		-- Get Current Item
		local inv_item, active_item = GetControllerSelectedInventoryItem(inventoryBar)
		local selected = inv_item or active_item

		-- Fetch information
		local entityInformation = RequestEntityInformation(inv_item or active_item, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })
		local itemDescription = nil
		if entityInformation and entityInformation.information then
			itemDescription = entityInformation.information
		end

		inventoryBar.insightText:SetString(itemDescription)

		--local hovertext_lines = select(2, text:gsub("\n", "\n")) + 1 -- This is short by 1.
		local description_lines = inventoryBar.insightText.line_count or 0
		local textPadding = ""

		if itemDescription then
			textPadding = string.rep("\n ", description_lines)
		end
		
		-- This compensates for how vertical align is centered.
		local vertical_align_compensation = (description_lines - 1) * (inventoryBar.insightText.font_size / 2)
		
		-- 5 pixels for padding against the UI frame.
		inventoryBar.insightText:SetPosition(0, vertical_align_compensation + 5 + inventoryBar.insightText.font_size / 4)

		-- the " " forces it to constantly refresh, widgets/inventorybar:879
		oldActionStringBody_SetString(self, text .. " " .. textPadding)
		--oldActionStringBody_SetString(self, text .. " " .. string.rep("\n ", lines))
	end
end)

--==========================================================================================================================
--==========================================================================================================================
--======================================== FollowText ======================================================================
--==========================================================================================================================
--==========================================================================================================================
--STRINGS.NAMES.BEEFALO = "B33\nFA\nLO"

local DEBUG_SHOW_PREFAB = GetModConfigData("DEBUG_SHOW_PREFAB", true)
local RichText = import("widgets/RichText")

AddLocalPlayerPostInit(function(_, context) 
	DEBUG_SHOW_PREFAB = context.config["DEBUG_SHOW_PREFAB"] 
end)

AddClassPostConstruct("widgets/controls", function(controls)
	-- This is whatever is currently "selected", text is always the available actions.
	-- Starts with a newline (I assume for the entity name)
	-- See attack hit for notes on attack action.
	local old1 = controls.playeractionhint.SetTarget
	controls.playeractionhint.SetTarget = function(self, ...)
		--mprint("playeractionhint SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old1(self, ...)
	end

	-- This is whatever is currently "selected"
	-- Text is always starts with the entity name. If the enemy name has multiple lines, only the first line is here. 
	-- 		The other lines become part of playeractionhint.
	-- Text doesn't start with a newline, has 1 newline for every line in old1
	--[==[Ex:
		if playeractionhint is 
[[
(Y) Inspect
(A) Pickup]]
		then this text is
[[Twigs
 
 
]] (aka "Twigs\n \n ")
	]==]
	local old2 = controls.playeractionhint_itemhighlight.SetTarget
	controls.playeractionhint_itemhighlight.SetTarget = function(self, ...)
		--mprint("playeractionhint_itemhighlight SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old2(self, ...)
	end

	-- This is a secondary selector that shows the attack action on a nearby mob that isn't the primary focus
	-- If a target with this attackhint becomes the primary focus, it can no longer be the target here.
	-- Text doesn't start with a newline, nor any ending newlines
	-- Text is initially empty until assigned to the "(X) Attack" action
	local old3 = controls.attackhint.SetTarget
	controls.attackhint.SetTarget = function(self, ...)
		--mprint("attackhint SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old3(self, ...)
	end

	-- This is for turf related stuff and placing structures
	-- Text doesn't start with a newline or end with one
	-- Can either be "Dig" or "Place Ground" newline (and space?) "Cancel"
	-- The text is attached to the player for pitchforking and placing structures, and is attached to the tile grid when placing turf
	local old4 = controls.groundactionhint.SetTarget
	controls.groundactionhint.SetTarget = function(self, ...)
		--mprint("groundactionhint SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old4(self, ...)
	end
	
	local FollowText = require"widgets/followtext"
	controls.primaryInsightText = controls:AddChild(RichFollowText(TALKINGFONT, 28))
	controls.primaryInsightText:SetHUD(controls.owner.HUD.inst)
    controls.primaryInsightText:SetOffset(Vector3(0, 100, 0))
    controls.primaryInsightText:Hide()

	--[[
	controls.primaryInsightText2 = controls:AddChild(FollowText(TALKINGFONT, 28))
	controls.primaryInsightText2:SetHUD(controls.owner.HUD.inst)
    controls.primaryInsightText2:SetOffset(Vector3(1600, 100, 0))
    controls.primaryInsightText2:Hide()
	--]]

	local oldHighlightActionItem = controls.HighlightActionItem
	controls.HighlightActionItem = function(self, ...)
		oldHighlightActionItem(self, ...)
		local itemIndex, itemInActions = ...
		
		if itemIndex then
			if not self.primaryInsightText.shown then
				--print("Showing InsightText")
				self.primaryInsightText:Show()
				if self.primaryInsightText2 then
					self.primaryInsightText2:Show()
				end
			end


			-- The itemhighlight has the entity name.
			-- This has the information about the item.
			local followerWidget 
			if itemInActions then
				followerWidget = self.playeractionhint
			else
				followerWidget = self.groundactionhint
			end

			
			local offsetx, offsety = followerWidget:GetScreenOffset()
        	self.primaryInsightText:SetTarget(followerWidget.target)
        	if self.primaryInsightText2 then self.primaryInsightText2:SetTarget(followerWidget.target) end

			-- Show prefab if enabled
			if DEBUG_SHOW_PREFAB then
				local text = self.playeractionhint_itemhighlight.text:GetString()

				local pos = string.find(text, "\n")
				local prefab = " [" .. followerWidget.target.prefab .. "]"
				if pos then
					text = string.sub(text, 1, pos - 1) .. prefab .. string.sub(text, pos)
				else
					text = text .. prefab
				end

				self.playeractionhint_itemhighlight.text:SetString(text)
			end

			local followtext_lines = select(2, followerWidget.text:GetString():gsub("\n", "\n"))

			-- Reduced version of the logic from hoverer.
			local entityInformation = RequestEntityInformation(followerWidget.target, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })
			local itemDescription = nil
			if entityInformation and entityInformation.information then
				itemDescription = RichText.TrimNewlines(entityInformation.information)
			end

			if itemDescription then
				local insight_lines = select(2, itemDescription:gsub("\n", "\n")) + 1 -- Since I'm counting newlines, insight_lines is always 1 short. 
				-- However, trailing newlines have about half their actual height here (probably due to the middle vertical align). That means I need to add 1 more (aka double it) for Insight. 
				insight_lines = insight_lines + 1
				-- That leaves me with an overlap similar to the hoverer before the :SetPosition().
				-- One difference though: I correct the hoverer with a :SetPosition().
				-- The overlap here is half a newline's worth. Which means instead of adjusting the offset, I'll just add another to the line count.
				insight_lines = insight_lines + 1


				local total_lines = (followtext_lines) + (insight_lines) 
				self.primaryInsightText.text:SetString(string.rep("\n", total_lines) .. itemDescription)
				--self.primaryInsightText2.text:SetString(string.rep("\n", followtext_lines*2 + insight_lines) .. something .. ": A BLASPHEMOUS MOCKERY")
				
				--[[
				-- Testing with \n and \n\n confirms the preceeding newline stripping logic noted in RichText.
				self.primaryInsightText.text:SetString("\n\nRichText"..followerWidget.text:GetString())
				self.primaryInsightText2.text:SetString("\n\nNormText"..followerWidget.text:GetString())	
				]]
			else
				self.primaryInsightText.text:SetString(nil)
			end
			
		else
			if self.primaryInsightText.shown then
				--print("Hiding InsightText")
				self.primaryInsightText:Hide()
				if self.primaryInsightText2 then
					self.primaryInsightText2:Hide()
				end
			end
		end
	end
end)

--[[
local follows = {} -- i = followtext
--local targets = {} 
local targets_reverse = {} -- target = followtext

local function clean(tbl)
	local i = 1
	while i <= #tbl do
		if not tbl[i].inst:IsValid() then
			table.remove(tbl, i)
			i=i-1
		end

		i = i + 1
	end
end

local function init()
	local function cl(txt)
		local i = 1
		--txt:gsub("\n[%w%c%p%s]", function(x) i = i + 1 return x end)
		txt:gsub("\n", function(x) i = i + 1 return x end)

		if txt:sub(-1) == "\n" then
			i=i-1
		end

		return i
	end

	TheGlobalInstance:DoPeriodicTask(0.20, function()
		if not localPlayer then
			return
		end

		if not TheInput:ControllerAttached() then
			return
		end

		for target, widget in pairs(targets_reverse) do
			if not target:IsValid() or not widget.inst:IsValid() then
				targets_reverse[target] = nil
			end
		end

		clean(follows)

		local processed = {}
		for target, followText in pairs(targets_reverse) do
			if target ~= localPlayer then

			processed[followText] = true

			local itemInfo = RequestEntityInformation(target, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })

			if itemInfo then
				itemInfo = itemInfo.information
			end
			
			local lineHeight = 28
			local lines = cl(followText.text:GetString())

			if lines > 2 then
				lines = lines - 1
			else
				--lines = lines - 0.5 -- just this, but attack + only health (ancient furniture) = clipping
				if itemInfo and cl(itemInfo) > 1 then
					lines = lines - 0.5
				end
			end

			--local lines = itemInfo and cl(itemInfo) or 0
			--local base = lineHeight / 2

			followText.insightText:SetString(itemInfo)

			followText.insightText:SetPosition(0, -lines * lineHeight)

			end
		end

		for i = 1, #follows do
			local v = follows[i]
			if not processed[v] then
				v.insightText:SetString(nil)
			end
		end
	end)
end

AddClassPostConstruct("widgets/followtext", function(followText)
	follows[#follows+1] = followText
	init();init=function() end;

	-- generated and then updated as needed
	followText.insightText = followText:AddChild(RichText())
	followText.insightText:SetSize(28)

	-- target
	local oldSetTarget = followText.SetTarget
	followText.SetTarget = function(self, target)
		if self.target then
			if self.target ~= target then
				if targets_reverse[self.target] then
					targets_reverse[self.target].insightText:SetString(nil)
				end
			end
			targets_reverse[self.target] = nil
		end

		oldSetTarget(self, target)

		if target then
			targets_reverse[target] = self
		end

		--targets[self] = target
	end
end)
--]]

--==========================================================================================================================
--==========================================================================================================================
--======================================== Controller Menu =================================================================
--==========================================================================================================================
--==========================================================================================================================

local InsightMenuScreen = import("screens/insightmenuscreen")
TheInput:AddControlHandler(IS_DST and CONTROL_OPEN_CRAFTING or CONTROL_OPEN_DEBUG_MENU, function(down) -- CONTROL_FOCUS_UP
	if down then
		return
	end

	if not TheInput:ControllerAttached() then
		return -- turns out caps lock inside the tab menu. whoops.
	end
		
	local screen_name = TheFrontEnd:GetActiveScreen().name

	if screen_name == "PlayerStatusScreen" or (IS_DS and screen_name == "PauseScreen") then
		TheFrontEnd.screenstack[#TheFrontEnd.screenstack]:ClearFocus()
		local sc = InsightMenuScreen()
		TheFrontEnd:PushScreen(sc)
	elseif screen_name == "InsightMenuScreen" then
		TheFrontEnd:GetActiveScreen():Close()
	else
		dprint(screen_name)
	end
end)

if IS_DS then
	AddClassPostConstruct("screens/pausescreen", function(pauseScreen)
		local oldGetHelpText = pauseScreen.GetHelpText
		pauseScreen.GetHelpText = function(self)
			local str = ""
			if TheInput:ControllerAttached() then
				str = TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_OPEN_DEBUG_MENU) .. " Insight Menu  " -- two spaces looks correct
			end

			return str .. oldGetHelpText(self)
		end
	end)
end


if IS_DST then
	import("uichanges/playerstatusscreen").Initialize()
end