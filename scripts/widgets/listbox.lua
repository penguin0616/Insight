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

local Widget = require("widgets/widget")
local Screen = require("widgets/screen")
local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text = require("widgets/text")
local NineSlice = require("widgets/dst/nineslice")
local InsightScrollList = import("widgets/insightscrolllist")
local RichText = import("widgets/RichText")
local ITEMPLATES = import("widgets/insight_templates")

--[[
REGISTER_HOT_RELOAD({"widgets/insightscrolllist"}, function(imports)
	InsightScrollList = imports.insightscrolllist
end)
--]]

local function item_ctor_fn(context, index)
	local root = Widget("option" .. index)
	root:SetPosition(context.offset, 0)

	--[[
	root.main = root:AddChild(ITEMPLATES.ListItemBackground(context.option_width, context.option_height, function()
		root:Toggle()
	end))
	

	local normal_list_item_bg_tint = {1, 1, 1, 2}
	local focus_list_item_bg_tint = {1, 1, 1, 2}
	root.main:SetImageNormalColour(unpack(normal_list_item_bg_tint))
	root.main:SetImageFocusColour(unpack(focus_list_item_bg_tint))
	root.main:SetImageSelectedColour(unpack(normal_list_item_bg_tint))
	root.main:SetImageDisabledColour(unpack(normal_list_item_bg_tint))
	--]]

	root.context = context

	root.width = context.option_width
	root.height = context.option_height

	--root.checkbox = root:AddChild(ImageButton("images/button_icons2.xml", "disabled_filter.tex"))
	root.checkbox = root:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex"))
	root.checkbox.scale_on_focus = false
	root.checkbox.move_on_click = false
	root.checkbox:ForceImageSize(root.height, root.height)
	root.checkbox:SetPosition(-root.width/2 + root.height/2, 0)
	root.checkbox:SetOnClick(function()
		root:Toggle()
	end)

	--root.label = root:AddChild(Text(UIFONT, 25))
	root.label = root:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex"))
	root.label.scale_on_focus = false
	root.label.move_on_click = false
	root.label:ForceImageSize(root.width - root.checkbox.size_x, root.height)
	root.label.text:SetHAlign(ANCHOR_LEFT)
	root.label:SetTextSize(25)
	root.label:SetText("") -- Primes the text for SetTruncatedString
	root.label:SetFont(context.listbox.font)
	root.label:SetTextColour(UICOLOURS.WHITE)
	root.label:SetTextFocusColour(UICOLOURS.GOLD_FOCUS)
	root.label:SetPosition(root.checkbox:GetPosition() + Vector3(root.label.size_x/2 + root.checkbox.size_x/2, 0, 0))
	root.label.text:SetRegionSize(root.label.size_x, root.label.size_y)
	root.label:SetOnClick(function()
		root:Toggle()
	end)


	root:SetOnGainFocus(function()
		if not root.data then
			return
		end

		root.context.listbox.dropdown:OnWidgetFocus(root)
	end)

	root.Toggle = function(self)
		if not root.data then
			return
		end

		local old = root.data.selected

		root.data.selected = not root.data.selected
		root:SetEnabled(root.data.selected)

		context.listbox:OnChanged(root.data, old)
	end

	root.SetData = function(self, data)
		self.data = data

		if self.data then
			self:SetText(self.data.text)
			self:SetEnabled(self.data.selected)
			self:Show()
		else
			self:Hide()
			self:SetText(nil)
			self:SetEnabled(false)
		end
	end

	root.SetEnabled = function(self, yes)
		if yes then
			self.checkbox:SetTextures("images/dst/global_redux.xml", "checkbox_normal_check.tex", "checkbox_focus_check.tex")
		else
			self.checkbox:SetTextures("images/dst/global_redux.xml", "checkbox_normal.tex", "checkbox_focus.tex")
		end
	end

	-- 16
	root.SetText = function(self, text)
		--root.label:SetTruncatedString(text, nil, 16, true)
		root.label.text:SetTruncatedString(text, nil, 32, true) -- Can use SetTruncatedString + SetRegionSize as long as I don't provide a maxwidth.
	end

	root:SetEnabled(false)

	root.focus_forward = root.checkbox

	return root
