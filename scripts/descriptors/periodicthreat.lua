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

-- periodicthreat.lua [Worldly]
local function Describe(self, context)
	-- DS only
	local inst = self.inst
	local description = nil

	local wormthreat = self.threats["WORM"]

	--[[
	for name, data in pairs(self.threats) do
		mprint(name, data.timer, data.state, data.state_variables.statetimer)
	end
	--]]

	--dprint(wormthreat.timer, wormthreat.state, wormthreat.state_variables.statetimer)

	if wormthreat.state == "wait" then
		description = string.format(context.lstr.worms_incoming, TimeToText(time.new(wormthreat.timer, context)))
	elseif wormthreat.state == "warn" then
		description = string.format(context.lstr.worms_incoming_danger, TimeToText(time.new(wormthreat.timer, context)))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Depths_Worm.xml",
			tex = "Depths_Worm.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe
}