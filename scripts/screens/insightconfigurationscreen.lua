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

local Widget = require "widgets/widget"
local Screen = require "widgets/screen"
local Image = require("widgets/image")
local ImageButton = require "widgets/imagebutton"
local Text = require("widgets/text")
local Spinner = require("widgets/spinner")
local TEMPLATES = IS_DST and require("widgets/redux/templates") or setmetatable({}, { __index=function(self, index) error("Templates does not exist in DS.") end })
local InsightScrollList = import("widgets/insightscrolllist")
local ITEMPLATES = import("widgets/insight_templates")
local RichText = import("widgets/RichText")

local MAIN_WINDOW_WIDTH = 480
local MAIN_WINDOW_HEIGHT = 460

local NUM_VISIBLE_ROWS = 8
local OPTION_ENTRY_WIDTH = MAIN_WINDOW_WIDTH --200
local OPTION_ENTRY_HEIGHT = 40
local OPTION_ENTRY_PADDING = 0

local function KeybindChar(k)
	if k then
		k = STRINGS.UI.CONTROLSSCREEN.INPUTS[TheInput:GetControllerID() + 1][k]
	else
		k = STRINGS.UI.CONTROLSSCREEN.INPUTS[9][2]
	end

	return k
end

--------------------------------------------------------------------------
--[[ Main Window ]]
--------------------------------------------------------------------------
local function CreateMainWindow(self)
	-- These don't cick correctly.
	--[[
	local buttons = {
		{ text = STRINGS.UI.MODSSCREEN.APPLY, cb = function() end },
		{ text = STRINGS.UI.MODSSCREEN.RESETDEFAULT, cb = function() end },
		{ text = STRINGS.UI.MODSSCREEN.BACK, cb = function() self:Close() end },
	}
	--]]

	if IS_DST then
		-- "images/misc/dialogrect_9slice_blue.xml"
		-- #2B4D76
		local t = ITEMPLATES.RectangleWindow("images/dialogrect_9slice.xml", MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT, nil, buttons) -- [gp: 619, 359]
		--[[
		for i,v in pairs(t.elements) do
			v:SetTint(.6, .6, 1, 1)
		end
		--]]
		--local r,g,b = unpack(UICOLOURS.BROWN_DARK)
		local r, g, b = unpack(RGB(55, 55, 77)) -- 43, 77, 118 is the blue of the borders
   		t:SetBackgroundTint(r, g, b, 0.8)
		return t
	else
		local w = Image("images/globalpanels.xml", "panel_long.tex")
		w:SetSize(700, 450) -- [gp: 700, 450]
		return w
	end
end

