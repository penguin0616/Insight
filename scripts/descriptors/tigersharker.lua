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

-- tigershark.lua [Worldly]
local function Describe(self, context)
	-- SW only
	local description = nil

	local appear_time = self:TimeUntilCanAppear()
	local respawn_time = self:TimeUntilRespawn()

	--dprint("appear:", self:TimeUntilCanAppear(), "respawn:", self:TimeUntilRespawn(), "shark:", self.shark)

	if self.shark then
		description = context.lstr.tigershark_exists
	elseif self:CanSpawn(true, true) then
		-- something has to trigger a spawn
		if appear_time > 0 or respawn_time > 0 then 
			local max = math.max(appear_time, respawn_time)
			description = string.format(context.lstr.tigershark_spawnin, context.time:SimpleProcess(max))
		else
			description = context.lstr.tigershark_waiting
		end
	else
		description = string.format("?No Spawn Possible?")
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Tigershark.xml",
			tex = "Tigershark.tex"
		},
		worldly = true
	}
end



return {
	Describe = Describe
}