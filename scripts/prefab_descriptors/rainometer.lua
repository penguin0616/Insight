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

-- rainometer.lua [Prefab]
local function Describe(inst, context)
	local description = nil

	local wetness = nil
	local precipitation_rate = nil
	local frog_rain_chance = nil

	if IS_DST then
		wetness = string.format(context.lstr.global_wetness, Round(TheWorld.state.wetness, 1))
		
		if TheWorld.state.precipitationrate > 0 then
			precipitation_rate = string.format(context.lstr.precipitation_rate, Round(TheWorld.state.precipitationrate, 2))
		end

		local frog_rain = TheWorld.components.frograin
		if frog_rain and TheWorld.state.isspring then
			if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
				frog_rain_chance = string.format(context.lstr.frog_rain_chance, Round(TUNING.FROG_RAIN_CHANCE * 100, 1))
			else
				frog_rain_chance = string.format(context.lstr.frog_rain_chance, Round(frog_rain:OnSave().chance * 100, 1))
			end
		end
	end

	description = CombineLines(wetness, precipitation_rate, frog_rain_chance)
	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}