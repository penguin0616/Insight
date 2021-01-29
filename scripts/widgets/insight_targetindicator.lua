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
-- Additional Note: Sections marked as me or klei continue until the next comment indicates or the function ends

-- Me
local Is_DST = IsDST()
local Remap = Remap
local Entity_IsValid = Entity.IsValid

local Image = require "widgets/image"
local Widget = require "widgets/widget"
local Text = require("widgets/text") --FIXED_TEXT
local RichText = import("widgets/RichText")
local imageLib = import("widgets/image_lib")

local MIN_INDICATOR_RANGE = 20 --TUNING.MIN_INDICATOR_RANGE or 20 -- global positions messes with this
local MAX_INDICATOR_RANGE = 50 --TUNING.MAX_INDICATOR_RANGE or 50 -- global positions messes with this
local PORTAL_TEXT_COLOUR = Color.new(unpack(PORTAL_TEXT_COLOUR or {243/255, 244/255, 243/255, 255/255}))

local ARROW_OFFSET = 65

local TOP_EDGE_BUFFER = 20
local BOTTOM_EDGE_BUFFER = 40
local LEFT_EDGE_BUFFER = 67
local RIGHT_EDGE_BUFFER = 80

local MIN_SCALE = .5
local MIN_ALPHA = .35

local DEFAULT_ATLAS = "images/dst/avatars.xml"
local DEFAULT_AVATAR = "avatar_unknown.tex"

local function IsVector3(arg)
	-- Me
	return arg ~= nil and arg.IsVector3 and arg.IsVector3 == Vector3.IsVector3
end

local function CancelIndicator(inst)
	-- Klei
	inst.startindicatortask:Cancel()
	inst.startindicatortask = nil
	inst.OnRemoveEntity = nil
end

local function StartIndicator(target, self)
	-- Klei
	self.inst.startindicatortask = nil
	self.inst.OnRemoveEntity = nil
	-- Me
	self.colour = (target.playercolour and Color.new(unpack(target.playercolour))) or self.config_data.color or PORTAL_TEXT_COLOUR
	-- Klei
	self:StartUpdating()
	self:OnUpdate()
	self:Show()
end

local InsightTargetIndicator = Class(Widget, function(self, owner, target, data)
	-- Me
	Widget._ctor(self, "InsightTargetIndicator")
	-- Klei
	self.owner = owner
	self.isFE = false
	self:SetClickable(true)

	self.root = self:AddChild(Widget("root"))
	-- self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.icon = self.root:AddChild(Widget("target"))

	-- Me
	self.userflags = 0
	self.isGhost = false
	self.isCharacterState1 = false
	self.isCharacterState2 = false
	self.isCharacterState3 = false

	-- Klei
	self.is_mod_character = target ~= nil and target.prefab ~= nil and table.contains(MODCHARACTERLIST, target.prefab)
	self.config_data = data or {}
	-- Me
	self:SetTarget(target)
	self.colour = nil
	self.headbg = self.icon:AddChild(Image()) -- bg
	imageLib.SetTexture(self.headbg, DEFAULT_ATLAS, self.isGhost and "avatar_ghost_bg.tex" or "avatar_bg.tex")
	self.headbg:SetSize(95, 95) -- default is 95

	self.head = self.icon:AddChild(Image()) -- icon
	imageLib.SetTexture(self.head, self:GetAvatarAtlas(), self:GetAvatar(), DEFAULT_AVATAR)
	self.head:SetSize(64, 64)
	
	self.headframe = self.icon:AddChild(Image()) -- ring
	imageLib.SetTexture(self.headframe, DEFAULT_ATLAS, "avatar_frame_white.tex")
	self.headframe:SetSize(95, 95) -- default is 95

	--self.icon:SetScale(0.8)

	self.arrow = self.root:AddChild(Image())
	imageLib.SetTexture(self.arrow, "images/ui.xml", "scroll_arrow.tex")
	self.arrow:SetScale(.5)

	--self.name = target:GetDisplayName() -- taken care of
	self.name_label = self.icon:AddChild(RichText(UIFONT, 45, self.name)) -- Text(UIFONT, 45, self.name)
	self.name_label:SetPosition(0, 80, 0) 
	self.name_label:Hide()

	self.update_count = 0

	self:Hide()
	self.inst.startindicatortask = self.inst:DoTaskInTime(0, StartIndicator, self)
	self.inst.OnRemoveEntity = CancelIndicator
end)

function InsightTargetIndicator:OnGainFocus()
	-- Klei
	InsightTargetIndicator._base.OnGainFocus(self)
	self.name_label:Show()

end

function InsightTargetIndicator:OnLoseFocus()
	-- Klei
	InsightTargetIndicator._base.OnLoseFocus(self)
	self.name_label:Hide()
end

