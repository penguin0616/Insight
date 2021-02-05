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

-- rocmanager.lua
local function Describe(self, context)
	local description

	if not self.disabled and not self.roc then

		local remaining_time
		local should_spawn

		if IsDS() then
			local clock = GetClock()
			remaining_time = self.nexttime - clock:GetTotalTime()
			-- will only spawn before the first half of daylight, and not while player is indoors
			should_spawn = clock:GetNormTime() < (clock.daysegs / 16) /2 and not TheCamera.interior
		else
			remaining_time = self.nexttime
			should_spawn = TheWorld.state.isday
		end
		
		
		if remaining_time >= 0 then
			description = TimeToText(time.new(remaining_time, context))
		elseif not should_spawn then -- don't use self:ShouldSpawn(), does modifications of its own
			description = context.lstr.rocmanager.cant_spawn
		end
	end

	return {
		priority = 0,
		description = description,
		worldly = true,
		icon = {
			atlas = "images/Roc.xml",
			tex = "Roc.tex",
		},
	}
end

return {
	Describe = Describe
}