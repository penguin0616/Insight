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

-- shadowthrall_mimics.lua
local _scheduled_spawn_attempts
local _activemimics
local function OnServerInit()
	target_fn = TheWorld.components.shadowthrall_mimics.Debug_PlayerSpawns
	if target_fn then
		_scheduled_spawn_attempts = util.recursive_getupvalue(target_fn, "_scheduled_spawn_attempts")
	else
		mprint("Unable to find TheWorld.components.shadowthrall_mimics.Debug_PlayerSpawns")
	end

	target_fn = TheWorld.components.shadowthrall_mimics.GetDebugString
	if target_fn then
		_activemimics = util.recursive_getupvalue(target_fn, "_activemimics")
	else
		mprint("Unable to find TheWorld.components.shadowthrall_mimics.Debug_PlayerSpawns")
	end
end

local function Describe(self, context)
	local description = nil

	if not _scheduled_spawn_attempts or not _activemimics then
		return
	end
	
	if context.config["display_itemmimic_information"] < 1 then
		return
	end

	description = string.format(context.lstr.shadowthrall_mimics.mimic_count, GetTableSize(_activemimics), TUNING.ITEMMIMIC_CAP)

	--description = self:GetDebugString() .. "\nnight: " .. tostring(self.inst.state.iscavenight)

	local yes = {}

	for player, task in pairs(_scheduled_spawn_attempts) do
		yes[#yes+1] = {
			name = "shadowthrall_mimics.spawning." .. player.userid,
			priority = 0,
			worldly = true,
			playerly = true,
			icon = {
				atlas = "images/Mimicreep.xml",
				tex = "Mimicreep.tex",
			},
			description = tostring(GetTaskRemaining(task))
		}
	end


	return {
		name = "shadowthrall_mimics",
		priority = 0,
		worldly = true,
		icon = {
			atlas = "images/Mimicreep.xml",
			tex = "Mimicreep.tex",
		},
		description = description,
	}, unpack(yes)
end



return {
	OnServerInit = OnServerInit,

	Describe = Describe,
}