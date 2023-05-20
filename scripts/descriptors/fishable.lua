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
	local description = nil
	
	if self:IsFrozenOver() then
		return
	end

	if not context.config["display_simplefishing"] then
		return
	end

	-- fish count
	local fish_count = string.format(context.lstr.fish_count, self.fishleft, self.maxfish)

	-- normally i would just check for the respawn task, but it's possible for the task to exist with full fish capacity.
	if self.fishleft < self.maxfish and self.respawntask and context.config["time_style"] ~= "none" then
		local time_remaining = context.time:SimpleProcess(GetTaskRemaining(self.respawntask)) -- (self.respawntask.nexttick - TheSim:GetTick()) but in seconds
		fish_count = fish_count .. string.format(context.lstr.fish_recharge, time_remaining)
	end

	-- time to catch a fish
	local held = context.player.components.inventory and context.player.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local fishingrod = held and held.components.fishingrod

	if fishingrod and self.fishleft > 0 then
		if fishingrod.target == self.inst and fishingrod.fisherman and fishingrod.fishtask then
			-- is fishing
			description = fish_count .. "\n" .. string.format(context.lstr.fish_wait_time, Round(GetTaskRemaining(fishingrod.fishtask), 1))
		else
			local nibbletime = fishingrod.minwaittime + (1 - self:GetFishPercent()) * (fishingrod.maxwaittime - fishingrod.minwaittime)
			description = fish_count .. "\n" .. string.format(context.lstr.fish_wait_time, Round(nibbletime, 1))
		end
	else
		description = fish_count
	end

	return {
		priority = 100,
		description = description
	}
end



return {
	Describe = Describe
}