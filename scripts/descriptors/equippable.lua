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

-- equippable.lua
local world_type = GetWorldType()
--[[
	x=ThePlayer.components.sanity.current; print(x)
	ThePlayer.components.inventory:Equip(c_findnext'walrushat');
	ThePlayer:DoTaskInTime(60, function() ThePlayer.components.inventory:Unequip(EQUIPSLOTS.HEAD);c=ThePlayer.components.sanity.current; print(c); print(c-x); end);


	rate_modifier = 1.1
	60
	67.3292594151
	7.3292596415095

	rate_modifier = 1
	60
	66.66296331046
	6.6629633104599
]]
local function GetDappernessForPlayer(self, player)
	if not self.GetDapperness then
		return nil
	end

	local sanity = player.components.sanity
	if not sanity then
		return nil
	end

	if sanity.only_magic_dapperness and not self.is_magic_dapperness then
		return 0
	end

	local dapperness = (sanity.get_equippable_dappernessfn and sanity.get_equippable_dappernessfn(player, self)) or self:GetDapperness(player, sanity and sanity.no_moisture_penalty or false)
	dapperness = dapperness * (sanity.dapperness_mult or 1) * (TUNING.SANITY_DAPPERNESS or 1) * (sanity.rate_modifier or 1)

	return dapperness
end

local function GetSpeedModifier(self, player)
	local speed_modifier = world_type < 2 and self:GetWalkSpeedMult() or self.walkspeedmult or 0.0
	-- alright so in DST, DS, RoG, its a number from 0 to 1. (ie "ARMORMARBLE_SLOW" is 0.7)
	-- in SW & Hamlet, its a negative number. (ie "ARMORMARBLE_SLOW" is -0.3)

	-- so this makes SW and Hamlet consistent with the other versions
	if world_type >= 2 then
		speed_modifier = speed_modifier + 1
	end

	-- account for wolfgang's speed modifiers
	if world_type == -1 and speed_modifier > 0 and speed_modifier < 1 then
		if player and player.components.mightiness and player.components.mightiness:GetState() == "mighty" then
			--speed_modifier = math.min(1, speed_modifier + TUNING.MIGHTY_HEAVY_SPEED_MULT_BONUS)
			speed_modifier = 1;
		end
	end

	return speed_modifier
end

local function Describe(self, context)
	local inst = self.inst
	local description = nil
	local hunger_modifier_string = nil

	local owner = context.player --GetPlayer() --GetItemPossessor(inst) or GetPlayer()
	-- bug where one man band has .dapperfn and it needs leader component of holder, just assume owner is GetPlayer()

	local speed_modifier = GetSpeedModifier(self, owner) - 1
	if speed_modifier ~= 0 then
		-- Round is leaving hidden floating point error? (Round(1.2) - 1 ~= 1.2 - 1); precision error isn't shown unless you use FormatNumber's formatting pattern
		-- FormatNumber had a precision error too. FormatNumber((1.2-1)*100) == +19
		speed_modifier = string.format(context.lstr.speed, FormatDecimal(speed_modifier * 100, 0)) 
	else
		speed_modifier = nil
	end

	-- expressed as sanity gain/loss per SECOND. we want it per MINUTE.
	local dapperness = GetDappernessForPlayer(self, owner)

	if not dapperness or dapperness == 0 then
		dapperness = nil
	else
		dapperness = string.format(context.lstr.dapperness, FormatDecimal(dapperness * 60, 1))
	end

	-- might modify hunger rate
	if owner and owner.components.hunger then
		if world_type == -1 then
			

			-- the problem with using CalculateModifierFromSource is that it has to be equipped to report the real number
			--[[
			-- example of total hunger modifier: 1 * (0.75 [from beargervest]) * (0.6 [from armorslurper]) = 0.45
			local hunger_modifier = owner.components.hunger.burnratemodifiers._modifiers[inst] and owner.components.hunger.burnratemodifiers:CalculateModifierFromSource(inst)
			if hunger_modifier then
				hunger_modifier = (1 - hunger_modifier) -- 1 - 0.75 = 0.25

				if hunger_modifier > 0 then -- slower
					hunger_modifier_string = string.format(context.lstr.hunger_slow, hunger_modifier * 100)
				elseif hunger_modifier < 0 then -- faster
					hunger_modifier_string = string.format(context.lstr.hunger_drain, -hunger_modifier * 100)
				else
					hunger_modifier_string = "¯\\_(ツ)_/¯"
				end
			end

			--]]
			local hunger_modifier
			if inst.prefab == "red_mushroomhat" or inst.prefab == "green_mushroomhat" or inst.prefab == "blue_mushroomhat" then
				hunger_modifier = TUNING.MUSHROOMHAT_SLOW_HUNGER
			elseif inst.prefab == "beargervest" then
				hunger_modifier = TUNING.ARMORBEARGER_SLOW_HUNGER
			elseif inst.prefab == "armorslurper" then
				hunger_modifier = TUNING.ARMORSLURPER_SLOW_HUNGER
			end

			if hunger_modifier then
				hunger_modifier = 1 - hunger_modifier -- i used to do -1 instead of 1-
				if hunger_modifier > 0 then -- slower
					hunger_modifier_string = string.format(context.lstr.hunger_slow, hunger_modifier * 100)
				elseif hunger_modifier < 0 then -- faster
					hunger_modifier_string = string.format(context.lstr.hunger_drain, -hunger_modifier * 100)
				else
					hunger_modifier_string = "¯\\_(ツ)_/¯"
				end
			end

		elseif world_type == 0 or world_type == 1 then -- base game and RoG
			-- hardcoding.jpg
			if inst.prefab == "armorslurper" then
				hunger_modifier_string = string.format(context.lstr.hunger_slow, (1 - TUNING.ARMORSLURPER_SLOW_HUNGER) * 100)
			elseif inst.prefab == "beargervest" then
				hunger_modifier_string = string.format(context.lstr.hunger_slow, (1 - TUNING.ARMORBEARGER_SLOW_HUNGER) * 100)
			end

		else -- SW and Hamlet, it is additive here
			local hunger_modifier = owner.components.hunger.burn_rate_modifiers[inst.prefab] or owner.components.hunger.burn_rate_modifiers[inst] or owner.components.hunger.burn_rate_modifiers[inst.prefab:gsub("_", "")]-- beargervest is -0.25

			if hunger_modifier then
				if hunger_modifier < 0 then -- slower
					hunger_modifier_string = string.format(context.lstr.hunger_slow, -hunger_modifier * 100)
				elseif hunger_modifier > 0 then -- faster
					hunger_modifier_string = string.format(context.lstr.hunger_drain, hunger_modifier * 100)
				end 
			end

		end
	end

	local insulated
	if (world_type > 0 or world_type == -1) and self:IsInsulated() then
		insulated = context.lstr.insulated
	end

	description = CombineLines(speed_modifier, dapperness, hunger_modifier_string)
	local alt_description = CombineLines(description, insulated)

	return {
		priority = 0.1,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}