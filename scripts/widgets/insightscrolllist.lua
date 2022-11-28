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
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

--[[
-- This disables camera zooming.
local function FindFirstAncestor(inst, name)
	local this = inst
	repeat
		this = this:GetParent()
	until this == nil or this.name == name
	if this then
		return this
	end
end

if IS_DS then
	local FollowCamera = require("cameras/followcamera")
	local oldCanControl = FollowCamera.CanControl
	FollowCamera.CanControl = function(self)
		local ui = TheInput:GetHUDEntityUnderMouse()
		if ui then
			local list = FindFirstAncestor(ui.widget, "InsightScrollList")
			if list then
				return false
			end
		end

		return oldCanControl(self)
	end
end
--]]

local InsightScrollList = Class(Widget, function(self, context, item_ctor, item_update, item_width, item_height, visible_rows, row_padding)
	Widget._ctor(self, "InsightScrollList")
	assert(type(context) == "table", "InsightScrollList bad argument #1 (context): expected [function], got [" .. type(context) .. "]")
	--assert(type(context) == "table", "InsightScrollList bad argument #1 (context): expected [function], got [" .. type(context) .. "]")
	
	self.context = context
	self.item_ctor = item_ctor
	self.item_update = item_update
	self.item_width = item_width
	self.item_height = item_height
	self.visible_rows = visible_rows
	self.row_padding = row_padding or 0

	self.control_up = CONTROL_SCROLLBACK
	self.control_down = CONTROL_SCROLLFWD

	self._width = item_width
	--self._height = self.item_height * self.visible_rows
	self._height = self.item_height * self.visible_rows + (self.row_padding * (self.visible_rows-1))

	-- Ensures we're absorbing all control inputs within the widget region.
	self.bg = self:AddChild(Image("images/ui.xml", "blank.tex"))
    self.bg:ScaleToSize(self._width, self._height)

	-- The Root Container for everything
	self.root = self:AddChild(Widget("root"))

	-- This will hold all of the items.
	self.list_root = self.root:AddChild(Widget("list_root"))
	--self.list_root = self.root:AddChild(Image(DEBUG_IMAGE(true))); self.list_root:SetSize(self._width, self._height);
	
	self.scroll_per_click = 1
	self.current_scroll_pos = 0 -- Represents the current row index. Could be 1, 1.5, 2, etc.
	self.target_scroll_pos = 0
	self.end_scroll_pos = 0
	
	self:BuildListItems()
	self:BuildScrollBar()
	self:SetItemsData(nil)

	self:StartUpdating()
end)

--[[
function InsightScrollList:OnGainFocus()
	mprint("InsightScrollList ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ GOT FOCUS")
end

function InsightScrollList:OnLoseFocus()
	print(debugstack())
	mprint("InsightScrollList ---------------------------------------------------------------------------------------------------------------- LOST FOCUS")
end
--]]

function InsightScrollList:BuildListItems()
	self.list_root:KillAllChildren()
	self.item_widgets = {}

	--[[
	local _, y = self.container:GetSize()
	local free_space = y - (self.display_rows * item_height)
	assert(free_space >= 0, "[Insight]: free space is not 0?")

	local widget = self.container:AddChild(ItemDetail({width = item_width, height = item_height}))

	local offset = item_height-- + (free_space / self.display_rows)

	local padding = free_space / self.display_rows

	-- negative = down
	-- positive =  up
	local base_pos = y/2 - item_height/2 + padding/2

	widget:SetPosition(0, base_pos + offset - ((padding + offset) * i-1))

	table.insert(self.rows, widget)
	]]
	--local est_height = self.item_height * self.visible_rows + (self.row_padding * (self.visible_rows-1))
	local est_height = self._height

	-- 3, 1, 6, 2 is the display order

	for i = 1, self.visible_rows do
		local w = self.list_root:AddChild(self.item_ctor(self.context))
		local top_pos = est_height/2 - self.item_height/2
		local pos = top_pos - (self.item_height * (i - 1))-- - (self.row_padding * (i-1))

		--[[
		if i == 2 then
			pos = pos - self.row_padding
		end
		if i == 3 then
			pos = pos - self.row_padding * 2
		end
		if i == 4 then
			pos = pos - self.row_padding * 3
		end
		--]]

		pos = pos - self.row_padding * (i - 1)


		w:SetPosition(0, pos)
		
		
		self.item_widgets[i] = w
	end
