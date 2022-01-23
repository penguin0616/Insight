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

-- herdmember.lua
local function Describe(self, context)
	-- afaik, no way to mouse over herd component
	-- so just taking care of this one

	if not context.config["herd_information"] then
		return
	end

	local herdobject = self:GetHerd()
	if not herdobject then
		return
	end

	local herd = herdobject.components.herd
	local mood = herdobject.components.mood

	local herd_info = herd and {
		name = "herd",
		priority = 0
	} or nil

	local mood_info = mood and {
		name = "mood",
		priority = 0,
	} or nil

	if herd then
		herd_info.alt_description = string.format(context.lstr.herd_size, herd.membercount, herd.maxsize)
	end

	if mood and mood.enabled and mood.daystomoodchange then
		if mood.isinmood then
			mood_info.description = string.format(context.lstr.mood.exit, mood.daystomoodchange)
		else
			mood_info.description = string.format(context.lstr.mood.enter, mood.daystomoodchange)
		end
		--mood_info.description = mood:GetDebugString()
	end

	return herd_info, mood_info
end



return {
	Describe = Describe
}