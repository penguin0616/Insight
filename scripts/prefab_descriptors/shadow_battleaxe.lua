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

-- shadow_battleaxe.lua [Prefab]
local combatHelper = import("helpers/combat")

local weak = Color.fromHex("#D08C91")
local strong = Color.fromHex("#BC4C51")

local function Describe(inst, context)
	local description = nil

	--[[
	return string.format(
        "Level: %d/%d | Defeated Bosses: %d/%d | Life Steal: %.2f | Tracked Bosses: [ %s ]",
        inst.level, #TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS,
        inst.epic_kill_count, TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[#TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS],
        inst._lifesteal,
        table.concat(trackedentities, ", ")
    )
	]]
	
	local max_level = #TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS

	-- How many bosses we've killed on this threshold level.
	local this_level_boss_kills = 0

	-- The number of bosses that need to be killed to reach the next level.
	local boss_kills_for_next_level = 0

	if inst.level < max_level then
		this_level_boss_kills = inst.epic_kill_count - TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level]
		--boss_kills_to_next_level = TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level + 1] - inst.epic_kill_count
		boss_kills_for_next_level = TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level + 1] - TUNING.SHADOW_BATTLEAXE.LEVEL_THRESHOLDS[inst.level]
	end


	
	local level_string = string.format(context.lstr.shadow_battleaxe.level, 
		ApplyColor(inst.level, weak:Lerp(strong, inst.level / max_level)),
		ApplyColor(max_level, strong)
	)

	
	local boss_progress_string
	-- We only want to show the text if there are boss kills needed to reach the next level
	-- (presumably) there is a next level if more kills are needed.
	if boss_kills_for_next_level > 0 then
		boss_progress_string = string.format(context.lstr.shadow_battleaxe.boss_progress, 
			ApplyColor(this_level_boss_kills, weak:Lerp(strong, this_level_boss_kills / boss_kills_for_next_level)),
			ApplyColor(boss_kills_for_next_level, strong)
		)
	end

	
	local lifesteal_info
	if inst._lifesteal > 0 then
		lifesteal_info = {
			name = "shadow_battleaxe_lifesteal",
			priority = combatHelper.DAMAGE_PRIORITY - 10,
			description = string.format(context.lstr.shadow_battleaxe.lifesteal, 
				inst._lifesteal, 
				-inst._lifesteal * TUNING.SHADOW_BATTLEAXE.LIFE_STEAL_SANITY_LOSS_SCALE
			),
		}
	end

	-- Put it all together.
	description = level_string
	if boss_progress_string then
		description = description .. " | " .. boss_progress_string
	end

	--description = CombineLines(description, lifesteal_string)
	
	return {
		name = "shadow_battleaxe",
		priority = 100,
		description = description,
		prefably = true
	}, lifesteal_info
end



return {
	Describe = Describe
}