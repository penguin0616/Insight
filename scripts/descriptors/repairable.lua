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

-- repairable.lua
local function CanRepair(self, repair_item)
	if self.testvalidrepairfn and not self.testvalidrepairfn(self.inst, repair_item) then
		return false
	elseif repair_item.components.repairer == nil or self.repairmaterial ~= repair_item.components.repairer.repairmaterial then
		return false
	elseif self.checkmaterialfn ~= nil then
		local success, reason = self.checkmaterialfn(self.inst, repair_item)
		if not success then
			return false
		end
	end

	return true
end

local function Describe(self, context)
	local description, alt_description

	if self.finiteusesrepairable and self.inst.components.finiteuses then
		-- I consider this to be in the realm of "refueling" and as such shouldn't be affected by the repair config.
		
		local held_item = context.player.components.inventory and context.player.components.inventory:GetActiveItem()
		if held_item and CanRepair(self, held_item) then
			local use_value = held_item.components.repairer.finiteusesrepairvalue or 0
			local percent_restore = use_value / self.inst.components.finiteuses.total
			
			description = string.format(context.lstr.repairer.held_repair, held_item.prefab, use_value, Round(percent_restore * 100, 0))
			return {
				priority = 0,
				description = description,
				alt_description = alt_description
			}
		end
		return
	end

	if not (context.config["repair_values"] == false or context.config["repair_values"] == 0) then
		return
	end

	local workable = self.inst.components.workable

	if workable == nil then -- don't care about health too?
		return
	end

	if self.inst:HasTag("chess") then
		-- ok
		description = string.format(context.lstr.repairable.chess, 6 - workable.workleft)
	end

	return {
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}