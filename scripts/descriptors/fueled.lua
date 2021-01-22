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

-- fueled.lua
local function FormatFuel(fuel, context)
	return string.format(context.lstr.fuel_units, TimeToText(time.new(fuel, context)))
end

local function Describe(self, context)
	local description = nil

	local fuel_verbosity = context.config["fuel_verbosity"]
	local fuel_type = Insight.FUEL_TYPES[self.fueltype] or "Fuel"
	local remaining_time = self.currentfuel / self.rate
	local time_string = nil
	local efficiency = self.bonusmult
	local efficiency_string = nil
	
	remaining_time = time.new(remaining_time, context)
	
	if self.rate > 0 then
		if fuel_verbosity == 2 then
			time_string = string.format(context.lstr.fueled_time_verbose, fuel_type, Round(self:GetPercent() * 100, 0), TimeToText(remaining_time))
		elseif fuel_verbosity == 1 then
			time_string = string.format(context.lstr.fueled_time, Round(self:GetPercent() * 100, 0), TimeToText(remaining_time))
		end
	end

	if fuel_verbosity > 0 and efficiency ~= 1 then
		efficiency = string.format(context.lstr.fuel_efficiency, efficiency * 100)
	end

	description = CombineLines(time_string, efficiency_string)
	
	--[[
	mprint(self.inst, self.currentfuel, self.rate)
	local remaining_time = self.currentfuel / self.rate
	local efficiency = self.bonusmult
	local timeString

	if context.config["time_style"] == "none" then
		remaining_time = nil
	else
		remaining_time = time.new(remaining_time, context)


		local typ = Insight.FUEL_TYPES[self.fueltype] or "Fuel"

		if fuel_verbosity == 2 then
			timeString = string.format(context.lstr.fueled_time_verbose, typ, Round(self:GetPercent() * 100, 0), TimeToText(remaining_time))
		elseif fuel_verbosity == 1 then
			timeString = string.format(context.lstr.fueled_time, Round(self:GetPercent() * 100, 0), TimeToText(remaining_time))
		else
			-- nope
		end
	end
	
	if fuel_verbosity > 0 then
		if efficiency < 1 then
			-- uh oh?
			efficiency = "YEP PENALTY TELL PENGUIN PLEASE: " .. efficiency
		elseif efficiency > 1 then
			efficiency = string.format(context.lstr.fuel_efficiency, efficiency * 100)
		else
			efficiency = nil
		end
	else
		efficiency = nil
	end

	description = CombineLines(timeString, efficiency)
	--]]

	return {
		priority = 1,
		description = description,
		remaining_time = TimeToText(remaining_time, "realtime_short"),
		accepting = self.accepting,
		fueltype = self.fueltype,
		secondaryfueltype = self.secondaryfueltype
	}
end



return {
	Describe = Describe,
	FormatFuel = FormatFuel
}