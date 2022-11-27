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


function patches.SetSize(self, sz)
	if LOC then
		sz = sz * LOC.GetTextScale()
	end
    self.inst.TextWidget:SetSize(sz)
    self.size = sz
end

function patches.GetSize(self)
    return self.size or self.inst.TextWidget:GetSize()
end

patcher_common.PatchClass(Text, patches)

return {}