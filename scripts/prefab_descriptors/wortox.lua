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

-- wortox.lua [Prefab]
local world_type = GetWorldType()
local function Describe(inst, context)
	local description = nil

	if world_type ~= -1 then
		return
	end

	if not (inst.components.skilltreeupdater and inst.components.skilltreeupdater:IsActivated("wortox_panflute_playing")) then
		return
	end

	if inst:HasDebuff("wortox_panflute_buff") then
		--description = "has the buff"
		-- Wortox having the buff means we can just put that info on the debuffable.
		
	elseif inst.components.timer:TimerExists("wortox_panflute_playing") then
		local time_remaining = inst.components.timer:GetTimeLeft("wortox_panflute_playing")
		description = string.format(context.lstr.wortox.time_untl_panflute_inspiration, 
			context.time:SimpleProcess(time_remaining)
		)
		--inst.components.timer:StartTimer("wortox_panflute_playing", GetRandomWithVariance(TUNING.SKILLS.WORTOX.WORTOX_PANFLUTE_INSPIRATION_WAIT, TUNING.SKILLS.WORTOX.WORTOX_PANFLUTE_INSPIRATION_WAIT_VARIANCE))
	end

	
	return {
		priority = 0,
		description = description,
		prefably = true,
		playerly = true,
		icon = ResolvePrefabToImageTable("panflute"),
	}
end



return {
	Describe = Describe
}