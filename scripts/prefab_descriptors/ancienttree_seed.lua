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

-- ancienttree_seed.lua [Prefab]
local Color = Color
local TREE_DEFS = require("prefabs/ancienttree_defs").TREE_DEFS
local PLANT_DATA = require("prefabs/ancienttree_defs").PLANT_DATA

local TREE_TYPE_COLORS = setmetatable({
	gem = Color.fromHex("#E94209"),
	nightvision = Color.fromHex("#6456CA")--Color.fromHex("#5446BA"), -- added more blue to the light purple of the tree
}, {
	__index = function(self, index)
		rawset(self, index, Color.fromHex("#acacac"))
		return self[index]
	end
})

local bottom = Color.fromRGB(160, 230, 160) --Color.fromHex("#8cec8c")
local top = Color.fromRGB(230, 160, 160) --Color.fromHex("#ec8c8c")

local function Describe(inst, context)
	local description, alt_description = nil, nil

	
	if inst.type then
		local def = TREE_DEFS[inst.type]
		if not def then
			return
		end

		local tree_prefab = "ancienttree_" .. inst.type
		local tree_color = TREE_TYPE_COLORS[inst.type]

		local seed_type_string = string.format(context.lstr.ancienttree_seed.type, 
			tree_color:ToHex(),
			tree_prefab
		)
	
		local regen_time_simple
		local regen_time_advanced

		if inst._plantdata then
			regen_time_simple = string.format(context.lstr.ancienttree_seed.fruit_regen_time, 
				context.time:SimpleProcess(inst._plantdata.fruit_regen)
			)
			regen_time_advanced = string.format(context.lstr.ancienttree_seed.fruit_regen_time_bounded, 
				ApplyColour(context.time:SimpleProcess(PLANT_DATA.fruit_regen.min, "gametime_short"), bottom),
				ApplyColour(
					context.time:SimpleProcess(inst._plantdata.fruit_regen), 
					bottom:Lerp(top, Remap(inst._plantdata.fruit_regen, PLANT_DATA.fruit_regen.min, PLANT_DATA.fruit_regen.max, 0, 1) )
				),
				ApplyColour(context.time:SimpleProcess(PLANT_DATA.fruit_regen.max, "gametime_short"), top)
			)
		end

		description = CombineLines(seed_type_string, regen_time_simple)
		alt_description = CombineLines(seed_type_string, regen_time_advanced)
	end
	
	return {
		priority = 0,
		description = description,
		alt_description = alt_description,
		prefably = true,
	}
end



return {
	Describe = Describe
}