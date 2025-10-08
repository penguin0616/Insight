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

local Widget = require("widgets/widget")
local ImageButton = require("widgets/imagebutton")
local RichText = import("widgets/RichText") --FIXED_TEXT

local InsightCrashReportStatus = Class(Widget, function(self, title)
	Widget._ctor(self, "InsightCrashReportStatus")

	self.title = self:AddChild(RichText(UIFONT, 40, title))
	self.message = self:AddChild(RichText(UIFONT, 32))
	--self.message:SetPosition(0, -(40/2 + 32/2 + 5))

	--self.manual_report_button = self:AddChild(ImageButton("images/global_redux.xml", "button_carny_long_normal.tex", "button_carny_long_hover.tex", "button_carny_long_disabled.tex", "button_carny_long_down.tex"))
	self.manual_report_button = self:AddChild(ImageButton())
	self.manual_report_button:SetImageNormalColour(.1, .8, 1.5, 1)
	self.manual_report_button:SetImageDisabledColour(.3, .3, .3, 1)
	self.manual_report_button:SetImageSelectedColour(.6, .6, .6, 1)
	self.manual_report_button:ForceImageSize(360, 50)
	self.manual_report_button:SetTextSize(28)
	self.manual_report_button:SetText("Report crash anyway")
	self.manual_report_button:Hide()

	self.manual_report_button:SetOnClick(function(...)
		if self.manual_report_callback then
			self.manual_report_callback(...)
		end
		--self.manual_report_button:Select()
	end)

	if message then
		self:SetMessage(message)
	end
	
	--[[
	if color then
		self:SetColor(color)
	end
	--]]
end)

function InsightCrashReportStatus:SetMessage(msg)
	self.message:SetString(msg)
	local w, h = self.title:GetRegionSize()
	local x, y = self.message:GetRegionSize()
	
	local msg_x, msg_y = 0, -(h/2 + y/2 + 5)
	self.message:SetPosition(msg_x, msg_y)

	self.manual_report_button:SetPosition(msg_x, msg_y - h/2 - 25 - 5)
end

function InsightCrashReportStatus:SetColor(color)
	self.title:SetColour(color)
	self.message:SetColour(color)
end

function InsightCrashReportStatus:ShowManualReportButton(enabled)
	if enabled then
		self.manual_report_button:Show()
	else
		self.manual_report_button:Hide()
	end
end

function InsightCrashReportStatus:SetManualReportCallback(callback)
	self.manual_report_callback = callback
end

return InsightCrashReportStatus