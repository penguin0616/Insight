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

-- lunarthrall_plant.lua [Prefab]
local DANGER = Color.fromRGB(255, 0, 0)
local SAFE = Color.fromRGB(0, 255, 0)

local function Describe(inst, context)
	local description = nil

	if not context.complex_config["unique_info_prefabs"]["lunarthrall_plant"] then
		return
	end

	-- Rest task is "part 1" of the vulnerability phase where nothing happens
	-- Wake task is "part 2" where plant starts shaking(t)

	local attack_window

	if inst.waketask then
		attack_window = GetTaskRemaining(inst.waketask)
	elseif inst.resttask then
		attack_window = GetTaskRemaining(inst.resttask) + TUNING.LUNARTHRALL_PLANT_WAKE_TIME
	end

	local maximum_attack_window = (TUNING.LUNARTHRALL_PLANT_REST_TIME + 1) + TUNING.LUNARTHRALL_PLANT_WAKE_TIME

	if attack_window then
		local color = DANGER:Lerp(SAFE, attack_window / maximum_attack_window):ToHex()
		description = string.format(context.lstr.lunarthrall_plant.time_to_aggro, color, attack_window)
	end
	
	return {
		priority = 0,
		description = description,
		prefably = true
	}
end



return {
	Describe = Describe
}