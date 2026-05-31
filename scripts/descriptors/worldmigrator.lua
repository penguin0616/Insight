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

-- worldmigrator.lua
local colors = {}

for i,v in pairs(FOREST_MIGRATOR_IMAGES) do
	colors[i] = v[2]:ToHex()
end

local function Describe(self, context)
	if not context.config["display_worldmigrator"] then
		return
	end
	
	local description = nil

	-- self.id = int, migrator #
   	-- self.linkedWorld = int, destination shardid (Shard_GetConnectedShards())
	-- self.receivedPortal = int, migrator on shard that brings to here
	
	if not self.enabled then
		description = context.lstr.worldmigrator.disabled -- if rocks are blocking it
	else
		local clr = colors[self.receivedPortal] or "#ffffff"

		local target = string.format(context.lstr.worldmigrator.target_shard, ApplyColor(self.linkedWorld or "", clr))
		local received = string.format(context.lstr.worldmigrator.received_portal, ApplyColor(self.receivedPortal or "", clr))
		local id = string.format(context.lstr.worldmigrator.id, ApplyColor(self.id or "", clr))
		--Shard Migrator: %s, This #: %s", self.linkedWorld or "", self.receivedPortal or "", self.id or "")

		description = target .. ", " .. received .. ", " .. id
	end

	return {
		priority = 100,
		description = description,
		linkedWorld = self.linkedWorld,
		receivedPortal = self.receivedPortal,
		id = self.id
	}
end



return {
	Describe = Describe
}