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

--==========================================================================================================================
--==========================================================================================================================
--======================================== Declaration =====================================================================
--==========================================================================================================================
--==========================================================================================================================
local select, unpack = select, unpack

local function pack(...) return { n=select("#", ...), ...} end
local function vararg(packed) return unpack(packed, 1, packed.n) end

-- every optimization matters...?
local SendModRPCToServer = SendModRPCToServer
local SendModRPCToShard = SendModRPCToShard
local SendModRPCToClient = SendModRPCToClient

local MOD_RPC_HANDLERS = MOD_RPC_HANDLERS
local SHARD_MOD_RPC_HANDLERS = SHARD_MOD_RPC_HANDLERS
local CLIENT_MOD_RPC_HANDLERS = CLIENT_MOD_RPC_HANDLERS

local IS_CLIENT_HOST = nil

-- functions

local function GetRPCName(id_table)
	if id_table.rpc_name then
		return id_table.rpc_name
	end

	--[[
	for name, idtbl in pairs(tbl[id_table.namespace]) do
		if idtbl == id_table then
			id_table.name = "! - " .. name
			return id_table.name
		end
	end
	--]]

	--
	for name, idtbl in pairs(MOD_RPC[id_table.namespace] or {}) do
		if idtbl == id_table then
			id_table.insight_name = "S - " .. name
			return id_table.insight_name
		end
	end

	for name, idtbl in pairs(SHARD_MOD_RPC[id_table.namespace] or {}) do
		if idtbl == id_table then
			id_table.insight_name = "X - " .. name
			return id_table.insight_name
		end
	end

	for name, idtbl in pairs(CLIENT_MOD_RPC[id_table.namespace] or {}) do
		if idtbl == id_table then
			id_table.insight_name = "C - " .. name
			return id_table.insight_name
		end
	end
	--

	id_table.insight_name = "? - " .. id_table.id
	return id_table.insight_name
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== RPC Network =====================================================================
--==========================================================================================================================
--==========================================================================================================================
local rpcNetwork = {}
rpcNetwork.debugging = false

rpcNetwork.AddModRPCHandler = function(namespace, name, fn)
	if not rpcNetwork.debugging then
		return AddModRPCHandler(namespace, name, fn)
	end

	return AddModRPCHandler(namespace, name, function(...)
		--dprint(string.format("SERVER MOD RPC GOT [namespace \"%s\", rpc \"%s\"]", namespace, name))
		return fn(...)
	end) -- traces back to networkclientrpc
	--[[
	return AddModRPCHandler(namespace, name, function(...)
		return select(2, pcall(fn, ...)) 
	end)
	--]]
end

rpcNetwork.AddShardModRPCHandler = function(namespace, name, fn)
	if not rpcNetwork.debugging then
		return AddShardModRPCHandler(namespace, name, fn)
	end

	return AddShardModRPCHandler(namespace, name, function(...)
		--dprint(string.format("SHARD MOD RPC GOT [namespace \"%s\", rpc \"%s\"]", namespace, name))
		-- assuming same situation as client mod rpc handler
		local args = pack(...)
		local safe, res = xpcall(function() return fn(vararg(args)) end, debug.traceback)
		
		if not safe then
			mprint(string.format("SHARD MOD RPC ERROR[namespace \"%s\", rpc \"%s\"]\n%s", namespace, name, res))
			-- error properly :)
			if TheGlobalInstance then
				TheGlobalInstance:DoTaskInTime(0, function() error(string.format("SHARD RPC ERROR[namespace \"%s\", rpc \"%s\"]: %s", namespace, name, res), 0) end)
			end

			return
		end

		return res
	end)
end

rpcNetwork.AddClientModRPCHandler = function(namespace, name, fn)
	--[[
	if DEBUG_ENABLED then
		dprint"MONTY"
		AddClientModRPCHandler(namespace, name, fn)
		return
	end
	--]]

	return AddClientModRPCHandler(namespace, name, function(...)
		--dprint(string.format("CLIENT MOD RPC GOT [namespace \"%s\", rpc \"%s\"]", namespace, name))
		-- TheNet call doesn't properly handle errors
		local args = pack(...)
		local safe, res = xpcall(function() return fn(vararg(args)) end, debug.traceback)

		--dprint("RESPONSE", safe, res)
		
		if not safe then
			mprint(string.format("CLIENT MOD RPC ERROR[namespace \"%s\", rpc \"%s\"]\n%s", namespace, name, res))

			-- error properly :)
			if TheGlobalInstance then
				TheGlobalInstance:DoTaskInTime(0, function() error(string.format("CLIENT MOD RPC ERROR[namespace \"%s\", rpc \"%s\"]: %s", namespace, name, res), 0) end)
			end
			-- hmm
			return
		end

		return res -- don't actually know if returning does anything
	end)
