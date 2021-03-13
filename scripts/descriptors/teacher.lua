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

-- teacher.lua
local recipe_cache = setmetatable({}, {__mode="v"}) -- [recipe] = {players userids}
local listening = setmetatable({}, {__mode="kv"})

local function ListenForLearning(player)
	if listening[player] then
		return
	end

	listening[player] = true

	player:ListenForEvent("unlockrecipe", function(inst, data)
		if not data then
			-- used creative mode
			return
		end

		if data.recipe and recipe_cache[data.recipe] then
			table.removearrayvalue(recipe_cache[data.recipe], inst.name)
		end
	end)
end

local function GetDumbPlayers(recipe)
	if recipe_cache[recipe] then
		return recipe_cache[recipe]
	end

	recipe_cache[recipe] = setmetatable({}, {__mode="v"})

	for i = 1, #AllPlayers do
		local player = AllPlayers[i]

		if player.userid ~= "" and player.components.builder then
			if not player.components.builder:KnowsRecipe(recipe) and player.components.builder:CanLearn(recipe) then
				recipe_cache[recipe][#recipe_cache[recipe]+1] = player.name
				ListenForLearning(player)
			end
		end
	end

	return recipe_cache[recipe]
end

-- TODO: figure out a better way to do this?
-- is this a feature that actually helps people?
local function Describe(self, context)
	local alt_description = nil

	if not context.etc.DEBUG_ENABLED then
		return
	end

	if not self.recipe then
		return
	end

	--[[
	local players = GetDumbPlayers(self.recipe)
	for i = 1, #players do
		players[i] = players[i].name
	end
	--]]

	alt_description = "Unknown by: " .. table.concat(GetDumbPlayers(self.recipe), ", ")
	

	return {
		priority = 0,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}