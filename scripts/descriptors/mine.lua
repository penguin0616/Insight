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

-- mine.lua
--[[
if inst.prefab == "trap_starfish" and context.config["display_attack_range"] then
		local dmg, reset = string.format(context.lstr.combat.damage, TUNING.STARFISH_TRAP_DAMAGE), nil
		if inst._reset_task then
			reset = string.format(context.lstr.trap_starfish_cooldown, context.time:SimpleProcess(GetTaskRemaining(inst._reset_task)))
		end

		description = CombineLines(dmg, reset)
	end
]]

local function Describe(self, context)
	local inst = self.inst
	local description, alt_description

	-- effect
	if inst.prefab == "trap_starfish" then
		description = Insight.descriptors.combat.DescribeDamageForPlayer(TUNING.STARFISH_TRAP_DAMAGE, context.player, context)
		if inst._reset_task then
			description = description .. "\n" .. string.format(context.lstr.mine.trap_starfish_cooldown, context.time:SimpleProcess(GetTaskRemaining(inst._reset_task)))
		end
	elseif inst.prefab == "trap_bramble" then
		description = Insight.descriptors.combat.DescribeDamageForPlayer(TUNING.TRAP_BRAMBLE_DAMAGE, context.player, context)
	elseif inst.prefab == "trap_teeth" then
		description = Insight.descriptors.combat.DescribeDamageForPlayer(TUNING.TRAP_TEETH_DAMAGE, context.player, context)
	elseif inst.prefab == "beemine" then
		description = string.format(context.lstr.mine.beemine_bees, TUNING.BEEMINE_BEES)
	end

	-- reset time
	if self.testtask then
		alt_description = string.format(context.lstr.mine.active, Round(self.testtask.period, 1))
	else
		alt_description = context.lstr.mine.inactive
	end

	alt_description = CombineLines(description, alt_description)

	return {
		name = "mine",
		priority = 49,
		description = description,
		alt_description = alt_description,
	}, (self.radius and context.config["display_attack_range"] and {
		name = "insight_ranged",
		priority = 0,
		description = nil,
		range = self.radius,
		color = "#ff0000",
		attach_player = false
	} or nil)
end



return {
	Describe = Describe
}