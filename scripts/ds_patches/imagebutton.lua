local patcher_common = import("ds_patches/patcher_common")
local ImageButton = require("widgets/imagebutton")

local patches = {
	_base = patcher_common.GetPatcher("button")
}

--================================================================================================================================================================--
--= Global Patches ===============================================================================================================================================--
--================================================================================================================================================================--

function patches.OnControl(self, control, down)
    if not self:IsEnabled() or not self.focus then return end

	--if self:IsSelected() and not self.AllowOnControlWhenSelected then return false end

	if control == CONTROL_ACCEPT then
        if down then
            if not self.down then
                if self.has_image_down then
                    self.image:SetTexture(self.atlas, self.image_down)

                    if self.size_x and self.size_y then
                        self.image:ScaleToSize(self.size_x, self.size_y)
                    end
                end
                TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
                self.o_pos = self:GetLocalPosition()
                if self.move_on_click then
                    self:SetPosition(self.o_pos + self.clickoffset)
                end
                self.down = true
                if self.whiledown then
                    self:StartUpdating()
                end
                if self.ondown then
                    self.ondown()
                end
            end
        else
            if self.down then
                if self.has_image_down then
                    self.image:SetTexture(self.atlas, self.image_focus)

                    if self.size_x and self.size_y then
                        self.image:ScaleToSize(self.size_x, self.size_y)
                    end
                end
                self.down = false
                self:ResetPreClickPosition()
                if self.onclick then
                    self.onclick()
                end
                self:StopUpdating()
            end
        end
        return true
    end
end

function patches.UseFocusOverlay(self, focus_selected_texture)
    if not self.hover_overlay then
        self.hover_overlay = self.image:AddChild(Image())
    end
    --imageLib.SetTexture(self.hover_overlay, self.atlas, focus_selected_texture)
	self.hover_overlay:SetTexture(self.atlas, focus_selected_texture)
    self.hover_overlay:Hide()
    --self:_RefreshImageState()
end

function patches.ForceImageSize(self, x, y)
	self.size_x = x
	self.size_y = y
    self.image:ScaleToSize(self.size_x, self.size_y)
end
--================================================================================================================================================================--
--= Instance Patches =============================================================================================================================================--
--================================================================================================================================================================--

--------------------------------------------------------------------------
--[[ Focus Functions ]]
--------------------------------------------------------------------------
local function OnGainFocus(self)
	ImageButton._base.OnGainFocus(self)

	if self.hover_overlay then
        self.hover_overlay:Show()
	end

	if self:IsEnabled() then
        --imageLib.SetTexture(self.image, self.atlas, self.image_focus)
		self.image:SetTexture(self.atlas, self.image_focus)

        if self.size_x and self.size_y then 
            self.image:ScaleToSize(self.size_x, self.size_y)
        end
    end
end

local function OnLoseFocus(self)
	ImageButton._base.OnLoseFocus(self)

	if self.hover_overlay then
    	self.hover_overlay:Hide()
	end

	if self:IsEnabled() then
        --imageLib.SetTexture(self.image, self.atlas, self.image_normal)
		self.image:SetTexture(self.atlas, self.image_normal)

        if self.size_x and self.size_y then 
            self.image:ScaleToSize(self.size_x, self.size_y)
        end
    end
end

-- I want this available globally. I might change my mind down the road though.
--[[
widgetLib.imagebutton.OverrideFocuses\(([^)]+)\)
$1:InsightOverrideFocuses()
]]
function patches.InsightOverrideFocuses(self)
    if IS_DST then
        return
    end
	self.OnGainFocus = OnGainFocus
	self.OnLoseFocus = OnLoseFocus
end

--patcher_common.debugging = true
patcher_common.PatchClass(ImageButton, patches)
--patcher_common.debugging = false

return {
	--Patch = Patch
}