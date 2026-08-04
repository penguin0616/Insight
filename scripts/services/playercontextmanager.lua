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

--- This singleton services as the manager for player contexts. 
--- On the server, it manages contexts for everyone.
--- On the client, it manages context for the local player.
--- @class PlayerContextManager
--- @field private PlayerContexts table Player contexts managed by the manager.
local PlayerContextManager = {
	PlayerContexts = {}
}

local PlayerContext = import("objects/playercontext")

--- Checks whether a player's context exists.
--- @param player EntityScript
--- @return bool
function PlayerContextManager:HasContext(player)
	if not (type(player) == "table" and type(player.is_a) == "function" and player:is_a(EntityScript)) then
		argerror(1, "GetContext", "EntityScript", player)
	end

	if IS_DST and TheWorld.ismastersim then
		-- i know we'll have it
		context = self.PlayerContexts[player]
	else
		-- will be the only context
		context = self.PlayerContexts[player]
	end

	return context ~= nil
end

--- Returns a copy of the player's PlayerContext
--- @param player EntityScript
--- @return PlayerContext
function PlayerContextManager:GetContext(player)
	if not (type(player) == "table" and type(player.is_a) == "function" and player:is_a(EntityScript)) then
		argerror(1, "GetContext", "EntityScript", player)
	end

	if IS_DST and TheWorld.ismastersim then
		-- i know we'll have it
		context = self.PlayerContexts[player]
	else
		-- will be the only context
		context = self.PlayerContexts[player]
	end

	if context then
		return setmetatable({ FROM_INSPECTION=false }, { __index=context })
	end
end

--- Returns all of the player contexts.
--- @return table<PlayerContext>
function PlayerContextManager:GetAllContexts()
	return self.PlayerContexts
end

--- Removes the player's context
--- @param player EntityScript Player entity.
function PlayerContextManager:RemoveContext(player)
	self.PlayerContexts[player] = nil
end


--- Creates a new instance of a player context.
--- @param player EntityScript Player entity.
--- @param configs table The sets of configuration options that the player currently has -- vanilla, external, and complex.
--- @param etc table etc. I should have named this better :(
--- @return PlayerContext @The created player context
function PlayerContextManager:CreateContext(player, configs, etc)
	mprint("Creating player context for", player)
	local context = PlayerContext.new(player, configs, etc)

	self.PlayerContexts[player] = context

	return context
end

--- Updates a player's context if they already have one.
--- @param player EntityScript Player entity.
--- @param configs table The sets of configuration options that the player currently has -- vanilla, external, and complex.
--- @param etc table etc. I should have named this better :(
--- @return PlayerContext @The created player context
function PlayerContextManager:UpdateContext(player, configs, etc)
	mprint("Updating player context for", player)
	if not self.PlayerContexts[player] then
		mprint("Can't update missing player context.")
		return
	end

	-- I don't quite remember why I made the old UpdatePlayerContext like that.
	-- Will just rebuild it.
	return self:CreateContext(player, configs, etc)
end

--[[
--- Updates a player's context if they already have one.
---@param player EntityScript
---@param data table
function UpdatePlayerContext(player, data)
	local context = player_contexts[player]
	if not context then
		mprint("Can't update missing player context.")
		return
	end

	local oldLang = context.config["language"]
	if data.configs then
		if type(data.configs.vanilla) ~= "table" then
			if IS_DST then TheNet:Kick(player.userid) return end
			error("[Insight]: UpdatePlayerContext Config is invalid!")
		end

		if type(data.configs.external) ~= "table" then
			if IS_DST then TheNet:Kick(player.userid) return end
			error("[Insight]: UpdatePlayerContext external config is invalid!")
		end

		if type(data.configs.complex) ~= "table" then
			if IS_DST then TheNet:Kick(player.userid) return end
			error("[Insight]: UpdatePlayerContext complex config is invalid!")
		end

		ValidateComplexConfiguration(player, data.configs.complex)

		context.config = setmetatable(data.configs.vanilla, CONTEXT_META)
		context.external_config = setmetatable(data.configs.external, CONTEXT_META)
		context.complex_config = setmetatable(data.configs.complex, CONTEXT_META)
	end
	data.configs = nil

	for i,v in pairs(data) do
		context[i] = v
	end

	local oldUsingIcons = context.usingIcons
	context.usingIcons = context.config["info_style"] == "icon"

	if oldLang ~= context.config["language"] or oldUsingIcons ~= context.usingIcons then
		context.lstr = language(context.config, context.etc.locale)
		context.etc.locale = context.config["language"]
	end
end
]]

return PlayerContextManager