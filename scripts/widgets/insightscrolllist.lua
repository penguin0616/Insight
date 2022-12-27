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

-- This file's naming conventions try to stay somewhat close to DST's TrueScrollList
-- so as to minimize any issues for code swapping between the two across DS/T.

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

local InsightScrollList = Class(Widget, function(self, data)
	-- context, item_ctor, item_update_fn, item_width, item_height, visible_rows, row_padding
	Widget._ctor(self, "InsightScrollList")
	--assert(type(context) == "table", "InsightScrollList bad argument #1 (context): expected [function], got [" .. type(context) .. "]")
	--assert(type(context) == "table", "InsightScrollList bad argument #1 (context): expected [function], got [" .. type(context) .. "]")
	
	self.context = assert(data.scroll_context, "Missing scroll_context")
	self.item_ctor_fn = assert(data.item_ctor_fn, "Missing item_ctor_fn")
	self.item_update_fn = assert(data.apply_fn, "Missing apply_fn")
	self.item_width = assert(data.widget_width, "Missing widget_width")
	self.item_height = assert(data.widget_height, "Missing widget_height")
	self.num_visible_rows = assert(data.num_visible_rows, "Missing num_visible_rows")
	self.row_padding = data.row_padding or 0
	self.display_scroll_bar = true
	self.scroller_data = data.scroller_data or {}
	if data.display_scroll_bar ~= nil then
		self.display_scroll_bar = data.display_scroll_bar
	end
	
	self.controller_scheme = controlHelper.controller_scheme --controlHelper.GetScheme("controller")
	

	--[[
	self.controls = {
		normal = {
			scroll_up = CONTROL_SCROLLBACK,
			scroll_down = CONTROL_SCROLLFWD
		},
		controller = {
			scroll_up = controlHelper.KNOWN_CONTROLS.CONTROLLER.SCROLLBACK,
			scroll_down = controlHelper.KNOWN_CONTROLS.CONTROLLER.SCROLLFWD
		},
	}
	--]]

	self.bg = self:AddChild(Image("images/ui.xml", "blank.tex")) -- Ensures we're absorbing all control inputs within the widget region.
	--self.bg = self:AddChild(Image(DEBUG_IMAGE(true)))

	-- The Root Container for everything
	self.root = self:AddChild(Widget("root"))

	-- This will hold all of the items.
	self.list_root = self.root:AddChild(Widget("list_root"))
	--self.list_root = self.root:AddChild(Image(DEBUG_IMAGE(true))); self.list_root:SetSize(self._width, self._height);
	
	self:RecalculateSize()

	-- Scrolling position stuff
	self.scroll_per_click = 1
	self.current_scroll_pos = 0 -- Represents the current row index. Could be 1, 1.5, 2, etc.
	self.target_scroll_pos = 0
	self.end_scroll_pos = 0


	-- Tracking
	self.focused_widget_index = 0 -- The focused widget in the actual visible list of rows; so this is always (1 < X <= visible rows)
	self.displayed_start_index = 0 -- Topmost visible item index (1 <= x <= num_items)
	self.focused_item_index = nil -- Item index temporarily set to focus an item

	self.getnextitemindex = function(dir, focused_item_index)
		-- Only 1 column per row, so.
		return (dir == MOVE_UP and focused_item_index - 1) or
			(dir == MOVE_DOWN and focused_item_index + 1) or nil
	end
	
	self:SetItemsData(nil)

	--self.focus_forward = self.list_root

	self:StartUpdating()
end)

function InsightScrollList:BuildListItems()
	self.list_root:KillAllChildren()
	self.item_widgets = {}

	-- negative = down
	-- positive =  up

	--local est_height = self.item_height * self.num_visible_rows + (self.row_padding * (self.num_visible_rows-1))
	local est_height = self._height

	for i = 1, self.num_visible_rows do
		local w = self.list_root:AddChild(self.item_ctor_fn(self.context, i))
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

		local current_pos = w:GetPosition()
		w:SetPosition(current_pos.x, pos)
		
		self.item_widgets[i] = w
	end
