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
local CRABKING_SPAWNTIMER = CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") and assert(util.getupvalue(_G.Prefabs.crabking_spawner.fn, "CRABKING_SPAWNTIMER"), "Unable to find \"CRABKING_SPAWNTIMER\"") --"regen_crabking"


local function GetCrabKingData(self)
	if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
		if type(self) == "table" and self.inst == TheWorld then -- for modmain
			self = TheWorld.shard.components.shard_insight.notables.crabking_spawner
		end

		return {
			time_to_respawn = self.components.worldsettingstimer:GetTimeLeft(CRABKING_SPAWNTIMER)
		}
	end

	return {
		time_to_respawn = self:OnSave().timetorespawn
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
		data = GetCrabKingData(self)
	else
		error(string.format("crabkingspawner.Describe improperly called with self=%s & crabking_data=%s", tostring(self), tostring(context.crabking_data)))
	end

	if data.time_to_respawn then
		description = string.format(context.lstr.crabking_spawnsin, TimeToText(time.new(data.time_to_respawn, context)))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Crabking.xml",
			tex = "Crabking.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe,
	GetCrabKingData = GetCrabKingData
}