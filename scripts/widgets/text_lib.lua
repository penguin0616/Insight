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

-- man the text widget is so screwed up
local Text = require("widgets/text")

local function Text_SetSize(self, sz)
	if IS_DST then
		return self.SetSize(self, sz)
	end

	if LOC then
		sz = sz * LOC.GetTextScale()
	end
    self.inst.TextWidget:SetSize(sz)
    self.size = sz
end

local function Text_GetSize(self)
	if IS_DST then
		return self.GetSize(self)
	end

    return self.size or self.inst.TextWidget:GetSize()
end

local lib = {}

--lib.SetSize = Text_SetSize
--lib.GetSize = Text_GetSize

lib.ApplyDSGlobalPatch = function(self)
	Text.SetSize = Text_SetSize
	Text.GetSize = Text_GetSize
end

return lib