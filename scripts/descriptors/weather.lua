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
local PRECIP_TYPE_DESCRIPTORS = {}
local entity_tracker = import("helpers/entitytracker")

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

-- Mostly for debugging purposes.
local RECORDED_UPVALUES = {}
local function RecordUpvalue(name)
	local got = OnUpdate and util.recursive_getupvalue(OnUpdate, name) or nil
	RECORDED_UPVALUES[name] = got
	return got
end

local _moisture = RecordUpvalue("_moisture")
local _preciptype = RecordUpvalue("_preciptype")
local _peakprecipitationrate = RecordUpvalue("weather._peakprecipitationrate")
local _moisturefloor = RecordUpvalue("_moisturefloor")
local _moistureceil = RecordUpvalue("_moistureceil")
local _moisturerate = RecordUpvalue("_moisturerate")
local _lunarhaillevel = RecordUpvalue("_lunarhaillevel")

local PRECIP_TYPES = RecordUpvalue("PRECIP_TYPES")
local PRECIP_RATE_SCALE = RecordUpvalue("PRECIP_RATE_SCALE")
local MIN_PRECIP_RATE = RecordUpvalue("MIN_PRECIP_RATE")

local LUNAR_HAIL_FLOOR = RecordUpvalue("LUNAR_HAIL_FLOOR")
local LUNAR_HAIL_CEIL = RecordUpvalue("LUNAR_HAIL_CEIL")
local LUNAR_HAIL_EVENT_RATE = RecordUpvalue("LUNAR_HAIL_EVENT_RATE")

local WHITE = Color.fromRGB(255, 255, 255)
local RAIN_COLOR = Color.fromHex(Insight.COLORS.WET)
local HAIL_COLOR = Color.fromHex(Insight.COLORS.LUNAR_RIFT)



local precip_rate = 0

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

local function OnWeatherTick(inst, data)
	precip_rate = data.precipitationrate
	print("onweathertick", precip_rate)
end

local function OnServerInit()
	TheWorld:ListenForEvent("weathertick", OnWeatherTick)
end

local function LunarHailEnabled()
	return (TheWorld.components.riftspawner ~= nil and
        TheWorld.components.riftspawner:IsLunarPortalActive() and
        _preciptype:value() ~= PRECIP_TYPES.lunarhail) or
		_preciptype:value() == PRECIP_TYPES.lunarhail
        
end

--[[
local function CalculatePrecipitationRate()
	local p = math.max(0, math.min(1, (_moisture:value() - _moisturefloor:value()) / (_moistureceil:value() - _moisturefloor:value())))
	local rate = MIN_PRECIP_RATE + (1 - MIN_PRECIP_RATE) * math.sin(p * PI)
	return math.min(rate, _peakprecipitationrate:value())
end
--]]


--========================================================================================================================--
--= None =================================================================================================================--
--========================================================================================================================--
local function DescribeNone(self, context)
	if not OnUpdate then
		return
	end

	local advanced = context.config["weather_detail"] == 1

	-- "none"
	-- PRECIP_TYPES.none

	-- Progress to the others, basically.
	local rain_progress_string = nil
	if _moistureceil:value() > 0 then
		local current_moisture = _moisture:value()
		local target_moisture = _moistureceil:value()

		local moisture_needed = target_moisture - current_moisture
		local delta = _moisturerate:value()
		local time_left = math.min(moisture_needed / delta, 86400)

		local base_string = advanced and (
			"%s: %s (<color=" .. WHITE:Lerp(RAIN_COLOR, current_moisture / target_moisture):ToHex() .. ">%.1f</color> / <color=WET>%.1f</color>)"
		) or "%s: %s"

		rain_progress_string = string.format(
			base_string, 
			context.lstr.weather.progress_to_rain, 
			context.time:SimpleProcess(time_left),
			current_moisture, target_moisture
		)

	elseif DEBUG_ENABLED then
		-- Don't know if I've actually seen this happen, but might as well keep it here.
		rain_progress_string = "BAD _moistureceil: " .. tostring(_moistureceil:value())
	end

	-- Progress to lunar hail
	local hail_progress_string = nil
	local debug_string = nil
	if LunarHailEnabled() then
		local current_hail_level = _lunarhaillevel:value()
		local amount_left = math.max(LUNAR_HAIL_CEIL - current_hail_level, 0)
		local delta = LUNAR_HAIL_EVENT_RATE.COOLDOWN * 1
		local time_left = amount_left / delta

		local base_string = advanced and (
			"%s: %s (<color=" .. WHITE:Lerp(HAIL_COLOR, current_hail_level / LUNAR_HAIL_CEIL):ToHex() .. ">%.2f</color> / <color=LUNAR_RIFT>%.1f</color>)"
		) or "%s: %s"

		hail_progress_string = string.format(
			base_string, -- %.1f%%
			context.lstr.weather.progress_to_hail, 
			context.time:SimpleProcess(time_left), -- (level / LUNAR_HAIL_CEIL) * 100
			current_hail_level, LUNAR_HAIL_CEIL
		)
	end
	
	
	return CombineLines(rain_progress_string, hail_progress_string)
