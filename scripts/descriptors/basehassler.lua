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


-- basehassler.lua [Worldly]
local icons = {
	deerclops = {
		atlas = "images/Deerclops.xml",
		tex = "Deerclops.tex"
	},
	bearger = {
		atlas = "images/Bearger.xml",
		tex = "Bearger.tex"
	},
	dragonfly = {
		atlas = "images/Dragonfly.xml",
		tex = "Dragonfly.tex"
	},
	moose = {
		atlas = "images/Moose.xml",
		tex = "Moose.tex",
	},
	twister = {
		atlas = "images/Twister.xml",
		tex = "Twister.tex",
	}
}

local function Describe(self, context)
	-- does not exist in dst
	local description = nil
	local hasslers = {}

	if GetWorldType() == 0 then
		local time_to_attack = self.timetoattack

		if time_to_attack then
			--table.insert(hasslers, {name = "deerclops", text = TimeToText(time.new(time_to_attack, context)), icon=icons.deerclops})
			table.insert(hasslers, {
				priority = 0,
				description = TimeToText(time.new(time_to_attack, context)),
				icon = icons.deerclops,
				worldly = true,
			})
		end
	else
		local season = GetWorld().components.seasonmanager:GetSeason()
		
		for name, data in pairs(self.hasslers or {}) do -- someone had hasslers = nil, 12/8/2020
			--if GetWorldType() == 3 then dprint(name, data.HASSLER_STATE, data.timer) end
			if data.HASSLER_STATE ~= "DORMANT" and (data.activeseason == season or data.attackduringoffseason) then
				--table.insert(hasslers, {name = data.prefab, text = TimeToText(time.new(data.timer, context)), icon=icons[data.prefab]})
				local str = data.HASSLER_STATE == "WARNING" and "<color=HEALTH>%s</color>" or "%s"
				table.insert(hasslers, {
					priority = 0,
					description = string.format(str, TimeToText(time.new(data.timer, context))),
					icon = icons[data.prefab],
					worldly = true,
					name = "basehassler_" .. data.prefab
				})
			end
		end

		
	end

	if #hasslers > 0 then
		return unpack(hasslers)
	else
		return {
			priority = 0,
			description = description,
			worldly = true
		}
	end
end




return {
	Describe = Describe
}