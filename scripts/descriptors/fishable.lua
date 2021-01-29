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

-- fishable.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil
	
	if not self:IsFrozenOver() then
		description = string.format(context.lstr.fish_count, self.fishleft, self.maxfish)

		-- normally i would just check for the respawn task, but it's possible for the task to exist with full fish capacity.
		if self.fishleft < self.maxfish and self.respawntask and context.config["time_style"] ~= "none" then
			local time_remaining = time.new(self.respawntask:NextTime() - GetTime(), context) -- (self.respawntask.nexttick - TheSim:GetTick()) but in seconds
			description = description .. string.format(context.lstr.fish_recharge, TimeToText(time_remaining))
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