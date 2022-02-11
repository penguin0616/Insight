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

-- hideandseekgame.lua
-- GetDistanceSqToPoint returns squared wall distance
-- so if the hiding range is 30 (KITCOONDEN_HIDEANDSEEK_HIDING_RADIUS_MAX), :FindEntities returns all entities within 30 units
-- the minimum range is KITCOONDEN_HIDEANDSEEK_HIDING_RADIUS_MIN_SQ, which is 5*5, so things have to be at least 5 units away

local function Describe(self, context)
	local description

	local hiding_range = string.format(context.lstr.hideandseekgame.hiding_range, math.sqrt(TUNING.KITCOONDEN_HIDEANDSEEK_HIDING_RADIUS_MIN_SQ) / 4, self.hiding_range / 4)
	local needed_spots = self.inst.components.kitcoonden and string.format(context.lstr.hideandseekgame.needed_hiding_spots, self.inst.components.kitcoonden.num_kitcoons * 5) or "no kitcoonden component"
	
	description = CombineLines(hiding_range, needed_spots)

	return {
		priority = 1,
		description = description
	}
end



return {
	Describe = Describe
}