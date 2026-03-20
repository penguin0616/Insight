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

-- klaussackloot.lua

--local giant_loot1 = assert(util.getupvalue(TheWorld.components.klaussackloot.RollKlausLoot, "giant_loot1"), "[Insight]: klaussackloot -> missing giant_loot1")
--[[
{
    "deerclops_eyeball",
    "dragon_scales",
    "hivehat",
    "shroom_skin",
    "mandrake",
}
--]]

--local giant_loot2 = assert(util.getupvalue(TheWorld.components.klaussackloot.RollKlausLoot, "giant_loot1"), "[Insight]: klaussackloot -> missing giant_loot2")
--[[
{
    "dragonflyfurnace_blueprint",
    "red_mushroomhat_blueprint",
    "green_mushroomhat_blueprint",
    "blue_mushroomhat_blueprint",
    "mushroom_light2_blueprint",
    "mushroom_light_blueprint",
    "townportal_blueprint",
    "bundlewrap_blueprint",
	"trident_blueprint",
}
--]]

--local giant_loot3 = assert(util.getupvalue(TheWorld.components.klaussackloot.RollKlausLoot, "giant_loot3"), "[Insight]: klaussackloot -> missing giant_loot3")
--[[
{
    "bearger_fur",
    "royal_jelly",
    "goose_feather",
    "lavae_egg",
    "spiderhat",
    "steelwool",
    "townportaltalisman",
	"malbatross_beak",
}
--]]

local function SummarizeLoot(self)
	self = self or TheWorld.components.klaussackloot
	
	local loot = {}
	-- self.loot structure:
	--[[
		bundle 1: amulet, goldnugget, X charcoal
		bundle 2: 50% chance of amulet, goldnugget, X charcoal
		bundle 3: 10% chance of krampus sack, goldnugget, X charcoal
		bundle 4: giant loot
	]]
	

	local loot_pools = {self.loot}
	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		table.insert(loot_pools, self.wintersfeast_loot)
	end

	for poolIdx, pool in ipairs(loot_pools) do
		for bundleIdx, bundle in ipairs(pool) do
			for itemIdx = 1, #bundle do
				local prefab = bundle[itemIdx]
				-- Winterlands stores tables instead of strings sometimes.
				if type(prefab) == "string" then
					if not loot[prefab] then
						loot[prefab] = {
							amount = 0,
							important = poolIdx == 1 and (bundleIdx == 3 or bundleIdx == 4),
						}
					end
					loot[prefab].amount = loot[prefab].amount + 1
				end
			end
		end
	end


	return loot
end

return {
	SummarizeLoot = SummarizeLoot,
}