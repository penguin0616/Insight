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
local Text = require "widgets/text"
local Image = require "widgets/image"

local strs = {
	"YOU ARE USING A TAMPERED VERSION OF Insight, PLEASE USE THE OFFICIAL VERSION ON STEAM.", -- en
	"USTED ESTÁ UTILIZANDO UNA VERSIÓN PELIGROSA DE Insight, POR FAVOR UTILICE EL OFICIAL EN Steam.", -- sp
	"您正在使用Insight的篡改版本，请在Steam上使用正式版本。", -- ch
	"Вы используете поддельную версию Insight, пожалуйста, используйте официальную версию в Steam.", -- ru
}

local InsightDangerScreen = Class(Screen, function(self)
	Screen._ctor(self, "InsightDangerScreen")

	local x, y = TheSim:GetScreenSize()

	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0, 0, 0)
	self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)
	
	self.bg = self.root:AddChild(Image("images/White_Square.xml", "White_Square.tex"))
	self.bg:SetTint(0, 0, 0, 1)
	self.bg:SetSize(x, y)

	self.text = self.root:AddChild(Text(UIFONT, 40))
	self.text:SetColour(1, 1, 1, 1)
	self.text:EnableWordWrap(true)
	self.text:SetString(string.rep(table.concat(strs, "\n"), 1))
	self.text:SetRegionSize(x * 0.75, y * 0.75)
end)

return InsightDangerScreen