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

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim


local Text = require("widgets/text")
local RichText = import("widgets/RichText")
local infotext_common = import("uichanges/infotext_common").Initialize()

local module = {}


--[[
local HOVERER_TEXT_SIZE = 30
local insight_text_size = 22
rawset(_G, "choice", 0)


rawset(_G, "sz", function(x) insight_text_size = x end)
rawset(_G, "sz2", function(x) HOVERER_TEXT_SIZE = x end)
rawset(_G, "both", function(x) sz(x) sz2(x) end)
rawset(_G, "hov", function(x) hoverer.default_text_pos.y = x end)

--]]
--STRINGS.NAMES.SPIDER = "SPI\nDER" 
--STRINGS.NAMES.CANE = "Cane" .. string.rep(string.format("\n%s: Equip", string.char(238, 132, 129)), 4)


--
-- inspectable spider (needed a total of 6 lines to match beefalo) 		alt_description = "a\nb\nc\nd\ne\nf"
-- finiteuses		 alt_description = table.concat(actions_verbose, ", ") .. string.rep("\n", 6) .. "morsey"
-- 		later changed that to 		alt_description = table.concat(actions_verbose, ", ") .. "\n3\n4\n5\n6\n7"

local GetMouseTargetItem = GetMouseTargetItem
local RequestEntityInformation = RequestEntityInformation
local TheSim = TheSim
local debug_getinfo = debug.getinfo
local math_clamp = math.clamp
local string_find = string.find
local string_sub = string.sub
local string_split = string.split
local math_ceil = math.ceil
local TheInput_IsKeyDown = TheInput.IsKeyDown
local TheInputProxy_GetLocalizedControl = TheInputProxy.GetLocalizedControl
local TheInput_IsControlPressed = TheInput.IsControlPressed
local CONTROL_FORCE_INSPECT = CONTROL_FORCE_INSPECT
local CONTROL_FORCE_TRADE = CONTROL_FORCE_TRADE

local SetString = Text.SetString

