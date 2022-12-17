local patcher_common = import("ds_patches/patcher_common")
local Input = require("input")

local patches = {}

function patches:UpdateEntitiesUnderMouse()
	self.entitiesundermouse = TheSim:GetEntitiesAtScreenPoint(TheSim:GetPosition())
end

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(Input, patches) end
}