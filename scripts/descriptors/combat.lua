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
local world_type = GetWorldType()

local function GetAttackerDamageData(attacker, target)
	local damage = attacker.components.combat and attacker.components.combat.defaultdamage or 0
	local mount_damage_multiplier = 1
	local mount_external_damage_multiplier = 1
	local mount_damage_bonus = 0
	
	-- needs revision
	if attacker.components.rider ~= nil and attacker.components.rider:IsRiding() then
		local mount = attacker.components.rider:GetMount()
		if mount ~= nil and mount.components.combat ~= nil then
			damage = mount.components.combat.defaultdamage
			mount_damage_multiplier = mount.components.combat.damagemultiplier or mount_damage_multiplier
			mount_external_damage_multiplier = mount.components.combat.externaldamagemultipliers and mount.components.combat.externaldamagemultipliers:Get() or 1
			mount_damage_bonus = mount.components.combat.damagebonus or mount_damage_bonus
		end

		local saddle = attacker.components.rider:GetSaddle()
		if saddle ~= nil and saddle.components.saddler ~= nil then
			damage = damage + saddle.components.saddler:GetBonusDamage()
		end
	else
		local weapon = attacker.components.inventory ~= nil and attacker.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
		if weapon and weapon.components.weapon then -- monkeys
			damage = Insight.descriptors.weapon.GetDamage(weapon.components.weapon, attacker, target) or 0
		end

		-- attacker damage multiplier
		local attack_damage_multiplier = 1
		if attacker and attacker.components.combat then
			attack_damage_multiplier = attacker.components.combat.damagemultiplier or attack_damage_multiplier
		end

		-- external attack damage multiplier
		local external_attack_damage_multiplier = 1
		if attacker and attacker.components.combat and attacker.components.combat.externaldamagemultipliers then
			external_attack_damage_multiplier = attacker.components.combat.externaldamagemultipliers:Get() or external_attack_damage_multiplier
		end

		return damage
			* attack_damage_multiplier
			* external_attack_damage_multiplier
	end

	return damage, mount_damage_multiplier, mount_external_damage_multiplier, mount_damage_bonus
end


--- Figures out the real amount of damage that is dealt from attacker to target.
local function GetRealDamage(damage, attacker, target, settings)
	settings = settings or {}

	-- i'm getting a headache

	-- can't damage something that doesn't have health
	if target and not target.components.health then
		return 0
	end

	-- immunity
	-- is this something even worth considering
	if target and (target.is_teleporting or target.components.health.invincible or target:HasTag("alwaysblock")) then
		return 0
	end

	if not damage then
		-- aaaaahhhhhhhh
		assert(damage, "Missing damage.")
	end

	-- amount = amount * math.clamp(1 - (self.playerabsorb ~= 0 and afflicter ~= nil and afflicter:HasTag("player") and self.playerabsorb + self.absorb or self.absorb), 0, 1) * math.clamp(1 - self.externalabsorbmodifiers:Get(), 0, 1)
	
	-- percent damage for players
	local damage_percent_for_players = 1
	if attacker and attacker.components.combat and target and target:HasTag("player") then
		damage_percent_for_players = attacker.components.combat.playerdamagepercent or damage_percent_for_players
	end

	-- pvp damage multiplier
	local pvp_damage_multiplier = 1
	if attacker and attacker.components.combat and attacker:HasTag("player") and target and target:HasTag("player") then
		pvp_damage_multiplier = attacker.components.combat.pvp_damagemod or pvp_damage_multiplier
	end

	-- stimuli damage (screw it)
	local stimuli_multiplier = 1

	-- attacker damage multiplier
	local attack_damage_multiplier = 1
	if not settings.ignoreAttackerMultiplier and (attacker and attacker.components.combat) then
		attack_damage_multiplier = attacker.components.combat.damagemultiplier or attack_damage_multiplier
	end

	-- external attack damage multiplier
	local external_attack_damage_multiplier = 1
	if not settings.ignoreAttackerMultiplier and (attacker and attacker.components.combat and attacker.components.combat.externaldamagemultipliers) then
		external_attack_damage_multiplier = attacker.components.combat.externaldamagemultipliers:Get() or external_attack_damage_multiplier
	end

	-- damage absorption from players
	local player_absorb = 0
	if attacker and target and target.components.health then
		if attacker:HasTag("player") then
			player_absorb = target.components.health.playerabsorb or player_absorb
		end
	end

	-- health absorption
	local absorb = 0
	if target and target.components.health then
		absorb = target.components.health.absorb or absorb
	end

	-- external health absorb
	local external_absorb = 0
	if target and target.components.health and target.components.health.externalabsorbmodifiers then
		external_absorb = target.components.health.externalabsorbmodifiers:Get() or external_absorb
	end

	-- external damage taken multiplier
	local external_damage_taken_multiplier = 1
	if target and target.components.combat and target.components.combat.externaldamagetakenmultipliers then
		external_damage_taken_multiplier = target.components.combat.externaldamagetakenmultipliers:Get() or external_damage_taken_multiplier
	end

	-- here we go. don't know if this is accurate at this point, but i'm tired of this
	damage = damage
		* attack_damage_multiplier
		* external_attack_damage_multiplier
		* stimuli_multiplier -- stimuli damage
		* damage_percent_for_players
		* pvp_damage_multiplier
		* external_damage_taken_multiplier


	if world_type == -1 then 
		damage = damage * math.clamp(1 - absorb, 0, 1) * math.clamp(1 - external_absorb, 0, 1)
	else
		-- not DST
		if damage < 0 then
			damage = damage - (damage * absorb)
		end
	end

	return damage
	--[[
		DST combat CalcDamage: return basedamage
        * (basemultiplier or 1)
        * self.externaldamagemultipliers:Get()
        * (multiplier or 1)
        * playermultiplier
        * pvpmultiplier
		* (self.customdamagemultfn ~= nil and self.customdamagemultfn(self.inst, target, weapon, multiplier) or 1)
        + (bonus or 0)
	]]
end

local function DescribeDamageForPlayer(damage, target, context)
	local damage_to_player = damage

	if target and target:HasTag("player") then
		damage_to_player = GetRealDamage(damage, nil, target)
	end

	local description = string.format(context.lstr.damage, Round(damage, 1))
	if damage_to_player ~= damage then
		description = description .. string.format(context.lstr.damageToYou, Round(damage_to_player, 1))
	end

	return description
end


local function Describe(self, context)
	if not context.config["display_mob_attack_damage"] then
		return
	end
	
	local description = nil

	local damage = GetAttackerDamageData(self.inst, context.player)

	if damage ~= 0 then
		local damage_to_player = GetRealDamage(damage, self.inst, context.player, { ignoreAttackerMultiplier=true })

		description = string.format(context.lstr.damage, Round(damage, 1))

		if damage_to_player ~= damage then
			description = description .. string.format(context.lstr.damageToYou, Round(damage_to_player, 1))
		end
	end
	
	--[[

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
	--]]

	-- defaultdamage
	-- playerdamagepercent

	return {
		priority = 49,
		forge_enabled = true,
		description = description,
	}
end



return {
	Describe = Describe,
	GetRealDamage = GetRealDamage,
	DescribeDamageForPlayer = DescribeDamageForPlayer,
}