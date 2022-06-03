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

-- carnivaldecor_figure_kit.lua [Prefab]

local rarity_colors = {
	rare = Insight.COLORS.DECORATION,
	uncommon = "#bb88ff",
	common = "#ffcccc",
	unknown = "#ffffff",
}

-- Obtained from prefabs/carnivaldecor_figure.lua on June 11, 2021, game version 467172
local rarity_decor_vale_map = {
	rare     = 20,
	uncommon = 16,
	common   = 12,
	unknown  = "?",
}

local shape_rarity_season1 = setmetatable({
	s1 = "rare",
	s2 = "uncommon",
	s3 = "uncommon",
	s4 = "common",
	s5 = "common",
	s6 = "common",
	s7 = "uncommon",
	s8 = "common",
	s9 = "common",
	s10 = "common",
	s11 = "common",
	s12 = "common",
}, {
	__index = function(self, index)
		rawset(self, index, "unknown")
		return "unknown"
	end
})

local shape_rarity_season2 = setmetatable({
	s1 = "common",
	s2 = "common",
	s3 = "uncommon",
	s4 = "uncommon",
	s5 = "common",
	s6 = "common",
	s7 = "common",
	s8 = "uncommon",
	s9 = "common",
	s10 = "uncommon",
	s11 = "common",
	s12 = "rare",
}, {
	__index = function(self, index)
		rawset(self, index, "unknown")
		return "unknown"
	end
})

local shape_rarity = {
	shape_rarity_season1,
	shape_rarity_season2
}

local function GetData(inst)
	if not inst.shape then
		return
	end

	local season_table = shape_rarity[inst.carnival_season]
	if not season_table then
		return
	end

	local rarity = season_table[inst.shape]

	return {
		rarity = rarity,
		rarity_color = rarity_colors[rarity],
		decor = rarity_decor_vale_map[rarity]
	}
end

local function Describe(inst, context)
	if not context.config["display_cawnival"] then
		return
	end

	local description = nil

	if not inst.shape then
		description = context.lstr.carnivaldecor_figure_kit.undecided
	else
		local data = GetData(inst)
		if not data then
			return
		end

		local shape = string.format(context.lstr.carnivaldecor_figure_kit.shape, ApplyColour(inst.shape, data.rarity_color))
		local rarity = string.format(context.lstr.carnivaldecor_figure_kit.rarity,
			ApplyColour(context.lstr.carnivaldecor_figure_kit.rarity_types[data.rarity], data.rarity_color)
		)
		local season = string.format(context.lstr.carnivaldecor_figure_kit.season, inst.carnival_season)
		local decor = string.format(context.lstr.carnivaldecor.value, data.decor)
		description = CombineLines(shape, rarity, season, decor)
	end

	return {
		priority = 10,
		description = description
	}
end

return {
	GetData = GetData,
	Describe = Describe,
}
