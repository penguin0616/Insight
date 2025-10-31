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
local combatHelper = import("helpers/combat")
local SLINGSHOTPART_DEFS = require("prefabs/slingshotpart_defs")
local BAND_PREFIX = "slingshot_band_"

-- timeout comes from "slingshot_shoot" in SGwilson.lua
-- special_timeout comes from "slingshot_special" in SGwilson.lua
local slingshot_handle_data = {
	["slingshot_handle_sticky"] = {
		timeout = 11,
		special_timeout = 15,
	},
	["slingshot_handle_jelly"] = {
		timeout = 7,
		special_timeout = 11,
	},
	["slingshot_handle_voidcloth"] = {
		timeout = 11,
		special_timeout = 15,
		ramping = true,
	},
	["slingshot_handle_silk"] = {
		ramping = true
	},
}

-- The frame savings when the ramping up is at max.
local MAX_RAMP_FRAMES_SPEEDUP = 6

-- The default attack timeouts for the normal and charged attacks.
local DEFAULT_NORMAL_WINDUP_TIMEOUT = 16
local DEFAULT_SPECIAL_WINDUP_TIMEOUT = 20

-- The time it takes to actually fire a normal attack.
local ATTACK_SHOOT_FRAMES = 8
-- The time it takes to actually fire a charged attack.
local SPECIAL_SHOOT_FRAMES = 8
-- There seems to be an extra frame coming in somewhere, but I don't know where (comparing against Wiki on 2025-10-19)
-- I assume an extra frame is passing between the switch back to windup after firing.
local BUFFER_FRAMES = 1

