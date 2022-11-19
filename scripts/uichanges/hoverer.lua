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

local HOVERER_TEXT_SIZE = 30
local TEXT_SIZE = 30
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

	--local altOnlyIsVerbose
	hoverer.insightText = hoverer:AddChild(RichText(UIFONT, TEXT_SIZE))
	hoverer.insightText.DEBUG_TESTING = true

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

	-- count lines
	local function cl(txt)
		local i = 1
		txt:gsub("\n", function() i = i + 1 end) -- i should probably bring this up to scratch with the other one, but i do not have the mental fortitude to handle it.
		-- oh, how i hate working with UIs.
		return i
	end

	-- TheInput:GetScreenPosition()

	if IS_DST then
		function hoverer:UpdatePosition(x, y)
			local YOFFSETUP = -80
			local YOFFSETDOWN = -50
			local XOFFSET = 10

			local scale = self:GetScale()
			local scr_w, scr_h = TheSim:GetScreenSize()
			local w = 0
			local h = 0

			if self.text ~= nil and self.str ~= nil then
				local w0, h0 = self.text:GetRegionSize()
				w = math.max(w, w0)
				h = math.max(h, h0)
			end
			if self.secondarytext ~= nil and self.secondarystr ~= nil then
				local w1, h1 = self.secondarytext:GetRegionSize()
				w = math.max(w, w1)
				h = math.max(h, h1)
			end
			if self.insightText ~= nil and self.insightText:GetString() then
				local w2, h2 = self.insightText:GetRegionSize()
				w = math.max(w, w2)
				h = math.max(h, h2)
			end

			w = w * scale.x * .5
			h = h * scale.y * .5

			--print(y, "LOWER:", h + YOFFSETDOWN * scale.y, "HIGHER:", scr_h - h - YOFFSETUP * scale.y)

			-- low = bottom
			-- high = top
			--print("max:", scr_h - h*2 - YOFFSETUP * scale.y) -- scr_h - h - YOFFSETUP * scale.y
			--print("current:", y)
			--print'-----------------------------------------'

			local x_min = w + XOFFSET
			local x_max = scr_w - w - XOFFSET

			local r = cl(self.text:GetString())
			local y_min = h + YOFFSETDOWN * scale.y + (30*.75)
			-- y_max = scr_h - h - YOFFSETUP * scale.y
			local y_max = scr_h - h*2 - YOFFSETUP * scale.y -- h*2 means harder for insight to go off bounds

			self:SetPosition(
				math_clamp(x, x_min, x_max),
				math_clamp(y, y_min, y_max),
				0)
		end
	end
	
	function hoverer.OnUpdate(self, ...)
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

		hoverer.insightText:SetString(itemDescription)
		
		-- size info
		local dataWidth, dataHeight = hoverer.insightText:GetRegionSize()
		--local headerWidth, headerHeight = CalculateSize(text) --self:GetRegionSize()
		--local headerY = (hoverer.owner.HUD.controls:GetTooltipPos() or hoverer.default_text_pos).y

		-- misc
		--local positionPadding = (cl(text) - 1) * 7.5

		local x = math_ceil(dataHeight / hoverer.insightText.font_size)
		local r = cl(text) - 1

		local textPadding 
		

		--local textPadding = string.rep("\n ", math.ceil(dataHeight / 30) + 0)

		--mprint(CalculateSize(text), headerWidth, headerHeight, math.ceil(headerHeight / 30))
		--mprint(math.ceil(headerHeight / 30) - math.ceil(dataHeight / 30))

		local p1 = hoverer:GetPosition()
		--mprint(p1.x, dataWidth, screenWidth)

		if IS_DST then
			local tp_bonus = (r == 2 and 0) or 1
			textPadding = string.rep("\n ", x + r + tp_bonus)
			
			hoverer.insightText:SetPosition(0, 7.5 + tp_bonus * 15 + dataHeight/2)
		else
			textPadding = string.rep("\n ", x)
			r = r - 1
			if r < 0 then
				--r = 0 -- i commented this and that made the stars align
			end

			hoverer.insightText:SetPosition(0, -7.5 + (-15 * r) + dataHeight / 2)
		end

		
		return oldSetString(self, text .. textPadding)
	end

	hoverer.secondarytext.SetString = function(self, text)
		-- stuff like boats, where the action is far below
		-- or any ground entity really
		-- explains why the text overlap from boats happened
		--mprint('t2:', text)
		--[[
		local YOFFSETDOWN = (IS_DS and 30) or -50
		local w, h = hoverer.insightText:GetRegionSize()

		local line_buffer = (IS_DS and 4) or 7
		
		
		local r = h - (30 * line_buffer)
		if r < 0 then
			r = 0
		end

		if IS_DST then
			r = h
		end

		self:SetPosition(0, 0)
		--]]

		-- default y is -30
		-- size info
		local dataPosition = hoverer.insightText:GetPosition()
		local dataWidth, dataHeight = hoverer.insightText:GetRegionSize()

		-- there's a 1 line gap in vanilla (both) between the primarytext and secondarytext
		if hoverer.insightText.raw_text == nil then
			self:SetPosition(0, -30)
		else
			self:SetPosition(0, dataPosition.y - dataHeight)
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