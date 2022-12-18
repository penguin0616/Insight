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

-- perishable.lua
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile

local world_type = GetWorldType()

local function Perish(self, bundle)
	local inst
	if bundle then
		if self ~= nil then
			error("[Insight]: Perish called with both 'self' and 'bundle'.")
		end
		inst = bundle
	else
		if self == nil then
			error("[Insight]: Perish called without 'self'.")
		end

		inst = self.inst
	end
	
	if not inst then
		error("[Insight]: Perish called without inst")
	end

	local modifier = 1
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil

	if owner then
		if owner:HasTag("fridge") then
			if world_type == 0 then
				modifier = TUNING.PERISH_FRIDGE_MULT 
			else -- rog, sw, hamlet
				if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
					modifier = TUNING.PERISH_COLD_FROZEN_MULT
				else
					modifier = TUNING.PERISH_FRIDGE_MULT 
				end
			end
		-- accounts for all world types
		elseif owner:HasTag("spoiler") and owner:HasTag("poison") then
			modifier = TUNING.PERISH_POISON_MULT
		elseif owner:HasTag("spoiler") then
			modifier = TUNING.PERISH_GROUND_MULT 
		end
	else
		modifier = TUNING.PERISH_GROUND_MULT
	end

	local season_manager = GetSeasonManager and GetSeasonManager()
	if world_type > 0 then -- dlcs
		-- Cool off hot foods over time (faster if in a fridge)
		if inst.components.edible and inst.components.edible.temperaturedelta and inst.components.edible.temperaturedelta > 0 then
			if owner and owner:HasTag("fridge") then
				if not owner:HasTag("nocool") then
					inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - 1
				end
			elseif season_manager and season_manager:GetCurrentTemperature() < TUNING.OVERHEAT_TEMP - 5 then
				inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - .25
			end
			if inst.components.edible.temperatureduration < 0 then inst.components.edible.temperatureduration = 0 end
		end

		local mm = GetWorld().components.moisturemanager
		if mm:IsEntityWet(inst) then
			modifier = modifier * TUNING.PERISH_WET_MULT
		end
	end

	if season_manager and season_manager:GetCurrentTemperature() < 0 then
		-- PERISHABLE only
		if self then
			-- only dlcs have frozen tag
			if inst:HasTag("frozen") and not inst.components.perishable.frozenfiremult then
				modifier = TUNING.PERISH_COLD_FROZEN_MULT
			else
				modifier = modifier * TUNING.PERISH_WINTER_MULT
			end
		end
	end

	-- PERISHABLE only
	if self and inst.components.perishable.frozenfiremult then
		modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
	end

	if world_type > 0 then
		if season_manager and season_manager:GetCurrentTemperature() > TUNING.OVERHEAT_TEMP then
			modifier = modifier * TUNING.PERISH_SUMMER_MULT
		end	
	end

	if GetAporkalypse and GetAporkalypse() then
		local aporkalypse = GetAporkalypse()
		if aporkalypse and aporkalypse:IsActive() then
			modifier = modifier * TUNING.PERISH_APORKALYPSE_MULT
		end
	end
	
	modifier = modifier * TUNING.PERISH_GLOBAL_MULT

	return modifier
end

