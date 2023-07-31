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
local world_type = GetWorldType()
local moisturemanager = world_type > 0 and GetWorld().components.moisturemanager

local function FormatFuel(fuel, context)
	return string.format(context.lstr.fueled.units, context.time:SimpleProcess(fuel))
end

local function GetFuelValue(self, item, doer)
	-- wetness multiplier
	local is_wet = false
	if world_type == -1 then
		is_wet = item:GetIsWet()
	elseif world_type > 0 and moisturemanager then
		is_wet = not moisturemanager:IsEntityDry(item)
	end

	local wetness_mult = is_wet and TUNING.WET_FUEL_PENALTY or 1

	-- mastery multiplier
	local mastery_mult = world_type == -1 and doer ~= nil and doer.components.fuelmaster ~= nil and doer.components.fuelmaster:GetBonusMult(item, self.inst) or 1

	return item.components.fuel.fuelvalue * self.bonusmult * wetness_mult * mastery_mult
end

local function Describe(self, context)
	local description, alt_description = nil, nil

	local fuel_verbosity = context.config["fuel_verbosity"]
	local primary_fuel_type = context.lstr.fuel.types[self.fueltype] or "Fuel"
	local _currentfuel = self.currentfuel -- this is to just get it to show up in crash logs
	local _rate = self.rate -- same as above
	local remaining_time = self.currentfuel / self.rate
	local time_string, time_string_verbose
	local efficiency = self.bonusmult
	local efficiency_string = nil
	
	-- remaining fuel
	if self.rate > 0 then
		local current_percent = self:GetPercent()
		local fuel_time = context.time:SimpleProcess(remaining_time)
		time_string_verbose = string.format(context.lstr.fueled.time_verbose, primary_fuel_type, Round(current_percent * 100, 0), fuel_time)

		if fuel_verbosity == 2 then
			time_string = time_string_verbose
		elseif fuel_verbosity == 1 then
			time_string = string.format(context.lstr.fueled.time, Round(current_percent * 100, 0), fuel_time)
		end
	end

	-- efficiency
	if efficiency and efficiency ~= 1 and fuel_verbosity == 2 then
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

	-- held item?
	local refuel_string
	local held_item = context.player.components.inventory and context.player.components.inventory:GetActiveItem()
	if held_item and held_item.components.fuel then
		if self:CanAcceptFuelItem(held_item) then
			local fuel_value = GetFuelValue(self, held_item, context.player)
			local percent_restore = 0
			if self.maxfuel > 0 then
				--[[
				if world_type == -1 then
					new_percent = math.max(0, math.min(1, (self.currentfuel + fuel_value) / self.maxfuel))
				else
					new_percent = math.min(1, (self.currentfuel + fuel_value) / self.maxfuel)
				end
				--]]

				percent_restore = fuel_value / self.maxfuel
			end

			refuel_string = string.format(context.lstr.fueled.held_refuel, held_item.prefab, Round(percent_restore * 100, 0))
		end
	elseif held_item and held_item.components.sewing then
		local USAGE_FUELTYPE = world_type == -1 and FUELTYPE.USAGE or "USAGE"
		if self.fueltype == USAGE_FUELTYPE or self.secondaryfueltype == USAGE_FUELTYPE then
			-- can sew
			local percent_restore = held_item.components.sewing.repair_value / self.maxfuel

			refuel_string = string.format(context.lstr.fueled.held_refuel, held_item.prefab, Round(percent_restore * 100, 0))
		end
	end

	-- combine
	description = CombineLines(time_string, efficiency_string, refuel_string)
	alt_description = CombineLines(time_string_verbose, efficiency_string, refuel_string)

	return {
		priority = 1,
		description = description,
		alt_description = alt_description,
		remaining_time = context.time:SimpleProcess(remaining_time, "realtime_short"),
		accepting = self.accepting,
		fueltype = self.fueltype,
		secondaryfueltype = self.secondaryfueltype
	}
end



return {
	Describe = Describe,
	FormatFuel = FormatFuel
}