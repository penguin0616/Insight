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

local language = import("language/language")

local PlayerContext = {}

PlayerContext.__index = PlayerContext
PlayerContext._newindex = function() error("context is readonly") end -- I shouldn't be using context to exchange descriptor information anymore.
--PlayerContext.__tostring = function(self) return string.format("Player Context (%s): %s", tostring(self.player), self._name or "ADDR") end,
PlayerContext.__metatable = "[Insight] The metatable is locked" -- No touchy!

--- Validation/fixup for complex configuration.
--- @param player EntityScript
--- @param complex_config_table table
local function ValidateComplexConfiguration(player, complex_config_table)
	for name, config in pairs(modinfo.complex_configuration_options) do
		local val = complex_config_table[name]
		if config.type == "listbox" then
			if type(val) ~= "table" then
				complex_config_table[name] = {}
				mprintf("!!!!!!!!!! %s had an invalid complex config for %s: %s (%s)", tostring(player), name, tostring(val), type(val))
			end
		end
	end
end

--- Creates a new instance of a player context.
--- @param player EntityScript Player entity.
--- @param configs table The sets of configuration options that the player currently has -- vanilla, external, and complex.
--- @param etc table etc. I should have named this better :(
--- @return PlayerContext @The created player context
function PlayerContext.new(player, configs, etc)
	if not (type(player) == "table" and type(player.is_a) == "function" and player:is_a(EntityScript)) then
		argerror(1, "new", "EntityScript", player)
	end

	if type(configs) ~= "table" then
		argerror(2, "new", "table", type(configs))
	end

	if type(etc) ~= "table" then
		argerror(3, "new", "table", type(etc))
	end

	if type(configs.vanilla) ~= "table" then
		if IS_DST then TheNet:Kick(player.userid) return end -- Only reason this is going to happen in DST is due to someone being naughty.
		error("[Insight]: vanilla config is invalid!")
	end

	if type(configs.external) ~= "table" then
		if IS_DST then TheNet:Kick(player.userid) return end -- Only reason this is going to happen in DST is due to someone being naughty.
		error("[Insight]: external config is invalid!")
	end

	if type(configs.complex) ~= "table" then
		if IS_DST then TheNet:Kick(player.userid) return end -- Only reason this is going to happen in DST is due to someone being naughty.
		error("[Insight]: complex config is invalid!")
	end

	ValidateComplexConfiguration(player, configs.complex)

	local context = {
		player = player,
		config = configs.vanilla,
		external_config = configs.external,
		complex_config = configs.complex,
		time = nil,
		usingIcons = configs.vanilla["info_style"] == "icon",
		lstr = language(configs.vanilla, etc.locale),
		etc = etc
	}

	context.time = Time:new({ context=context })

	-- Uses Klei ID.
	if TheNet:GetIsServerOwner(player.Network:GetUserID()) then
		if context.config["crash_reporter"] then
			CrashReporter.server_owner_optin = true
			SyncSecondaryInsightData({ server_owner_optin=true })
		end
	end

	setmetatable(context.config, {__newindex = function() error("config is readonly") end, __metatable = "[Insight] The metatable is locked" })
	setmetatable(context.external_config, {__newindex = function() error("external_config is readonly") end, __metatable = "[Insight] The metatable is locked" })
	setmetatable(context.complex_config, {__newindex = function() error("complex_config is readonly") end, __metatable = "[Insight] The metatable is locked" })
	setmetatable(context, PlayerContext)

	return context
end

return PlayerContext