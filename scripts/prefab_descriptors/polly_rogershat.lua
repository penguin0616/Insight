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

-- polly_rogershat.lua [Prefab]
local function Describe(inst, context)
	local description = nil

	--[[
	return {
		priority = 0,
		description = description,
		prefably = true
	}
	--]]

	return {
		name = "insight_ranged",
		priority = 0,
		description = nil,
		range = 15, -- PICKUP_RANGE in pollyrogerbrain.lua
		color = "#ded15e",
		attach_player = true
	}
end

local function StatusAnnoucementsDescribe(special_data, context, inst)
	local respawn_time = GetLocalInsight(context.player):GetInformation(inst).special_data.spawner.respawn_time
	if not respawn_time then
		return
	end

	local description = ProcessRichTextPlainly(string.format(
		context.lstr.polly_rogershat.announce_respawn,
		context.time:TryStatusAnnouncementsTime(respawn_time)
	))

	return {
		description = description,
		append = true
	}
end

return {
	Describe = Describe,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}
