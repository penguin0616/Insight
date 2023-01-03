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
local PopupDialogScreen = IS_DST and require("screens/redux/popupdialog") or require("screens/popupdialog")
local TEMPLATES = IS_DST and require("widgets/redux/templates") or setmetatable({}, { __index=function(self, index) error("Templates does not exist in DS.") end })
local InsightScrollList = import("widgets/insightscrolllist")
local ITEMPLATES = import("widgets/insight_templates")
local RichText = import("widgets/RichText")
local ListBox = import("widgets/listbox")
local InsightPresetScreen = import("screens/insightpresetscreen")

--[[
REGISTER_HOT_RELOAD({"widgets/listbox"}, function(imports) 
	ListBox = imports.listbox
end)

REGISTER_HOT_RELOAD({"widgets/insightscrolllist"}, function(imports) 
	InsightScrollList = imports.insightscrolllist
end)
--]]

local MAIN_WINDOW_WIDTH = 580 -- 480
local MAIN_WINDOW_HEIGHT = 480

local HEADER_HEIGHT = 120

local NUM_VISIBLE_ROWS = 8
local OPTION_ENTRY_WIDTH = MAIN_WINDOW_WIDTH --200
local OPTION_ENTRY_HEIGHT = 40
local OPTION_ENTRY_PADDING = 0

local function KeybindChar(k)
	if k then
		k = STRINGS.UI.CONTROLSSCREEN.INPUTS[TheInput:GetControllerID() + 1][k]
		if k == nil then
			k = STRINGS.UI.CONTROLSSCREEN.INPUTS[TheInput:GetControllerID() + 1][0]
		end
	else
		if IS_DST then
			k = STRINGS.UI.CONTROLSSCREEN.INPUTS[9][2]
		else
			k = STRINGS.UI.CONTROLSSCREEN.INPUTS[6][2]
		end
	end

	return k
end

