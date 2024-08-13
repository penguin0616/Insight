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

-- klaussackspawner.lua [Worldly]
local KLAUSSACK_TIMERNAME
local function sack_can_despawn(inst)
    if not IsSpecialEventActive(SPECIAL_EVENTS.WINTERS_FEAST) and
        inst.components.entitytracker:GetEntity("klaus") == nil and
        inst.components.entitytracker:GetEntity("key") == nil then
        return true
	end
	return false
end

local function GetKlausSackData(self)
	local despawn_day = nil
	local time_to_spawn = nil
	local sack = util.recursive_getupvalue(self.GetDebugString, "_sack")
	local save_data = self:OnSave()
	if sack and sack:IsValid() and sack.despawnday and sack_can_despawn(sack) then
		despawn_day = sack.despawnday
	else
		if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
			if KLAUSSACK_TIMERNAME == nil then
				KLAUSSACK_TIMERNAME = assert(util.recursive_getupvalue(TheWorld.components.klaussackspawner.GetDebugString, "KLAUSSACK_TIMERNAME"), "Unable to find \"KLAUSSACK_TIMERNAME\"") --"klaussack_spawntimer"
			end

			time_to_spawn = TheWorld.components.worldsettingstimer:GetTimeLeft(KLAUSSACK_TIMERNAME)
		elseif save_data.timetorespawn then
			time_to_spawn = save_data.timetorespawn
		end
	end

	return {
		despawn_day = despawn_day,
		time_to_spawn = time_to_spawn
	}
end

local function RemoteDescribe(data, context)
	local description = nil
	if not data then
		return nil
	end

	if data.despawn_day then
		description = string.format(context.lstr.klaussackspawner.klaussack_despawn, data.despawn_day)

	elseif data.time_to_spawn then
		description = string.format(context.lstr.klaussackspawner.klaussack_spawnsin, context.time:SimpleProcess(data.time_to_spawn))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Klaus_Sack.xml",
			tex = "Klaus_Sack.tex",
		},
		worldly = true,
		despawn_day = data.despawn_day,
		time_to_spawn = data.time_to_spawn,
	}
end

local function StatusAnnouncementsDescribe(special_data, context)
	local description = nil

	if special_data.despawn_day then
		description = ProcessRichTextPlainly(string.format(
			context.lstr.klaussackspawner.announce_despawn,
			special_data.despawn_day
		))
	elseif special_data.time_to_spawn then
		description = ProcessRichTextPlainly(string.format(
			context.lstr.klaussackspawner.announce_spawn,
			context.time:TryStatusAnnouncementsTime(special_data.time_to_spawn)
		))
	else
		return
	end

	return {
		description = description,
		append = true
	}
end

return {
	RemoteDescribe = RemoteDescribe,
	GetKlausSackData = GetKlausSackData,
	StatusAnnouncementsDescribe = StatusAnnouncementsDescribe,
}