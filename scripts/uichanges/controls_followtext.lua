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

local FollowText = require("widgets/followtext")
local RichText = import("widgets/RichText")
local RichFollowText = import("widgets/richfollowtext")
local infotext_common = import("uichanges/infotext_common").Initialize()

local function countnewlines(str)
	return select(2, str:gsub("\n", "\n"))
end

local function IsValidTarget(target)
	return target ~= localPlayer
end

local function UpdateFollowText(self, ...)
	if self.primaryInsightText.text.size ~= infotext_common.configs.followtext_insight_font_size then
		self.primaryInsightText.text:SetSize(infotext_common.configs.followtext_insight_font_size)
		if self.primaryInsightText2 then
			self.primaryInsightText2.text:SetSize(self.primaryInsightText.text:GetSize())
		end
	end

	local itemIndex, itemInActions = ...
	
	-- DS has a similar but different set of checks.
	if IS_DS then
		local t1 = self.owner.components.playercontroller.controller_target and self.owner.components.playercontroller.controller_target:IsValid()
		local t2 = self.playeractionhint.target or self.groundactionhint.target
		itemIndex = t1 and t2 -- This should technically be #cmds but I'm only using it as a condition for truth.
		itemInActions = self.playeractionhint.shown
	end

	if itemIndex then
		if not self.primaryInsightText.shown then
			--print("Showing InsightText")
			self.primaryInsightText:Show()
			if self.primaryInsightText2 then
				self.primaryInsightText2:Show()
			end
		end


		-- The itemhighlight has the entity name.
		-- This has the information about the item.
		local followerWidget 
		if itemInActions then
			followerWidget = self.playeractionhint
		else
			followerWidget = self.groundactionhint
		end

		-- Doing this just like inventorybar until I get feedback that suggests otherwise.
		if followerWidget.text.size ~= infotext_common.configs.followtext_insight_font_size then
			followerWidget.text:SetSize(infotext_common.configs.followtext_insight_font_size)
		end

		local widgetWithEntityName = (IS_DST and self.playeractionhint_itemhighlight) or self.playeractionhint
		
		local offsetx, offsety = followerWidget:GetScreenOffset()
		self.primaryInsightText:SetTarget(followerWidget.target)
		if self.primaryInsightText2 then self.primaryInsightText2:SetTarget(followerWidget.target) end

		-- Show prefab if enabled
		if DEBUG_SHOW_PREFAB and IsValidTarget(followerWidget.target) then
			local text = widgetWithEntityName.text:GetString()

			local pos = string.find(text, "\n")
			local prefab = " [" .. followerWidget.target.prefab .. "]"
			if pos then
				text = string.sub(text, 1, pos - 1) .. prefab .. string.sub(text, pos)
			else
				text = text .. prefab
			end

			widgetWithEntityName.text:SetString(text)
		end

		local followtext_lines = select(2, followerWidget.text:GetString():gsub("\n", "\n"))

		-- Reduced version of the logic from hoverer.
		local entityInformation
		if IsValidTarget(followerWidget.target) then
			entityInformation = RequestEntityInformation(followerWidget.target, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })
		end

		local itemDescription = nil
		if entityInformation and entityInformation.information then
			itemDescription = RichText.TrimNewlines(entityInformation.information)
		end

		if itemDescription then
			local insight_lines = select(2, itemDescription:gsub("\n", "\n")) + 1 -- Since I'm counting newlines, insight_lines is always 1 short. 
			-- However, trailing newlines have about half their actual height here (probably due to the middle vertical align). That means I need to add 1 more (aka double it) for Insight. 
			insight_lines = insight_lines + 1
			-- That leaves me with an overlap similar to the hoverer before the :SetPosition().
			-- One difference though: I correct the hoverer with a :SetPosition().
			-- The overlap here is half a newline's worth. Which means instead of adjusting the offset, I'll just add another to the line count.
			insight_lines = insight_lines + 1


			local total_lines = (followtext_lines) + (insight_lines) 
			self.primaryInsightText.text:SetString(string.rep("\n", total_lines) .. itemDescription)
			--self.primaryInsightText2.text:SetString(string.rep("\n", followtext_lines*2 + insight_lines) .. something .. ": A BLASPHEMOUS MOCKERY")
			
			--[[
			-- Testing with \n and \n\n confirms the preceeding newline stripping logic noted in RichText.
			self.primaryInsightText.text:SetString("\n\nRichText"..followerWidget.text:GetString())
			self.primaryInsightText2.text:SetString("\n\nNormText"..followerWidget.text:GetString())	
			]]
		else
			self.primaryInsightText.text:SetString(nil)
		end
		
	else
		if self.primaryInsightText.shown then
			--print("Hiding InsightText")
			self.primaryInsightText:Hide()
			if self.primaryInsightText2 then
				self.primaryInsightText2:Hide()
			end
		end
	end
