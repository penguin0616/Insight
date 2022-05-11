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
local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local ItemDetail = import("widgets/itemdetail")

local item_width = 400
local item_height = 80

local function DEBUG()
	if false then
		return "images/White_Square.xml", "White_Square.tex"
	end

	return nil, nil
end


local function MakeGrid()
	local TEMPLATES = require "widgets/redux/templates"

	return TEMPLATES.ScrollingGrid({}, {
		num_visible_rows = 3,
		num_columns = 1,
		widget_width = item_width,
		widget_height = item_height,
		scrollbar_offset = -10,
		scrollbar_height_offset = 0,
		peek_percent = 0.29, -- too much peek just clones the last item
		allow_bottom_empty_row = false,
		apply_fn = function(context, widget, data, index)
			--mprint('apply', widget, index, data and data.text)
			--[[
			if context then
				table.foreach(context, print)
			end
			mprint'--'
			if data then
				table.foreach(data, print)
			end
			--]]
			if data then
				--mprint(index)
				--table.foreach(data, print)

				--widget.text:SetString(data.text)
				-- "images/Volcano.xml", "Volcano.tex"

				if data.icon and data.icon.atlas and data.icon.tex then
					widget:SetIcon(data.icon.atlas, data.icon.tex)
				else
					widget:SetIcon(nil, nil)
				end
				
				widget:SetText(data.text)
				widget.component = data.component
			else
				widget:SetText(nil)
				widget:SetIcon(nil, nil)
				widget.component = nil
			end
		end,
			item_ctor_fn = function(context, index)
			--mprint'context'
			--table.foreach(context, print)

			--mprint('ctor', index)

			return ItemDetail({width = item_width, height = item_height})
		end,
	})
end

local ScrollList = Class(Widget, function(self)
	Widget._ctor(self, "yep")
	assert(IsDS(), "should not exist in DST")

	local scrollbutton_width, scrollbutton_height = 20, 20
	
	self.index = 1
	self.display_rows = 3
	self.rows = {}
	self.items = {} -- processed

	self.container = self:AddChild(Image()) -- "images/White_Square.xml", "White_Square.tex"
	--self.container:SetTint(0, .5, 0, .8)
	self.container:SetSize(400, 290)

	-- all this is pretty much taken from truescrolllist with revisions for DS
	local container_width, container_height = self.container:GetSize()
	local scroller_width, scroller_height = scrollbutton_width, container_height

	self.scroll_bar_container = self:AddChild(Widget("scroll-bar-container"))
    self.scroll_bar_container:SetPosition(container_width/2-scroller_width/2, 0)

	self.up_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_up.tex"))
	widgetLib.imagebutton.OverrideFocuses(self.up_button)
	widgetLib.imagebutton.ForceImageSize(self.up_button, scrollbutton_width, scrollbutton_height)
	self.up_button:SetPosition(0, scroller_height/2 - scrollbutton_height/2)
	self.up_button:SetOnClick(function() self:Scroll(-1) end)
	
	self.down_button = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_arrow_down.tex"))
	widgetLib.imagebutton.OverrideFocuses(self.down_button)
	widgetLib.imagebutton.ForceImageSize(self.down_button, scrollbutton_width, scrollbutton_height)
	self.down_button:SetPosition(0, -scroller_height/2 + scrollbutton_height/2)
	self.down_button:SetOnClick(function() self:Scroll(1) end)
	
	self.scroll_bar_line = self.scroll_bar_container:AddChild(Image("images/dst/global_redux.xml", "scrollbar_bar.tex"))
	self.scroll_bar_line:SetSize(10, scroller_height - scrollbutton_height*2)
    --self.scroll_bar_line:ScaleToSize(11*bar_width_scale_factor, line_height)
	self.scroll_bar_line:SetPosition(0, 0)
	
	self.position_marker = self.scroll_bar_container:AddChild(ImageButton("images/dst/global_redux.xml", "scrollbar_handle.tex"))
	widgetLib.imagebutton.OverrideFocuses(self.position_marker)
	widgetLib.imagebutton.ForceImageSize(self.position_marker, scrollbutton_width, scrollbutton_height)

	local _, scroll_bar_line_height = self.scroll_bar_line:GetSize()
	self.marker_bound = scroll_bar_line_height/2 - scrollbutton_height
	ImageButton._base.Disable(self.position_marker)

	self.scroll_bar_container:Hide()

	--[[
    self.position_marker.scale_on_focus = false
    self.position_marker.move_on_click = false
    self.position_marker.show_stuff = true
    self.position_marker:SetPosition(0, self.scrollbar_height/2 - arrow_button_size)
    self.position_marker:SetScale(bar_width_scale_factor*0.3, bar_width_scale_factor*0.3, 1)
    self.position_marker:SetOnDown( function() 
        TheFrontEnd:LockFocus(true)
        self.dragging = true
        self.saved_scroll_pos = self.current_scroll_pos
    end)
    self.position_marker:SetWhileDown( function() 
		self:DoDragScroll()
    end)   
    self.position_marker.OnLoseFocus = function()
        --do nothing OnLoseFocus
    end
    self.position_marker:SetOnClick( function() 
        self.dragging = nil
        TheFrontEnd:LockFocus(false)
        self:RefreshView() --refresh again after we've been moved back to the "up-click" position in Button:OnControl
	end)
	--]]
	
	
	for i = 1, self.display_rows do
		-- 80 * 3 = 240
		-- max is 290
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
	end
end)

