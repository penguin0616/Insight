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

local module = {}

local RichText = import("widgets/RichText")
local infotext_common = import("uichanges/infotext_common").Initialize()

local function countnewlines(str)
	return select(2, str:gsub("\n", "\n"))
end

local function trim(str)
	str = str:gsub("\n ", "\n")
	if str:sub(1, 1) == "\n" then
		str = str:sub(2)
	end

	local s = str:find("\n*$")
	return str:sub(1, s-1)
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

local function OnInventoryBarPostInit(inventoryBar)
	inventoryBar.insightText = inventoryBar.actionstring:AddChild(RichText())
	inventoryBar.insightText:SetSize(infotext_common.configs.inventorybar_insight_font_size)

	local oldActionStringTitle_SetString = inventoryBar.actionstringtitle.SetString
	inventoryBar.actionstringtitle.SetString = function(self, str)
		local inv_item, active_item = GetControllerSelectedInventoryItem(inventoryBar)

		if (inv_item or active_item) and DEBUG_SHOW_PREFAB then
			str = str .. string.format(" [%s]", (inv_item or active_item).prefab)
        end
		
		oldActionStringTitle_SetString(self, str)
	end

	--[[
	inventoryBar.actionstringtitle.SetPosition = function(self, x, y, z)

	end
	--]]

	--[[
	local oldOnUpdate = inventoryBar.OnUpdate
	inventoryBar.OnUpdate = function(self, dt)
		if self.insightText.size ~= infotext_common.configs.inventorybar_insight_font_size then
			self.insightText:SetSize(infotext_common.configs.inventorybar_insight_font_size)
		end

		if self.actionstringbody:GetSize() ~= infotext_common.configs.inventorybar_insight_font_size then
			-- Whatever! I'll adjust both because it just makes sense to do so.
			self.actionstringbody:SetSize(infotext_common.configs.inventorybar_insight_font_size)
		end

		-- I want the normal position logic to go through (OnUpdate -> UpdateCursor -> UpdateCursorText)
		-- before I make adjustments.
		oldOnUpdate(self, dt)
		local titlepos = self.actionstringtitle:GetPosition()
		local bodypos = self.actionstringbody:GetPosition()
		local bodyw, bodyh = self.actionstringbody:GetRegionSize()

		local minimum_height = bodypos.y + bodyh/2 - self.actionstringbody.size/2 + self.actionstringtitle.size
		mprint(titlepos.y, bodypos.y, minimum_height)
		if titlepos.y < minimum_height then
			self.actionstringtitle:SetPosition(titlepos.x, minimum_height)
		end
	end
	--]]

	local oldUpdateCursorText = inventoryBar.UpdateCursorText
	inventoryBar.UpdateCursorText = function(self)
		-- I want the normal position logic to go through (UpdateCursor -> UpdateCursorText)
		-- before I make adjustments.
		oldUpdateCursorText(self)
		local titlepos = self.actionstringtitle:GetPosition()
		local bodypos = self.actionstringbody:GetPosition()
		local bodyw, bodyh = self.actionstringbody:GetRegionSize()

		-- The bodypos needs to be adjusted first, because the title pos depends on it.

		-- What's happening here is that for every line of Insight text beyond 1,
		-- there seems to be an extra half line space between the body and Insight.
		-- This only happens when the controller inventory is open.
		if self.open and IS_DST then
			bodypos.y = bodypos.y + self.actionstringbody.size/2 -- I don't know why it's exactly this short after trimming the newlines.
			self.actionstringbody:SetPosition(bodypos)
		end

		--mprint("bodypos", bodypos)

		-- Maybe I should put this in the open check.
		local minimum_height = bodypos.y + bodyh/2 - self.actionstringbody.size/2 + self.actionstringtitle.size
		--mprint(titlepos.y, bodypos.y, minimum_height)
		if titlepos.y < minimum_height then
			self.actionstringtitle:SetPosition(titlepos.x, minimum_height)
		end
	end

	--[[
	inventoryBar.actionstringbody.SetPosition = function(self, ...)
		mprint("setpos", ...)
		local a, b = inventoryBar.actionstringbody:GetRegionSize()
		mprint("\t", a, b)
		mprint(debugstack())
		return inventoryBar.SetPosition(self, ...)
	end
	--]]

	local oldActionStringBody_SetString = inventoryBar.actionstringbody.SetString
	inventoryBar.actionstringbody.SetString = function(self, text)
		if not localPlayer then
			return
		end
		
		-- Get Current Item
		local inv_item, active_item = GetControllerSelectedInventoryItem(inventoryBar)
		local selected = inv_item or active_item

		-- Fetch information
		local entityInformation = RequestEntityInformation(inv_item or active_item, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })
		local itemDescription = nil
		if entityInformation and entityInformation.information then
			itemDescription = entityInformation.information
		end

		inventoryBar.insightText:SetString(itemDescription)

		--local hovertext_lines = select(2, text:gsub("\n", "\n")) + 1 -- This is short by 1.

		local size_ratio = inventoryBar.insightText:GetSize() / self:GetSize()

		local description_lines = inventoryBar.insightText.line_count or 0
		local textPadding = ""
		--local total_lines = math.ceil(description_lines * (size_ratio))

		--mprintf("description lines: %s | adjusted total: %s", description_lines, total_lines)
		--mprint("|" .. text .. "|", countnewlines(text), "|" .. trim(text) .. "|")

		if inventoryBar.open then
			text = trim(text) -- There's a whole bunch of extra newlines when the controllerinventory is open. Not sure why.
		end

		--mprint("|" .. text .. "|", countnewlines(text))
		if itemDescription then
			textPadding = string.rep("\n ", description_lines)
		end
		
		-- This compensates for how vertical align is centered.
		local vertical_align_compensation = (description_lines - 1) * (inventoryBar.insightText.size / 2)
		
		-- 5 pixels for padding against the UI frame.
		inventoryBar.insightText:SetPosition(0, vertical_align_compensation + 5 + inventoryBar.insightText.size / 4)

		-- the " " forces it to constantly refresh, widgets/inventorybar:879
		oldActionStringBody_SetString(self, text .. " " .. textPadding)
		--oldActionStringBody_SetString(self, text .. " " .. string.rep("\n ", lines))
	end
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S"):match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	AddClassPostConstruct("widgets/inventorybar", OnInventoryBarPostInit)
end

return module