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
local function SortDescriptors(a, b)
	local p1, p2 = a[1] or 0, b[1] or 0

	if p1 == p2 and a[2] and b[2] then
		return a[2] < b[2]
	else
		return p1 > p2
	end
end

local function Describe(self, context)
	local alt_description

	if not self.inst.components.follower then
		return
	end

	local priority = 0
	local head_item = self:GetEquippedItem(EQUIPSLOTS.HEAD)
	if head_item then
		-- hm..
		--[[
		local data = GetEntityInformation(head_item, context.player, context.params)
		return data
		--]]

		
		-- only things i really care about
		local perishable = (head_item.components.perishable and Insight.descriptors.perishable and Insight.descriptors.perishable.Describe(head_item.components.perishable, context))
		local armor = (head_item.components.armor and Insight.descriptors.armor and Insight.descriptors.armor.Describe(head_item.components.armor, context))
		local fueled = (head_item.components.fueled and Insight.descriptors.fueled and Insight.descriptors.fueled.Describe(head_item.components.fueled, context))

		if not perishable and not armor and not fueled then
			return
		end

		
		local list = {}
		if perishable then
			priority = perishable.priority > priority and perishable.priority or priority
			list[#list+1] = {perishable.priority, context.lstr.inventory.hat_describe .. (perishable.description or "")}
		end
		if armor then
			priority = armor.priority > priority and armor.priority or priority
			list[#list+1] = {armor.priority, context.lstr.inventory.hat_describe .. (armor.description or "")}
		end
		if fueled then
			priority = fueled.priority > priority and fueled.priority or priority
			list[#list+1] = {fueled.priority, context.lstr.inventory.hat_describe .. (fueled.description or "")}
		end

		table.sort(list, SortDescriptors)

		alt_description = CombineLines(
			list[1] and list[1][2] or nil, 
			list[2] and list[2][2] or nil, 
			list[3] and list[3][2] or nil
		)
	end

	return {
		priority = priority,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}