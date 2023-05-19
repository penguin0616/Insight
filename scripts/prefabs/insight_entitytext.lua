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

local function UpdatePosition(inst)
	if not inst.target then
		return
	end

	local x, y, z = inst.target.Transform:GetWorldPosition()
	if inst._x ~= x or inst._z ~= z then
		inst._x = x
		inst._z = z
		inst.Transform:SetPosition(x, 0, z)
	end
end

local function OnTargetRemoved(inst)
	SetTarget(inst, nil)
end


local function SetTarget(inst, target)
	if inst.target then
		inst.target:RemoveEventCallback("onremove", OnTargetRemoved)
	end

	inst.target = target

	if target then
		if not inst.task then
			inst.task = inst:DoPeriodicTask(FRAMES, UpdatePosition)
		end

		target:ListenForEvent("onremove", OnTargetRemoved)
	else
		if inst.task then
			inst.task:Cancel()
			inst.task = nil
		end
	end
end

local function SetText(inst, text)
	if text == nil or text == "" then
		inst.label:SetText("")
		inst.label:Enable(false)
	else
		inst.label:SetText(text)
		inst.label:Enable(true)
	end
end

local function Clear(inst)
	inst:SetTarget(nil)
	inst:SetText(nil)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()

	inst:AddTag("NOBLOCK")
	inst:AddTag("NOCLICK")

	inst.persists = false

	local label = inst.entity:AddLabel()
	label:SetWorldOffset(0, -1, 0)
	label:SetFont(CHATFONT_OUTLINE)
	label:SetFontSize(18)
	label:Enable(false)
	label:SetText("")

	inst.label = label

	inst.SetTarget = SetTarget
	inst.SetText = SetText
	inst.Clear = Clear

	return inst
end

return Prefab("insight_entitytext", fn) 