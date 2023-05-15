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

-- atrium_gate.lua [Prefab]
local R15_QOL_WORLDSETTINGS = CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS")

local function GetRemainingCooldown(inst)
	local atriumgate_timer
	-- destabilizing = time before reset
	-- cooldown = time before can resocket the key
	-- destabilizedelay = time before can pulse on rejoin
	if R15_QOL_WORLDSETTINGS then
		atriumgate_timer = inst.components.worldsettingstimer:GetTimeLeft("cooldown")
	else
		atriumgate_timer = inst.components.timer:GetTimeLeft("cooldown")
	end
	return atriumgate_timer
end

local function RemoteDescribe(data, context)
	local atrium_gate_cooldown = data or -1
	if atrium_gate_cooldown >= 0 then
		local description = context.time:SimpleProcess(atrium_gate_cooldown)
		return {
			description = description,
			icon = {
				atlas = "images/Atrium_Gate.xml",
				tex = "Atrium_Gate.tex"
			},
			worldly = true, -- meeeh
			prefably = true,
			from = "prefab",
			cooldown = atrium_gate_cooldown,
		}
	end
	return nil
end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.cooldown then
		-- Not like we can do anything...
		return
	end

	local description = string.format(
		ProcessRichTextPlainly(context.lstr.atrium_gate.cooldown),
		context.time:TryStatusAnnouncementsTime(special_data.cooldown)
	)

	return {
		description = description,
		append = true
	}
end

return {
	GetRemainingCooldown = GetRemainingCooldown,

	RemoteDescribe = RemoteDescribe,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}
