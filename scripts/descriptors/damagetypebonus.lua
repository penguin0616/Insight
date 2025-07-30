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

-- damagetypebonus.lua
local combatHelper = import("helpers/combat")

local function DescribeModifiers(modifiers, context)
	local description = nil

	local strings = {}
	for tag, percent in pairs(modifiers) do
		percent = (percent - 1) * 100
		-- The signs are flipped across damagetypebonus/resist.
		local percent_color = (percent > 0 and Insight.COLORS.PERCENT_GOOD) or (percent < 0 and Insight.COLORS.PERCENT_BAD) or "#ffffff"
		
		local type_color = combatHelper.DAMAGE_TYPE_COLORS[tag] or "#8c8c8c"
		local name = context.lstr.damage_types[tag] or ("\"" .. tag .. "\"")
		name = ApplyColor(name, type_color)
		
		strings[#strings+1] = string.format(context.lstr.damagetypebonus.modifier, percent_color, percent, name)
	end

	description = table.concat(strings, "\n")

	if description == "" then description = nil end

	return {
		name = "damagetypebonus",
		priority = combatHelper.DAMAGE_PRIORITY - 200,
		description = description
	}
end

local function Describe(self, context)
	if self.inst.components.weapon ~= nil then
		-- If updating this, also update houndstooth_blowpipe
		if not context.config["weapon_damage"] then return end
	end

	local modifiers = combatHelper.GetDamageTypeModifiers(self)

	return DescribeModifiers(modifiers, context)
end



return {
	Describe = Describe,
	DescribeModifiers = DescribeModifiers,
}