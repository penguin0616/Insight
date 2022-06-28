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

-- dragonfly_spawner.lua [Prefab]
-- Technically yeah, this isn't networked to clients, but whatever.
local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.time_to_respawn then
		return
	end

	local description = string.format(
		ProcessRichTextPlainly(context.lstr.dragonfly_spawner.time_to_respawn),
		context.time:TryStatusAnnouncementsTime(special_data.time_to_respawn)
	)

	return {
		description = description,
		append = true
	}
end

return {
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}
