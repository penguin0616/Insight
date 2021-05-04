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
local is_dst = IsDST()
local inventory_cache = setmetatable({}, {__mode="kv"})
local listeners_hooked = setmetatable({}, {__mode="kv"})

local function IsWinter()
	if is_dst then
		return TheWorld.state.iswinter
	else
		return GetSeasonManager():IsWinter()
	end
end

local function Uncache(inst)
	inventory_cache[inst] = nil
end

local function SummarizeInventory(inst)
	local items = inventory_cache[inst]
	if not items then
		items = {}
		for k = 1, inst.components.inventory.maxslots do
			local item = inst.components.inventory.itemslots[k]
			if item ~= nil then
				local stacksize = item.components.stackable and item.components.stackable:StackSize() or 1
				items[#items+1] = {item.prefab, stacksize, item.components.perishable}
			end
		end
		inventory_cache[inst] = items

		if not listeners_hooked[inst] then
			listeners_hooked[inst] = true
			inst:ListenForEvent("itemlose", Uncache)
			inst:ListenForEvent("itemget", Uncache)
		end
	end

	local inventory_string
	for i = 1, #items do
		local item = items[i]
		local perish_percent = ""
		if item[3] and Insight.descriptors.perishable and Insight.descriptors.perishable.GetPerishData then
			local data = Insight.descriptors.perishable.GetPerishData(item[3])
			perish_percent = data and data.percent and ("<color=MONSTER>" .. Round(data.percent * 100, 1) .. "</color>") or ""
		end
		local str = string.format("<color=%s><prefab=%s></color>(<color=DECORATION>%d</color>) %s", "#eeeeee", item[1], item[2], perish_percent)
		inventory_string = (inventory_string or "") .. str
		if i < #items then
			inventory_string = inventory_string .. "\n"
		end
	end

	return inventory_string
end

local function Describe(inst, context)
	local description = nil

	-- become active
	local active_string = nil
	if inst.hibernatetask and not IsWinter() then
		active_string = string.format(context.lstr.lureplant.become_active, context.time:SimpleProcess(GetTaskRemaining(inst.hibernatetask)))
	end

	-- inventory
	local inventory_string = SummarizeInventory(inst)
	description = CombineLines(active_string, inventory_string)
	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe,
	SummarizeInventory = SummarizeInventory
}