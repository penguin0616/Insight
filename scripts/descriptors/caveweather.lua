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

-- caveweather.lua
local PRECIP_TYPE_DESCRIPTORS = {}

local WHITE = Color.fromRGB(255, 255, 255)
local RAIN_COLOR = Color.fromHex(Insight.COLORS.WET)
local ACID_RAIN_COLOR = Color.fromHex(Insight.COLORS.SHADOW_ALIGNED)

local entity_tracker = import("helpers/entitytracker")

--local world_prefix = ((TheWorld.worldprefab == "forest" and "") or (TheWorld.worldprefab == "cave" and "cave") or TheWorld.worldprefab)
--local OnUpdate = TheWorld.net.components[world_prefix.."weather"].OnUpdate


-- Mostly for debugging purposes.
local ThisComponent = nil
local module = nil
local requested_upvalues = {}
local upvalues = {}

local function RequestUpvalue(name)
	requested_upvalues[name] = false
end

local function RecordUpvalue(fn, name)
	if not fn then
		dprintf("Missing function [GetDebugString] for RecordUpvalue?")
	end

	local got = fn and util.recursive_getupvalue(fn, name) or nil
	requested_upvalues[name] = got ~= nil
	upvalues[name] = got
	return got
end

-- These exist in OnLoad
local _moisture = RequestUpvalue("_moisture")
local _preciptype = RequestUpvalue("_preciptype")
local _peakprecipitationrate = RequestUpvalue("_peakprecipitationrate")
local _moisturefloor = RequestUpvalue("_moisturefloor")
local _moistureceil = RequestUpvalue("_moistureceil")
local _moisturerate = RequestUpvalue("_moisturerate")

-- These exist in OnUpdate
local PRECIP_TYPES = RequestUpvalue("PRECIP_TYPES")
local PRECIP_RATE_SCALE = RequestUpvalue("PRECIP_RATE_SCALE")
local MIN_PRECIP_RATE = RequestUpvalue("MIN_PRECIP_RATE")

-- Misc
local precip_rate = 0

local function OnWeatherTick(inst, data)
	precip_rate = data.precipitationrate
end


local function AcidRainEnabled()
	return (TheWorld.components.riftspawner ~= nil and
        TheWorld.components.riftspawner:IsShadowPortalActive() and
        _preciptype:value() ~= PRECIP_TYPES.acidrain) or
		_preciptype:value() == PRECIP_TYPES.acidrain
        
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
	local advanced = context.config["weather_detail"] == 1

	-- I guess acid rain follows the same rules as normal rain.
	local rain_progress_string = nil
	if _moistureceil:value() > 0 then
		local current_moisture = _moisture:value()
		local target_moisture = _moistureceil:value()

		local moisture_needed = target_moisture - current_moisture
		local delta = _moisturerate:value()
		local time_left = moisture_needed / delta

		local is_acid_rain = AcidRainEnabled()

		local moisture_percent = math.clamp(current_moisture / target_moisture, 0, 1)

		local base_string = advanced and (
			"%s: %s (<color=" .. WHITE:Lerp(
				(is_acid_rain and ACID_RAIN_COLOR or RAIN_COLOR), 
				moisture_percent
			):ToHex() .. ">%.1f</color> / <color=" .. (is_acid_rain and "SHADOW_ALIGNED" or "WET") .. ">%.1f</color>)"
		) or "%s: %s"

		local other_string = is_acid_rain and context.lstr.weather.progress_to_acid_rain or context.lstr.weather.progress_to_rain

		rain_progress_string = string.format(
			base_string, 
			other_string,
			isbadnumber(time_left) and "???" or context.time:SimpleProcess(time_left),
			current_moisture, target_moisture
		)

	elseif DEBUG_ENABLED then
		-- Don't know if I've actually seen this happen, but might as well keep it here.
		rain_progress_string = "BAD _moistureceil: " .. tostring(_moistureceil:value())
	end
	
	return CombineLines(rain_progress_string, hail_progress_string)
