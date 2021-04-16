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

-- winch.lua
local CLAW_CATCHING_RADIUS = 2.5
local CLAW_CATCH_MUST_TAGS = {"winchtarget"}

local function Describe(self, context)
	local description = nil

	if self.inst.prefab ~= "winch" then
		if DEBUG_ENABLED then
			description = context.lstr.winch.not_winch
		end
	else
		local salvageable = FindEntity(self.inst, CLAW_CATCHING_RADIUS, nil, CLAW_CATCH_MUST_TAGS, nil)
		if salvageable then
			if salvageable.components.winchtarget and salvageable.components.winchtarget:GetSunkenObject() then
				salvageable = salvageable.components.winchtarget:GetSunkenObject()
			end
			
			description = string.format(context.lstr.winch.sunken_item, GetPrefabNameOrElse(salvageable.prefab, "\"%s\""))
		end
	end



	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}