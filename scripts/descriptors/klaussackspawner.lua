--[[
Copyright (C) 2020 penguin0616

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
	local sack = util.getupvalue(self.GetDebugString, "_sack")
	local save_data = self:OnSave()

	if sack and sack.despawnday and sack_can_despawn(sack) then
		despawn_day = sack.despawnday
	elseif save_data.timetorespawn then
		time_to_spawn = save_data.timetorespawn
	end

	return {
		despawn_day = despawn_day,
		time_to_spawn = time_to_spawn
	}
end

local function Describe(self, context)
	local description = nil
	local data = {}

	if self == nil and context.klaussack_data then
		data = context.klaussack_data
	elseif self and context.klaussack_data == nil then
		data = GetKlausSackData(self)
	else
		error(string.format("klaussackspawner.Describe improperly called with self=%s & klaussack_data=%s", tostring(self), tostring(context.klaussack_data)))
	end

	if data.despawn_day then
		description = string.format(context.lstr.klaussack_despawn, data.despawn_day)

	elseif data.time_to_spawn then
		description = string.format(context.lstr.klaussack_spawnsin, TimeToText(time.new(data.time_to_spawn, context)))
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Klaus_Sack.xml",
			tex = "Klaus_Sack.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe,
	GetKlausSackData = GetKlausSackData
}