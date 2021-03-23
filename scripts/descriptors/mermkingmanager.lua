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

-- mermkingmanager.lua [Worldly]
local function Describe(self, context)
	local description = nil

	-- HasKing checks if king is valid, getking gets it
	local king = self:HasKing() and self:GetKing()
	if king then
		local hunger_data = Insight.descriptors.hunger.GetData(king.components.hunger, context) or nil
		if hunger_data then
			local time_to_decay = Insight.descriptors.hunger.GetTimeToEmpty(king.components.hunger)
			local time_to_die = king.components.health and king.components.health.currenthealth / king.components.hunger.hurtrate

			local remaining = Round(time_to_decay + time_to_die, 0)

			description = string.format("<icon=hunger> %s / %s, dies in: %s", hunger_data.hunger, hunger_data.max_hunger, TimeToText(time.new(remaining, context), "both_short"))
		end
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Mermking.xml",
			tex = "Mermking.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe
}