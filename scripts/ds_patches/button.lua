-- Most stuff here was from DST and was made by Klei. 
local patcher_common = import("ds_patches/patcher_common")
local Button = require("widgets/button")

local patches = {}
local old_ctor = Button._ctor
function patches._ctor(self, ...)
	old_ctor(self, ...)

	self.font = BUTTONFONT
	self.fontdisabled = BUTTONFONT

	--self.textcolour = {0,0,0,1} textcol
	self.textfocuscolour = {0,0,0,1}
	self.textdisabledcolour = {0,0,0,1}
    self.textselectedcolour = {0,0,0,1}

	self.clickoffset = Vector3(0,-3,0)

	self.selected = false


	self.control = CONTROL_ACCEPT
	self.mouseonly = false
	self.help_message = STRINGS.UI.HELP.SELECT
end

function patches:SetControl(ctrl)
	if ctrl == CONTROL_PRIMARY then
		self.control = CONTROL_ACCEPT
	elseif ctrl then
		self.control = ctrl
	end
	self.mouseonly = ctrl == CONTROL_PRIMARY
end

function patches.OnControl(self, control, down)
	if Button._base.OnControl(self, control, down) then return true end

	if not self:IsEnabled() or not self.focus then return false end

	if control == self.control and (not self.mouseonly or TheFrontEnd.isprimary) then
		if down then
			if not self.down then
				TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_move")
				self.o_pos = self:GetLocalPosition()
				self:SetPosition(self.o_pos + self.clickoffset)
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

function patches.OnUpdate(self, dt)
	if self.down then
		if self.whiledown then
			self.whiledown()
		end
	end
end

function patches:OnGainFocus()
	Button._base.OnGainFocus(self)

    if self:IsEnabled() and not self.selected and TheFrontEnd:GetFadeLevel() <= 0 then
    	if self.text then self.text:SetColour(self.textfocuscolour) end
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover", nil, ClickMouseoverSoundReduction and ClickMouseoverSoundReduction() or nil)
	end

    if self.ongainfocus then
        self.ongainfocus(self:IsEnabled())
    end
end

function patches.ResetPreClickPosition(self)
	if self.o_pos then
		self:SetPosition(self.o_pos)
        self.o_pos = nil
    end
end

function patches:OnLoseFocus()
	Button._base.OnLoseFocus(self)

	if self:IsEnabled() and not self.selected then
		self.text:SetColour(self.textcol)
	end
	self:ResetPreClickPosition()

	self.down = false

    if self.onlosefocus then
        self.onlosefocus(self:IsEnabled())
    end
end

function patches:OnEnable()
	if not self.focus and not self.selected then
		self.text:SetColour(self.textcol)
	    self.text:SetFont(self.font)
	end
end

function patches:OnDisable()
    self.text:SetColour(self.textdisabledcolour)
    self.text:SetFont(self.fontdisabled)
end

function patches:Select()
	self.selected = true
	self:OnSelect()
end

function patches:Unselect()
	self.selected = false
	self:OnUnselect()
end

function patches:OnSelect()
	self.text:SetColour(self.textselectedcolour)
    if self.onselect then
        self.onselect()
    end
end

function patches:OnUnselect()
	if self:IsEnabled() then
		if self.focus then
			if self.text then
				self.text:SetColour(self.textfocuscolour[1],self.textfocuscolour[2],self.textfocuscolour[3],self.textfocuscolour[4])
			end
		else
			self:OnLoseFocus()
		end
	else
		self:OnDisable()
	end
    if self.onunselect then
        self.onunselect()
    end
end

function patches:IsSelected()
	return self.selected
end

function patches:SetOnClick( fn )
    self.onclick = fn
end

function patches:SetOnSelect( fn )
    self.onselect = fn
end

function patches:SetOnUnSelect( fn )
    self.onunselect = fn
end

function patches:SetOnUnselect( fn )
    self.onunselect = fn
end

function patches:SetOnDown( fn )
	self.ondown = fn
end

function patches:SetWhileDown( fn )
	self.whiledown = fn
end

function patches:SetFont(font)
	self.font = font
	if self:IsEnabled() then
		self.text:SetFont(font)
		if self.text_shadow then
			self.text_shadow:SetFont(font)
		end
	end
end

function patches:SetDisabledFont(font)
	self.fontdisabled = font
	if not self:IsEnabled() then
		self.text:SetFont(font)
		if self.text_shadow then
			self.text_shadow:SetFont(font)
		end
	end
end

function patches:SetTextColour(r,g,b,a)
	if type(r) == "number" then
		self.textcol = {r,g,b,a}
	else
		self.textcol = r
	end

	if self:IsEnabled() and not self.focus and not self.selected then
		self.text:SetColour(self.textcol)
	end
end

function patches:SetTextFocusColour(r,g,b,a)
	if type(r) == "number" then
		self.textfocuscolour = {r,g,b,a}
	else
		self.textfocuscolour = r
	end

	if self.focus and not self.selected then
		self.text:SetColour(self.textfocuscolour)
	end
end

function patches:SetTextDisabledColour(r,g,b,a)
	if type(r) == "number" then
		self.textdisabledcolour = {r,g,b,a}
	else
		self.textdisabledcolour = r
	end

	if not self:IsEnabled() then
		self.text:SetColour(self.textdisabledcolour)
	end
end

function patches:SetTextSelectedColour(r,g,b,a)
	if type(r) == "number" then
		self.textselectedcolour = {r,g,b,a}
	else
		self.textselectedcolour = r
	end

	if self.selected then
		self.text:SetColour(self.textselectedcolour)
	end
end

function patches:SetTextSize(sz)
	self.size = sz
	self.text:SetSize(sz)
	if self.text_shadow then self.text_shadow:SetSize(sz) end
end

function patches:GetText()
    return self.text:GetString()
end

function patches:SetText(msg, dropShadow, dropShadowOffset)
    if msg then
    	self.name = msg or "button"
        self.text:SetString(msg)
        self.text:Show()
        if self:IsEnabled() then
			self.text:SetColour(self.selected and self.textselectedcolour or (self.focus and self.textfocuscolour or self.textcol))
		else
			self.text:SetColour(self.textdisabledcolour)
		end

		if dropShadow then
			if self.text_shadow == nil then
				self.text_shadow = self:AddChild(Text(self.font, self.size or 40))
				self.text_shadow:SetVAlign(ANCHOR_MIDDLE)
				self.text_shadow:SetColour(.1,.1,.1,1)
				local offset = dropShadowOffset or {-2, -2}
				self.text_shadow:SetPosition(offset[1], offset[2])
			    self.text:MoveToFront()
			end
		    self.text_shadow:SetString(msg)
		end
    else
        self.text:Hide()
        if self.text_shadow then self.text_shadow:Hide() end
    end
end

function patches:SetHelpTextMessage(str)
	if str then
		self.help_message = str
	end
end

function patches:GetHelpText()
	local controller_id = TheInput:GetControllerID()
	local t = {}
	if (not self:IsSelected() or self.AllowOnControlWhenSelected) and self.help_message ~= "" then
    	table.insert(t, TheInput:GetLocalizedControl(controller_id, self.control, false, false ) .. " " .. self.help_message)
    end
	return table.concat(t, "  ")
end


--local Patch = patcher_common.CreateInstancePatcher(patches)
return {
	patches = patches,
	Init = function() patcher_common.PatchClass(Button, patches) end
}