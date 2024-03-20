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

do
	local GLOBAL = GLOBAL
	local mainEnv = GLOBAL.getfenv(1)
	local rawget, setmetatable = GLOBAL.rawget, GLOBAL.setmetatable
	setmetatable(mainEnv, {
		__index = function(self, index)
			return rawget(GLOBAL, index)
		end
	})

	_G = GLOBAL
end

local module = {}

-- netvars debugging
local NETVARS = {
	"net_float", "net_byte", "net_shortint", "net_ushortint", "net_int", "net_uint", 
	"net_bool", "net_hash", "net_string", "net_entity", "net_tinybyte", "net_smallbyte", 
	"net_bytearray", "net_smallbytearray", 
}

local DebugNetvar = Class(function(self, GUID, name, event, ctor)
	self.GUID = GUID
	self.name = name
	self.event = event

	self._netvar = ctor(self.GUID, self.name, self.event)
end)

function DebugNetvar:set(...)
	return self._netvar:set(...)
end

function DebugNetvar:set_local(...)
	return self._netvar:set_local(...)
end

function DebugNetvar:value(...)
	return self._netvar:value(...)
end

local NETVAR_FNS = {}
local ents_database = setmetatable({}, { })

local function xprint(...)
	print("[DEBUGGING TOOL]", ...)
end

local function GetEntityRecord(GUID)
	-- Make sure we have a record for this entity
	local record = ents_database[GUID]
	if not record then
		--[[
		if not entity.Network then
			-- It doesn't seem to exist immediately.
			--xprint("Entity", entity, "doesn't have a Network?")
		end
		--]]
		--local network_id = entity.Network and entity.Network:GetNetworkID()
		record = {
			--networkID = network_id, 
			netvars = {},
			netvar_mapping = {},
		}
		ents_database[GUID] = record
	end

	return record
end

local function OnGameError(self)
	module.OnGameExit()

	-- ScriptErrorWidget
	TheSim:GetPersistentString("../../client_log.txt", function(successful, data)
		if not successful then
			xprint("UNABLE TO FIND CLIENT LOG")
			return
		end

		-- Error deserializing lua state for entity woodie[100108]
		for prefab, GUID in string.gmatch(data, "Error deserializing lua state for entity ([%d%w_]+)%[(%d+)%]") do
			GUID = tonumber(GUID) or "???"
			xprint("DESERIALIZATION FAIL FOR:", prefab, GUID)
			xprint(module.SerializeEntity(GUID))
			module.CompareDatabaseStateToServer()
		end
	end)
end

local function OnRemoveEntity(GUID)
	--xprint("OnRemoveEntity", GUID, Ents[GUID])
	ents_database[GUID] = nil

	return module.old_OnRemoveEntity(GUID)
end

module.StartNetvarDebugging = function()
	xprint("=====================================================================")
	xprint("StartNetvarDebugging called")
	

	if TheNet:IsDedicated() == false and TheNet:GetIsMasterSimulation() == true then
		xprint("CANNOT DEBUG IS_CLIENT_HOST")
		return
	end

	getfenv(0).VERBOSITY_LEVEL = VERBOSITY.DEBUG

	module.old_OnRemoveEntity = getfenv(0).OnRemoveEntity
	getfenv(0).OnRemoveEntity = OnRemoveEntity


	for i, netvar_type in pairs(NETVARS) do
		xprint("replacing Netvar", netvar_type)

		-- Get original netvar
		local orig = getfenv(0)[netvar_type]
		if not orig then
			error("Missing Netvar: " .. netvar_Type)
			return
		end
		NETVAR_FNS[netvar_type] = orig
		-- And remember it

		local replacement = function(GUID, netvar_name, netvar_event)
			local entity = Ents[GUID]
			local record = GetEntityRecord(GUID)
			
			--[[
			if record.netvar_mapping[netvar_name] ~= nil then
				xprint("NETVAR NAME:", netvar_name)
				xprint("NETVAR TYPE:", netvar_type)
				error("Netvar overriden!!", 2)
				return
			end
			--]]
			
			local netvar = DebugNetvar(GUID, netvar_name, netvar_event, orig)
			
			table.insert(record.netvars, netvar)
			record.netvar_mapping[netvar.name] = netvar

			--xprint("Recorded", GUID, entity, netvar_name)

			return netvar
		end

		getfenv(0)[netvar_type] = replacement
	end

	AddClassPostConstruct("widgets/scripterrorwidget", OnGameError)
	AddSimPostInit(function()
		module.write_disk_task = TheGlobalInstance:DoPeriodicTask(3, function()
			module.WriteNetvarDataToDisk()

			if TheNet:GetIsClient() then
				module.LoadServerNetvarData()
				module.CompareDatabaseStateToServer()
			end
		end)
	end)

	xprint("All done!")
	xprint("=====================================================================")


	-- SaveAndShutdown?
	local old_Quit = Sim.Quit
	Sim.Quit = function(...)
		module.OnGameExit()
		return old_Quit(...)
	end
