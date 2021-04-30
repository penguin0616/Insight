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
local ItemTile = require("widgets/itemtile")
local CraftSlot = require("widgets/craftslot")
local IngredientUI = require("widgets/ingredientui")
local RecipePopup = require("widgets/recipepopup") 
local InsightButton = import("widgets/insightbutton")
local RichText = import("widgets/RichText")
local Is_DS = IsDS()
local Is_DST = IsDST()

local SHIF_TASK = nil
local function SetHighlightIngredientFocus(arg)
	if SHIF_TASK then
		SHIF_TASK:Cancel()
		SHIF_TASK = nil
	end

	if arg == nil then
		highlighting.SetActiveIngredientUI(nil)
		return
	end

	SHIF_TASK = TheGlobalInstance:DoTaskInTime(0.09, function()
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

	AddLocalPlayerPostInit(function(insight)
		insight:MaintainMenu(menu)
	end)

	local mb = InsightButton()
	mb:SetPosition(-60 -64 -30, 40, 0) -- -60, 70, 0 is map button
	mb:SetDraggable(true)
	mb.allowcontroller = IsDS() -- false
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

		local pos = json.decode(str).position
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

--==========================================================================================================================
--==========================================================================================================================
--======================================== Item Tile =======================================================================
--==========================================================================================================================
--==========================================================================================================================
-- Handler for ItemTile:SetPercent()
-- created for issue #5
local oldItemTile_SetPercent = ItemTile.SetPercent
local ITEMTILE_DISPLAY = 2; AddLocalPlayerPostInit(function(_, context) ITEMTILE_DISPLAY = context.config["itemtile_display"] end);
function ItemTile:SetPercent(...)
	if not localPlayer then
		return oldItemTile_SetPercent(self, ...)
	end
	
	--dprint('yep', GetModConfigData("itemtile_display", true))
	--dprint('yep', self.item, self, ...) 

	local cfg = ITEMTILE_DISPLAY
	
	if (cfg == 2) or IsForge() then
		return oldItemTile_SetPercent(self, ...)
	end

	--dprint('hello')
	
	if not self.percent then
		-- have klei take care of setting up the percent first.
		oldItemTile_SetPercent(self, ...)
		if not self.percent then
			--dprint("Unable to :SetPercent()")
		end

	end

	if cfg == 0 then
		if self.item and self.percent then
			self.percent:SetString(nil)
		end

		return
	end

	if self.item and self.percent then
		--dprint('oh')
		local value
		
		local itemInfo = RequestEntityInformation(self.item, localPlayer, { fromInspection=true, ignore_worldly=true })

		if itemInfo then
			if itemInfo.special_data.temperature then -- thermal stone, coming in STRONG
				value = itemInfo.special_data.temperature.temperatureValue

			elseif itemInfo.special_data.armor then
				value = itemInfo.special_data.armor.durabilityValue

			elseif itemInfo.special_data.fueled then
				--mprint('asdf', itemInfo.special_data.fueled.remaining_time)
				value = itemInfo.special_data.fueled.remaining_time
				
			elseif itemInfo.special_data.finiteuses then
				value = itemInfo.special_data.finiteuses.uses

			end
		end

		--dprint("hey", value)

		if value then
			--dprint('right')
			value = tostring(value)
			self.percent:SetString(value)

			if IsDS() then -- this flips over and goes tiny in DST
				if #value > 4 then
					-- today i learned Text:SetSize() does nothing, because they messed up while coding the text widget and made :GetSize() into :SetSize() overriding the working one.
					-- real nice. 
					--self.percent.inst.TextWidget:SetSize((LOC and LOC.GetTextScale() or 1) * (42 - (#value - 4) * 2))
					self.percent:InsightSetSize((#value - 4) * 2)
				else
					--self.percent:SetSize(42) -- default
					self.percent:InsightSetSize(42) -- default
				end
			else
				if #value > 4 then
					self.percent:SetSize(42 - (#value - 4) * 2)
				else
					self.percent:SetSize(42) -- default
				end
			end

			-- don't want to trigger it again
			return
		end
	end
	

	return oldItemTile_SetPercent(self, ...)
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Ingredient UI ===================================================================
--==========================================================================================================================
--==========================================================================================================================
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


--==========================================================================================================================
--==========================================================================================================================
--======================================== Craft Slot ======================================================================
--==========================================================================================================================
--==========================================================================================================================
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

--==========================================================================================================================
--==========================================================================================================================
--======================================== Recipe Popup ====================================================================
--==========================================================================================================================
--==========================================================================================================================
local recipe_urls = {}
local function GetRecipeURL(recipe)
	if recipe_urls[recipe.name] then
		return unpack(recipe_urls[recipe.name])
	end

	--print('lookup', recipe and recipe.product)
	if not _G.Prefabs[recipe.product] or not _G.Prefabs[recipe.product].fn then
		return nil
	end

	local ctor = _G.Prefabs[recipe.product].fn
	local info = debug.getinfo(ctor, "S")

	
	local parent = string.match(info.source, "(.*)scripts%/prefabs%/")
	local mod_folder_name = parent and string.match(parent, "mods%/([^/]+)%/")
	--mprint("hey:", recipe.product, info.source, parent, mod_folder_name)

	if info.source == "scripts/prefabutil.lua" or parent == "" then
		-- vanilla
		if not STRINGS.NAMES[string.upper(recipe.product)] then
			recipe_urls[recipe.name] = {nil, nil}
			return recipe_urls[recipe.name]
		end

		local url = "https://dontstarve.fandom.com/wiki/" .. STRINGS.NAMES[string.upper(recipe.product)]:gsub("%s", "_")
		recipe_urls[recipe.name] = {url, false}

		return url, false
	end

	-- modded
	for _, modname in pairs(ModManager:GetEnabledModNames()) do
		if modname == mod_folder_name then
			local modinfo = KnownModIndex:GetModInfo(modname)
			if type(modinfo.forumthread) == "string" and modinfo.forumthread ~= "" then
				recipe_urls[recipe.name] = {modinfo.forumthread, true}
				return unpack(recipe_urls[recipe.name])
			else
				local workshop_id = string.match(mod_folder_name, "workshop%-(%d+)")
				if workshop_id then
					local url = "https://steamcommunity.com/sharedfiles/filedetails/?id=" .. workshop_id
					recipe_urls[recipe.name] = {url, true}
					return url, true
				end
			end
		end
	end

	recipe_urls[recipe.name] = {nil, nil}
	return nil
end

local oldRecipePopup_Refresh = RecipePopup.Refresh
function RecipePopup:Refresh()
	local mod = {0, 1, 0, 1}
	local normal = {1, 1, 1, 1}

	oldRecipePopup_Refresh(self)
	local context = localPlayer and GetPlayerContext(localPlayer)
	if not context or not context.config["display_crafting_lookup_button"] then
		--dprint("rejected, 1", self.recipe and self.recipe.product)
		return
	end
	
	if self.lookup and self.lookup.inst:IsValid() then 
		self.lookup:SetPosition(self.name:GetRegionSize() / 2 + self.name:InsightGetSize() / 2, 0)
		local url, modded = GetRecipeURL(self.recipe)
		if url then
			if modded then
				self.lookup.button.image:SetTint(unpack(mod))
			else
				self.lookup.button.image:SetTint(unpack(normal))
			end
		else
			self.lookup:Kill()
			self.lookup = nil
		end
		--dprint("rejected, 2", self.recipe and self.recipe.product)
		return
	end

	if not self.recipe then
		--dprint("rejected, 3", self.recipe and self.recipe.product)
		return
	end

	local url, modded = GetRecipeURL(self.recipe)
	if not url then
		--dprint("rejected, 4", self.recipe and self.recipe.product)
		return
	end
	
	local header = self.name
	self.lookup = header:AddChild(InsightButton())
	widgetLib.imagebutton.ForceImageSize(self.lookup.button, header:InsightGetSize(), header:InsightGetSize())
	self.lookup:SetPosition(header:GetRegionSize() / 2 + header:InsightGetSize() / 2, 0)
	self.lookup.button.scale_on_focus = false
	widgetLib.imagebutton.OverrideFocuses(self.lookup.button)
	self.lookup.button:SetTooltip("Click to lookup item")

	if modded then
		self.lookup.button.image:SetTint(unpack(mod))
	else
		self.lookup.button.image:SetTint(unpack(normal))
	end

	self.lookup:SetOnClick(function()
		VisitURL(GetRecipeURL(self.recipe))
	end)
end


--==========================================================================================================================
--==========================================================================================================================
--======================================== Crock Pot =======================================================================
--==========================================================================================================================
--==========================================================================================================================
if IsDST() then
	local CookbookPageCrockPot = require("widgets/redux/cookbookpage_crockpot")

	local oldPopulateRecipeDetailPanel = CookbookPageCrockPot.PopulateRecipeDetailPanel
	function CookbookPageCrockPot:PopulateRecipeDetailPanel(data)
		-- there's self.details_root, and this details_root, so its technically self.details_root.details_root even though that doesnt actually work
		local details_root = oldPopulateRecipeDetailPanel(self, data)

		local header
		for i,v in pairs(details_root:GetChildren()) do
			if v.name == "Text" and v:GetString() == data.name then
				header = v
				break
			end
		end

		if not header then return details_root end

		self.lookup = header:AddChild(InsightButton())
		widgetLib.imagebutton.ForceImageSize(self.lookup.button, header:InsightGetSize(), header:InsightGetSize())
		self.lookup:SetPosition(header:GetRegionSize() / 2 + header:InsightGetSize() / 2, 0)
		self.lookup.button.scale_on_focus = false
		widgetLib.imagebutton.OverrideFocuses(self.lookup.button)
		self.lookup.button:SetTooltip("Click to lookup item") -- wont work in cookbook, overlay reasons i think

		self.lookup:SetOnClick(function()
			-- the wiki url automatically resolves spaces to underscores.
			local title = header:GetString()
			VisitURL("https://dontstarve.fandom.com/wiki/" .. title) 
		end)

		return details_root
	end
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
local DEBUG_SHOW_PREFAB = GetModConfigData("DEBUG_SHOW_PREFAB", true); AddLocalPlayerPostInit(function(_, context) DEBUG_SHOW_PREFAB = context.config["DEBUG_SHOW_PREFAB"] end);
AddClassPostConstruct("widgets/hoverer", function(hoverer)
	local HOVERER_TEXT_SIZE = 30
	local TEXT_SIZE = 30
	local GetMouseTargetItem = GetMouseTargetItem
	local RequestEntityInformation = RequestEntityInformation
	local TheSim = TheSim
	local debug_getinfo = debug.getinfo
	local math_clamp = math.clamp
	local string_find = string.find
	local string_sub = string.sub
	local math_ceil = math.ceil
	local TheInput_IsKeyDown = TheInput.IsKeyDown
	local TheInputProxy_GetLocalizedControl = TheInputProxy.GetLocalizedControl
	local TheInput_IsControlPressed = TheInput.IsControlPressed

	local Is_DS = IsDS()
	local Is_DST = IsDST()
	local CONTROL_FORCE_INSPECT = CONTROL_FORCE_INSPECT
	local CONTROL_FORCE_TRADE = CONTROL_FORCE_TRADE

	local oldSetString = hoverer.text.SetString
	local oldOnUpdate = hoverer.OnUpdate
	local oldHide = hoverer.text.Hide
	local oldHide2 = hoverer.secondarytext.Hide

	local informationOnAltOnly
	local canShowItemRange
	local canShowExtendedInfoIndicator
	--local altOnlyIsVerbose

	hoverer.insightText = hoverer:AddChild(RichText(UIFONT, TEXT_SIZE))

	-- so, there's an issue where once you examine something, YOFFSETUP and YOFFSETDOWN are changed to compensate for that secondary text, but are never changed back
	-- so whereas normally hover text is unable to follow below a certain height because of math.min, the new YOFFSETUP means it is free to roam wherever vertically
	-- nothing like having to fix klei bugs myself because you literally can't report don't starve bugs

	-- this gets spam called
	function hoverer.text.Hide(self)
		if self.shown then 
			--GetMouseTargetItem() -- i could probably do this better, eh?
			if canShowItemRange and currentlySelectedItem ~= nil then
				OnCurrentlySelectedItemChanged(currentlySelectedItem, nil)
				currentlySelectedItem = nil
			end
			oldHide(self)
		end
	end

	function hoverer.secondarytext.Hide(self)
		if Is_DS then
			util.replaceupvalue(debug_getinfo(2).func, "YOFFSETUP", 40)
			util.replaceupvalue(debug_getinfo(2).func, "YOFFSETDOWN", 30)
		end

		if self.shown then
			oldHide2(self)
		end
	end

	-- count lines
	local function cl(txt)
		local i = 1
		txt:gsub("\n", function() i = i + 1 end) -- i should probably bring this up to scratch with the other one, but i do not have the mental fortitude to handle it.
		-- oh, how i hate working with UIs.
		return i
	end

	-- TheInput:GetScreenPosition()

	if Is_DST then
		function hoverer:UpdatePosition(x, y)
			local YOFFSETUP = -80
			local YOFFSETDOWN = -50
			local XOFFSET = 10

			local scale = self:GetScale()
			local scr_w, scr_h = TheSim:GetScreenSize()
			local w = 0
			local h = 0

			if self.text ~= nil and self.str ~= nil then
				local w0, h0 = self.text:GetRegionSize()
				w = math.max(w, w0)
				h = math.max(h, h0)
			end
			if self.secondarytext ~= nil and self.secondarystr ~= nil then
				local w1, h1 = self.secondarytext:GetRegionSize()
				w = math.max(w, w1)
				h = math.max(h, h1)
			end
			if self.insightText ~= nil and self.insightText:GetString() then
				local w2, h2 = self.insightText:GetRegionSize()
				w = math.max(w, w2)
				h = math.max(h, h2)
			end

			w = w * scale.x * .5
			h = h * scale.y * .5

			--print(y, "LOWER:", h + YOFFSETDOWN * scale.y, "HIGHER:", scr_h - h - YOFFSETUP * scale.y)

			-- low = bottom
			-- high = top
			--print("max:", scr_h - h*2 - YOFFSETUP * scale.y) -- scr_h - h - YOFFSETUP * scale.y
			--print("current:", y)
			--print'-----------------------------------------'

			local x_min = w + XOFFSET
			local x_max = scr_w - w - XOFFSET

			local r = cl(self.text:GetString())
			local y_min = h + YOFFSETDOWN * scale.y + (30*.75)
			-- y_max = scr_h - h - YOFFSETUP * scale.y
			local y_max = scr_h - h*2 - YOFFSETUP * scale.y -- h*2 means harder for insight to go off bounds

			self:SetPosition(
				math_clamp(x, x_min, x_max),
				math_clamp(y, y_min, y_max),
				0)
		end
	end
	
	function hoverer.OnUpdate(self, ...)
		if not self.text.shown then
			self.insightText:SetString(nil) -- this ends up causing some delay for text positioning?
		end

		oldOnUpdate(self, ...)
	end

	hoverer.text.SetString = function(self, text)
		if not localPlayer then
			return oldSetString(self, text)
		end

		if informationOnAltOnly == nil then
			informationOnAltOnly = GetModConfigData("alt_only_information", true)
		end

		if canShowItemRange == nil then
			canShowItemRange = GetModConfigData("hover_range_indicator", true)
		end

		if canShowExtendedInfoIndicator == nil then
			canShowExtendedInfoIndicator = GetModConfigData("extended_info_indicator", true)
		end

		--[[
		if altOnlyIsVerbose == nil then
			altOnlyIsVerbose = GetModConfigData("alt_only_is_verbose", true)
		end
		--]]

		--YOFFSETUP = util.getupvalue(debug.getinfo(2).func, "YOFFSETUP")
		--YOFFSETDOWN = util.getupvalue(debug.getinfo(2).func, "YOFFDOWN")
		--mprint('t1:', text) -- main action or whatnot, including alt
		-- additional hours going through hell and back
		-- i have such an irritating headache.
		--
		-- information
		local item = GetMouseTargetItem()
		local entityInformation = RequestEntityInformation(item, localPlayer, { fromInspection=true, ignore_worldly=true })
		local itemDescription = nil

		if item and DEBUG_SHOW_PREFAB then
			local pos = string_find(text, "\n")
			local prefab = " [" .. item.prefab .. "]"
			if pos then
				text = string_sub(text, 1, pos - 1) .. prefab .. string_sub(text, pos)
			else
				text = text .. prefab
			end
		end
		
		if entityInformation then
			-- control pressed doesn't have the game focus issues (alt+tab keeps the key down) and handles the changed keybinds in control menu. 
			if TheInput_IsControlPressed(TheInput, CONTROL_FORCE_INSPECT) then
				local altOnlyIsVerbose = TheInput_IsControlPressed(TheInput, CONTROL_FORCE_TRADE)
				if informationOnAltOnly == true and altOnlyIsVerbose == false then
					itemDescription = entityInformation.information

					if entityInformation.information ~= entityInformation.alt_information then
						local pos = string_find(text, "\n")
						if pos then
							text = string_sub(text, 1, pos - 1) .. (canShowExtendedInfoIndicator and "*" or "") .. string_sub(text, pos)
						else
							text = text .. "*"
						end
					end
					
				else
					itemDescription = entityInformation.alt_information
				end
			elseif informationOnAltOnly then
				itemDescription = nil
			else
				itemDescription = entityInformation.information
				if entityInformation.information ~= entityInformation.alt_information then
					local pos = string_find(text, "\n")
					if pos then
						text = string_sub(text, 1, pos - 1) .. (canShowExtendedInfoIndicator and "*" or "") .. string_sub(text, pos)
					else
						text = text .. (canShowExtendedInfoIndicator and "*" or "")
					end
				end
			end

			--[[
				if altOnlyIsVerbose == true then
					print'yeep'
					itemDescription = entityInformation.alt_information
				else
					itemDescription = entityInformation.information
				end
			]]

			--itemInfo = (TheInput:IsKeyDown(KEY_LALT) and itemInfo.alt_information) or itemInfo.information or nil
		end

		if canShowItemRange then
			if item == nil or entityInformation == nil then
				if currentlySelectedItem ~= nil then
					OnCurrentlySelectedItemChanged(currentlySelectedItem, nil)
					currentlySelectedItem = nil
				end
			elseif item and entityInformation and entityInformation.GUID then -- GUID presence means it is initialized
				if currentlySelectedItem ~= item then
					OnCurrentlySelectedItemChanged(currentlySelectedItem, item, entityInformation)
					currentlySelectedItem = item
				end
			end
		end

		if item and DEBUG_ENABLED then
			--itemInfo = string.format("Active: %s\n", tostring(entityManager:IsEntityActive(item))) .. (itemInfo or "")
		end

		hoverer.insightText:SetString(itemDescription)
		
		-- size info
		local dataWidth, dataHeight = hoverer.insightText:GetRegionSize()
		--local headerWidth, headerHeight = CalculateSize(text) --self:GetRegionSize()
		--local headerY = (hoverer.owner.HUD.controls:GetTooltipPos() or hoverer.default_text_pos).y

		-- misc
		--local positionPadding = (cl(text) - 1) * 7.5

		local x = math_ceil(dataHeight / hoverer.insightText.font_size)
		local r = cl(text) - 1

		local textPadding 
		

		--local textPadding = string.rep("\n ", math.ceil(dataHeight / 30) + 0)

		--mprint(CalculateSize(text), headerWidth, headerHeight, math.ceil(headerHeight / 30))
		--mprint(math.ceil(headerHeight / 30) - math.ceil(dataHeight / 30))

		local p1 = hoverer:GetPosition()
		--mprint(p1.x, dataWidth, screenWidth)

		if Is_DST then
			local tp_bonus = (r == 2 and 0) or 1
			textPadding = string.rep("\n ", x + r + tp_bonus)
			
			hoverer.insightText:SetPosition(0, 7.5 + tp_bonus * 15 + dataHeight/2)
		else
			textPadding = string.rep("\n ", x)
			r = r - 1
			if r < 0 then
				--r = 0 -- i commented this and that made the stars align
			end

			hoverer.insightText:SetPosition(0, -7.5 + (-15 * r) + dataHeight / 2)
		end

		
		return oldSetString(self, text .. textPadding)
	end

	hoverer.secondarytext.SetString = function(self, text)
		-- stuff like boats, where the action is far below
		-- or any ground entity really
		-- explains why the text overlap from boats happened
		--mprint('t2:', text)
		--[[
		local YOFFSETDOWN = (IsDS() and 30) or -50
		local w, h = hoverer.insightText:GetRegionSize()

		local line_buffer = (IsDS() and 4) or 7
		
		
		local r = h - (30 * line_buffer)
		if r < 0 then
			r = 0
		end

		if IsDST() then
			r = h
		end

		self:SetPosition(0, 0)
		--]]

		-- default y is -30
		-- size info
		local dataPosition = hoverer.insightText:GetPosition()
		local dataWidth, dataHeight = hoverer.insightText:GetRegionSize()

		-- there's a 1 line gap in vanilla (both) between the primarytext and secondarytext
		if hoverer.insightText.raw_text == nil then
			self:SetPosition(0, -30)
		else
			self:SetPosition(0, dataPosition.y - dataHeight)
		end

		return oldSetString(self, text)
	end
	--]]
end)

--==========================================================================================================================
--==========================================================================================================================
--======================================== InventoryBar ====================================================================
--==========================================================================================================================
--==========================================================================================================================

AddClassPostConstruct("widgets/inventorybar", function(inventoryBar)
	local function cl(txt)
		local i = 1
		--txt:gsub("\n[%w%c%p%s]", function(x) i = i + 1 return x end)
		txt:gsub("\n", function(x) i = i + 1 return x end)

		if txt:sub(-1) == "\n" then
			i=i-1
		end
		return i
	end

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
	inventoryBar.actionstringbody.SetString = function(self, str)
		if not localPlayer then
			return
		end
		
		local inv_item, active_item = GetControllerSelectedInventoryItem(inventoryBar)
		local selected = inv_item or active_item

		local lineHeight = 25

		local itemInfo = RequestEntityInformation(inv_item or active_item, localPlayer, { fromInspection=true, ignore_worldly=true })

		if itemInfo then
			itemInfo = itemInfo.information
		end

		local lines = itemInfo and cl(itemInfo) or 0
		local base = lineHeight / 2

		local lineCountOffset = 1

		inventoryBar.insightText:SetString(itemInfo)
		inventoryBar.insightText:SetPosition(0, base + (lines-lineCountOffset) * lineHeight ) 

		-- the " " forces it to constantly refresh, widgets/inventorybar:879
		oldActionStringBody_SetString(self, str .. " " .. string.rep("\n ", lines))
	end
end)

--==========================================================================================================================
--==========================================================================================================================
--======================================== FollowText ======================================================================
--==========================================================================================================================
--==========================================================================================================================

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

			local itemInfo = RequestEntityInformation(target, localPlayer, { fromInspection=true, ignore_worldly=true })

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

--==========================================================================================================================
--==========================================================================================================================
--======================================== Controller Menu =================================================================
--==========================================================================================================================
--==========================================================================================================================

local InsightMenuScreen = import("screens/insightmenuscreen")
TheInput:AddControlHandler(IsDST() and CONTROL_OPEN_CRAFTING or CONTROL_OPEN_DEBUG_MENU, function(down) -- CONTROL_FOCUS_UP
	if down then
		return
	end

	if not TheInput:ControllerAttached() then
		return -- turns out caps lock inside the tab menu. whoops.
	end
		
	local screen_name = TheFrontEnd:GetActiveScreen().name

	if screen_name == "PlayerStatusScreen" or (Is_DS and screen_name == "PauseScreen") then
		TheFrontEnd.screenstack[#TheFrontEnd.screenstack]:ClearFocus()
		local sc = InsightMenuScreen()
		TheFrontEnd:PushScreen(sc)
	elseif screen_name == "InsightMenuScreen" then
		TheFrontEnd:GetActiveScreen():Close()
	else
		dprint(screen_name)
	end
end)

if IsDS() then
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

if IsDST() then
	AddClassPostConstruct("screens/playerstatusscreen", function(playerStatusScreen)
		local oldGetHelpText = playerStatusScreen.GetHelpText
		playerStatusScreen.GetHelpText = function(self)
			local str = ""
			if TheInput:ControllerAttached() then
				str = TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_OPEN_CRAFTING) .. " Insight Menu  " -- two spaces looks correct
			end

			return str .. oldGetHelpText(self)
		end
	end)
	

--[[
local function ClientToPlayer(name)
	for i,v in pairs(AllPlayers) do
		if v.name == name then
			return v
		end
	end
end
--]]

local function UpdatePlayerListing(self)
	local font_size = 16
	local listing = self.widget

	local context = localPlayer and GetPlayerContext(localPlayer)

	if not localPlayer or not context or not context.config["display_shared_stats"] then
		listing.insight_text:SetString(nil)
		return
	end

	local data = shard_players[listing.userid]
	if not data then
		listing.insight_text:SetString(nil)
		return
	end

	listing.insight_text:SetSize(font_size)

	local asd = {}

	if data.health then
		local f = ResolveColors(string.format("<icon=health> <color=HEALTH>%s</color> / <color=HEALTH>%s</color>", data.health.health, data.health.max_health))
		table.insert(asd, f)
	end

	if data.sanity then
		local str = data.sanity.lunacy and "ENLIGHTENMENT" or "SANITY"
		local f = ResolveColors(string.format("<icon=" .. str:lower() .. "> <color=" .. str .. ">%s</color> / <color=" .. str .. ">%s</color>", data.sanity.sanity, data.sanity.max_sanity))
		table.insert(asd, f)
	end

	if data.wereness and data.wereness.weremode then
		local f = ResolveColors(string.format("<icon=hunger> <color=HUNGER>%s</color> / <color=HUNGER>%s</color>", data.hunger.hunger, data.hunger.max_hunger))
		table.insert(asd, f)
	elseif data.hunger then
		local f = ResolveColors(string.format("<icon=hunger> <color=HUNGER>%s</color> / <color=HUNGER>%s</color>", data.hunger.hunger, data.hunger.max_hunger))
		table.insert(asd, f)
	end

	listing.insight_text:SetString((#asd > 0 and table.concat(asd, "\n")) or nil)
	listing.insight_text:SetPosition(listing.name:GetRegionSize() + 10, 1 + (#asd-1) * font_size/2)
end


local function PlayerStatusScreenPostInit(playerStatusScreen)
	if playerStatusScreen.__insight_init then
		return
	end

	--playerStatusScreen.__insight_init = true

	
	for i,v in pairs(playerStatusScreen.player_widgets) do -- they persistent constantly
		--[[
		local x = v.OnGainFocus
		v.OnGainFocus = function(...)
			x(...)
			mprint("ongainfocus", "playerwidget")
		end
		v.characterBadge.OnGainFocus = function(...)
			mprint("got focus! cb")
		end
		--]]

		--local char = TheNet:GetClientTableForUser()
		if v.insight_text == nil then
			v.insight_text = v.name:AddChild(RichText())
			v.inst:DoPeriodicTask(1, UpdatePlayerListing)
		end
	end
end

AddClassPostConstruct("screens/playerstatusscreen", function(playerStatusScreen)
	--[[
		parent	row_root	
[00:32:29]: characterBadge	PlayerBadge	
[00:32:29]: OnGainFocus	function: 9203CB20	
[00:32:29]: next_in_tab_order	Text - 	
[00:32:29]: mute	BUTTON	
[00:32:29]: GetHelpText	function: B0976000	
[00:32:29]: enabled	true	
[00:32:29]: userid	KU_md6wbcj2	
[00:32:29]: age	Text - 59 Days	
[00:32:29]: name	Text - 	
[00:32:29]: focus_flow	table: 87F24FD8	
[00:32:29]: number	Text - 1	
[00:32:29]: isMuted	false	
[00:32:29]: highlight	Image - images/scoreboard.xml:row_goldoutline.tex	
[00:32:29]: perf	Image - images/scoreboard.xml:host_indicator2.tex	
[00:32:29]: useractions	BUTTON	
[00:32:29]: OnLoseFocus	function: 9F5C3F40	
[00:32:29]: inst	133028 - 	
[00:32:29]: focus	false	
[00:32:29]: viewprofile	BUTTON	
[00:32:29]: children	table: 87F251E0	
[00:32:29]: focus_flow_args	table: 87F25000	
[00:32:29]: focus_target	false	
[00:32:29]: parent_scroll_list	ScrollBar	
[00:32:29]: callbacks	table: 87F24DF8	
[00:32:29]: can_fade_alpha	true	
[00:32:29]: profileFlair	rank badge	
[00:32:29]: ban	BUTTON	
[00:32:29]: adminBadge	BUTTON	
[00:32:29]: focus_forward	BUTTON	
[00:32:29]: ishost	true	
[00:32:29]: kick	BUTTON	
[00:32:29]: displayName	penguin0616	
[00:32:29]: shown	true	
	]]
	--mprint("made: playerStatusScreen", playerStatusScreen)
	--table.foreach(playerStatusScreen, mprint)

	local oldDoInit = playerStatusScreen.DoInit
	playerStatusScreen.DoInit = function(self, ...)
		oldDoInit(self, ...)
		PlayerStatusScreenPostInit(self)
	end
end)

AddClassPostConstruct("screens/chatinputscreen", function(self)
	if TheNet:GetUserID() == MyKleiID then
		--mprint"hey!!!"
	end
end)

end