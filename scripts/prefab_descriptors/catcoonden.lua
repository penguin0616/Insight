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

-- catcoonden.lua [Prefab]

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

-- catcoonden.lua [Prefab]
local function SummarizeInventory(inst)
	if not inst.components.inventory then
		-- Doesn't have inventory in DS or DLCs
		return
	end

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
	local description = nil

	if inst.lives_left then
		description = string.format(context.lstr.catcoonden.lives, inst.lives_left, 9)
		if inst.lives_left <= 0 and inst.delay_end then
			local remaining_time = inst.delay_end - GetTime()

			if remaining_time > 0 then
				description = description .. "\n" .. string.format(context.lstr.catcoonden.regenerate, context.time:SimpleProcess(remaining_time))
			else
				description = description .. "\n" .. context.lstr.catcoonden.waiting_for_sleep
			end
		end
	end

	local inventory_string = SummarizeInventory(inst)
	description = CombineLines(description, inventory_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}