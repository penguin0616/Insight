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
-- cache loot?
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

local function SummarizeImportantLoot(self)
	self = self or TheWorld.components.klaussackloot
	
	local loot = {}
	-- so while i could just check the i of self.loot to figure out which bundle we are on, i think just checking if its in the loot pool is more mod compatible.

	--[[
		bundle 1: amulet, goldnugget, X charcoal
		bundle 2: 50% chance of amulet, goldnugget, X charcoal
		bundle 3: 10% chance of krampus sack, goldnugget, X charcoal
		bundle 4: giant loot
	]]

	if self.loot[3] then
		for k = 1, #self.loot[3] do
			local item = self.loot[3][k]
			if item == "krampus_sack" then
				loot[item] = (loot[item] or 0) + 1
			end
		end
	end

	if self.loot[4] then
		for k = 1, #self.loot[4] do
			local item = self.loot[4][k]
			loot[item] = (loot[item] or 0) + 1
		end
	end

	--[[
	for i = 1, #self.loot do
		local bundle = self.loot[i]
		for k = 1, #bundle do
			local item = bundle[k]
			if not loot[item] then
				loot[item] = 1
			else
				loot[item] = loot[item] + 1
			end
		end
	end
	

	if IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) then
		for i = 1, #self.wintersfeast_loot do
			local bundle = self.wintersfeast_loot[i]
			for k = 1, #bundle do
				local item = bundle[k]
				if not loot[item] then
					loot[item] = 1
				else
					loot[item] = loot[item] + 1
				end
			end
		end
	end
	--]]

	return loot
end

local function Describe(self, context)
	local description = nil

	return nil
end



return {
	Describe = Describe,
	SummarizeImportantLoot = SummarizeImportantLoot,
}