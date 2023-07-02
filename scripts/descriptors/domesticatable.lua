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

-- domesticatable.lua
-- x, y, z = 20, 10, 10; print(x * 2, x+y+z) -> 40 40
-- x, y, z = 40, 20, 20; print(x * 2, x+y+z) -> 80 80
-- so in other words, dominant trait must be 50% of overall points

local TENDENCY_COLORS = setmetatable({
	[TENDENCY.DEFAULT] = "#bbbbbb",
	[TENDENCY.ORNERY] = "#B33C34", --"#A22B23",
	[TENDENCY.RIDER] = Insight.COLORS.ENLIGHTENMENT,
	[TENDENCY.PUDGY] = Insight.COLORS.HUNGER,
}, {
	__index = function(self, index)
		rawset(self, index, "#ffffff")
		return rawget(self, index)
	end,
})

-- order to display
--local ORDER = {TENDENCY.DEFAULT, TENDENCY.ORNERY, TENDENCY.RIDER, TENDENCY.PUDGY}
local ORDER = {TENDENCY.RIDER, TENDENCY.ORNERY, TENDENCY.PUDGY}

local function GetTotalTendencyPoints(self)
	local total = 0
	for tendency, points in pairs(self.tendencies) do
		total = total + points
	end
	return total
end

local function Describe(self, context)
	local description, alt_description

	if not context.config["domestication_information"] then
		return nil
	end

	-- figure out stats
	if not type(self.domestication) == "number" or not type(self.obedience) == "number" then
		return
	end

	local domestication = Round(self.domestication * 100, 2)
	local obedience = Round(self.obedience * 100, 1)
	local total_tendency_points = GetTotalTendencyPoints(self)
	--local ride_obedience = self.inst.components.rideable and math.floor(self.inst.components.rideable.requiredobedience * 100) or "?"

	-- make strings
	local domestication_string = domestication > 0 and string.format(context.lstr.domesticatable.domestication, domestication) or nil
	
	local obedience_string = obedience > 0 and string.format(context.lstr.domesticatable.obedience, obedience) or nil
	--local obedience_extended_string = obedience > 0 and string.format(context.lstr.domesticatable.obedience_extended, obedience, TUNING.BEEFALO_SADDLEABLE_OBEDIENCE*100, TUNING.BEEFALO_KEEP_SADDLE_OBEDIENCE*100, ride_obedience) or nil
	local obedience_extended_string = obedience > 0 and string.format(context.lstr.domesticatable.obedience_extended, obedience, TUNING.BEEFALO_KEEP_SADDLE_OBEDIENCE*100, (self.minobedience and Round(self.minobedience * 100, 0))) or nil
	-- (self.minobedience and Round(self.minobedience * 100, 0)) TUNING.BEEFALO_MIN_DOMESTICATED_OBEDIENCE[inst.tendency]

	local dominant_tendency_string = self.inst.tendency and ApplyColor(context.lstr.domesticatable.tendencies[self.inst.tendency] or "???", TENDENCY_COLORS[self.inst.tendency])
	local tendency_string = dominant_tendency_string and string.format(context.lstr.domesticatable.tendency, dominant_tendency_string) or nil
	
	local full_tendency_string = ""

	for i = 1, #ORDER do
		local tendency = ORDER[i]
		local tendency_amt = self.tendencies[tendency] or 0
		local tendency_percent = total_tendency_points > 0 and (tendency_amt / total_tendency_points * 100) or 0
		full_tendency_string = full_tendency_string .. string.format("%s: %s (<color=" .. TENDENCY_COLORS[tendency].. ">%s%%</color>), ", 
			ApplyColor(context.lstr.domesticatable.tendencies[tendency] or "?", TENDENCY_COLORS[tendency]),
			Round(tendency_amt, 3),
			Round(tendency_percent, 2)
		)
	end

	if #full_tendency_string > 0 then
		full_tendency_string = full_tendency_string:sub(1, -3)
	end

	description = CombineLines(domestication_string, obedience_string, tendency_string)
	alt_description = CombineLines(domestication_string, obedience_extended_string, tendency_string, full_tendency_string)

	return {
		priority = 10,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}