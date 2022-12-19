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

-- farming_manager.lua [Worldly]
local LORDFRUITFLY_TIMERNAME = CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") and assert(util.recursive_getupvalue(TheWorld.components.farming_manager.GetDebugString, "LORDFRUITFLY_TIMERNAME"), "Unable to find \"LORDFRUITFLY_TIMERNAME\"") --"bearger_timetospawn"

local function GetLordFruitFlyData(self)
	local lordfruitfly_spawntime

	if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
		lordfruitfly_spawntime = TheWorld.components.worldsettingstimer:GetTimeLeft(LORDFRUITFLY_TIMERNAME)
	else
		lordfruitfly_spawntime = util.getupvalue(self.OnSave, "lordfruitfly_spawntime")
		if lordfruitfly_spawntime then
			lordfruitfly_spawntime = lordfruitfly_spawntime.end_time - GetTime()
		end
	end

	if not (lordfruitfly_spawntime) then
		return {}
	end

	return {
		lordfruitfly_spawntime = lordfruitfly_spawntime
	}
end

local function Describe(self, context)
	local description = nil

	local data = GetLordFruitFlyData(self)

	if not data.lordfruitfly_spawntime then
		return
	end

	local remaining_time = data.lordfruitfly_spawntime
	remaining_time = context.time:SimpleProcess(remaining_time)

	description = remaining_time

	return {
		name = "farming_manager_lordfruitfly",
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Lordfruitfly.xml",
			tex = "Lordfruitfly.tex"
		},
		worldly = true,
	}
end

return {
	Describe = Describe
}