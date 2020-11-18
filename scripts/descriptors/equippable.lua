--[[
Copyright (C) 2020 penguin0616

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
local function Describe(self, context)
	local inst = self.inst
	local description = nil

	local owner = context.player --GetPlayer() --GetItemPossessor(inst) or GetPlayer()
	-- bug where one man band has .dapperfn and it needs leader component of holder, just assume owner is GetPlayer()

	-- in locomotor:GetSpeedMultiplier()
	-- the numbers are added to a base value of 1
	-- that base value is multiplied in conjunction with other stuff
	-- so i'm not sure why the equippables would return a walkspeedmult of 1 through the method :GetWalkSpeedMult()
	-- probabaly why it was commented out anyway.
	local speed_modifier = self.walkspeedmult or 0.0

	speed_modifier = Round(speed_modifier, 2)
	
	if speed_modifier ~= 0 then
		if IsDST() or GetWorldType() == 0 or GetWorldType() == 1 then -- same thing here
			-- consistency
			speed_modifier = speed_modifier - 1
		end
		speed_modifier = string.format(context.lstr.speed, FormatNumber(speed_modifier * 100))
	else
		speed_modifier = nil
	end
	

	-- expressed as sanity gain/loss per SECOND. we want it per MINUTE.

	local dapperness = nil

	if (inst.components.dapperness) then
		-- dapperness is seperated from equippable in the base game
		-- let dapperness.lua take care of this, maybe other mods are using the component as well

	elseif self.GetDapperness then -- does not exist in RoG
		dapperness = self:GetDapperness(owner)
		dapperness = Round(dapperness * 60, 1)

		if dapperness ~= 0 then
			dapperness = string.format(context.lstr.dapperness, FormatNumber(dapperness))
		else
			dapperness = nil
		end
	end

	-- might modify hunger rate
	local hunger_modifier = nil

	if owner and owner.components.hunger then
		if IsDST() then
			--hunger_modifier = tostring(owner.components.hunger.burnratemodifiers:CalculateModifierFromSource(inst)) -- no
			--hunger_modifier = owner.components.hunger.burn_rate_modifiers[inst.prefab] -- beargervest is -0.25
			--mprint('a', hunger_modifier)
			-- fallback

			--hunger_modifier = tostring(owner.components.hunger.burnratemodifiers:Get())

			if inst.prefab == "red_mushroomhat" or inst.prefab == "green_mushroomhat" or inst.prefab == "blue_mushroomhat" then
				hunger_modifier = TUNING.MUSHROOMHAT_SLOW_HUNGER
			elseif inst.prefab == "beargervest" then
				hunger_modifier = TUNING.ARMORBEARGER_SLOW_HUNGER
			elseif inst.prefab == "armorslurper" then
				hunger_modifier = TUNING.ARMORSLURPER_SLOW_HUNGER
			end

			if hunger_modifier then hunger_modifier = hunger_modifier - 1 end
			--[[
			
			if hunger_modifier == nil then
				local name = (inst.prefab == "beargervest" and "armorbearger") or inst.prefab
				hunger_modifier = -(1 - TUNING[name:upper() .. "_SLOW_HUNGER"])
				--mprint('b', name, hunger_modifier)
			end
			--]]
		

		elseif GetWorldType() == 0 or GetWorldType() == 1 then -- base game and RoG
			-- hardcoding.jpg

			if inst.prefab == "armorslurper" then
				hunger_modifier = -0.4
			elseif inst.prefab == "beargervest" then
				hunger_modifier = -0.25
			end

			--hunger_modifier = -(1 - owner.components.hunger.burn_rate_modifiers[inst.prefab])
			-- beargervest
			
		else -- hamlet and shipwrecked
			hunger_modifier = owner.components.hunger.burn_rate_modifiers[inst.prefab] -- beargervest is -0.25
			--mprint('a', hunger_modifier)
			-- fallback
			if hunger_modifier == nil then
				local name = (inst.prefab == "beargervest" and "armorbearger") or inst.prefab
				hunger_modifier = TUNING[name:upper() .. "_SLOW_HUNGER"]
				--mprint('b', name, hunger_modifier)
			end
			
		end

		if hunger_modifier ~= nil then
			hunger_modifier = string.format(context.lstr.hunger_slow, -hunger_modifier * 100)
			--hunger_modifier = hunger_modifier .. string.format("\n饥饿速度降低: %s%%", -hunger_modifier * 100)
		end
	end

	local insulated
	if (GetWorldType() > 0 or IsDST()) and self:IsInsulated() then
		insulated = "Protects you from lightning."
	end

	description = CombineLines(speed_modifier, dapperness, hunger_modifier, insulated)

	return {
		priority = 0.1,
		description = description
	}
end



return {
	Describe = Describe
}