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

-- moonstormmanager.lua
local function GetWagstaffHuntData()
	local self = TheWorld.components.moonstormmanager
	if not self then
		return
	end

	if self.wagstaff and self.wagstaff.hunt_stage == "hunt" then
		return {
			progress = self.wagstaff.hunt_count or 0,
			final = TUNING.WAGSTAFF_NPC_HUNTS,
		}
	end
end


--[[
	self.stormdays = self.stormdays + 1
		if self.stormdays >= TUNING.MOONSTORM_MOVE_TIME then
			if math.random() < Remap(self.stormdays, TUNING.MOONSTORM_MOVE_TIME, TUNING.MOONSTORM_MOVE_MAX, 0.1, 1) then
]]

local function Describe(self, context)
	local description = nil

	if not self.stormdays then
		return
	end

	local days_left = TUNING.MOONSTORM_MOVE_TIME - self.stormdays
	if days_left < 1 then
		-- so when days_left = 0, it'll always show the next day
		days_left = 1
	end

	-- self.stormdays + 1 for when we are on the days to change, show next day's chance
	local chance = Remap(math.max(self.stormdays + 1, TUNING.MOONSTORM_MOVE_TIME), TUNING.MOONSTORM_MOVE_TIME, TUNING.MOONSTORM_MOVE_MAX, 0.1, 1)

	-- TheWorld.state.cycles + 1 to make it the same as the clock
	description = string.format(context.lstr.moonstormmanager.storm_move, chance * 100, TheWorld.state.cycles + 1 + days_left)

	return {
		priority = 1,
		description = description,
		worldly = true,
	}
end



return {
	Describe = Describe,
	GetWagstaffHuntData = GetWagstaffHuntData,
}