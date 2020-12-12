--[[
Copyright (C) 2020 penguin0616

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
local Screen = require "widgets/screen"
local InsightMenu = import("widgets/insightmenu")

local CONTROL_TYPE = (IsDST() and "MOVE") or "INVENTORY" -- MOVE is the left joystick, INVENTORY is the right one
local MOVE_UP = getfenv(1)[string.format("CONTROL_%s_UP", CONTROL_TYPE)]
local MOVE_DOWN = getfenv(1)[string.format("CONTROL_%s_DOWN", CONTROL_TYPE)]
local MOVE_LEFT = getfenv(1)[string.format("CONTROL_%s_LEFT", CONTROL_TYPE)]
local MOVE_RIGHT = getfenv(1)[string.format("CONTROL_%s_RIGHT", CONTROL_TYPE)]
local OPEN_MENU = IsDST() and CONTROL_OPEN_CRAFTING or CONTROL_OPEN_DEBUG_MENU

local InsightMenuScreen = Class(Screen, function(self)
	Screen._ctor(self, "InsightMenuScreen")

	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0, 0, 0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.menu = self.root:AddChild(InsightMenu())
	self.menu:SetPosition(0, 0)
	self.menu:Show()

	GetInsight(localPlayer):MaintainMenu(self.menu)
end)

function InsightMenuScreen:GetHelpText()
	local tips = {}

	-- CONTROL_MENU_MISC_3
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), OPEN_MENU) .. " Go Back")
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), MOVE_LEFT) .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), MOVE_RIGHT) .. " Switch Tabs")
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), MOVE_UP) .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), MOVE_DOWN) .. " Scroll")

	return table.concat(tips, "   ")
end

function InsightMenuScreen:OnControl(control, down)
	print(control, down)
	if down then
		if control == MOVE_UP then
			self.menu:GetCurrentPage().list:Scroll(-1) -- 1 entry
		elseif control == MOVE_DOWN then
			self.menu:GetCurrentPage().list:Scroll(1) -- 1 entry
		elseif control == MOVE_LEFT then
			self.menu:NextPage(-1)
		elseif control == MOVE_RIGHT then
			self.menu:NextPage(1)
		elseif control == CONTROL_PAUSE or control == CONTROL_CANCEL then
			self:Close()
		end
	end
end

function InsightMenuScreen:Close()
	TheFrontEnd:PopScreen(self) -- safety?
end

return InsightMenuScreen