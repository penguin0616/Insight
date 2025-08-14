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

-- edible.lua
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile

local uncompromising = KnownModIndex:IsModEnabled("workshop-2039181790")
local debuffHelper = import("helpers/debuff")
local cooking = require("cooking")
local world_type = GetWorldType()

local SPECIAL_FOODS = {
	["petals_evil"] = {
		SANITY = -TUNING.SANITY_TINY,
	}
}

--------------------------------------------------------------------------------
--- Helper functions
--------------------------------------------------------------------------------

--- Takes in food stats and formats them into the correct output string.
--- @param hunger number
--- @param sanity number
--- @param health number
--- @param context table
--- @return string
local function FormatFoodStats(hunger, sanity, health, context)
	-- Prepare the ordering for the string format.
	local order = context.config["food_order"] -- interface (default), wiki
	local food_data = nil
	local long_display_format = nil
	local short_display_format = nil
	
	if order == "interface" then
		long_display_format = context.lstr.edible_interface
		food_data = {hunger, sanity, health}
		short_display_format = "<color=HUNGER>%s</color> / <color=SANITY>%s</color> / <color=HEALTH>%s</color>"
	elseif order == "wiki" then
		long_display_format = context.lstr.edible_wiki
		food_data = {health, hunger, sanity}
		short_display_format = "<color=HEALTH>%s</color> / <color=HUNGER>%s</color> / <color=SANITY>%s</color>"
	else
		return string.format("[ERROR] BAD FOOD ORDER CONFIG [%s]", tostring(order))
	end

	for i, value in pairs(food_data) do
		if type(value) == "number" and value ~= 0 then
			-- If it's an integer, then I don't want any decimal places.
			-- Otherwise, we'll do 1 decimal place.
			local decimal_places = value%1==0 and 0 or 1
			food_data[i] = FormatDecimal(value, decimal_places)
		end
	end

	
	-- Okay, the order of the food stats is prepared. Now we just have to choose what style to use.
	local style = context.config["food_style"]

	if style == "short" then
		return string.format(short_display_format, food_data[1], food_data[2], food_data[3])
	elseif style == "long" then
		return string.format(long_display_format, food_data[1], food_data[2], food_data[3])
	else
		return string.format("[ERROR] BAD FOOD STYLE CONFIG [%s]", tostring(style))
	end
end

--- Checks if the specified entity can actually eat the food item.
--- @param entity EntityScript The entity in question
--- @param inst The food item
--- @return boolean
local function CanEntityEatItem(entity, inst)
	if not entity then
		return false
	end
	
	if entity.components.eater then
		-- base game does not have :IsValidFood()
		if entity.components.eater.IsValidFood and entity.components.eater:IsValidFood(inst) then
			if entity.components.eater:AbleToEat(inst) then
				return true
			end
		elseif entity.components.eater:CanEat(inst) then
			return true
		end
	end

	if entity.components.souleater and inst.components.soul then
		return true
	end

	return false
end


