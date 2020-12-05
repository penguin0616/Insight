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

-- things to load
-- NOTE: c_reset() will not recognize freshly copied stuff, have to physically reload world
-- when grabbing image from wiki, can remove the shortener from the url (https://dontstarve.fandom.com/wiki/Crock_Pot#Food_groups)

-- zark: 
-- premultiply alpha = fixes the empty space whiteness
-- generate mipmaps = "mapmaps make your image look nicer when its displayed on the screen smaller"

--================================================================================================================================================================--
--= Atlases ======================================================================================================================================================--
--================================================================================================================================================================--

local known_atlases = {
	"images/inventoryimages.xml", -- DS/DST
	"images/hud.xml", -- DS/DST
}

if IsDS() then -- prevent TheSim:AtlasContains throwing a warning instead of an error from the engine
	table.insert(known_atlases, "images/inventoryimages_2.xml") -- DS
else
	table.insert(known_atlases, "images/inventoryimages1.xml") -- DST
	table.insert(known_atlases, "images/inventoryimages2.xml") -- DST
end

local atlas_lookups = {}
local atlas_hud = "images/hud.xml"
local atlas_inv = "images/inventoryimages.xml"

--================================================================================================================================================================--
--= Assets =======================================================================================================================================================--
--================================================================================================================================================================--
local BulkAssets = {
	"Ancient_Herald", "Antlion", "Antqueen", "Arrow", "Arrow_Down", "Atrium_Gate", "Bearger", "Beequeen", "Blueprint", "Chester_Eyebone", "Claywarg", "Crabking", "Crocodog", "Crown", "Deerclops", "Depths_Worm", "Dirtpile", "Dragonfly", "Enlightenment_Meter", "Frog", "Gingerbreadpig", "Gingerbreadwarg", "Health_Meter", "Hound", "Hunger_Meter", "Hutch_Fishbowl", "Klaus", "Klaus_Sack", "Knightboat", "Koalefant_Summer", "Koalefant_Winter", "Kraken", "Krampus", "Leif", "Leif_Sparse", "Lightninggoat", "Magnifying_Glass", "Malbatross", "Mermking", "Minotaur", "Moose", "Nightmare_timepiece_dawn", "Oar", "Oar_Force", "Pigcrownhat", "Pocket_Scale", "Pugalisk", "Sanity_Arrow", "Sanity_Meter", "Spat", "Spiderqueen", "Stalker", "Stalker_Atrium", "Stalker_Forest", "Stopwatch", "Tigershark", "Toadstool", "Treeguard", "Twister", "Twister_Seal", "Volcano", "Volcano_Active", "Warg", "Wetness_Meter", "Whale_Blue", "Whale_Bubbles", "Whale_White", "White_Rounded", "White_Square"
}

Assets = {
	-- DST migration to DS
	Asset("ATLAS", "images/dst/avatars.xml"),
	Asset("IMAGE", "images/dst/avatars.tex"),

	Asset("ATLAS", "images/dst/global_redux.xml"),
	Asset("IMAGE", "images/dst/global_redux.tex"),

	Asset("ATLAS", "images/dst/frontend_redux.xml"),
	Asset("IMAGE", "images/dst/frontend_redux.tex"),

	Asset("ATLAS", "images/dst/scoreboard.xml"),
	Asset("IMAGE", "images/dst/scoreboard.tex"),

	Asset("ATLAS", "images/food_types/food_types.xml"),
	Asset("IMAGE", "images/food_types/food_types.tex"),

	Asset("ATLAS", "images/minimap/minimap.xml"),
	Asset("IMAGE", "images/minimap/minimap.tex"),
	--Asset("MINIMAP_IMAGE", "cave_open_red")

	--Asset("MINIMAP_IMAGE", "images/Volcano.png")
}

local MIGRATOR_COLORS = {
	RED = Color.fromRGB(255, 0, 0),
	ORANGE = Color.fromRGB(255, 140, 0),
	YELLOW = Color.fromRGB(255, 226, 0),
	GREEN = Color.fromRGB(115, 255, 0),
	CYAN = Color.fromRGB(0, 255, 213),
	BLUE = Color.fromRGB(0, 115, 255),
	PURPLE = Color.fromRGB(124, 26, 255),
	PINK = Color.fromRGB(253, 0, 255),
	WHITE = Color.fromRGB(255, 255, 255),
	BLACK = Color.fromRGB(76, 76, 76),
}

FOREST_MIGRATOR_IMAGES = {
	{ "cave_open_red.tex", MIGRATOR_COLORS.RED },
	{ "cave_open_orange.tex", MIGRATOR_COLORS.ORANGE },
	{ "cave_open_yellow.tex", MIGRATOR_COLORS.YELLOW },
	{ "cave_open_green.tex", MIGRATOR_COLORS.GREEN },
	{ "cave_open_cyan.tex", MIGRATOR_COLORS.CYAN },
	{ "cave_open_blue.tex", MIGRATOR_COLORS.BLUE },
	{ "cave_open_purple.tex", MIGRATOR_COLORS.PURPLE },
	{ "cave_open_pink.tex", MIGRATOR_COLORS.PINK },
	{ "cave_open_white.tex", MIGRATOR_COLORS.WHITE },
	{ "cave_open_black.tex", MIGRATOR_COLORS.BLACK }
}

CAVE_MIGRATOR_IMAGES = {
	{ "cave_open2_red.tex", MIGRATOR_COLORS.RED },
	{ "cave_open2_orange.tex", MIGRATOR_COLORS.ORANGE },
	{ "cave_open2_yellow.tex", MIGRATOR_COLORS.YELLOW },
	{ "cave_open2_green.tex", MIGRATOR_COLORS.GREEN },
	{ "cave_open2_cyan.tex", MIGRATOR_COLORS.CYAN },
	{ "cave_open2_blue.tex", MIGRATOR_COLORS.BLUE },
	{ "cave_open2_purple.tex", MIGRATOR_COLORS.PURPLE },
	{ "cave_open2_pink.tex", MIGRATOR_COLORS.PINK },
	{ "cave_open2_white.tex", MIGRATOR_COLORS.WHITE },
	{ "cave_open2_black.tex", MIGRATOR_COLORS.BLACK }
}

--AddMinimapAtlas("images/Volcano.xml")
AddMinimapAtlas("images/minimap/minimap.xml")

for i,v in pairs(BulkAssets) do
	table.insert(Assets, Asset("ATLAS", string.format("images/%s.xml", v)))
	table.insert(Assets, Asset("IMAGE", string.format("images/%s.tex", v)))
end

--================================================================================================================================================================--
--= Icons =======================================================================================================================================================--
--================================================================================================================================================================--
local BulkIcons = {"Bugs", "Dairy", "Eggs", "Fat", "Fishes", "Fruit", "Inedible", "Meats", "Monster_Foods", "Sweetener", "Vegetable"}

local icon_list = {
	--["blank"] = {"White_Square.tex", "images/White_Square.xml"},

	-- ["value"] = {tex, atlas}
	-- from hud.tex
	["swords"] = {"tab_fight.tex", atlas_hud}, -- swords
	["tools"] = {"tab_tool.tex", atlas_hud},
	["fire"] = {"tab_light.tex", atlas_hud},
	["magic"] = {"tab_magic.tex", atlas_hud},

	-- from inventoryimages.tex
	--[[
	["armorwood"] = {"armorwood.tex", atlas_inv},
	["cane"] = {"cane.tex", atlas_inv},
	["manure"] = {"poop.tex", atlas_inv},
	["fish"] = {"fish.tex", atlas_inv},
	["fast_farmplot"] = {"fast_farmplot.tex", atlas_inv},
	["snurtleshell"] = {"armorsnurtleshell.tex", atlas_inv},
	["beargervest"] = {"beargervest.tex", atlas_inv},
	["icehat"] = {"icehat.tex", atlas_inv},
	["mussel"] = {"mussel.tex", atlas_inv},
	["thermometer"] = {"winterometer.tex", atlas_inv},
	--]]

	-- other
	["health"] = {"Health_Meter.tex", "images/Health_Meter.xml"},
	["sanity"] = {"Sanity_Meter.tex", "images/Sanity_Meter.xml"},
	["enlightenment"] = {"Enlightenment_Meter.tex", "images/Enlightenment_Meter.xml"},
	["hunger"] = {"Hunger_Meter.tex", "images/Hunger_Meter.xml"},
	["wetness"] = {"Wetness_Meter.tex", "images/Wetness_Meter.xml"},
	["volcano"] = {"Volcano.tex", "images/Volcano.xml"},
	["volcano_active"] = {"Volcano_Active.tex", "images/Volcano_Active.xml"},
	["arrow"] = {"Arrow.tex", "images/Arrow.xml"},
	["arrow_down"] = {"Arrow_Down.tex", "images/Arrow_Down.xml"},
	["krampus"] = {"Krampus.tex", "images/Krampus.xml"},
	["frog"] = {"Frog.tex", "images/Frog.xml"},
	["inedible"] = {"Inedible.tex", "images/Inedible.xml"},
	["antlion"] = {"Antlion.tex", "images/Antlion.xml"},
	

	-- for hunts
	["dirtpile"] = {"Dirtpile.tex", "images/Dirtpile.xml"},
	["whale_bubbles"] = {"Whale_Bubbles.tex", "images/Whale_Bubbles.xml"},
	["whale_white"] = {"Whale_White.tex", "images/Whale_White.xml"},
	["whale_blue"] = {"Whale_Blue.tex", "images/Whale_Blue.xml"},
	["koalefant_summer"] = {"Koalefant_Summer.tex", "images/Koalefant_Summer.xml"},
	["koalefant_winter"] = {"Koalefant_Winter.tex", "images/Koalefant_Winter.xml"},
	["lightninggoat"] = {"Lightninggoat.tex", "images/Lightninggoat.xml"},
	["spat"] = {"Spat.tex", "images/Spat.xml"},
	["warg"] = {"Warg.tex", "images/Warg.xml"},
	["claywarg"] = {"Claywarg.tex", "images/Claywarg.xml"},
}

for i,v in pairs(BulkIcons) do
	icon_list[v:lower()] = {string.format("%s.tex", v), string.format("images/food_types/food_types.xml", v)}
end

for _,v in pairs(BulkAssets) do
	local tex, atlas = string.format("%s.tex", v), string.format("images/%s.xml", v)

	local hit = false
	for j,k in pairs(icon_list) do
		if k[1] == tex and k[2] == atlas then
			hit = true
			break
		end
	end

	if not hit then
		icon_list[v:lower()] = {tex, atlas}
	end
end

local refs_delayed = {
	"armorwood", "cane", "poop", "fish", "fast_farmplot", "armorsnurtleshell", "beargervest", "icehat", "mussel", "winterometer", "goldnugget", "dubloon", 
}

local entity_animations = {
	["dragonfly"] = {
		bank = "dragonfly",
		build = "dragonfly_build",
	},
	["frog"] = {
		bank = "dragonfly",
	}
}



function LookupIcon(icon)
	-- C:\Program Files (x86)\Steam\steamapps\common\dont_starve\data\images
	
	if icon_list[icon] then
		return unpack(icon_list[icon])
	end
end

function DefineIcon(icon, tex, atlas)
	assert(icon_list[icon] == nil, "Attempt to overwrite existing icon '" .. icon .. "'")
	assert(tex ~= nil, "DefineIcon(..., tex, ...): tex == nil")
	assert(atlas ~= nil, "DefineIcon(..., ..., atlas): atlas == nil")
	icon_list[icon] = {tex, atlas}
end

-- TheSim:AtlasContains("images/inventoryimages.xml", "radish.tex")


function GetAtlasForTex(tex)
	if atlas_lookups[tex] then
		return atlas_lookups[tex]
	end

	-- simutil.lua
	for _, atlas in pairs(known_atlases) do
		if TheSim:AtlasContains(atlas, tex) then
			atlas_lookups[tex] = atlas
			return atlas
		end
	end
end

function ResolvePrefabToImageTable(prefab)
	local exists = PrefabHasIcon(prefab)

	if exists then
		local tex, atlas = LookupIcon(prefab)

		return {
			atlas = atlas,
			tex = tex
		}
	else
		return nil
	end
end

function PrefabHasIcon(prefab)
	if LookupIcon(prefab) then
		return true
	end

	local tex = prefab .. ".tex"
	local atlas = GetAtlasForTex(tex)
	if atlas then
		print("defined", prefab, tex, atlas)
		DefineIcon(prefab, tex, atlas)
		return true
	end

	return false
end

AddSimPostInit(function(plr)
	for i,v in pairs(refs_delayed) do
		PrefabHasIcon(v)
	end
end)

-- load stuff that i cant be asked to get
--print("hey:", PrefabHasIcon("mussel"))
--print("hey:", PrefabHasIcon("winterometer"))

-- log file says atlases are missing