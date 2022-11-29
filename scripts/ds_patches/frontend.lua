local patcher_common = import("ds_patches/patcher_common")
local FrontEnd = FrontEnd

local patches = {}

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

patcher_common.PatchClass(FrontEnd, patches)

return {}