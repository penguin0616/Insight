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

local function UpdatePlayerListing(self)
	local font_size = 16
	local listing = self.widget

	local context = localPlayer and GetPlayerContext(localPlayer)

	if not localPlayer or not context or not context.config["display_shared_stats"] then
		listing.insight_text:SetString(nil)
		return
	end

	local data = shard_players[listing.userid]
	if not data then
		listing.insight_text:SetString(nil)
		return
	end

	listing.insight_text:SetSize(font_size)

	local asd = {}

	if data.health then
		local f = string.format("<icon=health> <color=HEALTH>%s</color> / <color=HEALTH>%s</color>", data.health.health, data.health.max_health)
		table.insert(asd, f)
	end

	if data.sanity then
		local str = data.sanity.lunacy and "ENLIGHTENMENT" or "SANITY"
		local f = string.format("<icon=" .. str:lower() .. "> <color=" .. str .. ">%s</color> / <color=" .. str .. ">%s</color>", data.sanity.sanity, data.sanity.max_sanity)
		table.insert(asd, f)
	end

	if data.wereness and data.wereness.weremode then
		local f = string.format("<icon=hunger> <color=HUNGER>%s</color> / <color=HUNGER>%s</color>", data.hunger.hunger, data.hunger.max_hunger)
		table.insert(asd, f)
	elseif data.hunger then
		local f = string.format("<icon=hunger> <color=HUNGER>%s</color> / <color=HUNGER>%s</color>", data.hunger.hunger, data.hunger.max_hunger)
		table.insert(asd, f)
	end

	listing.insight_text:SetString((#asd > 0 and table.concat(asd, "\n")) or nil)
	listing.insight_text:SetPosition(listing.name:GetRegionSize() + 10, 0)
end

local function SetupPlayerStatInfo(playerStatusScreen)
	if playerStatusScreen.__insight_init then
		return
	end

	for i,v in pairs(playerStatusScreen.player_widgets) do -- they persistent constantly
		if v.insight_text == nil then
			v.insight_text = v.name:AddChild(RichText())
			v.inst:DoPeriodicTask(1, UpdatePlayerListing)
		end
	end
end

local function OnPlayerStatusScreenPostInit(playerStatusScreen)
	local oldGetHelpText = playerStatusScreen.GetHelpText
	playerStatusScreen.GetHelpText = function(self)
		local str = ""
		if TheInput:ControllerAttached() then
			str = TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_OPEN_CRAFTING) .. " Insight Menu  " -- two spaces looks correct
		end

		return str .. oldGetHelpText(self)
	end

	--[[
		parent	row_root	
		[00:32:29]: characterBadge	PlayerBadge	
		[00:32:29]: OnGainFocus	function: 9203CB20	
		[00:32:29]: next_in_tab_order	Text - 	
		[00:32:29]: mute	BUTTON	
		[00:32:29]: GetHelpText	function: B0976000	
		[00:32:29]: enabled	true	
		[00:32:29]: userid	KU_md6wbcj2	
		[00:32:29]: age	Text - 59 Days	
		[00:32:29]: name	Text - 	
		[00:32:29]: focus_flow	table: 87F24FD8	
		[00:32:29]: number	Text - 1	
		[00:32:29]: isMuted	false	
		[00:32:29]: highlight	Image - images/scoreboard.xml:row_goldoutline.tex	
		[00:32:29]: perf	Image - images/scoreboard.xml:host_indicator2.tex	
		[00:32:29]: useractions	BUTTON	
		[00:32:29]: OnLoseFocus	function: 9F5C3F40	
		[00:32:29]: inst	133028 - 	
		[00:32:29]: focus	false	
		[00:32:29]: viewprofile	BUTTON	
		[00:32:29]: children	table: 87F251E0	
		[00:32:29]: focus_flow_args	table: 87F25000	
		[00:32:29]: focus_target	false	
		[00:32:29]: parent_scroll_list	ScrollBar	
		[00:32:29]: callbacks	table: 87F24DF8	
		[00:32:29]: can_fade_alpha	true	
		[00:32:29]: profileFlair	rank badge	
		[00:32:29]: ban	BUTTON	
		[00:32:29]: adminBadge	BUTTON	
		[00:32:29]: focus_forward	BUTTON	
		[00:32:29]: ishost	true	
		[00:32:29]: kick	BUTTON	
		[00:32:29]: displayName	penguin0616	
		[00:32:29]: shown	true	
	]]
	--mprint("made: playerStatusScreen", playerStatusScreen)
	--table.foreach(playerStatusScreen, mprint)

	local oldDoInit = playerStatusScreen.DoInit
	playerStatusScreen.DoInit = function(self, ...)
		oldDoInit(self, ...)
		SetupPlayerStatInfo(self)
	end
end

--[[
AddClassPostConstruct("screens/chatinputscreen", function(self)
	if TheNet:GetUserID() == MyKleiID then
		--mprint"hey!!!"
	end
end)
--]]

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S"):match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	AddClassPostConstruct("screens/playerstatusscreen", OnPlayerStatusScreenPostInit)
end

return module