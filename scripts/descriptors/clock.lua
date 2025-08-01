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

-- clock.lua
local netvars = {}

local function Initialize(cmp)
	netvars.cycles = util.getupvalue(cmp.OnSave, "_cycles")
	netvars.phase = util.getupvalue(cmp.OnSave, "_phase")
	netvars.mooomphasecycle = util.getupvalue(cmp.OnSave, "_mooomphasecycle")
	netvars.totaltimeinphase = util.getupvalue(cmp.OnSave, "_totaltimeinphase")
	netvars.remainingtimeinphase = util.getupvalue(cmp.OnSave, "_remainingtimeinphase")
end

local function OnServerInit()
	AddComponentPostInit("clock", Initialize)
end

local function GetMoonPhaseCycle()
	if IS_DST then
		return netvars.mooomphasecycle:value()
	else
		return error("Not added in DS.") 
	end
end

local function GetTimeLeftInSegment()
	if IS_DST then
		if netvars.remainingtimeinphase then
			return netvars.remainingtimeinphase:value() % 30
		end
	else
		return GetClock().timeLeftInEra % 30
	end
end

return {
	OnServerInit = OnServerInit,
	GetMoonPhaseCycle = GetMoonPhaseCycle,
	GetTimeLeftInSegment = GetTimeLeftInSegment
}