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
--ThePlayer.HUD.controls.secondary_status.upgrademodulesdisplay.battery_frame:Kill()
local module = {}

-- Imports
local RichText = import("widgets/RichText")
local Reader = import("reader")
local UpgradeModulesDisplayExists = pcall(function() return require("widgets/recipepopup") end) -- Old recipe popup

-- Constant(s)
local Y_OFFSET = -120

local statusAnnouncementsPresent = false

--- Generates the hover text string. 
---@param plain boolean Whether formatting tags are included.
local function GetChargeString(plain)
	local context = GetPlayerContext(localPlayer)
	local info = localPlayer.replica.insight:GetInformation(localPlayer)

	-- nil == unregistered, false == full charge, number == time till next charge
	if not info or info.special_data.wx78 == nil or info.special_data.wx78.time_to_gain_charge == nil or info.special_data.wx78.charge_level == nil or info.special_data.wx78.max_charge == nil then
		return
	end

	-- This violates my readonly convention... but...........
	if context.lstr.wx78.CLIENT_gain_charge_time_plain == nil then
		rawset(context.lstr.wx78, "CLIENT_gain_charge_time_plain", Reader.Stringify(Reader:new(context.lstr.wx78.gain_charge_time):Read(), true))
	end

	if info.special_data.wx78.time_to_gain_charge == false then
		-- fully charged
		return context.lstr.wx78.full_charge
	end

	if plain then
		-- Since this is the plain version, it's assumed that this is for the status announcement.
		-- We'll use rezecib's time formatting for that if we can.
		local time_formatted = context.time:TryStatusAnnouncementsTime(info.special_data.wx78.time_to_gain_charge)
		return string.format(
			context.lstr.wx78.CLIENT_gain_charge_time_plain, 
			info.special_data.wx78.charge_level,
			info.special_data.wx78.max_charge,
			time_formatted
		)
	else
		return string.format(
			context.lstr.wx78.gain_charge_time, 
			info.special_data.wx78.charge_level,
			info.special_data.wx78.max_charge,
			context.time:SimpleProcess(info.special_data.wx78.time_to_gain_charge)
		)
	end

end

local function UpdateChargeLabel(self)
	if not localPlayer then return end
	if not self.insightChargeTimeLabel then return end
	local charge_string = GetChargeString()
	
	if charge_string then
		self.insightChargeTimeLabel:SetString(charge_string)
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

	-- Gain Focus
	local oldOnGainFocus = self.OnGainFocus
	self.OnGainFocus = function(self)
		UpdateChargeLabel(self)
		self.insightChargeTimeLabel:Show()
		if oldOnGainFocus then
			return oldOnGainFocus(self)
		end
	end

	-- Lose Focus
	local oldOnLoseFocus = self.OnLoseFocus
	self.OnLoseFocus = function(self)
		self.insightChargeTimeLabel:Hide()
		if oldOnLoseFocus then
			return oldOnLoseFocus(self)
		end
	end

	--[[
	-- For pinging charge!
	if statusAnnouncementsPresent then return end
	local oldOnControl = self.OnControl
	self.OnControl = function(self, ...)
		for i, v in pairs(self.chip_objectpool) do
			if v.focus then
				if oldOnControl then
					return oldOnControl(self, ...)
				end
			end
		end

		local control, down = ...

		if control == CONTROL_ACCEPT and TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) and down then
			local str = GetChargeString(true)
			if localPlayer.HUD._StatusAnnouncer and str then
				localPlayer.HUD._StatusAnnouncer:Announce(str, "insight_chargemeter" .. math.random())
			end
		end

		if oldOnControl then
			return oldOnControl(self, ...)
		end
	end
	--]]
	
	--

	--[[
	for i,v in pairs(self.chip_objectpool) do
		local oldOnControl = v.OnControl
		v.OnControl = function(self, control, down)
			if control == CONTROL_ACCEPT and TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) and down then
				local str = GetChargeString(true)
				if localPlayer.HUD._StatusAnnouncer and str then
					localPlayer.HUD._StatusAnnouncer:Announce(str, "insight_chargemeter" .. math.random())
				end
			end

			return oldOnControl(self, control, down)
		end
	end
	--]]
end

--- Intercepts Status Announcements' ping of the charge meter. Only should ping when directly hovering a module. Otherwise, I'll ping the charge from Insight.
local function StatusAnnouncementWXInterceptor(oldString, data)
	-- Don't ping charge if hovering on module.
	for i, v in pairs(data.widget.chip_objectpool) do
		if v.focus then
			return oldString
		end
	end

	-- Hovering the energy bar or whatnot.
	local str = GetChargeString(true)
	return str
end

module.CanHookUpgradeModuleDisplay = function()
	return IS_DST and UpgradeModulesDisplayExists and CurrentRelease.GreaterOrEqualTo("R21_REFRESH_WX78")
end

module.HookUpgradeModuleDisplay = function()
	assert(module.CanHookUpgradeModuleDisplay(), "Attempting to hook when it shouldn't be possible.")
	AddClassPostConstruct("widgets/upgrademodulesdisplay", UpgradeModuleDisplayPost)
	
	OnLocalPlayerPostInit:AddListener("register_wx78_interceptor", function()
		-- Only want to work with the original.
		if localPlayer.HUD._StatusAnnouncer and localPlayer.HUD._StatusAnnouncer.RegisterInterceptor then
			statusAnnouncementsPresent = true
			localPlayer.HUD._StatusAnnouncer:RegisterInterceptor(modname, "WX78CIRCUITS", StatusAnnouncementWXInterceptor)
		end
	end)
end




return module