end

function InsightScrollList:BuildScrollBar()
	if self.scroll_bar_container then
		self.scroll_bar_container:Kill()
		self.scroll_bar_container = nil
	end

	local target_width = self.scroller_data.width or 20
	local target_height = target_width
	
	--local scroller_width = target_width
	local scroller_height = self.scroller_data.height or self._height

	local offset = self.scroller_data.position_offset or {target_width/2 + 5, 0}

	self.scroll_bar_container = self:AddChild(Widget("scroll_bar_container"))
	self.scroll_bar_container:SetPosition(self._width/2 + offset[1], offset[2])

	self.up_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_up.tex"))
	local button_width, button_height = self.up_button:GetSize() -- Actual size of the tex
	--self.up_button:InsightOverrideFocuses()
	--self.up_button.scale_on_focus = false
	self.up_button:SetNormalScale(target_width / button_width, target_height / button_height)
	self.up_button:SetFocusScale(target_width / button_width + 0.05, target_height / button_height + 0.05)
	--self.up_button:ForceImageSize(target_width, target_height)
	self.up_button:SetPosition(0, scroller_height/2 - target_height/2 + 8)
	self.up_button:SetOnClick(function() self:ScrollUp() end)
	
	self.down_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_down.tex"))
	--self.down_button:InsightOverrideFocuses()
	self.down_button:SetNormalScale(target_width / button_width, target_height / button_height)
	self.down_button:SetFocusScale(target_width / button_width + 0.05, target_height / button_height + 0.05)
	--self.down_button:ForceImageSize(target_width, target_height)
	self.down_button:SetPosition(0, -scroller_height/2 + target_height/2 - 8)
	self.down_button:SetOnClick(function() self:ScrollDown() end)

	--self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/dst/global_redux.xml", "scrollbar_bar.tex"))
	self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/misc/scrollbar_bar.xml", "scrollbar_bar.tex"))
	--self.scroll_bar_line = self.scroll_bar_container:AddChild(Image(DEBUG_IMAGE(true)); self.scroll_bar_line:SetTint(.6, .3, .3, 1)
	self.scroll_bar_line:SetSize(10, scroller_height - target_height*2)
	--self.scroll_bar_line:ScaleToSize(11*target_width_scale_factor, line_height)
	self.scroll_bar_line:SetPosition(0, 0)
	self.scroll_bar_height = select(2, self.scroll_bar_line:GetSize())
	
	self.position_marker = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_handle.tex")) -- ~(60, 57)
	-- Trying to scale this like the buttons has some issue where it never reverts back to normal scale.
	self.position_marker.scale_on_focus = false
	self.position_marker.move_on_click = false
	--patcher.imagebutton.Patch(self.position_marker)
	--self.position_marker:InsightOverrideFocuses()
	--self.position_marker:ForceImageSize(target_width, target_height)
	self.position_marker:SetScale(target_width/60, target_width/57 , 1)

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

function InsightScrollList:RecalculateSize()
	self._width = self.item_width
	--self._height = self.item_height * self.num_visible_rows
	self._height = self.item_height * self.num_visible_rows + (self.row_padding * (self.num_visible_rows-1))

	self.bg:ScaleToSize(self._width + 10, self._height + 10)
	self:BuildListItems()
	if self.display_scroll_bar then
		self:BuildScrollBar()
	end
end

function InsightScrollList:SetNumVisibleRows(num)
	if num == self.num_visible_rows then
		return
	end

	self.num_visible_rows = num
	self:RecalculateSize()

	self:SetItemsData(self.items)
	self:ResetView()
end

function InsightScrollList:OnWidgetFocus(focused_widget)
	for i = 1, self.num_visible_rows do
		if self.item_widgets[i] == focused_widget then
			self.focused_widget_index = i
			return
		end
	end
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
	--return self.end_scroll_pos > self.num_visible_rows
	return self.end_scroll_pos > 0
end

function InsightScrollList:ConvertScrollPosToPixels(pos)
	local pos_to_max_ratio = pos / (self.end_scroll_pos) -- Basically a (progress/completion).
	local bar_height = self.scroll_bar_height -- Should I cache this?
	-- Start at the top of the bar, and add part of the height back as a position based on the ratio.
	-- That way, if the ratio was 1 (end of the scroller), it would be at the end.
	local pos = (bar_height/2) - (bar_height * pos_to_max_ratio)

	return pos
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

--- Scroll to an item index, leaving it at the topmost position if possible.
function InsightScrollList:ScrollToItemIndex(idx)
	--mprintf("Current: %s | Idx: %s | Adjusted for row count: %s", self.current_scroll_pos, idx, idx - 1)
	self.current_scroll_pos = math.clamp(idx - 1, 0, self.end_scroll_pos)
	--mprint(self.current_scroll_pos, "\n--------------------------------------------------------------------------------")
	self.target_scroll_pos = self.current_scroll_pos
	
	self:RefreshView()
end

--- Returns the topmost visible item index.
function InsightScrollList:GetRowIndex(pos)
	pos = pos or self.current_scroll_pos
	return ((pos % 1 < .5 and math.floor) or math.ceil)(pos)
end

function InsightScrollList:RefreshView()
	-- Clamp the scroll position to the closest "item row".
	local row_index = self:GetRowIndex()
	self.displayed_start_index = row_index
	--self.displayed_last_index = row_index + self.num_visible_rows

	for i = 1, self.num_visible_rows do
		self.item_update_fn(self.context, self.item_widgets[i], self.items[row_index + i], row_index + i)
		if self.focused_item_index and self.focused_item_index == self.displayed_start_index + i then 
			if self:GetParentScreen() == TheFrontEnd:GetActiveScreen() then
				self.item_widgets[i]:SetFocus()
			end
		end
	end

	--print(self.num_items, self.end_scroll_pos, self:CanScroll())
	if self:CanScroll() then
		if self.scroll_bar_container then
			self.scroll_bar_container:Show()
			local pos = self:ConvertScrollPosToPixels(row_index)
			self.position_marker:SetPosition(0, pos)
		end
	else
		if self.scroll_bar_container then
			self.scroll_bar_container:Hide()
		end
	end
end

function InsightScrollList:SetItemsData(items)
	self.items = items or {}
	self.num_items = #self.items

	local max_scroll = self.num_items - self.num_visible_rows
	self.end_scroll_pos = math.max(max_scroll, 0)

	-- This is the index of the currently focused item in our list

	if self.focus then
		if self.num_items > 0 and self.items[self:GetFocusedItemIndex()] == nil then
			-- The new data doesn't have an item that can be focused at this index, so reset focus back to the topmost displayed widget. 
			self.item_widgets[1]:SetFocus()
		end
	elseif self.num_items > 0 then
		--self.focus_forward = self.item_widgets[math.clamp(self.focused_widget_index, 1, self.num_visible_rows)]
	end

	self:OnUpdate()
	self:RefreshView()
end

local SCROLL_REPEAT_TIME = .2
local PAGE_REPEAT_TIME = .3

function InsightScrollList:OnUpdate(dt)
	-- Repeat scrolling for controllers
	local attached = TheInput:ControllerAttached()
	if attached and self.control_scroll_repeat_time == nil then
		self.control_scroll_repeat_time = -1
	elseif not attached and self.control_scroll_repeat_time ~= nil then
		self.control_scroll_repeat_time = nil
	end

	-- Thanks Klei!
	if dt and self.control_scroll_repeat_time ~= nil then
		local controls = self.controller_scheme
		--Scroll repeat
	   	-- if not (TheInput:IsControlPressed(controls.scroll_up) or TheInput:IsControlPressed(controls.scroll_down)) then
		if not (controls.scroll_up:IsAnyControlPressed() or controls.scroll_down:IsAnyControlPressed()) then
			self.control_scroll_repeat_time = -1

		elseif self.control_scroll_repeat_time > dt then
			self.control_scroll_repeat_time = self.control_scroll_repeat_time - dt

		--elseif TheInput:IsControlPressed(controls.scroll_up) then
		elseif controls.scroll_up:IsAnyControlPressed() then
			local repeat_time = SCROLL_REPEAT_TIME
			if self.control_scroll_repeat_time < 0 then
				self.control_scroll_repeat_time = repeat_time > dt and repeat_time - dt or 0
			else
				self.control_scroll_repeat_time = repeat_time
				self:OnControl(controls.scroll_up[1], true)
			end

		else
			local repeat_time =  SCROLL_REPEAT_TIME
			if self.control_scroll_repeat_time < 0 then
				self.control_scroll_repeat_time = repeat_time > dt and repeat_time - dt or 0
			else
				self.control_scroll_repeat_time = repeat_time
				self:OnControl(controls.scroll_down[1], true)
			end
		end
	end

	-- Clamp the scroller position
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
		delta = -math.min(self.scroll_per_click, math.abs(diff))
	end

	self.current_scroll_pos = self.current_scroll_pos + delta

	-- Make sure that we've moved before refreshing the view.
	if self.current_scroll_pos ~= last_pos then
		self:RefreshView()
	else
		self.focused_item_index = nil
	end
end

function InsightScrollList:OnGainFocus()
	-- I'm experimenting with trying to get focus to the first item to happen automatically in a safe way.
	--mprint(self.name, "OnGainFocus ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

	--[[
	self.list_root:MoveToFront()
	if self._bg then
		self._bg:MoveToBack()
	end
	if self.bg then
		self.bg:MoveToBack()
	end
	--]]
	
	--[[
	mprint(debugstack())
	self.focused_item_index = 1
	if self.item_widgets[self.focused_item_index] then
		self.focus_forward = self.item_widgets[self.focused_item_index]
	end
	--]]

	self._base.OnGainFocus(self)
end

function InsightScrollList:OnLoseFocus()
	--mprint(self.name, "OnLoseFocus ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	--mprint(debugstack())
	return self._base.OnLoseFocus(self)
end

function InsightScrollList:ResetView(focused_item_index)
	if self.item_widgets[self.focused_widget_index] then
		self.item_widgets[self.focused_widget_index]:ClearFocus()
	end

	self.focused_widget_index = 0
	self.current_scroll_pos = 0
	self.target_scroll_pos = 0

	self:RefreshView()
end

function InsightScrollList:GetFocusedItemIndex()
	return self.displayed_start_index + self.focused_widget_index
end

function InsightScrollList:ForceItemFocus(itemindex)
	local new_widget_index = itemindex - (self.displayed_start_index)
	--mprint("ForceItemFocus", itemindex, "| current:", new_widget_index)

	if self.item_widgets[new_widget_index] then
		--mprint("\t", self.item_widgets[new_widget_index].data.label)
		self.item_widgets[new_widget_index]:SetFocus()
	else
		self:SetFocus()
	end

	self.focused_item_index = itemindex
end

-- If you can't scroll past the first widget, make sure you're calling OnWidgetFocus.
function InsightScrollList:GetNextWidget(dir)
	local focused_item_index = self.focused_item_index or self:GetFocusedItemIndex()
	local next_item_index = self.getnextitemindex(dir, focused_item_index) 
	--mprint("-----------------------------------------------getnext current focused:", focused_item_index, "|", self:GetFocusedItemIndex())

	local scrolled = false

	if next_item_index and self.items[next_item_index] then
		-- This is the max index that is displayed on the scroller right now.
		local max_displayed_index = self.displayed_start_index + self.num_visible_rows
		--[[
		mprintf(
			"\nnext: %s, next (item): %s, \nself.focused_item_index: %s, GetFocusedItemIndex: %s", 
			next_item_index, tostring(self.items[next_item_index]), 
			self.focused_item_index, self:GetFocusedItemIndex()
		)
	--]]
		if next_item_index <= self.displayed_start_index then
			--dprint("@@@@@@ Gotta scroll back")
			scrolled = true
			self:Scroll(-1)
		elseif next_item_index > max_displayed_index then
			--dprint("@@@@@@ Gotta scroll forward")
			scrolled = true
			self:Scroll(1)
		end

			-- We have to scroll.
			--local delta = (next_item_index > max_displayed_index and 1) or -1
			--self.current_scroll_pos = self.current_scroll_pos + delta
			--self.target_scroll_pos = self.current_scroll_pos
		
		if next_item_index and self.items[next_item_index] then
			self:ForceItemFocus(next_item_index)
			scrolled = true -- I don't get why this is done.
		elseif scrolled then
			self:ForceItemFocus(focused_item_index)
		end
		
		return scrolled
	else
		--dprint("missing next!!")
	end

	return scrolled
end

function InsightScrollList:OnFocusMove(dir, down)
	if InsightScrollList._base.OnFocusMove(self, dir, down) then return true end
	--rawset(_G, "s", self)
	-- down is always true
	--mprint(self.name .. " OnFocusMove", dir, down)
	
	if dir == MOVE_UP or dir == MOVE_DOWN then
		local had_to_scroll = self:GetNextWidget(dir)
		if had_to_scroll then
			return had_to_scroll
		end
	end 

	--[[
	local prev_focus = self.item_widgets[self.focused_widget_index]
    local did_parent_move = InsightScrollList._base.OnFocusMove(self, dir, down)
    if prev_focus and did_parent_move then
        local focused_item_index = self:GetFocusedItemIndex()
        if not self.items[focused_item_index] then
            -- New widget is empty, undo parent's move to focus valid widget.
            prev_focus:SetFocus()
            return false
        end
    end

	return did_parent_move
	--]]
end

function InsightScrollList:OnControl(control, down)
	--mprint('yes')
	if InsightScrollList._base.OnControl(self, control, down) then return true end
	--dprint(self.name, controlHelper.Prettify(control), down, "|", TheInput:GetControlIsMouseWheel(control))
	--[[
	This was happening too.
	CONTROL_ZOOM_IN = 9
	CONTROL_ZOOM_OUT = 10	
	]]

	local controls = controlHelper.GetCurrentScheme()

	if (self.focus or FunctionOrValue(self.custom_focus_check)) and self:CanScroll() then
		if down then -- down
			local accepted = false

			if controls:IsAcceptedControl("scroll_up", control) then
				--print("Scrolling up.")
				self:Scroll(-self.scroll_per_click)
				accepted = true
			elseif controls:IsAcceptedControl("scroll_down", control) then
				--print("Scrolling down.")
				self:Scroll(self.scroll_per_click)
				accepted = true
			elseif controls:IsAcceptedControl("page_up", control) then
				self:Scroll(-self.num_visible_rows)
				accepted = true
			elseif controls:IsAcceptedControl("page_down", control) then
				self:Scroll(self.num_visible_rows)
				accepted = true
			end

			if accepted then
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction and ClickMouseoverSoundReduction() or nil)
				return true
			end
		end
	end
	--mprint("Failed ALL:", controlHelper.Prettify(control), down, self.focus, self:CanScroll())
end

function InsightScrollList:GetHelpText()
	local controller_id = TheInput:GetControllerID()

	local tips = {}
	if self:CanScroll() then
		table.insert(tips, TheInput:GetLocalizedControl(controller_id, self.controller_scheme.scroll_up[1]) .. "/" .. TheInput:GetLocalizedControl(controller_id, self.controller_scheme.scroll_down[1]) .. " " .. "Scroll")
	end

	return table.concat(tips, "  ")
end

return InsightScrollList