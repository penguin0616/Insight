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

-- book.lua
local WICKER_BOOK_INFO = {
	book_tentacles = {
		range = 8,
		--color = "#3B2249",
		color = "#9864F5",
		tentacles_spawned = 3,
	},
	book_birds = {
		range = 10,
		color = Insight.COLORS.EGG,
		max_birds = 30,
	},
	book_brimstone = {
		range = 15,
		color = "#DED15E",
		strikes = 16
	},
	book_sleep = {
		range = 30,
		color = "#525EAC",
	},
	book_gardening = { -- Old (Original) Gardening Book
		range = 30,
		color = Insight.COLORS.NATURE
	},
	book_horticulture = {
		range = 30,
		color = Insight.COLORS.NATURE,
		affected = 10
	},
	book_horticulture_upgraded = {
		range = 30,
		color = Insight.COLORS.NATURE,
		affected = 15
	},
	book_silviculture = {
		range = 30,
		color = Insight.COLORS.INEDIBLE
	},
	-- nothing useful here?
	--[[
	book_fish = {
		--range = 
	}
	--]]
	book_fire = {
		range = BOOK_FIRE_RADIUS,
		color = "#923822"
	},
	book_web = {
		color = "#bbbbbb",
		duration = TUNING.BOOK_WEB_GROUND_DURATION,
	},
	book_temperature = {
		range = TUNING.BOOK_TEMPERATURE_RADIUS,
		color = Insight.COLORS.FROZEN,
	},
	book_light = {
		color = "LIGHT",
		duration = TUNING.TOTAL_DAY_TIME / 2,
	},
	book_light_upgraded = {
		color = "LIGHT",
		duration = TUNING.TOTAL_DAY_TIME * 2,
	},
	book_rain = {
		range = TILE_SCALE*2,
		color = "WET",
	},
	book_bees = {
		amount = TUNING.BOOK_BEES_AMOUNT,
		cap = TUNING.BOOK_MAX_GRUMBLE_BEES,
		color = "#f5dd0f" -- brighter? #fcf003
	},
	book_research_station = {
		bonuses = {
			SCIENCE = 2,
			MAGIC = 2,
			SEAFARING = 2
		},
	},
	book_meteor = {
		range = TUNING.VOLCANOBOOK_FIRERAIN_RADIUS, -- im hoping that when book_meteor exists, this exists. == 5 in SW anyway.
		color = Insight.COLORS.VEGGIE,
		meteors = TUNING.VOLCANOBOOK_FIRERAIN_COUNT
	},

	
}

local WICKER_BOOK_INFO_PRIORITY = 6
-- Not sure how I feel about using prefab names as descriptor return names here...
WICKER_BOOK_INFO.book_tentacles.DescribeBook = function(data, context)
	return {
		name = "book_tentacles",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.tentacles, data.color, data.tentacles_spawned)
	}
end
WICKER_BOOK_INFO.book_birds.DescribeBook = function(data, context)
	return {
		name = "book_birds",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.birds, data.color, data.max_birds)
	}
end
WICKER_BOOK_INFO.book_brimstone.DescribeBook = function(data, context)
	return {
		name = "book_brimstone",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.brimstone, data.color, data.strikes)
	}
end
-- nothing useful for book_sleep
-- book_gardening seems self explanatory
WICKER_BOOK_INFO.book_horticulture.DescribeBook = function(data, context)
	return {
		name = "book_horticulture",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.horticulture, data.color, data.affected)
	}
end
WICKER_BOOK_INFO.book_horticulture_upgraded.DescribeBook = function(data, context)
	return {
		name = "book_horticulture_upgraded",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.horticulture_upgraded, data.color, data.affected)
	}
end
WICKER_BOOK_INFO.book_web.DescribeBook = function(data, context)
	return {
		name = "book_web",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.web, data.color, data.color, context.time:SimpleProcess(data.duration, "realtime_short"))
	}
end
-- book_temperature
WICKER_BOOK_INFO.book_light.DescribeBook = function(data, context)
	return {
		name = "book_light",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.light, context.time:SimpleProcess(data.duration))
	}
end
WICKER_BOOK_INFO.book_light_upgraded.DescribeBook = function(data, context)
	return {
		name = "book_light_upgraded",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.light, context.time:SimpleProcess(data.duration))
	}
end
WICKER_BOOK_INFO.book_rain.DescribeBook = function(data, context)
	return {
		name = "book_rain",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.rain)
	}
end
WICKER_BOOK_INFO.book_bees.DescribeBook = function(data, context)
	return {
		name = "book_bees",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.bees, data.color, data.amount, data.color, data.cap)
	}
end
WICKER_BOOK_INFO.book_research_station.DescribeBook = function(data, context)
	local list = {}
	for tab, amt in pairs(data.bonuses) do
		table.insert(list, string.format(
			context.lstr.book.wickerbottom._research_station_charge, 
			"<string=TABS." .. tab ..">",
			amt
		))
	end


	return {
		name = "book_research_station",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.research_station, table.concat(list, ", "))
	}
end



WICKER_BOOK_INFO.book_meteor.DescribeBook = function(data, context)
	if IS_DST then
		return
	end
	
	return {
		name = "book_meteor",
		priority = WICKER_BOOK_INFO_PRIORITY,
		description = string.format(context.lstr.book.wickerbottom.meteor, data.color, data.meteors)
	}
end

local function Describe(self, context)
	local description

	local reader = context.player.components.reader
	if not reader then
		return
	end

	if reader.aspiring_bookworm then
		if checknumber(self.peruse_sanity) then
			description = string.format(context.lstr.sanity.interaction, self.peruse_sanity)
		end
	else
		if checknumber(self.read_sanity) then
			description = string.format(context.lstr.sanity.interaction, self.read_sanity)
		end
	end

	local wicker_data = WICKER_BOOK_INFO[self.inst.prefab]
	local book_fn_info, range_info 
	if wicker_data then
		book_fn_info = wicker_data.DescribeBook and wicker_data.DescribeBook(wicker_data, context) or nil

		if wicker_data.range then
			range_info = {
				name = "insight_ranged",
				priority = 0,
				description = nil,
				range = wicker_data.range,
				color = wicker_data.color,
				attach_player = nil
			}
		end
	end


	return {
		name = "book_sanity_info",
		priority = 5,
		description = description
	}, book_fn_info, range_info
end

return {
	Describe = Describe,
	WICKER_BOOK_INFO = WICKER_BOOK_INFO, -- maybe someone wants to change this
}