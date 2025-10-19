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

-- containerinstallableitem.lua
local SLINGSHOTPART_DEFS = require("prefabs/slingshotpart_defs")
local BAND_PREFIX = "slingshot_band_"

local slingshot_data = {
	bands = {
		["slingshot_band_pigskin"] = {
			--bonus_range = TUNING.SLINGSHOT_MOD_BONUS_RANGE_1,
		}
	},
	handles = {
		["slingshot_handle_sticky"] = {
			timeout = 15,
		},
		["slingshot_handle_jelly"] = {
			timeout = 11,
		},
		["slingshot_handle_voidcloth"] = {
			timeout = 15,
			ramping = true,
		},
		["slingshot_handle_silk"] = {
			ramping = true
		},
	}
}

local DEFAULT_ANIMATION_TIMEOUT = 20
local MAX_RAMP_FRAMES_SPEEDUP = 6

local function OnServerLoad()
	for name, data in pairs(SLINGSHOTPART_DEFS) do
		if name:sub(1, #BAND_PREFIX) == BAND_PREFIX then
			
		end
	end
end


local function DescribeSlingshotBand(self, context)
	local description, alt_description = nil, nil

	local range
	local speed
	if self.inst.prefab == "slingshot_band_pigskin" then
		range = TUNING.SLINGSHOT_MOD_BONUS_RANGE_1
		speed = TUNING.SLINGSHOT_MOD_SPEED_MULT_1
	elseif self.inst.prefab == "slingshot_band_tentacle" or self.inst.prefab == "slingshot_band_mimic" then
		range = TUNING.SLINGSHOT_MOD_BONUS_RANGE_2
		speed = TUNING.SLINGSHOT_MOD_SPEED_MULT_2
	end

	if range then
		range = string.format(context.lstr.containerinstallableitem.slingshot_band.range, range)
	end

	if speed then
		speed = string.format(context.lstr.containerinstallableitem.slingshot_band.speed, (speed-1)*100)
	end

	description = CombineLines(range, speed)

	if self.inst.prefab == "slingshot_band_mimic" then
		local additional = string.format(context.lstr.containerinstallableitem.slingshot_band.slingshot_band_mimic, TUNING.SLINGSHOT_MOD_FREE_AMMO_CHANCE*100)
		description = CombineLines(description, additional)
	end

	return {
		name = "containerinstallableitem_slingshotband",
		priority = 1,
		description = description,
		alt_description = alt_description
	}
end

local function DescribeSlingshotHandle(self, context)
	local description, alt_description = nil, nil

	-- SGwilson "slingshot_special"
	local data = slingshot_data.handles[self.inst.prefab]
	if not data then
		return
	end

	local animation_timeout = data.timeout or DEFAULT_ANIMATION_TIMEOUT
	local has_ramp = data.ramping or false

	local frames_per_second = 1 / FRAMES

	local min_attacks_per_second = frames_per_second / animation_timeout
	local max_attacks_per_second = min_attacks_per_second
	
	if has_ramp then
		max_attacks_per_second = frames_per_second / (animation_timeout - MAX_RAMP_FRAMES_SPEEDUP)
	end


	description = CombineLines(min_attacks_per_second, max_attacks_per_second)

	return {
		name = "containerinstallableitem_slingshothandle",
		priority = 1,
		description = description,
		alt_description = alt_description
	}
end

local function Describe(self, context)
	local description = nil

	return 
		DescribeSlingshotBand(self, context)--,
		--DescribeSlingshotHandle(self, context)
end



return {
	Describe = Describe,
	OnServerLoad = OnServerLoad
}