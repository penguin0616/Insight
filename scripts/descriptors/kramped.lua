--[[
Copyright (C) 2020 penguin0616

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

-- kramped.lua [Worldly]
local function GetPlayerNaughtiness(player)
	if IsDS() then
		-- <3
		local kramped = player.components.kramped
		if kramped then
			if not kramped.actions or not kramped.threshold then
				kramped:OnNaughtyAction(0)
			end

			assert(kramped.actions and kramped.threshold, "[Insight]: Kramped stats missing after initialization?")
			return { actions=kramped.actions, threshold=kramped.threshold }
		end
	end

	assert(TheWorld.ismastersim, "[Insight]: GetPlayerNaughtiness called on client")
	local data = Insight.kramped.players[player]

	if not data or data.threshold <= 0 then 
		return
	end

	return { actions = data.actions, threshold = data.threshold }
end

--- [DST] Returns naughtiness value of a creature.
-- @tparam Entity inst The living creature.
-- @treturn number
local function DST_GetCreatureNaughtiness(inst)
	assert(TheWorld.ismastersim, "[Insight]: DST_GetCreatureNaughtiness called on client")

	if inst.components.werebeast ~= nil and inst.components.werebeast:IsInWereState() then
		-- you can kill werebeasts all you want with no moral sin
		return 0
	end

	local res = Insight.kramped.values[inst.prefab]

	if type(res) == "function" then
		-- their doydoys have naughtiness as a function, which is supported by gemcore. https://gitlab.com/IslandAdventures/IslandAdventures/-/blob/master/modmain.lua (September 19, 2020)
		res = res()
	end

	if type(res) == "number" then
		return res
	end
	
	return 0
end

--- [DS] Returns naughtiness value of a creature.
-- @tparam Entity inst The living creature.
-- @treturn number
local function GetCreatureNaughtiness(inst)
	if IsDST() then
		return DST_GetCreatureNaughtiness(inst)
	end

	local name = inst.prefab

	if name ~= 'doydoy' and name ~= 'pigman' and name ~= 'ballphin' and Insight.kramped.values[name] then
		return Insight.kramped.values[name]
	end

	-- not DST
	local kramped = GetPlayer().components.kramped

	--local oldOnKilledOther = kramped.onkilledother
	local oldOnNaughtyAction = kramped.OnNaughtyAction

	kramped.OnNaughtyAction = function(self, value)
		Insight.kramped.values[name] = value
	end

	kramped:onkilledother(inst)

	kramped.OnNaughtyAction = oldOnNaughtyAction

	if not Insight.kramped.values[name] then
		Insight.kramped.values[name] = 0
	end

	return Insight.kramped.values[name]
end

local function Describe(self, context)
	local inst = self
	local naughtiness = nil

	if not IsPrefab(inst) then
		return nil
	end
	
	if inst:HasTag("player") then
		naughtiness = GetPlayerNaughtiness(inst, context)
		--dprint'player naughtiness'
	elseif inst.components.health then
		naughtiness = GetCreatureNaughtiness(inst)
		--dprint'critter naughtiness'
	end

	return {
		priority = 0,
		description = nil,
		naughtiness = naughtiness
	}
end



return {
	Describe = Describe
}