
setfenv(1, _G.Insight.env)
-- globalmapicon has some issues. 

local function UpdatePosition(inst)
	local x, y, z = inst.tracked_entity.Transform:GetWorldPosition()
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

	inst.MiniMapEntity:SetCanUseCache(true)
	inst.MiniMapEntity:SetIsProxy(true)
	--inst.MiniMapEntity:SetDrawOverFogOfWar(true)
	inst.entity:SetCanSleep(false)
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end

	inst.tracked_entity = nil
	inst.TrackEntity = TrackEntity
	inst.persists = false

   	return inst
end

return Prefab("insight_map_marker", fn, {}) 