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

-- friendlevels.lua
local HERMIT_TASKS = nil
local HERMIT_TASKS_INVERTED = nil

local function Describe(self, context)
	local description, alt_description = nil, nil
	local friendlevel = string.format(context.lstr.friendlevel, self:GetLevel(), self:GetMaxLevel())
	local taskstuff = nil

	if self.inst.prefab == "hermitcrab" then
		if HERMIT_TASKS == nil then
			local listener = self.inst and
				self.inst.event_listening and
				self.inst.event_listening.CHEVO_lureplantdied and 
				self.inst.event_listening.CHEVO_lureplantdied[TheWorld]
				and self.inst.event_listening.CHEVO_lureplantdied[TheWorld][1]
			or nil

			if not listener then
				description = "Missing data error [1]"
			else
				HERMIT_TASKS = util.getupvalue(listener, "checklureplant", "TASKS")
				if not HERMIT_TASKS then
					description = "Missing data error [2]"
				else
					HERMIT_TASKS_INVERTED = table.invert(HERMIT_TASKS)
				end
			end
		end
		
		if HERMIT_TASKS and DEBUG_ENABLED then
			taskstuff = {}
			for i,v in pairs(self.friendlytasks) do
				if not v.complete then
					table.insert(taskstuff, HERMIT_TASKS_INVERTED[i])
				end
			end
			table.sort(taskstuff)
			description = friendlevel
			alt_description = CombineLines(description, table.concat(taskstuff, ", "))
		else
			-- :(
		end
	else
		description = friendlevel
	end

	return {
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}