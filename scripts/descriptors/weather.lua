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

-- weather.lua
local world_prefix = ((TheWorld.worldprefab == "forest" and "") or (TheWorld.worldprefab == "cave" and "cave") or TheWorld.worldprefab)
local OnUpdate = TheWorld.net.components[world_prefix.."weather"].OnUpdate
if debug.getinfo(OnUpdate, "S").source ~= "scripts/components/" .. world_prefix .. "weather.lua" then
	mprint("Weather.OnUpdate has been replaced by:", debug.getinfo(OnUpdate, "S").source, "@", debug.getinfo(OnUpdate, "l").linedefined)
	
	-- also workshop-1837053004
	--[[
	if KnownModIndex:IsModEnabled("workshop-1589856657") then -- https://steamcommunity.com/sharedfiles/filedetails/?id=1589856657 replaces it
		local realOnUpdate = util.getupvalue(OnUpdate, "_OnUpdate") 
		if realOnUpdate then
			mprint("\tFound real Weather.OnUpdate")
			OnUpdate = realOnUpdate
		else
			mprint("\tUnable to find real Weather.OnUpdate")
		end
	elseif KnownModIndex:IsModEnabled("workshop-1467214795") then
		-- yeah no im not dealing with this. regardless, OnUpdate_old
		OnUpdate = nil
		mprint("Ignoring weather since Island Adventures is present.")
	end
	--]]
end

--local _moisture = util.getupvalue(TheWorld.net.components.weather.OnUpdate, "_moisture")
local _preciptype = OnUpdate and util.recursive_getupvalue(OnUpdate, "_preciptype")
local _moisturefloor = OnUpdate and util.recursive_getupvalue(OnUpdate, "_moisturefloor")
local _moistureceil = OnUpdate and util.recursive_getupvalue(OnUpdate, "_moistureceil")
local _moisturerate = OnUpdate and util.recursive_getupvalue(OnUpdate, "_moisturerate")
local PRECIP_TYPES = OnUpdate and util.recursive_getupvalue(OnUpdate, "PRECIP_TYPES")
local PRECIP_RATE_SCALE = OnUpdate and util.recursive_getupvalue(OnUpdate, "PRECIP_RATE_SCALE")
--local CalculatePrecipitationRate = util.getupvalue(OnUpdate, "CalculatePrecipitationRate")
--local precipitation_rate = CalculatePrecipitationRate()

--[[
TheWorld:DoPeriodicTask(0.1, function()
	precipitation_rate = CalculatePrecipitationRate()
end)
--]]

--[[
	_moisture = TheWorld.state.moisture
	CalculatePrecipitationRate = TheWorld.state.precipitationrate
]]

local function Describe(self, context)
	if not OnUpdate then
		return
	end
	
	if not context.config["display_weather"] then
		return
	end
	--[[
	if not _preciptype then
		return
	end

	if not _moisturefloor then
		return
	end

	if not _moistureceil then
		return
	end

	if not _moisturerate then
		return
	end
	--]]


	local description = nil

	if _preciptype:value() == PRECIP_TYPES.none then
		if _moistureceil:value() > 0 then
			local moisture = TheWorld.state.moisture-- + _moisturerate:value() * 1
			-- if moisture >= _moistureceil:value()
			--local progress = _moistureceil:value() - moisture -- once progress = 0, it rains

			--local progress = math.clamp(moisture / _moistureceil:value(), 0, 1)
			local progress = moisture / _moistureceil:value()
			--description = string.format("Progress to rain: %s%%", Round(progress * 100, 3))
			description = string.format("Progress to rain: %s / %s", Round(moisture, 1), Round(_moistureceil:value(), 1))

		elseif DEBUG_ENABLED then
			description = tostring(_moistureceil:value())
		end
	else
		local delta = 1
		local moisture = math.max(TheWorld.state.moisture - TheWorld.state.precipitationrate * 1 * PRECIP_RATE_SCALE, 0) -- -_moisturefloor:value() because its the threshold

		--description = Round(moisture / delta, 2) .. "     RATE:" .. Round(TheWorld.state.precipitationrate, 2) .. "     FLOOR: " .. Round(_moisturefloor:value(), 2)
		-- once moisture / delta == 0, it stops raining

		--local progress = TheWorld.state.moisture - _moisturefloor:value() / (TheWorld.state.precipitationrate * 1 * PRECIP_RATE_SCALE)
		--description = string.format("??? %s, %s, %s", Round(progress, 3), Round(TheWorld.state.moisture, 3), Round(_moisturefloor:value(), 3))

		local progress = (TheWorld.state.moisture - _moisturefloor:value())

		description = string.format("Remaining rain: %s", Round(progress, 1))
		--[[
			local progress = (TheWorld.state.moisture - _moisturefloor:value()) / _moisturefloor:value()
		if progress <= 1 or progress >= 0 then
			progress = 1 - progress
			description = string.format("Progress to end of rain: %s%%", Round(progress * 100, 3))
		elseif progress > 1 then
			description = string.format("Rain has no end in sight.")
		elseif DEBUG_ENABLED then
			description = string.format("??? %s, %s, %s", Round(progress, 3), Round(TheWorld.state.moisture, 3), Round(_moisturefloor:value(), 3))
		end
		--]]
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Weather_Settings_Icon.xml",
			tex = "Weather_Settings_Icon.tex"
		},
		worldly = true
	}
end

return {
	Describe = Describe
}