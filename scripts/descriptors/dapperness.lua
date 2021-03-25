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

-- dapperness.lua
-- only exists in base game DS

local world_type = GetWorldType()

local function Describe(self, context)
	if world_type ~= 0 then
		return
	end

	local description = nil

	local owner = context.player
	description = self:GetDapperness(context.player)
	description = Round(description * 60, 1)

	if description ~= 0 then
		description = string.format(context.lstr.dapperness, FormatNumber(description))
	else
		description = nil
	end


	return {
		priority = 0.1,
		description = description
	}
end



return {
	Describe = Describe
}