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
local ImageButton = require("widgets/imagebutton")
local PopupDialogScreen = require "screens/redux/popupdialog"

local CrashReportStatus = import("widgets/insight_crashreportstatus")

local InsightServerCrashScreen = Class(Screen, function(self, title)
	Screen._ctor(self, "InsightServerCrash")

	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_TOP)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0, 0, 0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.status = self.root:AddChild(CrashReportStatus(title))
	self.status:SetPosition(0, -30)

	--[[
	self.manual_report_button = self.root:AddChild(ImageButton("images/dst/frontend_redux.xml",
		"listitem_thick_normal.tex", -- normal
		nil, -- focus
		nil,
		nil,
		"listitem_thick_selected.tex" -- selected
	))
	--]]

	-- Screens will have OnUpdate triggered if they are the active one by the frontend
	-- but we want to keep running forever.
	self:StartUpdating()
end)

function InsightServerCrashScreen:SetMessage(message)
	self.status:SetMessage(message)
end

function InsightServerCrashScreen:SetColor(color)
	self.status:SetColor(color)
end

function InsightServerCrashScreen:SetColor(color)
	self.status:SetColor(color)
end

function InsightServerCrashScreen:OnUpdate(dt)
	local active_screen = TheFrontEnd:GetActiveScreen()
	if not active_screen then return end
	local parent_screen = self.root:GetParentScreen()

	if active_screen == self then
		if parent_screen ~= self then
			self:AddChild(self.root)
			self.root.parent_screen = nil -- This is cached for some reason.
			mprint("Reparented status back to screen from (%s)", parent_screen)
		end
	else
		if parent_screen ~= active_screen then
			active_screen:AddChild(self.root)
			self.root.parent_screen = nil -- This is cached for some reason.
			mprintf("Reparented status from (%s) to active screen (%s)", parent_screen, active_screen)
		end 
	--[[
	elseif active_screen._ctor == PopupDialogScreen._ctor then
		if active_screen.dialog.title and active_screen.dialog.title:GetString() == STRINGS.UI.NETWORKDISCONNECT.TITLE["ID_CONNECTION_LOST"] then
			if self.root:GetParentScreen() ~= active_screen then
				active_screen:AddChild(self.root)
				mprint("Reparented status to popup dialog")
			end 
		end
	--]]
	end
end

return InsightServerCrashScreen