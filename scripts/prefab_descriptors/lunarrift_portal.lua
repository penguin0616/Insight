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

-- lunarrift_portal.lua [Prefab]
local STAGE_GROWTH_TIMER = "trynextstage"

local MAX_CRYSTAL_RING_COUNT_BY_STAGE -- = {0, 1, 3}
local CRYSTALS_PER_RING -- = 4
local MIN_CRYSTAL_DISTANCE -- = 3
local MAX_CRYSTAL_DISTANCE_BY_STAGE
local TERRAFORM_DELAY -- = TUNING.RIFT_LUNAR1_STAGEUP_BASE_TIME / 3

-- lunarthrall plant spawner
local TIME_UNIT = TUNING.SEG_TIME*8
local PERIODIC_TIME = TUNING.TOTAL_DAY_TIME *2

local function OnServerLoad()
	-- The power of recursive-ness.
	MAX_CRYSTAL_RING_COUNT_BY_STAGE = util.recursive_getupvalue(_G.Prefabs.lunarrift_portal.fn, "MAX_CRYSTAL_RING_COUNT_BY_STAGE")
	CRYSTALS_PER_RING = util.recursive_getupvalue(_G.Prefabs.lunarrift_portal.fn, "CRYSTALS_PER_RING")
	MIN_CRYSTAL_DISTANCE = util.recursive_getupvalue(_G.Prefabs.lunarrift_portal.fn, "MIN_CRYSTAL_DISTANCE")
	TERRAFORM_DELAY = util.recursive_getupvalue(_G.Prefabs.lunarrift_portal.fn, "TERRAFORM_DELAY")
	MAX_CRYSTAL_DISTANCE_BY_STAGE = util.recursive_getupvalue(_G.Prefabs.lunarrift_portal.fn, "MAX_CRYSTAL_DISTANCE_BY_STAGE")
end

