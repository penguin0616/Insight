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

local module = {}

local RichText = import("widgets/RichText")
local UpgradeModulesDisplayExists = pcall(function() return require("widgets/recipepopup") end) -- Old recipe popup

local Y_OFFSET = -120

--ThePlayer.HUD.controls.secondary_status.upgrademodulesdisplay.battery_frame:Kill()

local function UpdateChargeLabel(self)
	if not localPlayer then return end
	if not self.insightChargeTimeLabel then return end
	local context = GetPlayerContext(localPlayer)
	local info = localPlayer.replica.insight:GetInformation(localPlayer)
	if info.special_data.wx78.time_to_gain_charge then
		
		self.insightChargeTimeLabel:SetString(
			string.format(
				context.lstr.wx78.gain_charge_time, 
				context.time:SimpleProcess(info.special_data.wx78.time_to_gain_charge)
			)
		)
		local width = self.insightChargeTimeLabel:GetRegionSize()
		self.insightChargeTimeLabel:SetPosition(-width/2 + 10, Y_OFFSET)
	else
		self.insightChargeTimeLabel:SetString(nil)
	end
end

local function UpgradeModuleDisplayPost(self)
	self.insightChargeTimeLabel = self:AddChild(RichText(nil, 30 * (1 / 0.7)))
	self.insightChargeTimeLabel:SetPosition(0, Y_OFFSET)
	self.insightChargeTimeLabel:SetString(nil)
	self.insightChargeTimeLabel:Hide()
	self.inst:DoPeriodicTask(1, function(inst)
		if self.insightChargeTimeLabel.shown then
			UpdateChargeLabel(self)
		end
	end)

	local oldOnGainFocus = self.OnGainFocus
	self.OnGainFocus = function(self)
		UpdateChargeLabel(self)
		self.insightChargeTimeLabel:Show()
		if oldOnGainFocus then
			return oldOnGainFocus(self)
		end
	end

	local oldOnLoseFocus = self.OnLoseFocus
	self.OnLoseFocus = function(self)
		self.insightChargeTimeLabel:Hide()
		if oldOnLoseFocus then
			return oldOnLoseFocus(self)
		end
	end
end

module.CanHookUpgradeModuleDisplay = function()
	return UpgradeModulesDisplayExists and CurrentRelease.GreaterOrEqualTo("R21_REFRESH_WX78")
end

module.HookUpgradeModuleDisplay = function()
	assert(module.CanHookUpgradeModuleDisplay(), "Attempting to hook when it shouldn't be possible.")
	AddClassPostConstruct("widgets/upgrademodulesdisplay", UpgradeModuleDisplayPost)
end




return module