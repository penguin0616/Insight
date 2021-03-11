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

-- repairer.lua
local function Describe(self, context)
	local description, alt_description

	if not (context.config["repair_values"] > 0) then
		return
	end

	if not self.repairmaterial then
		return
	end

	--[[
		self.workrepairvalue = 0
		self.healthrepairvalue = 0
		self.healthrepairpercent = 0
		self.perishrepairpercent = 0
		self.repairmaterial = nil
	]]

	local stuff = {}
	-- repairable only allows you to repair one aspect thanks to elseif's. order: health, workable, perishable
	-- that being said, it looks like some materials are versatile repairers (such as moonrockcrater, moonrocknugget, thulecute (and pieces))
	if (self.healthrepairvalue and self.healthrepairvalue ~= 0) or (self.healthrepairpercent and self.healthrepairpercent ~= 0) then
		stuff[#stuff+1] = string.format(context.lstr.repairer.health2, Round(self.healthrepairvalue or 0, 0), Round((self.healthrepairpercent or 0) * 100, 0) or 0)
	end
	
	if (self.workrepairvalue and self.workrepairvalue ~= 0) then
		stuff[#stuff+1] = string.format(context.lstr.repairer.work2, self.workrepairvalue)
	end
	if (self.perishrepairpercent and self.perishrepairpercent ~= 0) then
		stuff[#stuff+1] = string.format(context.lstr.repairer.perish2, Round(self.perishrepairpercent * 100, 0))
	end

	if #stuff > 0 then
		alt_description = string.format(context.lstr.repairer.type, context.lstr.repairer.materials[self.repairmaterial] or ("\"" .. self.repairmaterial .. "\"")) .. ", " ..  table.concat(stuff, ", ")
	end

	return {
		priority = 0,
		description = nil,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}