end


-- TODO: Can these 2 functions be simplified/incorporated to reduce function call overhead?
local function Controls_OnUpdate(self, ...)
	module.oldOnUpdate(self, ...)
	return UpdateFollowText(self, nil, nil)
end

local function Controls_HighlightActionItem(self, ...)
	module.oldHighlightActionItem(self, ...)
	return UpdateFollowText(self, ...)
end

local function OnControlsPostInit(controls)
	-- !! These comments & documentation are largely for DST. They might apply to DS as well.

	-- This is whatever is currently "selected", text is always the available actions.
	-- Starts with a newline (I assume for the entity name)
	-- See attack hit for notes on attack action.
	-- ~In DS, this is both the entity name and actions.
	--[[
	local old1 = controls.playeractionhint.SetTarget
	controls.playeractionhint.SetTarget = function(self, ...)
		--mprint("playeractionhint SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old1(self, ...)
	end
	--]]

	-- This is whatever is currently "selected"
	-- Text is always starts with the entity name. If the enemy name has multiple lines, only the first line is here. 
	-- 		The other lines become part of playeractionhint.
	-- ~In DS, this is doesn't exist. The entity name is included in playeractionhint.
	-- Text doesn't start with a newline, has 1 newline for every line in old1
	--[==[Ex:
		if playeractionhint is 
[[
(Y) Inspect
(A) Pickup]]
		then this text is
[[Twigs
 
 
]] (aka "Twigs\n \n ")
	]==]
	--[[
	local old2 = controls.playeractionhint_itemhighlight.SetTarget
	controls.playeractionhint_itemhighlight.SetTarget = function(self, ...)
		--mprint("playeractionhint_itemhighlight SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old2(self, ...)
	end
	--]]

	-- This is a secondary selector that shows the attack action on a nearby mob that isn't the primary focus
	-- If a target with this attackhint becomes the primary focus, it can no longer be the target here.
	-- Text doesn't start with a newline, nor any ending newlines
	-- Text is initially empty until assigned to the "(X) Attack" action
	--[[
	local old3 = controls.attackhint.SetTarget
	controls.attackhint.SetTarget = function(self, ...)
		--mprint("attackhint SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old3(self, ...)
	end
	--]]

	-- This is for turf related stuff and placing structures
	-- Text doesn't start with a newline or end with one
	-- Can either be "Dig" or "Place Ground" newline (and space?) "Cancel"
	-- The text is attached to the player for pitchforking and placing structures, and is attached to the tile grid when placing turf
	--[[
	local old4 = controls.groundactionhint.SetTarget
	controls.groundactionhint.SetTarget = function(self, ...)
		--mprint("groundactionhint SetTarget:", ..., " -------------> ", "|"..tostring(self.text:GetString()).."|::"..countnewlines(self.text:GetString()))
		return old4(self, ...)
	end
	--]]
	
	controls.primaryInsightText = controls:AddChild(RichFollowText(TALKINGFONT, infotext_common.configs.followtext_insight_font_size))
	controls.primaryInsightText:SetHUD(controls.owner.HUD.inst)
    controls.primaryInsightText:SetOffset(Vector3(0, 100, 0))
    controls.primaryInsightText:Hide()

	--[[
	controls.primaryInsightText2 = controls:AddChild(FollowText(TALKINGFONT, infotext_common.configs.followtext_insight_font_size))
	controls.primaryInsightText2:SetHUD(controls.owner.HUD.inst)
    controls.primaryInsightText2:SetOffset(Vector3(1600, 100, 0))
    controls.primaryInsightText2:Hide()
	--]]

	if IS_DST then
		module.oldHighlightActionItem = controls.HighlightActionItem
		controls.HighlightActionItem = Controls_HighlightActionItem
	else
		module.oldOnUpdate = controls.OnUpdate
		controls.OnUpdate = Controls_OnUpdate
	end
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	AddClassPostConstruct("widgets/controls", OnControlsPostInit)
end

return module