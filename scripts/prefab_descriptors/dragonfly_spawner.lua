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

-- dragonfly_spawner.lua [Prefab]
-- Technically yeah, this isn't networked to clients, but whatever.
local R15_QOL_WORLDSETTINGS = CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS")

--local DRAGONFLY_SPAWNTIMER = R15_QOL_WORLDSETTINGS and assert(util.recursive_getupvalue(_G.Prefabs.dragonfly_spawner.fn, "DRAGONFLY_SPAWNTIMER"), "Unable to find \"DRAGONFLY_SPAWNTIMER\"") --"regen_dragonfly"


local function GetRespawnTime(inst)
	local dragonfly_spawner_timer = nil

	if R15_QOL_WORLDSETTINGS then
		dragonfly_spawner_timer = inst.components.worldsettingstimer:GetTimeLeft("regen_dragonfly")
	else
		dragonfly_spawner_timer = inst.components.timer:GetTimeLeft("regen_dragonfly")
	end

	return dragonfly_spawner_timer
end

local function RemoteDescribe(data, context)
	local dragonfly_respawn = data or -1
	if dragonfly_respawn >= 0 then
		local description = context.time:SimpleProcess(dragonfly_respawn)
		return {
			description = description,
			icon = {
				atlas = "images/Dragonfly.xml",
				tex = "Dragonfly.tex",
			},
			worldly = true, -- meeeh
			prefably = true,
			from = "prefab",
			time_to_respawn = dragonfly_respawn,
		}
	end
	return nil
end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.time_to_respawn then
		return
	end

	local description = string.format(
		ProcessRichTextPlainly(context.lstr.dragonfly_spawner.time_to_respawn),
		context.time:TryStatusAnnouncementsTime(special_data.time_to_respawn)
	)

	return {
		description = description,
		append = true
	}
end

return {
	GetRespawnTime = GetRespawnTime,

	RemoteDescribe = RemoteDescribe,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}
