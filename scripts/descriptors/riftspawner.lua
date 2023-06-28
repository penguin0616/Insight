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

-- riftspawner.lua
--------------------------------------------------------------------------
--[[ Constants ]]
--------------------------------------------------------------------------
local RIFTSPAWN_TIMERNAME = "rift_spawn_timer"
local RIFT_PORTAL_DEFS = require("prefabs/rift_portal_defs")

local PORTAL_DEFS = RIFT_PORTAL_DEFS.RIFTPORTAL_DEFS
local RIFT_AFFINITY = RIFT_PORTAL_DEFS.RIFTPORTAL_CONST.AFFINITY

--------------------------------------------------------------------------
--[[ Helper Functions ]]
--------------------------------------------------------------------------

--- Gets all of the prefabs that can spawn for a designated rift type/affinity.
---@param rift_type RIFTPORTAL_CONST.AFFINITY
---@return table
local function GetRiftPrefabs(rift_type)
	-- Logic figured out from RiftSpawner:GetNextRiftPrefab()

	local prefabs = {}

	for prefab, def in pairs(PORTAL_DEFS) do
		if def.Affinity == rift_type then
			table.insert(prefabs, prefab)
		end
	end
	
	return prefabs
end


--------------------------------------------------------------------------
--[[ Description stuff ]]
--------------------------------------------------------------------------
-- One of the issues I'm not sure how to handle is the possibility of multiple rifts per shard.
-- It's currently limited to 1 due to whatever technical issues Klei is having at the moment (see Jesse's TUNING comment)
-- I'm currently thinking just to give each rift it's own entry in the menu, but that feels cluttered.
-- No other options I can think of at the moment though.

local function DescribeRiftSpawn(self, context)
	-- Check if time information is relevant
	local time_to_spawn

	-- The timer still goes once we hit the maximum rift count but just stops once it ends if we're still at max rifts.
	-- There's no point in showing it if it'll just end up doing nothing.
	if self.rifts_count < TUNING.MAXIMUM_RIFTS_COUNT and self._worldsettingstimer:ActiveTimerExists(RIFTSPAWN_TIMERNAME) then
		local time = self._worldsettingstimer:GetTimeLeft(RIFTSPAWN_TIMERNAME)
		time_to_spawn = string.format(context.lstr.riftspawner.next_spawn, context.time:SimpleProcess(time))
	
		return {
			name = "riftspawner_riftspawn",
			priority = 0,
			description = time_to_spawn,
			next_rift_spawn = time,
			icon = {
				atlas = "images/Rift_Split.xml",
				tex = "Rift_Split.tex",
			},
			worldly = true,
		}
	end
end

local function DescribeRiftsOfAffinity(self, context, affinity)
	local rift_descriptions = {}

	for rift in pairs(self.rifts) do
		-- The vanilla game only has 1 prefab per affinity type but mods may add some in the future.
		if PORTAL_DEFS[rift.prefab].Affinity == affinity then
			-- I want the information to be available both in the menu and on the actual entity itself.
			-- Plus, the actual logic here is prefab-specific and not controlled by a particular component.
			-- So this just makes sense.
			local descriptor = Insight.prefab_descriptors[rift.prefab] 
			
			if descriptor and descriptor.Describe then
				-- Only use the returned data that matches.
				local described = GetDataFromDescribe(rift.prefab, descriptor.Describe(rift, context))

				if described then
					described.name = "riftspawner_" .. rift.prefab .. "_" .. rift.GUID
					described.worldly = true

					rift_descriptions[#rift_descriptions+1] = described
				end
			end
		end
	end

	return rift_descriptions
end

local function Describe(self, context)
	if not self:GetEnabled() then
		return
	end

	local rift_spawn = DescribeRiftSpawn(self, context)
	local lunars = {}
	local shadows = {}

	if self:GetLunarRiftsEnabled() then
		lunars = DescribeRiftsOfAffinity(self, context, RIFT_AFFINITY.LUNAR)
	end

	if self:GetShadowRiftsEnabled() then
		shadows = DescribeRiftsOfAffinity(self, context, RIFT_AFFINITY.SHADOW)

	end


	local combined = ArrayUnion(lunars, shadows)
	if rift_spawn then
		table.insert(combined, 1, rift_spawn)
	end

	return unpack(combined)
end

local function StatusAnnoucementsDescribe(special_data, context)
	local description = nil

	if special_data.next_rift_spawn then
		description = string.format(ProcessRichTextPlainly(context.lstr.riftspawner.announce_spawn), 
			context.time:TryStatusAnnouncementsTime(special_data.next_rift_spawn)
		)
	end

	return {
		description = description,
		append = true
	}
end

return {
	Describe = Describe,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe,
}