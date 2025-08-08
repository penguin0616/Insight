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

-- lureplant.lua [Prefab]
local inventory_cache = setmetatable({}, {__mode="kv"})
local listeners_hooked = setmetatable({}, {__mode="kv"})

local function IsWinter()
	if IS_DST then
		return TheWorld.state.iswinter
	else
		return GetSeasonManager():IsWinter()
	end
end

local function Uncache(inst)
	inventory_cache[inst] = nil
end

local function SummarizeInventory(inst)
	local inventoryData = Insight.descriptors.inventory and Insight.descriptors.inventory.GetInventoryData(inst.components.inventory)

	if not inventoryData then
		return
	end
	
	local inventory_string
	for i = 1, #inventoryData.items do
		local item = inventoryData.items[i]
		local perish_percent = ""
		if item.inst.components.perishable and Insight.descriptors.perishable and Insight.descriptors.perishable.GetPerishData then
			local data = Insight.descriptors.perishable.GetPerishData(item.inst.components.perishable)
			perish_percent = data and data.percent and ("<color=MONSTER>" .. Round(data.percent * 100, 1) .. "%</color>") or ""
		end
		local str = string.format("<color=%s><prefab=%s></color>(<color=DECORATION>%d</color>) %s", "#eeeeee", item.inst.prefab, item.stackSize, perish_percent)
		inventory_string = (inventory_string or "") .. str
		if i < #inventoryData.items then
			inventory_string = inventory_string .. "\n"
		end
	end

	return inventory_string
end

local function Describe(inst, context)
	local description, alt_description 

	-- become active
	local active_string = nil
	if inst.hibernatetask and not IsWinter() then
		active_string = string.format(context.lstr.lureplant.become_active, context.time:SimpleProcess(GetTaskRemaining(inst.hibernatetask)))
	end

	-- inventory
	local inventory_string

	if not context.complex_config["unique_info_prefabs"][inst.prefab] then
		inventory_string = SummarizeInventory(inst)
	end

	description = active_string
	alt_description = CombineLines(active_string, inventory_string)

	return {
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe,
	SummarizeInventory = SummarizeInventory
}