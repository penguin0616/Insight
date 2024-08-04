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

-- inspectacleshat.lua [Prefab]
local function Describe(self, context)
	local player = context.player
	if not player or
		player.prefab ~= "winona" or
		not player.components.skilltreeupdater or
		not player.components.skilltreeupdater:IsActivated("winona_wagstaff_1") or
		not player.components.inspectaclesparticipant
	then
		return nil
	end

	local description

	if not player.components.inspectaclesparticipant.cooldowntask then
		-- Thinking on this now, we know it's ready by lack of cooldown.
		--description = context.lstr.inspectacleshat.ready_to_use
	else
		description = string.format(context.lstr.cooldown,
			context.time:SimpleProcess(GetTaskRemaining(player.components.inspectaclesparticipant.cooldowntask))
		)
	end

	return {
		--name = "inspectacleshat",
		priority = 0,
		description = description,
		prefably = true,
	}
end

return { 
	Describe = Describe
}
