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

--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local Entity_HasTag = Entity.HasTag

local PREFABS_TO_IGNORE = {}

local is_dst = IsDST()
local is_ds = IsDS()
local is_client_host = IsClientHost()
local manager = nil

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------

local function SetEntitySleep(inst)
	if manager.active_entities[inst] == nil then
		return
	end
	
	manager.active_entities[inst] = nil
	manager.active_entity_lookup[inst.GUID] = nil
	manager.entity_count = manager.entity_count - 1
	 
	manager:PushEvent("sleep", inst)
end

local function SetEntityAwake(inst)
	if manager.active_entities[inst] then
		return
	end

	if not inst.components.spawnfader and Entity_HasTag(inst.entity, "NOCLICK") then 
		if inst.replica then 
			if inst.replica.inventoryitem == nil then
				return
			end
		else
			if inst.components.inventoryitem == nil then
				return
			end
		end
	end
	
	manager.active_entities[inst] = true
	manager.active_entity_lookup[inst.GUID] = inst
	manager.entity_count = manager.entity_count + 1

	manager:PushEvent("awake", inst)
end

--------------------------------------------------------------------------
--[[ EntityManager ]]
--------------------------------------------------------------------------

local EntityManager = Class(function(self)
	self.active_entities = setmetatable(createTable(1000), { __mode="kv" })
	self.active_entity_lookup = setmetatable(createTable(1000), { __mode="kv" })
	self.entity_count = 0
	self.listeners = {}
	--self.chests = setmetatable(createTable(250), { __mode="k" }) -- used for highlighting, and that meant item highlighting didnt work since it only considered chests
end)

function EntityManager.Manage(inst)
	if PREFABS_TO_IGNORE[inst.prefab] then
		return
	end

	if not inst.Transform or not inst.AnimState then
		--[[
		print(string.format("DENIED: %s | FX: %s, %s | DECOR: %s | CLASSIFIED: %s", 
			tostring(inst), 
			tostring(inst:HasTag("fx")), 
			tostring(inst:HasTag("FX")), -- case doesn't matter
			tostring(inst:HasTag("DECOR")), 
			tostring(inst:HasTag("CLASSIFIED"))
		))
		--]]
		PREFABS_TO_IGNORE[inst.prefab] = true
		return
	elseif Entity_HasTag(inst.entity, "fx") or Entity_HasTag(inst.entity, "decor") or Entity_HasTag(inst.entity, "classified") then
		PREFABS_TO_IGNORE[inst.prefab] = true
		return
	end
	
	-- localPlayer.replica.insight:EntityActive(inst)
	inst:ListenForEvent("entitysleep", SetEntitySleep)
	inst:ListenForEvent("entitywake", SetEntityAwake)
	inst:ListenForEvent("onremove", SetEntitySleep)

	if not is_client_host or (is_client_host and inst.entity:IsAwake()) then
		SetEntityAwake(inst)
	end
end


function EntityManager:Count()
	return self.entity_count
end


function EntityManager:IsEntityActive(entity)
	return self.active_entities[entity] ~= nil
end

function EntityManager:AddListener(key, func)
	assert(self.listeners[key]==nil, "Unable to overwrite previous listener")

	self.listeners[key] = func
end

function EntityManager:RemoveListener(key)
	self.listeners[key] = nil
end

function EntityManager:PushEvent(name, ...)
	for key, fn in pairs(self.listeners) do
		fn(self, name, ...)
	end
end


manager = EntityManager()

return manager