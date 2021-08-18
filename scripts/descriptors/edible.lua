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
local uncompromising = KnownModIndex:IsModEnabled("workshop-2039181790")
local debuffHelper = import("helpers/debuff")
local cooking = require("cooking")
local world_type = GetWorldType()


local function GetWereEaterData(inst, context)
	local wereeater = context.player.components.wereeater
	if not wereeater then
		return
	end

	if not inst:HasTag("monstermeat") then
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

	return string.format(context.lstr.wereeater, wereeater.monster_count, 2, forget_time)
end

local function GetFoodUnits(inst, context)
	local ing = cooking.ingredients[inst.prefab]

	local units = {}

	if ing then
		for name, value in pairs(ing.tags) do
			local color = Insight.COLORS[name:upper()] and name:upper() or "FEATHER"
			local unit = context.lstr.edible_foodtype[name:lower()] or name .. "*"
			
			if context.usingIcons and PrefabHasIcon(unit) then
				units[#units+1] = string.format(context.lstr.food_unit, color, value, unit)
			else
				units[#units+1] = string.format(context.lstr.lang.food_unit, color, value, color, unit)
			end
			--[[
			local clr = name:upper()
			if Insight.COLORS[clr] == nil then
				clr = "FEATHER"
				-- you heard me. all unregistered food is now FEATHER. accept defeat.
			end

			local unit = context.lstr["edible_" .. name:lower()] or name
			table.insert(units, string.format(context.lstr.food_unit, clr, val, clr, unit))
			--]]
		end
	end

	if #units == 0 then
		return nil
	end

	return table.concat(units, ", ")
end

local function FormatFoodStats(hunger, sanity, health, context)

	-- for handling different styles
	local style = context.config["food_style"]
	local order = context.config["food_order"] -- interface (default), wiki

	local long = nil
	local short = nil

	local data = nil

	if order == "interface" then
		--long = "<color=HUNGER>Hunger</color>: <color=HUNGER>%s</color> / <color=SANITY>Sanity</color>: <color=SANITY>%s</color> / <color=HEALTH>Health</color>: <color=HEALTH>%s</color>"
		long = context.lstr.edible_interface --string.format("%s <color=HUNGER>%%s</color> / %s <color=SANITY>%%s</color> / %s <color=HEALTH>%%s</color>", hunger_str, sanity_str, health_str)
		data = {hunger, sanity, health}
		short = "<color=HUNGER>%s</color> / <color=SANITY>%s</color> / <color=HEALTH>%s</color>"
	elseif order == "wiki" then
		--long = "<color=HEALTH>Health</color>: <color=HEALTH>%s</color> / <color=HUNGER>Hunger</color>: <color=HUNGER>%s</color> / <color=SANITY>Sanity</color>: <color=SANITY>%s</color>"
		long = context.lstr.edible_wiki --string.format("%s <color=HEALTH>%%s</color> / %s <color=HUNGER>%%s</color> / %s <color=SANITY>%%s</color>", health_str, hunger_str, sanity_str)
		data = {health, hunger, sanity}
		short = "<color=HEALTH>%s</color> / <color=HUNGER>%s</color> / <color=SANITY>%s</color>"
	else
		error("unexpected order in food_order: " .. tostring(order))
	end

	if style == "short" then
		return string.format(short, data[1], data[2], data[3])
	elseif style == "long" then
		--local DEBUG_STR = "<color=SHALLOWS>hey there jimbo</color>\nhey there jimbo\n"
		return string.format(long, data[1], data[2], data[3])
	else
		return string.format(long, data[1], data[2], data[3]) .. string.format(" [%s]", tostring(style)) 
		--error("unexpected style in food_style: " .. tostring(style))
	end
end

local function IsEdible(owner, inst)
	if not owner then
		return false
	end
	
	if owner.components.eater then
		-- base game does not have :IsValidFood()
		if owner.components.eater.IsValidFood and owner.components.eater:IsValidFood(inst) then
			if owner.components.eater:AbleToEat(inst) then
				return true
			end
		elseif owner.components.eater:CanEat(inst) then
			return true
		end
	end

	if owner.components.souleater and inst.components.soul then
		return true
	end

	return false
end

local SPECIAL_FOODS = {
	["petals_evil"] = {
		SANITY = -TUNING.SANITY_TINY,
	}
}

local function Describe(self, context)
	local description, alt_description = nil, nil

	local owner = context.player --GetPlayer()
	local foodmemory = owner.components.foodmemory
	local stats = context.stats
	local alt_description = nil

	local safe_food = true

	if context.config["display_food"] then
		local hunger, sanity, health
		if type(stats) == 'table' then
			hunger, sanity, health = stats.hunger, stats.sanity, stats.health
		else
			hunger, sanity, health = self:GetHunger(), self:GetSanity(), self:GetHealth() 
		end

		if hunger then hunger = (hunger > 0 and "+" or "") .. hunger else safe_food = false hunger = "?" end
		if sanity then sanity = (sanity > 0 and "+" or "") .. sanity else safe_food = false sanity = "?" end
		if health then health = (health > 0 and "+" or "") .. health else safe_food = false health = "?" end
		alt_description = FormatFoodStats(hunger, sanity, health, context)

		if not safe_food then
			description = alt_description -- .. " ! Missing stats due to a broken mod !" -- won't be processed by advanced food stat calculations
		end
	end
	
	if safe_food and IsEdible(owner, self.inst) and context.config["display_food"] then -- i think this filters out wurt's meat stats.
		local eater = owner.components.eater

		local hunger, sanity, health
		if type(stats) == 'table' then
			hunger, sanity, health = stats.hunger, stats.sanity, stats.health
		else
			hunger, sanity, health = self:GetHunger(owner), self:GetSanity(owner), self:GetHealth(owner) -- DST's food affinity is included in all 3

			if world_type ~= 0 then -- accounting for strong stomach in anywhere except base game since no one cares there
				if sanity < 0 and eater:DoFoodEffects(self.inst) == false then
					sanity = 0
				end
				if health < 0 and eater:DoFoodEffects(self.inst) == false then
					health = 0
				end
			end
		end	

		local base_mult = foodmemory ~= nil and foodmemory:GetFoodMultiplier(self.inst.prefab) or 1 -- warly? added while was doing food stat modifiers
		if not stats or (type(stats) == 'table' and not stats.fixed) then
			-- uncompromising mode sets absorptions to 0 on first eat event and stores the original as a variable in the player.
			-- \init\init_food\init_foodregen.lua in local function oneat, August 17, 2021.
			hunger = hunger * base_mult * (uncompromising and owner.hungerabsorption or eater.hungerabsorption)
			sanity = sanity * base_mult * (uncompromising and owner.sanityabsorption or eater.sanityabsorption)
			health = health * base_mult * (uncompromising and owner.healthabsorption or eater.healthabsorption)
		end

		if health < 0 then
			if world_type > 0 then -- RoG+
				health = health - health * (owner.components.health.absorb or 0)
			elseif world_type == -1 then -- DST
				health = health * math.clamp(1 - (owner.components.health.absorb or 0), 0, 1) * math.clamp(1 - (owner.components.health.externalabsorbmodifiers:Get() or 0), 0, 1)
			end
		end

		local special_stats = SPECIAL_FOODS[self.inst.prefab] 
		if special_stats then
			if special_stats.SANITY then
				sanity = special_stats.SANITY
			end
		end

		hunger = (hunger ~= 0 and FormatDecimal(hunger, hunger%1==0 and 0 or 1)) or hunger
		sanity = (sanity ~= 0 and FormatDecimal(sanity, sanity%1==0 and 0 or 1)) or sanity
		health = (health ~= 0 and FormatDecimal(health, health%1==0 and 0 or 1)) or health
		
		description = FormatFoodStats(hunger, sanity, health, context) -- .. "\nHunger: +25 / Sanity: +15 / Health: +20\nHunger: +25 / Sanity: +15 / Health: +20"
	end

	local foodunit_data = nil
	if context.config["food_units"] then
		local foodunits = GetFoodUnits(self.inst, context)
		if foodunits then
			foodunit_data = {
				name = "edible_foodunit",
				priority = 4,
				description = foodunits
			}
		end
	end

	local foodmemory_data = nil
	if context.config["food_memory"] then
		local mem = foodmemory and foodmemory.foods[foodmemory:GetBaseFood(self.inst.prefab)]
		if mem then
			local recently_eaten, time_to_forget = mem.count, GetTaskRemaining(mem.task)
			foodmemory_data = {
				name = "edible_foodmemory",
				priority = 0.1,
				description = string.format(context.lstr.foodmemory, recently_eaten, #foodmemory.mults, context.time:SimpleProcess(time_to_forget))
			}
		end
	end

	local wereeater_data = context.player.components.wereeater and GetWereEaterData(self.inst, context)
	if wereeater_data then
		wereeater_data = {
			name = "edible_wereeater",
			priority = 0.1,
			description = wereeater_data
		}
	end

	local effect_table = nil
	local advanced_effect_table = nil
	if context.config["food_effects"] then
		local effects = debuffHelper.GetFoodEffects(self)
		local effect_description = {}

		for name, data in pairs(effects) do
			effect_description[#effect_description + 1] = string.format(context.lstr.edible_foodeffect[name], data.delta and FormatDecimal(data.delta, 1) or ("MISSING DELTA FOR [" .. name .. "]"), data.duration and context.time:SimpleProcess(data.duration, "realtime_short") or "[YOU SHOULDN'T SEE THIS]")
		end

		if #effect_description > 0 then
			effect_table = {
				name = "edible_foodeffects",
				priority = 1.9, 
				description = table.concat(effect_description, "\n")
			}
		end

		local advanced_effects = debuffHelper.GetItemEffects(self.inst, context)
		--mprint(advanced_effects, advanced_effects and #advanced_effects)
		if advanced_effects and #advanced_effects > 0 then
			--mprint'its returned'
			advanced_effect_table = {
				name = "edible_advancedfoodeffects",
				priority = 1.8, 
				description = table.concat(advanced_effects, "\n")
			}
		end
	end

	return {
		name = "edible",
		priority = 5,
		description = description,
		alt_description = alt_description,
	}, foodunit_data, effect_table, advanced_effect_table, foodmemory_data, wereeater_data
end



return {
	Describe = Describe
}