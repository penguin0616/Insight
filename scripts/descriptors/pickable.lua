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

-- pickable.lua
local wsth = import("helpers/worldsettingstimer")

local function Describe(self, context)
	if not context.config["display_pickable"] then
		return
	end
	
	local description = nil
	local remaining_harvests = nil

	local remaining_time

	if self.useexternaltimer then
		remaining_time = self.inst.components.worldsettingstimer and self.inst.components.worldsettingstimer:GetTimeLeft(wsth.PICKABLE_REGENTIME_TIMERNAME)
	else
		remaining_time = self.targettime and (self.targettime - GetTime()) or nil
	end

	if remaining_time then 
		if not self.paused and remaining_time > 0 then
			remaining_time = context.time:SimpleProcess(remaining_time)

			if context.usingIcons and self.product and PrefabHasIcon(self.product) then
				description = string.format(context.lstr.pickable.regrowth, self.product, remaining_time)
			else
				description = string.format(context.lstr.lang.pickable.regrowth, remaining_time)
			end

		elseif self.paused then
			description = string.format(context.lstr.pickable.regrowth_paused)
		end
	end

	if self.cycles_left and self.max_cycles and self.transplanted then -- self.transplanted needed for DS
		remaining_harvests = string.format(context.lstr.pickable.cycles, self.cycles_left, self.max_cycles)
	end

	-- Mushroom logic
	if self.inst.prefab:sub(-9) == "_mushroom" and type(self.inst.data) == "table" and self.inst.data.name and type(self.inst.rain) == "number" then
		-- Probably a mushroom.
		if not self.canbepicked then
			-- Needs regrowth!
			description = string.format(context.lstr.pickable.mushroom_rain, self.inst.rain)
		end
	end

	description = CombineLines(description, remaining_harvests)

	return {
		priority = 1,
		description = description
	}
end



return {
	Describe = Describe
}