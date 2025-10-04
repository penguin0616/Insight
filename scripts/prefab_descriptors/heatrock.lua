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

-- heatrock.lua [Prefab]
local world_type = GetWorldType()

local relative_temperature_thresholds = { -30, -10, 10, 30 } -- world ambient temperature is 0
local colors = { [1] = Color.fromHex("#00C6FF"), [6] = Color.fromRGB(255, 0, 0) }
for i = 1, 4 do
	colors[i + 1] = colors[1]:Lerp(colors[6], i / 5)
end
--[[
colors[2] = colors[1]:Lerp(colors[6], .2)
colors[3] = colors[1]:Lerp(colors[6], .4)
colors[4] = colors[1]:Lerp(colors[6], .6)
colors[5] = colors[1]:Lerp(colors[6], .8)
--]]



local function GetTemperatureThresholds(temp, ambient)
	local min, max, next_threshold

	for i = 1, #relative_temperature_thresholds do
		if temp < ambient + relative_temperature_thresholds[i] then -- have we not crossed the threshold?
			next_threshold = i
			break
		end
	end

	local level = nil

	if next_threshold == 1 then -- didn't even make it pass the first threshold
		max = relative_temperature_thresholds[next_threshold] + ambient
		level = 1 -- frozen

	elseif next_threshold == nil then -- made it past all the thresholds
		min = relative_temperature_thresholds[#relative_temperature_thresholds] + ambient
		level = 5 -- scorching
	else
		min = relative_temperature_thresholds[next_threshold - 1] + ambient -- our current threshold which we have passed
		max = relative_temperature_thresholds[next_threshold] + ambient -- next threshold, not passed
		level = next_threshold
	end

	return min, max, level
end

local function Describe(inst, context)
	local temperatureComponent = inst.components.temperature
	if not temperatureComponent then return end -- who knows?

	local description, alt_description

	local temp = temperatureComponent:GetCurrent()
	description = string.format(context.lstr.temperature, temp)

	if world_type == -1 then
		local min, max, level = GetTemperatureThresholds(temp, TheWorld.state.temperature)
		min = min or temperatureComponent.mintemp
		max = max or temperatureComponent.maxtemp

		local percent = math.clamp((temp - min) / (max - min), 0, 1) -- during testing, appears that this never goes past 0 or 1.

		local target_color = colors[level + 1]

		alt_description = string.format(context.lstr.heatrock_temperature, 
			ApplyColor("<temperature="..min..">", colors[level]), -- 1
			--ApplyColor(temperatureValue .. "<sub>" .. (level .. " - " .. Round(percent * 100, 1) .. "%") .. "</sub>", colors[level]:Lerp(target_color, percent)),
			ApplyColor(
				"<sub>" .. level .. " </sub>" .. "<temperature="..temp..">" .. "<sub> " .. Round(percent * 100, 1) .. "%" .. "</sub>",
				(
				colors[level]:Lerp(target_color, percent)
				) or
				"#ffffff"
			),
			ApplyColor("<temperature="..max..">", target_color)-- 4
		)
	end

	return {
		priority = 0,
		description = description,
		alt_description = alt_description,
		temperatureValue = temp
	}
end

--- This is responsible for making sure percentusedchanged gets pushed in DS when temperature changes. 
--- I don't remember why this is needed.
local function OnHeatrockSpawned(inst)
	--local cache = 0 -- stop network spam
	inst:ListenForEvent("temperaturedelta", function()
		if GetModConfigData("itemtile_display", true) == "numbers" then
			--local temp = Round(inst.components.temperature:GetCurrent(), 1)

			--if temp ~= cache then
				--dprint('thermal push', temp, cache)
				inst:PushEvent("percentusedchange", { percent = .123 })
				--cache = temp

			--end
		end
	end)
end

local function OnClientLoad()
	if IS_DST then return end
	AddPrefabPostInit("heatrock", OnHeatrockSpawned)
end

return {
	Describe = Describe,

	OnClientLoad = OnClientLoad,
}