local function DST_Perish(self, bundle)
	local inst
	if bundle then
		if self ~= nil then
			error("[Insight]: DST_Perish called with both 'self' and 'bundle'.")
		end
		inst = bundle
	else
		if self == nil then
			error("[Insight]: DST_Perish called without 'self'.")
		end

		inst = self.inst
	end
	
	if not inst then
		error("[Insight]: DST_Perish called without inst")
	end

	local modifier = 1
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
	if not owner and inst.components.occupier then
		owner = inst.components.occupier:GetOwner()
	end

	if owner then
		if owner.components.preserver ~= nil then
			modifier = owner.components.preserver:GetPerishRateMultiplier(inst) or modifier
		elseif owner:HasTag("fridge") then
			if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
				modifier = TUNING.PERISH_COLD_FROZEN_MULT
			else
				modifier = TUNING.PERISH_FRIDGE_MULT
			end
		elseif owner:HasTag("foodpreserver") then
			modifier = TUNING.PERISH_FOOD_PRESERVER_MULT
		elseif owner:HasTag("cage") and inst:HasTag("small_livestock") then
			modifier = TUNING.PERISH_CAGE_MULT
		end

		if owner:HasTag("spoiler") then
			modifier = modifier * TUNING.PERISH_GROUND_MULT
		end
	else
		modifier = TUNING.PERISH_GROUND_MULT
	end

	-- PERISHABLE ONLY
	if self and inst:GetIsWet() and not self.ignorewentness then -- its actually not a typo trust me
		modifier = modifier * TUNING.PERISH_WET_MULT
	end

	if TheWorld.state.temperature < 0 then
		if inst:HasTag("frozen") and not self.frozenfiremult then
			modifier = TUNING.PERISH_COLD_FROZEN_MULT
		else
			modifier = modifier * TUNING.PERISH_WINTER_MULT
		end
	end

	-- PERISHABLE only
	if self and self.frozenfiremult then
		modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
	end

	if TheWorld.state.temperature > TUNING.OVERHEAT_TEMP then
		modifier = modifier * TUNING.PERISH_SUMMER_MULT
	end

	-- PERISHABLE only
	if self and self.localPerishMultiplyer then -- for some reason, some modders like to remove the field for one reason or another
		modifier = modifier * self.localPerishMultiplyer
	end

	modifier = modifier * TUNING.PERISH_GLOBAL_MULT

	return modifier
end

local function GetPerishModifier(...)
	if IS_DST then
		return DST_Perish(...)
	elseif IS_DS then
		return Perish(...)
	end
	
	return nil
end

