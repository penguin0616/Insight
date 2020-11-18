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

local function CanWither(self)
	return TheWorld.state.temperature > self.wither_temp and not TheWorld.state.israining
end

local function CanRejuvenate(self)
	return TheWorld.state.temperature < self.rejuvenate_temp or TheWorld.state.israining
end

-- witherable.lua
local function Describe(self, context)
	local description = nil

	if self.delay_to_time then
		local remaining_time = self.delay_to_time - GetTime()
		remaining_time = TimeToText(time.new(remaining_time, context))

		description = string.format(context.lstr.witherable.delay, remaining_time)
		return
	end

	if not self.task_to_time then
		return
	end

	if self:IsProtected() then
		-- meh
	elseif self:CanWither() then
		local remaining_time = self.task_to_time - GetTime()
		remaining_time = TimeToText(time.new(remaining_time, context))

		if CanWither(self) then
			description = string.format(context.lstr.witherable.wither, remaining_time)
		else
			--description = string.format(context.lstr.witherable.delay, remaining_time)
		end
	elseif self:CanRejuvenate() then
		local remaining_time = self.task_to_time - GetTime()
		remaining_time = TimeToText(time.new(remaining_time, context))

		if CanRejuvenate(self) then
			description = string.format(context.lstr.witherable.rejuvenate, remaining_time)
		else
			--description = string.format(context.lstr.witherable.delay, remaining_time)
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