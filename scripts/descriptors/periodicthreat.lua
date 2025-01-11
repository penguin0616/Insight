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

-- periodicthreat.lua [Worldly]
local world_type = GetWorldType()

local function CalculateThreatPriority(time_to_threat, metadata)
	if not time_to_threat or type(time_to_threat) ~= "number" then
		return 0
	end

	metadata = metadata or {}

	-- { ignore_different_shard=true, shard_data=data.shard_data }
	if metadata.ignore_different_shard and metadata.shard_data then
		if metadata.shard_data.shard_id ~= TheShard:GetShardId() then
			return 0
		end
	end
	
	if time_to_threat <= TUNING.TOTAL_DAY_TIME then
		return 5
	end
	
	return 0
end

local function Describe(self, context)
	-- DS only

	if world_type < 0 then
		return
	end

	local inst = self.inst
	local description = nil

	local wormthreat = self.threats["WORM"]

	--[[
	for name, data in pairs(self.threats) do
		mprint(name, data.timer, data.state, data.state_variables.statetimer)
	end
	--]]

	--dprint(wormthreat.timer, wormthreat.state, wormthreat.state_variables.statetimer)

	if not wormthreat then
		-- Some Hero in the Dark probably removes this or something
		return
	end
	
	if wormthreat.state == "wait" then
		description = string.format(context.lstr.worms_incoming, context.time:SimpleProcess(wormthreat.timer))
	elseif wormthreat.state == "warn" then
		description = string.format(context.lstr.worms_incoming_danger, context.time:SimpleProcess(wormthreat.timer))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Depths_Worm.xml",
			tex = "Depths_Worm.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe,
	CalculateThreatPriority = CalculateThreatPriority,
}