end

function InsightScrollList:BuildScrollBar()
	if self.scroll_bar_container then
		self.scroll_bar_container:Kill()
	end

	local scrollbutton_width = 20
	local scrollbutton_height = 20
	
	local scroller_width = scrollbutton_width
	local scroller_height = self._height

	self.scroll_bar_container = self:AddChild(Widget("scroll-bar-container"))
	self.scroll_bar_container:SetPosition(self._width/2 + scroller_width/2 + 5, 0)

	self.up_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_up.tex"))
	self.up_button:InsightOverrideFocuses()
	self.up_button:ForceImageSize(scrollbutton_width, scrollbutton_height)
	self.up_button:SetPosition(0, scroller_height/2 - scrollbutton_height/2 + 8)
	self.up_button:SetOnClick(function() self:ScrollUp() end)
	
	self.down_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_down.tex"))
	self.down_button:InsightOverrideFocuses()
	self.down_button:ForceImageSize(scrollbutton_width, scrollbutton_height)
	self.down_button:SetPosition(0, -scroller_height/2 + scrollbutton_height/2 - 8)
	self.down_button:SetOnClick(function() self:ScrollDown() end)

	--self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/dst/global_redux.xml", "scrollbar_bar.tex"))
	self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/misc/scrollbar_bar.xml", "scrollbar_bar.tex"))
	--self.scroll_bar_line = self.scroll_bar_container:AddChild(Image(DEBUG_IMAGE(true)); self.scroll_bar_line:SetTint(.6, .3, .3, 1)
	self.scroll_bar_line:SetSize(10, scroller_height - scrollbutton_height*2)
	--self.scroll_bar_line:ScaleToSize(11*bar_width_scale_factor, line_height)
	self.scroll_bar_line:SetPosition(0, 0)
	self.scroll_bar_height = select(2, self.scroll_bar_line:GetSize())
	
	self.position_marker = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_handle.tex"))
	self.position_marker.scale_on_focus = false
    self.position_marker.move_on_click = false
	--patcher.imagebutton.Patch(self.position_marker)
	self.position_marker:InsightOverrideFocuses()
	--self.position_marker:ForceImageSize(scrollbutton_width, scrollbutton_height)
	self.position_marker:SetScale(0.3, 0.3, 1)

	self.position_marker:SetOnDown(function()
		TheFrontEnd:LockFocus(true)
		local scale = self:GetScale()

		-- We need to get the current position of the mouse on the screen, so we can establish the bounds for moving around.
		local mouse_pos = Vector3(TheFrontEnd.lastx/scale.x, TheFrontEnd.lasty/scale.y, 0)
		local scroll_pos = self.current_scroll_pos

		-- This is how much space is left to scroll downwards.
		local scrolling_space_left = self:GetScrollingSpaceLeft()
		-- We'll use this to establish the bounds for our mouse scrolling.
		local mouse_bound_top = mouse_pos.y + (self.scroll_bar_height - scrolling_space_left)
		local mouse_bound_bottom = mouse_pos.y - scrolling_space_left

		--mprint("Init state with:", scrolling_space_left, "|", mouse_bound_top, mouse_bound_bottom)

		self.drag_state = {
			last_mouse_pos = mouse_pos,
			mouse_bound_top = mouse_bound_top,
			mouse_bound_bottom = mouse_bound_bottom,
		}
	end)
	self.position_marker:SetWhileDown( function()
		self:DoDragScroll()
	end)

	--[[
	self.position_marker.OnGainFocus = function()
		print("ongainfocus")
		--do nothing OnGainFocus
	end
	--]]
	self.position_marker.OnLoseFocus = function()
		--print("onlosefocus")
		--do nothing OnLoseFocus
	end
	
	self.position_marker:SetOnClick(function()
		--print("onclick")
		self.drag_state = nil -- Unused
		self.saved_scroll_pos = nil
		TheFrontEnd:LockFocus(false)
		self:RefreshView() --refresh again after we've been moved back to the "up-click" position in Button:OnControl
	end)
end

--- Calculates the amount of space left to go downwards in pixel terms.
function InsightScrollList:GetScrollingSpaceLeft()
	-- scrolling_space_left
	return self.scroll_bar_height - (self.current_scroll_pos / self.end_scroll_pos) * self.scroll_bar_height
end

-- Bar height is 204
function InsightScrollList:DoDragScroll()
	local state = self.drag_state
	local bar_height = self.scroll_bar_height
	local scale = self:GetScale()
	
	local mouse_pos = Vector3(TheFrontEnd.lastx / scale.x, TheFrontEnd.lasty / scale.y)
	local last_pos = state.last_mouse_pos

	-- Get the difference from the last position we have recorded.
	local diff = mouse_pos.y - last_pos.y

	-- Clamp the difference so that the mouse has to be in the same Y region as the scrollbar to move the marker.
	if mouse_pos.y > state.mouse_bound_top then
		local distance_left_up = bar_height - self:GetScrollingSpaceLeft()
		--mprint("Too far up!", distance_left_up, diff, "|", mouse_pos.y - state.mouse_bound_top)
		diff = distance_left_up -- For cases where we move the mouse faster to beyond the bounds and the marker can't keep up, just take us to the bound.
	elseif mouse_pos.y < state.mouse_bound_bottom then
		local distance_left_down = self:GetScrollingSpaceLeft()
		--mprint("Too far down!", distance_left_down, diff, "|", state.mouse_bound_bottom - mouse_pos.y)
		diff = -distance_left_down -- For cases where we move the mouse faster to beyond the bounds and the marker can't keep up, just take us to the bound.
	end

	-- Diff / bar_height alone would be sufficient if we were working on a scale of 0-1.
	-- However, we're working on a scale of 0 - end
	-- So to go from 0-1 to 0-end, we need to multiply by the end_scroll_pos.
	local scroll = (diff / bar_height) * self.end_scroll_pos

	self.current_scroll_pos = self.current_scroll_pos - scroll -- math.clamp(self.current_scroll_pos - scroll, 0, self.end_scroll_pos) -- Short for (self.current_scroll_pos + -scroll)
	self.target_scroll_pos = self.current_scroll_pos

	state.last_mouse_pos = mouse_pos

	self:RefreshView()
end

function InsightScrollList:CanScroll()
	return self.end_scroll_pos > self.visible_rows
end

function InsightScrollList:ConvertScrollPosToPixels(pos)
	local pos_to_max_ratio = pos / (self.end_scroll_pos) -- Basically a (progress/completion).
	local bar_height = self.scroll_bar_height -- Should I cache this?
	-- Start at the top of the bar, and add part of the height back as a position based on the ratio.
	-- That way, if the ratio was 1 (end of the scroller), it would be at the end.
	local pos = (bar_height/2) - (bar_height * pos_to_max_ratio)

	return pos
end

function InsightScrollList:GetMaxPages()
	
end

function InsightScrollList:Scroll(amount)
	self.target_scroll_pos = math.clamp(self.target_scroll_pos + amount, 0, self.end_scroll_pos)
end

--- Mostly for external cases where they shouldn't need to know how much to scroll by.
function InsightScrollList:ScrollDown()
	self:Scroll(self.scroll_per_click)
end

--- Mostly for external cases where they shouldn't need to know how much to scroll by.
function InsightScrollList:ScrollUp()
	self:Scroll(-self.scroll_per_click)
end

function InsightScrollList:RefreshView()
	-- Clamp the scroll position to the closest "item row".
	local row_index = ((self.current_scroll_pos % 1 < .5 and math.floor) or math.ceil)(self.current_scroll_pos)

	for i = 1, self.visible_rows do
		self.item_update(self.context, self.item_widgets[i], self.items[row_index + i])
	end

	--print(self.num_items, self.end_scroll_pos, self:CanScroll())
	if self:CanScroll() then
		self.scroll_bar_container:Show()
		local pos = self:ConvertScrollPosToPixels(row_index)
		self.position_marker:SetPosition(0, pos)
	else
		self.scroll_bar_container:Hide()
	end

	--[[
	local row_index, offset = self:GetIndexOfFirstVisibleWidget()

	for i = 1, self.visible_rows do
		self.item_update(self.context, self.item_widgets[i], self.items[row_index + i - 1])
	end

	if self:CanScroll() then
		self.scroll_bar_container:Show()
	else
		self.scroll_bar_container:Hide()
	end

	self.list_root:SetPosition(offset * self.item_height)
	--]]
end

function InsightScrollList:SetItemsData(items)
	self.items = items or {}
	self.num_items = #self.items

	local max_scroll = self.num_items - self.visible_rows - 1
	self.end_scroll_pos = math.max(max_scroll, 0)

	self:OnUpdate()
	self:RefreshView()
end

function InsightScrollList:OnUpdate()
	local last_pos = self.current_scroll_pos

	if self.current_scroll_pos < 0 then
		self.current_scroll_pos = 0
		self.target_scroll_pos = self.current_scroll_pos 
	elseif self.current_scroll_pos > self.end_scroll_pos then
		self.current_scroll_pos = self.end_scroll_pos
		self.target_scroll_pos = self.current_scroll_pos 
	end

	-- This whole bit-by-bit scroll logic probably isn't practical to do in an OnUpdate.
	-- Only really made sense for the Lerp, but I'm not doing that here.
	local diff = self.target_scroll_pos - self.current_scroll_pos

	local delta = 0
	if diff > 0 then
		-- We need to scroll down.
		delta = math.min(self.scroll_per_click, diff)
	elseif diff < 0 then
		-- We need to scroll up.
		delta = -math.min(self.scroll_per_click, -diff)
	end

	self.current_scroll_pos = self.current_scroll_pos + delta

	-- Make sure that we've moved before refreshing the view.
	if self.current_scroll_pos ~= last_pos then
		self:RefreshView()
	end
end

function InsightScrollList:OnControl(control, down)
	mprint("InsightScrollList", controlsHelper.Prettify(control), down, self.focus)
	if InsightScrollList._base.OnControl(self, control, down) then return true end
	mprint("\t:)")
	--[[
	if TheCamera.gg == nil then
		TheCamera.gg=true
		TheCamera.ZoomIn = function(...)
			print(debugstack())
		end
	end
	--]]
	
	--[[
	This was happening too.
	CONTROL_ZOOM_IN = 9
	CONTROL_ZOOM_OUT = 10	
	]]

	if self.focus and self:CanScroll() then
		if down then -- down
			if control == self.control_up then
				--print("Scrolling up.")
				self:Scroll(-self.scroll_per_click)
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction and ClickMouseoverSoundReduction() or nil)
				return true
			elseif control == self.control_down then
				--print("Scrolling down.")
				self:Scroll(self.scroll_per_click)
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction and ClickMouseoverSoundReduction() or nil)
				return true
			end 
		end

		--[[
		-- Eat the control input here, so scrolling doesn't make us zoom in and out.
		if (control == CONTROL_ZOOM_IN or control == CONTROL_ZOOM_OUT) or (control == CONTROL_MAP_ZOOM_IN or control == CONTROL_MAP_ZOOM_OUT) then
			return true
		end
		--mprint("Within focus:", control, (control == CONTROL_ZOOM_IN or control == CONTROL_ZOOM_OUT) or (control == CONTROL_MAP_ZOOM_IN or control == CONTROL_MAP_ZOOM_OUT))
		--]]
	end

	mprint("Failed ALL:", controlsHelper.Prettify(control), down, self.focus, self:CanScroll())
end

return InsightScrollList