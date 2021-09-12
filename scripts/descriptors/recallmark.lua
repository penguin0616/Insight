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

-- recallmark.lua

local ShardConnected = util.getupvalue(Shard_UpdateWorldState, "ShardConnected")

local shard_locations = {}
setmetatable(shard_locations, {
	__index = function(self, index)
		-- check insight shard connections
		if index == Insight.selected_forest_shard then
			rawset(self, index, "forest")
			return rawget(self, index)
		elseif index == Insight.selected_cave_shard then
			rawset(self, index, "cave")
			return rawget(self, index)
		end

		-- check self
		if index == TheShard:GetShardId() then
			rawset(self, index, TheWorld.worldprefab)
			return rawget(self, index)
		end

		-- check connected shards (master shard has no associated information it seems)
		for shard_id, data in pairs(Shard_GetConnectedShards()) do
			if shard_id == index and data.world and data.world[1] and data.world[1].location then
				rawset(self, index, data.world[1].location)
				return rawget(self, index)
			end
		end

		--rawset(self, index, "?")
		--return rawget(self, index)
	end
})

local function Describe(self, context)
	local description, alt_description = nil, nil

	if not self.recall_worldid then return end
	--local shard_id = string.format(context.lstr.recallmark.shard_id, self.recall_worldid)
	local location = shard_locations[self.recall_worldid] or "?"
	local shard_type = string.format(context.lstr.recallmark.shard_type, location:sub(1, 1):upper() .. location:sub(2):lower())

	description = CombineLines(shard_id, shard_type)

	return {
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}