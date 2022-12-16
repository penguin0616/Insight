local patcher_common = import("ds_patches/patcher_common")
local Screen = require("widgets/screen")

local patches = {}

local old_ctor = Screen._ctor
function patches._ctor(self, ...)
	old_ctor(self, ...)
	self.is_screen = true
end

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(Screen, patches) end
}