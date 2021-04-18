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

-- moonstorm_static.lua [Prefab]
local function Describe(inst, context)
	local description = nil

	local tool_string
	local experiment_string

	local msm = TheWorld.components.moonstormmanager
	if msm.tools_need then
		local time_left = GetTaskRemaining(msm.tools_need)
		if time_left > 0 then
			tool_string = string.format(context.lstr.moonstormmanager.wagstaff_hunt.time_for_next_tool, context.time:SimpleProcess(time_left, "realtime_short"))
		end
	end

	if msm.inst.components.timer then
		local time_left = msm.inst.components.timer:GetTimeLeft("moonstorm_experiment_complete")
		if time_left then
			experiment_string = string.format(context.lstr.moonstormmanager.wagstaff_hunt.experiment_time, context.time:SimpleProcess(time_left, "realtime_short"))
		end
	end

	description = CombineLines(tool_string, experiment_string)
	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}