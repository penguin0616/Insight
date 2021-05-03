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

-- stagehand.lua [Prefab]
local function Describe(inst, context)
	local description = nil

	-- lots of logic/math done here to make result make more sense / flow better
	local mem = inst.sg.mem
	local hits_left = mem.hits_left or TUNING.STAGEHAND_HITS_TO_GIVEUP -- something to display if no hits registered
	local hit_string = nil
	local reset_string = nil

	if mem.prevtimeworked then
		local offset = GetTime() - mem.prevtimeworked
		local remaining_time = TUNING.SEG_TIME * 0.5 - offset

		if remaining_time >= 0 then
			reset_string = string.format(context.lstr.stagehand.time_to_reset, context.time:SimpleProcess(remaining_time))
		else
			hits_left = TUNING.STAGEHAND_HITS_TO_GIVEUP -- we're technically reset to 86, though it doesn't take place until the next hit.
		end
	end
	
	hit_string = string.format(context.lstr.stagehand.hits_remaining, hits_left) 

	description = CombineLines(hit_string, reset_string)
	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}