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

-- planardamage.lua
local combatHelper = import("helpers/combat")

local function DescribeByScrapbook(inst, context)
	local description = nil

	-- Used for cases where it needs to be manually specified, such as houndstooth_blowpipe.
	if not (inst.scrapbook_planardamage and type(inst.scrapbook_planardamage) == "number") then
		return
	end


	local planar_damage = inst.scrapbook_planardamage
	description = string.format(context.lstr.planardamage.planar_damage, Round(planar_damage, 1))

	return {
		name = "planardamage_scrapbook",
		priority = combatHelper.DAMAGE_PRIORITY - 100,
		description = description,
		alt_description = alt_description
	}
end

-- darker #b079e8
-- lighter #c99cf7
local function Describe(self, context)
	local description, alt_description = nil, nil

	-- First time I've ever had a split config check like this.
	if self.inst.components.weapon ~= nil then
		if not context.config["weapon_damage"] then return end

	elseif self.inst.components.health then
		if not context.config["display_mob_attack_damage"] then return end
	end

	if self.inst:HasTag("player") then
		-- Not really necessary to be visible on players.
		return
	end

	local base_damage = self:GetBaseDamage()
	local current_damage = self:GetDamage()
	
	local bonus_damage = current_damage - base_damage

	if current_damage ~= 0 then	
		description = string.format(context.lstr.planardamage.planar_damage, Round(current_damage, 1))

		alt_description = string.format(context.lstr.planardamage.planar_damage, Round(base_damage, 1))
		if bonus_damage ~= 0 then
			alt_description = alt_description .. string.format(context.lstr.planardamage.additional_damage, Round(bonus_damage, 1))
		end
	end
	
	return {
		name = "planardamage",
		priority = combatHelper.DAMAGE_PRIORITY - 100,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe,
	DescribeByScrapbook = DescribeByScrapbook,
}