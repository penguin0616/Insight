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

-- shadowsubmissive.lua
local ShadowSanitySplitterPresent = KnownModIndex:IsModEnabled("workshop-2452266825")

-- this is technically used for the bone helm, but piggybacking here
local function Describe(self, context)
	local description = nil

	local spawnedforplayer_string = nil
	local sanityreward_string = nil
	if not self.inst:HasTag("shadowcreature") then -- "nightmarecreature" tag is ruins variant
		return
	end

	if self.inst.spawnedforplayer then
		-- going to assume that player needs to be valid for network color to be valid too
		local color = self.inst.spawnedforplayer:IsValid() and GetPlayerColour(self.inst.spawnedforplayer) or "#ffffff"

		local target_string = (self.inst.spawnedforplayer.name or "?") .. " - " .. GetPrefabNameOrElse(self.inst.spawnedforplayer.prefab, "\"%s\"")

		spawnedforplayer_string = string.format(context.lstr.shadowsubmissive.shadowcreature.spawned_for, 
			ApplyColour(target_string, color)
		)
	end

	if false and ShadowSanitySplitterPresent then
		
	else
		sanityreward_string = string.format(context.lstr.shadowsubmissive.shadowcreature.sanity_reward, self.inst.sanityreward or TUNING.SANITY_SMALL)
	end
	
	description = CombineLines(spawnedforplayer_string, sanityreward_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}