local function OnHovererPostInit(hoverer)
	local oldSetString = hoverer.text.SetString
	local oldSecondarySetString = hoverer.secondarytext.SetString
	local oldOnUpdate = hoverer.OnUpdate
	local oldHide = hoverer.text.Hide
	local oldHide2 = hoverer.secondarytext.Hide

	--rawset(_G, "hoverer", hoverer)

	--local altOnlyIsVerbose
	hoverer.insightText = hoverer:AddChild(RichText(
		util.GetInsightFont(), 
		infotext_common.configs.hoverer_insight_font_size
	))

	hoverer.text:SetFont(util.GetInsightFont())
	hoverer.secondarytext:SetFont(util.GetInsightFont())

	--hoverer.text:SetSize(HOVERER_TEXT_SIZE)
	--hoverer.secondarytext:SetSize(HOVERER_TEXT_SIZE)

	-- so, there's an issue where once you examine something, YOFFSETUP and YOFFSETDOWN are changed to compensate for that secondary text, but are never changed back
	-- so whereas normally hover text is unable to follow below a certain height because of math.min, the new YOFFSETUP means it is free to roam wherever vertically
	-- nothing like having to fix klei bugs myself because you literally can't report don't starve bugs

	-- this gets spam called
	function hoverer.text.Hide(self)
		if self.shown then 
			--GetMouseTargetItem() -- i could probably do this better, eh?
			if infotext_common.configs.hover_range_indicator and currentlySelectedItem ~= nil then
				OnCurrentlySelectedItemChanged(currentlySelectedItem, nil)
				currentlySelectedItem = nil
			end
			oldHide(self)
		end
	end

	function hoverer.secondarytext.Hide(self)
		if IS_DS then
			util.replaceupvalue(debug_getinfo(2).func, "YOFFSETUP", 40)
			util.replaceupvalue(debug_getinfo(2).func, "YOFFSETDOWN", 30)
		end

		if self.shown then
			oldHide2(self)
		end
	end
	-- TheInput:GetScreenPosition()

	-- GetIntegratedBackpack

	if true then
		--local YOFFSETUP = -80
		--local YOFFSETDOWN = -50
		
		local XOFFSET = 10
		function hoverer:UpdatePosition(x, y)
			local scale = self:GetScale()
			local scr_w, scr_h = TheSim:GetScreenSize()
			local w = 0
			local h = 0

			local primary_text_height = 0
			if self.text ~= nil and self.str ~= nil then
				local w0, h0 = self.text:GetRegionSize()

				primary_text_height = h0

				w = math.max(w, w0)
				--h = math.max(h, h0)
			end

			
			if self.secondarytext ~= nil and self.secondarystr ~= nil then
				local w1, h1 = self.secondarytext:GetRegionSize()
				w = math.max(w, w1)
				--h = math.max(h, h1)
			end

			
			local iw, ih = 0, 0
			if self.insightText ~= nil and self.insightText:GetString() then
				iw, ih = self.insightText:GetRegionSize()

				w = math.max(w, iw)
				--h = math.max(h, ih)
			end

			w = w * scale.x * .5
			--h = h * scale.y * .5
			--===== Calculating the X bounds ==================================================================
			-- Default works here.
			local x_min = w + XOFFSET
			local x_max = scr_w - w - XOFFSET

			--===== Calculating the Y bounds ========================================================================================================================================================

			-- The Y Minimum =============================================================================================================================================
			-- This alone gives some padding. However, an observation:
			local base_padding = ih * scale.y -- Do not use the length of the primary text since it will shift the text if pressing alt
			--primary_text_height = (primary_text_height - (self.insightText.line_count - 1) * self.text.size) * scale.y -- Minus 1.. because... Yes.
			--[[
				[# of lines of insight text] line = [base_padding] (how the text appears aligned to me)
				1 line = 60 (too short by 15 units)
				2 line = 120 (perfect)
				3 line = 180 (too big by 15 units)
				4 line = 240 (too big by 30 units)

				Items tested with: Pitchfork (4 lines), Axe (3 lines), Cane (2 lines), Cut Grass (1 line)
				Finiteuses had an extra line appended to it, Pitchfork had the component info warning for terraformer.
				I thought maybe the 2 line equilibrium was due to the "<EntityDisplayName>\nInspect" but that doesn't seem to be it?
			]]

			local USE_INTEGRATED_MODIFIER = localPlayer and localPlayer.HUD 
											and localPlayer.HUD.controls
											and localPlayer.HUD.controls.inv
											and localPlayer.HUD.controls.inv.integrated_backpack -- TheInput:ControllerAttached() or Profile:GetIntegratedBackpack()
			
			-- Feeling like one of those wizards right now. I experimented with the *2 modifier until I realized the behaviour
			-- seemed similar to the whole -2 things I have to do for lines. What do you know, it worked!
			local INTEGRATED_MODIFIER = USE_INTEGRATED_MODIFIER and 2 or 1

			-- Based on the above observation, this formula made sense to use.
			local corrective_padding = (self.insightText.line_count - (2*INTEGRATED_MODIFIER)) * -(self.text.size / 2)
			-- However, alone it's not enough. It's still a little off. That's where we need the scaling.
			local y_min = base_padding + (corrective_padding * scale.y)

			-- The Y Maximum =============================================================================================================================================
			local font_size_diff = self.text.size - self.insightText.size

			-- This is enough to work for most cases.
			-- It's a little short when self.text.size < 30.
			local down = primary_text_height/2 + self.text.size * 1.5
			-- This is enough to fix it. Subtracting because it needs to be inverted.
			if self.text.size < 30 then
				down = down - (30 - self.text.size)
			end


			-- y_min is the bottom of the screen
			-- y_max is the top of the screen

			local y_max = scr_h - (down * scale.y) 
			-- I must be going crazy, this is being quite inconsistent.

			self:SetPosition(
				math_clamp(x, x_min, x_max),
				math_clamp(y, y_min, y_max),
				0
			)
		end
	end
	
	function hoverer.OnUpdate(self, ...)
		if self.insightText.size ~= infotext_common.configs.hoverer_insight_font_size then
			self.insightText:SetSize(infotext_common.configs.hoverer_insight_font_size)
		end

		self.insightText:SetFont(util.GetInsightFont())
		hoverer.text:SetFont(util.GetInsightFont())
		hoverer.secondarytext:SetFont(util.GetInsightFont())

		--[[
		if self.text.size ~= HOVERER_TEXT_SIZE then
			self.text:SetSize(HOVERER_TEXT_SIZE)
			self.secondarytext:SetSize(HOVERER_TEXT_SIZE)
		end
		--]]

		if not self.text.shown then
			self.insightText:SetString(nil) -- this ends up causing some delay for text positioning?
		end

		oldOnUpdate(self, ...)
	end

	hoverer.text.SetString = function(self, text)
		if not localPlayer then
			return oldSetString(self, text)
		end

		--YOFFSETUP = util.getupvalue(debug.getinfo(2).func, "YOFFSETUP")
		--YOFFSETDOWN = util.getupvalue(debug.getinfo(2).func, "YOFFDOWN")
		--mprint('t1:', text) -- main action or whatnot, including alt
		-- additional hours going through hell and back
		-- i have such an irritating headache.
		--
		-- information
		local item = GetMouseTargetItem()
		local entityInformation = RequestEntityInformation(item, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })
		local itemDescription = nil

		if item and infotext_common.configs.DEBUG_SHOW_PREFAB then
			local pos = string_find(text, "\n")
			local prefab = " [" .. item.prefab .. "]"
			if pos then
				text = string_sub(text, 1, pos - 1) .. prefab .. string_sub(text, pos)
			else
				text = text .. prefab
			end
		end

		local MAX_LINES = infotext_common.configs.hoverer_line_truncation
		
		if entityInformation then
			-- IsControlPressed doesn't have the game focus issues (alt+tab keeps the key down) and handles the changed keybinds in control menu. 
			-- CONTROL_FORCE_INSPECT is normally Left Alt.

			if TheInput_IsControlPressed(TheInput, CONTROL_FORCE_INSPECT) then
				-- CONTROL_FORCE_TRADE is normally Left Shift.
				-- So, if they're holding Alt and Left Shift, then they want to be able to see all of the information.
				-- If they're only olding alt, and they have the alt-only config option, then we show the normal information
				-- instead of the alt information.
				local altOnlyIsVerbose = TheInput_IsControlPressed(TheInput, CONTROL_FORCE_TRADE)
				if infotext_common.configs.alt_only_information == true and altOnlyIsVerbose == false then
					-- They're using the config option and not holding shift, so only show the normal information.
					itemDescription = entityInformation.information
				else
					-- They're holding their designated "show all information key" (either LShift or LALT) depending on config,
					-- so We know they absolutely want all the information now, so show that.
					itemDescription = entityInformation.alt_information
					MAX_LINES = nil
				end
			elseif infotext_common.configs.alt_only_information then
				-- If alt isn't pressed and they have alt only information, then they don't get any information.
				itemDescription = nil
			else
				-- Standard situation, standard user. 
				itemDescription = entityInformation.information
			end

			-- I guess I never actually hooked up the configuration? 
			-- Either that or I accidentally removed the hook at some point.
			local canShowExtendedInfoIndicator = true 

			-- Okay, we need to do our line truncation before we do the alt_information check.
			if type(MAX_LINES) == "number" and itemDescription then
				-- Oh boy, here we go.
				local trimmed = RichText.TrimNewlines(itemDescription)
				local lines = string_split(trimmed, "\n")
				local fixed = ""
				for i = 1, MAX_LINES do
					local line = lines[i]
					if not line then
						break
					end

					fixed = fixed .. lines[i]
					if i < MAX_LINES then
						fixed = fixed .. "\n"
					end
				end

				if MAX_LINES < #lines then
					--fixed = fixed .. " <color=#888888>.</color><color=#222222>.</color><color=#888888>.</color>"
					fixed = fixed .. " ....."
				end

				itemDescription = fixed
			end


			if entityInformation.information ~= entityInformation.alt_information then
				local pos = string_find(text, "\n")
				if pos then
					text = string_sub(text, 1, pos - 1) .. (canShowExtendedInfoIndicator and "*" or "") .. string_sub(text, pos)
				else
					--text = text .. "*"
					text = text .. (canShowExtendedInfoIndicator and "*" or "")
				end
			end



			--[[
				if altOnlyIsVerbose == true then
					print'yeep'
					itemDescription = entityInformation.alt_information
				else
					itemDescription = entityInformation.information
				end
			]]

			--itemInfo = (TheInput:IsKeyDown(KEY_LALT) and itemInfo.alt_information) or itemInfo.information or nil
		end


		
		if infotext_common.configs.hover_range_indicator then
			if item == nil or entityInformation == nil then
				if currentlySelectedItem ~= nil then
					OnCurrentlySelectedItemChanged(currentlySelectedItem, nil)
					currentlySelectedItem = nil
				end
			elseif item and entityInformation and entityInformation.GUID then -- GUID presence means it is initialized
				if currentlySelectedItem ~= item then
					OnCurrentlySelectedItemChanged(currentlySelectedItem, item, entityInformation)
					currentlySelectedItem = item
				end
			end
		end

		if item and DEBUG_ENABLED then
			--itemInfo = string.format("Active: %s\n", tostring(entityManager:IsEntityActive(item))) .. (itemInfo or "")
		end

		hoverer.insightText:SetString(itemDescription) -- Trimming newlines handled here

		-- Trigger other mods that might have text stuff to do
		if oldSetString ~= SetString then
			--mprint(text)
			oldSetString(self, text)
			text = self:GetString()
			--mprint(text, "\n", string.rep("=", 66))
		end
	
		-- size info
		local font_size_diff = self.size - hoverer.insightText.size
		local font_size_diff_ratio = hoverer.insightText.size / self.size 

		local hovertext_lines = select(2, text:gsub("\n", "\n")) -- Line count is shortened by 1.
		local description_lines = hoverer.insightText.line_count
		local total_lines = hovertext_lines + description_lines - 1
		local total_lines_scaled = math.ceil(total_lines * font_size_diff_ratio) -- Has to be ceil, so we at least have some room on a oneline description for something in the inventory.
		
		local diff = total_lines - total_lines_scaled

		local adjusted_total = total_lines
		--local adjusted_offset = 0

		local textPadding

		local min = (1 - hovertext_lines)
		if diff > min then
			adjusted_total = adjusted_total - (diff - math.abs(min))
			--adjusted_offset = (total_lines - total_lines_scaled - 1) * hoverer.insightText.size
		end

		--mprint("totals:", total_lines, total_lines_scaled, "| diff & min:", diff, min, "| adjusted:", adjusted_total)
		--mprint(total_lines - total_lines_scaled, "|", adjusted_offset)

		--local top_pos = hoverer.default_text_pos.y-- - ((hovertext_lines+1) * self.size/2)

		local text_pos = self:GetPosition()
		local top_pos = text_pos.y
		local move_up = (description_lines-0) * (font_size_diff/2) -- Used to be -1, but there would be a tiny bit of space on sizes <30. -0 fixes that.
		local pos = top_pos - self.size + move_up
		
		if IS_DST then
			-- <place> <Item> (<#top_hoverlines>/<#insight_lines> line) = <choice_with_size_factor> | <choice_with_just_default> 

			-- Floor Nightmarefuel (1/1 line) = 11 | 30
			-- Inv Nightmarefuel (2/1 line) = 0 | 30

			-- Floor Poop = (1/2 line) = 11 | 26
			-- Inv Poop = (2/2 line) = 0 | 26

			-- Floor Tam = (1/3 line) = 3 | 22
			-- Inv Tam = (2/3 line) = -8 or -11 | 22

			-- Floor Magis = (1/4 line) = ? | 18
			-- Inv Magis = (2/4 line) = ? | 18
			
			--[[
			local reduction = math.floor(move_up / self.size)
			mprintf("Can remove '%s' newline(s) (move_up is [%s])", reduction, move_up)
			total_lines = total_lines - reduction
			move_up = move_up - reduction * self.size

			local pos = top_pos - self.size + move_up
			pos = pos - choice
			--local pos = top_pos - rawget(_G, "choice")
			mprintf("\tTop_pos: [%s], move_up: [%s], pos: [%s]", top_pos, move_up, pos)
			--]]

			textPadding = string.rep("\n ", total_lines)
			--mprint("\t", ((hovertext_lines-1) * font_size_diff))
			-- Changing the text position of the vanilla object is bad, since it causes jittering.
			-- Turns out the (30/4 == 7.5) was never exact. It's pretty damn close though. It's just barely short.
			-- I'm thinking that might have something to do with RichText using the full font size for each line, instead of just the region height. Oh well!
			-- About 40 minutes later: Nope. It's because of the default_text_pos (40). At both text sizes 30, 10 is what you need for perfect alignment. 7.5 was almost there, but not quite.
			hoverer.insightText:SetPosition(0, pos)
		
		else
			textPadding = string.rep("\n ", total_lines)
			hoverer.insightText:SetPosition(0, pos)
		end

		-- Trigger a position update.
		if (hoverer.old_insight_text ~= itemDescription) then
			self.old_insight_text = itemDescription
			local pos = TheInput:GetScreenPosition()
        	hoverer:UpdatePosition(pos.x, pos.y)
		end

		SetString(self, text .. textPadding)
	end
	

	hoverer.secondarytext.SetString = function(self, text)
		-- stuff like boats, where the action is far below
		-- or any ground entity really
		-- explains why the text overlap from boats happened

		-- a good test case is holding an axe and hovering a beefalo

		--[[
			hovering a beefalo holding an axe, insight text states:
			health
			damage
			hunger
			hunger decay
			tendency
			naughtiness
			mood
			brushed

			-- 8 lines, and on default offset of -30, this text is positioned betweenish lines 5 and 6.
		]]

		local font_size_diff = hoverer.text.size - hoverer.insightText.size

		-- Start from right below the .text
		local top = (hoverer.insightText.line_count) * hoverer.text.size / 2
		-- Push down past the Insight text.
		local insight_down = (hoverer.insightText.line_count) * hoverer.insightText.size
		-- Additionally padding for prettiness.
		local padding_offset = 10 -- font_size_diff

		local offset = top - insight_down - padding_offset

		-- there's a 1 line gap in vanilla (both) between the primarytext and secondarytext
		-- We don't want that gap with Insight info though, it's wasted space.
		if hoverer.insightText.raw_text == nil then
			self:SetPosition(0, -hoverer.text.size) -- Default position
		else
			self:SetPosition(0, offset)
		end

		--mprint("SECONDARY::", text)
		return oldSecondarySetString(self, text)
	end
end


module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	AddClassPostConstruct("widgets/hoverer", OnHovererPostInit)
end

return module