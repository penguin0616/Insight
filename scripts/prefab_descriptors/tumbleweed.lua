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

-- tumbleweed.lua [Prefab]
local LOOT_COLORS

local function GetLootColors()
	LOOT_COLORS = {
		none = util.COLORS_ADD.NOTHING,

		blueprint = util.COLORS_ADD.BLUE,
		mob = util.COLORS_ADD.RED,
		gears = util.COLORS_ADD.ORANGE,
		valuable = util.COLORS_ADD.GREEN,
		trinket = util.COLORS_ADD.YELLOW,
	}
end

-- RegisterPrefabsImpl
local function OnServerSpawn(inst)
	inst._loot = net_string(inst.GUID, "insight_tumbleweed_loot", "insight_tumbleweedloot_dirty")
	
	if inst.loot then
		inst._loot:set(table.concat(inst.loot, ","))
	end
end

local function OnServerInit()
	if IS_DS then return end -- Handled by client
	GetLootColors()
	AddPrefabPostInit("tumbleweed", OnServerSpawn)
end


local function GetLootType(prefab)
	if prefab == "blueprint" then
		return "blueprint"
	elseif prefab == "rabbit" or prefab == "mole" or prefab == "spider" or prefab == "frog" or prefab == "bee" or prefab == "mosquito" then
		return "mob"
	elseif prefab == "gears" then
		return "gears"
	elseif prefab:sub(-3) == "gem" then
		return "valuable"
	elseif prefab:sub(1, 7) == "trinket" then
		return "trinket"
	end
end

local function ProcessLoot(inst)
	--print(table.concat(inst.insight_loot, ", "))
	local loot = inst.insight_loot

	local info = { blueprint=false, mob=false, gears=false, valuable=false, trinket=false }

	for i = 1, #loot do
		local prefab = loot[i]
		local typ = GetLootType(prefab)
		if info[typ] ~= nil then
			info[typ] = true
		end
	end

	
	-- The priority approach
	local final_color
	if info.valuable then
		final_color = LOOT_COLORS.valuable
	elseif info.gears then
		final_color = LOOT_COLORS.gears
	elseif info.blueprint then
		final_color = LOOT_COLORS.blueprint
	elseif info.trinket then
		final_color = LOOT_COLORS.trinket
	elseif info.mob then
		final_color = LOOT_COLORS.mob
	else
		final_color = LOOT_COLORS.none
	end

	inst.AnimState:SetAddColour(unpack(final_color))

	-- The summation approach
	--[[
	local final_color = LOOT_COLORS.none
	for typ, yes in pairs(info) do
		if yes then
			local clr = LOOT_COLORS[typ]
			final_color[1] = math.min(final_color[1] + clr[1], 1)			
			final_color[2] = math.min(final_color[2] + clr[2], 1)			
			final_color[3] = math.min(final_color[3] + clr[3], 1)
			final_color[4] = math.min(final_color[4] + clr[4], 1)
		end
	end
	--]]

	-- The generalization approach
	--[[
	local final_color
	for typ, yes in pairs(info) do
		if yes then
			if final_color then
				final_color = util.COLORS_ADD.PINK
				break
			else
				final_color = LOOT_COLORS[typ]
			end
		end
	end

	final_color = final_color or LOOT_COLORS.none
	--]]

	
end

local function OnLootDirty(inst)
	if not localPlayer then 
		OnLocalPlayerPostInit:AddWeakListener(function() OnLootDirty(inst) end)
		return 
	end

	local context = GetPlayerContext(localPlayer)
	if not context.config["tumbleweed_info"] then
		if inst.insight_loot then
			inst.AnimState:SetAddColour(0, 0, 0, 0)
			inst.insight_loot = nil
		end
		return
	end


	local str = inst._loot:value()
	if str == "" then
		if inst.insight_loot then
			inst.AnimState:SetAddColour(0, 0, 0, 0)
			inst.insight_loot = nil
		end
		return
	end

	local loot = {}
	for prefab in string.gmatch(str, "([^,]+)") do
		loot[#loot+1] = prefab
	end
	
	inst.insight_loot = loot
	
	ProcessLoot(inst)
end


local function OnClientSpawn(inst)
	if IS_DST then
		if not inst._loot then
			inst._loot = net_string(inst.GUID, "insight_tumbleweed_loot", "insight_tumbleweedloot_dirty")
		end

		if not IS_CLIENT_HOST then
			-- I'm not dealing with util networking.
			inst:ListenForEvent("insight_tumbleweedloot_dirty", OnLootDirty)
			OnLootDirty(inst)
			return
		end
	else
		OnLootDirty(inst)
	end
end

local function OnClientInit()
	GetLootColors()

	-- Good enough
	--LOOT_TABLE = util.recursive_getupvalue(_G.Prefabs.tumbleweed.fn, "possible_loot")
	entity_tracker:TrackPrefab("tumbleweed")
	AddPrefabPostInit("tumbleweed", OnClientSpawn)

	OnContextUpdate:AddListener("tumbleweed", function(context)
		for i,v in pairs(entity_tracker:GetInstancesOf("tumbleweed")) do
			OnLootDirty(v)
		end
	end)
end




local function Describe(inst, context)
	if not context.config["tumbleweed_info"] then return end
	if not inst.loot then
		return
	end

	-- inst.loot is actual loot prefabs
	-- inst.lootaggro is used for determining combat aggression, indexes match across tables
	local alt_description = {}
	for i,v in pairs(inst.loot) do
		alt_description[i] = "<prefab=" .. v ..">"
		--[[
		local typ = GetLootType(v)
		if typ then
			local color = Color.new(unpack(LOOT_COLORS[typ])):ToHex()
			alt_description[i] = ApplyColor(alt_description[i], color)
		end
		--]]
	end

	if #alt_description > 0 then
		alt_description = table.concat(alt_description, ", ")
	else
		alt_description = nil
	end
	
	return {
		priority = 0,
		alt_description = alt_description,
		prefably = true
	}
end



return {
	OnServerInit = OnServerInit,
	OnClientInit = OnClientInit,


	Describe = Describe
}