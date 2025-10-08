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

-- basefan.lua [Prefab]
local function OnBaseFanSpawned(inst)
	inst.range_indicator = SpawnPrefab("insight_range_indicator")
	inst.range_indicator:Attach(inst)
	inst.range_indicator:SetRadius(30 / WALL_STUDS_PER_TILE)
	inst.range_indicator:SetColour(Color.fromHex(Insight.COLORS.WET))
	inst.range_indicator:SetVisible(false)

	inst:AddComponent("dst_deployhelper")
	inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end

local function OnClientLoad()
	if not IS_DS then return end
	AddPrefabPostInit("basefan", OnSprinklerSpawned)
end

local function Describe(self, context)
	-- adds tags to itself and then moisture/hay fever handler stuff check for the tags
	return {
		name = "insight_ranged",
		priority = 0,
		description = nil,
		range = 30,
		color = "#00ffff",
		attach_player = false
	}
end



return {
	Describe = Describe,

	OnClientLoad = OnClientLoad,
}