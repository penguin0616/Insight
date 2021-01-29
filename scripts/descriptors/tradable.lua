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

-- tradable.lua
local function Describe(self, context)
	local description = nil
	local gold = self.goldvalue > 0 and self.goldvalue
	local dubloon = self.dubloonvalue and self.dubloonvalue > 0 and self.dubloonvalue
	local tribute = self.rocktribute and self.rocktribute > 0 and self.rocktribute


	if context.config["item_worth"] then
		if gold and dubloon then
			--description = string.format("Worth %s and %s.", gold, dubloon)
			description = string.format(context.lstr.tradable_gold_dubloons, gold, dubloon)
		elseif gold then
			--description = string.format("Worth %s.", gold)
			description = string.format(context.lstr.tradable_gold, gold)
		end
	end

	if context.config["appeasement_value"] then
		if tribute then
			tribute = string.format(context.lstr.tradable_rocktribute, TimeToText(time.new(tribute * TUNING.ANTLION_TRIBUTE_TO_RAGE_TIME, context)))
			description = CombineLines(description, tribute)
		end
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}