end


-- id_table { string namespace=namespace, int id=id }


rpcNetwork.SendModRPCToServer = function(id_table, ...)
	--dprint(string.format("SEND MOD RPC SERVER [namespace \"%s\", rpc \"%s\"]", id_table.namespace, GetRPCName(id_table)))

	if IS_CLIENT_HOST == nil then
		IS_CLIENT_HOST = IsClientHost()
	end

	if IS_CLIENT_HOST then
		local player = localPlayer or AllPlayers[1] -- first player

		if not player then error("UNABLE TO PROCESS RPC 1") end

		--for _, fn in pairs(MOD_RPC_HANDLERS[id_table.namespace][]) do
		--end
		local fn = MOD_RPC_HANDLERS[id_table.namespace][id_table.id]
		if fn then
			fn(player, ...)
		end

		return
	else
		SendModRPCToServer(id_table, ...)
	end
end

rpcNetwork.SendModRPCToShard = function(id_table, sender_list, ...)
	--dprint(string.format("SEND MOD RPC SHARD [namespace \"%s\", rpc \"%s\"]", id_table.namespace, GetRPCName(id_table)))

	if IS_CLIENT_HOST == nil then
		IS_CLIENT_HOST = IsClientHost()
	end

	SendModRPCToShard(id_table, sender_list, ...)
end


rpcNetwork.SendModRPCToClient = function(id_table, sender_list, ...)
	--dprint(string.format("SEND MOD RPC CLIENT [namespace \"%s\", rpc \"%s\"]", id_table.namespace, GetRPCName(id_table)))

	if IS_CLIENT_HOST == nil then
		IS_CLIENT_HOST = IsClientHost()
	end

	if type(sender_list) == "string" then
		sender_list = {sender_list}
	end

	if IS_CLIENT_HOST and localPlayer then
		for i = 1, #sender_list do
			local v = sender_list[i]
			if v == localPlayer.userid then
				table.remove(sender_list, i)
				--mprint("TO CLIENT")
				--table.foreach(id_table, mprint)

				--for _, fn in pairs(CLIENT_MOD_RPC_HANDLERS[id_table.namespace]) do
					
				--end

				local fn = CLIENT_MOD_RPC_HANDLERS[id_table.namespace][id_table.id]
				if fn then
					fn(...)
				end

				break;
			end
		end
	end
	
	if #sender_list > 0 then
		--dprint("SENDING TO CLIENTS", unpack(sender_list))
		-- empty sender_list is also "invalid sender list"
		SendModRPCToClient(id_table, sender_list, ...)
		return
	end

	--dprint("sender list fail")
end

rpcNetwork.SendModRPCToAllClients = function(id_table, ...)
	--dprint(string.format("SEND MOD RPC CLIENT [namespace \"%s\", rpc \"%s\"]", id_table.namespace, GetRPCName(id_table)))

	if IS_CLIENT_HOST == nil then
		IS_CLIENT_HOST = IsClientHost()
	end

	local sender_list = {}

	for i = 1, #AllPlayers do
		local player = AllPlayers[i]
		if player.userid ~= "" then
			if IS_CLIENT_HOST and localPlayer and player.userid == localPlayer.userid then
				local fn = CLIENT_MOD_RPC_HANDLERS[id_table.namespace][id_table.id]
				if fn then
					fn(...)
				end
			else
				sender_list[#sender_list+1] = player.userid
			end
		end
	end
	
	if #sender_list > 0 then
		--dprint("SENDING TO CLIENTS", unpack(sender_list))
		-- empty sender_list is also "invalid sender list"
		SendModRPCToClient(id_table, sender_list, ...)
		return
	end

	--dprint("sender list fail")
end




return rpcNetwork