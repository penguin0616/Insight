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

-- Phase colors are eyedroppers on the medallions.
local phases_data = setmetatable({
	calm = {
		atlas = true,
		--atlas = "images/inventoryimages1.xml", -- inventoryimages1.xml but i'll let the code resolve this
		tex = "nightmare_timepiece.tex",
		color = "#897559",
		priority = 0,
	},
	warn = {
		atlas = true,
		--atlas = "images/inventoryimages1.xml",
		tex = "nightmare_timepiece_warn.tex",
		color = "#663235",
		priority = 1,
	},
	wild = {
		atlas = true,
		--atlas = "images/inventoryimages1.xml",
		tex = "nightmare_timepiece_nightmare.tex",
		color = "#CE3D45",
		priority = 2,
	},
	dawn = {
		atlas = "images/Nightmare_timepiece_dawn.xml",
		tex = "Nightmare_timepiece_dawn.tex",
		color = "#E99A68",
		priority = 0,
	}
}, {
	__index = function(self, index)
		local dummy_data = {
			atlas = nil,
			tex = nil,
			color = "#0000ff",
			priority = 0,
		}

		rawset(self, index, dummy_data)
		return rawget(self, index)
	end
})

for i,v in pairs(phases_data) do
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


local function Describe(self, context)
	local description = nil
	local control = context.config["nightmareclock_display"] 
	local hasMedallion = false

	if control == 1 then
		if context.player.components.inventory:Has("nightmare_timepiece", 1) then
			hasMedallion = true
		elseif IS_DST and context.player.components.inventory:GetOverflowContainer() and context.player.components.inventory:GetOverflowContainer():Has("nightmare_timepiece", 1) then
			hasMedallion = true
		end
	end

	if not ((control == 1 and hasMedallion) or control == 2) then
		return
	end

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
		remaining_time = context.lstr.nightmareclock.phase_locked
	else
		if IS_DST then
			remaining_time = context.time:SimpleProcess(save_data.remainingtimeinphase)
		else
			remaining_time = context.time:SimpleProcess(self:GetTimeLeftInEra())
		end
	end

	local phase_metadata = phases_data[save_data.phase]

	local phase_string = context.lstr.nightmareclock.phases[save_data.phase] or ("\"" .. save_data.phase .. "\"")
	description = string.format(context.lstr.nightmareclock.phase_info, phase_metadata.color, phase_string, remaining_time)
	

	local phase_metadata = phases_data[save_data.phase]

	return {
		priority = phase_metadata.priority or 0,
		description = description,
		icon = {
			atlas = phase_metadata.atlas or nil,
			tex = phase_metadata.tex or nil,
		},
		worldly = true,
		locked_phase = save_data.lockedphase,
		remaining_time_in_phase = save_data.remainingtimeinphase,
		phase = phase_string
	}
end

local function StatusAnnouncementsDescribe(special_data, context)
	local description

	if special_data.locked_phase then
		description = ProcessRichTextPlainly(context.lstr.nightmareclock.announce_phase_locked)
	elseif special_data.remaining_time_in_phase and special_data.phase then
		description = ProcessRichTextPlainly(string.format(
			context.lstr.nightmareclock.announce_phase,
			special_data.phase,
			context.time:TryStatusAnnouncementsTime(special_data.remaining_time_in_phase)
		))
	else
		return
	end

	return {
		description = description,
		append = true
	}
end

return {
	Describe = Describe,
	StatusAnnouncementsDescribe = StatusAnnouncementsDescribe
}