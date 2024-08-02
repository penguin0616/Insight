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

-- i don't quite recall what this was used for, but it has been repurposed
-- i think it was a very early prototype of richtext / icon mode
local Widget = require("widgets/widget")
local Image = require("widgets/image")
local RichText = import("widgets/RichText")
local Text = require("widgets/text")
local infotext_common = import("uichanges/infotext_common").Initialize()

local text_holder_padding = 0 -- padding of 20 for the scrollbar

local ItemDetail = Class(Widget, function(self, info)
	-- Image(atlas, tex, default_tex)
	--Image._ctor(self, atlas, "inv_slot.tex")
	Widget._ctor(self, "ItemDetail")

	assert(type(info) == 'table', "ItemDetail(info): info must be a table")
	assert(info.width, "info.width must be specified")
	assert(info.height, "info.height must be specified")

	self.componentName = nil

	
	self.yep = self:AddChild(Image(DEBUG_IMAGE()))
	self.yep:SetTint(1, 1, 1, .5)
	self.yep:SetSize(info.width, info.height)
	

	--[[
	self.icon_holder2 = self:AddChild(Image("images/avatars.xml", "avatar_bg.tex"))
	self.icon_holder2:SetSize(64, 64)
	--]]

	self.icon_holder = self:AddChild(Image("images/hud.xml", "inv_slot.tex")) -- in the bundle
	--self.icon_holder:SetTint(0, .5, 0, .7)
	--self.icon_holder:SetTexture("images/avatars.xml", "avatar_frame_white.tex")
	self.icon_holder:SetSize(64, 64) -- needs to be set on :SetIcon(), but it is needed here for the rest of the ctor 
	self.icon_holder:Hide()

	local icon_holder_width, icon_holder_height = self.icon_holder:GetSize()

	self.icon_holder:SetPosition(-info.width/2 + icon_holder_width/2, 0)
	--self.icon_holder2:SetPosition(-info.width/2 + icon_holder_width/2, 0)

	

	self.icon = (self.icon_holder2 or self.icon_holder):AddChild(Image())
	--self.icon:SetSize(icon_holder_width, icon_holder_height) 

	-- The image for row.tex has blank pixels: ~8 empty top, ~5 empty bottom
	self.text_holder = self:AddChild(Image("images/dst/scoreboard.xml", "row.tex")) -- avatars.xml
	self.text_holder:SetSize(info.width - icon_holder_width - text_holder_padding, info.height + (13/2.5)) 
	self.text_holder:SetPosition(icon_holder_width/2 - text_holder_padding/2, 0) -- subtract 10 to keep icon_holder and text still bordering eachother
	self.text_holder:Hide()

	local f = self.text_holder:AddChild(Image("images/dst/scoreboard.xml", "row.tex"))
	f:SetSize(self.text_holder:GetSize())
	f:SetRotation(180)
	
	--self.text = self.text_holder:AddChild(Text(UIFONT, 30, nil))
	--self.text:SetHAlign(ANCHOR_RIGHT)
	self.text = self.text_holder:AddChild(RichText(util.GetInsightFont()))
	self.text:SetSize(22)
	--self.text:SetRegionSize(self.text_holder:GetSize())
	--self.text:SetPosition(icon_holder_width/2, 0)
	--self.text:SetHAlign(ANCHOR_LEFT)

	--[[
	self.heckler = self:AddChild(Image(DEBUG_IMAGE()))
	--self.heckler:SetTint(.5, 0, 0, .7)
	self.heckler:SetSize(info.width - icon_holder_width - 20, icon_holder_height) -- padding of 20 for the scrollbar
	self.heckler:SetPosition(icon_holder_width/2 - 10, 0) -- subtract 10 to keep icon_holder and text still bordering eachother
	--]]

	self.config_listener = infotext_common.new_configs_event:AddListener("ItemDetail_" .. self.inst.GUID, function()
		if self.inst:IsValid() then
			self.text:SetFont(util.GetInsightFont())
		end
	end)
end)

function ItemDetail:Kill()
	self.config_listener:Remove()
	return Widget.Kill(self)
end

function ItemDetail:OnControl(control, down)
	-- Check input and component name
	local cmp = (self.componentData and self.componentData.source_descriptor) or self.componentName
	if cmp and control == CONTROL_ACCEPT and down and TheInput:IsControlPressed(CONTROL_FORCE_INSPECT) then
		-- Check localplayer status
		if localPlayer and localPlayer.HUD._StatusAnnouncer then
			-- Using self.componentName so that we can use the special data from the named data.
			local special_data = localPlayer.replica.insight.world_data.special_data[self.componentName]

			local describer = special_data and (
				(special_data.prefably and Insight.prefab_descriptors[cmp] and Insight.prefab_descriptors[cmp].StatusAnnoucementsDescribe) or
				(Insight.descriptors[cmp] and Insight.descriptors[cmp].StatusAnnoucementsDescribe)
			)

			if describer then
				local data = describer(special_data, GetPlayerContext(localPlayer), TheWorld)
				if data and data.description then
					-- Using self.componentName here so that the cooldown is unique per individual describe from a descriptor, not for the entire descriptor.
					localPlayer.HUD._StatusAnnouncer:Announce(data.description, self.componentName) 
				end
			end
		end

		return true
	end

	return Widget.OnControl(self, control, down)
end

function ItemDetail:SetText(str)
	if type(str) == "string" then
		--str = ResolveColors(str)
	end

	if str == nil then
		self.text_holder:Hide()
	else
		self.text_holder:Show()
	end

	if str then
		--str = "\n\n\n"..str .. "alpha\nbeta\nthree"
	end

	self.text:SetString(str)
end

function ItemDetail:SetIcon(atlas, tex)
	-- atlas gets resolved so it doesnt match
	--local resolved = atlas ~= nil and resolvefilepath(atlas) or nil

	if (self.icon.atlas == atlas) and self.icon.texture == tex then
		-- optimize?
		--dprint('optimized', atlas, tex, "|||||", self.icon.atlas, self.icon.texture, "|||||", atlas == self.icon.atlas, tex == self.icon.texture)
		return
	end

	if atlas == nil and tex == nil then
		self.icon_holder:Hide()
		if self.icon_holder2 then
			self.icon_holder2:Hide()
		end
	elseif tex and atlas then
		self.icon_holder:Show()
		self.icon:RealSetTexture(atlas, tex)
		if self.icon_holder2 then
			self.icon_holder2:Show()
		end
		self.icon:SetSize(56, 56)
	else
		error("expected atlas and tex in ItemDetail:SetIcon")
	end
	
	--self.icon:SetPosition(4, 4)
end

return ItemDetail