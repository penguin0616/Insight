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

-- oceanfishingtackle.lua
-- This handles both the bobbers and the lure.

-- Bobbers:
--[[
The bobbers are created in prefabs/oceanfishingbobber.lua, its one of those bulk prefab generators
Bobber data is in TUNING.OCEANFISHING_TACKLE
The BASE in there is set on the rod prefab, and the bobbers/tackle have modifiers to that base
]]

-- Lures:
--[[
The lures are created in prefabs/oceanfishinglure.lua, its one of those bulk prefab generators
Lure data is in TUNING.OCEANFISHING_LURE
The HOOK in there is set on the rod prefab and I believe is just "cast a line and hope." 

Several properties:
	-- radius = how far away the fish will start to be attracted to it
	-- charm = 0 to 1
	-- reel_charm = -1 to 1
	-- timeofday = {day = 1, dusk = 0.5, night = 0.5}
	-- style = spoon, spinnerbait, berry, seed, hook
	-- dist_max = added to the casting distance
]]

-- MAX_HOOK_DIST

local function Describe(self, context)
	local description = nil

	-- I'm doing a bunch of conditionals for members of the datas in case some mod does something weird. 
	-- As far as I'm aware, they shouldn't be nil in vanilla.

	if not context.config["display_tackle_information"] then
		return
	end

	if self.casting_data then
		local bonus_distance
		if self.casting_data.dist_max then
			bonus_distance = string.format(context.lstr.oceanfishingtackle.casting.bonus_distance, 
				self.casting_data.dist_max
			)
		end


		local bonus_accuracy
		if self.casting_data.dist_min_accuracy and self.casting_data.dist_max_accuracy then
			bonus_accuracy = string.format(context.lstr.oceanfishingtackle.casting.bonus_accuracy, 
				self.casting_data.dist_min_accuracy * 100, 
				self.casting_data.dist_max_accuracy * 100
			)
		end

		description = CombineLines(bonus_distance, bonus_accuracy)
	end

	if self.lure_data then
		local charm
		if self.lure_data.charm and self.lure_data.reel_charm then
			charm = string.format(context.lstr.oceanfishingtackle.lure.charm, 
				self.lure_data.charm, 
				self.lure_data.reel_charm
			)
		end

		local stamina_drain
		if self.lure_data.stamina_drain then
			stamina_drain = string.format(context.lstr.oceanfishingtackle.lure.stamina_drain,
				self.lure_data.stamina_drain
			)
		end

		local timeofday
		if self.lure_data.timeofday and self.lure_data.timeofday.day and self.lure_data.timeofday.dusk and self.lure_data.timeofday.night then
			timeofday = string.format(context.lstr.oceanfishingtackle.lure.time_of_day_modifier, 
				self.lure_data.timeofday.day * 100, 
				self.lure_data.timeofday.dusk * 100, 
				self.lure_data.timeofday.night * 100
			)
		end

		local weather
		if self.lure_data.weather and self.lure_data.weather.default and self.lure_data.weather.raining and self.lure_data.weather.snowing then
			weather = string.format(context.lstr.oceanfishingtackle.lure.weather_modifier, 
				self.lure_data.weather.default * 100, 
				self.lure_data.weather.raining * 100, 
				self.lure_data.weather.snowing * 100
			)
		end

		
		description = CombineLines(description, charm, stamina_drain, timeofday, weather)
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}