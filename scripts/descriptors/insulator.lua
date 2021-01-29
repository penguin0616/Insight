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

-- insulator.lua
local function Describe(self, context)
	local inst = self.inst
	local description = "[why am i empty]"

	-- self.cooling is not used

	local insulation, season = self.insulation, "WINTER" -- base game
	
	if self.GetInsulation then
		insulation, season = self:GetInsulation()
	else
		-- base game
	end

	local str = (season:lower() == "winter" and context.lstr.insulation_winter) or (season:lower() == "summer" and context.lstr.insulation_summer) or "?"

	description = string.format(str, insulation)

	return {
		priority = 3,
		description = description
	}
end



return {
	Describe = Describe
}