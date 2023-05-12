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

-- entitytracker.lua
-- This module is for tracking specific entities (usually to make sure there's just at least 1).


--------------------------------------------------------------------------
--[[ Stuff ]]
--------------------------------------------------------------------------
local module = {
	prefabs_to_track = {}, -- Should be populated before prefabs get loaded in.
	components_to_track = {} -- Same.
}

--------------------------------------------------------------------------
--[[ Functions ]]
--------------------------------------------------------------------------
local function OnTrackedEntitySpawned(inst)
	local tbl = module.prefabs_to_track[inst.prefab] -- Breaks the immersion, doesn't it?
	if not tbl then
		error("Somehow tracking a prefab without it being tracked?")
		return
	end

	if table.contains(tbl, inst) then
		error("Duplicated inst in prefabs_to_track")
		return
	end

	table.insert(tbl, inst)
	inst:ListenForEvent("onremove", function(inst)
		local index = table.reverselookup(tbl, inst)
		if index then
			table.remove(tbl, index)
		end
	end)
end

--[[
local function OnComponentPostInit(cmp)
	local inst = cmp.inst
	
	if not module.prefabs_to_track[inst.prefab] then
		module:TrackPrefab(inst.prefab)
	end

	return OnTrackedEntitySpawned(inst)
end
--]]

--[[
-- @tparam Component cmp
-- @tparam string name
local function OnComponentPostInit(cmp, name)
	if not module.components_to_track[name] then
		error("Somehow tracking a component without it being tracked?")
		return
	end

	local inst = cmp.inst
end
--]]

--[[
--- Tracks an entity
-- @tparam Entity inst
function module:TrackEntity(inst)
	if self.prefabs_to_track[inst.prefab] then
		OnTrackedEntitySpawned(inst)
		return
	end

	return self:TrackPrefab(inst.prefab)
end
--]]

--[[
--- Tracks a component. Really fits with the name & theme huh?
-- This is kind of unnecessary but it's kinda "ehhh".
-- @tparam string component
function module:TrackComponent(component)
	if self.components_to_track[component] then
		error("Attempt to track component more than once.")
		return
	end

	self.components_to_track[component] = {} -- Ehhhhh
	AddComponentPostInit(component, function(cmp) OnComponentPostInit(cmp, component) end)
end
--]]


--[[
--- Tracks a component. If a component gets added to the entity, it starts getting tracked.
-- This is kind of unnecessary but it's kinda "ehhh".
-- @tparam string component
function module:TrackComponentEntities(component)
	if self.components_to_track[component] then
		error("Attempt to track component more than once.")
		return
	end

	self.components_to_track[component] = true

	AddComponentPostInit(component, OnComponentPostInit)
end
--]]

--- Tracks a prefab
-- @tparam string prefab
function module:TrackPrefab(prefab)
	if self.prefabs_to_track[prefab] then
		error("Attempt to track prefab more than once.")
		return
	end

	self.prefabs_to_track[prefab] = {}
	AddPrefabPostInit(prefab, OnTrackedEntitySpawned)
end

--- Counts instances of the tracked prefab
-- If the prefab is not tracked, it will return 0.
function module:CountInstancesOf(prefab)
	if not self.prefabs_to_track[prefab] then
		return 0
	end

	return #self.prefabs_to_track[prefab]
end

function module:GetInstancesOf(prefab)
	if not self.prefabs_to_track[prefab] then
		return {}
	end

	return self.prefabs_to_track[prefab]
end

--- Checks if there is at least 1 instance of the tracked prefab
function module:WorldHasInstanceOf(prefab)
	return self:CountInstancesOf(prefab) > 0
end

return module