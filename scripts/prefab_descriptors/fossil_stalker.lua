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

-- fossil_stalker.lua [Prefab]
local ATRIUM_RANGE = 8.5 
local ATRIUM_RANGE_SQ = ATRIUM_RANGE * ATRIUM_RANGE -- 72.25 sq, geometric placement leaves us at the exact distance
local STARGET_TAGS = { "stargate" }
--local STALKER_TAGS = { "stalker" }

local function ActiveStargate(gate)
	return gate:IsWaitingForStalker()
end

local function Describe(inst, context)
	local description = nil

	-- correctly assembled?
	local build_string = nil
	local needed_pieces = 5 - inst.moundsize
	if needed_pieces > 0 then
		build_string = string.format(context.lstr.fossil_stalker.pieces_needed, needed_pieces)
	else
		if inst.form == 1 then
			build_string = context.lstr.fossil_stalker.correct
		else
			build_string = context.lstr.fossil_stalker.incorrect
		end
	end

	-- close enough to ancient gateway?
	local atrium_string = nil
	local stargate = TheWorld.shard.components.shard_insight.notables.atrium_gate
	if stargate and context.player.components.areaaware:CurrentlyInTag("Atrium") then
		local distance = inst:GetDistanceSqToInst(stargate)
		-- 1 geo stud is 3 to 0.5
		if distance <= ATRIUM_RANGE_SQ then
			-- close
			--atrium_string = string.format("Dis: %s %s %s", distance, math.sqrt(distance), math.sqrt(distance / 4))
		else
			-- far
			atrium_string = string.format(context.lstr.fossil_stalker.gateway_too_far, Round(math.sqrt(distance / 4), 1))
		end
	end

	description = CombineLines(build_string, atrium_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}