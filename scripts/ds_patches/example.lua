local patcher_common = import("ds_patches/patcher_common")
local EX = require("widgets/EX")

local patches = {}

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(EX, patches) end
}