--[[
Copyright (C) 2020 penguin0616

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


-- bloomness.lua
local WHITE = Color.new(1, 1, 1, 1)
local LIGHT_PINK = Color.fromHex(Insight.COLORS.LIGHT_PINK)

local function Describe(self, context)
	local description = nil

	if self.rate <= 0 then
		return
	end

	local amount = self.timer / self.rate

	local remaining_time = time.new(amount, context)
	local next_stage = self.is_blooming and (self.level + 1) or (self.level - 1)

	if self.is_blooming or self.level ~= 0 then
		local clr1 = WHITE:Lerp(LIGHT_PINK, self.level / self.max):ToHex()
		local clr2 = WHITE:Lerp(LIGHT_PINK, next_stage / self.max):ToHex()
		--description = string.format("Will enter stage %s/<color=LIGHT_PINK>%s</color> in %s", ApplyColour(next_stage, clr), self.max, TimeToText(remaining_time))
		
		description = string.format("Stage %s -> %s in %s", ApplyColour(self.level, clr1), ApplyColour(next_stage, clr2), TimeToText(remaining_time))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/hud.xml",
			tex = "tab_nature.tex"
		},
		playerly = true
	}
end



return {
	Describe = Describe
}