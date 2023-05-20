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

-- eater.lua
local world_type = GetWorldType()

local function Describe(self, context)
	local description, alt_description = nil, nil

	-- stats for eot stuff
	local eot_string
	local is_eye_equipment = self.inst.prefab == "shieldofterror" or self.inst.prefab == "eyemaskhat"
	local armor = self.inst.components.armor
	if is_eye_equipment and armor then
		--eot_string = string.format(context.lstr.eater.eot_loot, Round(self.hungerabsorption * 100, 0), Round(self.healthabsorption * 100, 0))
	end

	-- held food
	local held_string = nil
	local alt_held_string = nil

	local held_item = context.player.components.inventory and context.player.components.inventory:GetActiveItem()
	if held_item and held_item.components.edible then
		if is_eye_equipment and armor then
			local hunger, health = math.abs(held_item.components.edible:GetHunger(self.inst)) * self.hungerabsorption, math.abs(held_item.components.edible:GetHealth(self.inst)) * self.healthabsorption
			local durability = hunger + health
			local percent = Round((durability / armor.maxcondition) * 100, 0)
			durability = Round(durability, 0)
			held_string = string.format(context.lstr.eater.eot_tofeed_restore, held_item.prefab, durability, percent)
			alt_held_string = string.format(context.lstr.eater.eot_tofeed_restore_advanced, held_item.prefab, durability, hunger, health, percent)
		elseif not is_eye_equipment then
			if (IS_DST and self:PrefersToEat(held_item)) or (IS_DS and self:CanEat(held_item)) and Insight.descriptors.edible and Insight.descriptors.edible.GetFoodStatsForEntity then
				local hunger, sanity, health = Insight.descriptors.edible.GetFoodStatsForEntity(held_item.components.edible, self.inst, context.player, true)
				if hunger then
					hunger, sanity, health = (hunger > 0 and "+" or "") .. hunger, (sanity > 0 and "+" or "") .. sanity, (health > 0 and "+" or "") .. health
					held_string = string.format(context.lstr.eater.tofeed_restore, held_item.prefab, Insight.descriptors.edible.FormatFoodStats(hunger, sanity, health, context))
					alt_held_string = held_string
				end
			end
		end
	end

	-- eater diet
	local eater_diet_string = nil
	if world_type == -1 then
		-- prefers to eat, can eat. UGH.
	end

	description = CombineLines(eot_string, held_string)
	alt_description = CombineLines(eot_string, alt_held_string)

	return {
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}