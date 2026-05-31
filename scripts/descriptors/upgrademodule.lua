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

-- upgrademodule.lua
local MODULE_PREFIX = "wx78module_"

local module_describers = {}

local function IsSkillActivated(inst, skill)
    return inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated(skill)
end

--- This describes the "Hardy Circuit".
--- Provides max health information in addition to armor based on skills.
module_describers.maxhealth = function(self, context)
	-- Just the raw max health increase.
	local description = string.format(context.lstr.upgrademodule.module_describers.maxhealth, TUNING.WX78_MAXHEALTH_BOOST)

	-- Post-armor combat damage reduction.
	-- The actual "armor" values go through this alphabuff modifier in GetHealthCircuitArmor.
	local damage_reduction_percent = 1 * TUNING.SKILLS.WX78.MAXHEALTH_ARMOR_ALPHABUFF_2
	local combat_damage_reduction = string.format(context.lstr.upgrademodule.module_describers.maxhealth_armor, damage_reduction_percent * 100)

	local alt_description = CombineLines(description, combat_damage_reduction)

	if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") then
		description = alt_description
	end

	return {
		name = "maxhealth",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- This describes the "Super-Hardy Circuit".
--- Provides max health information in addition to armor based on skills.
module_describers.maxhealth2 = function(self, context)
	-- Just the raw max health increase.
	local description = string.format(context.lstr.upgrademodule.module_describers.maxhealth, TUNING.WX78_MAXHEALTH_BOOST * TUNING.WX78_MAXHEALTH2_MULT)
	
	-- Post-armor combat damage reduction.
	-- The actual "armor" values go through this alphabuff modifier in GetHealthCircuitArmor.
	local damage_reduction_percent = TUNING.SKILLS.WX78.MAXHEALTH2_ARMOR_MULT * TUNING.SKILLS.WX78.MAXHEALTH_ARMOR_ALPHABUFF_2
	local combat_damage_reduction = string.format(context.lstr.upgrademodule.module_describers.maxhealth_armor, damage_reduction_percent * 100)

	local alt_description = CombineLines(description, combat_damage_reduction)

	if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") then
		description = alt_description
	end

	return {
		name = "maxhealth2",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- This describes the "Gastrogain Circuit".
module_describers.maxhunger1 = function(self, context)
	local description = string.format(context.lstr.upgrademodule.module_describers.maxhunger, TUNING.WX78_MAXHUNGER1_BOOST)

	local hunger_slow_skill_percent = 
		IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") and TUNING.SKILLS.WX78.MAXHUNGER1_SLOWPERCENT_ALPHABUFF_2 or
		IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_1") and TUNING.SKILLS.WX78.MAXHUNGER1_SLOWPERCENT_ALPHABUFF

	if hunger_slow_skill_percent then
		description = description .. "\n" .. string.format(
			context.lstr.hunger_slow,
			(1 - hunger_slow_skill_percent) * 100
		)
	end

	return {
		name = "maxhunger1",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- This describes the "Super-Gastrogain Circuit".
module_describers.maxhunger = function(self, context)
	local description = string.format(context.lstr.upgrademodule.module_describers.maxhunger, TUNING.WX78_MAXHUNGER_BOOST)
	
	local hunger_slow_skill_percent = 
		IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") and TUNING.SKILLS.WX78.MAXHUNGER_SLOWPERCENT_ALPHABUFF_2 or
		IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_1") and TUNING.SKILLS.WX78.MAXHUNGER_SLOWPERCENT_ALPHABUFF
		or TUNING.WX78_MAXHUNGER_SLOWPERCENT

	local hunger_slow = string.format(
		context.lstr.hunger_slow,
		(1 - TUNING.WX78_MAXHUNGER_SLOWPERCENT) * 100
	)

	if hunger_slow_skill_percent then
		description = description .. "\n" .. string.format(
			context.lstr.hunger_slow,
			(1 - hunger_slow_skill_percent) * 100
		)
	end

	return {
		name = "maxhunger",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- Processing Circuit
module_describers.maxsanity1 = function(self, context)
    -- Base Max Sanity Boost
    local description = string.format(context.lstr.upgrademodule.module_describers.maxsanity, TUNING.WX78_MAXSANITY1_BOOST)

    -- The first alpha buff enables the negative sanity aura modifier.
	if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_1") then
		
		-- The second one adds the dapperness multiplier.
		if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") then
			local dapperness_mult = string.format(context.lstr.sanity.dapperness_mult, TUNING.SKILLS.WX78.MAXSANITY1_DAPPERNESS_MULT * 100)
			description = description .. "\n" .. dapperness_mult
		end

		local sanity_mod = TUNING.SKILLS.WX78.MAXSANITY1_SANITY_MOD_ALPHABUFF
		if sanity_mod then
			description = description .. "\n" .. string.format(
				context.lstr.sanityaura.negative_aura_modifier,
				(1 - sanity_mod) * 100
			)
		end
	end

    return {
		name = "maxsanity1",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- Super-Processing Circuit
module_describers.maxsanity = function(self, context)
    -- Base Max Sanity Boost
    local description = string.format(context.lstr.upgrademodule.module_describers.maxsanity, TUNING.WX78_MAXSANITY_BOOST)
    
    -- Dapperness
	local dapperness = string.format(
        context.lstr.dapperness,
        FormatDecimal(TUNING.WX78_MAXSANITY_DAPPERNESS * 60, 1)
    )
    description = description .. "\n" .. dapperness

    -- The first alpha buff enables the negative sanity aura modifier.
	if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_1") then

		-- The second one adds the dapperness multiplier.
		if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") then
			local dapperness_mult = string.format(context.lstr.sanity.dapperness_mult, TUNING.SKILLS.WX78.MAXSANITY_DAPPERNESS_MULT * 100)
			description = description .. "\n" .. dapperness_mult
		end

		local sanity_mod = TUNING.SKILLS.WX78.MAXSANITY_SANITY_MOD_ALPHABUFF
		if sanity_mod then
			description = description .. "\n" .. string.format(
				context.lstr.sanityaura.negative_aura_modifier,
				(1 - sanity_mod) * 100
			)
		end
	end

    return {
		name = "maxsanity",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- Beanbooster Circuit
module_describers.bee = function(self, context)
	local health_regen = string.format(
		context.lstr.upgrademodule.module_describers.bee,
		TUNING.WX78_BEE_HEALTHPERTICK,
		TUNING.WX78_BEE_TICKPERIOD,
		TUNING.WX78_BEE_HEALTHPERTICK * (TUNING.TOTAL_DAY_TIME / TUNING.WX78_BEE_TICKPERIOD)
	)

	local max_shield = string.format(context.lstr.upgrademodule.module_describers.bee_shield, 
		TUNING.SKILLS.WX78.BEE_SHIELDPERCENT * context.player.components.health.maxhealth,
		TUNING.SKILLS.WX78.BEE_SHIELDPERCENT * 100
	)

	local shield_charge_amt = string.format(context.lstr.upgrademodule.module_describers.bee_shield_regen, 
		TUNING.SKILLS.WX78.BEE_SHIELD_REGEN_PER_SECOND
	)

	local description = health_regen
	local alt_description = CombineLines(health_regen, max_shield, shield_charge_amt)

	if IsSkillActivated(context.player, "wx78_circuitry_alphabuffs_2") then
		description = alt_description
	end
	
	return {
		name = "bee",
		priority = 1,
		description = description,
		alt_description = alt_description
	}, module_describers.maxsanity(self, context)
end

--- Rangebooster Circuit
module_describers.radar = function(self, context)
	local alt_description, alt = string.format(context.lstr.upgrademodule.module_describers.radar, TUNING.SKILLS.WX78.RADAR_SCOUTDRONERANGE), nil

	if IsSkillActivated(context.player, "wx78_circuitry_betabuffs_1") then
		description = alt_description
	end

	return {
		name = "radar",
		priority = 0,
		description = description,
		alt_description = alt_description,
	}
end

--- Chorusbox Circuit
module_describers.music = function(self, context)
	local sanity_aura = string.format(
		context.lstr.upgrademodule.module_describers.music, 
		FormatDecimal(TUNING.WX78_MUSIC_SANITYAURA * 60, 1),
		math.sqrt(TUNING.WX78_MUSIC_AURADSQ) / 4
	)
	
	local tend_range = string.format(
		context.lstr.upgrademodule.module_describers.music_tend,
		TUNING.WX78_MUSIC_TENDRANGE / 4
	)

	local followers = string.format(context.lstr.followers, TUNING.SKILLS.WX78.MUSIC_MAXFOLLOWERS)

	local description = CombineLines(sanity_aura, tend_rangei)
	local alt_description = CombineLines(sanity_aura, tend_range, followers)

	if IsSkillActivated(context.player, "wx78_circuitry_betabuffs_1") then
		description = alt_description
	end

	return {
		name = "music",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

--- Acceleration Circuit
module_describers.movespeed = function(self, context)
	-- +1 to ignore the movespeed 0 thing
	-- +1 and another to figure out what the speed boost would be if i was inserting a chip
	local num = (context.player._movespeed_chips or 0) + 1 + 1

	-- this is kind of a mess
	local str = ""
	local len = #TUNING.WX78_MOVESPEED_CHIPBOOSTS
	for i = 2, len do
		local boost = (TUNING.WX78_MOVESPEED_CHIPBOOSTS[i] - TUNING.WX78_MOVESPEED_CHIPBOOSTS[i - 1]) * 100
		str = str .. ApplyColor(
			(i == num and "<u>" or "") .. boost .. "%" .. (i == num and "</u>" or ""),
			i == num and "#469de8" or "DAIRY"
		)
		if i < len then
			str = str .. "/"
		end
	end

	return {
		name = "movespeed",
		priority = 0,
		description = string.format(context.lstr.upgrademodule.module_describers.movespeed, str),
		alt_description = alt_description
	}
end

-- Super-Acceleration Circuit
module_describers.movespeed2 = module_describers.movespeed

-- Thermal Circuit
module_describers.heat = function(self, context)
	local description = string.format(
		context.lstr.upgrademodule.module_describers.heat,
		TUNING.WX78_MINTEMPCHANGEPERMODULE
	) .. "\n" .. string.format(
		context.lstr.upgrademodule.module_describers.heat_drying,
		0.1
	)

	return {
		name = "heat",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

-- Optoelectronic Circuit
--[[
module_describers.nightvision = function(self, context)
	return nil
end
--]]

-- Refrigerant Circuit
module_describers.cold = function(self, context)
	local description = string.format(context.lstr.upgrademodule.module_describers.cold, TUNING.WX78_MINTEMPCHANGEPERMODULE)

	return {
		name = "cold",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

-- Electrification Circuit
module_describers.taser = function(self, context)
	local description = string.format(
		context.lstr.upgrademodule.module_describers.taser,
		TUNING.WX78_TASERDAMAGE,
		context.lstr.weapon_damage_type.electric,
		0.3
	)

	return {
		name = "taser",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end

-- Illumination Circuit
--[[
module_describers.light = function(self, context)
	local description = string.format(
		context.lstr.upgrademodule.module_describers.light,
		TUNING.WX78_LIGHT_BASERADIUS,
		TUNING.WX78_LIGHT_EXTRARADIUS
	)

	return {
		name = "light",
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end
--]]

local function Describe(self, context)
	-- wx78module_
	local module_name = self.inst.prefab:sub(#MODULE_PREFIX + 1)

	if module_describers[module_name] then
		local res = {module_describers[module_name](self, context)}
		for i,v in pairs(res) do
			v.name = "upgrademodule_" .. (v.name or module_name)
		end
		return unpack(res)
	end
end

return {
	Describe = Describe
}
