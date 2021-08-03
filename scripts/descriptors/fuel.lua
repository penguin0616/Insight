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

-- fuel.lua

local world_type = GetWorldType()

local function Describe(self, context)
	if context.config["fuel_verbosity"] == 0 then
		return
	end

	local inst = self.inst
	local description, alt_description = nil, nil

	-- self.fuelvalue is SECONDS_PER_SEGMENT (30) * whatever balancing thing
	-- self.fueltype
	-- so it is seconds.

	local value = self.fuelvalue

	if not value then
		description = string.format("Missing fuel value?:", tostring(self.inst), tostring(value))
		if DEBUG_ENABLED then
			table.foreach(self, dprint)
			dprint'-----------------'
		end
		return
	end

	-- fuel penalty
	if world_type == -1 then -- IsDST()
		local wetness_mult = inst:GetIsWet() and TUNING.WET_FUEL_PENALTY or 1
		--local mastery_mult = context.player.components.fuelmaster and context.player.components.fuelmaster:GetBonusMult(item, self.inst) or 1
		
       value = value * wetness_mult
	elseif world_type >= 1 then
		if not GetWorld().components.moisturemanager:IsEntityDry(inst) then
			value = value * TUNING.WET_FUEL_PENALTY
		end
	end


	local fuel_type_string = "'" .. (Insight.FUEL_TYPES[self.fueltype] or "Fuel") .. "'"
	if self.secondaryfueltype then
		fuel_type_string = fuel_type_string .. "/'" .. (Insight.FUEL_TYPES[self.secondaryfueltype] or "?") .. "'"
	end
	

	-- format
	local fuel_string_verbose = string.format(context.lstr.fuel.fuel_verbose, value, fuel_type_string)
	local fuel_string

	if context.config["fuel_verbosity"] == 1 then
		fuel_string = string.format(context.lstr.fuel.fuel, value)
	elseif context.config["fuel_verbosity"] == 2 then
		fuel_string = fuel_string_verbose
	end

	description = fuel_string
	alt_description = fuel_string_verbose
	
	return {
		priority = 0.8,
		description = description,
		alt_description = alt_description,
		fueltype = self.fueltype
	}
end



return {
	Describe = Describe
}