--------------------------------------------------------------------------
--[[ Scroller ]]
--------------------------------------------------------------------------
local function ConfigOptionCtor(context, index)
	--local widget = Widget("option")
	--widget.bg = widget:AddChild(TEMPLATES.ListItemBackground(OPTION_ENTRY_WIDTH, OPTION_ENTRY_HEIGHT))

	local root = Widget("option" .. index)
	root.bg = root:AddChild(ITEMPLATES.ListItemBackground(OPTION_ENTRY_WIDTH, OPTION_ENTRY_HEIGHT))

	-- This is the label describing the option.
	local labelw, labelh = OPTION_ENTRY_WIDTH * .55, OPTION_ENTRY_HEIGHT
	root.label = root:AddChild(Text(CHATFONT, 25))
	root.label:SetRegionSize(labelw, labelh)
	root.label:SetHAlign(ANCHOR_RIGHT)
	root.label:SetPosition(-OPTION_ENTRY_WIDTH/2 + labelw/2, 0)
	--[[
	root.label = root:AddChild(Image(DEBUG_IMAGE(true)))
	root.label:ScaleToSize(labelw, labelh)
	root.label:SetTint(1, .6, .6, 1)
	root.label:SetPosition(-OPTION_ENTRY_WIDTH/2 + labelw/2, 0)
	--]]

	-- This is the section label in case the thing is a section header.
	root.section_label = root:AddChild(Text(CHATFONT, 25))
	root.section_label:SetRegionSize(OPTION_ENTRY_WIDTH, OPTION_ENTRY_HEIGHT)
	


	local option_width, option_height = OPTION_ENTRY_WIDTH * .45, OPTION_ENTRY_HEIGHT
	local option_widgets = {}
	root.option_widgets = option_widgets

	-- The option widget for keybinds.
	--[[
	option_widgets.keybind = root:AddChild(Image(DEBUG_IMAGE(true)))
	option_widgets.keybind:ScaleToSize(option_width, option_height)
	option_widgets.keybind:SetTint(.6, 1, .6, 1)
	option_widgets.keybind:SetPosition(OPTION_ENTRY_WIDTH/2 - option_width/2, 0)
	--]]
	--
	option_widgets.keybind = root:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex", "spinner_focus.tex"))
	option_widgets.keybind:ForceImageSize(option_width, option_height)
	option_widgets.keybind:SetPosition(OPTION_ENTRY_WIDTH/2 - option_width/2, 0)
	option_widgets.keybind:SetTextColour(UICOLOURS.WHITE) -- GOLD_CLICKABLE
	option_widgets.keybind:SetTextFocusColour(UICOLOURS.WHITE) -- GOLD_FOCUS
	option_widgets.keybind:SetFont(CHATFONT)
	option_widgets.keybind:SetTextSize(25)
	
	-- The option widget for spinner stuff (vanilla)
	option_widgets.spinner = root:AddChild(Spinner(
		{}, option_width, option_height, {font=CHATFONT, size=25}, NIL_EDITABLE, "images/dst/global_redux.xml", NIL_TEXTURES, true
	))
	option_widgets.spinner:SetPosition(OPTION_ENTRY_WIDTH/2 - option_width/2, 0)
	option_widgets.spinner.text:SetString(" ") -- So SetHoverText will make the wrapper widget for Text.
	--root.spinner.text:SetHoverText("nil")
	--local arrow_size = root.spinner.leftimage:GetSize() * root.spinner.arrow_scale
	--root.spinner.text.hover.image:ScaleToSize(option_width-arrow_size*2, option_height)

	-- Hide the widgets until we know which one we need.
	for i,v in pairs(option_widgets) do
		v:Hide()
	end


	root:SetOnGainFocus(function()
		root.context.screen.options_scroll_list:OnWidgetFocus(root)
		root:ApplyDescription()
	end)

	root.option_widgets.spinner:SetOnChangedFn(function(selected, old)
		local option = root:GetSelectedOption()
		mprint(option.description, "|", selected, old)
		root:ApplyDescription()
		root:UpdateHoverText()
	end)


	--[[ Widget Methods ]]
	--- Sets the option type.
	root.SetOptionType = function(self, type)
		self.current_option_type = type
		for name, wdgt in pairs(self.option_widgets) do
			if name == type then
				wdgt:Show()
			else
				wdgt:Hide()
			end
		end
	end

	root.GetOptionType = function(self)
		return self.current_option_type
	end

	root.GetSelectedOption = function(self)
		local option_type = self:GetOptionType()

		if option_type == "spinner" then
			return self.data.options[self.option_widgets.spinner:GetSelectedIndex()]
		elseif option_type == "keybind" then
			return self.data
		else
			errorf("Don't know how to get selected option for option type '%s'", option_type)
		end
	end

	-- Handles bulk updates.
	root.SetData = function(self, data)
		self.data = data
		data = nil -- Enforcing use of self.data

		if not self.data then
			self:SetOptionType(nil)
			return
		end

		-- Sections logic
		local is_section_header = self.data and #self.data.options == 1 and self.data.options[1].description == ""
		self:SetIsSectionHeader(is_section_header)

		if is_section_header then
			self:SetOptionType(nil)
			return
		end

		self:SetOptionType(self.data.option_type or "spinner")

		if self:GetOptionType() == "keybind" then
			local k = self.data.saved or self.data.default or nil
			k = KeybindChar(k)

			self.option_widgets.keybind:SetText(k)
		elseif self:GetOptionType() == "spinner" then
			-- Spinner Logic
			local selected = 1
			
			local spinner_options = {}
			for i,v in ipairs(self.data.options) do
				-- If there's a saved value, check if this one is the saved one. Otherwise, check if it's the default.
				if (self.data.saved ~= nil and v.data == self.data.saved) or (v.data == self.data.default) then
					selected = i
				end
				table.insert(spinner_options, { text=v.description, data=v.data })
			end
			
			self.option_widgets.spinner:SetOptions(spinner_options)
			self.option_widgets.spinner:SetSelectedIndex(selected)
			self:UpdateHoverText()
		else
			errorf("Unrecognized option type '%s'", self:GetOptionType())
		end
	end

	root.UpdateHoverText = function(self)
		if true then return end
		self.option_widgets.spinner.text.hover.image:ScaleToSize(self.option_widgets.spinner.text:GetRegionSize())
		self.option_widgets.spinner.text:SetHoverText(self:GetSelectedOption().description)
	end
	
	root.SetIsSectionHeader = function(self, bool)
		-- Hiding the option is handled elsewhere.
		self.is_section_header = bool
		if self.is_section_header then
			self.label:Hide()
			self.section_label:Show()
			self.bg:Hide()
		else
			self.label:Show()
			self.section_label:Hide()
			self.bg:Show()
		end
	end

	root.SetLabel = function(self, text)
		if self.is_section_header then
			--self.section_label:SetColour(Color.fromHex("#ee6666"))
			self.section_label:SetString(text)
		else
			self.label:SetString((text and text .. ":") or nil)
		end
	end

	--- Updates the option info text in the menu header.
	root.ApplyDescription = function(self)
		if self.is_section_header then
			return
		end

		local current_option = self:GetSelectedOption()

		local config_description = self.data.hover
		local option_description = current_option.hover

		if self:GetOptionType() == "keybind" then
			option_description = STRINGS.UI.OPTIONS.DEFAULT .. ": " .. KeybindChar(self.data.default)
		end

		self.context.screen.config_hover:SetString(config_description)
		self.context.screen.option_hover:SetString(option_description)
	end

	--[[
	local a = root:AddChild(Image(DEBUG_IMAGE(true)))
	a:SetTint(1, .6, .6, 1)
	a:SetSize(w, h)
	a:SetPosition(-w/2, 0)

	local b = root:AddChild(Image(DEBUG_IMAGE(true))) 
	b:SetTint(.6, 1, .6, 1)
	b:SetSize(w, h)
	b:SetPosition(w/2, 0)
	--]]

	return root
