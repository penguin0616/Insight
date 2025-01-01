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

-- support_pillar_dreadstone.lua [Prefab]
local function Describe(inst, context)
	local description = nil

	-- TUNING.SUPPORT_PILLAR_DREADSTONE_REGEN_PERIOD

	if inst._regentask then
		description = string.format(context.lstr.support_pillar_dreadstone.time_until_reinforcement_regen, context.time:SimpleProcess(GetTaskRemaining(inst._regentask)))
	end
	
	return {
		name = "support_pillar_dreadstone",
		priority = 0,
		description = description,
		prefably = true
	}, Insight.prefab_descriptors.support_pillar.Describe(inst, context)
end



return {
	Describe = Describe
}