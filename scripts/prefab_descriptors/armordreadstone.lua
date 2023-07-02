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

-- armordreadstone.lua [Prefab]

-- The actual prefab file is armor_dreadstone, but the spawned prefab is armordreadstone.
-- Goddamnit Klei.

-- happens every TUNING.ARMOR_DREADSTONE_REGEN_PERIOD
local PERIOD_MOD = 2

local tiny = Color.fromHex("#D08C91")
local big = Color.fromHex("#BC4C51")

local function Describe(inst, context)
	local description, alt_description = nil, nil

	-- This entire descriptor is reused by the hat.
	if not context.complex_config["unique_info_prefabs"]["armordreadstone"] then
		return
	end

	local setbonus = inst.components.setbonus ~= nil and inst.components.setbonus:IsEnabled(EQUIPMENTSETNAMES.DREADSTONE) and TUNING.ARMOR_DREADSTONE_REGEN_SETBONUS or 1


	local min_rate = 1 / (1 / TUNING.ARMOR_DREADSTONE_REGEN_MINRATE)
	local max_rate = 1 / (1 / TUNING.ARMOR_DREADSTONE_REGEN_MAXRATE)
	local current_rate = 0
	
	if context.player.components.sanity ~= nil and context.player.components.sanity:IsInsanityMode() then
		current_rate = 1 / Lerp(1 / TUNING.ARMOR_DREADSTONE_REGEN_MAXRATE, 1 / TUNING.ARMOR_DREADSTONE_REGEN_MINRATE, context.player.components.sanity:GetPercent())
	end

	min_rate = inst.components.armor.maxcondition * min_rate * setbonus * PERIOD_MOD
	max_rate = inst.components.armor.maxcondition * max_rate * setbonus * PERIOD_MOD
	current_rate = inst.components.armor.maxcondition * current_rate * setbonus * PERIOD_MOD

	description = string.format(context.lstr.armordreadstone.regen, 
		tiny:Lerp(big, current_rate / max_rate):ToHex(),
		current_rate, 
		TUNING.ARMOR_DREADSTONE_REGEN_PERIOD * PERIOD_MOD
	)

	alt_description = string.format(context.lstr.armordreadstone.regen_complete, 
		tiny:ToHex(), min_rate, 
		tiny:Lerp(big, (current_rate - min_rate) / (max_rate - min_rate)):ToHex(), current_rate, 
		big:ToHex(), max_rate, 
		TUNING.ARMOR_DREADSTONE_REGEN_PERIOD * PERIOD_MOD
	)

	--[[
	alt_description = string.format(context.lstr.armordreadstone.regen_complete, 
		ApplyColour(min_rate * PERIOD_MOD, tiny), 
		ApplyColour(current_rate * PERIOD_MOD, tiny:Lerp(big, current_rate / max_rate)), 
		ApplyColour(max_rate * PERIOD_MOD, big), 
		TUNING.ARMOR_DREADSTONE_REGEN_PERIOD * PERIOD_MOD
	)
	--]]
	
	return {
		priority = 1.4,
		description = description,
		alt_description = alt_description,
		prefably = true
	}
end



return {
	Describe = Describe
}