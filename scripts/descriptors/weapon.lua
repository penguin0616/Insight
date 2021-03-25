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
local world_type = GetWorldType()

local SLINGSHOT_AMMO_DATA = {}

for i,v in pairs(_G.Prefabs) do
	-- skins (glomling_winter) are missing .fn i think
	if v.fn and debug.getinfo(v.fn, "S").source == "scripts/prefabs/slingshotammo.lua" then
		if v.name:sub(-5) == "_proj" then
			local ammo_data = util.getupvalue(v.fn, "v")
			SLINGSHOT_AMMO_DATA[ammo_data.name] = ammo_data
		end
	end
end

local function GetSlingshotAmmoData(inst)
	--mprint(require("/prefabs/slingshotammo"))
	-- prefabs/slingshotammo.lua

	--[[
	local damage = "?"

	if SLINGSHOT_AMMO_DATA[inst.prefab] then
		damage = SLINGSHOT_AMMO_DATA[inst.prefab].damage or 0
	end
	--]]

	--[[
	if inst.prefab == "slingshotammo_rock" then
		damage = TUNING.SLINGSHOT_AMMO_DAMAGE_ROCKS or damage
	elseif inst.prefab == "slingshotammo_gold" then
		damage = TUNING.SLINGSHOT_AMMO_DAMAGE_GOLD or damage
	elseif inst.prefab == "slingshotammo_marble" then
		damage = TUNING.SLINGSHOT_AMMO_DAMAGE_MARBLE or damage
	elseif inst.prefab == "slingshotammo_thulecite" then
		damage = TUNING.SLINGSHOT_AMMO_DAMAGE_THULECITE or damage
	elseif inst.prefab == "slingshotammo_slow" then
		damage = TUNING.SLINGSHOT_AMMO_DAMAGE_SLOW or damage
	elseif inst.prefab == "trinket_1" then
		damage = TUNING.SLINGSHOT_AMMO_DAMAGE_TRINKET_1 or damage
	end
	--]]

	return SLINGSHOT_AMMO_DATA[inst.prefab]
end

local function GetDamageModifier(combat, context)
	if not combat or not context.config["account_combat_modifiers"] then
		return 1
	end

	if world_type == -1 then
		return (combat.damagemultiplier or 1) * combat.externaldamagemultipliers:Get()
		--return combat.externaldamagemultipliers:Get()
	elseif world_type == 0 or world_type == 1 then
		return combat.damagemultiplier or 1
	else
		return combat:GetDamageModifier()
	end
end

local POISONOUS_WEAPONS = {"blowdart_poison", "spear_poison", }

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

	local multiplier = GetDamageModifier(owner.components.combat, context)

	-- Add obsidian power to multiplier
	if inst.components.obsidiantool then -- only have to worry about it in sw or hamlet, which already agrees with the number formatting
		local charge, maxcharge = inst.components.obsidiantool:GetCharge()
		local damage_mod = Lerp(0, 1, charge/maxcharge) --Deal up to double damage based on charge.
		multiplier = multiplier + damage_mod
	end

	-- Get Damage
	local damage = owner.components.combat.defaultdamage --or TUNING.UNARMED_DAMAGE
	if world_type == -1 or world_type >= 2 then
		-- DS Weapon:GetDamage()
		-- DST Weapon:GetDamage(attacker, target)
		damage = self:GetDamage(owner) or damage
	else
		damage = self.damage or damage
	end

	local _stimuli = self.stimuli
	-- Weapon type
	if _stimuli == "electric" then
		
		damage = damage * TUNING.ELECTRIC_DAMAGE_MULT

	elseif self.stimuli == "poisonous" or util.table_find(POISONOUS_WEAPONS, inst.prefab) then -- turns out the game doesn't set the .stimuli
		_stimuli = "poisonous"
	elseif self.stimuli == "thorns" then
		
	end

	-- Walter's slingshot
	if inst:HasTag("slingshot") then -- walter's slingshot
		local ammo = inst.components.container:GetItemInSlot(1)
		if ammo then
			local ammo_data = GetSlingshotAmmoData(ammo)

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

	_stimuli = _stimuli or "normal"
	local damage_string = string.format(context.lstr.weapon_damage, context.lstr.weapon_damage_type[_stimuli] or context.lstr.weapon_damage_type.normal, Round(damage * multiplier, 1) or "?")

	description = CombineLines(damage_string, attack_range)

	return {
		priority = 49,
		description = description,
		attack_range = self.attackrange
	}
end



return {
	Describe = Describe,
	GetSlingshotAmmoData = GetSlingshotAmmoData
}