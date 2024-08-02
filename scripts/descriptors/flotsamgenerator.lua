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

-- flotsamgenerator.lua

local _guaranteed_spawn_tasks

local function OnServerInit()
	if TheWorld.components.flotsamgenerator and TheWorld.components.flotsamgenerator.ScheduleGuaranteedSpawn then
		_guaranteed_spawn_tasks = util.getupvalue(TheWorld.components.flotsamgenerator.ScheduleGuaranteedSpawn, "_guaranteed_spawn_tasks")
	end
end

local function DescribeMessageBottle(context, player, task)
	local description = string.format(context.lstr.flotsamgenerator.messagebottle_cooldown, context.time:SimpleProcess(GetTaskRemaining(task)))

	return {
		name = "flotsamgenerator-messagebottle-" .. player.userid,
		priority = 0,
		worldly = true,
		playerly = true,
		description = description,
		icon = {
			atlas = "images/inventoryimages2.xml",
			tex = "messagebottle.tex"
		},
	}
end

local function Describe(self, context)
	if not _guaranteed_spawn_tasks then
		return
	end

	-- This is a worldly component but is meant to describe the individual player that's requesting this.
	local tasks = _guaranteed_spawn_tasks[context.player]
	if not tasks then
		return
	end

	local descriptions = {}

	for v, task in pairs(tasks) do
		-- guaranteed_presets
		if v.prefabs[1] == "messagebottle" then
			table.insert(descriptions, DescribeMessageBottle(context, player, task))
		end
	end

	-- Describe globally
	--[[
	-- spawn_task: { player -> { preset -> Task } }
	for player, tasks in pairs(spawn_task) do
		-- tasks: { preset -> Task }
		for v, task in pairs(tasks) do
			-- guaranteed_presets
			if v.prefabs[1] == "messagebottle" then
				table.insert(descriptions, DescribeMessageBottle(context, player, task))
			end
		end
	end
	--]]

	return unpack(descriptions)
	
end

return { 
	Describe = Describe,
	OnServerInit = OnServerInit
}