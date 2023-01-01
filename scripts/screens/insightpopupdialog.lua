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
local PopupDialogScreen = IS_DST and require("screens/redux/popupdialog") or require("screens/popupdialog")

--------------------------------------------------------------------------
--[[ Screen ]]
--------------------------------------------------------------------------
local InsightPopupDialog = Class(PopupDialogScreen, function(self, ...)
	PopupDialogScreen._ctor(self, ...)

	if IS_DST then
		local tint = self.black.tint
		self.black:Kill()

		-- MoveToBack doesn't work in DS atm. https://forums.kleientertainment.com/forums/topic/145358-widget-layering-movetobackfront-is-bugged-in-ds-works-fine-in-dst
		self.black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
		self.black:MoveToBack()
		self.black:SetControl(CONTROL_PRIMARY)
		self.black.image:SetVRegPoint(ANCHOR_MIDDLE)
		self.black.image:SetHRegPoint(ANCHOR_MIDDLE)
		self.black.image:SetVAnchor(ANCHOR_MIDDLE)
		self.black.image:SetHAnchor(ANCHOR_MIDDLE)
		self.black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
		self.black.image:SetTint(unpack(tint))	

		self.black:SetOnClick(function()
			self:Close()
		end)
	end

	self.force_exit_listener = ClientCoreEventer:ListenForEventOnce("force_insightui_exit", function()
		self:Close()
	end)
end)

function InsightPopupDialog:Close()
	if self.force_exit_listener then
		self.force_exit_listener:Remove()
	end
	
	TheFrontEnd:PopScreen(self)
end

function InsightPopupDialog:OnControl(control, down)
	--mprint("InsightPopupDialog", controlHelper.Prettify(control), down)
	-- PopupDialog is just a mess with it trying to infer button usage from input. Complete overwrite of base.
	if Screen.OnControl(self, control, down) then return true end

	local scheme = controlHelper.GetCurrentScheme()
	if not down then
		if scheme:IsAcceptedControl("exit", control) then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:Close()
			return true
		end
	end
end

function InsightPopupDialog:GetHelpText()
	-- Same issue as OnControl here.
	local controller_id = TheInput:GetControllerID()
	local t = {}

	table.insert(t, TheInput:GetLocalizedControl(controller_id, controlHelper.GetCurrentScheme().exit:GetPrimaryControl()) .. " " .. STRINGS.UI.HELP.BACK)	

	return table.concat(t, "  ")
end

return InsightPopupDialog