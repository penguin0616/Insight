--[[
Copyright (C) 2020 penguin0616

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

-- madsciencelab.lua
local function Describe(self, context)
	local description = nil

	-- { time = 2, anim = "cooking_loop3", pre_anim = "cooking_loop3_pre", fire_pre_anim = "fire3_pre", fire_anim = "fire3"},

	if not self.task then
		return
	end

	-- note: self.stage never gets cleared after initial set
	if not self.stage then
		return
	end

	local time_remaining = GetTaskRemaining(self.task)
	for i = self.stage + 1, #self.stages do -- GetTaskRemaining accounts for current stage
		time_remaining = time_remaining + self.stages[i].time
	end

	description = string.format(context.lstr.madsciencelab_finish, TimeToText(time.new(time_remaining, context)))

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}