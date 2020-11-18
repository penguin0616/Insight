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

-- hackable.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if self.targettime and context.config["time_style"] ~= "none" then
		local remaining_time = self.targettime - GetTime()

		if not self.paused and remaining_time > 0 then
			remaining_time = time.new(remaining_time, context)

			if context.usingIcons and PrefabHasIcon(self.product) then
				description = string.format(context.lstr.regrowth, self.product, TimeToText(remaining_time))
			else
				description = string.format(context.lstr.lang.regrowth, TimeToText(remaining_time))
			end

		elseif self.paused then
			description = string.format(context.lstr.regrowth_paused)
		end
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}