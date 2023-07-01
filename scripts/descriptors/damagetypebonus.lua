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
local damageHelper = import("helpers/damage")

local function Describe(self, context)
	local description = nil

	if self.inst.components.weapon ~= nil then
		if not context.config["weapon_damage"] then return end
	end

	local modifiers = {}
	for tag, sml in pairs(self.tags) do
		local percent = (sml:Get() - 1) * 100
		-- Modifier is generally something like 1.1 or 0.9, where 1 is normal

		-- The signs are flipped across damagetypebonus/resist.
		local percent_color = (percent > 0 and "#66cc00") or (percent < 0 and "#dd5555") or "#ffffff"
		
		local type_color = damageHelper.DAMAGE_TYPE_COLORS[tag] or "#8c8c8c"
		local name = context.lstr.damage_types[tag] or ("\"" .. tag .. "\"")
		name = ApplyColor(name, type_color)
		
		modifiers[#modifiers+1] = string.format(context.lstr.damagetypebonus.modifier, percent_color, percent, name)
	end

	description = table.concat(modifiers, "\n")

	if description == "" then description = nil end

	return {
		priority = damageHelper.DAMAGE_PRIORITY - 2,
		description = description
	}
end



return {
	Describe = Describe
}