--------------------------------------------------------------------------
--[[ Main Window ]]
--------------------------------------------------------------------------
local function CreateMainWindow(self)
	-- These don't cick correctly.
	local buttons = {
		{ text = STRINGS.UI.MODSSCREEN.APPLY, cb = function() self:ApplyChanges() end },
		{ text = STRINGS.UI.MODSSCREEN.RESETDEFAULT, cb = function() self:ResetToDefaultValues() end },
		{ text = STRINGS.UI.HELP.BACK, cb = function() self:Close() end }, -- (IS_DST and STRINGS.UI.MODSSCREEN.BACK) or STRINGS.UI.MODSSCREEN.CANCEL
	}

	if TheInput:ControllerAttached() then
		buttons = nil
	end

	if true or IS_DST then
		-- "images/misc/dialogrect_9slice_blue.xml"
		-- #2B4D76
		local t = ITEMPLATES.RectangleWindow("images/dst/dialogrect_9slice.xml", MAIN_WINDOW_WIDTH, MAIN_WINDOW_HEIGHT, nil, buttons) -- [gp: 619, 359]
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
	setmetatable(root, {
		__index = getmetatable(root).__index,
		__newindex = getmetatable(root).__newindex,
		__call = getmetatable(root).__call,
		__tostring = function(self)
			return Widget.__tostring(self) .. " - " .. string.format("[%s] %s = %s", 
				self.is_section_header and "S" or "C", 
				self.is_section_header and self.section_label:GetText() or self.label:GetString(), 
				self.is_section_header and "" or tostring(self.data.saved)
			)
		end,
	})

	root.bg = root:AddChild(ITEMPLATES.ListItemBackground(OPTION_ENTRY_WIDTH, OPTION_ENTRY_HEIGHT))

	-- This is the label describing the option.
	local labelw, labelh = OPTION_ENTRY_WIDTH * .55, OPTION_ENTRY_HEIGHT
	root.label = root:AddChild(Text(CHATFONT, 25))
	root.label:SetRegionSize(labelw, labelh)
	root.label:SetHAlign(ANCHOR_RIGHT)
	root.label:SetPosition(-OPTION_ENTRY_WIDTH/2 + labelw/2, 0)
	root.label:Hide()
	--[[
	root.label = root:AddChild(Image(DEBUG_IMAGE(true)))
	root.label:ScaleToSize(labelw, labelh)
	root.label:SetTint(1, .6, .6, 1)
	root.label:SetPosition(-OPTION_ENTRY_WIDTH/2 + labelw/2, 0)
	--]]

	-- This is the section label in case the thing is a section header.
	--root.section_label = root:AddChild(Text(CHATFONT, 25))
	--root.section_label:SetRegionSize(OPTION_ENTRY_WIDTH, OPTION_ENTRY_HEIGHT)
	---- "images/dst/frontend_redux.xml", "serverlist_listitem_normal.tex", "serverlist_listitem_selected.tex"
	root.section_label = root:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex")) 
	root.section_label.control = nil
	root.section_label.GetHelpText = function() return end
	root.section_label.scale_on_focus = false
	root.section_label:ForceImageSize(OPTION_ENTRY_WIDTH, OPTION_ENTRY_HEIGHT)
	root.section_label:SetTextColour(UICOLOURS.WHITE)
	root.section_label:SetTextFocusColour(UICOLOURS.GOLD_FOCUS)
	--root.section_label:SetTextSelectedColour(root.section_label.textcolour)
	--root.section_label:SetTextDisabledColour(root.section_label.textcolour)
	root.section_label:SetFont(CHATFONT)
	root.section_label:SetTextSize(25)
	root.section_label:Hide()

	local option_width, option_height = OPTION_ENTRY_WIDTH * .45, OPTION_ENTRY_HEIGHT
	local option_widgets = {}
	root.option_widgets = option_widgets

	-- The option widget for listboxes.
	option_widgets.listbox = root:AddChild(ListBox({
		width = option_width,
		option_height = option_height, 
		num_visible_rows = 4,
		scroller = {
			width = 15
		}
	}))
	option_widgets.listbox:SetPosition(OPTION_ENTRY_WIDTH/2 - option_width/2, 0)

	-- The option widget for keybinds.
	--[[
	option_widgets.keybind = root:AddChild(Image(DEBUG_IMAGE(true)))
	option_widgets.keybind:ScaleToSize(option_width, option_height)
	option_widgets.keybind:SetTint(.6, 1, .6, 1)
	option_widgets.keybind:SetPosition(OPTION_ENTRY_WIDTH/2 - option_width/2, 0)
	--]]
	--
	option_widgets.keybind = root:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex", "spinner_focus.tex"))
	option_widgets.keybind.scale_on_focus = false
	option_widgets.keybind:ForceImageSize(option_width, option_height)
	option_widgets.keybind:SetPosition(OPTION_ENTRY_WIDTH/2 - option_width/2, 0)
	option_widgets.keybind:SetTextColour(UICOLOURS.WHITE) -- GOLD_CLICKABLE
	option_widgets.keybind:SetTextFocusColour(UICOLOURS.WHITE) -- GOLD_FOCUS
	option_widgets.keybind:SetTextDisabledColour(Color.fromHex(Insight.COLORS.MOB_SPAWN))
	option_widgets.keybind:SetFont(CHATFONT)
	option_widgets.keybind:SetDisabledFont(CHATFONT)
	option_widgets.keybind:SetTextSize(25)
	option_widgets.keybind:SetOnClick(function()
		if not root.data then
			return
		end

		context.screen:MapControl(root.data)
	end)
	
	-- The option widget for spinner stuff (vanilla)
	option_widgets.spinner = root:AddChild(Spinner(
		{}, option_width, option_height, {font=CHATFONT, size=25}, NIL_EDITABLE, IS_DST and "images/global_redux.xml" or nil, NIL_TEXTURES, true
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

	--[[
	root.section_label.OnGainFocus = function(self)
		self._base.OnGainFocus(self)
	end

	root.section_label.OnLoseFocus = function(self)
		--mprint("SectionLabel::OnLoseFocus ---------------")
		--mprint(debugstack())
		self._base.OnLoseFocus(self)
	end
	--]]

	root:SetOnGainFocus(function()
		--mprint('gain0', root.focus)
		if not root.data then
			return
		end
		
		--mprint('gain', root.data.label)
		if not root.is_section_header then
			root.label:SetColour(UICOLOURS.GOLD_FOCUS)
		end

		root.context.screen.options_scroll_list:OnWidgetFocus(root)
		root:ApplyDescription()

		root:MoveToFront()
	end)

	root:SetOnLoseFocus(function()
		if not root.data then
			return
		end
		
		--mprint('lose', root.data.label)
		if not root.is_section_header then
			root.label:SetColour(UICOLOURS.WHITE)
		end
	end)

	----------------------------------------------------------------------------------------------
	root.option_widgets.listbox:SetOnChangedFn(function(data, old)
		context.screen:ChangeSetting(root.data, root.option_widgets.listbox:GetSelectedOptionsDataOnly())
	end)

	root.option_widgets.spinner:SetOnChangedFn(function(selected, old)
		--local option = root:GetSelectedOption()
		--mprint(option.description, "|", selected, old)
		--mprint(root.data.label, root.data.saved, "|", old, "->", selected)
		context.screen:ChangeSetting(root.data, selected)
		--mprint(root.data.label, "222222|", root.data.saved, "|", old, "->", selected)

		root:ApplyDescription()
		root:UpdateHoverText()
	end)


	--[[ Widget Methods ]]
	--- Sets the option type.
	root.SetConfigType = function(self, type)
		self.current_config_type = type
		self.focus_forward = nil
		for name, wdgt in pairs(self.option_widgets) do
			if name == type then
				wdgt:Show()
				self.focus_forward = wdgt -- The actual option thing should be focused
			else
				wdgt:Hide()
			end
		end
		
		--[[
		if type == "listbox" then
			self:MoveToFront()
		else
			self:MoveToBack()
		end
		--]]
	end

	root.GetConfigType = function(self)
		return self.current_config_type
	end

	root.GetSelectedOption = function(self)
		local config_type = self:GetConfigType()

		if config_type == "spinner" then
			return self.data.options[self.option_widgets.spinner:GetSelectedIndex()]
		elseif config_type == "keybind" then
			--return self.data
		elseif config_type == "listbox" then
			--return self.data
		else
			errorf("Don't know how to get selected option for option type '%s'", tostring(config_type))
		end
	end

	-- Handles bulk updates.
	root.SetData = function(self, data)
		self.data = data
		data = nil -- Enforcing use of self.data

		if not self.data then
			self:SetConfigType(nil)
			return
		end

		-- Sections logic
		if self.data.options == nil and self.data["_"] then
			-- This means it's likely an empty AddSectionTitle from modinfo in DS.
			setmetatable(self.data, { __index=self.data["_"], __newindex=self.data["_"] })
		end
		
		local is_section_header = self.data and #self.data.options == 1 and self.data.options[1].description == ""
		self:SetIsSectionHeader(is_section_header)

		if is_section_header then
			return
		end

		self:SetConfigType(self.data.config_type or "spinner")

		if self:GetConfigType() == "listbox" then
			local using = self.data.saved or self.data.default

			local listbox_options = {}
			
			for i,v in ipairs(self.data.options) do
				local opt = {text=v.description, data=v.data, selected=table.contains(using, v.data)}
				if table.contains(self.data.tags, "richtext") then
					opt.text = ProcessRichTextPlainly(opt.text)
				end
				listbox_options[#listbox_options+1] = opt
			end

			self.option_widgets.listbox:SetData(listbox_options)
		elseif self:GetConfigType() == "keybind" then
			local k = self.data.saved or self.data.default or nil
			k = KeybindChar(k)
			self.option_widgets.keybind:SetText(k)

			if TheInput:ControllerAttached() then
				self.option_widgets.keybind:Disable() -- Should this be a Select?
			else
				self.option_widgets.keybind:Enable()
			end
		elseif self:GetConfigType() == "spinner" then
			-- Spinner Logic
			local selected = 1
			
			local spinner_options = {}
			for i,v in ipairs(self.data.options) do
				-- If there's a saved value, check if this one is the saved one. Otherwise, check if it's the default.
				if (self.data.saved ~= nil and v.data == self.data.saved) or (self.data.saved == nil and v.data == self.data.default) then
					selected = i
				end
				table.insert(spinner_options, { text=v.description, data=v.data })
			end
			
			self.option_widgets.spinner:SetOptions(spinner_options)
			self.option_widgets.spinner:SetSelectedIndex(selected)
			self:UpdateHoverText()
		else
			errorf("Unrecognized option type '%s'", self:GetConfigType())
		end

		if self.focus then
			self:ApplyDescription()
		end
	end

	root.UpdateHoverText = function(self)
		--self.option_widgets.spinner.text.hover.image:ScaleToSize(self.option_widgets.spinner.text:GetRegionSize())
		--self.option_widgets.spinner.text:SetHoverText(self:GetSelectedOption().description)
	end
	
	root.SetIsSectionHeader = function(self, bool)
		self.is_section_header = bool
		if self.is_section_header then
			self:SetConfigType(nil)
			self.focus_forward = self.section_label
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
			if self.section_label:is_a(Text) then
				self.section_label:SetString(text)
			elseif self.section_label:is_a(ImageButton) then
				self.section_label:SetText(text)
			else
				error("Unable to update section_label")
			end
		else
			self.label:SetString((text and text .. ":") or nil)
		end
	end

	--- Updates the option info text in the menu header.
	root.ApplyDescription = function(self)
		if self.is_section_header then
			self.context.screen.config_hover:SetString(nil)
			self.context.screen.option_hover:SetString(nil)
			return
		end

		local current_option = self:GetSelectedOption()

		local config_description = self.data.hover -- The description of the entire configuration (config.hover)
		local option_description = nil -- The option hover (config.options[n].hover)

		if self:GetConfigType() == "keybind" then
			option_description = STRINGS.UI.OPTIONS.DEFAULT .. ": " .. KeybindChar(self.data.default)
		elseif self:GetConfigType() == "listbox" then
			local default_summary = {} -- table.concat(self.data.default, ", ")
			local lookup = table.invert(self.data.default)

			for i,v in ipairs(self.data.options) do
				if lookup[v.data] then
					default_summary[#default_summary+1] = v.description
				end
			end

			default_summary = table.concat(default_summary, ", ")
			if table.contains(self.data.tags, "richtext") then
				default_summary = ProcessRichTextPlainly(default_summary)
			end

			option_description = STRINGS.UI.OPTIONS.DEFAULT .. ": " .. default_summary
		else
			option_description = current_option.hover
		end

		self.context.screen.config_hover:SetString(config_description)
		--self.context.screen.option_hover:SetString(option_description)
		if option_description then
			local w = self.context.screen.header:GetSize()
			self.context.screen.option_hover:SetMultilineTruncatedString(option_description, 2, w, nil_max_chars, true)
		else
			self.context.screen.option_hover:SetString(nil)
		end
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
	--if IS_DST then
	if false then
		-- ScrollingGrid with its Scissor Shenanigans doesn't work well for widgets that would extend past the bounds
		-- Ie ListBox. But even with cleared scissor, the focus doesn't work right.
		-- So I guess I'll be using the InsightScrollList for both!
		return TEMPLATES.ScrollingGrid(
			{},
			{
				scroll_context = {
					screen = self,
					--config_hover = self.config_hover,
					--option_hover = self.option_Hover,
				},
				widget_width = OPTION_ENTRY_WIDTH,
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
		return InsightScrollList(
			{
				scroll_context = {
					screen = self,
				},
				widget_width = OPTION_ENTRY_WIDTH,
				widget_height = OPTION_ENTRY_HEIGHT,
				row_padding = OPTION_ENTRY_PADDING,
				num_visible_rows = NUM_VISIBLE_ROWS,
				--num_columns = 1,
				item_ctor_fn = ConfigOptionCtor,
				apply_fn = UpdateEntryWidget,
				--scrollbar_offset = 20, -- 20
				--scrollbar_height_offset = 0, -- -60
			}
		)
	end
end

--------------------------------------------------------------------------
--[[ Screen ]]
--------------------------------------------------------------------------
local InsightConfigurationScreen = Class(Screen, function(self)
	Screen._ctor(self, "InsightConfigurationScreen")

	self.modname = modname
	self.active = true
	self.dirty_changes = {}
	self.owner = localPlayer

	-- Background tint
	self.black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
	self.black:SetControl(CONTROL_PRIMARY) -- Control is unchanging, but makes the clicker mouseonly.
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
	local headerw, headerh = mainw, HEADER_HEIGHT

	self.header = self.main:AddChild(Image(DEBUG_IMAGE(false)))
	--self.header:SetTint(1, 1, 1, .1)
	self.header:SetSize(headerw, headerh)
	-- Y starts at the bottom here, so [+ is up], [- is down].
	self.header:SetPosition(0, mainh/2 - headerh/2)

	-- Header label stating modname and configuration
	self.header_label = self.header:AddChild(Text(HEADERFONT, 26))
	self:UpdateHeader()
	self.header_label:SetPosition(0, headerh/2 - self.header_label:GetSize()/2 - 4) -- 4 pixels of padding from the top
	self.header_label:SetColour(UICOLOURS.GOLD)
	
	local presetw, preseth = 120, 40
	local prefix = GetReduxButtonPrefix({presetw, preseth})
	self.preset_button = self.header:AddChild(ImageButton("images/dst/global_redux.xml", prefix.."_normal.tex", prefix.."_hover.tex", prefix.."_disabled.tex", prefix.."_down.tex"))
	self.preset_button.scale_on_focus = false
	self.preset_button.move_on_click = false
	self.preset_button:ForceImageSize(presetw, preseth)
	self.preset_button:SetPosition(self.header_label:GetPosition() + Vector3(headerw/2 - 60))
	self.preset_button:SetText("Presets")
	self.preset_button:SetTextSize(25)
	self.preset_button:SetFont(UIFONT)
	self.preset_button:SetTextColour(UICOLOURS.WHITE) -- GOLD_CLICKABLE
	self.preset_button:SetTextFocusColour(UICOLOURS.WHITE) -- GOLD_FOCUS
	self.preset_button.text:SetPosition(0, -2)
	--self.preset_button:SetImageNormalColour(1, 1, 1, .1)
	--self.preset_button:SetImageFocusColour(.5, .5, 1, .5)
	self.preset_button:SetOnClick(function()
		local scr = InsightPresetScreen(GetPlayerContext(self.owner), self.modname)
		scr:SetOnApplyFn(function()
			self:Close(true)
		end)
		TheFrontEnd:PushScreen(scr)
	end)
	
	
	--[[
	self.preset_button:SetHoverText("Presets")
	
	self.preset_button.icon = self.preset_button:AddChild(Image("images/loading_screen_icons.xml", "icon_tooltips.tex"))
	self.preset_button.icon:ScaleToSize(self.preset_button.size_x, self.preset_button.size_y)
	--]]
	--self.preset_button.icon:SetPosition(1, 0)


	-- Config Hover label
	self.config_hover = self.header:AddChild(Text(CHATFONT, 18)) -- The hover for the entire configuration entry
	self.config_hover:SetPosition(0, self.header_label:GetPosition().y - self.header_label:GetSize()/2 - self.config_hover:GetSize()/2 - 10) -- 20 pixels of padding
	--self.config_hover:SetString("CONFIGURATION ENTRY HOVER")
	
	-- Option hover label
	self.option_hover = self.header:AddChild(Text(CHATFONT, 18)) -- The hover for the selected option in the config
	self.option_hover:SetPosition(0, -headerh/2 + self.option_hover:GetSize()/2 + 10)
	--self.option_hover:SetString("OPTION HOVER")

	self.divider = self.main:AddChild(Image("images/dst/global_redux.xml", "item_divider.tex"))
	self.divider:SetSize(mainw + 20, 5)
	self.divider:SetPosition(0, self.header:GetPosition().y - headerh/2 - 5)

	local leftover_space = mainh - select(2, self.header:GetSize()) - select(2, self.divider:GetSize())

	-- context, create_widgets_fn, update_fn, scissor_x, scissor_y, scissor_width, scissor_height, scrollbar_offset, scrollbar_height_offset, scroll_per_click
	
	local scroller_height = (OPTION_ENTRY_HEIGHT + OPTION_ENTRY_PADDING) * NUM_VISIBLE_ROWS

	self.options_scroll_list = self.main:AddChild(CreateScroller(self))
	--self.options_scroll_list.bg:SetTexture(DEBUG_IMAGE(true))
	--self.options_scroll_list.bg:SetTint(.6, 1, .6, 1)
	--if self.options_scroll_list:is_a(InsightScrollList) then self.options_scroll_list:RecalculateSize() else self.options_scroll_list.bg:ScaleToSize(OPTION_ENTRY_WIDTH, scroller_height) end 
	--self.options_scroll_list:SetPosition(0, -mainh/2 + scroller_height/2) -- Not perfect unless using 7 rows with total row height = 80.
	self.options_scroll_list:SetPosition(0, self.divider:GetPosition().y - scroller_height/2 - (leftover_space - scroller_height) / 2) -- Not perfect unless using 7 rows with total row height = 80.

	-- Load mod options
	self.config_options = {}
	self.client_config = true
	self:PopulateKeybinds(self.config_options)
	self:LoadModConfig()
	self.options_scroll_list:SetItemsData(self.config_options)
	-- 93 items
	self.options_scroll_list.scroll_per_click = math.max(math.floor(NUM_VISIBLE_ROWS/4), 1)

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

	self:SetDirty(false)
	self.default_focus = self.options_scroll_list

	self.options_scroll_list:SetFocusChangeDir(MOVE_UP, self.preset_button)
	self.preset_button:SetFocusChangeDir(MOVE_DOWN, self.options_scroll_list)

	self.force_exit_listener = ClientCoreEventer:ListenForEventOnce("force_insightui_exit", function()
		self:Close(true)
	end)
end)

function InsightConfigurationScreen:UpdateHeader(ending)
	self.header_label:SetString(
		string.format("%s %s%s", KnownModIndex:GetModFancyName(self.modname), STRINGS.UI.MODSSCREEN.CONFIGSCREENTITLESUFFIX, ending or "")
	)
end

function InsightConfigurationScreen:LoadModConfig() 
	assert(self.client_config ~= nil, "LoadModConfig requires client boolean")
	assert(self.client_config == true, "InsightConfigurationScreen only supports loading client config as true.")
	local mod_is_client_only = KnownModIndex:GetModInfo(self.modname) and KnownModIndex:GetModInfo(self.modname).client_only_mod

	self.raw_complex_options = LoadComplexConfiguration()
	if self.raw_complex_options and type(self.raw_complex_options) == "table" then
		for i,v in ipairs(self.raw_complex_options) do
			if (v.client and self.client_config) or not v.client then
				table.insert(self.config_options, v)
			end
		end
	end

	self.raw_config_options = KnownModIndex:LoadModConfigurationOptions(self.modname, self.client_config)

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

function InsightConfigurationScreen:PopulateKeybinds(tbl)
	if not insightSaveData:IsReady() then
		mprint("Unable to load keybind information.")
		return {}
	end

	if not self.client_config then
		mprint("Non-client config can't load keybinds.")
		return
	end

	local list = {}
	for name, data in pairs(insightKeybinds:GetKeybinds()) do
		local key = insightKeybinds:GetKey(name)
		list[#list+1] = { 
			name = name, 
			label = data.pretty_name,
			hover = data.description, 
			options = {}, 
			saved = key, 
			default = insightKeybinds:GetDefaultKey(name), 
			config_type = "keybind",
		}
	end

	table.sort(list, function(a, b) return a.label < b.label end)

	table.insert(tbl, {
		name = "KEYBINDS",
		label = GetPlayerContext(self.owner).lstr.keybinds.label, 
		options = {{description = "", data = 0}},
		saved = 0,
		default = 0,
		tags = {"ignore"},
		config_type = "keybind",
	})

	for i = 1, #list do
		table.insert(tbl, list[i])
	end
end

--- Prompts user to change config.
-- @tparam config Config_Entry
function InsightConfigurationScreen:MapControl(config)
	local default_text = string.format(STRINGS.UI.CONTROLSSCREEN.DEFAULT_CONTROL_TEXT, KeybindChar(config.default))
	local body_text = STRINGS.UI.CONTROLSSCREEN.CONTROL_SELECT .. "\n\n" .. default_text

	local popup = PopupDialogScreen(config.label, body_text, {
		{ text=STRINGS.UI.CONTROLSSCREEN.CANCEL, cb=function() TheFrontEnd:PopScreen() end },
		{ 
			text=GetLocalInsight(self.owner).context.lstr.unbind, -- STRINGS.UI.CONTROLSSCREEN.UNBIND
			cb=function() 
				dprint("unbind")
				self:ChangeSetting(config, nil)
				self.options_scroll_list:RefreshView()
				TheFrontEnd:PopScreen()
			end
		},
		{ 
			text=STRINGS.UI.MODSSCREEN.RESETDEFAULT, 
			cb=function() 
				dprint("reset")
				self:ChangeSetting(config, config.default)
				self.options_scroll_list:RefreshView()
				TheFrontEnd:PopScreen()
			end
		},
	})

	local function IsValidKey(key)
		if KeybindChar(key) == nil then
			error("pcall error")
		end
	end

	-- Prevents Escape from Triggering Unbind
	popup.oncontrol_fn = function() return true end

	popup.OnRawKey = function(_, key, down)
		-- Only check if the key has gone up
		if down then return end
		-- While I technically support anything in the inputs section, we'll pass on that for now.
		local a, b = pcall(string.char, key)
		local valid = pcall(IsValidKey, key)
		dprint("popup OnRawKey", key, a, b, "| valid:", valid, valid and KeybindChar(key) or nil)

		if valid then
			dprint("\tVALID!")
			self:ChangeSetting(config, key)
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self.options_scroll_list:RefreshView()
			TheFrontEnd:PopScreen()
		end
		
		return true
	end

	TheFrontEnd:PushScreen(popup)
end

function InsightConfigurationScreen:IsDirty()
	return self.dirty
end

function InsightConfigurationScreen:SetDirty(dirty)
	if self.dirty ~= dirty then
		self.dirty = dirty
		self:OnDirtyChanged(dirty)
	end
end

function InsightConfigurationScreen:OnDirtyChanged(dirty)
	--mprint("OnDirtyChanged", dirty)
	-- Check to make sure we have the buttons (aka no controller when screen launched)
	if not self.main.actions then
		return
	end

	for widget in pairs(self.main.actions:GetChildren()) do
		if widget.text and widget.text:GetString() == STRINGS.UI.MODSSCREEN.APPLY then
			if dirty == true then widget:Enable() else widget:Disable() end
			break
		end
	end
end

function InsightConfigurationScreen:ChangeSetting(data, new)
	--mprintf("ChangeSetting (%s): %s -> %s | Default: %s", data.label, tostring(data.saved), tostring(new), tostring(data.default))

	-- Check to make sure that data has actually changed.
	-- No point in updating data with the same thing. 
	if deepcompare(data.saved, new) then
		return
	end

	--mprintf("ChangeSetting ~~~ (%s): %s -> %s | Default: %s", data.label, tostring(data.saved), tostring(new), tostring(data.default))

	local old_saved = data.saved
	if old_saved == nil then
		old_saved = data.default
	end

	-- Using data as a key so dirty changes always overwrite previous dirty changes.
	-- Of course, that means we need to handle that case.
	if self.dirty_changes[data] ~= nil then
		-- Bring the oldest saved option forward.
		old_saved = self.dirty_changes[data].old
	end

	if deepcompare(old_saved, new) then
		self.dirty_changes[data] = nil
		data.saved = old_saved

		self:SetDirty(next(self.dirty_changes) ~= nil)
	else
		self:SetDirty(true)
		self.dirty_changes[data] = { old=old_saved, new=new }
		data.saved = new
	end
end

function InsightConfigurationScreen:DiscardChanges()
	if not self:IsDirty() then
		return
	end

	for data, change_info in pairs(self.dirty_changes) do
		data.saved = change_info.old
	end

	self.dirty_changes = {}
	self:SetDirty(false)
end

function InsightConfigurationScreen:ApplyChanges(callback)
	if not self:IsDirty() then
		if callback then
			callback(true, true)
		end
		return 
	end

	local settings = self:CollectSettings()
	
	-- Do keybind settings
	for i,v in pairs(settings.keybind) do
		if v.tags == nil or not table.contains(v.tags, "ignore") then
			insightSaveData:SetDirty(true)
			insightSaveData:Get("keybinds")[v.name] = v.saved
			insightKeybinds:ChangeKey(v.name, v.saved)
		end
	end
	insightSaveData:Save()
	settings.keybind = nil

	-- Do listbox settings
	for i,v in pairs(settings.listbox) do
		if v.tags == nil or not table.contains(v.tags, "ignore") then
			insightSaveData:SetDirty(true)
			insightSaveData:Get("configuration_options")[v.name] = v.saved
		end
	end
	insightSaveData:Save()
	settings.listbox = nil

	-- Do vanilla settings

	-- For DS, I have to reparse the data into a clean version since SaveConfigurationOptions is datadumping with slow mode.
	-- Needs to be clean because I modify the data with setmetatable for section headers in DS.
	local modconfigdata = settings.modconfig
	if IS_DS then
		local str = DataDumper(settings.modconfig, nil, true)
		modconfigdata = loadstring(str)()
	end

	KnownModIndex:SaveConfigurationOptions(function()
		--[[
		UpdateHeader(" (Saved!)")
		if self._headertask then
			self._headertask:Cancel()
			self._headertask = nil
		end
		--]]
	end, self.modname, modconfigdata, self.client_config)
	settings.modconfig = nil

	-- Check if I missed anything.
	if next(settings) ~= nil then
		errorf("ApplyChanges doesn't know how to save unknown type '%s'", next(settings))
	end

	self.dirty_changes = {}
	self:SetDirty(false)

	ClientCoreEventer:PushEvent("configuration_update")

	if callback then
		-- Settings, Keybinds
		callback(true, true)
	end
end

function InsightConfigurationScreen:CollectSettings()
	local settings = {}

	for i,v in ipairs(self.config_options) do
		local config_type = v.config_type or "modconfig"
		if settings[config_type] == nil then
			settings[config_type] = {}
		end

		table.insert(settings[config_type], v)
	end

	return settings
end

function InsightConfigurationScreen:ResetToDefaultValues()
	local settings = self:CollectSettings()
	
	for type, configs in pairs(settings) do
		for i,v in pairs(configs) do
			if not table.contains(v.tags, "ignore") then
				self:ChangeSetting(v, v.default)
			end
		end
		self.options_scroll_list:RefreshView()
	end
end

function InsightConfigurationScreen:Close(forced)
	if self:IsDirty() then
		if forced then
			-- We should only update configs if we've received a definite confirmation.
			self:DiscardChanges()
			self:Close(true)
			return
		end

		local popup = PopupDialogScreen(STRINGS.UI.MODSSCREEN.BACKTITLE, STRINGS.UI.MODSSCREEN.BACKBODY, {
		  	{
		  		text = STRINGS.UI.OPTIONS.YES,
		  		cb = function()
					self:DiscardChanges()
					TheFrontEnd:PopScreen()
					self:Close(true)
				end
			},
			{
				text = STRINGS.UI.OPTIONS.NO,
				cb = function()
					TheFrontEnd:PopScreen()
				end
			}
		})

		TheFrontEnd:PushScreen(popup)
	else
		if self.force_exit_listener then
			self.force_exit_listener:Remove()
		end

		TheFrontEnd:PopScreen(self)
	end
end

--[[
function InsightConfigurationScreen:OnBecomeActive()
	mprint("OnBecomeActive -> Tracking", TheFrontEnd.tracking_mouse)
	return self._base.OnBecomeActive(self)
end

function InsightConfigurationScreen:SetDefaultFocus(...)
	mprint("InsightConfigurationScreen -> SetDefaultFocus @@@@@@@@@@@@", ...)
	--mprint("\t", self.focus, self.options_scroll_list.focus)

	return self._base.SetDefaultFocus(self, ...)
end

function InsightConfigurationScreen:OnFocusMove(...)
	mprint("InsightConfigurationScreen -> OnFocusMove -------------------------------------------------------", ...)
	mprint("\t", self.focus, self.options_scroll_list.focus)

	return self._base.OnFocusMove(self, ...)
end
--]]

function InsightConfigurationScreen:OnControl(control, down)
	--mprint("InsightConfigurationScreen", controlHelper.Prettify(control), down)
	if self._base.OnControl(self, control, down) then return true end

	local scheme = controlHelper.GetCurrentScheme()
	if not down then
		if scheme:IsAcceptedControl("exit", control) then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:Close()
			return true
		elseif control == CONTROL_MAP then
			self:ResetToDefaultValues()
		elseif control == CONTROL_PAUSE then
			self:ApplyChanges()
		end
	end
end

function InsightConfigurationScreen:GetHelpText()
	local t = {}
	local controller_id = TheInput:GetControllerID()

	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_CANCEL) .. " " .. STRINGS.UI.HELP.BACK)
	table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_MAP) .. " " .. STRINGS.UI.MODSSCREEN.RESETDEFAULT)
	
	if self:IsDirty() then
		table.insert(t, TheInput:GetLocalizedControl(controller_id, CONTROL_PAUSE) .. " " .. STRINGS.UI.HELP.APPLY)
	end

	return table.concat(t, "  ")
end


return InsightConfigurationScreen