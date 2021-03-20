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

-- scenariorunner.lua

local chestfunctions = require("scenarios/chestfunctions")
local chest_openfunctions = require("scenarios/chest_openfunctions")
local chest_openfunctions_key = table.invert(chest_openfunctions)

local chest_cache = setmetatable({}, {})


local function RuinsChest(self, context)
	if not self.inst.scene_triggerfn then
		return "err: no trigger fn"
	end

	local openfn = util.getupvalue(self.inst.scene_triggerfn, "openfn")
	if not openfn then
		return "err: no openfn"
	end

	--[[
		sanity = sanitydelta,
	hunger = hungerdelta,
	health = healthdelta,
	inventory = inventorydelta,
	summonmonsters = summonmonsters
	]]

	local key = chest_openfunctions_key[openfn]

	return key and context.lstr.scenariorunner.chest_labyrinth[key] or "Unknown scenario."
end

-- so normally i would handle this here, except that scenariorunner gets removed once the scenario runs. i want to be able to tell users that a ruins chest has been opened, which i can't do from here.
-- so i handle it in the container descriptor.
local function Describe(self, context)
	local description = nil

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe,
	RuinsChest = RuinsChest
}