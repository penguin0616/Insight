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
local module = {
	initialized = false,
	active_players = {},
	naughtiness_values = {},
}

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

	local res = module.naughtiness_values[inst.prefab]

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

	if name ~= 'doydoy' and name ~= 'pigman' and name ~= 'ballphin' and module.naughtiness_values[name] then
		return module.naughtiness_values[name]
	end

	-- not DST
	local kramped = GetPlayer().components.kramped

	--local oldOnKilledOther = kramped.onkilledother
	local oldOnNaughtyAction = kramped.OnNaughtyAction

	kramped.OnNaughtyAction = function(self, value)
		module.naughtiness_values[name] = value
	end

	kramped:onkilledother(inst)

	kramped.OnNaughtyAction = oldOnNaughtyAction

	if not module.naughtiness_values[name] then
		module.naughtiness_values[name] = 0
	end

	return module.naughtiness_values[name]
end


--- yep
--- @param self kramped
local function OnKrampedPostInit(self)
	if not self.GetDebugString then
		mprint("Unable to find GetDebugString from kramped. Exiting naughtiness early.")
		return
	--[[elseif debug.getinfo(kramped.GetDebugString, "S").source ~= "scripts/components/kramped.lua" then
		mprint("Unable to setup kramped with non-vanilla kramped file.")
		return
		--]]
	end

	local _activeplayers = util.getupvalue(self.GetDebugString, "_activeplayers")
	if not _activeplayers then
		local d = debug.getinfo(self.GetDebugString, "Sl")
		mprint("Kramped::GetDebugString ->", d.source, d.linedefined)
		return --assert(_activeplayers, "[Insight]: Kramped failed to load _activeplayers, are you using mods that affect krampii?")
	end

	module.active_players = _activeplayers
	local oldOnNaughtyAction
	local firstLoad = true

	-- i can't begin to describe how much this hurt me (Basements) https://steamcommunity.com/sharedfiles/filedetails/?id=1349799880 
	-- they call ms_playerjoined and ms_playerleft manually on functions that have an _activeplayers upvalue. 
	-- i shouldnt have to do this for a variety of reasons, but here we are...
	-- note: because of how this works, entering/leaving one of those basements no longer resets your naughtiness.
	
	for i,v in pairs(TheWorld.event_listening.ms_playerleft[TheWorld]) do 
		if debug.getinfo(v, "S").source == "scripts/components/kramped.lua" then 
			module.OnPlayerLeft = v;
			TheWorld.event_listening.ms_playerleft[TheWorld][i] = function(...)
				return module.OnPlayerLeft(...)
			end
			break;
		end 
	end 
	
	for i,v in pairs(TheWorld.event_listening.ms_playerjoined[TheWorld]) do 
		if debug.getinfo(v, "S").source == "scripts/components/kramped.lua" then 
			module.OnPlayerJoined = v;
			TheWorld.event_listening.ms_playerjoined[TheWorld][i] = function(...)
				return module.OnPlayerJoined(...)
			end
			break;
		end 
	end

	setmetatable(module.active_players, {
		__newindex = function(self, player, playerdata)
			--dprint("newindex player", player, playerdata)
			-- Load OnKilledOther
			-- debug.getinfo(2).func's upvalues {_activeplayers [tbl], self [tbl], OnKilledOther [fn]}

			-- Hacky upvalue search, yay.
			if not module.OnKilledOther then
				-- this isn't annoying at all!
				local i = 2
				while true do
					local info = debug.getinfo(i)

					if not info then
						break
					end

					local func = util.getupvalue(info.func, "OnKilledOther")
					if type(func) == "function" then
						OnKilledOther = func
						if i > 2 then
							mprint("Got OnKilledOther at a level greater than two.")
						end
						break
					end
				end
			end

			-- Load naughtiness values
			if tonumber(APP_VERSION) > 435626 then -- zark
				module.naughtiness_values = NAUGHTY_VALUE
			elseif module.OnKilledOther then
				module.naughtiness_values = util.getupvalue(module.OnKilledOther, "NAUGHTY_VALUE")
			end

			--assert(module.naughtiness_values, "[Insight]: Kramped failed to load naughtiness values")

			-- Load oldOnNaughtyAction
			module.oldOnNaughtyAction = module.oldOnNaughtyAction or util.recursive_getupvalue(module.OnKilledOther, "OnNaughtyAction") -- zarklord's gemcore (https://steamcommunity.com/sharedfiles/filedetails/?id=1378549454) fiddles with OnKilledOther [September 6, 2020]
			--assert(oldOnNaughtyAction, "[Insight]: Kramped failed to load OnNaughtyAction [recursive]")

			-- Insert the player and the data.
			rawset(self, player, playerdata)

			-- Register player's naughtiness threshold.
			if TUNING.KRAMPUS_THRESHOLD ~= -1 then
				module.OnKilledOther(player, {
					-- fake a victim
					victim = {
						prefab = "glommer",
					},
					stackmult = 0, -- no naughtiness gained since it multiplies naughtiness by this value
				})
			else
				module.active_players[player].threshold = 0
			end

			if player.components.insight then
				--dprint'attempt to send naughtiness'
				-- Client initialized sends it now. Why did I do that again?
				--player.components.insight:SendNaughtiness()
				--dprint'attempt finished'
			else
				mprint("Unable to send initial naughtiness to:", player)
			end

			if firstLoad then
				util.replaceupvalue(module.OnKilledOther, "OnNaughtyAction", function(how_naughty, playerdata)
					--dprint("onnaughtyaction", how_naughty, playerdata, playerdata.player)
					--mprint("ON NAUGHTY ACTION BEFORE", playerdata.player, GetNaughtiness(playerdata.player).actions, GetNaughtiness(playerdata.player).threshold)
					module.oldOnNaughtyAction(how_naughty, playerdata)
					--mprint("ON NAUGHTY ACTION AFTER", playerdata.player, GetNaughtiness(playerdata.player).actions, GetNaughtiness(playerdata.player).threshold)
					--mprint(playerdata.actions, playerdata.threshold)
					-- while i could just pass in the playerdata........ i dont feel like it
					if playerdata.player.components.insight then
						playerdata.player.components.insight:SendNaughtiness()
					end
				end)
			end

			firstLoad = false
		end,
		__metatable = "[Insight] The metatable is locked"
	})
end

local function OnServerInit()
	if module.initialized then
		return
	end

	module.initialized = true

	if not IS_DST then
		return
	end

	AddComponentPostInit("kramped", OnKrampedPostInit)
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

--- Returns the naughtiness description for the specified player.
--- @param inst EntityScript player
--- @param context table
--- @return number|nil @Current naughtiness value.
local function GetNaughtiness(inst, context)
	local data = Describe(inst, context)
	if data then 
		return data.naughtiness 
	end
end


return {
	OnServerInit = OnServerInit,
	Describe = Describe,
	GetNaughtiness = GetNaughtiness,
}