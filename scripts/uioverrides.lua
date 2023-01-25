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
local ImageButton = require("widgets/imagebutton")
local InsightButton = import("widgets/insightbutton")
local RichText = import("widgets/RichText")
local Text = require"widgets/text"

local SHIF_CURRENT_CALLER = nil
local SHIF_TASK = nil
local SHIF_DELAY = IS_DST and 1/30 or 0.09

function SetHighlightIngredientFocus(caller, arg)
	--local cstr = caller.ing and caller.ing.texture and string.match(caller.ing.texture, '[^/]+$'):gsub('%.tex$', '') or caller
	--local argstr = arg and arg.ing and arg.ing.texture and string.match(arg.ing.texture, '[^/]+$'):gsub('%.tex$', '') or arg
	--mprint("SetHighlightIngredientFocus", cstr, argstr)
	--mprint("\t\tCaller diff: old", SHIF_CURRENT_CALLER, "| new:", caller)

	if arg == nil then
		-- When you quickly swap between two ingredients, the new one gets the highlighting call set but the second one triggers focus lose after and clears the highlighting task
		-- We only reset the thing here if the caller is the correct caller.
		if SHIF_CURRENT_CALLER == caller then
			--mprint("\t\t\t\tSuccessful cancel")
			highlighting.SetActiveIngredientUI(nil)
			SHIF_CURRENT_CALLER = nil
			if SHIF_TASK then SHIF_TASK:Cancel() SHIF_TASK = nil end
		end

		return
	end

	-- Presumably we have a new target now.
	SHIF_CURRENT_CALLER = caller

	if SHIF_TASK then SHIF_TASK:Cancel() SHIF_TASK = nil end
	SHIF_TASK = TheGlobalInstance:DoTaskInTime(SHIF_DELAY, function()
		highlighting.SetActiveIngredientUI(arg)
	end)
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

--==========================================================================================================================
--==========================================================================================================================
--======================================== Post Constructs =================================================================
--==========================================================================================================================
--==========================================================================================================================
import("uichanges/pausescreen").Initialize()

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

local function MakeInsightMenuButton(controls)
	-- Construct
	local mb = InsightButton()
	mb.allowcontroller = false
	mb.can_be_shown = true

	-- Functions
	function mb:ResetPosition()
		self:SetPosition(-60 -64 -30, 40, 0) -- -60, 70, 0 is map button
	end

	mb:SetOnDragFinish(function(oldpos, newpos)
		insightSaveData:Set("insightmenubutton_position", newpos)
		insightSaveData:Save(function(success)
			if success then
				mprint("Successfully saved new menu button position.")
			else
				mprint("[ERROR] FAILED TO SAVE MENU BUTTON POSITION")
			end
		end)
	end)

	mb:SetOnClick(function()
		controls:ToggleInsightMenu()
	end)

	-- Init
	mb.inst:DoPeriodicTask(0.5, function()
		if mb.allowcontroller then
			return
		end

		if not mb.can_be_shown or TheInput:ControllerAttached() then
			mb:Hide()
		elseif mb.can_be_shown then
			mb:Show()
		end
	end)

	mb:ResetPosition()
	mb:SetDraggable(true)
	mb:SetTooltip("Insight")
	
	local saved_pos = insightSaveData:Get("insightmenubutton_position")
	if saved_pos ~= nil then
		mb:SetPosition(saved_pos.x, saved_pos.y, saved_pos.z)
	end

	return mb
end


