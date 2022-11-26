local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"

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

	self._width = item_width
	--self._height = self.item_height * self.visible_rows
	self._height = self.item_height * self.visible_rows + (self.row_padding * (self.visible_rows-1))

	-- The Root Container for everything
	self.root = self:AddChild(Widget("root"))

	-- This will hold all of the items.
	--self.list_root = self.root:AddChild(Widget("list_root"))
	self.list_root = self.root:AddChild(Image(DEBUG_IMAGE(true))); self.list_root:SetSize(self._width, self._height);
	
	self.scroll_per_click = 1
	self.current_scroll_pos = 1 -- Represents the current row index. Could be 1, 1.5, 2, etc.
	self.target_scroll_pos = 1
	self.end_scroll_pos = 1
	
	self:BuildListItems()
	self:BuildScrollBar()
	self:SetItemsData(nil)

	self:StartUpdating()
end)

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
	widgetLib.imagebutton.OverrideFocuses(self.up_button)
	self.up_button:ForceImageSize(scrollbutton_width, scrollbutton_height)
	self.up_button:SetPosition(0, scroller_height/2 - scrollbutton_height/2 + 8)
	self.up_button:SetOnClick(function() self:Scroll(-self.scroll_per_click) end)
	
	self.down_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_down.tex"))
	widgetLib.imagebutton.OverrideFocuses(self.down_button)
	self.down_button:ForceImageSize(scrollbutton_width, scrollbutton_height)
	self.down_button:SetPosition(0, -scroller_height/2 + scrollbutton_height/2 - 8)
	self.down_button:SetOnClick(function() self:Scroll(self.scroll_per_click) end)

	--self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/dst/global_redux.xml", "scrollbar_bar.tex"))
	self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/misc/scrollbar_bar.xml", "scrollbar_bar.tex"))
	--self.scroll_bar_line = self.scroll_bar_container:AddChild(Image(DEBUG_IMAGE(true)); self.scroll_bar_line:SetTint(.6, .3, .3, 1)
	self.scroll_bar_line:SetSize(10, scroller_height - scrollbutton_height*2)
	--self.scroll_bar_line:ScaleToSize(11*bar_width_scale_factor, line_height)
	self.scroll_bar_line:SetPosition(0, 0)
	
	self.position_marker = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_handle.tex"))
	widgetLib.imagebutton.OverrideFocuses(self.position_marker)
	self.position_marker:ForceImageSize(scrollbutton_width, scrollbutton_height)

	local _, scroll_bar_line_height = self.scroll_bar_line:GetSize()
	self.marker_bound = scroll_bar_line_height/2 - scrollbutton_height
	ImageButton._base.Disable(self.position_marker)

	self.scroll_bar_container:Hide()
end

function InsightScrollList:RefreshScrollBar()
	
end

function InsightScrollList:CanScroll()
	return self.end_scroll_pos > self.visible_rows
end

-- TODO: Make scroll position math

function InsightScrollList:GetMaxPages()
	
end

function InsightScrollList:Scroll(amount)
	self.target_scroll_pos = math.clamp(self.target_scroll_pos + amount, 1, self.end_scroll_pos)
end

function InsightScrollList:RefreshView()
	local row_index = self.current_scroll_pos - 1

	for i = 1, self.visible_rows do
		self.item_update(self.context, self.item_widgets[i], self.items[row_index + i])
	end

	--print(self.num_items, self.end_scroll_pos, self:CanScroll())
	if self:CanScroll() then
		self.scroll_bar_container:Show()

		local r = row_index / (self.end_scroll_pos - 1)
		--print(row_index, self.end_scroll_pos-1, r, self.num_items)
		local _, y = self.scroll_bar_line:GetSize()
		local pos = (y/2) - (y * r)

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

	local max_scroll = self.num_items - self.visible_rows
	self.end_scroll_pos = math.max(max_scroll, 1)

	self:OnUpdate()
	self:RefreshView()
end

function InsightScrollList:OnUpdate()
	local last_pos = self.current_scroll_pos

	if self.current_scroll_pos < 1 then
		self.current_scroll_pos = 1
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

return InsightScrollList