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

-- workable.lua
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheWorld, TUNING = TheWorld, TUNING

local function GetDeciduousSpawnChance_DST(days_survived)
	local chance =
		(TheWorld.state.isautumn and TUNING.DECID_MONSTER_SPAWN_CHANCE_AUTUMN) or
		(TheWorld.state.isspring and TUNING.DECID_MONSTER_SPAWN_CHANCE_SPRING) or
		(TheWorld.state.issummer and TUNING.DECID_MONSTER_SPAWN_CHANCE_SUMMER) or
		(TheWorld.state.iswinter and TUNING.DECID_MONSTER_SPAWN_CHANCE_WINTER) or
		0

	local chance_mod = TUNING.DECID_MONSTER_SPAWN_CHANCE_MOD[1]
	for i = 1, #TUNING.DECID_MONSTER_DAY_THRESHOLDS do
		local v = TUNING.DECID_MONSTER_SPAWN_CHANCE_MOD[i]
		if days_survived < v then
			break
		end
		chance_mod = TUNING.DECID_MONSTER_SPAWN_CHANCE_MOD[i + 1]
	end

	return chance * chance_mod
end

local function GetDeciduousSpawnChance(days_survived)
	local chance = TUNING.DECID_MONSTER_SPAWN_CHANCE_BASE
	local thresh_chance = { TUNING.DECID_MONSTER_SPAWN_CHANCE_LOW, TUNING.DECID_MONSTER_SPAWN_CHANCE_MED, TUNING.DECID_MONSTER_SPAWN_CHANCE_HIGH }
	for i = 1, #TUNING.DECID_MONSTER_DAY_THRESHOLDS do
		local v = TUNING.DECID_MONSTER_DAY_THRESHOLDS[i]
		if days_survived >= v then
			chance = thresh_chance[i]
		else
			break
		end
	end

	return chance
end

local is_dst = IsDST()

local function Describe(self, context)
	local inst = self.inst

	local alt_description
	
	local player_chance, npc_chance

	local player_days, npc_days
	if is_dst then
		npc_days = TheWorld.state.cycles
		player_days = context.player.components.age ~= nil and context.player.components.age:GetAgeInDays() or npc_days -- crab king attacks and players are the only things with age
	else
		npc_days = GetClock().numcycles
		player_days = npc_chance
	end

	if inst.prefab == "deciduoustree" then
		if inst.components.growable ~= nil and inst.components.growable.stage == 3 then 
			player_chance, npc_chance = 0, 0

			if is_dst and player_days >= TUNING.DECID_MONSTER_MIN_DAY then
				player_chance = GetDeciduousSpawnChance_DST(player_days)

				if context.player:HasTag("beaver") then
					player_chance = player_chance * TUNING.BEAVER_DECID_MONSTER_CHANCE_MOD
				elseif context.player:HasTag("woodcutter") then
					player_chance = player_chance * TUNING.WOODCUTTER_DECID_MONSTER_CHANCE_MOD
				end
			end

			if npc_days >= TUNING.DECID_MONSTER_MIN_DAY then
				npc_chance = is_dst and GetDeciduousSpawnChance_DST(npc_days) or GetDeciduousSpawnChance(npc_chance)
			end
		end 
	elseif inst.prefab == "evergreen" or inst.prefab == "evergreen_sparse" then
		player_chance, npc_chance = 0, 0

		if is_dst and player_days >= TUNING.LEIF_MIN_DAY then
			player_chance = TUNING.LEIF_PERCENT_CHANCE

			if context.player:HasTag("beaver") then
				player_chance = player_chance * TUNING.BEAVER_LEIF_CHANCE_MOD
			elseif context.player:HasTag("woodcutter") then
				player_chance = player_chance * TUNING.WOODCUTTER_LEIF_CHANCE_MOD
			end
			--print(player_chance, player_chance * 100, Round(player_chance * 100, 0))
		end

		if npc_days >= TUNING.LEIF_MIN_DAY then
			npc_chance = TUNING.LEIF_PERCENT_CHANCE
		end
	end

	if not (player_chance and npc_chance) then
		return
	end

	if is_dst then
		alt_description = string.format(context.lstr.workable.treeguard_chance_dst, Round(player_chance * 100, 2), Round(npc_chance * 100, 2))
	else
		alt_description = string.format(context.lstr.workable.treeguard_chance, Round(npc_chance * 100, 2))
	end

	return {
		priority = 0,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}