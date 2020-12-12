--[[
Copyright (C) 2020 penguin0616

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

-- hatchable.lua
local function Describe(self, context)
	local description = nil

	--[[
	if self.state == "unhatched" then
		-- need to begin hatching process
		description = string.format("Hatch initialization: %s / %s", self.progress, self.cracktime)
	elseif self.state == "comfy" then
		-- hatching
		description = string.format("Hatching progress: %s / %s", self.progress, self.hatchtime)

	elseif self.state == "uncomfy" then
		-- self.inst is in peril
		--description = string.format("Y State: %s, Hatch Progress: %s / %s", self.state, self.progress, self.hatchtime)
		description = string.format("Discomfort: %s / %s", self.discomfort, self.hatchfailtime)
	end
	--]]

	local discomfort

	if self.hatchfailtime then -- some things just can't die :(
		discomfort = self.discomfort > 0 and string.format(context.lstr.hatchable.discomfort, self.discomfort, self.hatchfailtime) or nil
	end

	local progress = self.state == "comfy" and string.format(context.lstr.hatchable.progress, self.progress, self.hatchtime) or nil

	description = CombineLines(progress, discomfort)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}