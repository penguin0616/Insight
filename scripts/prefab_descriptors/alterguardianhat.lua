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

-- alterguardianhat.lua [Prefab]
local function Describe(inst, context)
	local description = nil
	
	if not context.complex_config["unique_info_prefabs"][inst.prefab] then
		return
	end
	
	local minimum_sanity_string = context.player.components.sanity and string.format(context.lstr.alterguardianhat.minimum_sanity, 
		math.ceil(context.player.components.sanity.max * TUNING.SANITY_BECOME_ENLIGHTENED_THRESH),
		TUNING.SANITY_BECOME_ENLIGHTENED_THRESH * 100
	)

	local gestalt_damage_string = string.format(context.lstr.alterguardianhat.summoned_gestalt_damage, TUNING.ALTERGUARDIANHAT_GESTALT_DAMAGE)
	
	description = CombineLines(minimum_sanity_string, gestalt_damage_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}

