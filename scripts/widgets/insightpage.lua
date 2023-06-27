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
local InsightScrollList = import("widgets/insightscrolllist")

--[[
local item_width = 400
local item_height = 64
-- 16 is because item_height used to be 80 for padding reasons. 
-- Moving it to 64 means we move it to between rows.
local padding_between_rows = 10 + 16
--]]


local function item_ctor_fn(context, index)
	return ItemDetail({width = context.item_width, height = context.item_height})
end

local function apply_fn(context, widget, data, index)
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
		widget.real_component = data.real_component
	else
		widget:SetText(nil)
		widget:SetIcon(nil, nil)
		widget.component = nil
		widget.real_component = nil
	end
end

local function MakeGrid(item_width, item_height, padding_between_rows)
	local TEMPLATES = require "widgets/redux/templates"

	return TEMPLATES.ScrollingGrid({}, {
		scroll_context = {
			item_width = item_width,
			item_height = item_height,
			padding_between_rows = padding_between_rows,

		},
		num_visible_rows = 3,
		num_columns = 1,
		widget_width = item_width,
		widget_height = item_height + padding_between_rows,
		scrollbar_offset = 15, -- Took this number from the math in insightscrolllist.
		scrollbar_height_offset = 0,
		peek_percent = 0.15, -- too much peek just clones the last item
		allow_bottom_empty_row = false,
		apply_fn = apply_fn,
		item_ctor_fn = item_ctor_fn,
	})
end


local InsightPage = Class(Widget, function(self, name, width, height, padding_between_rows)
	Widget._ctor(self, "InsightPage")
	assert(type(name) == "string", "Page expected name as first argument")

	self._name = name
	self.items = {}
	self.item_width = width
	self.item_height = height
	self.padding_between_rows = padding_between_rows

	assert(self.item_width, "missing width")
	assert(self.item_height, "missing height")
	assert(self.padding_between_rows, "missing padding")

	--self.main = self:AddChild(Image(DEBUG_IMAGE()))
	--self.main:SetSize(400, 290)
	--self.main:SetPosition(5, -25)

	if IS_DST then
		self.list = self:AddChild(MakeGrid(self.item_width, self.item_height, self.padding_between_rows))
	else
		--[[
			num_visible_rows = 3,
			num_columns = 1,
			widget_width = item_width,
			widget_height = item_height + padding_between_rows,
			scrollbar_offset = 15, -- Took this number from the math in insightscrolllist.
			scrollbar_height_offset = 0,
			peek_percent = 0, -- too much peek just clones the last item
			allow_bottom_empty_row = false,
			apply_fn = apply_fn,
			item_ctor_fn = item_ctor_fn,
		]]
		self.list = self:AddChild(InsightScrollList({
			scroll_context = {},
			item_ctor_fn = item_ctor_fn,
			apply_fn = apply_fn,
			widget_width = self.item_width,
			widget_height = self.item_height,
			num_visible_rows = 3,
			row_padding = self.padding_between_rows
		}))
	end

	self.list:SetPosition(-5, -25)
	self.focus_forward = self.list
	self:Hide()
end)

--[[
function InsightPage:OnGainFocus()
	mprint(self._name, "page gain focus ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	self.list:SetFocus()
	--self._base.OnGainFocus(self)
end

function InsightPage:OnLoseFocus()
	mprint(self._name, "page lose focus ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	self.list:ClearFocus()
	--self._base.OnLoseFocus(self)
end
--]]

--[[
function InsightPage:OnControl(...)
	mprint("InsightPage OnControl:", self.focus, "| list:", self.list.focus)
	return self._base.OnControl(self, ...)
end
--]]

--[[
function InsightPage:ScrollDown(...)
	return self.list:ScrollDown(...)
end

function InsightPage:ScrollUp(...)
	return self.list:ScrollUp(...)
end
--]]

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
	if type(key) ~= "string" then
		error("key expected to be a string")
	end
	if type(data) ~= "table" then
		error("data expected to be a table")
	end
	
	if self:GetItem(key) ~= nil then
		error("key is a duplicate")
	end

	data.key = key

	self.items[#self.items+1] = data
	self:Refresh()
end

function InsightPage:EditItem(key, data)
	local key = key
	if type(key) ~= "string" or type(data) ~= "table" then
		error("InsightPage::EditItem | key expected string, data expected table")
	end

	for _, item in pairs(self.items) do
		if item.key == key then
			item.text = data.text -- in case they are nil
			item.icon = data.icon -- in case they are nil
			for j,k in pairs(data) do
				item[j] = k
			end
			self:Refresh()
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