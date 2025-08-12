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
local Widget = require("widgets/widget")

local MIN_EXPLORATION_COLOR = Color.fromHex("#aaaaaa")
local MAX_EXPLORATION_COLOR = Color.fromHex(Insight.COLORS.PERCENT_GOOD)

local function OnMapScreenPostInit(self)
	local root = self:AddChild(Widget("tm_root"))
	root:SetScaleMode(SCALEMODE_PROPORTIONAL)
    root:SetHAnchor(ANCHOR_MIDDLE)
    root:SetVAnchor(ANCHOR_TOP)
    root:SetMaxPropUpscale(MAX_HUD_SCALE)

	--local header_root = root:AddChild(Widget("header"))
	--header_root:SetPosition(0, , 0)

	local text = root:AddChild(RichText(UIFONT, 24))
	text:SetPosition(0, -12-6, 0)
	if localPlayer and localPlayer.GetSeeableTilePercent then
		local context = GetPlayerContext(localPlayer)
		if context.config["show_map_info"] then
			local percent = localPlayer:GetSeeableTilePercent()
			local color = MIN_EXPLORATION_COLOR:Lerp(MAX_EXPLORATION_COLOR, percent)
			text:SetString(string.format(context.lstr.map.land_exploration, 
				color:ToHex(),
				percent*100
			))
		end
	end
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	if not IS_DST then
		return
	end

	module.initialized = true
	AddClassPostConstruct("screens/mapscreen", OnMapScreenPostInit)
end

module.Shutdown = function()
	if not module.initialized then
		mprint("Cannot shutdown inactive module")
		return
	end

	RemoveClassPostConstruct("screens/mapscreen", OnMapScreenPostInit)
end

return module