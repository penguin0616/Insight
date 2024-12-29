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

local function DescribeEfficiency(self, context)
	local description, alt_description = nil, nil

	local fuel_verbosity = context.config["fuel_verbosity"]
	local efficiency = self.bonusmult

	if type(efficiency) == "number" and efficiency ~= 1 then
		alt_description = string.format(context.lstr.fueled.efficiency, efficiency * 100)
		if fuel_verbosity == 2 then
			description = alt_description
		end
	end

	return {
		name = "fueled_efficiency",
		priority = 0.999,
		description = description,
		alt_description = alt_description
	}
end

local function DescribeHeldItemRefuelingCapability(self, context)
	local description

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

				percent_restore = SanitizeNumber(fuel_value / self.maxfuel, 0)
			end

			description = string.format(context.lstr.fueled.held_refuel, held_item.prefab, Round(percent_restore * 100, 0))
		end
	elseif held_item and held_item.components.sewing then
		local USAGE_FUELTYPE = world_type == -1 and FUELTYPE.USAGE or "USAGE"
		if self.fueltype == USAGE_FUELTYPE or self.secondaryfueltype == USAGE_FUELTYPE then
			-- can sew
			local percent_restore = held_item.components.sewing.repair_value / self.maxfuel

			description = string.format(context.lstr.fueled.held_refuel, held_item.prefab, Round(percent_restore * 100, 0))
		end
	end

	return {
		name = "fueled_helditemrefuelcapability",
		priority = 0.998,
		description = description,
	}
end

local function Describe(self, context)
	local description, alt_description = nil, nil

	local fuel_verbosity = context.config["fuel_verbosity"]
	local primary_fuel_type = context.lstr.fuel.types[self.fueltype] or "Fuel"

	local _currentfuel = self.currentfuel -- this is to just get it to show up in crash logs
	local rate = self.rate -- same as above
	if self.rate_modifiers then
		rate = rate * self.rate_modifiers:Get()
	end

	local current_percent = self:GetPercent()
	local pretty_percent = Round(current_percent * 100, 0)

	local time_string, time_string_verbose
	
	local remaining_time

	-- If the rate is greater than zero, we are currently consuming this item.
	if rate > 0 then
		remaining_time = self.currentfuel / rate
	end

	-- If the rate is less than zero, we are restoring it. One example is the voidcloth_umbrella.
	-- What to do in this case? We can either show the remaining time, or show how long it will take to restore the item.
	-- This block was originally added in #64 (https://github.com/penguin0616/Insight/commit/9d25d67c804717e382a5a8d57dcf4323a9c3fe44)
	-- ...For Winona's robot, which just so happens to have a powerload component.
	-- We'll show the time to recharge if it has powerload; otherwise, continue to default behaviour.
	if rate < 0 then
		if self.inst.components.powerload then
			local recharge_time = (self.maxfuel - self.currentfuel) / -rate
			local recharge_time_string = context.time:SimpleProcess(recharge_time)
			
			-- I'll just piggyback off rechargeable.
			time_string = string.format(context.lstr.rechargeable.charged_in, recharge_time_string)

			--[[
			time_string_verbose = string.format(context.lstr.fueled.time_verbose, primary_fuel_type, pretty_percent, recharge_time_string)
			if fuel_verbosity == 2 then
				time_string = time_string_verbose
			elseif fuel_verbosity == 1 then
				time_string = string.format(context.lstr.fueled.time, pretty_percent, recharge_time_string)
			end
			--]]
		else
			remaining_time = self.currentfuel / math.abs(rate)
		end
	end


	if remaining_time then
		if isbadnumber(remaining_time) then
			time_string = string.format(context.lstr.fueled.time, pretty_percent, "???")
		else
			local fuel_time = context.time:SimpleProcess(remaining_time)
			time_string_verbose = string.format(context.lstr.fueled.time_verbose, primary_fuel_type, pretty_percent, fuel_time)

			if fuel_verbosity == 2 then
				time_string = time_string_verbose
			elseif fuel_verbosity == 1 then
				time_string = string.format(context.lstr.fueled.time, pretty_percent, fuel_time)
			end
		end
	end

	-- fuel type
	--[[
	local fuel_type_string = self.fueltype
	if self.secondaryfueltype then
		fuel_type_string = fuel_type_string .. " & " .. self.secondaryfueltype
	end
	fuel_type_string = string.format(context.lstr.fuel.type, fuel_type_string)
	--]]
	
	description = time_string
	alt_description = time_string_verbose

	return {
		name = "fueled",
		priority = 1,
		description = description,
		alt_description = alt_description,
		remaining_time = remaining_time and context.time:SimpleProcess(remaining_time, "realtime_short") or "?",
		accepting = self.accepting,
		fueltype = self.fueltype,
		secondaryfueltype = self.secondaryfueltype
	}, DescribeEfficiency(self, context), DescribeHeldItemRefuelingCapability(self, context)
end



return {
	Describe = Describe,
	DescribeEfficiency = DescribeEfficiency,
	DescribeHeldItemRefuelingCapability = DescribeHeldItemRefuelingCapability,
	FormatFuel = FormatFuel
}