end

local function UpdateEntryWidget(context, widget, data, index)
	-- Doing this in priority of importance
	--widget:SetIsSectionHeader(is_section_header)
	widget:SetData(data)
	widget.context = context

	-- Apply data
	if data then
		widget:SetLabel(data.label)
		--widget:UpdateSelected(data.saved)
	else
		widget:SetLabel(nil)
	end
end


local function CreateScroller(self)
	if IS_DST then
		return TEMPLATES.ScrollingGrid(
			self.option_widgets,
			{
				scroll_context = {
					screen = self,
					--config_hover = self.config_hover,
					--option_hover = self.option_Hover,
				},
				widget_width  = OPTION_ENTRY_WIDTH,
				widget_height = OPTION_ENTRY_HEIGHT + OPTION_ENTRY_PADDING,
				num_visible_rows = NUM_VISIBLE_ROWS,
				num_columns = 1,
				item_ctor_fn = ConfigOptionCtor,
				apply_fn = UpdateEntryWidget,
				scrollbar_offset = 20, -- 20
				scrollbar_height_offset = 0, -- -60
			}
		)
	else
		return 
	end
end

--------------------------------------------------------------------------
--[[ Screen ]]
--------------------------------------------------------------------------
local InsightConfigurationScreen = Class(Screen, function(self)
	Screen._ctor(self, "InsightConfigurationScreen")

	self.active = true
	self.owner = ThePlayer

	-- Background tint
	self.black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
	self.black.image:SetVRegPoint(ANCHOR_MIDDLE)
	self.black.image:SetHRegPoint(ANCHOR_MIDDLE)
	self.black.image:SetVAnchor(ANCHOR_MIDDLE)
	self.black.image:SetHAnchor(ANCHOR_MIDDLE)
	self.black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black.image:SetTint(0, 0, 0, .5) -- invisible, but clickable!
	self.black:SetOnClick(function() 
		self:Close()
	end)
	--self.black:SetHelpTextMessage("") -- I don't know what this does.

	-- Root Widget
	self.root = self:AddChild(Widget("ROOT"))
	self.root:SetVAnchor(ANCHOR_MIDDLE)
	self.root:SetHAnchor(ANCHOR_MIDDLE)
	self.root:SetPosition(0, 0, 0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.root:SetOnLoseFocus(function()
		self.config_hover:SetString(nil)
		self.option_hover:SetString(nil)
	end)

	-- Main Window
	self.main = self.root:AddChild(CreateMainWindow(self))
	local mainw, mainh = self.main:GetSize()
	local headerw, headerh = mainw, 100

	self.header = self.main:AddChild(Image(DEBUG_IMAGE(false)))
	--self.header:SetTint(1, 1, 1, .1)
	self.header:SetSize(headerw, headerh)
	-- Y starts at the bottom here, so [+ is up], [- is down].
	self.header:SetPosition(0, mainh/2 - headerh/2)

	self.header_label = self.header:AddChild(Text(HEADERFONT, 26))
	self.header_label:SetString(KnownModIndex:GetModFancyName(modname) .. " " ..STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX)
	self.header_label:SetPosition(0, headerh/2 - self.header_label:GetSize()/2 - 4) -- 4 pixels of padding from the top
	self.header_label:SetColour(UICOLOURS.GOLD)

	self.config_hover = self.header:AddChild(Text(CHATFONT, 18)) -- The hover for the entire configuration entry
	self.config_hover:SetPosition(0, self.header_label:GetPosition().y - self.header_label:GetSize()/2 - self.config_hover:GetSize()/2 - 10) -- 20 pixels of padding
	--self.config_hover:SetString("CONFIGURATION ENTRY HOVER")
	
	self.option_hover = self.header:AddChild(Text(CHATFONT, 18)) -- The hove for the selected option in the config
	self.option_hover:SetPosition(0, -headerh/2 + self.option_hover:GetSize()/2)
	--self.option_hover:SetString("OPTION HOVER")

	self.divider = self.main:AddChild(Image("images/dst/global_redux.xml", "item_divider.tex"))
	self.divider:SetSize(mainw + 20, 5)
	self.divider:SetPosition(0, self.header:GetPosition().y - headerh/2 - 5)

	self.option_widgets = {}

	local leftover_space = mainh - select(2, self.header:GetSize()) - select(2, self.divider:GetSize())

	-- context, create_widgets_fn, update_fn, scissor_x, scissor_y, scissor_width, scissor_height, scrollbar_offset, scrollbar_height_offset, scroll_per_click
	
	local scroller_height = (OPTION_ENTRY_HEIGHT + OPTION_ENTRY_PADDING) * NUM_VISIBLE_ROWS

	self.options_scroll_list = self.main:AddChild(CreateScroller(self))
	--self.options_scroll_list.bg:SetTexture(DEBUG_IMAGE(true))
	--self.options_scroll_list.bg:SetTint(1, 1, 1, .1)
	self.options_scroll_list.bg:ScaleToSize(OPTION_ENTRY_WIDTH, scroller_height)
	--self.options_scroll_list:SetPosition(0, -mainh/2 + scroller_height/2) -- Not perfect unless using 7 rows with total row height = 80.
	self.options_scroll_list:SetPosition(0, self.divider:GetPosition().y - scroller_height/2 - (leftover_space - scroller_height) / 2) -- Not perfect unless using 7 rows with total row height = 80.
	

	-- Load mod options
	self.config_options = {}
	self:PopulateConfigKeybinds(self.config_options)
	self:LoadModConfig(true)
	self.options_scroll_list:SetItemsData(self.config_options)

	--self.options_scroll_list:RefreshView()
	--[[
	self.options_scroll_list = self.main:AddChild(TEMPLATES.ScrollingGrid(
		self.optionwidgets,
		{
			scroll_context = {},
			widget_width  = OPTION_ENTRY_WIDTH,
			widget_height = OPTION_ENTRY_HEIGHT,
			num_visible_rows = 8,
			num_columns = 1,
			item_ctor_fn = ConfigOptionCtor,
			apply_fn = UpdateEntryWidget,
			scrollbar_offset = 20,
			scrollbar_height_offset = -60
		}
	))
	
	local scroller_height = OPTION_ENTRY_HEIGHT * 8
	self.options_scroll_list:SetPosition(0, -mainh/2 + scroller_height/2 + OPTION_ENTRY_HEIGHT/2)
	--]]

	--[[
	self.scroll_list = self.main:AddChild(InsightPage("modconfig", true))
	self.scroll_list:SetSize(mainw, mainh - headerh - select(2, self.divider:GetSize()) - 5)
	--]]
end)

function InsightConfigurationScreen:LoadModConfig(client)
	assert(client ~= nil, "LoadModConfig requires client boolean")

	self.client_config = client
	self.raw_config_options = KnownModIndex:LoadModConfigurationOptions(modname, self.client_config)
	local mod_is_client_only = KnownModIndex:GetModInfo(modname) and KnownModIndex:GetModInfo(modname).client_only_mod

	if self.raw_config_options and type(self.raw_config_options) == "table" then
		for i,v in ipairs(self.raw_config_options) do
			if (v.client and self.client_config) or not v.client then
				table.insert(self.config_options, v)
			end
			--[[
			if ((self.client_config or mod_is_client_only) and (v.client == nil or v.client == true)) or -- Client side options
				(v.client == nil or v.client == false) -- Server side options
			then
				table.insert(self.config_options, v)
			end
			--]]
		end
	end
end

function InsightConfigurationScreen:PopulateConfigKeybinds(tbl)
	if not insightSaveData:IsReady() then
		mprint("Unable to load keybind information.")
		return {}
	end

	local list = {}
	for name, data in pairs(keybinds.keybinds) do
		local key = keybinds:GetKey(name)
		list[#list+1] = { 
			name = name, 
			label = name, 
			hover = data.description, 
			options = {}, 
			saved = key, 
			default = keybinds:GetDefaultKey(name), 
			option_type = "keybind" 
		}
	end

	table.sort(list, function(a, b) return a.label < b.label end)

	table.insert(tbl, {
		name = "KEYBINDS",
		label = "Keybinds", 
		options = {{description = "", data = 0}},
		default = 0,
		tags = {"ignore"},
		option_type = "keybind",
	})

	for i = 1, #list do
		table.insert(tbl, list[i])
	end
end

--- Creates a "clean" mod config table for saving.
function InsightConfigurationScreen:CollectSettings()
	
end

function InsightConfigurationScreen:Apply()
	
end


function InsightConfigurationScreen:ResetToDefaultValues()
	
end

function InsightConfigurationScreen:OnControl(control, down)
	--mprint("InsightConfigurationScreen", controlHelper.Prettify(control), down)

	local scheme = controlHelper.GetCurrentScheme()
	if not down and scheme:IsAcceptedControl("exit", control) then
		return self:Close()
	end

	return self._base.OnControl(self, control, down)
end

function InsightConfigurationScreen:Close()
	TheFrontEnd:PopScreen(self)
end

return InsightConfigurationScreen