--- Calculates the food stats of an item as if it was eaten by the specified entity.
--- @param self Edible The edible entity.
--- @param eating_entity EntityScript The entity that wants to eat the food.
--- @param feeder EntityScript The entity feeding the eating entity the food. Can be the entity itself.
--- @param account_eatable boolean Whether to account for whether the food is actually edible by the entity.
local function GetFoodStatsForEntity(self, eating_entity, feeder, account_eatable)
	feeder = feeder or eating_entity

	if account_eatable then
		if not CanEntityEatItem(eating_entity, self.inst) then
			return nil
		end
	end

	-- DST's food affinity (player favorite foods) is included in these for us.
	local hunger, sanity, health = self:GetHunger(eating_entity) or 0, self:GetSanity(eating_entity) or 0, self:GetHealth(eating_entity) or 0 
	local eater = eating_entity.components.eater

	-- Some food can have negative effects, so this checks for that.
	-- Accounts for things like strong stomach (in anywhere except base game since no one cares there).
	if eater and world_type ~= 0 then
		local do_effects = eater:DoFoodEffects(self.inst)
		
		if sanity < 0 and do_effects == false then
			sanity = 0
		end
		if health < 0 and do_effects == false then
			health = 0
		end
	end

	-- In Hamlet, this tag prevents Wormwood from getting any health impact from food.
	if world_type == 3 and eating_entity:HasTag("donthealfromfood") then
		health = 0
	end

	-- Food multipliers. Only includes Warly in vanilla.
	local base_food_mult = eating_entity.components.foodmemory ~= nil and eating_entity.components.foodmemory:GetFoodMultiplier(self.inst.prefab) or 1 

	-- uncompromising mode sets absorptions to 0 on first eat event and stores the original as a variable in the player.
	-- \init\init_food\init_foodregen.lua in local function oneat, August 17, 2021.
	-- Variable change necessary according to Atoba, Dec 16 2022
	-- Do I want to do something with custom logic for uncomp absorption??
	hunger = hunger * base_food_mult * (uncompromising and eating_entity.modded_hungerabsorption or eater.hungerabsorption)
	sanity = sanity * base_food_mult * (uncompromising and eating_entity.modded_sanityabsorption or eater.sanityabsorption)
	health = health * base_food_mult * (uncompromising and eating_entity.modded_healthabsorption or eater.healthabsorption)

	-- Klei added this function for custom modification of incoming food stats without having to override the getters.
	-- More mods should make use of this, honestly.
	if eater and eater.custom_stats_mod_fn then
		health, hunger, sanity = eater.custom_stats_mod_fn(eating_entity, health, hunger, sanity, self.inst, feeder)
	end

	-- make sure they are able to receive this healing from the food
	if health > 0 and eating_entity.components.oldager then
		if not eating_entity.components.oldager.valid_healing_causes[self.inst.prefab] then
			health = 0
		end
	end

	-- stats get "consumed" now
	if health < 0 and eating_entity.components.health then
		if world_type > 0 then -- RoG+
			health = health - health * (eating_entity.components.health.absorb or 0)
		elseif world_type == -1 then -- DST
			health = health * math.clamp(1 - (eating_entity.components.health.absorb or 0), 0, 1) * math.clamp(1 - (eating_entity.components.health.externalabsorbmodifiers:Get() or 0), 0, 1)
		end
	end

	-- dark petals
	local special_stats = SPECIAL_FOODS[self.inst.prefab] 
	if special_stats then
		if special_stats.SANITY and eating_entity.components.sanity then
			sanity = special_stats.SANITY
		end
	end

	return hunger, sanity, health
end



--------------------------------------------------------------------------------

--- Creates the description table for food stats.
--- @param self Edible|table The edible component, or a table with food stats in it (similar structure to the component)
--- @param context table Insight player context.
--- @return table @Insight description table.
local function DescribeFoodStats(self, context)
	local description, alt_description = nil, nil

	if not context.config["display_food"] then
		return
	end

	-- I don't expect this would ever not be a table, but might as well check.
	if type(self) ~= "table" then
		return
	end

	-- First, we'll try to get the base stat values -- the stuff that isn't affected by who the eater is.
	local hunger = self.GetHunger and self:GetHunger() or self.hungervalue or nil
	local sanity = self.GetSanity and self:GetSanity() or self.sanityvalue or nil
	local health = self.GetHealth and self:GetHealth() or self.healthvalue or nil

	-- If any of the food values are nil, or something else is off, 
	-- we can probably assume this is one of those funky modded foods, 
	-- so we won't bother trying to get super accurate.
	local is_safe_food = self.inst and (hunger and sanity and health)

	-- The alt description is meant to serve as the base representation of the stats, 
	-- regardless of edibility or player modifiers.
	alt_description = FormatFoodStats(hunger, sanity, health, context)

	if not is_safe_food then
		description = alt_description
	end
	
	if is_safe_food and context.player and CanEntityEatItem(context.player, self.inst) then
		hunger, sanity, health = GetFoodStatsForEntity(self, context.player, nil, false)
		
		description = FormatFoodStats(hunger, sanity, health, context)
	end

	return {
		name = "edible",
		priority = 10,
		description = description,
		alt_description = alt_description,
	}
end

