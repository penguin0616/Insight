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

-- combat.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil

	local player = context.player --GetPlayer()
	local damage_reduction = (context.config["account_combat_modifiers"] and player and player.components.health.absorb) or 0

	local weapon = inst.components.inventory ~= nil and inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local damage = self.defaultdamage --Round(self.defaultdamage, 1)

	if weapon and weapon.components.weapon then -- monkeys
		if IsDST() or GetWorldType() >= 2 then
			-- DS Weapon:GetDamage()
			--DST Weapon:GetDamage(attacker, target)
			damage = weapon.components.weapon:GetDamage(inst, player) or damage
		else
			damage = weapon.components.weapon.damage or damage
		end
	end
	
	if type(damage) == "number" and damage ~= 0 then
		local playerDamage = damage * (self.playerdamagepercent or 1)
		playerDamage = playerDamage - (playerDamage * damage_reduction)

		--playerDamage = Round(playerDamage, 1)

		description = string.format(context.lstr.damage, Round(damage, 1))

		if playerDamage ~= damage then
			description = description .. string.format(context.lstr.damageToYou, Round(playerDamage, 1))
		end
	elseif damage == nil then
		if DEBUG_ENABLED then
			description = "[no damage]"
		end
	end

	-- defaultdamage
	-- playerdamagepercent

	return {
		priority = 1,
		description = description
	}
end



return {
	Describe = Describe
}