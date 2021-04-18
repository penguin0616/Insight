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

-- hounded.lua [Worldly]
local icons = {
	forest = {
		atlas = "images/Hound.xml",
		tex = "Hound.tex",
	},
	cave = {
		atlas = "images/Depths_Worm.xml",
		tex = "Depths_Worm.tex",
	},
	shipwrecked = {
		atlas = "images/Crocodog.xml",
		tex = "Crocodog.tex",
	},
}

local function Describe(self, context)
	local worldprefab = nil
	local description = nil

	local time_to_attack = nil
	
	if IsDST() then
		time_to_attack = self:GetTimeToAttack()
		worldprefab = TheWorld.worldprefab
	else
		time_to_attack = self.timetoattack
		worldprefab = GetWorld().prefab
	end

	if time_to_attack > 0 then
		description = context.time:SimpleProcess(time_to_attack)
	end

	return {
		priority = 5,
		description = description,
		icon = icons[worldprefab],
		worldly = true
	}
end



return {
	Describe = Describe
}