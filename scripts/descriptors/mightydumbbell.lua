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

-- mightydumbbell.lua
local function GetEfficiency(self, player)
	-- because the dumbbell automatically sets your meter arrow.
	local mightiness = player.components.mightiness
	local efficiency = self.efficiency_mighty
			
	if mightiness.current < TUNING.WIMPY_THRESHOLD then
		efficiency = self.efficiency_wimpy
	elseif mightiness.current < TUNING.MIGHTY_THRESHOLD then
		efficiency = self.efficiency_normal
	end

	return efficiency
end

local function Describe(self, context)
	local description, alt_description = nil, nil

	if not context.player.components.mightiness then
		return
	end

	-- right now attack efficiency and lifting efficiency are the exact same
	local efficiency = GetEfficiency(self, context.player)
	local state = context.player.components.mightiness:GetState()
	local gains_string = context.lstr.mightydumbbell.mightness_per_use .. string.format("<color=MIGHTINESS>%+.1f</color>", efficiency) 
	
	-- colors based on state
	local w, n, m = (state == "wimpy" and "MIGHTINESS") or "#ffffff", (state == "normal" and "MIGHTINESS") or "#ffffff", (state == "mighty" and "MIGHTINESS") or "#ffffff"
	local gains_string_verbose = context.lstr.mightydumbbell.mightness_per_use .. string.format("<color=%s>%+.1f</color> / <color=%s>%+.1f</color> / <color=%s>%+.1f</color>", 
		w, self.efficiency_wimpy,
		n, self.efficiency_normal,
		m, self.efficiency_mighty
	)

	description = gains_string
	alt_description = gains_string_verbose

	return {
		priority = 0,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}