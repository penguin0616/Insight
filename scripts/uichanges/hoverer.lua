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

local DEBUG_SHOW_PREFAB = GetModConfigData("DEBUG_SHOW_PREFAB", true)
local RichText = import("widgets/RichText")

AddLocalPlayerPostInit(function(_, context) 
	DEBUG_SHOW_PREFAB = context.config["DEBUG_SHOW_PREFAB"] 
end)

--
local HOVERER_TEXT_SIZE = 30
local INSIGHT_TEXT_SIZE = 22
rawset(_G, "choice", 0)


rawset(_G, "sz", function(x) INSIGHT_TEXT_SIZE = x end)
rawset(_G, "sz2", function(x) HOVERER_TEXT_SIZE = x end)
rawset(_G, "both", function(x) sz(x) sz2(x) end)
rawset(_G, "hov", function(x) hoverer.default_text_pos.y = x end)


STRINGS.NAMES.SPIDER = "SPI\nDER" 
STRINGS.NAMES.CANE = "Cane" .. string.rep(string.format("\n%s: Equip", string.char(238, 132, 129)), 4)
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
local math_ceil = math.ceil
local TheInput_IsKeyDown = TheInput.IsKeyDown
local TheInputProxy_GetLocalizedControl = TheInputProxy.GetLocalizedControl
local TheInput_IsControlPressed = TheInput.IsControlPressed
local CONTROL_FORCE_INSPECT = CONTROL_FORCE_INSPECT
local CONTROL_FORCE_TRADE = CONTROL_FORCE_TRADE

local informationOnAltOnly
local canShowItemRange
local canShowExtendedInfoIndicator

