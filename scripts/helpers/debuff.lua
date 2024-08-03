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

-- This file is responsible for keeping the food/cooking stuff over here.
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim

local TUNING = TUNING
local cooking = require("cooking")
local preparedfoods = require("preparedfoods")
local preparedfoods_warly = IS_DST and require("preparedfoods_warly") or {}
local spicedfoods = IS_DST and require("spicedfoods") or {}
local world_type = GetWorldType()
local item_debuffs = {}
local debuff_definitions = {}
local prefabs_to_generic_debuffs = {}

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
--- Returns the general food effects from cooking (not *really* special effects like Jellybeans)
---@param self Edible
---@return table
local function GetFoodEffects(self)
	local bonuses = {}

	if world_type == 0 then
		return bonuses
	end

	-- temperature
	local delta_multiplier = 1
	local duration_multiplier = 1

	if world_type == -1 and self.spice and TUNING.SPICE_MULTIPLIERS[self.spice] then
		if TUNING.SPICE_MULTIPLIERS[self.spice].TEMPERATUREDELTA then
			delta_multiplier = delta_multiplier + TUNING.SPICE_MULTIPLIERS[self.spice].TEMPERATUREDELTA
		end

		if TUNING.SPICE_MULTIPLIERS[self.spice].TEMPERATUREDURATION then
			duration_multiplier = duration_multiplier + TUNING.SPICE_MULTIPLIERS[self.spice].TEMPERATUREDURATION
		end
	end

	-- @Reign of Giants & @Don't Starve Together
	-- Food is an implicit heater/cooler if it has temperature
	if self.temperaturedelta and self.temperatureduration and self.temperaturedelta ~= 0 and self.temperatureduration ~= 0 and (self.chill == nil or self.chill < 1) then
		bonuses.temperature = { 
			delta = self.temperaturedelta * (1 - (self.chill or 0)) * delta_multiplier,
			duration = self.temperatureduration * duration_multiplier
		}
	end

	-- @Shipwrecked
	-- Food is an implicit speed booster if it has caffeine
	if self.caffeinedelta and self.caffeineduration and self.caffeinedelta ~= 0 and self.caffeineduration ~= 0 then
		-- eater.components.locomotor:AddSpeedModifier_Additive("CAFFEINE", self.caffeinedelta, self.caffeineduration)
		bonuses.caffeine = {
			delta = self.caffeinedelta,
			duration = self.caffeineduration
		}
	end

	-- Other food based speed modifiers
	if self.surferdelta and self.surferduration and self.surferdelta ~= 0 and self.surferduration ~= 0 then
		--eater.components.locomotor:AddSpeedModifier_Additive("SURF", self.surferdelta, self.surferduration)
		bonuses.surf = {
			delta = self.surferdelta,
			duration = self.surferduration
		}
	end

	-- SW/Hamlet
	if self.autodrydelta and self.autodryduration and self.autodrydelta ~= 0 and self.autodryduration ~= 0 then
		--eater.components.locomotor:AddSpeedModifier_Additive("AUTODRY", self.autodrydelta, self.autodryduration)
		bonuses.autodry = {
			delta = self.autodrydelta,
			duration = self.autodryduration
		}
	end

	-- Immediate cooling in SW/Hamlet
	if self.autocooldelta and self.autocooldelta ~= 0 then
		bonuses.instant_temperature = {
			delta = self.autocooldelta, 
			duration = false,
		}
		--[[
		local current_temp = eater.components.temperature:GetCurrent()
		local new_temp = math.max(current_temp - self.autocooldelta, TUNING.STARTING_TEMP)
		eater.components.temperature:SetTemperature(new_temp)
		--]]
	end

	-- @Hamlet
	if self.antihistamine and self.antihistamine ~= 0 then
		bonuses.antihistamine = {
			delta = self.antihistamine,
			duration = false
		}
		--[[
		if eater.components.hayfever and eater.components.hayfever.enabled then
			eater.components.hayfever:SetNextSneezeTime(self.antihistamine)			
		end
		--]]
	end

	if self.temperaturebump and self.temperaturebump ~= 0 then
		if bonuses.instant_temperature ~= nil then
			error("[Insight]: attempt to overwrite existing autocooldelta")
		end
		
		bonuses.instant_temperature = {
			delta = self.temperaturebump,
			duration = false
		}
	end

	return bonuses
end

local function IsKnownDebuff(debuffName)
	return debuff_definitions[debuffName] ~= nil
end