end
PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.none] = DescribeNone

--========================================================================================================================--
--= Rain =================================================================================================================--
--========================================================================================================================--
local function DescribeRain(self, context)
	--local delta = 1
	--local moisture = math.max(TheWorld.state.moisture - TheWorld.state.precipitationrate * 1 * PRECIP_RATE_SCALE, 0) -- -_moisturefloor:value() because its the threshold

	--description = Round(moisture / delta, 2) .. "     RATE:" .. Round(TheWorld.state.precipitationrate, 2) .. "     FLOOR: " .. Round(_moisturefloor:value(), 2)
	-- once moisture / delta == 0, it stops raining

	--local progress = TheWorld.state.moisture - _moisturefloor:value() / (TheWorld.state.precipitationrate * 1 * PRECIP_RATE_SCALE)
	--description = string.format("??? %s, %s, %s", Round(progress, 3), Round(TheWorld.state.moisture, 3), Round(_moisturefloor:value(), 3))

	local advanced = context.config["weather_detail"] == 1

	local current_moisture = _moisture:value()
	local target_moisture = _moisturefloor:value()

	local difference = math.max(current_moisture - target_moisture, 0)
	local delta = precip_rate * 1 * PRECIP_RATE_SCALE
	local time_left = difference / delta

	local base_string = advanced and (
		"%s: %s (%.1f / <color=" .. WHITE:Lerp(RAIN_COLOR, current_moisture / _moistureceil:value()):ToHex() .. ">%.1f</color> / <color=WET>%.1f</color>)"
	) or "%s: %s"

	rain_progress_string = string.format(
		base_string, 
		context.lstr.weather.remaining_rain, 
		context.time:SimpleProcess(time_left),
		_moisturefloor:value(), current_moisture, _moistureceil:value()
	)

	return rain_progress_string
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
PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.rain] = DescribeRain

--========================================================================================================================--
--= LunarHail ============================================================================================================--
--========================================================================================================================--
local hail_base_string = "%s: %s"
local advanced_hail_base_string = "%s: %s (%.1f / %.1f)"

local function DescribeHail(self, context)
	--description = string.format("M2|_lunarhaillevel=%.2f\ncooldown=%.1f, duration=%.1f", _lunarhaillevel:value(), LUNAR_HAIL_EVENT_RATE.COOLDOWN, LUNAR_HAIL_EVENT_RATE.DURATION)

	local advanced = context.config["weather_detail"] == 1

	local current_hail_level = _lunarhaillevel:value()

	local amount_left = current_hail_level - LUNAR_HAIL_FLOOR
	local delta = LUNAR_HAIL_EVENT_RATE.DURATION * 1
	local time_left = amount_left / delta

	local base_string = advanced and (
		"%s: %s (%.1f / <color=" .. WHITE:Lerp(HAIL_COLOR, current_hail_level / LUNAR_HAIL_CEIL):ToHex() .. ">%.2f</color> / <color=LUNAR_RIFT>%.1f</color>)"
	) or "%s: %s"

	local hail_progress_string = string.format(
		base_string,
		context.lstr.weather.remaining_hail, 
		context.time:SimpleProcess(time_left),
		LUNAR_HAIL_FLOOR, current_hail_level, LUNAR_HAIL_CEIL
	)

	return hail_progress_string
end
PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.lunarhail] = DescribeHail


--========================================================================================================================--
--= Main ============================================================================================================--
--========================================================================================================================--
local function Describe(self, context)
	if not OnUpdate then
		return
	end
	
	if context.config["display_weather"] == 0 then
		return
	end

	--cprint(context.config["display_weather"], entity_tracker:CountInstancesOf("rainometer"))
	if context.config["display_weather"] == 1 and not entity_tracker:WorldHasInstanceOf("rainometer") then
		return
	end

	local description = nil

	local describeFn = PRECIP_TYPE_DESCRIPTORS[_preciptype:value()]

	if describeFn then
		description = describeFn(self, context)
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
	OnServerInit = OnServerInit,
	Describe = Describe,

	PRECIP_TYPE_DESCRIPTORS = PRECIP_TYPE_DESCRIPTORS,
	debug = RECORDED_UPVALUES, 
}