end

SERVER_NETVAR_DATA = {}

module.LoadServerNetvarData = function()
	local f = io.open("netvars_server_1.txt")
	
	SERVER_NETVAR_DATA = {}
	local current = nil

	while true do
		local line = f:read("*line")
		if not line then
			break
		end

		-- GUID:100070 NetworkId:17506 NetvarCount:6 Prefab:scorchedground6
		if line:sub(1,4) == "GUID" then
			local GUID, networkId, netvarCount, prefab = line:match("GUID:(%d+) NetworkId:(%d+) NetvarCount:(%d+) Prefab:([%w_.?-]+)")
			GUID, networkId, netvarCount = tonumber(GUID), tonumber(networkId), tonumber(netvarCount)
			assert(GUID and networkId and netvarCount, "WTF")
			current = {
				networkId = networkId,
				netvarCount = netvarCount,
				netvars = {}
			}

			SERVER_NETVAR_DATA[networkId] = current
		else
			local idx, name, namehash, event, eventhash = line:match("%[(%d+)%] ([^%s]+) %((%d+)%)%s*([%w%d%[%]_.-]+) %((%d+)%)")
			if idx then
				table.insert(current.netvars, {idx=idx, name=name, namehash=namehash, event=event, eventhash=eventhash})
			else
				xprint("Unable to process line?")
				xprint(line)
			end
		end
	end

	f:close()
end

