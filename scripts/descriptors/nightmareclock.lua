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

-- nightmareclock.lua [Worldly]
-- nightmare_timepiece_warn.tex
-- nightmare_timepiece.tex
-- nightmare_timepiece_nightmare.tex

--[[
local PHASE_NAMES =
{
    "calm",
    "warn",
    "wild",
    "dawn",
}
--]]

local icons = {
	calm = {
		atlas = true,
		--atlas = "images/inventoryimages1.xml", -- inventoryimages1.xml but i'll let the code resolve this
		tex = "nightmare_timepiece.tex",
	},
	warn = {
		atlas = true,
		--atlas = "images/inventoryimages1.xml",
		tex = "nightmare_timepiece_warn.tex",
	},
	nightmare = {
		atlas = true,
		--atlas = "images/inventoryimages1.xml",
		tex = "nightmare_timepiece_nightmare.tex",
	},
	dawn = {
		atlas = "images/Nightmare_timepiece_dawn.xml",
		tex = "Nightmare_timepiece_dawn.tex",
	}
}

for i,v in pairs(icons) do
	if v.atlas == true then
		local r = ResolvePrefabToImageTable(v.tex:match("([%s%S]+).tex"))
		if r.atlas then
			v.atlas = r.atlas
		else
			error("Unable to find icon origin for nightmareclock: " .. i)
			v.tex = nil
			v.atlas = nil
		end
	end
end

local colors = setmetatable({ -- paint.net eyedropper on the medallions
	calm = "#897559",
	warn = "#663235",
	nightmare = "#CE3D45",
	dawn = "#E99A68",
}, {
	__index = function(self, index)
		rawset(self, index, "#0000ff")
		return rawget(self, index)
	end
})

local function Describe(self, context)
	local description = nil
	local control = context.config["nightmareclock_display"] 
	local hasMedallion = false
	local icon = nil

	if context.player.components.inventory:Has("nightmare_timepiece", 1) then
		hasMedallion = true
	elseif IsDST() and context.player.components.inventory:GetOverflowContainer() and context.player.components.inventory:GetOverflowContainer():Has("nightmare_timepiece", 1) then
		hasMedallion = true
	end

	if (control == 1 and hasMedallion) or (control == 2) then
		local save_data = self:OnSave() --[[ {
			lengths = {},
			phase = PHASE_NAMES[_phase:value()],
			totaltimeinphase = _totaltimeinphase:value(),
			remainingtimeinphase = _remainingtimeinphase:value(),
			lockedphase = _lockedphase ~= nil and PHASE_NAMES[_lockedphase] or nil,
		}
		]]

		--dprint(save_data.phase, "|", save_data.totaltimeinphase, "|", save_data.remainingtimeinphase)

		local remaining_time

		if save_data.lockedphase then -- DST only
			-- it has been locked with an ancient key
			remaining_time = context.lstr.nightmareclock_lock
		else
			if IsDST() then
				remaining_time = context.time:SimpleProcess(save_data.remainingtimeinphase)
			else
				remaining_time = context.time:SimpleProcess(self:GetTimeLeftInEra())
			end
		end

		local phase = save_data.phase == "wild" and "nightmare" or save_data.phase

		description = string.format(context.lstr.nightmareclock, colors[phase], phase:sub(1,1):upper() .. phase:sub(2):lower(), remaining_time)
		icon = icons[phase]
	end

	return {
		priority = 0,
		description = description,
		icon = icon,
		worldly = true,
	}
end



return {
	Describe = Describe
}