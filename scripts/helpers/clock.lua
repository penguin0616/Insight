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
local module = {
	initialized = false,
	netvars = {}
}

module.GetMoonPhaseCycle = function(self)
	if IS_DST then
		return self.netvars.mooomphasecycle:value()
	else
		return error("Not added in DS.") 
	end
end

module.GetTimeLeftInSegment = function(self)
	if IS_DST then
		if module.netvars.remainingtimeinphase then
			return self.netvars.remainingtimeinphase:value() % 30
		end
	else
		return GetClock().timeLeftInEra % 30
	end
end

module.Initialize = function(clock)
	if module.initialized then
		return
	end
	module.initialized = true
	
	module.netvars.cycles = util.getupvalue(clock.OnSave, "_cycles")
	module.netvars.phase = util.getupvalue(clock.OnSave, "_phase")
	module.netvars.mooomphasecycle = util.getupvalue(clock.OnSave, "_mooomphasecycle")
	module.netvars.totaltimeinphase = util.getupvalue(clock.OnSave, "_totaltimeinphase")
	module.netvars.remainingtimeinphase = util.getupvalue(clock.OnSave, "_remainingtimeinphase")
end

return module