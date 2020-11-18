--[[
Copyright (C) 2020 penguin0616

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

local Image = require("widgets/image")
local ItemDetail = import("widgets/itemdetail")

local ItemDetails = Class(Image, function(self)
	-- Image(atlas, tex, default_tex)
	--Image._ctor(self, "images/hud.xml", "inv_slot.tex")
	Image._ctor(self)

	self.details = nil

	self:StartUpdating()
end)

function ItemDetails:Clear()
	self:KillAllChildren()
	self.details = {}
end

function ItemDetails:ApplyDetails(list)
	self:Clear()

	for _, tbl in pairs(list) do
		self:AddDetail(tbl)
	end

	self:Sort()
end

function ItemDetails:Sort()
	local width, height = self:GetSize()
	
	local yoffset = 30 -- base line

	self:GetParent().text:GetString():gsub("\n", function()
		yoffset = yoffset + 30 -- action display 
	end)

	for i,v in pairs(self.details) do
		v:SetPosition(0, height / 2 - yoffset - 15 - (i - 1) * 30)
		v:SetSize(width, 0)
		--v.icon:SetPosition(-width / 2 + 15, 0)
	end
end

function ItemDetails:AddDetail(info)
	local itemDetail = self:AddChild(ItemDetail(info))
	table.insert(self.details, itemDetail)
	return itemDetail
end

function ItemDetails:OnUpdate(...)
	local parent = self:GetParent()

	if parent then
		local x, y = parent.text:GetRegionSize()
		
		self:SetSize(parent.text:GetRegionSize())
		self:SetPosition(parent.text:GetPosition())
		
	end
	
end

return ItemDetails