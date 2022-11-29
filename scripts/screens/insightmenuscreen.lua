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
local Screen = require "widgets/screen"
local InsightMenu = import("widgets/insightmenu")

local CONTROL_TYPE = (IS_DST and "MOVE") or "INVENTORY" -- MOVE is the left joystick, INVENTORY is the right one
local MOVE_UP = getfenv(1)[string.format("CONTROL_%s_UP", CONTROL_TYPE)]
local MOVE_DOWN = getfenv(1)[string.format("CONTROL_%s_DOWN", CONTROL_TYPE)]
local MOVE_LEFT = getfenv(1)[string.format("CONTROL_%s_LEFT", CONTROL_TYPE)]
local MOVE_RIGHT = getfenv(1)[string.format("CONTROL_%s_RIGHT", CONTROL_TYPE)]
--local OPEN_MENU = IS_DST and CONTROL_OPEN_CRAFTING or CONTROL_OPEN_DEBUG_MENU

local InsightMenuScreen = Class(Screen, function(self)
	mprint("Created InsightMenuScreen ============================================================================")
	Screen._ctor(self, "InsightMenuScreen")
	self.screen = true

	self.root = self:AddChild(Widget("INSIGHTMENUSCREEN_ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0, 0, 0)
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.menu = self.root:AddChild(InsightMenu())
	self.menu:SetPosition(0, 0)
	self.menu:Activate()

	GetLocalInsight(localPlayer):MaintainMenu(self.menu)
end)

function InsightMenuScreen:OnControl(control, down)
	-- [MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN] doesn't seem to trigger anymore down the focus chain, but worked here in screen previously? What changed??

	-- Trigered from FrontEnd:OnControl
	--mprint(string.rep("-", 66))
	mprint("InsightMenuScreen", controlHelper.Prettify(control), down, "|", "self", self.focus, "| root", self.root.focus, "| menu", self.menu.focus)
	if self.focus and not self.root.focus then
		-- Mouse input broke focus or something. Just fix it.
		dprint("Fixing focus.")
		TheFrontEnd.tracking_mouse = false
		self.menu:NextPage(0)
	end

	if not down then
		--[[
		if control == MOVE_LEFT then
			self.menu:NextPage(-1)
			return true
		elseif control == MOVE_RIGHT then
			self.menu:NextPage(1)
			return true
		end
		--]]
		if controlHelper.controller_scheme:IsAcceptedControl("exit", control) then
			self:Close()
			return true
		end
	end

	--mprint("Delegating", controlHelper.Prettify(control), down)
	return self._base.OnControl(self, control, down)
	--[[
	if control == MOVE_UP then
		--self.menu:GetCurrentPage():ScrollUp()
		self.menu:DelegateControl(control, down)
	elseif control == MOVE_DOWN then
		--self.menu:GetCurrentPage():ScrollDown()
		self.menu:DelegateControl(control, down)
	end
	--]]
end

function InsightMenuScreen:Close()
	TheFrontEnd:PopScreen(self) -- safety?
end

function InsightMenuScreen:GetHelpText()
	local tips = {}

	-- CONTROL_MENU_MISC_3
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), controlHelper.controller_scheme.exit[1]) .. " Go Back") -- OPEN_MENU

	return table.concat(tips, "   ")
end

return InsightMenuScreen