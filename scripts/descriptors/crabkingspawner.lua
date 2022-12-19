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

-- crabkingspawner.lua [Worldly]
local CRABKING_SPAWNTIMER = assert(util.recursive_getupvalue(_G.Prefabs.crabking_spawner.fn, "CRABKING_SPAWNTIMER"), "Unable to find \"CRABKING_SPAWNTIMER\"") --"regen_crabking"


local function GetCrabKingData(inst)
	return {
		time_to_respawn = inst and inst.components.worldsettingstimer:GetTimeLeft(CRABKING_SPAWNTIMER) or nil
	}
end

local function Describe(self, context)
	local description = nil
	local data = {}

	-- in QoL beta, self == [inst] crabking_spawner
	-- otherwise, self == [component] crabkingspawner

	if self == nil and context.crabking_data then
		data = context.crabking_data
	elseif self and context.crabking_data == nil then
		data = GetCrabKingData(TheWorld.shard.components.shard_insight.notables.crabking_spawner)
	else
		error(string.format("crabkingspawner.Describe improperly called with self=%s & crabking_data=%s", tostring(self), tostring(context.crabking_data)))
	end

	if data.time_to_respawn then
		description = context.time:SimpleProcess(data.time_to_respawn)
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Crabking.xml",
			tex = "Crabking.tex",
		},
		worldly = true,
		time_to_respawn = data.time_to_respawn
	}
end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.time_to_respawn then
		return
	end

	local description = ProcessRichTextPlainly(string.format(
		context.lstr.crabkingspawner.time_to_respawn,
		context.time:TryStatusAnnouncementsTime(special_data.time_to_respawn)
	))

	return {
		description = description,
		append = true
	}
end

return {
	Describe = Describe,
	GetCrabKingData = GetCrabKingData,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}