-- The action handler for attacks in SGWilson.lua chooses the target state.
-- ActionHandler(ACTIONS.ATTACK

-- print(ThePlayer.AnimState:GetCurrentAnimationNumFrames())

--- Calculates the speedup for a slingshot handle.
--- @param default_timeout int The default animation timeout of the windup without any handles.
--- @param windup_timeout int The animation timeout of the windup for the handle.
--- @param attack_timeout int The number of frames it takes to actually shoot the projectile.
--- @param ramping bool Whether ramping is enabled.
local function CalculateHandleSpeedup(default_timeout, windup_timeout, attack_timeout, ramping)
	-- To actually fire the shot, we have to wind up ("slingshot_shoot") then fire ("slingshot_shoot2")
	-- The handles improve the wind up time, not the firing time.
	-- So only part of the overall fire rate can be improved.
	-- The higher the timeout, the more frames it takes to wind up the shot.
	local default_frames_to_fire = default_timeout + attack_timeout + BUFFER_FRAMES
	local max_frames_to_fire = windup_timeout + attack_timeout + BUFFER_FRAMES
	local min_frames_to_fire = max_frames_to_fire

	if ramping then
		min_frames_to_fire = (windup_timeout - MAX_RAMP_FRAMES_SPEEDUP) + attack_timeout + BUFFER_FRAMES
	end

	-- Calculating the time it takes to fire a single shot.
	local default_time_to_fire = default_frames_to_fire * FRAMES
	local max_time_to_fire = max_frames_to_fire * FRAMES
	local min_time_to_fire = min_frames_to_fire * FRAMES

	--print(max_time_to_fire, min_time_to_fire)

	-- Calculating the attacks per second. Note variable swap.
	local default_attacks_per_second = 1 / default_time_to_fire
	local max_attacks_per_second = 1 / min_time_to_fire
	local min_attacks_per_second = 1 / max_time_to_fire

	--print(min_attacks_per_second, max_attacks_per_second)

	-- Calculate the improvement.
	local max_improvement = max_attacks_per_second / default_attacks_per_second - 1
	local min_improvement = min_attacks_per_second / default_attacks_per_second - 1

	--print(min_improvement, max_improvement)

	return {
		max_attacks_per_second = max_attacks_per_second,
		max_improvement = max_improvement,

		min_attacks_per_second = min_attacks_per_second,
		min_improvement = min_improvement
	}
end


local function DescribeSlingshotBand(inst, context)
	local description, alt_description = nil, nil

	local range
	local speed
	if inst.prefab == "slingshot_band_pigskin" then
		range = TUNING.SLINGSHOT_MOD_BONUS_RANGE_1
		speed = TUNING.SLINGSHOT_MOD_SPEED_MULT_1
	elseif inst.prefab == "slingshot_band_tentacle" or inst.prefab == "slingshot_band_mimic" then
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

	if inst.prefab == "slingshot_band_mimic" then
		local additional = string.format(context.lstr.containerinstallableitem.slingshot_band.slingshot_band_mimic, TUNING.SLINGSHOT_MOD_FREE_AMMO_CHANCE*100)
		description = CombineLines(description, additional)
	end

	return {
		name = "containerinstallableitem_slingshotband",
		priority = combatHelper.DAMAGE_PRIORITY - 101,
		description = description,
		alt_description = alt_description
	}
end

local function DescribeSlingshotFrame(inst, context)
	local description, alt_description = nil, nil

	return {
		name = "containerinstallableitem_slingshotframe",
		priority = combatHelper.DAMAGE_PRIORITY - 102,
		description = description,
		alt_description = alt_description
	}
end



local function DescribeSlingshotHandle(inst, context)
	local description, alt_description = nil, nil

	local data = slingshot_handle_data[inst.prefab]
	if not data then
		if inst:HasTag("slingshot") then
			-- Not technically supposed to be doing this as this is unclean, but I'm going to nonetheless.
			-- Mostly for easy use by the slingshot later.
			data = {}
		end
	end

	if not data then
		return
	end


	local attack_speedup_data = CalculateHandleSpeedup(
		DEFAULT_NORMAL_WINDUP_TIMEOUT, 
		data.timeout or DEFAULT_NORMAL_WINDUP_TIMEOUT,
		ATTACK_SHOOT_FRAMES,
		data.ramping or false
	)

	local special_speedup_data = CalculateHandleSpeedup(
		DEFAULT_SPECIAL_WINDUP_TIMEOUT, 
		data.special_timeout or DEFAULT_SPECIAL_WINDUP_TIMEOUT,
		ATTACK_SHOOT_FRAMES,
		data.ramping or false
	)

	for type, data in pairs({ ["primary_"]=attack_speedup_data, ["secondary_"]=special_speedup_data }) do
		local base_string = context.lstr.containerinstallableitem.slingshot_handle[type .. "fire_rate"]
		local fire_rate_string
		local fire_rate_string_complex

		if data.max_attacks_per_second == data.min_attacks_per_second then
			fire_rate_string = string.format(
				context.lstr.containerinstallableitem.slingshot_handle.fire_rate, 
				data.max_attacks_per_second
			)
			fire_rate_string_complex = string.format(
				"%s (%+.1f%%)", 
				fire_rate_string, 
				data.max_improvement * 100
			)
		else
			fire_rate_string = string.format(
				context.lstr.containerinstallableitem.slingshot_handle.fire_rate_ramping,
				data.min_attacks_per_second,
				data.max_attacks_per_second
			)
			fire_rate_string_complex = string.format(
				"%s (%+.1f%% → %+.1f%%)", 
				fire_rate_string, 
				data.min_improvement * 100, data.max_improvement * 100
			)
		end

		description = CombineLines(string.format(base_string, fire_rate_string), description)
		alt_description = CombineLines(string.format(base_string, fire_rate_string_complex), alt_description)
	end


	
	

	return {
		name = "containerinstallableitem_slingshothandle",
		priority = combatHelper.DAMAGE_PRIORITY - 103,
		description = description,
		alt_description = alt_description
	}
end

local function Describe(self, context)
	local description = nil

	return 
		DescribeSlingshotBand(self.inst, context),
		DescribeSlingshotHandle(self.inst, context)
end



return {
	Describe = Describe,
	DescribeSlingshotBand = DescribeSlingshotBand,
	DescribeSlingshotFrame = DescribeSlingshotFrame,
	DescribeSlingshotHandle = DescribeSlingshotHandle
}