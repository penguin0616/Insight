local patcher_common = import("ds_patches/patcher_common")
local Spinner = require("widgets/spinner")

local patches = {}

function patches:GetSelectedText()
	if self.options[self.selectedIndex] and self.options[self.selectedIndex].text then
		return self.options[ self.selectedIndex ].text, self.options[self.selectedIndex].colour
	else
		return ""
	end
end

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(Spinner, patches) end
}