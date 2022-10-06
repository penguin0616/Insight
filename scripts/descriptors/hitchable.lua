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

-- hitchable.lua
if true or not IS_DST then
	return { Describe = function() end }
end

local yotbHelper = import("helpers/yotb")

-- finally
local function Describe(self, context)
	if not context.config["display_yotb_appraisal"] then
		return
	end

	local hitched_to = self:GetHitch()
	if not hitched_to or not hitched_to:HasTag("yotb_post") then
		return
	end

	local description = "Yep, this is hitched to a post. Why did I forget to remove this?"

	


	--local score = GetBeefScore(self.inst)
	--local description = string.format(context.lstr.skinner_beefalo, score.FEARSOME, score.FESTIVE, score.FORMAL)


	return {
		priority = 0,
		description = description
	}

end



return {
	Describe = Describe
}