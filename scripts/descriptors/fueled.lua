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

-- fueled.lua
local function FormatFuel(fuel, context)
	return string.format(context.lstr.fueled.units, TimeToText(time.new(fuel, context)))
end

local function Describe(self, context)
	local description, alt_description = nil, nil

	local fuel_verbosity = context.config["fuel_verbosity"]
	local primary_fuel_type = Insight.FUEL_TYPES[self.fueltype] or "Fuel"
	local remaining_time = self.currentfuel / self.rate
	local time_string, time_string_verbose
	local efficiency = self.bonusmult
	local efficiency_string = nil
	
	remaining_time = time.new(remaining_time, context)
	
	-- remaining fuel
	if self.rate > 0 then
		time_string_verbose = string.format(context.lstr.fueled.time_verbose, primary_fuel_type, Round(self:GetPercent() * 100, 0), TimeToText(remaining_time))

		if fuel_verbosity == 2 then
			time_string = time_string_verbose
		elseif fuel_verbosity == 1 then
			time_string = string.format(context.lstr.fueled.time, Round(self:GetPercent() * 100, 0), TimeToText(remaining_time))
		end
	end

	-- efficiency
	if efficiency ~= 1 and fuel_verbosity == 2 then
		efficiency_string = string.format(context.lstr.fueled.efficiency, efficiency * 100)
	end

	-- fuel type
	--[[
	local fuel_type_string = self.fueltype
	if self.secondaryfueltype then
		fuel_type_string = fuel_type_string .. " & " .. self.secondaryfueltype
	end
	fuel_type_string = string.format(context.lstr.fuel.type, fuel_type_string)
	--]]

	-- combine
	description = CombineLines(time_string, efficiency_string)
	alt_description = CombineLines(time_string_verbose, efficiency_string)

	return {
		priority = 1,
		description = description,
		alt_description = alt_description,
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