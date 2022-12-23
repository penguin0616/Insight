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

-- This is the recipe lookup button related stuff.
local module = {
	current_focused_badge = nil
}

local Text = require("widgets/text")

--- Triggered whenver the inspect key is pressed.
-- Digital is a boolean, while analog is an integer representing a boolean.
local function InspectListener(digital, analog)
	if not module.current_focused_badge then
		return
	end

	if digital then
		module.current_focused_badge.num:Hide()
		module.current_focused_badge.insight_rate:Show()
	else
		module.current_focused_badge.num:Show()
		module.current_focused_badge.insight_rate:Hide()
	end
end

local function OnStatBadgePostConstruct(self)
	if not self.num then
		-- Just in case...
		return
	end

	self.insight_rate = self:AddChild(Text(BODYTEXTFONT, 33))
    self.insight_rate:SetHAlign(ANCHOR_MIDDLE)
    self.insight_rate:SetPosition(3, 0, 0)
    self.insight_rate:Hide()

	local oldOnGainFocus = self.OnGainFocus
	self.OnGainFocus = function(self, ...)
		module.current_focused_badge = self

		if TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
			self.insight_rate:Show()
		else
			if oldOnGainFocus then
				return oldOnGainFocus(self, ...)
			end
		end
	end


	local oldOnLoseFocus = self.OnLoseFocus
	self.OnLoseFocus = function(self, ...)
		module.current_focused_badge = nil

		if self.insight_rate.shown then
			self.insight_rate:Hide()
		end

		if oldOnLoseFocus then
			return oldOnLoseFocus(self, ...)
		end
	end
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	
	--AddClassPostConstruct("widgets/hungerbadge", OnStatBadgePostConstruct)
	AddClassPostConstruct("widgets/sanitybadge", OnStatBadgePostConstruct)
	--AddClassPostConstruct("widgets/healthbadge", OnStatBadgePostConstruct) -- No actual "rate" stuff here.
	if IS_DST then
		AddClassPostConstruct("widgets/moisturemeter", OnStatBadgePostConstruct)
	end
	
	TheInput:AddControlHandler(CONTROL_FORCE_INSPECT, InspectListener)
end

return module