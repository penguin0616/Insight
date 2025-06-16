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

-- cave_entrance.lua [Prefab]
local initialized = false

-- Thought about doing this through shardmigrator, but I'm looking to texture these based off of their prefab.
-- Which could also be done from the shardmigrator, but ehhhhhhhh.
local function OnMigrationAvailable(inst)
	local id = inst.components.worldmigrator.receivedPortal

	local icon_table = (inst.prefab == "cave_entrance_open" and FOREST_MIGRATOR_IMAGES)
		or (inst.prefab == "cave_exit" and CAVE_MIGRATOR_IMAGES)
		or nil

	if not icon_table or not icon_table[id] then
		dprint(string.format("Migrator [%s] does not have anything color bound to it.", id or "nil"))
		return
	end

	local marker = SpawnPrefab("insight_map_marker")
	marker:TrackEntity(inst)
	marker.MiniMapEntity:SetIcon(icon_table[id][1])
	inst.MiniMapEntity:SetIcon(icon_table[id][1]) -- since marker gets removed when it enters vision, this is used.
	--marker.MiniMapEntity:SetCanUseCache(false) -- default true
	--marker.MiniMapEntity:SetIsProxy(false) -- default false
	inst.marker = marker
	dprint(string.format("Migrator [%s] activated.", id))
end

local function OnMigratorSpawned(inst)
	inst:ListenForEvent("migration_available", OnMigrationAvailable)
end

local function Initialize()
	if initialized then
		return
	end

	initialized = true

	AddPrefabPostInit("cave_entrace_open", OnMigratorSpawned)
	AddPrefabPostInit("cave_exit", OnMigratorSpawned)
end

local function OnServerInit()
	Initialize()
end

local function OnClientInit()
	Initialize()
end



return {
	OnServerInit = OnServerInit,
	OnClientInit = OnClientInit
}