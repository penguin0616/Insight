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

-- shadowlevel.lua
local function Describe(self, context)
	if context.player.prefab ~= "waxwell" then
		return
	end
	
	local description, alt_description
	local level = self:GetCurrentLevel() or 0

	local damage = level * TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL
	local damageString = string.format(context.lstr.shadowlevel.damage_boost, damage)

	if level == self.level then
		description = string.format(context.lstr.shadowlevel.level, level)
	else
		description = string.format(context.lstr.shadowlevel.level_diff, level, self.level)
	end

	description = description .. damageString

	-- Alt description also shows your total shadow level.
	alt_description = description

	if context.player.components.inventory then
		local total = 0
		for k, v in pairs(EQUIPSLOTS) do
			local equip = context.player.components.inventory:GetEquippedItem(v)
			if equip ~= nil and equip.components.shadowlevel ~= nil then
				total = total + equip.components.shadowlevel:GetCurrentLevel()
			end
		end

		-- Only show if there would be an actual difference
		if total > 0 and total ~= level then
			local totalDamage = total * TUNING.SHADOWWAXWELL_PROTECTOR_DAMAGE_BONUS_PER_LEVEL
			local totalString = string.format(context.lstr.shadowlevel.total_shadow_level, total)
			totalString = totalString .. string.format(context.lstr.shadowlevel.damage_boost, totalDamage)
			alt_description = CombineLines(description, totalString)
		end
	end

	return {
		priority = 2,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}