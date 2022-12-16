local patcher_common = import("ds_patches/patcher_common")
local FrontEnd = FrontEnd

local ConsoleScreen = require "screens/consolescreen"
local DebugMenuScreen = require "screens/DebugMenuScreen"

local patches = {}

function patches:IsControlsDisabled()
    return self:GetFadeLevel() > 0
        or (self.fadedir == FADE_OUT and self.fade_delay_time == nil)
        or global_error_widget ~= nil
end

-- This patch is just the DS code, except it has the control isprimary stuff that patched buttons use.
function patches:OnControl(control, down, isrepeat)
--	print ("FE:Oncontrol", control, down)
	--handle focus moves

	if not isrepeat and not down and self.ignoreups[control] then
		self.ignoreups[control] = nil
		return true
	end

	self.isprimary = control == CONTROL_PRIMARY
	if self:IsControlsDisabled() then
		self.isprimary = false
		-- return?
	end


	if #self.screenstack > 0 then
		local screen = self.screenstack[#self.screenstack]
		if control == CONTROL_PRIMARY then control = CONTROL_ACCEPT end  --map this one for buttons
		if screen:OnControl(control == CONTROL_PRIMARY and CONTROL_ACCEPT or control, down) then 
			self.isprimary = false
			return true 
		end
	end

	if CONSOLE_ENABLED and not down and control == CONTROL_OPEN_DEBUG_CONSOLE then
		self.isprimary = false
		self:PushScreen(ConsoleScreen())
		return true
	end

	if DEBUG_MENU_ENABLED then
		if not down and control == CONTROL_OPEN_DEBUG_MENU then
			self.isprimary = false
			self:PushScreen(DebugMenuScreen())
			return true
		end
	end

	if SHOWLOG_ENABLED and not down and control == CONTROL_TOGGLE_LOG then
		self.isprimary = false
		if self.consoletext.shown then 
			self:HideConsoleLog()
		else
			self:ShowConsoleLog()
		end
		return true
	end

	if DEBUGRENDER_ENABLED and not down and control == CONTROL_TOGGLE_DEBUGRENDER then
		self.isprimary = false
		if TheInput:IsKeyDown(KEY_CTRL) then
			TheSim:SetDebugPhysicsRenderEnabled(not TheSim:GetDebugPhysicsRenderEnabled())
		else
			TheSim:SetDebugRenderEnabled(not TheSim:GetDebugRenderEnabled())
		end
		return true
	end


--[[
		elseif control == CONTROL_CANCEL then
			return screen:OnCancel(down)
--]]
	self.isprimary = false
end

function patches.GetIntermediateFocusWidgets(self)
	if #self.screenstack > 0 then
		local widgs = {}
		if self.screenstack[#self.screenstack] then
			local nextWidget = self.screenstack[#self.screenstack]:GetFocusChild()

			while nextWidget and nextWidget ~= self:GetFocusWidget() do
				table.insert(widgs, nextWidget)
				nextWidget = nextWidget:GetFocusChild()
			end
		end
		return widgs
	end
end

-- Reverses the order of default control helps. Oh well!
function patches.GetHelpText(self)
	local t = {}

	local widget = self:GetFocusWidget()
	local active_screen = self:GetActiveScreen()

	if active_screen ~= widget and active_screen ~= nil then
		local str = active_screen:GetHelpText()
		if str ~= nil and str ~= "" then
			table.insert(t, str)
		end
	end

	-- Show the help text for secondary widgets, like scroll bars
	local intermediate_widgets = self:GetIntermediateFocusWidgets()
	if intermediate_widgets then
		for i,v in ipairs(intermediate_widgets) do
			if v and v ~= widget and v.GetHelpText then
				local str = v:GetHelpText()
				if str and str ~= "" then
					if v.HasExclusiveHelpText and v:HasExclusiveHelpText() then
						-- Only use this widgets help text, clear all other help text
						t = {}
						table.insert(t, v:GetHelpText())
						break
					else
						table.insert(t, v:GetHelpText())
					end
				end
			end
		end
	end

	-- Show the help text for the focused widget
	if widget and widget.GetHelpText then
		if widget.HasExclusiveHelpText and widget:HasExclusiveHelpText() then
			-- Only use this widgets help text, clear all other help text
			t = {}
		end

		local str = widget:GetHelpText()
		if str and str ~= "" then
			table.insert(t, widget:GetHelpText())
		end
	end

	return table.concat(t, "  ")
end

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(FrontEnd, patches) end,
}