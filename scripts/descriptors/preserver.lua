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

-- preserver.lua
local prefab_safety = {}

local function GetPerishRateMultiplierSafe(self)
	local is_safe = prefab_safety[self.inst.prefab]
	if is_safe == true then
		return self:GetPerishRateMultiplier()
	elseif is_safe == false then
		return "Unknown"
	else
		local safe, res = pcall(self.GetPerishRateMultiplier, self, nil)
		prefab_safety[self.inst.prefab] = safe
		return GetPerishRateMultiplierSafe(self)
	end
end


local function Describe(self, context)
	local description = nil

	local rate = GetPerishRateMultiplierSafe(self)

	if type(rate) ~= "number" then
		return
	end

	if rate > 0 then
		description = string.format(context.lstr.preserver.spoilage_rate, math.abs(rate) * 100)

		--[[
		if rate < 1 then
			alt_description = string.format(context.lstr.preserver.slower_spoilage, 1 / rate)
		else
			alt_description = string.format(context.lstr.preserver.faster_spoilage, 1 / rate)
		end
		--]]

	elseif rate <= 0 then
		-- Gains freshness
		description = string.format(context.lstr.preserver.freshness_rate, math.abs(rate) * 100)
	end
	
	return {
		priority = 0,
		description = description,
		--alt_description = alt_description
	}
end



return {
	Describe = Describe
}