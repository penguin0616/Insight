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

-- breeder.lua
local function Describe(self, context)
	local description = nil

	if not self.seeded then
		--description = string.format(context.lstr.breeder_needroe)
	else
		local data = self:OnSave()

		local fishstring = string.format(context.lstr.breeder_fishstring, context.lstr["breeder_" .. self.product] or ("\"" .. self.product .. "\""), self.volume, self.max_volume)
		local levelup_time = data.breedtasktime and string.format(context.lstr.breeder_nextfishtime, TimeToText(time.new(data.breedtasktime, context)))

		-- lure tasks don't work properly in shipwrecked, this is due to :OnSave() checking self.luretask instead of self.lureTask, so it never gets exported
		-- this means the threat of a predator is only relevant from when you first plant the roe to when you exit the world
		-- also this means we have to check the component itself
		local predatorcheck_time = self.lureTask and string.format(context.lstr.breeder_possiblepredatortime, TimeToText(time.new(GetTaskRemaining(self.lureTask), context)))

		description = CombineLines(fishstring, levelup_time, predatorcheck_time)
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}