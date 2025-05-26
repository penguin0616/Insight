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
local RichText = import("widgets/RichText") --FIXED_TEXT

local InsightCrashReportStatus = Class(Widget, function(self, title)
	Widget._ctor(self, "InsightCrashReportStatus")

	self.title = self:AddChild(RichText(UIFONT, 40, title))
	self.message = self:AddChild(RichText(UIFONT, 32))
	--self.message:SetPosition(0, -(40/2 + 32/2 + 5))

	if message then
		self:SetMessage(message)
	end
	
	if color then
		self:SetColor(color)
	end
end)

function InsightCrashReportStatus:SetMessage(msg)
	self.message:SetString(msg)
	local w, h = self.title:GetRegionSize()
	local x, y = self.message:GetRegionSize()
	self.message:SetPosition(0, -(h/2 + y/2 + 5))
end

function InsightCrashReportStatus:SetColor(color)
	self.title:SetColour(color)
	self.message:SetColour(color)
end

return InsightCrashReportStatus