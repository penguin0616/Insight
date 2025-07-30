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

-- molehill.lua [Prefab]
local function SummarizeInventory(inst)
	local inventoryData = Insight.descriptors.inventory and Insight.descriptors.inventory.GetInventoryData(inst.components.inventory)

	if not inventoryData then
		return
	end
	
	local inventory_string = {}
	for prefab, amt in pairs(inventoryData.prefabCounts) do
		local str = string.format("<color=%s><prefab=%s></color>(<color=DECORATION>%d</color>)", "#eeeeee", prefab, amt)
		inventory_string[#inventory_string+1] = str
	end

	if #inventory_string > 0 then
		return table.concat(inventory_string, "\n")
	end
end

local function Describe(inst, context)
	local description = SummarizeInventory(inst)
	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe,
	SummarizeInventory = SummarizeInventory
}