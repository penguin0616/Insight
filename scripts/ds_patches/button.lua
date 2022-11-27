local patcher_common = import("ds_patches/patcher_common")
local Button = require("widgets/button")

local patches = {}

function patches.SetOnDown(self, fn)
	self.ondown = fn
end

function patches.SetWhileDown(self, fn)
	self.whiledown = fn
end

function patches.ResetPreClickPosition(self)
	if self.o_pos then
		self:SetPosition(self.o_pos)
        self.o_pos = nil
    end
end

function patches.OnControl(self, control, down)
	if Button._base.OnControl(self, control, down) then return true end

	if not self:IsEnabled() or not self.focus then return false end

	if control == CONTROL_ACCEPT then
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

patcher_common.PatchClass(Button, patches)
--local Patch = patcher_common.CreateInstancePatcher(patches)

return {
	--Patch = Patch
}