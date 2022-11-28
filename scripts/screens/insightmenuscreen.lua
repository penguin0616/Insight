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
local OPEN_MENU = IS_DST and CONTROL_OPEN_CRAFTING or CONTROL_OPEN_DEBUG_MENU

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
	self.menu:Show()

	--self.menu:SetFocus()

	GetLocalInsight(localPlayer):MaintainMenu(self.menu)
	self.default_focus = self.menu
end)

function InsightMenuScreen:GetHelpText()
	local tips = {}

	-- CONTROL_MENU_MISC_3
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), OPEN_MENU) .. " Go Back")
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), self.menu.controls.tab_left) .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), self.menu.controls.tab_right) .. " Switch Tabs")
	table.insert(tips, TheInput:GetLocalizedControl(TheInput:GetControllerID(), self.menu.controls.scroll_up) .. TheInput:GetLocalizedControl(TheInput:GetControllerID(), self.menu.controls.scroll_down) .. " Scroll")

	return table.concat(tips, "   ")
end

-- All is well:
--[[
[00:00:20]: [workshop-2081254154 (Insight)]:	Created InsightMenuScreen ============================================================================
[00:00:20]: [workshop-2081254154 (Insight)]:	About to SetPage
[00:00:20]: [workshop-2081254154 (Insight)]:	SetPage done
[00:00:20]: [workshop-2081254154 (Insight)]:	SetFocusFromChild	INSIGHTMENUSCREEN_ROOT	InsightMenu
[00:00:20]: [workshop-2081254154 (Insight)]:		All Good here.	InsightMenuScreen
[00:00:20]: [workshop-2081254154 (Insight)]:	SetFocusFromChild	InsightMenuScreen	INSIGHTMENUSCREEN_ROOT
[00:00:20]: [workshop-2081254154 (Insight)]:		All Good here.	screenroot
[00:00:20]: [workshop-2081254154 (Insight)]:	SetFocusFromChild	screenroot	InsightMenuScreen
[00:00:21]: [workshop-2081254154 (Insight)]:	------------------------------------------------------------------
[00:00:21]: [workshop-2081254154 (Insight)]:	InsightMenuScreen	self	true	| root	true	| menu	true
[00:00:21]: [workshop-2081254154 (Insight)]:	oncontrol	InsightMenuScreen	47	true	|	true
[00:00:21]: [workshop-2081254154 (Insight)]:		running onto:	INSIGHTMENUSCREEN_ROOT
[00:00:21]: [workshop-2081254154 (Insight)]:	oncontrol	INSIGHTMENUSCREEN_ROOT	47	true	|	true
[00:00:21]: [workshop-2081254154 (Insight)]:		running onto:	InsightMenu
[00:00:21]: [workshop-2081254154 (Insight)]:		InsightMenu OnControl	[CONTROL_INVENTORY_LEFT - 47]	true
[00:00:21]: [workshop-2081254154 (Insight)]:	oncontrol	InsightMenu	47	true	|	true
[00:00:21]: [workshop-2081254154 (Insight)]:		skipping:	Image - :
[00:00:21]: [workshop-2081254154 (Insight)]:		skipping:	Image - ../mods/workshop-2081254154/images/dst/scoreboard.xml:scoreboard_frame.tex
[00:00:21]: [workshop-2081254154 (Insight)]:		skipping:	InsightPage
[00:00:21]: [workshop-2081254154 (Insight)]:		skipping:	InsightPage
]]

-- Clicking might be breaking it.

function InsightMenuScreen:OnControl(control, down)
	-- Trigered from FrontEnd:OnControl
	mprint(string.rep("-", 66))
	mprint("InsightMenuScreen", controlsHelper.Prettify(control), down, "|", "self", self.focus, "| root", self.root.focus, "| menu", self.menu.focus)
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
		if control == CONTROL_PAUSE or control == CONTROL_CANCEL then
			self:Close()
			return true
		end
	end

	--mprint("Delegating", controlsHelper.Prettify(control), down)
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

return InsightMenuScreen