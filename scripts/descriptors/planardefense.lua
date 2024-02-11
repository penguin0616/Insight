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

-- planardefense.lua
local combatHelper = import("helpers/combat")

-- darker #b079e8
-- lighter #c99cf7
local function Describe(self, context)
	local description, alt_description = nil, nil

	if self.inst.components.armor ~= nil then
		if not context.config["armor"] then return end
	end

	local base_defense = self:GetBaseDefense()
	local current_defense = self:GetDefense()
	
	local bonus_defense = current_defense - base_defense

	if current_defense ~= 0 then
		description = string.format(context.lstr.planardefense.planar_defense, Round(current_defense, 1))
	end

	alt_description = string.format(context.lstr.planardefense.planar_defense, Round(base_defense, 1))
	if bonus_defense ~= 0 then
		alt_description = alt_description .. string.format(context.lstr.planardefense.additional_defense, Round(bonus_defense, 1))
	end
	
	return {
		priority = combatHelper.DAMAGE_PRIORITY - 200,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}