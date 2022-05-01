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

-- wx78.lua [Prefab]
local wx78_refresh = IsDST() and CurrentRelease.GreaterOrEqualTo("R21_REFRESH_WX78")
local CHARGEREGEN_TIMERNAME = "chargeregenupdate"

local function Describe(inst, context)
	local description = nil
	local time_to_gain_charge

	if not wx78_refresh and inst.charge_time and inst.charge_time > 0 then -- inspectable manually added in DS
		description = string.format(context.lstr.wx78_charge, context.time:SimpleProcess(inst.charge_time))
	end

	if wx78_refresh then
		local time_left = inst.components.timer and inst.components.timer:GetTimeLeft(CHARGEREGEN_TIMERNAME)
		if inst.components.upgrademoduleowner and time_left and time_left > 0 then
			description = string.format(context.lstr.wx78.gain_charge_time, context.time:SimpleProcess(time_left))
			time_to_gain_charge = time_left
		end
	end

	return {
		priority = 1,
		description = description,
		icon = {
			tex = "ladybolt.tex",
			atlas = "images/ladybolt.xml"
		},
		playerly = true,
		time_to_gain_charge = time_to_gain_charge
	}
end



return {
	Describe = Describe
}
