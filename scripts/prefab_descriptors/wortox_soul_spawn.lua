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

-- wortox_soul_spawn.lua [Prefab]
local function OnSoulSpawned(inst)
	if not (localPlayer and localPlayer:HasTag("soulstealer")) then
		return
	end

	-- TODO: Update to context?
	if not GetModConfigData("wortox_soul_range", true) then
		return
	end

	inst.pickup_indicator = SpawnPrefab("insight_range_indicator")
	inst.pickup_indicator:Attach(inst)
	inst.pickup_indicator:SetRadius(TUNING.WORTOX_SOULSTEALER_RANGE / WALL_STUDS_PER_TILE) 
	inst.pickup_indicator:SetColour(Color.fromHex(Insight.COLORS.HEALTH))

	--[[
	local yes2 = SpawnPrefab("insight_range_indicator")
	yes2.entity:SetParent(inst.entity)

	yes2:SetRadius_Zark(TUNING.WORTOX_SOULSTEALER_RANGE / WALL_STUDS_PER_TILE - offset)
	yes2:SetColour(0, 1, 0, 1)
	--]]
end


local function OnClientInit()
	if not IS_DST then return end
	-- This is for the soul that gets dropped from enemies.
	AddPrefabPostInit("wortox_soul_spawn", OnSoulSpawned)
end

return {
	OnClientInit = OnClientInit
}