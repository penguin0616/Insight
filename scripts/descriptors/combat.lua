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
local combatHelper = import("helpers/combat")
local attackRangeHelper = import("helpers/attack_range")

local FAKE_COMBATS = {
	["moonstorm_spark"] = {
		attack_range = 4,
		damage = TUNING.LIGHTNING_DAMAGE
	},
	["moonstorm_glass"] = {
		attack_range = 4,
		damage = 30
	},
	["alterguardian_phase3_trap"] = {
		attack_range = TUNING.ALTERGUARDIAN_PHASE3_TRAP_AOERANGE
	},
	["mushroombomb"] = {
		attack_range = TUNING.TOADSTOOL_MUSHROOMBOMB_RADIUS,
		hit_range = TUNING.TOADSTOOL_MUSHROOMBOMB_RADIUS,
		damage = function(inst)
			local toadstool = inst.components.entitytracker:GetEntity("toadstool")
			return (toadstool ~= nil and toadstool.components.combat ~= nil and toadstool.components.combat.defaultdamage) or
				(inst.prefab ~= "mushroombomb" and TUNING.TOADSTOOL_DARK_DAMAGE_LVL[0]) or
				TUNING.TOADSTOOL_DAMAGE_LVL[0]
		end
	}
}

FAKE_COMBATS.mushroombomb_dark = FAKE_COMBATS.mushroombomb

local ConvertHealthAmountToAge = Insight.descriptors.oldager and Insight.descriptors.oldager.ConvertHealthAmountToAge or function() return 0 end
local world_type = GetWorldType()

local function OnServerInit()
	AddComponentPostInit("combat", attackRangeHelper.HookCombat)

	for prefab, data in pairs(FAKE_COMBATS) do
		AddPrefabPostInit(prefab, function(inst)
			attackRangeHelper.RegisterFalseCombat(inst, data)
		end)
	end
end

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
			damage = Insight.descriptors.weapon and Insight.descriptors.weapon.GetDamage and Insight.descriptors.weapon.GetDamage(weapon.components.weapon, attacker, target) or 0
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
		--return 0
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
		--* (attacker.components.combat.customdamagemultfn ~= nil and attacker.components.combat.customdamagemultfn(attacker, target, weapon, multiplier, mount) or 1)
	-- todo maybe fix that for wanda

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

	local description = string.format(context.lstr.combat.damage, Round(damage, 1))
	if damage_to_player ~= damage then
		description = description .. string.format(context.lstr.combat.damageToYou, Round(damage_to_player, 1))
	end

	return description
end


local function Describe(self, context)
	if not context.config["display_mob_attack_damage"] then
		return
	end

	if self.inst:HasTag("player") then
		-- meh.
		return
	end
	
	if self.inst == context.player then
		-- shouldn't be calculating damage towards myself
		return
	end
	
	local description, alt_description = nil, nil
	local damage = GetAttackerDamageData(self.inst, context.player)

	if damage ~= 0 then
		local damage_to_player = GetRealDamage(damage, self.inst, context.player, { ignoreAttackerMultiplier=true })

		description = string.format(context.lstr.combat.damage, Round(damage, 1))

		if damage_to_player ~= damage then
			description = description .. string.format(context.lstr.combat.damageToYou, Round(damage_to_player, 1))
		end

		if context.player.components.oldager then
			alt_description = description
			
			local age_damage = ConvertHealthAmountToAge(-damage)
			description = string.format(context.lstr.combat.age_damage, Round(age_damage, 1))

			if damage_to_player ~= damage then
				local age_damage_to_player = ConvertHealthAmountToAge(-damage_to_player)
				description = description .. string.format(context.lstr.combat.age_damageToYou, Round(age_damage_to_player, 1))
			end
		end
	end


	return {
		priority = combatHelper.DAMAGE_PRIORITY + 100,
		forge_enabled = true,
		description = description,
		alt_description = alt_description,
	}
end



return {
	OnServerInit = OnServerInit,
	Describe = Describe,
	GetRealDamage = GetRealDamage,
	DescribeDamageForPlayer = DescribeDamageForPlayer,
}