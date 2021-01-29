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

local ImageButton = require("widgets/imagebutton")
local imageLib = import("widgets/image_lib")

-- ImageButton functions from DST with modifications
local function ImageButton_OnGainFocus(self)
	ImageButton._base.OnGainFocus(self)

	if self.hover_overlay then
        self.hover_overlay:Show()
	end

	if self:IsEnabled() then
        imageLib.SetTexture(self.image, self.atlas, self.image_focus)

        if self.size_x and self.size_y then 
            self.image:ScaleToSize(self.size_x, self.size_y)
        end
    end
end

local function ImageButton_OnLoseFocus(self)
	ImageButton._base.OnLoseFocus(self)

	if self.hover_overlay then
    	self.hover_overlay:Hide()
	end

	if self:IsEnabled() then
        imageLib.SetTexture(self.image, self.atlas, self.image_normal)

        if self.size_x and self.size_y then 
            self.image:ScaleToSize(self.size_x, self.size_y)
        end
    end
end

local function ImageButton_UseFocusOverlay(self, focus_selected_texture)
    if not self.hover_overlay then
        self.hover_overlay = self.image:AddChild(Image())
    end
    imageLib.SetTexture(self.hover_overlay, self.atlas, focus_selected_texture)
    self.hover_overlay:Hide()
    --self:_RefreshImageState()
end

local function ImageButton_ForceImageSize(self, x, y)
    if self.ForceImageSize then
        return self.ForceImageSize(self, x, y)
    end
    
	self.size_x = x
	self.size_y = y
    self.image:ScaleToSize(self.size_x, self.size_y)
end

local lib = {}

lib.ForceImageSize = ImageButton_ForceImageSize
lib.UseFocusOverlay = ImageButton_UseFocusOverlay

lib.OverrideFocuses = function(self)
    if IsDST() then
        return
    end
	self.OnGainFocus = ImageButton_OnGainFocus
	self.OnLoseFocus = ImageButton_OnLoseFocus
end










return lib