function InsightTargetIndicator:UpdateName()
	-- Me
	-- Wagstaff vision & Wetness & Whatnot
	if self.config_data.name then
		self.name = self.config_data.name
	elseif self.targetIsVector3 then
		self.name = "Vector3" .. tostring(self.target)
	else
		self.name = self.target:GetDisplayName()
	end

	if self.name_label then
		self.name_label:SetString(self.name)
	end
end

function InsightTargetIndicator:SetTarget(target)
	-- Me
	self.target = target
	self.targetIsVector3 = IsVector3(self.target)

	self:UpdateName()
end

function InsightTargetIndicator:GetTarget()
	-- Klei
	return self.target
end

function InsightTargetIndicator:GetTargetIndicatorAlpha(dist)
	-- Klei
	if dist > MAX_INDICATOR_RANGE*2 then
		dist = MAX_INDICATOR_RANGE*2
	end
	local alpha = Remap(dist, MAX_INDICATOR_RANGE, MAX_INDICATOR_RANGE*2, 1, MIN_ALPHA)
	if dist <= MAX_INDICATOR_RANGE then
		alpha = 1
	end
	return alpha
end

function InsightTargetIndicator:OnUpdate()
	-- figure out how far away they are and scale accordingly
	-- then grab the new position of the target and update the HUD elt's pos accordingly
	-- kill on this is rough: it just pops in/out. would be nice if it faded in/out...

	-- Me
	if self.target ~= nil and not self.targetIsVector3 and (not Entity_IsValid(self.target.entity) or not Entity_IsValid(self.inst.entity)) then
		-- wait to be cleaned up by Insight
		--dprint('cleanup waiting for', self.target)
		return
	end

	local userflags = self.target ~= nil and not self.targetIsVector3 and self.target.Network ~= nil and self.target.Network:GetUserFlags() or 0
	-- Klei
	if self.userflags ~= userflags then
		self.userflags = userflags
		self.isGhost = checkbit(userflags, USERFLAGS.IS_GHOST)
		self.isCharacterState1 = checkbit(userflags, USERFLAGS.CHARACTER_STATE_1)
		self.isCharacterState2 = checkbit(userflags, USERFLAGS.CHARACTER_STATE_2)
		self.isCharacterState3 = checkbit(userflags, USERFLAGS.CHARACTER_STATE_3)
		imageLib.SetTexture(self.headbg, DEFAULT_ATLAS, self.isGhost and "avatar_ghost_bg.tex" or "avatar_bg.tex")
		imageLib.SetTexture(self.head, self:GetAvatarAtlas(), self:GetAvatar(), DEFAULT_AVATAR)
	end

	-- Me
	local dist = 0
	local target_pos

	if self.targetIsVector3 then
		dist = self.owner:GetDistanceSqToPoint(self.target)
		target_pos = self.target
	elseif self.target ~= nil then
		dist = self.owner:GetDistanceSqToInst(self.target)
		target_pos = self.target:GetPosition()
	else
		target_pos = Vector3(0, 0, 0)
	end

	dist = math.sqrt(dist)

	local alpha = self:GetTargetIndicatorAlpha(dist)
	--self.headbg:SetTint(self.colour[1], self.colour[2], self.colour[3], alpha) --self.headbg:SetTint(1, 1, 1, alpha)
	--self.headbg:SetTint(0.5 + self.colour[1]/2, 0.5 + self.colour[2]/2, 0.5 + self.colour[3]/2, alpha)
	local bgclr = self.colour/2 + 0.5
	self.headbg:SetTint(bgclr.r, bgclr.g, bgclr.b, alpha)
	self.name_label:SetColour(self.colour)

	-- Klei
	self.head:SetTint(1, 1, 1, alpha)
	self.headframe:SetTint(self.colour[1], self.colour[2], self.colour[3], alpha)
	self.arrow:SetTint(self.colour[1], self.colour[2], self.colour[3], alpha)
	

	if dist < MIN_INDICATOR_RANGE then
		dist = MIN_INDICATOR_RANGE
	elseif dist > MAX_INDICATOR_RANGE then
		dist = MAX_INDICATOR_RANGE
	end
	local scale = Remap(dist, MIN_INDICATOR_RANGE, MAX_INDICATOR_RANGE, 1, MIN_SCALE)
	self:SetScale(scale)

	-- Me
	local x, y, z = target_pos:Get()
	self:UpdatePosition(x, z)

	self.update_count = self.update_count + 1
	if self.update_count > 10 then
		self:UpdateName()
		self.update_count = 0
	end
end

local function GetXCoord(angle, width)
	if angle >= 90 and angle <= 180 then -- left side
		return 0
	elseif angle <= 0 and angle >= -90 then -- right side
		return width
	else -- middle somewhere
		if angle < 0 then
			angle = -angle - 90
		end
		local pctX = 1 - (angle / 90)
		return pctX * width
	end
