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

local CrashReportStatus = import("widgets/crashreportstatus")

local InsightServerCrash = Class(Screen, function(self, data)
	Screen._ctor(self, "InsightServerCrashed")

	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_TOP)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0, 0, 0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	
	local colour = { 1, 1, 1, 1 }
		
	if data.state == 0 then -- info
		colour = { 0.6, 0.6, 1, 1}
	elseif data.state == 1 then -- error
		colour = { 1, 0.6, 0.6, 1 }
	elseif data.state == 2 then -- good
		colour = { 0.6, 1, 0.6, 1 }
	end 

	data.colour = colour
	data.status = "This server has crashed.\n" .. data.status

	local ui = CrashReportStatus(data)

	self.root:AddChild(ui)
	ui:SetPosition(0, -120)

	mprint("Server Status:", data.status)
	mprint("Server State:", data.state)
end)

return InsightServerCrash