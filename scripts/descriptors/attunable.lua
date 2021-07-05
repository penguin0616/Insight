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

-- attunable.lua
local yep = { colour=Color.new(1, 1, 1, 1) }
local function Describe(self, context)
	local description = nil

	local players = {}
	for player in pairs(self.attuned_players) do
		local client_table = TheNet:GetClientTableForUser(player.userid) or yep
		local player_string = string.format(context.lstr.attunable.player, 
			Color.ToHex(client_table.colour),
			player.name or "?",
			player.prefab or "?"
		)
		players[#players+1] = player_string
	end

	local offline_users = {}
	for userid in pairs(self.attuned_userids) do
		offline_users[#offline_users+1] = userid
	end

	local linked = string.format(context.lstr.attunable.linked, table.concat(players, ", "))
	local offline = #offline_users > 0 and string.format(context.lstr.attunable.offline_linked, #offline_users) or nil
	description = CombineLines(linked, offline)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}