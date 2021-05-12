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

-- hunger.lua
local world_type = GetWorldType()

local function GetData(self)
	return {
		hunger = tonumber(Round(self.current, 0)),
		max_hunger = self.max
	}
end

local function GetBurnRate(self)
	local burn_rate
	if world_type == -1 then
		burn_rate = self.burnratemodifiers:Get()
	elseif world_type == 0 or world_type == 1 then -- base game and rog
		burn_rate = self.burnrate
	else
		burn_rate = self:GetBurnRate()
	end

	return burn_rate
end

local function GetTimeToEmpty(self)
	local decay_per_moment = GetBurnRate(self) * self.hungerrate * (self.period or 1)

	return self.current / decay_per_moment
end

local function Describe(self, context)
	local inst = self.inst
	local verbosity = context.config["display_hunger"]
	local description = nil
	local hunger_str = nil
	local burn_str = nil
	
	if verbosity > 0 then
		hunger_str = string.format(context.lstr.hunger, Round(self.current, 0), self.max)

		local burn_rate = 1
		

		if self.burning == false then
			burn_rate = 0
		else
			burn_rate = GetBurnRate(self)

			if not burn_rate then
				error("you moused over a: " .. self.inst:GetDisplayName() .. ", please report this to penguin (PLEASE ATTACH MOD LOG!).")
			end
		end

		if verbosity == 2 then
			if burn_rate ~= 0 then
				-- period fixed 1
				-- self.burnrate*(-self.hungerrate*dt)
				
				local burn_per_second = Round(burn_rate * -self.hungerrate * (self.period or 1), 2) -- self.period missing in DST
				burn_str = string.format(context.lstr.hunger_burn, burn_per_second * TUNING.TOTAL_DAY_TIME, burn_per_second)
			else
				burn_str = context.lstr.hunger_paused
			end
		end
	end

	description = CombineLines(hunger_str, burn_str)

	return {
		priority = 28,
		description = description
	}
end



return {
	Describe = Describe,
	GetData = GetData,
	GetTimeToEmpty = GetTimeToEmpty
}