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

-- reloaditem.lua
local combatHelper = import("helpers/combat")
local function Describe(self, context)
	local description = nil

	if not (self.inst:HasTag("slingshotammo") and context.player:HasTag("slingshot_sharpshooter")) then
		return
	end

	local data = combatHelper.GetSlingshotAmmoData(self.inst.prefab)
	if not data then
		return
	end


	local damageString = data and data.damage or 0 -- Some ammo types do not do damage.
	local planarDamageString = data and data.planar

	local damageTypeModifiersString = Insight.descriptors.damagetypebonus and Insight.descriptors.damagetypebonus.DescribeModifiers(data.damagetypebonus or {}, context)

	
	damageString = damageString and string.format(context.lstr.weapon_damage, context.lstr.weapon_damage_type.normal, damageString) or nil
	planarDamageString = planarDamageString and string.format(context.lstr.planardamage.planar_damage, planarDamageString) or nil
	damageTypeModifiersString = damageTypeModifiersString and damageTypeModifiersString.description or nil

	description = CombineLines(damageString, planarDamageString, damageTypeModifiersString)

	return {
		priority = 49,
		description = description
	}
end



return {
	Describe = Describe
}