end

local function apply_fn(context, widget, data, index)
	widget:SetData(data)
end

local ListBox = Class(Widget, function(self, data)
	Widget._ctor(self, "ListBox")
	--[[
		data {
			width = x,
			option_height = x,
			num_visible_rows = x,
			scroller = {
				width = x,
			},
		}
	--]]

	assert(type(data) == "table", "Missing data")
	data.scroller = data.scroller or {}
	
	self.scroller_width = data.scroller.width or 15

	self.option_width = assert(data.width, "Missing width") - self.scroller_width
	self.option_height = assert(data.option_height, "Missing optionheight")
	self.num_visible_rows = assert(data.num_visible_rows, "Missing num_visible_rows")
	
	self.width = data.width
	self.height = self.option_height * self.num_visible_rows

	self.font = data.font or UIFONT

	local prefix = GetReduxButtonPrefix({self.width, self.option_height})
	self.display_button = self:AddChild(ImageButton("images/dst/global_redux.xml", prefix.."_normal.tex", prefix.."_hover.tex", prefix.."_disabled.tex", prefix.."_down.tex"))
	--self.display_button = self:AddChild(ImageButton("images/dst/global_redux.xml", "blank.tex", "spinner_focus.tex"))
	self.display_button:SetTextSize(25)
	self.display_button:SetFont(self.font)
	self.display_button:SetTextColour(UICOLOURS.GOLD_CLICKABLE) -- GOLD_CLICKABLE
	self.display_button:SetTextFocusColour(UICOLOURS.WHITE) -- GOLD_FOCUS
	--self.display_button:SetImageNormalColour(1, 1, 1, .1)
	--self.display_button:SetImageFocusColour(.5, .5, 1, .5)
	self.display_button:ForceImageSize(self.width, self.option_height)
	self.display_button.scale_on_focus = false
	self.display_button.move_on_click = false
	self.display_button:SetText("")
	self.display_button.text:SetPosition(0, -2)

	self.dropdown_arrow = self.display_button:AddChild(ImageButton("images/ui.xml", "spin_arrow.tex"))
	self.dropdown_arrow.scale_on_focus = false
	self.dropdown_arrow:Disable()
	self.dropdown_arrow:ForceImageSize(self.option_height, self.option_height)
	self.dropdown_arrow:SetRotation(90)
	self.dropdown_arrow:SetPosition(self.width/2-self.option_height/2, -5)

	self.dropdown = self:AddChild(InsightScrollList(
		{
			scroll_context = {
				listbox = self,
				option_width = self.option_width,
				option_height = self.option_height,
				offset = -self.scroller_width/2,
			},
			widget_width = self.width,
			widget_height = self.option_height,
			row_padding = 0,
			num_visible_rows = self.num_visible_rows,
			item_ctor_fn = item_ctor_fn,
			apply_fn = apply_fn,
			--display_scroll_bar = false
			scroller_data = {
				width = self.scroller_width,
				height = self.height - self.scroller_width*2,
				position_offset = {-self.scroller_width, 0},
			},
		}
	))

	local bgw, bgh = self.width - (32+33), self.height - (30+30)

	self.dropdown.name = "ListBox:InsightScrollList"
	--self.dropdown:SetPosition(0, -self.height/2 - self.option_height/2)
	--self.dropdown:SetPosition(0, -self.height/2 - self.option_height/2)
	self.dropdown:SetPosition(0, -self.height/2 - self.option_height/2)
	--if self.dropdown.inst.UITransform.ClearScissor then self.dropdown.inst.UITransform:ClearScissor() end
	self.dropdown:Hide()

	--[[
	local prefix2 = GetReduxListItemPrefix(self.width, self.height)
	self.dropdown.bg:SetTexture("images/dst/frontend_redux.xml", prefix2.."_normal.tex")
	--]]
	-- atlas, top_left, top_center, top_right, mid_left, mid_center, mid_right, bottom_left, bottom_center, bottom_right
	
	self.dropdown.bg:Kill()
	self.dropdown.bg = self.dropdown:AddChild(NineSlice("images/misc/listbox_bg/attempt2_thin_crop.xml", "TL.tex", "TM.tex", "TR.tex", "ML.tex", "MM.tex", "MR.tex", "BL.tex", "BM.tex", "BR.tex"))
	self.dropdown.bg:SetSize(bgw, bgh) -- Nineslice SetSize doesn't account for the not-center pieces.
	self.dropdown.bg:SetTint(0.8, 0.8, 0.8, 1) -- Color.fromHex("#E9CA79")
	self.dropdown.bg:MoveToBack()

	--[[
	for i,v in pairs(self.dropdown.bg:GetChildren()) do
		local w, h = v:GetSize()
		mprint(w, h, v.texture)
	end
	--]]

	--[[
	self.dropdown.bg2 = self.dropdown:AddChild(Image(DEBUG_IMAGE(true)))
	self.dropdown.bg2:MoveToBack()
	self.dropdown.bg2:SetSize(self.width, self.height)
	--]]

	self.display_button:SetOnClick(function()
		self:ToggleDropdown()
	end)


	if self.inst.UITransform.ClearScissor then self.inst.UITransform:ClearScissor() end

	self.focus_forward = self.display_button
end)