module.CompareDatabaseStateToServer = function()
	if not TheNet:GetIsClient() then
		return
	end

	xprint("Comparing database state to server")

	for GUID, record in pairs(ents_database) do
		local ent = Ents[GUID]
		--xprint("Comparing", ent)
		local network_id = ent and ent.Network and ent.Network:GetNetworkID() or 0
		local prefab = ent and type(ent.prefab)=="string" and #ent.prefab > 0 and ent.prefab or "?"

		if network_id ~= 0 then
			local server_state = SERVER_NETVAR_DATA[network_id]

			if server_state then
				local desync = false
				if server_state.netvarCount ~= #record.netvars then
					xprint(string.format("\tNETVAR COUNT DESYNC ON [%s]: CLIENT: %d, SERVER: %d", tostring(ent), #record.netvars, server_state.netvarCount))
					desync = true
				end

				local client_netvar_names = {}
				
				for i, client_netvar in pairs(record.netvars) do
					client_netvar_names[#client_netvar_names+1] = client_netvar.name
				end
				local c2 = table.invert(client_netvar_names)

				local server_netvar_names = {}
				for i, server_netvar in pairs(server_state.netvars) do
					server_netvar_names[#server_netvar_names+1] = server_netvar.name
				end
				local s2 = table.invert(server_netvar_names)

				local a, b = client_netvar_names, server_netvar_names
				local mode = "client"
				if #server_netvar_names > #client_netvar_names then
					a, b = server_netvar_names, client_netvar_names
					mode = "server"
				end

				local netvar_hashes = {}
				for i,v in pairs(a) do
					local hash = tostring(hash(v))
					if netvar_hashes[hash] then
						print("HASH COLLISION:", v, hash)
					end
					netvar_hashes[hash] = a
				end

				local diff = ExceptionArrays(a, b)

				if #diff > 0 then
					xprint("\tDESYNC:", ent)
					for i,v in pairs(diff) do
						xprint("\t\t", v)
					end
				end
				
				


				--[[
				for i, server_netvar in ipairs(server_state.netvars) do
					local client_netvar = record.netvars[i] or {}

					if desync or client_netvar.name ~= server_netvar.name or client_netvar.event ~= server_netvar.event then
						xprint(string.format("\tClient idx: %s, Server idx: %s", tostring(i), tostring(server_netvar.idx)))
						xprint(string.format("\tClient name: %s, Server name: %s", tostring(client_netvar.name), tostring(server_netvar.name)))
						xprint(string.format("\tClient event: %s, Server event: %s", tostring(client_netvar.event), tostring(server_netvar.event)))
					end
				end
				--]]
			else
				-- This shouldn't be happening...
				-- This seems to happen for a while then gets fixed. Maybe because of differences in the files until they're written?
				--xprint("Missing server state for", ent, network_id)
				--xprint(module.SerializeEntity(GUID))
			end
		end
	end
end

module.WriteNetvarDataToDisk = function()
	local path = "netvars_"
	if TheNet:GetIsClient() then
		path = path .. "client"
	else
		path = path .. "server_" .. TheShard:GetShardId()
	end
	path = path .. ".txt"

	local record_strings = {}

	for GUID in pairs(ents_database) do
		record_strings[#record_strings+1] = module.SerializeEntity(GUID)
	end

	local string = table.concat(record_strings, "\n")

	local f = io.open(path, "w")
	f:write(string)
	f:close()
	xprint("wrote to disk")
end

module.quit_dumped = false
module.OnGameExit = function()
	if module.quit_dumped then
		return
	end
	module.quit_dumped = true

	if module.write_disk_task then
		module.write_disk_task:Cancel()
		module.write_disk_task = nil
	end

	--module.DumpEntityDatabase()
	module.WriteNetvarDataToDisk()
end

module.DumpEntityDatabase = function()
	for GUID in pairs(ents_database) do
		xprint(module.SerializeEntity(GUID))
	end
end

--[[
module.DumpNetvarData = function(entity_record, concat)
	local netvar_strings = {}
	for i, netvar in ipairs(entity_record.netvars) do
		netvar_strings[#netvar_strings+1] = string.format("[%d] %s:\t\t\t%s", i, tostring(netvar.name), tostring(netvar.event))
	end

	return table.concat(netvar_strings, concat), #netvar_strings
end
--]]

--[[
module.DumpNetvarsForEntity = function(GUID)
	local entity = Ents[GUID]
	local record = ents_database[GUID]
	if not record then
		xprint("MISSING RECORD FOR ENTITY:", GUID, entity)
		return
	end

	xprint("DUMPING NETVARS FOR", GUID, entity)
	for i, netvar in ipairs(record.netvars) do
		xprint(string.format("\t[%d] %s:\t\t\t%s", i, tostring(netvar.name), tostring(netvar.event)))
	end
end
--]]

module.SerializeEntity = function(GUID)
	local record = ents_database[GUID]
	local record_string = ""
	local count = 0

	local chunks = {}

	local min_width = 0
	for i, netvar in ipairs(record.netvars) do
		local b = string.format("[%d] %s (%u)", i, tostring(netvar.name), hash(tostring(netvar.name)))
		chunks[i] = b
		min_width = math.max(min_width, #b)
	end

	for i, netvar in ipairs(record.netvars) do
		record_string = record_string .. string.format(
			"\n\t" .. chunks[i] .. "%s%s (%u)", 
			string.rep(" ", min_width - #chunks[i] + 2), 
			tostring(netvar.event),
			hash(tostring(netvar.event))
		)
		count = count + 1
	end

	-- Ents[GUID] and Ents[GUID].prefab or "?"
	local ent = Ents[GUID]
	local network_id = ent and ent.Network and ent.Network:GetNetworkID() or 0
	local prefab = ent and type(ent.prefab)=="string" and #ent.prefab > 0 and ent.prefab or "?"

	record_string = string.format('GUID:%d NetworkId:%d NetvarCount:%d Prefab:%s ' .. string.rep("--", 40), GUID, network_id, count, prefab) .. record_string
	
	return record_string
end

return module