function ScrollList:RefreshScrollBar()
	if self:GetMaxPages() < 2 then
		self.scroll_bar_container:Hide()
		return
	end

	self.scroll_bar_container:Show()

	local delta = self.marker_bound / (self:GetMaxPages()-1) * 2 -- -1 since we start from the top? (?? i cant remember what i was actually thinking), x2 since twice the area to traversing top->mid->bot
	local top_pos = self.marker_bound

	local y = top_pos - delta * (self.index - 1)

	self.position_marker:SetPosition(0, y)
end

function ScrollList:GetMaxPages()
	return math.ceil(#self.items / self.display_rows)
end

function ScrollList:SetItemsData(items)
	self.items = items
	self:Refresh()
end

function ScrollList:Scroll(mod)
	self.index = self.index + mod

	-- bound check
	if self.index < 1 then 
		self.index = 1 
	elseif self.index > self:GetMaxPages() then 
		self.index = self:GetMaxPages()
	end

	-- now update
	self:Refresh()
end

function ScrollList:Refresh()
	self:RefreshScrollBar()

	if self:GetMaxPages() == 0 then
		-- nothing to show
		return
	end

	local min = 1 + self.display_rows * (self.index - 1) -- remember to start at 1
	local max = min + (self.display_rows - 1)

	--table.foreach(self.rows, mprint)

	--mprint('min', min, 'max', max)

	local k = 0
	for i = min, max do
		--mprint(i)
		k = k + 1

		local widget = self.rows[k]
		local data = self.items[i]

		--mprint('asdf', k, widget, data, data and data.text)

		-- replicate grid behaviour
		if data then
			if data.icon and data.icon.atlas and data.icon.tex then
				widget:SetIcon(data.icon.atlas, data.icon.tex)
			else
				widget:SetIcon(nil, nil)
			end
		
			widget:SetText(data.text)
		else
			widget:SetText(nil)
			widget:SetIcon(nil, nil)
		end
	end

end


local InsightPage = Class(Widget, function(self, name)
	Widget._ctor(self, "InsightPage")
	assert(type(name) == "string", "Page expected name as first argument")

	self._name = name
	self.items = {}

	self.main = self:AddChild(Image(DEBUG()))
	--self.main = self:AddChild(Image())
	self.main:SetSize(400, 290)
	self.main:SetPosition(5, -25)

	if IsDST() then
		self.list = self.main:AddChild(MakeGrid())
	else
		self.list = self.main:AddChild(ScrollList())
	end

	self:Hide()
end)

function InsightPage:GetName()
	return self._name
end

function InsightPage:GetItems()
	return self.items
end

function InsightPage:GetItem(key)
	for _, item in pairs(self.items) do
		if item.key == key then
			return item
		end
	end
end

function InsightPage:AddItem(key, data)
	assert(type(key) == "string", "key expected to be a string")
	assert(type(data) == "table", "data expected to be a table")
	assert(self:GetItem(key) == nil, "key is a duplicate")

	data.key = key

	table.insert(self.items, data)
	self:Refresh()
end

function InsightPage:EditItem(key, data)
	local key = key
	assert(key, "key expected string, data expected table")

	for _, item in pairs(self.items) do
		if item.key == key then
			item.text = data.text -- in case they are nil
			item.icon = data.icon -- in case they are nil
			for j,k in pairs(data) do
				item[j] = k
				self:Refresh()
			end
			return
		end
	end

	error("attempt to edit an item that does not exist")
end

function InsightPage:RemoveItem(key)
	for index, item in pairs(self.items) do
		if item.key == key then
			table.remove(self.items, index)
			break
		end
	end
	self:Refresh()
end

function InsightPage:Refresh()
	self.list:SetItemsData(self.items)
end

return InsightPage