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

-- wagpunk_manager.lua
local function GetDebugString(self)
	return string.format(
        "State: %s || Updating: %s\nNext Spawn: %s || Next Hint: %s\nHint Count: %d/%d || Num Machines: %d/%d",
        self._enabled  and "ON" or "OFF",
        self._updating and "ON" or "OFF",
        self.nextspawntime ~= nil and string.format("%.2f", self.nextspawntime) or "???",
        self.nexthinttime ~= nil  and string.format("%.2f", self.nexthinttime)  or "???",
        self.hintcount,
        MAX_NUM_HINTS or 10,
        self:MachineCount(),
        NUM_MACHINES_PER_SPAWN or 3
    )
end

local function Describe(self, context)
	local description = context.etc.DEBUG_ENABLED and GetDebugString(self) or nil

	return {
		priority = 0,
		description = description
	}
end



return {
	--Describe = Describe
}