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

local THRALL_NAMES = setmetatable({
	shadowthrall_hands = "<color=MOB_SPAWN><string=NAMES.SHADOWTHRALL_HANDS_ALLEGIANCE></color>", --STRINGS.NAMES.SHADOWTHRALL_HANDS_ALLEGIANCE,
	shadowthrall_horns = "<color=MOB_SPAWN><string=NAMES.SHADOWTHRALL_HORNS_ALLEGIANCE></color>", --STRINGS.NAMES.SHADOWTHRALL_HORNS_ALLEGIANCE,
	shadowthrall_wings = "<color=MOB_SPAWN><string=NAMES.SHADOWTHRALL_WINGS_ALLEGIANCE></color>", --STRINGS.NAMES.SHADOWTHRALL_WINGS_ALLEGIANCE,
	shadowthrall_mouth = "<color=MOB_SPAWN><string=NAMES.SHADOWTHRALL_MOUTH_ALLEGIANCE></color>", --STRINGS.NAMES.SHADOWTHRALL_MOUTH_ALLEGIANCE,
}, {
	__index = function(self, index)
		rawset(self, index, "???")
		return rawget(self, index)
	end
})

local function Describe(self, context)
	local description = nil

	local verbosity = context.config["display_shadowthrall_information"]
	if verbosity == 0 then
		return
	end

	local thrall_string
	local fissure_string
	
	local data = self:OnSave()
	local fissure = self:GetControlledFissure()

	local priority = 0

	-- Check if we have an existing fissure (and thralls)
	if fissure then
		local thralls_alive = {}
		local thralls_alive_string = {}  -- Gets turned into a string before it gets read by anything.
		
		-- Despite the saved names being of the original trio,
		-- Klei will override their specific prefabs with the 'mouth' thralls.

		-- These are GUIDs
		if data.thrall_hands ~= nil then
			local ent = Ents[data.thrall_hands]
			thralls_alive[#thralls_alive+1] = ent
			if ent then
				thralls_alive_string[#thralls_alive_string+1] = THRALL_NAMES[ent.prefab]
			end
		end
		if data.thrall_horns ~= nil then
			local ent = Ents[data.thrall_horns]
			thralls_alive[#thralls_alive+1] = ent
			if ent then
				thralls_alive_string[#thralls_alive_string+1] = THRALL_NAMES[ent.prefab]
			end
		end
		if data.thrall_wings ~= nil then
			local ent = Ents[data.thrall_wings]
			thralls_alive[#thralls_alive+1] = ent
			if ent then
				thralls_alive_string[#thralls_alive_string+1] = THRALL_NAMES[ent.prefab]
			end
		end

		thralls_alive_string = table.concat(thralls_alive_string, ", ")

		--if self.thralltype == THRALL_TYPES.SHADOW.TRIO then
			
		--ThePlayer:HasTag("player_shadow_aligned")

		-- A fissure can be taken over "near" the player but the ink blights won't spawn if a player isn't close enough.
		if #thralls_alive == 0 and data.spawnthrallstime then
			thrall_string = context.lstr.shadowthrallmanager.waiting_for_players
		else
			if verbosity == 1 and not context.player:HasTag("player_shadow_aligned") then
				-- We will only show the counts if the verbosity is 1 and the player isn't shadow aligned.
				thrall_string = string.format(context.lstr.shadowthrallmanager.thrall_count, #thralls_alive)
			else
				thrall_string = string.format(context.lstr.shadowthrallmanager.thralls_alive, #thralls_alive, thralls_alive_string)
			end
		end

		if data.dreadstonecooldown then
			fissure_string = string.format(context.lstr.shadowthrallmanager.dreadstone_regen, context.time:SimpleProcess(data.dreadstonecooldown))
		end

		priority = 10
		
	elseif data.cooldown then
		fissure_string = string.format(context.lstr.shadowthrallmanager.fissure_cooldown, context.time:SimpleProcess(data.cooldown))
		priority = 1
	else
		--fissure_string = context.lstr.shadowthrallmanager.fissure_ready
	end

	description = CombineLines(thrall_string, fissure_string)

	return {
		priority = priority,
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