local function Describe(inst, context)
	local description

	---------------------------------------
	-- Stage information
	---------------------------------------
	local stage_info = string.format(context.lstr.riftspawner.stage, inst._stage, TUNING.RIFT_LUNAR1_MAXSTAGE)
	
	if inst._stage == TUNING.RIFT_LUNAR1_MAXSTAGE then
		local plantspawner = TheWorld.components.lunarthrall_plantspawner
		if plantspawner and plantspawner.currentrift == inst then
			-- This is probably somewhat accurate... right?
			local rift_close_time = 0

			if plantspawner.inst.components.timer:TimerExists("endrift") then
				rift_close_time = plantspawner.inst.components.timer:GetTimeLeft("endrift")
			else
				-- The approximation for the randomization is rough. 
				-- So instead of replacing math.random() with 1 like I've done before for small matters,
				-- I'll do 0.5 here to better approximate.
				local waves_left = plantspawner.waves_to_release
				rift_close_time = 10 + (waves_left - 1) * (TIME_UNIT + (0.5*TIME_UNIT) - (TIME_UNIT/2))

				-- Current states
				if waves_left > 1 and plantspawner._spawntask then
					rift_close_time = rift_close_time + GetTaskRemaining(plantspawner._spawntask)
				elseif plantspawner._nextspawn then
					rift_close_time = rift_close_time + GetTaskRemaining(plantspawner._nextspawn)
				end
			end

			stage_info = stage_info .. ": " .. string.format(context.lstr.lunarrift_portal.close, context.time:SimpleProcess(rift_close_time))
	
		end
	elseif inst.components.timer:TimerExists(STAGE_GROWTH_TIMER) then
		stage_info = stage_info .. ": " .. string.format(context.lstr.growable.next_stage, context.time:SimpleProcess(inst.components.timer:GetTimeLeft(STAGE_GROWTH_TIMER)))
	end

	---------------------------------------
	-- Grazer information
	---------------------------------------
	local grazer_info
	
	-- The goal here is to kind of simulate what childspawner would show.
	--local max_grazers = GRAZER_SPAWNS_BY_STAGE[inst._stage] -- Not actually maximum.
	local grazers = entity_tracker:GetInstancesOf("lunar_grazer")

	local alive = 0
	local dead = 0

	for i,v in pairs(grazers) do
		if v.components.entitytracker:GetEntity("portal") == inst then
			if v:HasTag("NOCLICK") then
				dead = dead + 1
			else
				alive = alive + 1
			end
		end
	end

	grazer_info = string.format(context.lstr.childspawner.children, "lunar_grazer", dead, alive, dead + alive)
	
	---------------------------------------
	-- Crystal information
	---------------------------------------
	local crystal_count_info
	local crystal_spawn_info

	-- I was going to separate them by prefab (size), but I'll just do number.
	--[[
	local crystals = {}
	for crystal in pairs(inst._crystals) do
		crystals[crystal.prefab] = crystals[crystal.prefab] or 0
	end
	--]]
	local max_crystals = MAX_CRYSTAL_RING_COUNT_BY_STAGE[inst._stage] * CRYSTALS_PER_RING
	local current_crystals = 0
	local available_crystals = 0
	local quickest_time_to_available_crystal
	
	for crystal in pairs(inst._crystals) do
		current_crystals = current_crystals + 1
		if not crystal:IsInLimbo() then
			available_crystals = available_crystals + 1
		else
			if crystal.components.timer:TimerExists("finish_spawnin") then
				local time = crystal.components.timer:GetTimeLeft("finish_spawnin")
				if quickest_time_to_available_crystal == nil or time < quickest_time_to_available_crystal then
					quickest_time_to_available_crystal = time
				end
			end
		end
	end

	-- Show number of available crystals
	if available_crystals > 0 then
		crystal_count_info = string.format(context.lstr.lunarrift_portal.crystals, available_crystals, current_crystals, max_crystals)
	end

	-- Show crystal regen time

	-- This is essentially true if:
	-- stage 2 == current_crystals = 0
	-- stage 3 == 
	local crystals_can_spawn = (max_crystals - current_crystals) >= CRYSTALS_PER_RING

	if (crystals_can_spawn or available_crystals < current_crystals) then
		local time

		if quickest_time_to_available_crystal  then
			time = quickest_time_to_available_crystal
		elseif crystals_can_spawn then
			-- We'll show an approximate time since it has some randomness, but an insignificant amount. 
			if inst.components.timer:TimerExists("try_crystals") then
				-- Math copied from lunarrift_portal with some tweaks.
				local offset = MIN_CRYSTAL_DISTANCE + math.sqrt(1)*(MAX_CRYSTAL_DISTANCE_BY_STAGE[inst._stage] - MIN_CRYSTAL_DISTANCE)
				local previous_max_crystal_distance = MAX_CRYSTAL_DISTANCE_BY_STAGE[inst._stage - 1] or 0
				local time_delay = math.max(0, ((offset - previous_max_crystal_distance) / TILE_SCALE) * TERRAFORM_DELAY)
				
				time = inst.components.timer:GetTimeLeft("try_crystals") + (time_delay + (2*1))
			end
		end

		if time then
			crystal_spawn_info = string.format(context.lstr.lunarrift_portal.next_crystal, context.time:SimpleProcess(time))
		end
	end

	-- tostring(crystals_can_spawn) .. tostring(current_crystals) .. 
	description = CombineLines(stage_info, crystal_count_info, crystal_spawn_info)

	return {
		name = "lunarrift_portal",
		priority = 50,
		description = description,
		icon = {
			atlas = "minimap/minimap_data.xml",
			tex = "lunarrift_portal.png",
		},
		prefably = true,
	}, {
		name = "lunarrift_portal_childspawner",
		priority = 49,
		description = grazer_info,
		prefably = true,
	}
end

return {
	OnServerLoad = OnServerLoad,

	Describe = Describe,

	StatusAnnouncementsDescribe = StatusAnnouncementsDescribe
}



