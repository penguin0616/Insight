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

setfenv(1, _G.Insight.env)
-- globalmapicon has some issues. 

local function UpdatePosition(inst)
	local x, y, z = inst.tracked_entity.Transform:GetWorldPosition()
	-- klei
	if inst._x ~= x or inst._z ~= z then
		inst._x = x
		inst._z = z
		inst.Transform:SetPosition(x, 0, z)
	end
end


local function TrackEntity(inst, target)
	if inst.tracked_entity then
		error("attempt to track more than 1 entity")
		return
	end

	inst.tracked_entity = target
	target:ListenForEvent("onremove", function() inst:Remove() end, target)
   	inst:DoPeriodicTask(1, UpdatePosition)
	UpdatePosition(inst)
end

local function OnSetCacheDirty(inst)
	inst.MiniMapEntity:SetCanUseCache(inst.net_set_cache:value())
end

local function OnSetProxyDirty(inst)
	inst.MiniMapEntity:SetIsProxy(inst.net_set_proxy:value())
end

local function OnSetIgnoreFogDirty(inst)
	inst.MiniMapEntity:SetDrawOverFogOfWar(inst.net_set_ignore_fog:value())
end

local function SetCanUseCache(inst, bool)
	inst.MiniMapEntity:SetCanUseCache(bool) -- not necessary but consistency
	inst.net_set_cache:set_local(bool)
	inst.net_set_cache:set(bool)
end

local function SetIsProxy(inst, bool)
	inst.MiniMapEntity:SetIsProxy(bool) -- not necessary but consistency
	inst.net_set_proxy:set_local(bool)
	inst.net_set_proxy:set(bool)
end

local function SetDrawOverFogOfWar(inst, bool)
	inst.MiniMapEntity:SetDrawOverFogOfWar(bool) -- not necessary but consistency
	inst.net_set_ignore_fog:set_local(bool)
	inst.net_set_ignore_fog:set(bool)
end

local function fn()
	local inst = CreateEntity()

	-- adds
	inst.entity:AddTransform()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddNetwork()

	-- tags
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")
	inst:AddTag("CLASSIFIED")
	inst:AddTag("insight_map_marker")

	--inst.MiniMapEntity:SetCanUseCache(true) -- default is true
	--inst.MiniMapEntity:SetIsProxy(true) -- default is false
	--inst.MiniMapEntity:SetDrawOverFogOfWar(true)
	--inst.MiniMapEntity:SetPriority(-5) -- doesn't work at all
	inst.entity:SetCanSleep(false)
	inst.entity:SetPristine()

	inst.net_set_cache = net_bool(inst.GUID, "set_cache", "set_cache_dirty")
	inst.net_set_proxy = net_bool(inst.GUID, "set_proxy", "set_proxy_dirty")
	inst.net_set_ignore_fog = net_bool(inst.GUID, "set_ignore_fog", "set_ignore_fog_dirty")

	if not TheWorld.ismastersim then
		inst:ListenForEvent("set_cache_dirty", OnSetCacheDirty)
		inst:ListenForEvent("set_proxy_dirty", OnSetProxyDirty)
		inst:ListenForEvent("set_ignore_fog", OnSetIgnoreFogDirty)
		return inst
	end

	inst.tracked_entity = nil
	inst.persists = false
	inst.TrackEntity = TrackEntity
	inst.SetCanUseCache = SetCanUseCache
	inst.SetIsProxy = SetIsProxy
	inst.SetDrawOverFogOfWar = SetDrawOverFogOfWar

   	return inst
end

return Prefab("insight_map_marker", fn, {}) 