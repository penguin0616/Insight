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

-- sanity.lua
--[[
	was looking around at sanity, turns out willow has sanity.rate_modifier of 1.1, which affects over time sanity (Sanity::Recalc)

	dapperness_mult (default 1, no characters use this) multiplies dapperness from equippables. i assume this is what walter used before they fixed stuff.

]]

local function GetData(self)
	local lunacy = false
	local max_sanity = 0

	if IS_DST then
		if self:IsLunacyMode() then
			lunacy = true
		end
		
		max_sanity = self:GetMaxWithPenalty()
	else
		max_sanity = self:GetMaxSanity()
	end

	return {
		sanity = tonumber(Round(self.current, 0)),
		max_sanity = math.floor(max_sanity),
		lunacy = lunacy
	}
end

local function Describe(self, context)
	if not context.config["display_sanity"] then
		return
	end
	
	local description = nil

	local sanity_type = context.lstr.sanity.current_sanity
	local max_sanity = nil
	local lunacy = false
	
	if IS_DST then
		if self:IsLunacyMode() then
			sanity_type = context.lstr.sanity.current_enlightenment
			lunacy = true
		end
		
		max_sanity = self:GetMaxWithPenalty()
	else
		max_sanity = self:GetMaxSanity()
	end

	description = string.format(sanity_type, Round(self.current, 0), math.floor(max_sanity), math.floor(self:GetPercent() * 100))

	

	return {
		priority = 29,
		description = description,
	}
end



return {
	Describe = Describe,
	GetData = GetData
}