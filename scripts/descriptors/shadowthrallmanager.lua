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

-- shadowthrallmanager.lua

-- Has a cooldown that when finished, polls the fissures for a nearby player to do all the cool stuff to.

-- Dread CD: %.1f 		cooldown of dreadstone in the fissure
-- Spawn CD: %.1f		fissure mutation cd

local function Describe(self, context)
	local description = nil

	local thrall_string
	local fissure_string
	
	local data = self:OnSave()
	local fissure = self:GetControlledFissure()

	-- Check if we have an existing fissure (and thralls)
	if fissure then
		local thrall_count = 0
		
		-- These are GUIDs
		if data.thrall_hands ~= nil then
			thrall_count = thrall_count + 1
		end
		if data.thrall_horns ~= nil then
			thrall_count = thrall_count + 1
		end
		if data.thrall_wings ~= nil then
			thrall_count = thrall_count + 1
		end

		-- A fissure can be taken over "near" the player but the ink blights won't spawn if a player isn't close enough.
		if thrall_count == 0 and data.spawnthrallstime then
			thrall_string = context.lstr.shadowthrallmanager.waiting_for_players
		else
			thrall_string = string.format(context.lstr.shadowthrallmanager.thrall_count, thrall_count)
		end

		if data.dreadstonecooldown then
			fissure_string = string.format(context.lstr.shadowthrallmanager.dreadstone_regen, context.time:SimpleProcess(data.dreadstonecooldown))
		end
		
	elseif data.cooldown then
		fissure_string = string.format(context.lstr.shadowthrallmanager.fissure_cooldown, context.time:SimpleProcess(data.cooldown))
	else
		--fissure_string = context.lstr.shadowthrallmanager.fissure_ready
	end

	description = CombineLines(thrall_string, fissure_string)

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Dreadstone_Outcrop.xml",
			tex = "Dreadstone_Outcrop.tex",
		},
		worldly = true,
	}
end



return {
	Describe = Describe
}