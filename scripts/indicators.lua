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

-- indicators.lua
local Widget = require("widgets/widget")
local InsightTargetIndicator = import("widgets/insight_targetindicator")
local pairs, assert = pairs, assert
local Entity_IsValid = Entity.IsValid
local TheSim = TheSim
local EntityScript_GetPosition = EntityScript.GetPosition

local function IsVector3(arg)
    -- Me
    return arg ~= nil and arg.IsVector3 and arg.IsVector3 == Vector3.IsVector3
end

local function IsOnScreen(target)
	--[[
		-- https://forums.kleientertainment.com/forums/topic/33584-ingame-coordinates-turf-type/
		x, y, z = TheSim:ProjectScreenPos(u, v)
		u2, v2 = TheSim:GetScreenPos(x, y, z)
		assert( math.abs(u - u2) < 0.2 )
		assert( math.abs(v - v2) < 0.2 )
	--]]
	--[[
		-- tried looking up a frustrum thing
				for (i = 0; i < LAST_PLANE; i++)
	{
		if (plane.x > 0) sum = plane.x *max.x;
		else sum = plane.x *min.x;
		if (plane.y > 0) sum += plane.y *max.y;
		else sum += plane.y *min.y;
		if (plane.z > 0) sum += plane.z *max.z;
		else sum += plane.z *min.z;
		if (sum <= -plane.d) return false;
	}
	]]

	--mprint("IsOnScreen", target)
	
	local screen_w, screen_h = TheSim:GetScreenSize()
	local pos = (IsVector3(target) and target) or EntityScript_GetPosition(target)
	local u, v = TheSim:GetScreenPos(pos.x, pos.y, pos.z)

	if (u >= 0 and u <= screen_w) and (v >= 0 and v <= screen_h) then
		return true
	end
	
	return false
end


local function ShouldShowIndicator(player, target, targetIsVector3, max_range)
	-- TUNING.MAX_INDICATOR_RANGE = 50
	max_range = max_range or (50 * 1.5)

	--[[
		frustum is a visibility check: target.entity:FrustumCheck()
		true if at least half entity is visible
		false if not
	--]]

	local visible_check = function()
		if not targetIsVector3 then
			if not Entity_IsValid(target.entity) then
				return true
			end

			if target.entity.FrustumCheck then
				return target.entity:FrustumCheck() -- so if FrustumCheck returns true, at least half of the entity is visible so we should remove the indicator
			end
		end

		return IsOnScreen(target)
	end

	local has_tag = (not targetIsVector3) and (target:HasTag("noplayerindicator") or target:HasTag("hiding"))
	local is_near = false do
		if targetIsVector3 then
			is_near = player:GetDistanceSqToPoint(target) < (max_range * max_range)
		else
			is_near = target:IsNear(player, max_range)
		end
	end

	local PlayerTargetIndicator_ShouldRemoveIndicator = 
		has_tag
        or not is_near
        or visible_check() --[[or
		not CanEntitySeeTarget(player, target)--]]
	
	return not PlayerTargetIndicator_ShouldRemoveIndicator
end

local Indicators = Class(function(self, owner)
	self.owner = owner
	self.indicators = {}
	--self.indicator_root = self.owner.HUD:AddChild(Widget("insight_indicator_root")) -- HUD gone on init in non-caves 
	self.cleanup = setmetatable({}, { __mode="v" })
end)

function Indicators:Get(target)
	for i,v in pairs(self.indicators) do
		if v:GetTarget() == target then
			return v
		end
	end
end

function Indicators:Add(target, data)
	assert(self:Get(target) == nil, "Attempt to create multiple indicators for target")
    local ti = self.owner.HUD.under_root:AddChild(InsightTargetIndicator(self.owner, target, data)) -- self.owner.HUD.under_root
    table.insert(self.indicators, ti)
	return ti
end

function Indicators:Remove(target)
	for i,v in pairs(self.indicators) do
		if v:GetTarget() == target then
			table.remove(self.indicators, i)
			v:Kill()
			break
		end
	end
end

function Indicators:RemoveNextUpdate(target)
	if table.contains(self.cleanup, target) then
		return
	end

	table.insert(self.cleanup, target)
end

function Indicators:Kill()
	self.OnUpdate = function() end
	self.Add = function() error("Killed") end
	for i,v in pairs(self.indicators) do
		v:Kill()
	end
	self.indicators = {}
end

function Indicators:OnUpdate()
	--print'indicators onupdate'
	local cleanup = {}
	for _, indicator in pairs(self.indicators) do
		-- or not Entity_IsValid(indicator.inst.entity)
		if indicator.kill == true or (not indicator.targetIsVector3 and (not Entity_IsValid(indicator.target.entity) or not Entity_IsValid(indicator.inst.entity))) then
			table.insert(cleanup, indicator.target) -- mark bad indicators for cleanup
		else
			local show = ShouldShowIndicator(self.owner, indicator.target, indicator.targetIsVector3, indicator.config_data.max_distance)
			if show then
				indicator:Show()
			else
				if indicator.config_data.removeOnFound == true then
					--dprint'marked for cleanup'
					table.insert(cleanup, indicator.target)
				else
					indicator:Hide()
				end
			end
		end
	end
	-- clean them up
	for _, target in pairs(cleanup) do
		self:Remove(target)
	end

	while #self.cleanup > 0 do
		local i = next(self.cleanup) -- in case gc takes one out
		self:Remove(table.remove(self.cleanup, i))
	end
end

return Indicators