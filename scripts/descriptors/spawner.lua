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

-- spawner.lua
local function Describe(self, context)
	if not context.config["spawner_information"] then
		return
	end
	
	local inst = self.inst
	local description, alt_description

	if self.nextspawntime then
		description = string.format(context.lstr.spawner_next, STRINGS.NAMES[self.childname:upper()] or ("\"" .. self.childname .."\""), TimeToText(time.new(self.nextspawntime - GetTime(), context)))
	else
		alt_description = string.format(context.lstr.spawner_child, STRINGS.NAMES[self.childname:upper()] or ("\"" .. self.childname .."\""))
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