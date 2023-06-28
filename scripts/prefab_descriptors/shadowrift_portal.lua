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

-- shadowrift_portal.lua [Prefab]
local STAGE_GROWTH_TIMER = "trynextstage"
local RIFT_CLOSE_TIMER = "close"

local function Describe(inst, context)
	local description

	---------------------------------------
	-- Stage information
	---------------------------------------
	local stage_info = string.format(context.lstr.riftspawner.stage, inst._stage, TUNING.RIFT_SHADOW1_MAXSTAGE)
	local rift_close_time

	if inst.components.timer:TimerExists(RIFT_CLOSE_TIMER) then
		rift_close_time = inst.components.timer:GetTimeLeft(RIFT_CLOSE_TIMER)
	end
	
	if rift_close_time and inst._stage == TUNING.RIFT_SHADOW1_MAXSTAGE then
		stage_info = stage_info .. ": " .. string.format(context.lstr.shadowrift_portal.close, context.time:SimpleProcess(rift_close_time))
	elseif inst.components.timer:TimerExists(STAGE_GROWTH_TIMER) then
		stage_info = stage_info .. ": " .. string.format(context.lstr.growable.next_stage, context.time:SimpleProcess(inst.components.timer:GetTimeLeft(STAGE_GROWTH_TIMER)))
	end

	description = stage_info

	return {
		name = "shadowrift_portal",
		priority = 50,
		description = description,
		icon = {
			atlas = "minimap/minimap_data.xml",
			tex = "shadowrift_portal.png",
		},
		prefably = true,
	}
end



return {
	Describe = Describe,
}



