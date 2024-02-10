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

-- aoeweapon_base.lua

-- Well, this is a problem.
-- I was never expecting Klei to make a component that inherited from another.
-- I think I'll treat this descriptor as a "_common" sort of thing?

local combatHelper = import("helpers/combat")

---@param self CombatHelper
---@param context InsightContext The player's context, used for getting the stimuli text.
---@param format string The string to be formatted using **subfmt**
---@param combat Component The combat component involved, if it exists.
---@return string
local function DescribeDamage(self, context, format, combat)
	local stimuli_data = combatHelper.GetStimuliData(self.stimuli)

	local damage = self.damage

	if stimuli_data.default_damage_modifier then
		damage = damage * stimuli_data.default_damage_modifier
	end

	damage = damage * combatHelper.GetOutgoingDamageModifier(combat)

	return subfmt(format, { damageType=context.lstr.weapon_damage_type[stimuli_data.name], damage=damage })
end

local function Describe(self, context)
	--local description = string.format(context.lstr.aoeweapon_base.weapon_damage, "_", self.damage)

	return {
		name = "aoeweapon_base",
		priority = 0,
		description = description
	}
end

return {
	Describe = Describe,

	DescribeDamage = DescribeDamage,
	--GetDamageData = GetDamageData,
}