local function GetDebuffEffects(debuffName, context)
	local str

	local data = debuff_definitions[debuffName]
	if not data then return end

	if data.duration and data.value then -- percent based spices
		str = subfmt(context.lstr.debuffs[debuffName].description, { percent=Round(data.value * 100, 0), duration=data.duration })

	elseif data.duration and data.tick_rate and data.tick_value then -- regenerators
		local total_stat_gain = (data.duration or 0) / (data.tick_rate or 1) * (data.tick_value or 1)
		str = subfmt(context.lstr.debuffs[debuffName].description, { amount=total_stat_gain, duration=data.duration })

	elseif data.duration then -- just a buff
		str = subfmt(context.lstr.debuffs[debuffName].description, { duration=data.duration })

	elseif data.blank then
		-- Just a string without any formatting needed.
		str = context.lstr.debuffs[debuffName].description
	else
		local duration = data.duration
		local value = data.value
		local tick_rate = data.tick_rate
		local tick_value = data.tick_value
		error("invalid effect?")
	end

	return str
end

local function GetItemEffects(inst, context)
	local debuffs = item_debuffs[inst.prefab]
	if not debuffs then
		return nil
	end

	local strs = {}
	for i, debuffName in pairs(debuffs) do
		local str = GetDebuffEffects(debuffName, context)
		if str then
			strs[#strs+1] = str
		end
	end

	return strs
end

local function GetRealDebuffPrefab(whatever)
	return prefabs_to_generic_debuffs[whatever] or whatever
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
local this = {
	GetFoodEffects = GetFoodEffects,
	GetItemEffects = GetItemEffects,
	IsKnownDebuff = IsKnownDebuff,
	GetDebuffEffects = GetDebuffEffects,
	GetRealDebuffPrefab = GetRealDebuffPrefab,
}

if not IS_DST then
	return this
end

-- Foodbuffs
debuff_definitions["buff_attack"] = {
	duration = TUNING.BUFF_ATTACK_DURATION, 
	value = TUNING.BUFF_ATTACK_MULTIPLIER - 1
}

debuff_definitions["buff_playerabsorption"] = {
	duration = TUNING.BUFF_PLAYERABSORPTION_DURATION, 
	value = TUNING.BUFF_PLAYERABSORPTION_MODIFIER
}

debuff_definitions["buff_workeffectiveness"] = {
	duration = TUNING.BUFF_WORKEFFECTIVENESS_DURATION, 
	value = TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER - 1
}

debuff_definitions["buff_moistureimmunity"] = {
	duration = TUNING.BUFF_MOISTUREIMMUNITY_DURATION
}

debuff_definitions["buff_electricattack"] = {
	duration = TUNING.BUFF_ELECTRICATTACK_DURATION,
}

debuff_definitions["buff_sleepresistance"] = {
	duration = TUNING.SLEEPRESISTBUFF_TIME,
}

-- Other buffs
debuff_definitions["tillweedsalve_buff"] = {
	duration = TUNING.TILLWEEDSALVE_DURATION,
	tick_rate = TUNING.TILLWEEDSALVE_TICK_RATE,
	tick_value = TUNING.TILLWEEDSALVE_HEALTH_DELTA,
}


debuff_definitions["healthregenbuff"] = {
	duration = TUNING.JELLYBEAN_DURATION,
	tick_rate = TUNING.JELLYBEAN_TICK_RATE,
	tick_value = TUNING.JELLYBEAN_TICK_VALUE,
}


debuff_definitions["sweettea_buff"] = {
	duration = TUNING.SWEETTEA_DURATION,
	tick_rate = TUNING.SWEETTEA_TICK_RATE,
	tick_value = TUNING.SWEETTEA_SANITY_DELTA,
}

--[[
for i,v in pairs({
	["wormlight_light"] = "DURATION_MULT",
	["wormlight_light_lesser"] = "LESSER_DURATION_MULT", 
	["wormlight_light_greater"] = "GREATER_DURATION_MULT",
}) do
	if _G.Prefabs[v] then
		debuff_definitions[v] = {
			duration = TUNING.TOTAL_DAY_TIME * .5,
		}
	end
end
--]]
do
	-- I'm not happy about this and I don't even understand why I'm doing this.
	-- Meh.
	local DURATION_MULT = 1
	local LESSER_DURATION_MULT = .25
	local GREATER_DURATION_MULT = 4

	local map = {DURATION_MULT=DURATION_MULT, LESSER_DURATION_MULT=LESSER_DURATION_MULT, GREATER_DURATION_MULT=GREATER_DURATION_MULT}

	for prefab, upvalue in pairs({
		["wormlight_light"] = "DURATION_MULT",
		["wormlight_light_lesser"] = "LESSER_DURATION_MULT", 
		["wormlight_light_greater"] = "GREATER_DURATION_MULT",
	}) do
		debuff_definitions[prefab] = {
			duration = TUNING.TOTAL_DAY_TIME * map[upvalue],
		}
	end
end


-- Misc buffs
debuff_definitions["wintersfeastbuff"] = {
	blank = true
}

debuff_definitions["hungerregenbuff"] = {
	duration = TUNING.BATNOSEHAT_PERISHTIME,
	tick_rate = TUNING.HUNGERREGEN_TICK_RATE,
	tick_value = TUNING.HUNGERREGEN_TICK_VALUE,
}

-- Halloween buffs
debuff_definitions["halloweenpotion_health_buff"] = {
	duration = TUNING.SEG_TIME * 2,
	tick_rate = 2,
	tick_value = 1
}

debuff_definitions["halloweenpotion_sanity_buff"] = {
	duration = TUNING.SEG_TIME * 2,
	tick_rate = 2,
	tick_value = 1
}

debuff_definitions["halloweenpotion_bravery_small_buff"] = {
	duration = TUNING.TOTAL_DAY_TIME * .5,
}

debuff_definitions["halloweenpotion_bravery_large_buff"] = {
	duration = TUNING.TOTAL_DAY_TIME * .75,
}




--[[
for name, data in pairs(debuff_definitions) do
	data.prefab = name
end
--]]

--=================================================================================================================
--=================================================================================================================
--=================================================================================================================
--=================================================================================================================
item_debuffs["batnosehat"] = {"hungerregenbuff"}

item_debuffs["tillweedsalve"] = {"tillweedsalve_buff"}

item_debuffs["jellybean"] = {"healthregenbuff"}

item_debuffs["sweettea"] = {"sweettea_buff"}

item_debuffs["frogfishbowl"] = {"buff_moistureimmunity"}

item_debuffs["voltgoatjelly"] = {"buff_electricattack"}

item_debuffs["shroomcake"] = {"buff_sleepresistance"}

--=================================================================================================================
--=================================================================================================================
--=================================================================================================================
--=================================================================================================================
prefabs_to_generic_debuffs["halloweenpotion_health_small_buff"] = "halloweenpotion_health_buff"
prefabs_to_generic_debuffs["halloweenpotion_health_large_buff"] = "halloweenpotion_health_buff"
prefabs_to_generic_debuffs["halloweenpotion_sanity_small_buff"] = "halloweenpotion_sanity_buff"
prefabs_to_generic_debuffs["halloweenpotion_sanity_large_buff"] = "halloweenpotion_sanity_buff"
--prefabs_to_generic_debuffs["halloweenpotion_bravery_small_buff"] = "halloweenpotion_bravery_buff"
--prefabs_to_generic_debuffs["halloweenpotion_bravery_large_buff"] = "halloweenpotion_bravery_buff"

--=================================================================================================================
--=================================================================================================================
--=================================================================================================================
--=================================================================================================================

local spicedfoodsfn = loadfile("spicedfoods")

--[[
setfenv(spicedfoodsfn, setmetatable({
	Prefab = function(...)
}, {
	__index = getfenv(0),
}))
--]]


local SPICES = util.getupvalue(GenerateSpicedFoods, "SPICES")

-- The purpose of this is to populate our database with every food that has a debuff.
-- That way, when a spiced food gets inspected at any point, we can retrieve information about the spice used
-- in GetItemEffects and display them to the user.
for prefab, data in pairs(spicedfoods) do
	local spice_used = data.spice -- The spice applied to the food

	-- Only spices that have a prefab will apply a debuff.
	-- Check for spice to exist in the SPICES table in case mods are adding to spicedfoods.
	if SPICES[spice_used] and SPICES[spice_used].prefabs and SPICES[spice_used].prefabs[1] then
		-- We're only doing the first debuff prefab for simplicity's sake though.
		item_debuffs[prefab] = shallowcopy(SPICES[spice_used].prefabs)

		-- In case we have the base food already in item_debuffs for non-spice-buff reasons, we'll apply those buffs
		-- Into the spiced food database's entry for the item.
		-- Ex: We have frogfishbowl already defined, but the dish can have spices.
		-- So after we create those spiced dishes in the database, we need to bring over the moisture immunity debuff 
		-- into the list of debuffs for spiced food.
		local original = item_debuffs[data.basename]
		if original then
			for i, buffname in pairs(original) do
				table.insert(item_debuffs[prefab], i, buffname)
			end
		end
		
	end
end

return this