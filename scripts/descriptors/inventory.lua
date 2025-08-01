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

-- inventory.lua
local inventory_cache = setmetatable({}, {__mode="kv"})
local listeners_hooked = setmetatable({}, {__mode="kv"})

local function SortDescriptors(a, b)
	local p1, p2 = a[1] or 0, b[1] or 0

	if p1 == p2 and a[2] and b[2] then
		return a[2] < b[2]
	else
		return p1 > p2
	end
end

local function Uncache(inst)
	inventory_cache[inst] = nil
end


local function GetInventoryData(self)
	local inst = self.inst
	
	-- Caching the inventory logic for convenience.
	local inventoryData = inventory_cache[inst]
	if not inventoryData then
		inventoryData = {
			prefabCounts = {}, -- [prefab = int],
			items = {}
		}

		for k = 1, inst.components.inventory.maxslots do
			local item = inst.components.inventory.itemslots[k]
			if item ~= nil then
				local stackSize = item.components.stackable and item.components.stackable:StackSize() or 1
				if item.prefab then
					inventoryData.prefabCounts[item.prefab] = (inventoryData.prefabCounts[item.prefab] or 0) + stackSize
				end
				inventoryData.items[#inventoryData.items+1] = {
					inst = item,
					itemSlotIndex = k,
					stackSize = stackSize,
				}
			end
		end
		inventory_cache[inst] = inventoryData

		if not listeners_hooked[inst] then
			listeners_hooked[inst] = true
			inst:ListenForEvent("itemlose", Uncache)
			inst:ListenForEvent("itemget", Uncache)
		end
	end

	return inventoryData
end


local function GetEquipItemDetails(item, context)
	local components_to_check = {"perishable", "armor", "fueled", "finiteuses"}

	-- This is going to get a little funky. 
	-- I'm turning this from a list into a dictionary mid-iteration.
	-- Feels weird!
	for i = 1, #components_to_check do
		local cmpName = components_to_check[i]
		components_to_check[i] = nil

		local component = item.components[cmpName]
		local descriptor = Insight.descriptors[cmpName]

		if component and descriptor and descriptor.Describe then
			components_to_check[cmpName] = descriptor.Describe(component, context)
		end
	end

	return components_to_check
end

local function DescribeEquipSlot(self, context, equip_slot)
	local alt_description

	local highestPriority = 0
	local head_item = self:GetEquippedItem(equip_slot)

	if head_item then
		-- hm..
		--[[
		local data = GetEntityInformation(head_item, context.player, context.params)
		return data
		--]]

		local slotString = context.lstr.inventory[equip_slot .. "_describe"]
		local item_describes = GetEquipItemDetails(head_item, context)
		local list = {}

		for cmpName, described in pairs(item_describes) do
			highestPriority = math.max(highestPriority, described.priority)
			list[#list+1] = {described.priority, slotString .. (described.description or "")}
		end

		table.sort(list, SortDescriptors)

		for i = 1, #list do
			alt_description = (alt_description or "") .. list[i][2] .. (i < #list and "\n" or "")
		end
	end

	if not alt_description then
		return
	end

	return {
		name = "inventory.DescribeEquipSlot(" .. equip_slot .. ")",
		priority = highestPriority,
		alt_description = alt_description
	}
end

local function Describe(self, context)
	if self.inst.components.follower then
		return DescribeEquipSlot(self, context, EQUIPSLOTS.HEAD), DescribeEquipSlot(self, context, EQUIPSLOTS.HANDS)
	else
		-- TODO: Figure out when to show inventory and fix other things that might be dependent on similar calls.
		-- TODO: Finish this
		
	end
end



return {
	Describe = Describe,
	GetInventoryData = GetInventoryData
}