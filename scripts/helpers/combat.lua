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

-- This file is meant to help me with the variety of damage calculations.
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local world_type = GetWorldType()

local module = {
	
}

local SLINGSHOT_AMMO_DATA = nil

-- Sourced from instances of damagetypebonus/damagetyperesist
local DAMAGE_TYPE_DEFS = {
	-- Normal
	explosive = {
		text_color = Insight.COLORS.LIGHT,
	},

	-- Planar
	lunar_aligned = {
		text_color = Insight.COLORS.ENLIGHTENMENT,
	},
	shadow_aligned = {
		text_color = Insight.COLORS.SHADOW_ALIGNED,
	}, 
}


local POISONOUS_WEAPONS = {"blowdart_poison", "spear_poison"} -- Turns out the game doesn't set the .stimuli on these.
local WEAPON_STIMULI_DEFS = {
	normal = {

	},
	electric = {
		-- This is used if the weapon's electric damage multiplier is missing.
		--default_damage_modifier = TUNING.ELECTRIC_DAMAGE_MULT
	},
	poisonous = {

	},
	thorns = {

	},
}
for i,v in pairs(WEAPON_STIMULI_DEFS) do v.name = i end

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------

--for i,v in pairs(_G.Prefabs) do if v.fn and debug.getinfo(v.fn, "S").source == "scripts/prefabs/slingshotammo.lua" and v.name:sub(-5) == "_proj" then horse=v cprint(v) break end end


local function LoadSlingAmmoData()
	SLINGSHOT_AMMO_DATA = {}

	local ammo_data_key = CurrentRelease.GreaterOrEqualTo("R36_ST_WENDWALTWORT") and "data" or "v"

	-- Load slingshot ammo damages from prefab upvalues.
	-- The actual "ammo" table isn't easily accessible, so we'll just do this.
	for i,v in pairs(_G.Prefabs) do
		-- skins (glomling_winter) are missing .fn i think
		if v.fn and debug.getinfo(v.fn, "S").source == "scripts/prefabs/slingshotammo.lua" then
			--cprint("something", v.name)
			if v.name:sub(-5) == "_proj" then
				local ammo_data = util.getupvalue(v.fn, ammo_data_key)
				--cprint("\tammo data for", v.name, "=", ammo_data)
				if type(ammo_data) == "table" then
					SLINGSHOT_AMMO_DATA[ammo_data.name] = ammo_data
				end
			end
		end
	end
end

--------------------------------------------------------------------------
--[[ Module Functions ]]
--------------------------------------------------------------------------

module.GetDamageTypeModifiers = function(component)
	local modifiers = {}
	
	for tag, sml in pairs(component.tags) do
		local percent = (sml:Get() - 1) * 100
		-- Modifier is generally something like 1.1 or 0.9, where 1 is normall

		modifiers[tag] = percent
	end

	return modifiers
end



--- Calculates the outgoing damage modifier of a character. 
--- It likely only considers "standard" combat modifiers (i.e. Wolfgang, Wigfrid, Wendy).
---@param combat Component
---@return number
module.GetOutgoingDamageModifier = function(combat)
	-- if not combat or context.config["account_combat_modifiers"] == false then
	if not combat then
		return 1
	end

	if world_type == -1 then
		--cprint((combat.damagemultiplier or 1), combat.externaldamagemultipliers:Get(), (combat.damagemultiplier or 1) * combat.externaldamagemultipliers:Get())
		return (combat.damagemultiplier or 1) * combat.externaldamagemultipliers:Get()
		--return combat.externaldamagemultipliers:Get()

	elseif world_type == 0 or world_type == 1 then
		return combat.damagemultiplier or 1

	else
		return combat:GetDamageModifier()
	end
end

--- Gets slingshot ammo data for a prefab after lazy loading the ammo data.
---@param prefab string
---@return table|nil
module.GetSlingshotAmmoData = function(prefab)
	if SLINGSHOT_AMMO_DATA == nil then
		LoadSlingAmmoData()
	end

	return SLINGSHOT_AMMO_DATA[prefab]
end

--- Gets stimuli data for a given stimuli string. A nil stimuli or unknown one is classified as normal.
---@param stimuli string
---@return table @Stimuli data
module.GetStimuliData = function(stimuli)
	if type(stimuli) == "nil" then
		return WEAPON_STIMULI_DEFS.normal
	end

	stimuli = stimuli:lower()

	if WEAPON_STIMULI_DEFS[stimuli] == nil then
		return WEAPON_STIMULI_DEFS.normal
	end

	return WEAPON_STIMULI_DEFS[stimuli]
end

--- Checks if a weapon is poisonous through the prefab table. Annoying.
---@param prefab string
module.IsPrefabPoisonous = function(prefab)
	return table.contains(POISONOUS_WEAPONS, prefab)
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
module.WEAPON_STIMULI_DEFS = WEAPON_STIMULI_DEFS
module.DAMAGE_TYPE_DEFS = DAMAGE_TYPE_DEFS

module.DAMAGE_TYPE_COLORS = setmetatable({}, {
	__index = function(self, index)
		return DAMAGE_TYPE_DEFS[index] and DAMAGE_TYPE_DEFS[index].text_color or nil
	end
})
module.DAMAGE_PRIORITY = 100000

return module