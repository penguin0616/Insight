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

-- sinkholespawner.lua
local ANTLION_RAGE_TIMER = CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") and assert(util.getupvalue(_G.Prefabs.antlion.fn, "ANTLION_RAGE_TIMER"), "Unable to find \"ANTLION_RAGE_TIMER\"") --"rage"

local function GetAntlionData(self)
	local time_to_rage

	local inst = self.inst or self
	if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
		time_to_rage = inst.components.worldsettingstimer:GetTimeLeft(ANTLION_RAGE_TIMER)
	else
		time_to_rage = inst.components.timer:GetTimeLeft("rage")
	end

	return {
		time_to_rage = time_to_rage
	}
end

local function Describe(self, context)
	local description = nil

	local data
	if self == nil and context.antlion_data then
		data = context.antlion_data
	elseif self and context.antlion_data == nil then
		data = GetAntlionData(self)
	else
		error(string.format("sinkholespawner.Describe improperly called with self=%s & antlion_data=%s", tostring(self), tostring(context.bearger_data)))
	end

	local time_to_rage = data.time_to_rage

	if time_to_rage and time_to_rage > 0 then
		description = string.format(context.lstr.antlion_rage, TimeToText(time.new(time_to_rage, context)))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Antlion.xml",
			tex = "Antlion.tex",
		},
		worldly = true, -- not really but might as well be
	}
end



return {
	Describe = Describe,
	GetAntlionData = GetAntlionData
}