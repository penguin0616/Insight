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

-- voidcloth_scythe.lua [Prefab]
local scything = {}

local HARVEST_MUSTTAGS  = {"pickable"}
local HARVEST_CANTTAGS  = {"INLIMBO", "FX"}
local HARVEST_ONEOFTAGS = {"plant", "lichen", "oceanvine", "kelp"}

-- Client gets hitbox reveal for scythe.
local function OnClientInit()

end

local function GetAngleFromAToB(A, B)
	-- Math from EntitiyScript:GetAngleToPoint, Idea from searching angle in locomotor
	-- The 180 + seems unncessary.
	
	--local x1, y1, z1 = doer_pos:Get()
	--local x, y, z = target_pos:Get()
	-- local angle = math.atan2(z1 - z, x - x1) * RADIANS
	return math.atan2(A.z - B.z, B.x - A.x) * RADIANS
end

-- This function from Klei
local function IsEntityInFront(inst, entity, doer_rotation, doer_pos)
	local facing = Vector3(math.cos(-doer_rotation / RADIANS), 0 , math.sin(-doer_rotation / RADIANS))

	return IsWithinAngle(doer_pos, facing, TUNING.VOIDCLOTH_SCYTHE_HARVEST_ANGLE_WIDTH, entity:GetPosition())
end

--est = SpawnPrefab("nightstick")

local function UpdateScytheSelection(doer)
	local state = scything[doer]
	
	if not scything[doer] then
		mprint("scything??????")
		return
	end

	local target = state.target

	-- Bear with me, math isn't my strong suit.
	local reap_dist = ACTIONS.SCYTHE.distance

	local doer_pos = doer:GetPosition()
	local target_pos = target:GetPosition()
	local estimated_pos

	local dx = doer_pos.x - target_pos.x
	local dy = doer_pos.y - target_pos.y
	local dz = doer_pos.z - target_pos.z

	local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)

	if magnitude > reap_dist then
		local a, b, c = (dx / magnitude), (dy / magnitude), (dz / magnitude)

		estimated_pos = Vector3(
			Lerp(doer_pos.x, target_pos.x + reap_dist * a, 1),
			Lerp(doer_pos.y, target_pos.y + reap_dist * b, 1),
			Lerp(doer_pos.z, target_pos.z + reap_dist * c, 1)
		)
	else
		-- yay!!
		estimated_pos = doer_pos
	end


 	-- If you do it from estimated_pos, it'll be facing from the 'nightstick' example
	-- Do it from the doer_pos so it'll be as if the target walked there
	local estimated_rotation = GetAngleFromAToB(doer_pos, target_pos)

	-- Logic from Klei
	local x, y, z = estimated_pos:Get()

	local safe = {}

	local ents = TheSim:FindEntities(x, y, z, TUNING.VOIDCLOTH_SCYTHE_HARVEST_RADIUS, HARVEST_MUSTTAGS, HARVEST_CANTTAGS, HARVEST_ONEOFTAGS)
	for _, ent in pairs(ents) do
		if ent:IsValid() then
			if IsEntityInFront(inst, ent, estimated_rotation, estimated_pos) then
				state.got[ent] = true
				safe[ent] = true
				ent.AnimState:SetLightOverride(0.5)
				--ent.AnimState:SetMultColour(1, 0.3, 0.3, 1)
				ent.AnimState:SetAddColour(0.3, 0.1, 0.1, 0.3)
			end
		end
	end

	--state.target.AnimState:SetAddColour(1, 0.1, 0.3, 1)

	for ent in pairs(state.got) do
		if not safe[ent] then
			state.got[ent] = nil
			ent.AnimState:SetLightOverride(0)
			--ent.AnimState:SetMultColour(1, 1, 1, 1)
			ent.AnimState:SetAddColour(0, 0, 0, 0)
		end
	end
end

local function OnScytheTargetSelected(inst, target, doer)
	--print('SELECTED', target, inst, doer)
	scything[doer] = {
		scythe = inst,
		target = target,
		got = {},

		task = doer:DoPeriodicTask(0.1, UpdateScytheSelection)
	}

	-- Hide highlight so we can see our red tint.
	doer.shownothightlight = true
	if target.components.highlight then
		target.components.highlight:UnHighlight()
	end

	UpdateScytheSelection(doer)

	--target.AnimState:SetAddColour(0.1, 0.1, 0.3, 0.3)
end

local function OnScytheTargetUnselected(doer)
	--target.AnimState:SetAddColour(0, 0, 0, 0)
	--print('UNSELECTED', target, doer)

	local state = scything[doer]
	if not state then
		return
	end
	
	doer.shownothightlight = nil
	state.task:Cancel()

	for ent in pairs(state.got) do
		ent.AnimState:SetLightOverride(0)
		--ent.AnimState:SetMultColour(1, 1, 1, 1)
		ent.AnimState:SetAddColour(0, 0, 0, 0)
	end

	scything[doer] = nil
end

return {
	OnClientInit = OnClientInit,
	
	OnScytheTargetSelected = OnScytheTargetSelected,
	OnScytheTargetUnselected = OnScytheTargetUnselected,
}