AddClassPostConstruct("widgets/controls", function(controls)
	local InsightButton = import("widgets/insightbutton")
	local InsightMenu = import("widgets/insightmenu")

	-- TODO: REMOVE THIS
	--[[
	util.classTweaker.TrackClassInstances(InsightMenu)
	REGISTER_HOT_RELOAD({"widgets/insightmenu"}, function(imports)
		InsightMenu = imports.insightmenu
		util.classTweaker.TrackClassInstances(InsightMenu)

		controls.insight_menu:Kill()
		controls.insight_menu = controls.top_root:AddChild(InsightMenu())
		controls.insight_menu:SetPosition(0, -400)
		controls.insight_menu:Hide()
		controls.insight_menu:Activate()
	end)
	--]]

	controls.ToggleInsightMenu = function(self)
		if not self.insight_menu then
			return
		end

		if self.insight_menu.shown then
			self.insight_menu:Hide()
		else
			self.insight_menu:Show()
		end
	end

	controls.insight_menu = controls.top_root:AddChild(InsightMenu())
	controls.insight_menu:SetPosition(0, -400)
	controls.insight_menu:Hide()
	controls.inst:DoTaskInTime(0, function() controls.insight_menu:Activate() end)

	controls.insight_menu.force_exit_listener = ClientCoreEventer:ListenForEvent("force_insightui_exit", function()
		controls.insight_menu:Hide()
	end)
	
	local already_prompted = false

	if OnContextUpdate:HasListener("controlspost") then
		OnContextUpdate:RemoveListener("controlspost")
	end

	OnContextUpdate:AddListener("controlspost", function(context)
		if context.config["display_insight_menu_button"] then
			controls.insight_menu_toggle = controls.insight_menu_toggle or controls.bottomright_root:AddChild(MakeInsightMenuButton(controls))
			if not already_prompted and FIRST_TIME_INSIGHT then
				already_prompted = true
				local exclamation = controls.insight_menu_toggle:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex"))
				exclamation:Disable()
				exclamation:SetText("!")
				exclamation:SetTextSize(35)
				exclamation:SetFont(UIFONT)
				exclamation:SetDisabledFont(exclamation.font)
				exclamation:SetPosition(0, 64/2 + 35/2)
				exclamation:SetTextColour(UICOLOURS.RED)
				exclamation:SetTextFocusColour(UICOLOURS.GOLD_FOCUS)
				--exclamation:SetTextSelectedColour(exclamation.textcolour)
				exclamation:SetTextDisabledColour(exclamation.textcolour)

				local old = controls.insight_menu_toggle.onclick2
				controls.insight_menu_toggle:SetOnClick(function()
					controls.insight_menu_toggle:SetOnClick(old)
					exclamation:Kill()
					NEW_VERSION_INFO_FN(controls.insight_menu_toggle)
				end)
			end
		else
			if controls.insight_menu_toggle then
				controls.insight_menu_toggle:Kill()
				controls.insight_menu_toggle = nil
			end
		end

		-- localPlayer isn't ready yet upon widget ctor, so the widget won't handle this automatically.
		local insight = GetLocalInsight(controls.owner)
		if not table.contains(insight.menus, controls.insight_menu) then
			insight:MaintainMenu(controls.insight_menu) 
		end
	end)

	--[[
	wowza = controls.top_root:AddChild(Text(UIFONT, 30, ""))
	wowza:SetPosition(0, -350)

	local ListBox = import("widgets/listbox")
	local box = controls.top_root:AddChild(ListBox({
		width = 300,
		option_height = 40, 
		num_visible_rows = 4,
		scroller = {
			width = 15
		}
	}))
	local t = {}
	for i = 1, 1 do
		t[i] = {text="txt"..i, data="txt"..i, selected=true}
	end
	box:SetData(t)
	box:SetPosition(0, -400)
	rawset(_G, "box", box)
	--]]

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
import("uichanges/craftingmenu").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Ingredient UI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import("uichanges/ingredientui").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ CraftSlot ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import("uichanges/craftslot").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Recipe Popup ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import("uichanges/recipelookup").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Stat Meter Inspection ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local meterInspectModule = import("uichanges/meterinspect")
meterInspectModule.Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ WX-78 Charge Timer ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local wxChargeDisplayModule = import("uichanges/wxchargedisplay")
if wxChargeDisplayModule.CanHookUpgradeModuleDisplay() then
	wxChargeDisplayModule.HookUpgradeModuleDisplay()
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Craft Pot ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
				SetHighlightIngredientFocus(self, { prefab=arg })
			end
		elseif typ == "tag" then
			if type(arg) ~= "string" then
				mprint("foodingredientui hook error", arg, type(arg), typ)
			else
				SetHighlightIngredientFocus(self, { prefab=nil, ingredient_tag=arg })
			end
		end
		
		if oldOnGainFocus then
			return oldOnGainFocus(self, ...)
		end
	end

	function FoodIngredientUI:OnLoseFocus(...)
		SetHighlightIngredientFocus(self, nil)

		if oldOnLoseFocus then
			return oldOnLoseFocus(self, ...)
		end
	end
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Hoverer ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
import("uichanges/hoverer").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FollowText ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- This is for controller support.
import("uichanges/controls_followtext").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ InventoryBar ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Also for controller support.
import("uichanges/inventorybar").Initialize()

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Controller Menu ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

local InsightMenuScreen = import("screens/insightmenuscreen")
TheInput:AddControlHandler(controlHelper.controller_scheme.open_insight_menu:GetPrimaryControl(), function(down) -- CONTROL_FOCUS_UP
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
				str = TheInput:GetLocalizedControl(TheInput:GetControllerID(), controlHelper.controller_scheme.open_insight_menu:GetPrimaryControl()) .. " Insight Menu  " -- two spaces looks correct
			end

			return str .. oldGetHelpText(self)
		end
	end)
end


if IS_DST then
	import("uichanges/playerstatusscreen").Initialize()
end