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

-- carnivaldecorranker.lua
--[[
local low = Color.fromHex("#DED15E")
local high = Color.fromHex(Insight.COLORS.DECORATION)
--]]

-- #BB88FF nice purple

local colors = setmetatable({
	[1] = "#BB88FF",
	[2] = "#FF88BB",
	[3] = "#FF44FF",
}, {
	__index = function(self, index)
		rawset(self, index, "#ffffff")
		return rawget(self, index)
	end
})

local function Describe(self, context)
	if not context.config["display_cawnival"] then
		return
	end
	
	local description = nil
	local rank_string, decor_string
	
	if self.rank and TUNING.CARNIVAL_DECOR_RANK_MAX then
		rank_string = string.format(context.lstr.carnivaldecorranker.rank,
			colors[self.rank],
			colors[self.rank],
			self.rank,
			colors[TUNING.CARNIVAL_DECOR_RANK_MAX],
			TUNING.CARNIVAL_DECOR_RANK_MAX
		)
	end

	if self.totalvalue then
		decor_string = string.format(context.lstr.carnivaldecorranker.decor, self.totalvalue)
	end

	description = CombineLines(rank_string, decor_string)

	return {
		priority = 20,
		description = description
	}
end



return {
	Describe = Describe
}