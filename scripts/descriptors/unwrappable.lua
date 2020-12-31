--[[
Copyright (C) 2020 penguin0616

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

-- unwrappable.lua
local bundlingAlreadyHandled = nil -- caching to save time
local processed_bundles = setmetatable({}, {__metatable = "k"})
local NAMES = STRINGS.NAMES

local function GetItems(self, context) -- ISSUE:PERFORMANCE
	local itemdata = self.itemdata

	if not itemdata then
		--mprint(self.inst.prefab)
		processed_bundles[self.inst] = {}
		return {}
	end

	local items = {
		--[n] = {prefab=prefab, amount=amount}
	}


	-- data, prefab, x, y, z
	for _, slot in pairs(itemdata) do
		local item = {}
		
		item.prefab = slot.prefab
		item.amount = 1
		item.perishable = nil
		item.name = nil

		-- the data (fake components) aren't really components
		if slot and slot.data then
			-- slot.data.sketchid (int)
			if slot.data.stackable then
				item.amount = slot.data.stackable.stack
			end

			if slot.data.perishable then
				local d = Insight.descriptors.perishable.Describe or function() return {description = "FAILED TO LOAD PERISHABLE COMPONENT"} end
				context.bundleitem = { bundle = self.inst, perishremainingtime = slot.data.perishable.time }

				item.perishable = d(nil, context).description		
			end

			if slot.data.named then
				item.name = slot.data.named.name
			end
		end

		if not item.name then
			local upper = string.upper(item.prefab)
			item.name = NAMES["KNOWN_" .. upper] or NAMES[upper]
		end

		table.insert(items, item)
	end

	processed_bundles[self.inst] = items

	return items
end

local function MakeDescription(items, context)
	local items_string = {}

	for i,item in pairs(items) do
		local perishable = item.perishable or ""
		local amount = item.amount
		local name = item.name or "**" .. item.prefab

		table.insert(items_string, string.format("<color=%s>%s</color>(<color=DECORATION>%d</color>) %s", "#eeeeee", name, amount, perishable))
	end

	return table.concat(items_string, "\n")
end

local function Describe(self, context)
	local description = nil

	if bundlingAlreadyHandled == nil then
		-- https://steamcommunity.com/sharedfiles/filedetails/?id=1916988643 shows bundle information in a much nicer way, also requested in https://github.com/penguin0616/insight/issues/10
		-- since i'm checking this ID specifically, IsDST() is implied
		if KnownModIndex:IsModEnabled("workshop-1916988643") and _G.GetModConfigData("BUNDLE", "workshop-1916988643", true) then
			-- skip
			bundlingAlreadyHandled = true
		else
			bundlingAlreadyHandled = false
		end
	end

	local contents = GetItems(self, context)

	if not context.onlyContents and bundlingAlreadyHandled == false then
		description = MakeDescription(contents, context)
	end

	--[[
	if not context.fromInspection then
		contents = GetItems(self, context)
	end
	--]]

	return {
		priority = 0,
		description = description,
		contents = contents,
	}
end



return {
	Describe = Describe
}