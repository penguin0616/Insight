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

-- wathgrithr_shield.lua [Prefab]
local combatHelper = import("helpers/combat")

local function Describe(inst, context)
	if not inst.components.parryweapon then
		return
	end

	local parry_skill_active = context.player.components.skilltreeupdater ~= nil and
        context.player.components.skilltreeupdater:IsActivated("wathgrithr_arsenal_shield_2")

	local duration_mult = parry_skill_active and TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_DURATION_MULT or 1
	local duration = TUNING.WATHGRITHR_SHIELD_PARRY_DURATION * duration_mult



	local described = Insight.descriptors.parryweapon.DescribeParryDuration(
		inst.components.parryweapon, 
		context,
		Round(duration, 1),
		context.lstr.parryweapon.parry_duration
	)

	described.name = "wathgrithr_shield_parryweapon"
	described.priority = combatHelper.DAMAGE_PRIORITY - 105

	described.alt_description = string.format(context.lstr.wathgrithr_shield.parry_duration_complex,
		parry_skill_active and "#8c8c8c" or "HEALTH",
		TUNING.WATHGRITHR_SHIELD_PARRY_DURATION,
		not parry_skill_active and "#8c8c8c" or "HEALTH",
		TUNING.WATHGRITHR_SHIELD_PARRY_DURATION * TUNING.SKILLS.WATHGRITHR.SHIELD_PARRY_DURATION_MULT
	)

	described.prefably = true
	
	return described
end



return {
	Describe = Describe
}