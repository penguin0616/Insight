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

-- sharkboimanager.lua

local function GetDebugString(self)
	if self.arena == nil then
        return string.format("No Arena. FindTick: %.1f", GetTaskRemaining(self.findoceanarenatask))
    end

    return string.format("State: %s, Sharkboi: %s\nFishingHole: %s, Fish: %d\nCooldown: %.1f, Radius: %.1f, DesiredRadius: %.1f",
        self:GetArenaStateString(),
        tostring(self.arena.sharkboi or "N/A"),
        tostring(self.arena.fishinghole or "N/A"),
        self.arena.caughtfish,
        GetTaskRemaining(self.arena.cooldowntask),
        self.arena.radius,
        self.arena.desiredradius or -1)
end

local function Describe(self, context)
	local description = context.etc.DEBUG_ENABLED and GetDebugString(self) or nil

	if self.arena then
		local cooldown = (self.arena and self.arena.cooldowntask and GetTaskRemaining(self.arena.cooldowntask)) or nil
		if cooldown then
			description = context.time:SimpleProcess(cooldown)
		end
	end


	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Sharkboi.xml",
			tex = "Sharkboi.tex",
		},
	}
end



return {
	OnServerLoad = OnServerLoad,

	Describe = Describe,
}