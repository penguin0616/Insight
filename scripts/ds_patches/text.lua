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

local patcher_common = import("ds_patches/patcher_common")
local Text = require("widgets/text")

local patches = {
	_base = patcher_common.GetPatcher("widget")
}


local old_ctor = Text._ctor
function patches._ctor(self, font, size, text)
	old_ctor(self, font, size, text)
	self:SetSize(size)
end

-- And with the ctor patch, this is mostly no longer needed too!
-- But I'm keeping it here for cases where a Text got initialized before the patch.
-- Unless I decide to add something that'll patch already-instantiated classes, but that seems like an even bigger bucket of worms.
-- Overall, very nice :)
function patches.GetSize(self)
	if not self.size then
		self.size = self.inst.TextWidget:GetSize()
	end

	return self.size
end

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(Text, patches) end,
}