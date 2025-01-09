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

-- support_pillar.lua [Prefab]

local durability_weak = Color.fromHex("#ffaaaa")
local durability_healthy = Color.fromHex("#88ff88")

local reinforcement_weak = Color.fromHex("#777777")
local reinforcement_strong = Color.fromHex("#88ff88")

local function Describe(inst, context)
	local description, alt_description = nil, nil

	-- Protection radius
	local protection_radius_string = string.format("Protection radius: %s tiles", TUNING.QUAKE_BLOCKER_RANGE / WALL_STUDS_PER_TILE)

	if not inst.components.constructionsite or not inst._level then
		return
	end

	-- Sure hope nobody modifies the recipe for this!
	local recipe = CONSTRUCTION_PLANS[inst.prefab]
	if not recipe or not recipe[1] then
		return
	end

	local rock_prefab = recipe[1].type
	local max_rocks = recipe[1].amount

	-- Reinforcement
	local reinforcement_string
	if inst.reinforced then
		-- Shouldn't ever be nil, but just in case...
		reinforcement_string = string.format(context.lstr.support_pillar.reinforcement, 
			ApplyColor(inst.reinforced, reinforcement_weak:Lerp(reinforcement_strong, inst.reinforced / TUNING.SUPPORT_PILLAR_REINFORCED_LEVELS)),
			ApplyColor(TUNING.SUPPORT_PILLAR_REINFORCED_LEVELS, reinforcement_strong)
		)
		--reinforcement_string = reinforcement_string .. "\n" .. string.format("work: %s / %s", inst.components.workable.workleft, inst.components.workable.maxwork)
	end

	-- Durability
	local rocks_remaining = inst.components.constructionsite:GetSlotCount(1)
	local level = inst._level:value() -- I'll go with Klei's current level values.
	local durability_string
	if rocks_remaining < max_rocks then
		durability_string = string.format(context.lstr.support_pillar.durability, rocks_remaining, max_rocks)
	end


	description = CombineLines(reinforcement_string, durability_string)
	alt_description = CombineLines(description, protection_radius_string)
	
	return {
		name = "support_pillar",
		priority = 0,
		description = description,
		prefably = true
	}
end



return {
	Describe = Describe
}