local function DescribeFoodUnits(self, context)
	if not context.config["food_units"] then
		return
	end

	if not self.inst then
		return
	end

	local ing = cooking.ingredients[self.inst.prefab]

	if not ing then
		return
	end

	local units = {}

	for name, value in pairs(ing.tags) do
		local color = Insight.COLORS[name:upper()] and name:upper() or "FEATHER"
		local unit = context.lstr.edible_foodtype[name:lower()] or name .. "*"
		
		if context.usingIcons and PrefabHasIcon(unit) then
			units[#units+1] = string.format(context.lstr.food_unit, color, value, unit)
		else
			units[#units+1] = string.format(context.lstr.lang.food_unit, color, value, color, unit)
		end
	end

	if #units == 0 then
		return
	end

	return {
		name = "edible_foodunit",
		priority = 4,
		description = table.concat(units, ", ")
	}
end

local function DescribeFoodMemory(self, context)
	local description = nil

	if not context.config["food_memory"] then
		return
	end

	if not context.player then
		return
	end

	local foodmemory = context.player.components.foodmemory
	if not foodmemory then
		return
	end

	local mem = foodmemory.foods[foodmemory:GetBaseFood(self.inst.prefab)]
	if not mem then
		return
	end

	local recently_eaten = mem.count
	local time_to_forget = GetTaskRemaining(mem.task)

	description = string.format(context.lstr.foodmemory, 
		recently_eaten, 
		(foodmemory.mults and #foodmemory.mults) or "?", 
		context.time:SimpleProcess(time_to_forget)
	)

	return {
		name = "edible_foodmemory",
		priority = 0.1,
		description = description
	}
end


--- Describes the player's wereeater status if it is relevant to the food item.
--- @param inst EntityScript The edible food item.
--- @param context table Insight player context.
--- @return string 
local function DescribeWereeaterData(self, context)
	local wereeater = context.player and context.player.components.wereeater
	if not wereeater then
		return
	end

	if not (self.inst and self.inst:HasTag("monstermeat")) then
		return
	end

	if wereeater.monster_count == 0 then
		return
	end

	local forget_time = wereeater.forget_task and GetTaskRemaining(wereeater.forget_task) 

	if forget_time then
		forget_time = context.time:SimpleProcess(forget_time)
	else
		forget_time = "?"
	end

	return {
		name = "edible_wereeater",
		priority = 0.1,
		description = string.format(context.lstr.wereeater, wereeater.monster_count, 2, forget_time)
	}
end

local function DescribeFoodEffects(self, context)
	if not context.config["food_effects"] then
		return
	end

	local effect_table = nil
	local advanced_effect_table = nil

	-- Prepare normal effects (stuff like temperature deltas, antihistamine, etc.)
	local effects = debuffHelper.GetFoodEffects(self)
	local effect_description = {}

	for name, data in pairs(effects) do
		effect_description[#effect_description + 1] = string.format(context.lstr.edible_foodeffect[name], 
			data.delta and FormatDecimal(data.delta, 1) or ("MISSING DELTA FOR [" .. name .. "]"), 
			data.duration and context.time:SimpleProcess(data.duration, "realtime_short") or "[YOU SHOULDN'T SEE THIS]"
		)
	end

	if #effect_description > 0 then
		effect_table = {
			name = "edible_foodeffects",
			priority = 1.9, 
			description = table.concat(effect_description, "\n")
		}
	end

	-- Prepare advanced effects (warly buffs, etc.)
	if self.inst then
		local advanced_effects = debuffHelper.GetItemEffects(self.inst, context)
		if advanced_effects and #advanced_effects > 0 then
			advanced_effect_table = {
				name = "edible_advancedfoodeffects",
				priority = 1.8, 
				description = table.concat(advanced_effects, "\n")
			}
		end
	end

	return effect_table, advanced_effect_table
end


local function Describe(self, context)

	return 
		DescribeFoodStats(self, context), 
		DescribeFoodUnits(self, context), 
		DescribeFoodMemory(self, context),
		DescribeWereeaterData(self, context),
		DescribeFoodEffects(self, context)

end



return {
	Describe = Describe,
	DescribeFoodStats = DescribeFoodStats,
	DescribeFoodUnits = DescribeFoodUnits,
	DescribeFoodMemory = DescribeFoodMemory,
	DescribeWereeaterData = DescribeWereeaterData,
	DescribeFoodEffects = DescribeFoodEffects,

	GetFoodStatsForEntity = GetFoodStatsForEntity,
	FormatFoodStats = FormatFoodStats
}