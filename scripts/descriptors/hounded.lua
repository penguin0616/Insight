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

-- hounded.lua [Worldly]
local icons = {
	forest = {
		atlas = "images/Hound.xml",
		tex = "Hound.tex",
	},
	cave = {
		atlas = "images/Depths_Worm.xml",
		tex = "Depths_Worm.tex",
	},
	shipwrecked = {
		atlas = "images/Crocodog.xml",
		tex = "Crocodog.tex",
	},
}

local function Describe(self, context)
	local world_prefab = nil
	local description = nil

	local time_to_attack = nil
	local warning = nil
	
	if IS_DST then
		time_to_attack = self:GetTimeToAttack()
		world_prefab = TheWorld.worldprefab
		warning = self:GetWarning()
	else
		time_to_attack = self.timetoattack
		world_prefab = GetWorld().prefab
	end

	if time_to_attack > 0 then
		description = context.time:SimpleProcess(time_to_attack)
	else
		time_to_attack = nil
	end

	return {
		priority = 5,
		description = description,
		icon = icons[world_prefab],
		time_to_attack = time_to_attack,
		warning = warning,
		worldly = true
	}
end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.time_to_attack then
		-- Not like we can do anything...
		return
	end

	local description = nil
	local world_prefab = (IS_DST and TheWorld.worldprefab) or GetWorld().prefab
	local attack_type = (world_prefab == "forest" and context.lstr.hounded.time_until_hounds) or 
		(world_prefab == "cave" and context.lstr.hounded.time_until_worms) or 
		nil

	if not attack_type then
		return
	end

	description = string.format(
		ProcessRichTextPlainly(attack_type),
		context.time:TryStatusAnnouncementsTime(special_data.time_to_attack)
	)

	return {
		description = description,
		append = true
	}
end

local function DangerAnnouncementDescribe(special_data, context)
	if not special_data.time_to_attack then
		return
	end

	local time_string = context.time:SimpleProcess(special_data.time_to_attack, "realtime")
	
	local world_prefab = (IS_DST and TheWorld.worldprefab) or GetWorld().prefab
	local attack_type = (world_prefab == "forest" and context.lstr.hounded.time_until_hounds) or 
		(world_prefab == "cave" and context.lstr.hounded.time_until_worms) or 
		nil

	if not attack_type then
		return
	end
	
	return string.format(
		attack_type, 
		time_string
	)
end

return {
	Describe = Describe,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe,
	DangerAnnouncementDescribe = DangerAnnouncementDescribe
}