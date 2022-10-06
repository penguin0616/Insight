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

-- quaker.lua [Worldly]
local QUAKESTATE = nil --[[
	{
		WAITING = 0,
		WARNING = 1,
		QUAKING = 2,
	}

]]

local function Describe(self, context)
	local description = nil

	if IS_DST and not QUAKESTATE then
		--dprint("loading QUAKESTATE")
		QUAKESTATE = util.getupvalue(self.OnLoad, "QUAKESTATE")
		assert(QUAKESTATE, "[Insight]: Failed to load quaker.lua's QUAKESTATE")
	end

	local save_data = self:OnSave()
	local next_quake = nil

	if IS_DST and save_data.state == QUAKESTATE.WAITING then
		--dprint("quake state valid")
		--print(save_data.time)
		--description = string.format(context.lstr.next_quake, context.time:SimpleProcess(save_data.time))
		next_quake = save_data.time
	elseif IS_DS and save_data and save_data.nextquake then
		next_quake = save_data.nextquake
	end

	if next_quake then
		description = string.format(context.lstr.quaker.next_quake, context.time:SimpleProcess(next_quake))
	end

	--local _, tex, atlas = PrefabHasIcon("rocks") -- cant think of a reason this wouldnt exist
	local icon = ResolvePrefabToImageTable("rocks")

	return {
		priority = 0,
		description = description,
		icon = icon,
		worldly = true,
		next_quake = next_quake
	}
end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.next_quake then
		return
	end

	local description = string.format(
		ProcessRichTextPlainly(context.lstr.quaker.next_quake),
		context.time:TryStatusAnnouncementsTime(special_data.next_quake)
	)

	return {
		description = description,
		append = true
	}
end

return {
	Describe = Describe,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}