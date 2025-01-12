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

-- linkeditem.lua
local DEFAULT_COLOR = "#cccccc"

local color_cache = setmetatable({}, {
	__index = function(self, userid)
		local client_table = TheNet:GetClientTableForUser(userid)
		local color = client_table and client_table.colour and Color.ToHex(client_table.colour) or DEFAULT_COLOR

		local data = {
			last_update = GetTime(),
			color = color,
		}

		rawset(self, userid, data)
		return rawget(self, userid)
	end
})


-- Turns out the component already does this!
local function Describe(self, context)
	local description = nil

	local netowneruserid = self:GetOwnerUserID()
	local owner_name = self:GetOwnerName()

	local owner_name_color = DEFAULT_COLOR

	-- If there's a netwowneruserid associated with this item, we know that it has some record of ownership.
	if netowneruserid then
		local cached_data = color_cache[netowneruserid]
		owner_name_color = cached_data.color or owner_name_color

		if (GetTime() - cached_data.last_update) >= 15 then
			color_cache[netowneruserid] = nil
		end

		-- If we have a registered owner, then we know there should probably be an owner name.
		-- If not, we'll default to unknown.
		owner_name = owner_name or "(Unknown)"
	end

	if owner_name then
		description = string.format(context.lstr.linkeditem.owner, ApplyColor(owner_name, owner_name_color))
	end
	return {
		priority = 0,
		description = description
	}
end



return {
	--Describe = Describe
}