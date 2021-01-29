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

-- locomotor.lua
local icons = {
	CAFFEINE = {
		prefab = "coffee"
	},
}

local SPECIALS = {
	WX_CHARGE = function(self, context)
		return {
			time = self.inst.charge_time or 0
		}
	end
}

local function Describe(self, context)
	local description = nil

	local modifiers = {}

	if GetWorldType() >= 2 then
		-- AddSpeedModifier_Additive
		for name, add in pairs(self.speed_modifiers_add) do
			local remaining_time = self.speed_modifiers_add_timer[name]

			if not remaining_time and SPECIALS[name] then
				local res = SPECIALS[name](self, context)
				if res and res.time then
					remaining_time = res.time
				end
			end

			if remaining_time then -- only show the ones with a timer
				local data = {
					priority = 0,
					description = string.format("ADD %s | %s", add, TimeToText(time.new(remaining_time, context))), -- apparently this timer is automatically deducted
					icon = icons[name] and ResolvePrefabToImageTable(icons[name].prefab) or nil,
					name = "locomotor_add_" .. name,
					playerly = true,
				}
				table.insert(modifiers, data)
			end
		end
		-- AddSpeedModifier_Mult
		for name, mult in pairs(self.speed_modifiers_mult) do
			if self.speed_modifiers_mult_timer[name] then
				local data = {
					priority = 0,
					description = string.format("MULT %s | %s", mult, TimeToText(time.new(self.speed_modifiers_mult_timer[name], context))), -- apparently this timer is automatically deducted
					icon = icons[name] and ResolvePrefabToImageTable(icons[name].prefab) or nil,
					name = "locomotor_mult_" .. name,
					playerly = true
				}
				table.insert(modifiers, data)
			end
		end
	end

	if #modifiers > 0 then
		return unpack(modifiers)
	else
		return {
			priority = 0,
			description = description,
			icon = {},
			playerly = true
		}
	end
end



return {
	Describe = Describe
}