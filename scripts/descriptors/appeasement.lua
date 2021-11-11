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


-- appeasement.lua (Shipwrecked)
local world_type = GetWorldType()
local function Describe(self, context)
	local description = nil

	if not context.config["appeasement_value"] then
		return
	end

	local volcano_manager = world_type >= 2 and GetVolcanoManager()
	if volcano_manager and volcano_manager:IsActive() then
		if self.appeasementvalue < 0 then
			description = context.lstr.appease_bad
			--description = "Hasten eruption: "
		elseif self.appeasementvalue > 0 then
			description = context.lstr.appease_good
			--description = "Delays eruption: " 
		end
	end
	
	if description then
		description = string.format(description, math.abs(self.appeasementvalue))
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}