end

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

	local is_acid_rain = AcidRainEnabled()

	local base_string = advanced and (
		"%s: %s (%.1f / <color=" .. WHITE:Lerp((is_acid_rain and ACID_RAIN_COLOR or RAIN_COLOR), current_moisture / _moistureceil:value()):ToHex() .. ">%.1f</color> / <color=" .. (is_acid_rain and "SHADOW_ALIGNED" or "WET") .. ">%.1f</color>)"
	) or "%s: %s"

	local other_string = is_acid_rain and context.lstr.weather.remaining_acid_rain or context.lstr.weather.remaining_rain

	rain_progress_string = string.format(
		base_string, 
		other_string, 
		isbadnumber(time_left) and "???" or context.time:SimpleProcess(time_left),
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

--========================================================================================================================--
--= Main ============================================================================================================--
--========================================================================================================================--
local function OnServerInit()
	local cmp_name = debug.getinfo(1, "S").source:match("([%w_]+)%.lua$")

	dprintf("%s OnServerInit", cmp_name)

	ThisComponent = TheWorld.net.components[cmp_name]
	if not ThisComponent then
		mprintf("Unable to find TheWorld.net.components['%s'] in setup for '%s' descriptor.", cmp_name, cmp_name)
		return
	end

	local debugInfo_OnUpdate = debug.getinfo(ThisComponent.OnUpdate, "Sl")

	if debugInfo_OnUpdate.source ~= "scripts/components/" .. cmp_name .. ".lua" then
		mprintf("%s.OnUpdate has been replaced by: %s@%s" , cmp_name, debugInfo_OnUpdate.source, debugInfo_OnUpdate.linedefined)
		
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

	-- These exist in OnLoad
	_moisture = RecordUpvalue(ThisComponent.OnLoad, "_moisture")
	_preciptype = RecordUpvalue(ThisComponent.OnLoad, "_preciptype")
	_peakprecipitationrate = RecordUpvalue(ThisComponent.OnLoad, "_peakprecipitationrate")
	_moisturefloor = RecordUpvalue(ThisComponent.OnLoad, "_moisturefloor")
	_moistureceil = RecordUpvalue(ThisComponent.OnLoad, "_moistureceil")
	_moisturerate = RecordUpvalue(ThisComponent.OnLoad, "_moisturerate")

	-- These exist in OnUpdate
	PRECIP_TYPES = RecordUpvalue(ThisComponent.OnUpdate, "PRECIP_TYPES")
	PRECIP_RATE_SCALE = RecordUpvalue(ThisComponent.OnUpdate, "PRECIP_RATE_SCALE")
	MIN_PRECIP_RATE = RecordUpvalue(ThisComponent.OnUpdate, "MIN_PRECIP_RATE")

	TheWorld:ListenForEvent("weathertick", OnWeatherTick)

	for name, found in pairs(requested_upvalues) do
		if found == false then
			mprintf("\tDisabled because of missing upvalue '%s'", name)
			return
		end
	end

	PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.none] = DescribeNone
	PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.rain] = DescribeRain
	PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.acidrain] = PRECIP_TYPE_DESCRIPTORS[PRECIP_TYPES.rain]
end


local function Describe(self, context)
	if context.config["display_weather"] == 0 then
		return
	end

	--cprint(context.config["display_weather"], entity_tracker:CountInstancesOf("rainometer"))
	if context.config["display_weather"] == 1 and not entity_tracker:WorldHasInstanceOf("rainometer") then
		return
	end

	if not _preciptype then
		return
	end

	local description = nil

	-- None of the descriptors will run if any upvalues are missing, because they won't get added to the table.
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

module = {
	OnServerInit = OnServerInit,
	Describe = Describe,

	PRECIP_TYPE_DESCRIPTORS = PRECIP_TYPE_DESCRIPTORS,
	debug = upvalues, 
}

return module