function ListBox:ToggleDropdown()
	if self.dropdown.shown then
		self:CloseDropdown()
	else
		self:OpenDropdown()
	end
end

function ListBox:OpenDropdown()
	self.dropdown:Show()
	self.dropdown.item_widgets[1]:SetFocus()
end

function ListBox:CloseDropdown()
	self.dropdown:Hide()
	self.dropdown:ClearFocus()
	self.dropdown:ResetView()
	if self.focus then
		self:SetFocus()
	end
end

function ListBox:OnLoseFocus()
	if self.dropdown.shown then
		self.dropdown:Hide()
		self.dropdown:ResetView()
	end

	return self._base.OnLoseFocus(self)
end

function ListBox:OnGainFocus()
	--mprint("ongainfocus =====================================================================================================")
	return self._base.OnGainFocus(self)
end

function ListBox:OnChanged(item, old)
	self:UpdateDisplayButton()

	if self.onchangedfn then
		self.onchangedfn(item, old)
	end
end

function ListBox:SetOnChangedFn(fn)
	self.onchangedfn = fn
end

--- Returns an array of all the "enabled" listbox options.
function ListBox:GetSelectedOptions()
	if not self.data then
		return {}
	end

	local selected = {}
	for i,v in ipairs(self.data) do
		if v.selected then
			selected[#selected+1] = v
		end
	end

	return selected
end

--- Same as GetSelectedOptions, except it only returns an array of the enabled listbox option datas.
function ListBox:GetSelectedOptionsDataOnly()
	if not self.data then
		return {}
	end

	local selected = {}
	for i,v in ipairs(self.data) do
		if v.selected then
			selected[#selected+1] = v.data
		end
	end

	return selected
end

--- This shows all of the "enabled" listbox options on the dropdown button.
function ListBox:UpdateDisplayButton()
	local selected = self:GetSelectedOptions()

	local str = nil
	for i,v in ipairs(selected) do
		str = (str or "") .. v.text
		if i < #selected then
			str = str .. ", "
		end
	end

	if not str then
		str = "<None selected>"
	end

	self.display_button.text:SetTruncatedString(str, nil, 30, true)
end

function ListBox:SetData(data)
	self.data = data
	self.dropdown:SetItemsData(data)
	self:UpdateDisplayButton()
end

function ListBox:OnControl(control, down)
	if self._base.OnControl(self, control, down) then return true end

	local scheme = controlHelper.GetCurrentScheme()
	if not down then
		if self.dropdown.shown and scheme:IsAcceptedControl("exit", control) then
			self:CloseDropdown()
			return true
		end
	end
end

return ListBox