local function GetPerishData(self)
	local next_task_call = GetTaskRemaining(self.updatetask)
	if next_task_call == -1 then
		-- SmartCrockPot (https://steamcommunity.com/sharedfiles/filedetails/?id=732554330) when mousing over the prediction, NextTime returns nil
		-- not sure why, but self.updatetask.nexttick is nil, so :NextTime() is nil
		-- 5/3/2020
		
		-- also seems to happen in DS birdcages, though they are paused
		return
	end

	if not self.perishremainingtime or not self.perishtime or not (self.perishtime > 0) then
		return
	end

	local inst = self.inst
	local is_critter = inst:HasTag("critter")

	if (inst.components.occupier == nil or (inst.components.occupier.GetOwner and inst.components.occupier:GetOwner() == nil)) and (inst.components.health and inst.components.inventoryitem and not inst.components.inventoryitem:IsHeld()) then
		-- no description for non-held creatures, or critters
		return nil
	end

	local modifier = GetPerishModifier(self)
	if modifier == 0 then
		return {
			modifier = 0
		}
	end

	local perish_type, alt_perish_type = nil, "rot"
	local time_to_perish, alt_time_to_perish = self.perishremainingtime, self.perishremainingtime

	-- figure out remaining perish time
	if inst.components.health then -- living creature
		perish_type = "dies"
		alt_perish_type = perish_type

	elseif is_critter then -- critter
		perish_type = "starves"
		alt_perish_type = perish_type
	
	elseif modifier < 0 then
		perish_type = "rot"
		alt_perish_type = perish_type -- wasn't here when was only describe

	elseif self:IsSpoiled() then
		--perish_type = modifier > 0 and context.lstr.perishable.rot or context.lstr.perishable.stale
		perish_type = "rot"
		alt_perish_type = "rot"
	
	elseif self:IsFresh() then
		--perish_type = modifier > 0 and context.lstr.perishable.stale or "???"
		perish_type = "stale"
		alt_perish_type = "rot"
		
		--time_to_perish = modifier > 0 and self.perishremainingtime - (self.perishtime) * 0.5 or self.perishremainingtime
		time_to_perish = self.perishremainingtime - (self.perishtime) * 0.5

	elseif self:IsStale() then
		--perish_type = modifier > 0 and context.lstr.perishable.spoil or context.lstr.perishable.fresh
		perish_type = "spoil"
		alt_perish_type = "rot"

		--time_to_perish = modifier > 0 and self.perishremainingtime - (self.perishtime) * 0.2 or self.perishremainingtime
		time_to_perish = self.perishremainingtime - (self.perishtime) * 0.2
	end

	local delta = self.updatetask.arg[2]
	local max_perish_time = self.perishtime / math.abs(modifier)

	-- account for modifiers and the next task tick, since perishing isn't realtime

	-- stage based perishing
	time_to_perish = time_to_perish / modifier
	if modifier > 0 then
		-- now, we use a bit of inaccuracy for consistency.
		-- before, number could be off because time_to_perish wasn't exactly the delta.
		-- before, i did time_to_perish + next_task_call, and when next_task_call == 0 right before a boundary switch, 
		-- the remaining time displayed was time_to_perish when time_to_perish < delta
		-- i could use a couple approaches to fix that but that meant the number would jump around as the boundary was approached within 2 ticks
		-- taking time_to_perish/delta gives us some "time units" we can fiddle with, flooring that and multiplying it back with delta undoes the "time units"
		-- which smoothes out the delta so the time is always consistent, if not perfectly accurate
		-- then again, the original approach wasn't accurate so who cares
		-- i don't know how i thought of this, it just came to me while i was staring at this.

		time_to_perish = math.floor(time_to_perish / delta) * delta + next_task_call
	elseif modifier < 0 then
		local x = math.abs(time_to_perish - (delta - next_task_call)) -- can't add, since we need opposite

		--print(x, self.perishtime, self.perishtime / math.abs(modifier))
		time_to_perish = math.min(x, max_perish_time)
	end

	-- complete perishing
	alt_time_to_perish = alt_time_to_perish / modifier
	if modifier > 0 then
		alt_time_to_perish = math.floor(alt_time_to_perish / delta) * delta + next_task_call

	elseif modifier < 0 then
		local x = math.abs(alt_time_to_perish - (delta - next_task_call)) -- can't add, since we need opposite
		alt_time_to_perish = math.min(x, max_perish_time)
	end

	-- percent
	local percent = math.min(max_perish_time, alt_time_to_perish) / max_perish_time

	return {
		modifier = modifier,
		perish_type = perish_type,
		alt_perish_type = alt_perish_type,
		time_to_perish = time_to_perish,
		alt_time_to_perish = alt_time_to_perish,
		percent = percent
	}
end

local function Describe(self, context)
	local description, alt_description

	if context.bundleitem then
		local modifier = GetPerishModifier(nil, context.bundleitem.bundle)

		return {
			priority = 0,
			description = subfmt(context.lstr.perishable.transition, { next_stage=context.lstr.perishable.rot, time=context.time:SimpleProcess(context.bundleitem.perishremainingtime) }),
			perishmodifier = modifier,
		}
	end

	if not context.config["display_perishable"] then
		return
	end

	local data = GetPerishData(self)
	if data and data.modifier == 0 then
		description = context.lstr.perishable.paused
	elseif data then
		
		local time_to_perish = context.time:SimpleProcess(math.abs(data.time_to_perish))
		local alt_time_to_perish = context.time:SimpleProcess(math.abs(data.alt_time_to_perish))

		description = subfmt(context.lstr.perishable.transition, { next_stage=context.lstr.perishable[data.perish_type], time=time_to_perish })
		alt_description = subfmt(context.lstr.perishable.transition_extended, { next_stage=context.lstr.perishable[data.alt_perish_type], time=alt_time_to_perish, percent=Round(data.percent * 100, 1) })
	end

	return {
		priority = 2,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe,
	GetPerishData = GetPerishData
}