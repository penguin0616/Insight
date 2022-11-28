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

local item_width = 400
local item_height = 64

local function item_ctor_fn(context, index)
	return ItemDetail({width = item_width, height = item_height})
end

local function apply_fn(context, widget, data, index)
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
		apply_fn = apply_fn,
		item_ctor_fn = item_ctor_fn,
	})
end


local InsightPage = Class(Widget, function(self, name)
	Widget._ctor(self, "InsightPage")
	assert(type(name) == "string", "Page expected name as first argument")

	self._name = name
	self.items = {}

	self.main = self:AddChild(Image(DEBUG_IMAGE()))
	self.main:SetSize(400, 290)
	self.main:SetPosition(5, -25)

	if IS_DST then
		self.list = self.main:AddChild(MakeGrid())
	else
		self.list = self.main:AddChild(InsightScrollList(
			{},
			item_ctor_fn,
			apply_fn,
			item_width,
			item_height,
			3,
			10 + 16
		))
	end

	self:Hide()
end)

--[[
function InsightPage:OnGainFocus()
	mprint(self._name, "page gain focus")
	self.list:SetFocus()
	self._base.OnGainFocus(self)
end

function InsightPage:OnLoseFocus()
	mprint(self._name, "page lose focus")
	self.list:ClearFocus()
	self._base.OnLoseFocus(self)
end
--]]

--[[
function InsightPage:OnControl(...)
	mprint("InsightPage:", self.focus, "| list:", self.list.focus)
	return false
end
--]]

function InsightPage:ScrollDown(...)
	return self.list:ScrollDown(...)
end

function InsightPage:ScrollUp(...)
	return self.list:ScrollUp(...)
end

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