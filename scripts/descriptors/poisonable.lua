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

-- poisonable.lua
local function Describe(self, context)
	local description = nil

	if self.start_time and self.duration then
		local time_remaining = (self.start_time + self.duration) - GetTime()
		local time_string = time_remaining > 0 and context.time:SimpleProcess(time_remaining, "both_short") or tostring(time_remaining)
		description = string.format(context.lstr.poisonable.remaining_time, time_string)
	end

	return {
		priority = 0,
		description = description,
		playerly = true,
		icon = {
			atlas = "images/Poison.xml",
			tex = "Poison.tex",
		},
	}
end



return {
	Describe = Describe
}