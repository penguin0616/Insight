--[[
Copyright (C) 2020 penguin0616

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

-- repairable.lua
local function Describe(self, context)
	local description, alt_description

	if not (context.config["repair_values"] > 0) then
		return
	end

	local workable = self.inst.components.workable

	if workable == nil then -- don't care about health too?
		return
	end

	if self.inst:HasTag("chess") then
		-- ok
		description = string.format(context.lstr.repairable.chess, 6 - workable.workleft)
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