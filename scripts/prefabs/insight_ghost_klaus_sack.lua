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

local assets = {
    Asset("ANIM", "anim/klaus_bag.zip"),
}

local function CheckForKlausSack(inst)
	local x, y, z = inst.Transform:GetWorldPosition()
	local found = TheSim:FindEntities(x, y, z, 2, {"klaussacklock"})
	if #found > 0 then
		inst.AnimState:SetMultColour(0, 0, 0, 0) -- 0.7, 0.7, 0.7, 0 is weird
	else
		inst.AnimState:SetMultColour(0.3, 0.3, 0.3, 0.3)
	end
end

local function FollowOwner(inst)
	if not inst.owner then
		return
	end

	if not inst.owner:IsValid() then
		inst:Remove()
		return
	end

	local x, y, z = inst.Transform:GetWorldPosition()
	local px, py, pz = inst.owner.Transform:GetWorldPosition()

	if x ~= px or y ~= py or z ~= pz then
		inst.Transform:SetPosition(px, py, pz)
	end
end



local function fn()
	local inst = CreateEntity()

	-- adds
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()

	-- tags
	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")

	-- anims
	inst.AnimState:SetBank("klaus_bag")
    inst.AnimState:SetBuild("klaus_bag")
    inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:SetMultColour(0.2, 0.2, 0.2, .4)

	inst.entity:SetPristine()
	if not TheWorld.ismastersim then
		return inst
	end

	inst:DoPeriodicTask(1, CheckForKlausSack)
	inst:DoPeriodicTask(1, FollowOwner)

	inst.persists = false

   	return inst
end

return Prefab("insight_ghost_klaus_sack", fn, assets) 