local function OnHovererPostInit(hoverer)
	local oldSetString = hoverer.text.SetString
	local oldOnUpdate = hoverer.OnUpdate
	local oldHide = hoverer.text.Hide
	local oldHide2 = hoverer.secondarytext.Hide

	rawset(_G, "hoverer", hoverer)

	--local altOnlyIsVerbose
	hoverer.insightText = hoverer:AddChild(RichText(UIFONT, INSIGHT_TEXT_SIZE))
	hoverer.text:SetSize(HOVERER_TEXT_SIZE)
	hoverer.secondarytext:SetSize(HOVERER_TEXT_SIZE)

	-- so, there's an issue where once you examine something, YOFFSETUP and YOFFSETDOWN are changed to compensate for that secondary text, but are never changed back
	-- so whereas normally hover text is unable to follow below a certain height because of math.min, the new YOFFSETUP means it is free to roam wherever vertically
	-- nothing like having to fix klei bugs myself because you literally can't report don't starve bugs

	-- this gets spam called
	function hoverer.text.Hide(self)
		if self.shown then 
			--GetMouseTargetItem() -- i could probably do this better, eh?
			if canShowItemRange and currentlySelectedItem ~= nil then
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

	if IS_DST then
		local YOFFSETUP = -80
		local YOFFSETDOWN = -50
		
		local XOFFSET = 10
		function hoverer:UpdatePosition(x, y)
			local scale = self:GetScale()
			local scr_w, scr_h = TheSim:GetScreenSize()
			local w = 0
			local h = 0

			if self.text ~= nil and self.str ~= nil then
				local w0, h0 = self.text:GetRegionSize()

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

			--===== Calculating the Y bounds ==================================================================

			-- The Y Minimum ======================================
			-- This alone gives some padding. However, an observation:
			local base_padding = ih * scale.y -- Do not use the length of the primary text since it will shift the text if pressing alt
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

			-- Based on the above observation, this formula made sense to use.
			local corrective_padding = (self.insightText.line_count - 2) * -(self.text.size / 2)
			-- However, alone it's not enough. It's still a little off. That's where we need the scaling.
			local y_min = base_padding + (corrective_padding * scale.y)

			-- The Y Maximum ======================================
			-- If the minimum is enough to keep the text from the bottom, 
			-- makes sense to me that it would work for the top.
			local y_max = scr_h - (y_min)
			-- And it mostly does! Just has roughly less than half of the normal text being clipped off.
			-- To compensate...
			y_max = y_max - (self.text.size / 2 * scale.y)
			-- This seems to do it.

			-- Now both are aligned exactly!
			-- Clamps could be changed to ternary for an incredibly slight performance gain.
			self:SetPosition(
				math_clamp(x, x_min, x_max),
				math_clamp(y, y_min, y_max),
				0
			)
		end
	end
	
	function hoverer.OnUpdate(self, ...)
		if self.insightText.size ~= INSIGHT_TEXT_SIZE then
			self.insightText:SetSize(INSIGHT_TEXT_SIZE)
		end

		if self.text.size ~= HOVERER_TEXT_SIZE then
			self.text:SetSize(HOVERER_TEXT_SIZE)
			self.secondarytext:SetSize(HOVERER_TEXT_SIZE)
		end

		if not self.text.shown then
			self.insightText:SetString(nil) -- this ends up causing some delay for text positioning?
		end

		oldOnUpdate(self, ...)
	end

	hoverer.text.SetString = function(self, text)
		if not localPlayer then
			return oldSetString(self, text)
		end

		if informationOnAltOnly == nil then
			informationOnAltOnly = GetModConfigData("alt_only_information", true)
		end

		if canShowItemRange == nil then
			canShowItemRange = GetModConfigData("hover_range_indicator", true)
		end

		if canShowExtendedInfoIndicator == nil then
			canShowExtendedInfoIndicator = GetModConfigData("extended_info_indicator", true)
		end

		--[[
		if altOnlyIsVerbose == nil then
			altOnlyIsVerbose = GetModConfigData("alt_only_is_verbose", true)
		end
		--]]

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

		if item and DEBUG_SHOW_PREFAB then
			local pos = string_find(text, "\n")
			local prefab = " [" .. item.prefab .. "]"
			if pos then
				text = string_sub(text, 1, pos - 1) .. prefab .. string_sub(text, pos)
			else
				text = text .. prefab
			end
		end
		
		if entityInformation then
			-- control pressed doesn't have the game focus issues (alt+tab keeps the key down) and handles the changed keybinds in control menu. 
			if TheInput_IsControlPressed(TheInput, CONTROL_FORCE_INSPECT) then
				local altOnlyIsVerbose = TheInput_IsControlPressed(TheInput, CONTROL_FORCE_TRADE)
				if informationOnAltOnly == true and altOnlyIsVerbose == false then
					itemDescription = entityInformation.information

					if entityInformation.information ~= entityInformation.alt_information then
						local pos = string_find(text, "\n")
						if pos then
							text = string_sub(text, 1, pos - 1) .. (canShowExtendedInfoIndicator and "*" or "") .. string_sub(text, pos)
						else
							text = text .. "*"
						end
					end
					
				else
					itemDescription = entityInformation.alt_information
				end
			elseif informationOnAltOnly then
				itemDescription = nil
			else
				itemDescription = entityInformation.information
				if entityInformation.information ~= entityInformation.alt_information then
					local pos = string_find(text, "\n")
					if pos then
						text = string_sub(text, 1, pos - 1) .. (canShowExtendedInfoIndicator and "*" or "") .. string_sub(text, pos)
					else
						text = text .. (canShowExtendedInfoIndicator and "*" or "")
					end
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

		if canShowItemRange then
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
			
			local top_pos = hoverer.default_text_pos.y
			local move_up = (description_lines-0) * (font_size_diff/2) -- Used to be -1, but there would be a tiny bit of space on sizes <30. -0 fixes that.
			local pos = top_pos - self.size + move_up
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
			-- No tooltip pos or FE
			local font_offset = hoverer.insightText.size / 4
			if hovertext_lines > 1 then
				total_lines = total_lines - (hovertext_lines - 1)
				font_offset = -font_offset
			end
			
			textPadding = string.rep("\n ", total_lines)
			hoverer.insightText:SetPosition(0, font_offset)
		end

		-- Trigger a position update.
		if (hoverer.old_insight_text ~= itemDescription) then
			self.old_insight_text = itemDescription
			local pos = TheInput:GetScreenPosition()
        	hoverer:UpdatePosition(pos.x, pos.y)
		end

		oldSetString(self, text .. textPadding)
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

		return oldSetString(self, text)
	end
end


module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S"):match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	AddClassPostConstruct("widgets/hoverer", OnHovererPostInit)
end

return module