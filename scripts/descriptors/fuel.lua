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

-- fuel.lua
local function Describe(self, context)
	local inst = self.inst
	local description = nil

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

	if IsDST() then
		if inst:GetIsWet() then
			value = value * TUNING.WET_FUEL_PENALTY
		end
	elseif IsDS() and GetWorldType() >= 1 then
		if not GetWorld().components.moisturemanager:IsEntityDry(inst) then
			value = value * TUNING.WET_FUEL_PENALTY
		end
	end

	if context.config["fuel_verbosity"] == 1 then
		description = string.format(context.lstr.fuel, value)
	elseif context.config["fuel_verbosity"] == 2 then
		description = string.format(context.lstr.fuel_verbose, value, Insight.FUEL_TYPES[self.fueltype] or "Fuel")
	end
	
	return {
		priority = 0.8,
		description = description,
		fueltype = self.fueltype
	}
end



return {
	Describe = Describe
}