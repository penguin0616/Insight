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
local Image = require("widgets/image")
local ImageButton = require "widgets/imagebutton"
local Text = require("widgets/text")
local Spinner = require("widgets/spinner")
local PopupDialogScreen = IS_DST and require("screens/redux/popupdialog") or require("screens/popupdialog")
local TEMPLATES = IS_DST and require("widgets/redux/templates") or setmetatable({}, { __index=function(self, index) error("Templates does not exist in DS.") end })
local InsightScrollList = import("widgets/insightscrolllist")
local ITEMPLATES = import("widgets/insight_templates")
local RichText = import("widgets/RichText")
local ListBox = import("widgets/listbox")

local CONFIG_PRESETS = import("misc/config_presets")

--------------------------------------------------------------------------
--[[ Screen ]]
--------------------------------------------------------------------------
local InsightPresetScreen = Class(PopupDialogScreen, function(self, context, modname)
	-- { text="a", cb=function() TheFrontEnd:PopScreen() end },
	-- Initialize self
	local options = {}
	for name in metapairs(CONFIG_PRESETS.PRESETS) do
		options[#options+1] = { text=name, cb=function() self:ApplyPreset(name) end }
	end
	PopupDialogScreen._ctor(self, "Configuration Presets", "Select a configuration preset.", options)
	self.name = "InsightPresetScreen"

	-- Record context
	self.context = content
	self.modname = modname

	local tbl = (IS_DST and self.dialog.actions.items) or (IS_DS and self.menu.items)

	for i, button in pairs(tbl) do
		local name = button:GetText()
		local preset = CONFIG_PRESETS.PRESETS[name]

		-- Fix display text
		local strings = context.lstr.presets.types[name]
		if not strings then
			errorf("Missing strings for config type %q", name)
		end

		button:SetText(strings.label)

		button._text, button.text = button.text, nil -- I want the hovertext to apply to the entire button, not just the text part.
		button:SetHoverText(strings.description, {offset_y = 60})
		button.text, button._text = button._text, nil
	end
end)

function InsightPresetScreen:SetOnApplyFn(fn)
	self.onapplyfn = fn
end

function InsightPresetScreen:ApplyPreset(name)
	mprint("applypreset", name)

	local preset = CONFIG_PRESETS.PRESETS[name]
	if not preset then
		errorf("Can't apply unknown preset %q", name)
	end

	local client_config = true

	local configs = KnownModIndex:LoadModConfigurationOptions(self.modname, client_config)

	for i, config in pairs(configs) do
		local selected = preset[config.name]
		-- Make sure it's in the preset as something to change
		if selected ~= nil then
			if selected == CONFIG_PRESETS.DEFAULT then
				-- Reset config to default
				config.saved = config.default
			else
				mprint("changing", config.name, "to", selected)
				config.saved = selected
			end
		end
	end

	KnownModIndex:SaveConfigurationOptions(function()
		-- :l
	end, self.modname, configs, client_config)

	self:Close()

	if self.onapplyfn then
		self.onapplyfn()
	end

	ClientCoreEventer:PushEvent("configuration_update")
end

function InsightPresetScreen:Close()
	TheFrontEnd:PopScreen(self)
end

--[[
function InsightConfigurationScreen:OnControl(control, down)
	--mprint("InsightConfigurationScreen", controlHelper.Prettify(control), down)
	if self._base.OnControl(self, control, down) then return true end

	local scheme = controlHelper.GetCurrentScheme()
	if not down then
		if scheme:IsAcceptedControl("exit", control) then
			TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
			self:Close()
			return true
		end
	end
end
--]]

return InsightPresetScreen