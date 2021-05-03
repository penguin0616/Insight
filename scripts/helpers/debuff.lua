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
local preparedfoods_warly = IsDST() and require("preparedfoods_warly") or {}
local spicedfoods = IsDST() and require("spicedfoods") or {}
local world_type = GetWorldType()
local debuff_effects = {}

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
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

	if self.autodrydelta and self.autodryduration and self.autodrydelta ~= 0 and self.autodryduration ~= 0 then
		--eater.components.locomotor:AddSpeedModifier_Additive("AUTODRY", self.autodrydelta, self.autodryduration)
		bonuses.autodry = {
			delta = self.autodrydelta,
			duration = self.autodryduration
		}
	end

	-- immediate cooling
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
	if self.antihistamine then
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
		assert(bonuses.instant_temperature == nil, "[Insight]: attempt to overwrite existing autocooldelta")
		bonuses.instant_temperature = {
			delta = self.temperaturebump,
			duration = false
		}
	end

	return bonuses
end

local function GetItemEffects(inst, context)
	local effects = debuff_effects[inst.prefab]
	if not effects then
		return nil
	end

	local strs = {}
	for buffname, buffdata in pairs(effects) do
		local data = buffdata.data
		if data.duration and data.value then -- percent based spices
			strs[#strs+1] = string.format(context.lstr.debuffs[buffdata.prefab], Round(data.value * 100, 0), data.duration)
		elseif data.duration and data.tick_rate and data.tick_value then -- regenerators
			local total_stat_gain = (data.duration or 0) / (data.tick_rate or 1) * (data.tick_value or 1)
			strs[#strs+1] = string.format(context.lstr.debuffs[buffdata.prefab], total_stat_gain, data.duration)
		elseif data.duration then
			strs[#strs+1] = string.format(context.lstr.debuffs[buffdata.prefab], data.duration)
		else
			local duration = data.duration
			local value = data.value
			local tick_rate = data.tick_rate
			local tick_value = data.tick_value
			error("invalid effect?")
		end
	end

	return strs
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
debuff_effects["tillweedsalve"] = { -- (recipe) prefab
	-- debuff name
	["tillweedsalve_buff"] = {
	 	-- debuff prefab
		prefab = "tillweedsalve_buff",
		-- debuff data
		data = {
			duration = TUNING.TILLWEEDSALVE_DURATION,
			tick_rate = TUNING.TILLWEEDSALVE_TICK_RATE,
			tick_value = TUNING.TILLWEEDSALVE_HEALTH_DELTA,
		},
	}
}

debuff_effects["jellybean"] = {
	["healthregenbuff"] = {
		prefab = "healthregenbuff",
		data = {
			duration = TUNING.JELLYBEAN_DURATION,
			tick_rate = TUNING.JELLYBEAN_TICK_RATE,
			tick_value = TUNING.JELLYBEAN_TICK_VALUE,
		},
	}
}
debuff_effects["sweettea"] = {
	["sweettea_buff"] = {
		prefab = "sweettea_buff",
		data = {
			duration = TUNING.SWEETTEA_DURATION,
			tick_rate = TUNING.SWEETTEA_TICK_RATE,
			tick_value = TUNING.SWEETTEA_SANITY_DELTA,
		}
	}
}

debuff_effects["frogfishbowl"] = {
	["buff_moistureimmunity"] = {
		prefab = "buff_moistureimmunity",
		data = {
			duration = TUNING.BUFF_MOISTUREIMMUNITY_DURATION,
		}
	}
}

debuff_effects["voltgoatjelly"] = {
	["buff_electricattack"] = {
		prefab = "buff_electricattack",
		data = {
			duration = TUNING.BUFF_ELECTRICATTACK_DURATION,
		}
	}
}

debuff_effects["shroomcake"] = {
	["buff_sleepresistance"] = {
		prefab = "buff_sleepresistance",
		data = {
			duration = TUNING.SLEEPRESISTBUFF_TIME,
		}
	}
}



local this = {
	GetFoodEffects = GetFoodEffects,
	GetItemEffects = GetItemEffects,
}

if not IsDST() then
	return this
end


local SPICES = util.getupvalue(GenerateSpicedFoods, "SPICES")

local SPICES_STATS = {
    SPICE_GARLIC = { duration=TUNING.BUFF_PLAYERABSORPTION_DURATION, value=TUNING.BUFF_PLAYERABSORPTION_MODIFIER },
    SPICE_SUGAR  = { duration=TUNING.BUFF_WORKEFFECTIVENESS_DURATION, value=TUNING.BUFF_WORKEFFECTIVENESS_MODIFIER-1 },
    SPICE_CHILI  = { duration=TUNING.BUFF_ATTACK_DURATION, value=TUNING.BUFF_ATTACK_MULTIPLIER-1 },
    --SPICE_SALT   = {},
}


for prefab, data in pairs(spicedfoods) do
	if data.spice ~= "SPICE_SALT" then
		local spice_buff = SPICES[data.spice].prefabs[1]
		debuff_effects[prefab] = {
			[spice_buff] = {
				prefab = spice_buff,
				data = SPICES_STATS[data.spice]
			}
		}

		local original = debuff_effects[data.basename]
		if original then
			for buffname, buffdata in pairs(original) do
				debuff_effects[prefab][buffname] = buffdata
			end
		end
	end
end

return this