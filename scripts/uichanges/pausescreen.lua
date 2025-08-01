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

local function OnPauseScreenPostConstructDST(self)
	mprint(self, self.BuildMenu)
end

local function PostButtons(screen, buttons)
	local ctx = localPlayer and GetPlayerContext(localPlayer)
	if ctx and not ctx.config["display_insight_menu_button"] then
		table.insert(buttons, 1, {
			text = "Insight Menu", 
			cb = function() 
				screen:unpause()
				localPlayer.HUD.controls:ToggleInsightMenu()
			end 
		})
		if screen.pause_button_index then
			screen.pause_button_index = screen.pause_button_index + 1
		end
		screen.options_button_index = screen.options_button_index + 1
	end
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	
	if IS_DST then
		--AddClassPostConstruct("screens/redux/pausescreen", OnPauseScreenPostConstructDST)
		local PauseScreen = require("screens/redux/pausescreen")
		local TEMPLATES = require("widgets/redux/templates")

		local fakeTemplates = setmetatable({ 
			CurlyWindow=function(sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text)
				local screen = util.getlocal(2, "self")
				local buttons = util.getlocal(2, "buttons")
				PostButtons(screen, buttons)

				local button_h = util.getlocal(2, "button_h")
				sizeY = button_h * #buttons + 30

				return TEMPLATES.CurlyWindow(sizeX, sizeY, title_text, bottom_buttons, button_spacing, body_text)
			end
		}, { __index=TEMPLATES, __newindex=TEMPLATES })

		util.replaceupvalue(
			PauseScreen.BuildMenu, 
			"TEMPLATES",
			fakeTemplates
		)
	end
end

return module