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

-- malbatrossspawner.lua [Worldly]
local MALBATROSS_TIMERNAME

local function GetMalbatrossData(self)
	if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
		if MALBATROSS_TIMERNAME == nil then
			MALBATROSS_TIMERNAME = assert(util.getupvalue(TheWorld.components.malbatrossspawner.GetDebugString, "MALBATROSS_TIMERNAME"), "Unable to find \"MALBATROSS_TIMERNAME\"") --"malbatross_timetospawn"
		end
		
		return {
			time_to_respawn =  TheWorld.components.worldsettingstimer:GetTimeLeft(MALBATROSS_TIMERNAME)
		}
	end

	local data = self:OnSave()
	
	return {
		time_to_respawn = data._time_until_spawn
	}
end

local function Describe(self, context)
	local description = nil
	local data = nil

	if self == nil and context.malbatross_data then
		data = context.malbatross_data
	elseif self and context.malbatross_data == nil then
		data = GetMalbatrossData(self)
	else
		error(string.format("malbatrossspawner.Describe improperly called with self=%s & malbatross_data=%s", tostring(self), tostring(context.malbatross_data)))
	end

	if data.time_to_respawn and data.time_to_respawn > 0 then
		description = string.format(context.lstr.malbatross_spawnsin, TimeToText(time.new(data.time_to_respawn, context)))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Malbatross.xml",
			tex = "Malbatross.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe,
	GetMalbatrossData = GetMalbatrossData
}