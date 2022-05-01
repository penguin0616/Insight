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

-- upgrademodule.lua
local MODULE_PREFIX = "wx78module_"

local module_describers = {}

-- Hardy Circuit
module_describers.maxhealth = function(self, context)
	return string.format(context.lstr.upgrademodule.module_describers.maxhealth, TUNING.WX78_MAXHEALTH_BOOST)
end

-- Processing Circuit
module_describers.maxsanity1 = function(self, context)
	return string.format(context.lstr.upgrademodule.module_describers.maxsanity, TUNING.WX78_MAXSANITY1_BOOST)
end

-- Super-Processing Circuit
module_describers.maxsanity = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.maxsanity, 
		TUNING.WX78_MAXSANITY_BOOST
	) .. "\n" .. string.format(
		context.lstr.dapperness,
		FormatDecimal(TUNING.WX78_MAXSANITY_DAPPERNESS * 60, 1)
	)
end

-- Acceleration Circuit
module_describers.movespeed = function(self, context)
	-- +1 to ignore the movespeed 0 thing
	-- +1 and another to figure out what the speed boost would be if i was inserting a chip
	local num = (context.player._movespeed_chips or 0) + 1 + 1

	-- this is kind of a mess
	local str = ""
	local len = #TUNING.WX78_MOVESPEED_CHIPBOOSTS
	for i = 2, len do
		local boost = (TUNING.WX78_MOVESPEED_CHIPBOOSTS[i] - TUNING.WX78_MOVESPEED_CHIPBOOSTS[i - 1]) * 100
		str = str .. ApplyColour(
			(i == num and "<u>" or "") .. boost .. "%" .. (i == num and "</u>" or ""),
			i == num and "#469de8" or "DAIRY"
		)
		if i < len then
			str = str .. "/"
		end
	end

	return string.format(context.lstr.upgrademodule.module_describers.movespeed, str)
end

-- Super-Acceleration Circuit
module_describers.movespeed2 = module_describers.movespeed

-- Thermal Circuit
module_describers.heat = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.heat,
		TUNING.WX78_MINTEMPCHANGEPERMODULE
	) .. "\n" .. string.format(
		context.lstr.upgrademodule.module_describers.heat_drying,
		0.1
	)
end

-- Optoelectronic Circuit
--[[
module_describers.nightvision = function(self, context)
	return nil
end
--]]

-- Refrigerant Circuit
module_describers.cold = function(self, context)
	return string.format(context.lstr.upgrademodule.module_describers.cold, TUNING.WX78_MINTEMPCHANGEPERMODULE)
end

-- Electrification Circuit
module_describers.taser = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.taser,
		TUNING.WX78_TASERDAMAGE,
		context.lstr.weapon_damage_type.electric,
		0.3
	)
end

-- Illumination Circuit
module_describers.light = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.light,
		TUNING.WX78_LIGHT_BASERADIUS,
		TUNING.WX78_LIGHT_EXTRARADIUS
	)
end

-- Super-Gastrogain Circuit
module_describers.maxhunger = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.maxhunger,
		TUNING.WX78_MAXHUNGER_BOOST
	) .. "\n" .. string.format(
		context.lstr.hunger_slow,
		(1 - TUNING.WX78_MAXHUNGER_SLOWPERCENT) * 100
	)
end

-- Gastrogain Circuit
module_describers.maxhunger1 = function(self, context)
	return string.format(context.lstr.upgrademodule.module_describers.maxhunger, TUNING.WX78_MAXHUNGER1_BOOST)
end

-- Chorusbox Circuit
module_describers.music = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.music, 
		FormatDecimal(TUNING.WX78_MUSIC_SANITYAURA * 60, 1)
	) .. "\n" .. string.format(
		context.lstr.upgrademodule.module_describers.music_tend,
		TUNING.WX78_MUSIC_TENDRANGE
	)
end

-- Beanbooster Circuit
module_describers.bee = function(self, context)
	return string.format(
		context.lstr.upgrademodule.module_describers.bee,
		TUNING.WX78_BEE_HEALTHPERTICK,
		TUNING.WX78_BEE_TICKPERIOD,
		TUNING.WX78_BEE_HEALTHPERTICK * (TUNING.TOTAL_DAY_TIME / TUNING.WX78_BEE_TICKPERIOD)
	) .. "\n" .. module_describers.maxsanity(self, context)
end

-- Super-Hardy Circuit
module_describers.maxhealth2 = function(self, context)
	return string.format(context.lstr.upgrademodule.module_describers.maxhealth, TUNING.WX78_MAXHEALTH_BOOST * TUNING.WX78_MAXHEALTH2_MULT)
end

local function Describe(self, context)
	local description = nil

	-- wx78module_
	local module_name = self.inst.prefab:sub(#MODULE_PREFIX + 1)

	if module_describers[module_name] then
		description = module_describers[module_name](self, context)
	end

	return {
		priority = 0,
		description = description
	}
end

return {
	Describe = Describe
}
