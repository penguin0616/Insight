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

local CrashReportStatus = import("widgets/insight_crashreportstatus")

local InsightServerCrashScreen = Class(Screen, function(self, title)
	Screen._ctor(self, "InsightServerCrash")

	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_TOP)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0, 0, 0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

	self.insight_crashreport_status = self.root:AddChild(CrashReportStatus(title))
	self.insight_crashreport_status:SetPosition(0, -60)
end)

function InsightServerCrashScreen:SetMessage(message)
	self.insight_crashreport_status:SetMessage(message)
end

function InsightServerCrashScreen:SetColor(color)
	self.insight_crashreport_status:SetColor(color)
end

return InsightServerCrashScreen