end

local function GetYCoord(angle, height)
	if angle <= -90 and angle >= -180 then -- top side
		return height
	elseif angle >= 0 and angle <= 90 then -- bottom side
		return 0
	else -- middle somewhere
		if angle < 0 then
			angle = -angle
		end
		if angle > 90 then
			angle = angle - 90
		end
		local pctY = (angle / 90)
		return pctY * height
	end
end

function InsightTargetIndicator:UpdatePosition(targX, targZ)
	-- Klei
	local angleToTarget = self.owner:GetAngleToPoint(targX, 0, targZ)
	local downVector = TheCamera:GetDownVec()
	local downAngle = -math.atan2(downVector.z, downVector.x) / DEGREES
	local indicatorAngle = (angleToTarget - downAngle) + 45
	while indicatorAngle > 180 do indicatorAngle = indicatorAngle - 360 end
	while indicatorAngle < -180 do indicatorAngle = indicatorAngle + 360 end

	local scale = self:GetScale()
	local w = 0
	local h = 0
	local w0, h0 = self.head:GetSize()
	local w1, h1 = self.arrow:GetSize()
	if w0 and w1 then
		w = (w0 + w1)
	end
	if h0 and h1 then
		h = (h0 + h1)
	end

	local screenWidth, screenHeight = TheSim:GetScreenSize()

	local x = GetXCoord(indicatorAngle, screenWidth)
	local y = GetYCoord(indicatorAngle, screenHeight)

	if x <= LEFT_EDGE_BUFFER + (.5 * w * scale.x) then 
		x = LEFT_EDGE_BUFFER + (.5 * w * scale.x)
	elseif x >= screenWidth - RIGHT_EDGE_BUFFER - (.5 * w * scale.x) then
		x = screenWidth - RIGHT_EDGE_BUFFER - (.5 * w * scale.x)
	end

	if y <= BOTTOM_EDGE_BUFFER + (.5 * h * scale.y) then 
		y = BOTTOM_EDGE_BUFFER + (.5 * h * scale.y)
	elseif y >= screenHeight - TOP_EDGE_BUFFER - (.5 * h * scale.y) then
		y = screenHeight - TOP_EDGE_BUFFER - (.5 * h * scale.y)
	end

	self:SetPosition(x,y,0)
	self.x = x
	self.y = y
	self.angle = indicatorAngle
	self:PositionArrow()
	self:PositionLabel()
end

function InsightTargetIndicator:PositionArrow()
	-- Klei
	if not self.x and self.y and self.angle then return end

	local angle = self.angle + 45
	self.arrow:SetRotation(angle)
	local x = math.cos(angle*DEGREES) * ARROW_OFFSET
	local y = -(math.sin(angle*DEGREES) * ARROW_OFFSET)
	self.arrow:SetPosition(x, y, 0)
end

function InsightTargetIndicator:PositionLabel()
	-- Klei
	if not self.x and self.y and self.angle then return end

	local angle = self.angle + 45 - 180
	local x = math.cos(angle*DEGREES) * ARROW_OFFSET * 1.75
	local y = -(math.sin(angle*DEGREES) * ARROW_OFFSET  * 1.25)
	self.name_label:SetPosition(x, y, 0)
end

function InsightTargetIndicator:GetAvatarAtlas()
	-- Me
	if self.is_mod_character and self.target ~= nil and not self.targetIsVector3 then
		-- Klei
		local location = MOD_AVATAR_LOCATIONS["Default"]
		if MOD_AVATAR_LOCATIONS[self.target.prefab] ~= nil then
			location = MOD_AVATAR_LOCATIONS[self.target.prefab]
		end

		local starting = self.isGhost and "avatar_ghost_" or "avatar_"
		local ending =
			(self.isCharacterState1 and "_1" or "")..
			(self.isCharacterState2 and "_2" or "")..
			(self.isCharacterState3 and "_3" or "")

		return location..starting..self.target.prefab..ending..".xml"
	end

	-- Me
	return self.config_data.atlas or DEFAULT_ATLAS
end

function InsightTargetIndicator:GetAvatar()
	-- Me
	if self.config_data.tex ~= nil then
		return self.config_data.tex
	end

	-- Klei
	local starting = self.isGhost and "avatar_ghost_" or "avatar_"
	local ending =
		(self.isCharacterState1 and "_1" or "")..
		(self.isCharacterState2 and "_2" or "")..
		(self.isCharacterState3 and "_3" or "")

	-- Me
	return self.target ~= nil 
		and not self.targetIsVector3
		-- Klei
		and self.target.prefab ~= nil
		and self.target.prefab ~= ""
		and (starting..self.target.prefab..ending..".tex")
		or (starting.."unknown.tex")
end

return InsightTargetIndicator
