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

-- kramped.lua [Worldly]
local function GetPlayerNaughtiness(player)
	if IS_DS then
		-- <3
		local kramped = player.components.kramped
		if kramped then
			if not kramped.actions or not kramped.threshold then
				kramped:OnNaughtyAction(0)
			end

			if not (kramped.actions and kramped.threshold) then
				error("[Insight]: Kramped stats missing after initialization?")
			end

			return { actions=kramped.actions, threshold=kramped.threshold }
		end
	end

	if not TheWorld.ismastersim then
		error("[Insight]: GetPlayerNaughtiness called on client")
		return
	end

	local data = Insight.kramped.players[player]

	if not data or not data.threshold or data.threshold < 0 then 
		return
	end

	return { actions = data.actions, threshold = data.threshold }
end

--- [DST] Returns naughtiness value of a creature.
---@param inst EntityScript The living creature.
---@return number
local function DST_GetCreatureNaughtiness(inst, context)
	if not TheWorld.ismastersim then
		error("[Insight]: DST_GetCreatureNaughtiness called on client")
	end

	if inst.components.werebeast ~= nil and inst.components.werebeast:IsInWereState() then
		-- you can kill werebeasts all you want with no moral sin
		return 0
	end

	local res = Insight.kramped.values[inst.prefab]

	local fn_data = {
		victim = inst
	}

	-- I sure hope no one is doing anything funny like using this as a hook for OnKilledOther, 
	-- doing definitive things that shouldn't be happening for a simple query of naughtiness value! 
	-- Fix requested by Hornet, probably for IA or something
	res = FunctionOrValue(res, context.player, fn_data)

	--[[
	if type(res) == "function" then
		-- their doydoys have naughtiness as a function, which is supported by gemcore. https://gitlab.com/IslandAdventures/IslandAdventures/-/blob/master/modmain.lua (September 19, 2020)
		res = res()
	end

	if type(res) == "number" then
		return res
	end
	--]]
	
	return 0
end

--- [DS] Returns naughtiness value of a creature.
---@param inst EntityScript The living creature.
---@return number
local function GetCreatureNaughtiness(inst, context)
	if IS_DST then
		return DST_GetCreatureNaughtiness(inst, context)
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
		naughtiness = GetCreatureNaughtiness(inst, context)
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