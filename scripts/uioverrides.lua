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

-- Not really the spot for it, but I'm going to patch the Image class here with RealSetTexture since I'm nuking the old widget libraries. Old comments included!
-- Image.SetTexture gets replaced, December 5, 2020: ([DST]HD Item Icon - Shang) https://steamcommunity.com/sharedfiles/filedetails/?id=2260439333
-- then i realized other mods, such as the reskinners, do the same thing.
-- oh boy.
-- honestly, if i ever make another mod of this complexity, i'm going to have to package all of my patches and hacks to deal with other mods into a library of its own. how lovely.
-- plus, it's really irritating i have to skip the syntatic sugar of : 
--[[
imageLib.SetTexture\(([^,]+),\s*([^)]+)\)
$1:RealSetTexture($2)
]]
do
	local Image = require("widgets/image")
	local image_loader = loadfile("scripts/widgets/image.lua")
	local env = setmetatable({}, {
		__index = getfenv(0)
	})
	setfenv(image_loader, env)
	local DummyImage = image_loader()
	Image.RealSetTexture = DummyImage.SetTexture
	DummyImage = nil
end

-- Patching ImageButton class here as well.
do
	local ImageButton = require("widgets/imagebutton")
	--------------------------------------------------------------------------
	--[[ Focus Functions ]]
	--------------------------------------------------------------------------
	local function OnGainFocus(self)
		ImageButton._base.OnGainFocus(self)

		if self.hover_overlay then
			self.hover_overlay:Show()
		end

		if self:IsEnabled() then
			--imageLib.SetTexture(self.image, self.atlas, self.image_focus)
			self.image:SetTexture(self.atlas, self.image_focus)

			if self.size_x and self.size_y then 
				self.image:ScaleToSize(self.size_x, self.size_y)
			end
		end
	end

	local function OnLoseFocus(self)
		ImageButton._base.OnLoseFocus(self)

		if self.hover_overlay then
			self.hover_overlay:Hide()
		end

		if self:IsEnabled() then
			--imageLib.SetTexture(self.image, self.atlas, self.image_normal)
			self.image:SetTexture(self.atlas, self.image_normal)

			if self.size_x and self.size_y then 
				self.image:ScaleToSize(self.size_x, self.size_y)
			end
		end
	end

	-- I want this available globally. I might change my mind down the road though.
	--[[
	widgetLib.imagebutton.OverrideFocuses\(([^)]+)\)
	$1:InsightOverrideFocuses()
	]]
	function ImageButton.InsightOverrideFocuses(self)
		if IS_DST then
			return
		end
		self.OnGainFocus = OnGainFocus
		self.OnLoseFocus = OnLoseFocus
	end
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

	controls.insight_menu = controls.top_root:AddChild(InsightMenu())
	controls.insight_menu:SetPosition(0, -400)
	controls.insight_menu:Hide()
	controls.insight_menu:Activate()

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
		if controls.insight_menu.shown then
			controls.insight_menu:Hide()
		else
			controls.insight_menu:Show()
		end
	end)

	AddLocalPlayerPostInit(function(insight, context)
		if not context.config["display_insight_menu_button"] then
			dprint("Display Insight Menu Button is disabled.")
			mb:Kill()
			return
		end
		insight:MaintainMenu(controls.insight_menu)
	end)

	--[[
	local Insight_Clock = import("widgets/insight_clock")

	local c = Insight_Clock()
	c:SetPosition(0, -400)
	controls.top_root:AddChild(c)
	--]]

	dprint("Insight Menu Button added")
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
		local vertical_align_compensation = (description_lines - 1) * (inventoryBar.insightText.size / 2)
		
		-- 5 pixels for padding against the UI frame.
		inventoryBar.insightText:SetPosition(0, vertical_align_compensation + 5 + inventoryBar.insightText.size / 4)

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
-- This is for controller support.
import("uichanges/controls_followtext").Initialize()

--==========================================================================================================================
--==========================================================================================================================
--======================================== Controller Menu =================================================================
--==========================================================================================================================
--==========================================================================================================================

local InsightMenuScreen = import("screens/insightmenuscreen")
TheInput:AddControlHandler(controlHelper.controller_scheme.open_insight_menu[1], function(down) -- CONTROL_FOCUS_UP
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
	--elseif screen_name == "InsightMenuScreen" then
		--TheFrontEnd:GetActiveScreen():Close()
	else
		dprint("uioverrides > AddControlHandler:", screen_name)
	end
end)

if IS_DS then
	AddClassPostConstruct("screens/pausescreen", function(pauseScreen)
		local oldGetHelpText = pauseScreen.GetHelpText
		pauseScreen.GetHelpText = function(self)
			local str = ""
			if TheInput:ControllerAttached() then
				str = TheInput:GetLocalizedControl(TheInput:GetControllerID(), controlHelper.controller_scheme.open_insight_menu[1]) .. " Insight Menu  " -- two spaces looks correct
			end

			return str .. oldGetHelpText(self)
		end
	end)
end


if IS_DST then
	import("uichanges/playerstatusscreen").Initialize()
end