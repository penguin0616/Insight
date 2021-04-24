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

local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"

local InsightButton = Class(Widget, function(self)
	Widget._ctor(self, "Menu Button")

	self.allowcontroller = true
	self.can_be_shown = true

	self.inst:DoPeriodicTask(0.5, function()
		if self.allowcontroller then
			return
		end

		if not self.can_be_shown or TheInput:ControllerAttached() then
			self:Hide()
		elseif self.can_be_shown then
			self:Show()
		end
	end)

	self.button = self:AddChild(ImageButton("images/Blueprint.xml", "Blueprint.tex", nil, nil, nil, nil, {1,1}, {0,0}))
	self.button:SetTooltip("Insight")

	self:SetOnClick()

	self.drag_tolerance = 4
	self:SetDraggable(false)
	self:SetOnDragFinish(nil)
end)

function InsightButton:SetDraggable(bool)
	self.draggable = bool
end

function InsightButton:SetOnDragFinish(fn)
	self.ondragfinish = fn
end


function InsightButton:SetOnClick(fn)
	self.onclick = fn
end

function InsightButton:OnControl(control, down)
	Widget.OnControl(self, control, down)

	--print(control, down)
	if control == CONTROL_ACCEPT then
		if down then
			if self.draggable then
				self:BeginDrag()
			end
		else
			--print(self:HasMoved())
			if not self:HasMoved() then
				if self.onclick then
					self.onclick()
				end
			end
			self:EndDrag()
		end
	end
end

function InsightButton:OnGainFocus()
	--mprint("gained focus")
end

function InsightButton:OnLoseFocus()
	if self:IsDragging() then
		self:EndDrag()
		mprint('still dragging')
	end
	--mprint("lost focus")
end

function InsightButton:HasMoved()
	if self._drag_origin == nil then
		return false
	end

	local bx, by, bz = self._drag_origin:Get()
	local x, y, z = self:GetPosition():Get()

	if math.abs(x - bx) + math.abs(y - by) >= self.drag_tolerance then
		return true
	end

	return false
end

function InsightButton:IsDragging()
	return self._draghandler ~= nil
end

function InsightButton:BeginDrag()
	if self:IsDragging() then
		dprint("ALREADY DRAGGING")
		return
	end

	--print(self:GetPosition(), self:GetWorldPosition())
	self._drag_origin = self:GetPosition()
	local pos = self._drag_origin

	self._draghandler = TheInput:AddMoveHandler(function(x,y)
		local deltax = x - (TheFrontEnd.lastx or x)
		local deltay = y - (TheFrontEnd.lasty or y)

		local scale = self:GetScale()
		local screen_width, screen_height = TheSim:GetScreenSize()
		screen_width = screen_width / scale.x
		screen_height = screen_height / scale.y

		deltax = deltax / scale.x
		deltay = deltay / scale.y

		local nx = pos.x + deltax
		local ny = pos.y + deltay

		--print(ny)

		local a, b = self.button:GetSize()

		nx = math.clamp(nx, -screen_width + a/2, -a/2) -- 0,0 is bottom right of screen
		ny = math.clamp(ny, b/2, screen_height - b/2)
		

		--print(ny, h)
		
		pos = Vector3(nx, ny, pos.z)
		self:SetPosition(pos)
	end)
end

function InsightButton:EndDrag()
	if not self:IsDragging() then -- checks self._draghandler
		return
	end

	self._draghandler:Remove()

	if self.ondragfinish and self:HasMoved() then
		self.ondragfinish(self._dragorigin, self:GetPosition())
	end

	self._dragorigin = nil
	self._draghandler = nil
end






return InsightButton