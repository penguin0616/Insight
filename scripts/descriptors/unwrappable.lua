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

-- unwrappable.lua
local bundlingAlreadyHandled = nil -- caching to save time
local processed_bundles = setmetatable({}, {__mode = "kv"}) -- {player = { [bundle]={} }}
local NAMES = STRINGS.NAMES
local subfmt = subfmt

local function GetItems(self, context)
	if not processed_bundles[context.player] then
		processed_bundles[context.player] = {}
	end

	if processed_bundles[context.player][self.inst] then
		return processed_bundles[context.player][self.inst]
	end

	local itemdata = self.itemdata
	if not itemdata then
		--mprint(self.inst.prefab)
		processed_bundles[context.player][self.inst] = {}
		return {}
	end

	local items = {
		--[n] = {prefab=prefab, amount=amount}
	}


	-- data, prefab, x, y, z
	for _, slot in pairs(itemdata) do -- deal with nils
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

				local res = d(nil, context)
				item.perishable = res and res.description or nil
			end

			if slot.data.named then
				item.name = slot.data.named.name
			end

			if slot.data.finiteuses then
				local d = Insight.descriptors.finiteuses.FormatUses or function() return {description = "FAILED TO LOAD FINITEUSES COMPONENT"} end

				local res = d(slot.data.finiteuses.uses, context)
				item.uses = res
			end

			if slot.data.fueled and slot.data.fueled.fuel then -- SW&Hamlet don't save fuel if it matches maxfuel
				local d = Insight.descriptors.fueled.FormatFuel or function() return {description = "FAILED TO LOAD FUELED COMPONENT"} end

				local res = d(slot.data.fueled.fuel, context)
				item.fuel = res
			end

			if slot.data.armor then
				local d = Insight.descriptors.armor.FormatCondition or function() return {description = "FAILED TO LOAD CONDITION COMPONENT"} end

				local res = d(slot.data.armor.condition, context)
				item.condition = res
			end
		end

		if not item.name then
			item.display_name = GetPrefabNameOrElse(item.prefab, "**%s")
		end

		items[#items+1] = item
	end

	processed_bundles[context.player][self.inst] = setmetatable(items, { __mode="kv"})

	return items
end

local function MakeDescription(items, context)
	if #items == 0 then
		return
	end
	
	local description, alt_description = "", ""
	for i = 1, #items do
		local item = items[i]
		
		local perishable = item.perishable and (item.perishable .. " ") or ""
		local amount = item.amount
		local name = item.name or item.display_name or ("uh oh...." .. item.prefab)
		local bonus = {}

		--[[
		table.insert(items_string, string.format("<color=%s>%s</color>(<color=DECORATION>%d</color>) %s", "#eeeeee", name, amount, perishable))
		if uses then
			table.insert(bonus[i], uses)
		end
		--]]
		
		local basic = string.format("<color=%s>%s</color>(<color=DECORATION>%d</color>) %s", "#eeeeee", name, amount, perishable)
		description = description .. basic
		alt_description = alt_description .. basic

		if item.uses then bonus[#bonus+1] = item.uses end
		if item.fuel then bonus[#bonus+1] = item.fuel end
		if item.condition then bonus[#bonus+1] = item.condition end

		if #bonus > 0 then
			alt_description = alt_description .. "- " .. table.concat(bonus, ", ")
		end

		if i < #items then
			description = description .. "\n"
			alt_description = alt_description .. "\n"
		end
	end


	--[[
	local description = table.concat(items_string, "\n")
	


	return table.concat(items_string, "\n"), (#bonus > 0 and table.concat(bonus, ", ") or nil)
	--]]

	return description, alt_description
end

local function Describe(self, context)
	local description, alt_description

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
		description, alt_description = MakeDescription(contents, context)
	end

	--[[
	if not context.fromInspection then
		contents = GetItems(self, context)
	end
	--]]

	return {
		priority = 0,
		description = description,
		alt_description = alt_description,
		contents = contents,
	}
end



return {
	Describe = Describe
}