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

-- weapon.lua
local combatHelper = import("helpers/combat")

local world_type = GetWorldType()
local WEAPON_CACHE = {
	
}

local function DescribeYOTRPillowWeapon(self, context)
	local description, alt_description
	local knockback = string.format(context.lstr.combat.yotr_pillows.knockback, self.inst._knockback, self.inst._strengthmult * 100)
	local laglength = string.format(context.lstr.combat.yotr_pillows.laglength, string.format(context.lstr.time_seconds, self.inst._laglength))
	local prize_value = string.format(context.lstr.combat.yotr_pillows.prize_value, self.inst._prize_value or "?")

	description = CombineLines(knockback, laglength)
	alt_description = CombineLines(description, prize_value)

	return {
		name = "weapon_yotr",
		priority = combatHelper.DAMAGE_PRIORITY + 1,
		description = description,
		alt_description = alt_description,
	}
end

--[[
local function GetCombatCustomDamageMult(player, weapon)
	-- 		* (self.customdamagemultfn ~= nil and self.customdamagemultfn(self.inst, target, weapon, multiplier, mount) or 1)
	if player.components.combat and player.components.combat.customdamagemultfn then
		-- this is more or less a really bad idea
		return player.components.combat.customdamagemultfn(player, nil, weapon, nil, player.components.rider and player.components.rider.mount or nil)
	end
end
--]]
local function WandaCustomCombatDamage(inst, target, weapon, multiplier, mount)
    if mount == nil then
        if weapon ~= nil and weapon:HasTag("shadow_item") then
			return inst.age_state == "old" and TUNING.WANDA_SHADOW_DAMAGE_OLD
					or inst.age_state == "normal" and TUNING.WANDA_SHADOW_DAMAGE_NORMAL
					or TUNING.WANDA_SHADOW_DAMAGE_YOUNG
		else
			return inst.age_state == "old" and TUNING.WANDA_REGULAR_DAMAGE_OLD
					or inst.age_state == "normal" and TUNING.WANDA_REGULAR_DAMAGE_NORMAL
					or TUNING.WANDA_REGULAR_DAMAGE_YOUNG
        end
    end

    return 1
end

-- also used by combat descriptor
local function GetDamage(self, attacker, target)
	-- attacker is the weapon owner
	local damage = nil --attacker.components.combat.defaultdamage --or TUNING.UNARMED_DAMAGE

	if world_type == -1 then -- DST
		-- This'll save me from doing manual stuff myself for projectiles and whatnot.
		if self.inst.scrapbook_weapondamage and type(self.inst.scrapbook_weapondamage) == "number" then
			return self.inst.scrapbook_weapondamage
		end
	
		-- DST is Weapon:GetDamage(attacker, target)
		-- in DST, some modded weapons don't put a nil check for targets. right now, April 5 2021, no vanilla weapons care about the target.
		if self.inst.prefab ~= nil and WEAPON_CACHE[self.inst.prefab] == nil then 
			WEAPON_CACHE[self.inst.prefab] = pcall(self.GetDamage, self, attacker, nil)
		end
			
		if self.inst.prefab == nil or WEAPON_CACHE[self.inst.prefab] == true then -- we know the GetDamage was safe to call.
			damage = self:GetDamage(attacker, target) or damage

		elseif self.inst.prefab and WEAPON_CACHE[self.inst.prefab] == false then -- some mods just overwrite Weapon::GetDamage
			damage = (type(self.damage) == "number" and self.damage) or damage
		end

	elseif world_type >= 2 then -- SW+
		-- SW+ uses Weapon:GetDamage() and falls back to self.damage if no function for damage is present
		damage = self:GetDamage() or damage
	else -- DS, RoG
		-- flat value only
		damage = self.damage or damage
	end

	return damage
end

local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if not context.config["weapon_damage"] then
		return
	end

	local owner = context.player --GetPlayer()

	if not owner.components.combat then
		return
	end

	local multiplier = combatHelper.GetOutgoingDamageModifier(owner.components.combat)

	-- Add obsidian power to multiplier
	if inst.components.obsidiantool then -- only have to worry about it in sw or hamlet, which already agrees with the number formatting
		local charge, maxcharge = inst.components.obsidiantool:GetCharge()
		local damage_mod = Lerp(0, 1, charge/maxcharge) --Deal up to double damage based on charge.
		multiplier = multiplier + damage_mod
	end

	-- Get Damage
	local damage = GetDamage(self, owner, nil) or owner.components.combat.defaultdamage

	-- i think this goes here?
	if context.player.prefab == "wanda" then
		damage = damage * WandaCustomCombatDamage(context.player, nil, self.inst, nil, context.player.components.rider and context.player.components.rider.mount or nil)
	end

	local stimuli_type = combatHelper.IsPrefabPoisonous(self.inst.prefab) and "poisonous" or self.stimuli
	local stimuli_data = combatHelper.GetStimuliData(stimuli_type)

	if stimuli_data == combatHelper.WEAPON_STIMULI_DEFS.electric then
		-- Check if weapon has custom damage mults for electric.
		local electric_damage_mult = self.electric_damage_mult or TUNING.ELECTRIC_DAMAGE_MULT
		local electric_wet_damage_mult = self.electric_wet_damage_mult or TUNING.ELECTRIC_WET_DAMAGE_MULT

		damage = damage * electric_damage_mult
	else
		if stimuli_data.default_damage_modifier then
			damage = damage * stimuli_data.default_damage_modifier
		end
	end

	-- Walter's slingshot
	if inst.components.container and inst:HasTag("slingshot") then -- walter's slingshot
		local ammo = inst.components.container:GetItemInSlot(1)
		if ammo then
			local ammo_data = combatHelper.GetSlingshotAmmoData(ammo.prefab)

			if ammo_data then
				damage = ammo_data.damage or damage
			end
		end
	end

	-- Attack Range
	local attack_range = self.attackrange
	if attack_range then
		attack_range = string.format(context.lstr.attack_range, attack_range)
	end

	local damage_string = string.format(context.lstr.weapon_damage, context.lstr.weapon_damage_type[stimuli_data.name] or context.lstr.weapon_damage_type.normal, Round(damage * multiplier, 1) or "?")

	

	-- Other stuff
	local pillow_info = self.inst:HasTag("pillow") and DescribeYOTRPillowWeapon(self, context) or nil
	if pillow_info and damage == 0 then
		damage_string = nil
	end

	-- Generate description and return datas
	description = CombineLines(damage_string, attack_range)

	return {
		name = "weapon",
		priority = combatHelper.DAMAGE_PRIORITY,
		description = description,
		attack_range = self.attackrange
	}, pillow_info
end



return {
	GetDamage = GetDamage,

	Describe = Describe,
}