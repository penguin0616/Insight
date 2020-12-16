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

---------------------------------------
-- Main script of the mod.
-- @module modmain
-- @author penguin0616

-- modify environment to inherit from klei's environment as a fallback
-- __newindex is left blank so all declarations are in our new environment
-- normally I'd just keep __index directly set to klei's environment,
-- but the mods loader assumes that unassigned variables won't error
-- so i have to tweak __index more than I want to, though ideally I would avoid it to avoid another unoptimization
do
	-- ds/scripts/strict.lua is why _G stuff keeps being rude
	-- get that sweet sweet local optimization
	local GLOBAL = GLOBAL
	local modEnv = GLOBAL.getfenv(1)
	local rawget, setmetatable = GLOBAL.rawget, GLOBAL.setmetatable
	setmetatable(modEnv, {
		__index = function(self, index)
			local value = rawget(GLOBAL, index)

			return value
		end
	})

	_G = GLOBAL
end

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile

DEFAULTFONT = "opensans"
DIALOGFONT = "opensans"
TITLEFONT = "bp100"
UIFONT = "bp50"
BUTTONFONT = "buttonfont"
NEWFONT = "spirequal"
NEWFONT_SMALL = "spirequal_small"
NEWFONT_OUTLINE = "spirequal_outline"
NEWFONT_OUTLINE_SMALL = "spirequal_outline_small"
NUMBERFONT = "stint-ucr"
TALKINGFONT = "talkingfont"
TALKINGFONT_WORMWOOD = "talkingfont_wormwood"
TALKINGFONT_HERMIT = "talkingfont_hermit"
CHATFONT = "bellefair"
HEADERFONT = "hammerhead"
CHATFONT_OUTLINE = "bellefair_outline"
SMALLNUMBERFONT = "stint-small"
BODYTEXTFONT = "stint-ucr"
CODEFONT = "ptmono"

-- Mod table
local Insight = {
	env = getfenv(1),
	kramped = {
		values = {},
		players = {},
	},
	active_hunts = {},
	descriptors = nil,
	FUEL_TYPES = {
		BURNABLE = "Fuel",
		CAVE = "Light", -- miner hat / lanterns, light bulbs n stuff
		CHEMICAL = "Fuel",
		CORK = "Fuel",
		GASOLINE = "Gasoline", -- DS: not actually used anywhere?
		MAGIC = "Durability", -- amulets that aren't refuelable (ex. chilled amulet)
		MECHANICAL = "Durability", -- SW: iron wind
		MOLEHAT = "Night vision", -- Moggles
		NIGHTMARE = "Nightmare fuel",
		NONE = "Time", -- will never be refueled...............................
		ONEMANBAND = "Durability",
		PIGTORCH = "Fuel",
		SPIDERHAT = "Durability", -- Spider Hat
		TAR = "Tar", -- SW
		USAGE = "Durability",
	},
	COLORS = {
		-- stats
		HUNGER = "#DEB639", 
		SANITY = "#C67823",
		HEALTH = "#A22B23",
		ENLIGHTENMENT = "#ACC5C3",

		-- mechanic
		LIGHT = "#CCBC78", -- light tab icon
		--DAMAGE = "#AAA79F", --"#C7C7C7", -- fight tab sword

		-- nature
		POND = "#344147", -- pond water,
		WET = "#95BFF2", -- just converted constants.lua -> WET_TEXT_COLOR to hex
		SHALLOWS = "#66A570", -- shallows in SW
		NATURE = "#9BD554", --"#8BA94B", -- palm tree

		-- foods
		MEAT = "#955D70", -- meat icon
		MONSTER = "#7D4381", -- monster meat icon
		FISH = "#727A8D", -- fish icon
		VEGGIE = "#BF8801", -- pumpkin icon
		FRUIT = "#9A3035", -- pomegranite (whole) icon
		EGG = "#E4CFA5", -- egg icon
		SWEETENER = "#DDA305", -- honeycomb
		FROZEN = "#A3C3DF", -- ice icon
		FAT = "#AF774D", -- literally only butter (and coconuts)
		DAIRY = "#A3C3DF", -- FROZEN; --"#EFF9EC", -- electric milk icon; ok this is indistinguishable
		DECORATION = "#8C4041", -- literally only butterfly wings
		MAGIC = "#9864F5", -- only mandrake. but they don't look magical, so royal purple it is.
		PRECOOK = "#ffffff", -- yep.
		DRIED = "#ffffff", -- yep.
		INEDIBLE = "#614A24", -- coconut
		BUG = "#804E32", -- bean bug
		SEED = "#8EA152", -- birchnut

		-- mob
		FEATHER = "#331D43", -- black feather
		FROG = "#69725C",

		-- misc
		ROYAL_PURPLE = "#6225D1", -- r
		LIGHT_PINK = "#ffb6c1",
		CAMO = "#4D6B43"
	},

	CONTROLS = {
		-- CONTROL_MENU_MISC_3 = L
		TOGGLE_INSIGHT_MENU = CONTROL_OPEN_CRAFTING, -- L2

	}
}

-- Provide to Global
_G.Insight = Insight

-- meh
MyKleiID = "KU_md6wbcj2"
WORKSHOP_ID_DS = "workshop-2081254154"
WORKSHOP_ID_DST = "workshop-2189004162"

-- declarations or module loading
DEBUG_ENABLED = (
	TheSim:GetGameID() == "DST" and (
		TheNet:GetUserID() == MyKleiID or -- me
		false --TheNet:GetUserID() == "KU_or9kA0Ka"	
	) and true)
	or TheSim:GetGameID() == "DS" and (
		TheSim:GetUserID() == "317172400@steam" -- steamid32
	)
	or GetModConfigData("DEBUG_ENABLED", true) or false 

if DEBUG_ENABLED and (TheSim:GetGameID() == "DS" or false) then
	Print(VERBOSITY.DEBUG, "hello world 1")
	_G.VERBOSITY_LEVEL = VERBOSITY.DEBUG
	print("VERBOSITY_LEVEL:", _G.VERBOSITY_LEVEL)

	Print(VERBOSITY.DEBUG, "hello world 2")
end

PrefabFiles = {"insight_range_indicator", "insight_map_marker"}
string = setmetatable({}, {__index = function(self, index) local x = _G.string[index]; rawset(self, index, x); return x; end}) -- ISSUE:PERFORMANCE
import = kleiloadlua(MODROOT .. "scripts/import.lua")()
time = import("time")
util = import("util")
Color = import("color")
entityManager = import("entitymanager")()
rpcNetwork = import("rpcnetwork")

widgetLib = {
	image = import("widgets/image_lib"),
	imagebutton = import("widgets/imagebutton_lib"),
	text = import("widgets/text_lib"),
}

TRACK_INFORMATION_REQUESTS = DEBUG_ENABLED and false

local player_contexts = {}
local mod_component_cache = {}

local log_buffer = ""
local LOG_LIMIT = 4500000 -- 4.5 million
local SERVER_OWNER_HAS_OPTED_IN = nil

local descriptors = createTable(100)
local prefab_descriptors = {}
local descriptors_ignore = {
	--"mapiconhandler", -- this is just from a mod i use :^)

	
	"obsidiantool", -- might be worth looking into more, but I got the damage buff accounted for in weapon.lua, so I don't see a need to do more with this
	"bloomable", -- hamlet trees
	"fixable", -- hamlet pig houses
	
	"repairer", "lootdropper", "workable", "childspawner", "periodicspawner", "shearable", "mystery", "eater", "poisonable", "sleeper", "freezable",  -- may be interesting looking into
	"thief", "characterspecific", "resurrector", "beard", "brushable", "rideable", "mood", "thrower", "windproofer", "creatureprox", "groundpounder", "prototyper", -- maybe interesting looking into

	--notable
	"bundlemaker", --used in bundling wrap before items
	

	"inventoryitem", "moisturelistener", "propagator", "stackable", "cookable", "bait", "blowinwind", "blowinwindgust", "floatable", "selfstacker", "book", -- don't care
	"dryable", "highlight", "cooker", "lighter", "instrument", "poisonhealer", "trader", "smotherer", "knownlocations", "homeseeker", "occupier", "talker", "inventory", -- don't care
	"werebeast", "named", "activatable", "transformer", "deployable", "upgrader", "playerprox", "flotsamspawner", "repairable", "rowboatwakespawner", "plantable", "waveobstacle", -- don't care
	"fader", "lighttweener", "sleepingbag", "machine", "floodable", "firedetector", "teacher", "heater", "tiletracker", "scenariorunner", "payable", "useableitem", "drawable", "shaver", -- don't care
	"gridnudger", "entitytracker", "appeasable", "currency", "mateable", "sizetweener", "saltlicker", "sinkable", "sticker", "projectile", "hiddendanger", "deciduoustreeupdater", -- don't care
	"geyserfx", "blinkstaff", -- don't care,

	-- Worldly DS stuff
	"ambientsoundmixer", "globalcolourmodifier", "moisturemanager", "inventorymoisture", -- world
	"optionswatcher", "giantgrubspawner", "flowerspawner_rainforest", "interiorspawner", "periodicpoopmanager", "roottrunkinventory", "bramblemanager", "canopymanager", "ripplemanager", "cloudpuffmanager", "shadowmanager", -- world (hamlet)
	"economy", "cityalarms", "banditmanager", "quaker_interior", "glowflyspawner", -- world (hamlet) (might be interesting)
	"nightmareambientsoundmixer", --gamelogic
	"colourcubemanager", "seasonmanager", "bigfooter", "flowerspawner", "doydoyspawner", "debugger", "rainbowjellymigration", "globalsettings", "flooding", "mosquitospawner", -- specific world types
	"volcanoambience", "volcanowave", "whalehunter", -- specific world types
	
	
	-- now for DST stuff
	"wardrobe", "plantregrowth", "bloomer", "drownable", "embarker", "inventoryitemmoisture", "constructionsite", "playeravatardata", "petleash", "giftreceiver", -- may be interesting looking into
	"grogginess", "workmultiplier", "wateryprotection", "mine", "aura", -- may be interesting looking into
	"resistance", -- for the armor blocking of bone armor

	"playerinspectable", "playeractionpicker", "playervision", "pinnable", "playercontroller", "playervoter", "singingshelltrigger", "tackler", "sleepingbaguser", "skinner", "playermetrics",-- from mousing over player
	"sheltered", "grue", "wisecracker", "constructionbuilder", "playerlightningtarget", "rider", "distancetracker", "frostybreather", "foodaffinity", "stormwatcher", "areaaware", "age", "steeringwheeluser", -- from mousing over player
	"touchstonetracker", "constructionbuilderuidata", "birdattractor", "attuner", "builder", "bundler", "carefulwalker", "catcher", "colouradder", "colourtweener", "inkable", "walkingplankuser", -- from mousing over player

	"hauntable", "savedrotation", "halloweenmoonmutable", "storytellingprop", "floater", "spawnfader", "transparentonsanity", "beefalometrics", "uniqueid", "reticule", "spellcaster", -- don't care
	"complexprojectile", "shedder", "disappears", "oceanfishingtackle", "shelf", "ghostlyelixirable", "maprevealable", "winter_treeseed", "summoningitem", "portablestructure", "deployhelper", -- don't care
	"symbolswapdata", "amphibiouscreature", 

	-- NEW:
	"farmplanttendable", "plantresearchable", "fertilizerresearchable",

	-- TheWorld
	"worldstate", "groundcreep", "skeletonsweeper", "uniqueprefabids", "ocean", "oceancolor",

	-- Forest & Caves
	"yotc_raceprizemanager", "shadowhandspawner", "desolationspawner", "ambientlighting", "worldoverseer", "forestresourcespawner", "shadowcreaturespawner", "chessunlocks", "feasts", 
	"regrowthmanager", "townportalregistry", "hallucinations", "dsp", "dynamicmusic",

	-- Forest
	"squidspawner", "moosespawner", "birdspawner", "worldwind", "retrofitforestmap_anr", "deerherdspawner", "deerherding", "wildfires", "flotsamgenerator", "brightmarespawner", 
	"sandstorms", "messagebottlemanager", "forestpetrification", "penguinspawner", "hunter", "sharklistener", "frograin", "waterphysics", "butterflyspawner", "worldmeteorshower",
	"worlddeciduoustreeupdater", "schoolspawner", "specialeventsetup", "playerspawner", "walkableplatformmanager", "lureplantspawner", "wavemanager",
	
	

	-- Caves
	"retrofitcavemap_anr", "caveins",
	
	

	-- Misc
	"ambientsound", -- forest, caves, forge, gorge
	"colourcube", -- forest, caves, forge, gorge

	-- Network/Shard AAAAAAAAAAAAAAAAAAAAAh


	-- prefab world_network


	--"caveweather", "quaker", "nightmareclock" -- Caves (Network)
	"weather", 
	"caveweather",
	"shardstate", -- idk
	"worldreset", -- when no one left alive
	"seasons", -- seasons
	"worldtemperature", -- world temperature
	"clock", -- clock
	"autosaver", -- autosaver
	"worldvoter", -- idc to look enough into

}

--================================================================================================================================================================--
--= Functions ====================================================================================================================================================--
--================================================================================================================================================================--

--- Checks whether we are in DS.
-- @return boolean
function IsDS()
	return TheSim:GetGameID() == "DS"
end

--- Checks whether we are in DST.
-- @treturn boolean
function IsDST()
	return TheSim:GetGameID() == "DST"
end

--- Checks whether the mod is running on a client
-- @treturn boolean
function IsClient()
	return IsDST() and TheNet:GetIsClient()
end

--- Checks whether the mod is running on a client that is also the host.
-- @treturn boolean
function IsClientHost()
	return IsDST() and TheNet:IsDedicated() == false and TheNet:GetIsMasterSimulation() == true
	--return IsDST() and TheNet:IsDedicated() == false and TheWorld.ismastersim == true
end

function IsForge()
	return IsDST() and TheNet:GetDefaultGameMode() == "lavaarena"
end

--- Checks if argument is a widget.
-- @param arg
-- @treturn boolean
function IsWidget(arg)
	return arg and arg.inst and arg.inst.widget and true
end

--- Checks if argument is a prefab.
-- @param arg
-- @treturn boolean
function IsPrefab(arg)
	return type(arg) == 'table' and arg.GUID and arg.prefab and true
end

--- Return player's Insight
-- @tparam Player player
-- @treturn ?Insight|nil
function GetInsight(player)
	assert(player, "[Insight]: GetInsight called without player")
	if IsDST() then
		return player.replica.insight
	else
		return player.components.insight
	end
end

--- Returns player's insight context.
-- @tparam Player player
-- @treturn ?table|nil
function GetPlayerContext(player)
	assert(IsPrefab(player), "[Insight]: GetPlayerContext called on non-player")
	local context
	if IsDST() and TheWorld.ismastersim then
		-- i know we'll have it
		context = player_contexts[player]
	else
		-- will be the only context
		context = player_contexts[player]
	end

	if context then
		return setmetatable({ fromInspection=false }, { __index=context })
	end

	--return context
end

--- Creates player's insight context.
-- @tparam Player player
-- @tparam table config
function CreatePlayerContext(player, config, external_config, etc)
	assert(player, "[Insight]: Player is missing!")
	assert(config, "[Insight]: Config is missing!")
	assert(external_config, "[Insight]: External_config is missing!")

	local mt = {
		__newindex = function()
			error("context is readonly")
		end;
		__tostring = function(self) return string.format("Player Context (%s): %s", tostring(self.player), self._name or "ADDR") end,
		__metatable = "[Insight] The metatable is locked"
	}

	local context = {
		player = player,
		config = config,
		external_config = external_config,
		usingIcons = config["info_style"] == "icon",
		lstr = import("language/language")(config, etc.locale),
		is_server_owner = etc.is_server_owner,
	}

	if context.is_server_owner then
		if context.config["crash_reporter"] then
			SERVER_OWNER_HAS_OPTED_IN = true
		end
	end

	setmetatable(context.config, mt)
	setmetatable(context.external_config, mt)
	setmetatable(context, mt)


	player_contexts[player] = context
end

--- Returns the component's origin. 
-- @string componentname
-- @treturn ?string|nil nil if it is native, string is mod's fancy name
function GetComponentOrigin(componentname)
	if IsDS() then
		return false
	end

	if mod_component_cache[componentname] == false then
		return nil
	elseif mod_component_cache[componentname] ~= nil then
		return mod_component_cache[componentname]
	end


	
	for i,mod in pairs(ModManager.mods) do
		-- mod is the env
		local data = KnownModIndex:GetModInfo(mod.modname) -- modinfo.lua
		--mprint("checking", data.name, "|", MODS_ROOT .. mod.modname .. "/scripts/components/" .. componentname .. ".lua")
		local c, x = io.open(MODS_ROOT .. mod.modname .. "/scripts/components/" .. componentname .. ".lua", "r")
		if c ~= nil then
			io.close(c)
			mod_component_cache[componentname] = data.name
			return mod.modname
		end
	end
	
	mod_component_cache[componentname] = false

	return nil
end

--- Returns the prefab's origin
-- @string prefabname
-- @treturn ?string|nil nil if it is native, string is mod's fancy name
function GetPrefabOrigin(prefabname)
	if IsDS() then
		return false
	end

	--[[
	if mod_prefab_cache[prefabname] == false then -- native
		return nil
	elseif mod_prefab_cache[prefabname] ~= nil then -- modded
		return mod_prefab_cache[prefabname]
	end
	--]]

	for i,modname in ipairs(ModManager.enabledmods) do
		local mod = ModManager:GetMod(modname)

		-- ModInfoname(mod.modname) = workshop-2189004162 (Insight)
		for name, prefab in pairs(mod.Prefabs) do
			if name == prefabname then
				--mod_prefab_cache[prefabname]
				return modname
			end
		end
	end
end

--- Retrives item posessor.
-- @tparam Prefab item
-- @treturn ?Prefab|nil The player/creature that is holding the item.
function GetItemPossessor(item)
	assert(IsDS() or (IsDST() and TheWorld.ismastersim), "GetItemPosessor not called from master")
	return item and item.components and item.components.inventoryitem and item.components.inventoryitem:GetGrandOwner()
end

--- Returns the current world type (DLCs and base game) that is active.
-- @treturn Integer (0 = Base Game, 1 = Reign of Giants, 2 = Shipwrecked, 3 = Hamlet)
function GetWorldType()
	if TheSim:GetGameID() == "DST" then
		return -1 -- Don't Starve Together
		-- ds DLC variables don't exist here by the way
	end

	if IsDLCEnabled(PORKLAND_DLC) then
		return 3 -- hamlet
	elseif IsDLCEnabled(CAPY_DLC) then
		return 2 -- shipwrecked
	elseif IsDLCEnabled(REIGN_OF_GIANTS) then
		return 1 -- reign of giants
	else
		return 0 -- base game of Don't Starve
	end
end

--- Custom print command specifically for the mod.
-- Indicates that a print came from the mod.
-- @param ... can be pretty much anything
function mprint(...)
	local msg, argnum = "", select("#",...)
	for i = 1, argnum do
		local v = select(i,...)
		msg = msg .. tostring(v) .. ( (i < argnum) and "\t" or "" )
	end

	local prefix = ""

	if false then
		local d = debug.getinfo(2, "Sl")
		prefix = string.format("%s:%s:", d.source or "?", d.currentline or 0)
	end

	return print(prefix .. "[" .. ModInfoname(modname) .. "]:", msg)
end

function dprint(...)
	if not DEBUG_ENABLED then
		return
	end
	mprint(...)
end

function cprint(...)
	if not TheNet:GetClientTableForUser(MyKleiID) then
		return
	end

	local msg, argnum = "", select("#",...)
	for i = 1, argnum do
		local v = select(i,...)
		msg = msg .. tostring(v) .. ( (i < argnum) and "\t" or "" )
	end
	
	local res = "[" .. ModInfoname(modname) .. " - SERVER]: " .. msg 

	if IsClient() then
		print(res)
	else
		rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "Print"), MyKleiID, res)
	end
	-- _G.Insight.env.rpcNetwork.SendModRPCToClient(GetClientModRPC(_G.Insight.env.modname, "Print"), ThePlayer.userid, "rek"
end

--- Returns the descriptor method for an item. Returns false if descriptor failed to load or does not exist.
-- @tparam string name
-- @treturn ?function|false
function GetComponentDescriptor(name)
	if descriptors[name] == nil then
		-- never processed before
		local safe, res = pcall(import, "descriptors/" .. name)
		descriptors[name] = (safe and res) or false
		
		if safe then
			if type(res) == "table" then
				assert(type(res.Describe) == "function", string.format("[Insight]: attempt to return '%s' as a complex descriptor with Describe as '%s'", name, tostring(res.Describe)))
				-- complex
				Insight.descriptors[name] = setmetatable(deepcopy(res), { __index = function(self, index) error(string.format("descriptor '%s' does not have index '%s'", name, index)) end })
			else
				--Insight.descriptors[name] = res
				mprint(safe, res)
				error(string.format("Attempt to return '%s' in descriptor '%s'", tostring(res), name))
			end
		else
			Insight.descriptors[name] = false
		end

		if not safe then
			if not res:find("not exist") then
				-- [string "../mods/workshop-2189004162/scripts/import...."]:48: [ERR] File does not exist: ../mods/workshop-2189004162/scripts/descriptors/teamattacker.lua	
				local _, en = string.find(res, ":%d+:%s")
				res = string.sub(res, (en or 0)+1)
				descriptors[name] = function() return {priority = -0.5, description = "<color=#ff0000>ERROR LOADING DESCRIPTOR \"" .. name .. "\"</color>:\n" .. res} end
			end

			dprint("FAILED TO LOAD DESCRIPTOR:", res)
		end

		-- reprocess
		return GetComponentDescriptor(name)
	--[[
	elseif type(descriptors[name]) == "function" then
		-- simple function return
		return descriptors[name]
	--]]
	elseif type(descriptors[name]) == "table" then
		-- looks like its a complex descriptor
		return descriptors[name].Describe
	else
		-- its not good :(
		return descriptors[name]
	end
end

function GetPrefabDescriptor(name)
	if prefab_descriptors[name] == nil then
		-- never processed before
		local safe, res = pcall(import, "prefab_descriptors/" .. name)
		prefab_descriptors[name] = (safe and res) or false

		if not safe then
			if res:find("loading") then
				prefab_descriptors[name] = function() return {priority = -0.5, description = "ERROR LOADING DESCRIPTOR \"" .. name .. "\": " .. res} end
			else
				--descriptors[name] = function() return {priority = -0.5, description = "ERROR LOADING DESCRIPTOR \"" .. name .. "\": " .. res} end
			end
		end

		-- reprocess
		return GetPrefabDescriptor(name)
	elseif type(prefab_descriptors[name]) == "function" then
		-- yay
		return prefab_descriptors[name]
	else
		-- its not good :(
		return prefab_descriptors[name]
	end
end

function GetSpecialData(describe_data)
	local special_data = {}
	for j, k in pairs(describe_data) do
		if j ~= 'name' and j ~= 'description' and j ~= 'priority' then
			special_data[j] = k
		end
	end
	return special_data
end

--- Retrives our information for an item.
-- @tparam Prefab item
-- @tparam Player player
-- @treturn string
function GetEntityInformation(item, player, params)
	-- some mods (https://steamcommunity.com/sharedfiles/filedetails/?id=2081254154) were setting .item to a non-prefab
	-- 5/2/2020

	local assembled = {
		GUID = item.GUID,
		information = "",
		special_data = {},
		raw = (params.raw and {}) or nil,
	}

	--[[
	if not IsPrefab(item) then
		assembled.GUID = "?"
		assembled.information = "Not a prefab"
		return assembled
	end
	--]]

	local player_context = GetPlayerContext(player)
	if not player_context then
		assembled.raw = nil
		assembled.information = "missing player context for " .. player.name

		return assembled
	end

	player_context.fromInspection = params.fromInspection or false

	local isForge = IsForge() -- why call this multiple times later?

	local components = item.components

	local chunks = {}
	for name, component in pairs(components) do
		
		local descriptor = GetComponentDescriptor(name)
		
		if descriptor then
			local datas = {descriptor(component, player_context)}

			for i, d in pairs(datas) do
				if d and ((not params.ignore_worldly) or (params.ignore_worldly == true and not d.worldly)) then
					assert(type(d.priority)=="number", "Invalid priority for:" .. name)

					if d.name ~= nil and type(d.name) ~= "string" then
						error("invalid chosen name for a descriptor")
					elseif d.name == nil and #datas > 1 then
						error("missing name for a multiple-return descriptor") -- when returning multiple tables, need to manually specify the names
					end
					
					d.name = d.name or name -- chosen name or default component name

					if isForge == false or (isForge == true and name == "health") then
						--fprint(item, "component", name, d.description)
						table.insert(chunks, d)
					end
				end
			end

		elseif player_context.config["DEBUG_SHOW_DISABLED"] and table.contains(descriptors_ignore, name) then
			table.insert(chunks, {priority = -2, name = name, description = "Disabled descriptor: " .. name})

		elseif player_context.config["DEBUG_SHOW_NOTIMPLEMENTED"] and not table.contains(descriptors_ignore, name) then
			local description = "No information for: " .. name
			local origin = GetComponentOrigin(name)

			if origin then
				description = string.format("[%s] No information for: %s", origin, name)
			end

			table.insert(chunks, {priority = -1, name = name, description = description})
		end
	end

	-- sort by priority
	table.sort(chunks, function(a, b)
		local p1, p2 = a.priority or 0, b.priority or 0

		if p1 == p2 and a.description and b.description then
			return a.description < b.description -- key code means letters further down the alphabet have a higher value, so we need smaller of them to sort alphabetically
		else
			return p1 > p2 -- we need higher value priority
		end
	end)

	-- assembly time
	-- if there's no data, why bother?
	if #chunks == 0 then
		assembled.information = nil
		return assembled
	end

	--fprint(item, "has some info")

	for i,v in pairs(chunks) do
		if assembled.special_data[v.name] == nil then
			assembled.special_data[v.name] = GetSpecialData(v)
		end

		-- collect the description if one was provided
		if type(v.description) == "string" then
			v.description = ResolveColors(v.description) -- resolve any color tags that reference the Insight table's colors

			assembled.information = assembled.information .. v.description
			if i < #chunks then
				assembled.information = assembled.information .. "\n"
			end

			if params.raw == true then
				assembled.raw[v.name] = v.description
			end
		elseif v.description ~= nil then
			-- should have been caught in the previous statement
			error(string.format("invalid description: %s | Descriptor: %s", tostring(v.description), v.name))
		end
	end

	if assembled.information == "" then
		assembled.information = nil
	end

	return assembled
end

--- Middleman between GetEntityInformation's server side and the client, really only important for DST
function RequestEntityInformation(item, player, params)
	--if true then return nil end

	assert(type(params) == "table", "RequestEntityInformation expected 'params' as a table")

	if TRACK_INFORMATION_REQUESTS then
		dprint("SERVER got:", item, player, params)
	end

	-- might as well
	if not item then
		--dprint(player, "requested information for nil.")
		return nil
	end

	-- DST
	if not IsPrefab(item) then
		if IsDST() then
			mprint(string.format("%s requested information for %s, mastersim: %s", player.name, tostring(item), tostring(TheWorld.ismastersim)))
		else
			mprint(string.format("Requested information for %s", tostring(item)))
		end

		return {GUID = params.id or 0, info = "not a real item?", special_data = {}}
	end

	local insight = GetInsight(player)

	if not insight then
		mprint(player.name, "is missing insight component.")
		return {GUID = params.id or 0, info = "missing insight component", special_data = {}}
	end
	
	if IsDS() then
		-- DS
		local info = GetEntityInformation(item, player, params)
		info.GUID = params.id
		insight.entity_data[item] = info

		return info
	end



	--local ok = DEBUG_ENABLED and ("is_active: " .. tostring(entityManager:IsEntityActive(item)) .. "\n") or ""

	local id = params.id

	-- GUIDs vary between server and client
	if TheWorld.ismastersim then
		--dprint(player, "is requesting info for", item)
		
		local data = GetEntityInformation(item, player, params)
		
		
		if not id then
			if IsClientHost() then
				-- understandable
				id = item.GUID
			else
				-- we shouldn't be here
				mprint("&&&&&&&&&&&&&& guid missing in server RQST")
				id = item.GUID
			end
		end
		

		data.GUID = id
		
		if TRACK_INFORMATION_REQUESTS then
			dprint("Information set for", item)
		end

		insight:SetEntityData(item, data)
	else
		-- client is asking for information
		insight:RequestInformation(item, params) -- clients have to go through this at some point, unless client is host and its a forest-only world
	end

	if TRACK_INFORMATION_REQUESTS then
		--dprint("Information returning for", item)
	end
	
	if insight.entity_data[item] then
		return insight.entity_data[item]
	end

	return ok or nil
end

function GetWorldInformation(player) -- refactor?
	--if true then return {} end

	local is_dst = IsDST()

	local world = TheWorld or GetWorld() -- implict game check
	local context = GetPlayerContext(player)
	assert(context, "how is context missing in GetWorldInformation for " .. player.name)

	if is_dst and not context.config["show_world_events"] then
		return {
			GUID = world.GUID,
			information = nil,
			special_data = {},
			raw = {}
		}
	end

	local data = GetEntityInformation(world, player, {raw = true})
	--[[
		-- cant visualize this at the moment
		{
			GUID = ...
			information = ...,
			special_data = {...},
			raw = {
				component = description
			}
		}
	]]

	for i,v in pairs(data.raw) do
		data.special_data[i].worldly = true
	end

	--[[
	for i = 1, 7 do
		local x = "test" .. i
		data.special_data[x] = { worldly=true }
		data.raw[x] = x
	end
	--]]
	

	if GetWorldType() >= 2 then
		local descriptor = GetComponentDescriptor("krakener")
		if descriptor then
			local krakener = descriptor(player.components.krakener, context)

			for j, k in pairs(krakener) do
				if j ~= 'description' and j ~= 'priority' then
					if data.special_data["krakener"] == nil then
						data.special_data["krakener"] = {}
					end
					data.special_data["krakener"][j] = k
				end
			end

			data.raw["krakener"] = krakener.description
			data.special_data["krakener"].worldly = true
		end
	end

	if is_dst then
		local helper = world.shard.components.shard_insight

		-- antlion
		local antlion_timer = helper:GetAntlionRageTimer() or -1
		if antlion_timer >= 0 then
			data.special_data["antlion"] = {
				icon = {
					atlas = "images/Antlion.xml",
					tex = "Antlion.tex",
				},
				worldly = true,
				from = "prefab"
			}

			data.raw["antlion"] = TimeToText(time.new(antlion_timer, context))
		end

		-- ancient gateway
		local atrium_gate_cooldown = helper:GetAtriumGateCooldown() or -1
		if atrium_gate_cooldown >= 0 then
			data.special_data["atrium_gate"] = {
				icon = {
					atlas = "images/Atrium_Gate.xml",
					tex = "Atrium_Gate.tex"
				},
				worldly = true,
				from = "prefab"
			}

			data.raw["atrium_gate"] = TimeToText(time.new(atrium_gate_cooldown, context))
		end

		-- dragonfly
		local dragonfly_respawn = helper:GetDragonflyRespawnTime() or -1
		if dragonfly_respawn >= 0 then
			data.special_data["dragonfly_spawner"] = {
				icon = {
					atlas = "images/Dragonfly.xml",
					tex = "Dragonfly.tex",
				},
				worldly = true,
				from = "prefab"
			}

			data.raw["dragonfly_spawner"] = TimeToText(time.new(dragonfly_respawn, context))	
		end

		-- bee queen
		local beequeen_respawn = helper:GetBeeQueenRespawnTime() or -1
		if beequeen_respawn >= 0 then
			data.special_data["beequeenhive"] = {
				icon = {
					atlas = "images/Beequeen.xml",
					tex = "Beequeen.tex",
				},
				worldly = true,
				from = "prefab"
			}

			data.raw["beequeenhive"] = TimeToText(time.new(beequeen_respawn, context))
		end

		-- bearger
		if data.raw["beargerspawner"] == nil and helper:GetBeargerData() then
			context.bearger_data = helper:GetBeargerData()
			local res = Insight.descriptors.beargerspawner.Describe(nil, context)
			data.special_data["beargerspawner"] = GetSpecialData(res)
			data.raw["beargerspawner"] = res.description
		end

		-- crabking
		if data.raw["crabkingspawner"] == nil and helper:GetCrabKingData() then
			context.crabking_data = helper:GetCrabKingData()
			local res = Insight.descriptors.crabkingspawner.Describe(nil, context)
			data.special_data["crabkingspawner"] = GetSpecialData(res)
			data.raw["crabkingspawner"] = res.description
		end

		-- deerclops
		if data.raw["deerclopsspawner"] == nil and helper:GetDeerclopsData() then
			context.deerclops_data = helper:GetDeerclopsData()
			local res = Insight.descriptors.deerclopsspawner.Describe(nil, context)
			data.special_data["deerclopsspawner"] = GetSpecialData(res)
			data.raw["deerclopsspawner"] = res.description
		end

		-- klaussack
		if data.raw["klaussackspawner"] == nil and helper:GetKlausSackData() then
			context.klaussack_data = helper:GetKlausSackData()
			local res = Insight.descriptors.klaussackspawner.Describe(nil, context)
			data.special_data["klaussackspawner"] = GetSpecialData(res)
			data.raw["klaussackspawner"] = res.description
		end

		-- malbatross
		if data.raw["malbatrossspawner"] == nil and helper:GetMalbatrossData() then
			context.malbatross_data = helper:GetMalbatrossData()
			local res = Insight.descriptors.malbatrossspawner.Describe(nil, context)
			data.special_data["malbatrossspawner"] = GetSpecialData(res)
			data.raw["malbatrossspawner"] = res.description
		end

		-- toadstool
		if data.raw["toadstoolspawner"] == nil and helper:GetToadstoolData() then
			context.toadstool_data = helper:GetToadstoolData()
			local res = Insight.descriptors.toadstoolspawner.Describe(nil, context)
			data.special_data["toadstoolspawner"] = GetSpecialData(res)
			data.raw["toadstoolspawner"] = res.description
		end

		-- add data from network
		-- TheWorld.net == forest_network or cave_network
		local secondary_data = GetEntityInformation(world.net, player, {raw = true})
		for i,v in pairs(secondary_data.special_data) do
			assert(data.special_data[i]==nil, "[Insight]: attempt to overwrite special_data: " .. tostring(i))
			data.special_data[i] = v
			data.special_data[i].from = "net"
		end

		for i,v in pairs(secondary_data.raw) do
			assert(data.raw[i]==nil, "[Insight]: attempt to overwrite raw: " .. tostring(i))
			data.raw[i] = v
		end
	end

	return data
end

function GetNaughtiness(inst, context)
	local kramped = Insight.descriptors.kramped
	if kramped then
		local data = kramped.Describe(inst, context)
		if data then return data.naughtiness end
	else
		mprint("GetNaughtiness failed due to broken descriptor")
	end
end

local function sprint(c)
	local x = c
	while #x > 0 do
		print(x:sub(1, 500))
		x = x:sub(501)
	end
end

local function heckler(f)
	return f:gsub("%[", "%%["):gsub("%]", "%%]") 
end

function compress(tbl)
	local str = json.encode(tbl)

	local key = {}
	local i = 0

	str = str:gsub("<color=([^>]+)", function(hit)
		if key[hit] == nil then
			key[hit] = "[c" .. i .. "]"
			i = i + 1
		end

		return key[hit]
	end)

	str = str:gsub("</color>", "</c>")

	str = json.encode(key) .. "|~|" .. str

	return str
end

function decompress(str)
	local original = str
	
	local s, e = string.find(str, "|~|")
	local key = string.sub(str, 1, s - 1) 
	str = string.sub(str, e + 1)

	key = json.decode(key)

	for original, compressed in pairs(key) do
		str = str:gsub(heckler(compressed), function(c)
			return "<color=" .. original
		end)
	end

	str = str:gsub("</c>", "</color>")

	return json.decode(str)
end

function compress2(tbl)
	--if true then return json.encode(tbl) end

	-- further optimizations: big numbers, key not existing when empty, idk
	local str = DataDumper(tbl, nil, true)

	--str = str:gsub("<color=", "<c=")
	
	local key = {}
	local i = 0

	--mprint("ORIGINAL:", str)

	str = str:gsub("<color=([^>]+)", function(hit)
		if key[hit] == nil then
			key[hit] = "[c" .. i .. "]"
			i = i + 1
		end

		return key[hit]
	end)

	--str = str:gsub("special_data=")

	str = str:gsub("</color>", "</c>")

	str = DataDumper(key, nil, true) .. "|~|" .. str

	--mprint("LENGTH:", #str)
	--sprint(str)

	-- max 24530

	return str
end

function decompress2(str)
	--if true then return json.decode(str) end

	local original = str
	
	local s, e = string.find(str, "|~|")
	local key = string.sub(str, 1, s - 1) 
	str = string.sub(str, e + 1)

	key = loadstring(key)()

	for original, compressed in pairs(key) do
		str = str:gsub(heckler(compressed), function(c)
			return "<color=" .. original
		end)
		--[[
		print(compressed, original, heckler(compressed))
		str = str:gsub(heckler(compressed), original)
		--]]
	end

	str = str:gsub("</c>", "</color>")

	--mprint("REBUILT:", str)

	local res, err = loadstring(str)
	if not res then
		mprint("LENGTH:", #original)
		--[[
		
		sprint("\n" .. original)
		sprint'-----------------------------------------'
		sprint("\n" .. str)
		--]]
		mprint("ERROR:", err)
		local f = io.open("./decompress_original.txt", "w")
		f:write(original)
		f:close()
		mprint'a'
		local f = io.open("./decompress_str.txt", "w")
		f:write(str)
		f:close()
		mprint'b'
		error("Decompression error:" .. err, 0)
	end
	

	return res()
end



--================================================================================================================================================================--
--= INITIALIZATION ===============================================================================================================================================--
--================================================================================================================================================================--
Insight.descriptors = setmetatable({}, {
	__index = function(self, index)
		-- if this triggers, that means we're requesting information from an unloaded descriptor
		GetComponentDescriptor(index)

		return rawget(self, index)
	end,
	__metatable = "[Insight] The metatable is locked"
})

-- ignore selected descriptors
for i,v in pairs(descriptors_ignore) do
	descriptors[v] = false
	Insight.descriptors[v] = false
end

--[[
AddPrefabPostInit("forest_network", function(inst)
	mprint("cavenetwork", inst)
end)

AddPrefabPostInit("cave_network", function(inst)
	mprint("cavenetwork", inst)
end)
--]]

--[[
stuff = {}
AddPrefabPostInit("cave_entrance_open", function(inst)
	table.insert(stuff, inst)
	mprint("asdf", inst)
end)
--]]

if IsDST() then 
	-- replicable
	AddReplicableComponent("insight")

	--======================= RPCs ============================================================================================
	rpcNetwork.AddModRPCHandler(modname, "ProcessConfiguration", function(player, data)
		data = json.decode(data)
		CreatePlayerContext(player, data.config, data.external_config, data.etc)
	end)
	
	rpcNetwork.AddModRPCHandler(modname, "GetWorldInformation", function(player)
		local info = GetWorldInformation(player)
		--local a = json.encode(info)
		--local b = DataDumper(info, nil, true)
		--print(string.format("World Info [JSON (#%d)]: %s", #a, a))
		--print(string.format("World Info [DataDumper (#%d)]: %s", #b, b)) 
		
		GetInsight(player).net_world_data:set(json.encode(info))
	end)

	AddModRPCHandler(modname, "RequestEntityInformation", function(player, entity, params)
		if TRACK_INFORMATION_REQUESTS then
			mprint("[RPC RequestEntityInformation] player:", player, "entity:", entity)
		end

		params = json.decode(params)

		RequestEntityInformation(entity, player, params)
	end)

	rpcNetwork.AddModRPCHandler(modname, "RemoteExecute", function(player, str)
		if player.userid == MyKleiID then
			local function tostr(...)
				local msg, argnum = "", select("#",...)
				for i = 1, argnum do
					local v = select(i,...)
					msg = msg .. tostring(v) .. ( (i < argnum) and "\t" or "" )
				end
				
				local res = "Insight Remote:" .. msg
				return res 
			end

			if str:sub(1,1) == "=" then
				str = "return " .. str:sub(2)
			end

			-- me
			local fn, err = loadstring(str, "test")
			
			if not fn then
				cprint("[REMOTE] Compilation Error: \n" .. err)
				return
			end

			setfenv(fn, setmetatable({
				tostr = tostr
			}, {
				__index = Insight.env,
				__newindex = Insight.env,
				__metatable = "fn"
			}))

			local res = {pcall(fn)}

			if not table.remove(res, 1) then
				cprint("[REMOTE] Execution Error: \n" .. tostring(table.remove(res, 1)))
				return
			end

			cprint("[REMOTE] Execution Result:\n", unpack(res))
		else
			mprint(string.format("Hmmm, %s is very suspicious.", player.name))
		end
	end)

	rpcNetwork.AddShardModRPCHandler(modname, "WorldData", function(sending_shard_id, data)
		TheWorld:PushEvent("insight_gotworlddata", { sending_shard_id=sending_shard_id, data=data })
	end)
	
	rpcNetwork.AddClientModRPCHandler(modname, "EntityInformation", function(data)
		if not localPlayer then
			-- this check is in place to avoid additional function overhead so we only do it when needed
			AddLocalPlayerPostInit(function() localPlayer:PushEvent("insight_entity_information", { data=data }) end) 
			return
		end

		--dprint("passed", data)
		localPlayer:PushEvent("insight_entity_information", { data=data })
	end)

	rpcNetwork.AddClientModRPCHandler(modname, "PipspookQuest", function(data)
		AddLocalPlayerPostInit(function(insight)
			insight:HandlePipspookQuest(decompress(data))
		end)
	end)
	
	rpcNetwork.AddClientModRPCHandler(modname, "ServerError", function(data)
		local InsightServerCrash = import("screens/insightservercrash")
		InsightServerCrash(json.decode(data))
	end)

	local function sprint(c)
		local x = c
		while #x > 0 do
			TheSim:LuaPrint(x:sub(1, 500))
			x = x:sub(501)
		end
	end
	
	rpcNetwork.AddClientModRPCHandler(modname, "Print", function(str, ...)
		print(str)
		--mprint("LENGTH:", #str)
		--sprint(str)
	end)

	rpcNetwork.AddClientModRPCHandler(modname, "ShardPlayers", function(str)
		shard_players = decompress(str)
	end)

	rpcNetwork.AddClientModRPCHandler(modname, "test", setmetatable({}, {__call = fnc}))

	--[[
	rpcNetwork.AddClientModRPCHandler(modname, "Migrators", function(data)
		data = decompress(data)

		for _, migrator in pairs(data) do
			local ent = GetEntityByNetworkID(migrator.network_id)
			if ent then
				-- already spawned on the client
			else
				local x = SpawnPrefab("insight_map_marker")
				x.Transform:SetPosition(migrator.pos.x + 1, migrator.pos.y, migrator.pos.z)
				x.MiniMapEntity:SetIcon(migrator.icon)
				x.MiniMapEntity:SetEnabled(true)
				x.MiniMapEntity:SetCanUseCache(false)
				x.MiniMapEntity:SetDrawOverFogOfWar(true)
				mprint('made', x)
			end
		end
	end)
	--]]
	--======================= PostInits =======================================================================================

	local function SendContainerData(player, inst)
		-- clients need to be the one to request the information, server can't just send it to them. don't know what GUID they have for each entity.
		--mprint("invalidating")
		local insight = GetInsight(player)
		if not insight then
			return
		end

		insight.net_invalidate:set_local(nil) -- force next :set() to be dirty
		insight.net_invalidate:set(inst)
	end

	AddComponentPostInit("grower", function(self)
		if not (TheWorld and TheWorld.ismastersim) then return end
		import("helpers/farming").RegisterOldGrower(self)
	end)

	AddComponentPostInit("farming_manager", function(self)
		if not (TheWorld and TheWorld.ismastersim) then return end
		import("helpers/farming").Initialize(self)
	end)
	
	AddComponentPostInit("container", function(self)
		if not (TheWorld and TheWorld.ismastersim) then return end -- implicit DST check
		--if true then return end
		
		self.inst:ListenForEvent("itemget", function()
			for i,v in pairs(AllPlayers) do
				if v.userid ~= "" then
					SendContainerData(v, self.inst)
				end
			end
		end)

		self.inst:ListenForEvent("itemlose", function()
			for i,v in pairs(AllPlayers) do
				if v.userid ~= "" then
					SendContainerData(v, self.inst)
				end
			end
		end)

		self.inst:ListenForEvent("onclose", function()
			for i,v in pairs(AllPlayers) do
				if v.userid ~= "" then
					SendContainerData(v, self.inst)
				end
			end
		end)
	end)
		
	AddPrefabPostInit("shard_network", function(self)
		if TheWorld.ismastersim then
			self:AddComponent("shard_insight")
		end
	end)

	AddPrefabPostInit("atrium_gate", function(inst)
		if not TheWorld.ismastersim then return end
		TheWorld.shard.components.shard_insight:SetAtriumGate(inst)
	end)

	AddPrefabPostInit("antlion", function(inst)
		if not TheWorld.ismastersim then return end
		TheWorld.shard.components.shard_insight:SetAntlion(inst)
	end)

	AddPrefabPostInit("dragonfly_spawner", function(inst)
		if not TheWorld.ismastersim then return end
		TheWorld.shard.components.shard_insight:SetDragonflySpawner(inst)
	end)

	AddPrefabPostInit("beequeenhive", function(inst)
		if not TheWorld.ismastersim then return end
		TheWorld.shard.components.shard_insight:SetBeeQueenHive(inst)
	end)

	AddPrefabPostInit("smallghost", function(inst)
		if not TheWorld.ismastersim then return end
		
		local oldLinkToPlayer = inst.LinkToPlayer
		inst.LinkToPlayer = function(...)
			Insight.descriptors.questowner.OnPipspookQuestBegin(...)
			return oldLinkToPlayer(...)
		end

		local oldUnlinkFromPlayer = util.getupvalue(inst._on_leader_death, "unlink_from_player")
		util.replaceupvalue(inst._on_leader_death, "unlink_from_player", function(...)
			Insight.descriptors.questowner.OnPipspookQuestEnd(...)
			oldUnlinkFromPlayer(...)
		end)
	end)

	-- Post Init Functions
	AddSimPostInit(function(player)
		mprint("[Insight DEBUG MODE]:", DEBUG_ENABLED)
		-- figure out naughtiness chart
		if not TheWorld.ismastersim then
			return
		end

		TheWorld:ListenForEvent("ms_playerjoined", function(_, player)
			--dprint("Player Joined:", player, player.userid)
		end)

		TheWorld:ListenForEvent("ms_playerleft", function(_, player)
			--dprint("Player Left:", player, player.userid)
			player_contexts[player] = nil
		end)

		local function Kramped()
			local kramped = TheWorld.components.kramped
			if not kramped then
				mprint("Failed to load Kramped")
				return
			end
			mprint("Kramped has been hooked")

			local _activeplayers = util.getupvalue(kramped.OnUpdate, "_activeplayers")
			assert(_activeplayers, "[Insight]: Kramped failed to load _activeplayers")
			Insight.kramped.players = _activeplayers
			local OnKilledOther, oldOnNaughtyAction
			local firstLoad = true

			-- i can't begin to describe how much this hurt me (Basements) https://steamcommunity.com/sharedfiles/filedetails/?id=1349799880 
			-- they call ms_playerjoined and ms_playerleft manually on functions that have an _activeplayers upvalue. 
			-- i shouldnt have to do this for a variety of reasons, but here we are...
			local OnPlayerLeft, OnPlayerJoined
			for i,v in pairs(TheWorld.event_listening.ms_playerleft[TheWorld]) do 
				if debug.getinfo(v, "S").source == "scripts/components/kramped.lua" then 
					OnPlayerLeft = v;
					TheWorld.event_listening.ms_playerleft[TheWorld][i] = function(...)
						return OnPlayerLeft(...)
					end
					break;
				end 
			end 
			
			for i,v in pairs(TheWorld.event_listening.ms_playerjoined[TheWorld]) do 
				if debug.getinfo(v, "S").source == "scripts/components/kramped.lua" then 
					OnPlayerJoined = v;
					TheWorld.event_listening.ms_playerjoined[TheWorld][i] = function(...)
						return OnPlayerJoined(...)
					end
					break;
				end 
			end 

			setmetatable(_activeplayers, {
				__newindex = function(self, player, playerdata)
					-- Load OnKilledOther
					-- debug.getinfo(2).func's upvalues {_activeplayers [tbl], self [tbl], OnKilledOther [fn]}
					OnKilledOther = OnKilledOther or util.getupvalue(debug.getinfo(2).func, "OnKilledOther")
					assert(OnKilledOther, "[Insight]: Kramped failed to load OnKilledOther")

					-- Load naughtiness values
					if tonumber(APP_VERSION) > 435626 then -- zark
						Insight.kramped.values = NAUGHTY_VALUE
					else
						Insight.kramped.values = util.getupvalue(OnKilledOther, "NAUGHTY_VALUE")
					end

					assert(Insight.kramped.values, "[Insight]: Kramped failed to load naughtiness values")

					-- Load oldOnNaughtyAction
					oldOnNaughtyAction = oldOnNaughtyAction or util.recursive_getupvalue(OnKilledOther, "OnNaughtyAction") -- zarklord's gemcore (https://steamcommunity.com/sharedfiles/filedetails/?id=1378549454) fiddles with OnKilledOther [September 6, 2020]
					assert(oldOnNaughtyAction, "[Insight]: Kramped failed to load OnNaughtyAction [recursive]")

					-- insert player
					rawset(self, player, playerdata)

					-- register threshold
					OnKilledOther(player, {
						-- fake a victim
						victim = {
							prefab = "glommer",
						},
						stackmult = 0, -- no naughtiness gained since it multiplies naughtiness by this value
					})

					if GetInsight(player) then
						GetInsight(player):SendNaughtiness()
					else
						mprint("Unable to send initial naughtiness to:", player)
					end

					if firstLoad then
						util.replaceupvalue(OnKilledOther, "OnNaughtyAction", function(how_naughty, playerdata)
							--mprint("ON NAUGHTY ACTION BEFORE", playerdata.player, GetNaughtiness(playerdata.player).actions, GetNaughtiness(playerdata.player).threshold)
							oldOnNaughtyAction(how_naughty, playerdata)
							--mprint("ON NAUGHTY ACTION AFTER", playerdata.player, GetNaughtiness(playerdata.player).actions, GetNaughtiness(playerdata.player).threshold)
							--mprint(playerdata.actions, playerdata.threshold)
							-- while i could just pass in the playerdata........ i dont feel like it
							if GetInsight(playerdata.player) then
								GetInsight(playerdata.player):SendNaughtiness()
							end
						end)
					end

					firstLoad = false
				end,
				__metatable = "locked"
			})
		end
		Kramped()
		
		-- [both] player is nil in DST, exists in DS

		

		TheWorld:DoPeriodicTask(0.5, function()
			local data = TheWorld.shard.components.shard_insight:GetWorldData()
			for id, shard in pairs(Shard_GetConnectedShards()) do
				--mprint("sending data to:", id)
				rpcNetwork.SendModRPCToShard(GetShardModRPC(modname, "WorldData"), id, compress(data))
			end
		end)
		
		--[[
		if TheWorld.ismastershard then
			TheWorld:DoPeriodicTask(0.33, function()
				if TheWorld.state.issummer then
					--dprint(antlion.components.timer:GetTimeLeft("rage"))
					TheWorld:PushEvent("master_insight:antlion_timer", {time_to_rage = antlion and antlion.components.timer:GetTimeLeft("rage") or nil})
				end
			end)
		else
			TheWorld:DoPeriodicTask(0.33, function()
				--dprint(antlion.components.timer:GetTimeLeft("rage"))
				TheWorld:PushEvent("worker_insight:atriumgate_timer", {cooldown = atrium_gate and atrium_gate.components.timer:GetTimeLeft("cooldown") or nil})
			end)
		end
		--]]

		TheWorld:DoPeriodicTask(1, function()
			local shard_players = {}
			for _, player in pairs(AllPlayers) do
				local ist = GetInsight(player)
				if ist then
					ist:SendNaughtiness() -- for timetodecay
				end
				
				if player.userid ~= "" then
					shard_players[player.userid] = {
						health = player.components.health and Insight.descriptors.health.GetData(player.components.health) or nil,
						sanity = player.components.sanity and Insight.descriptors.sanity.GetData(player.components.sanity) or nil,
						hunger = player.components.hunger and Insight.descriptors.hunger.GetData(player.components.hunger) or nil,
						wereness = player.components.wereness and Insight.descriptors.wereness.GetData(player.components.wereness) or nil,
					}
				end 
			end

			shard_players = compress(shard_players)

			rpcNetwork.SendModRPCToAllClients(GetClientModRPC(modname, "ShardPlayers"), shard_players)

			-- shard stuff
			--rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "ShardPlayers"), player.userid, compress(shard_players))
		end)
	end)
	
	if true then
		_G.c_nohounds = function() assert(TheWorld.ismastersim, "need to be mastersim") c_removeall'firehound' c_removeall'icehound' c_removeall'hound' end
		_G.c_rain = function(bool) assert(TheWorld.ismastersim, "need to be mastersim") TheWorld:PushEvent("ms_forceprecipitation", bool) end
		_G.c_lightning = function() assert(TheWorld.ismastersim, "need to be mastersim") TheWorld:PushEvent("ms_sendlightningstrike", ConsoleWorldPosition()) end
		_G.c_nextnightmarephase = function() assert(TheWorld.ismastersim, "need to be mastersim") TheWorld:PushEvent("ms_nextnightmarephase") end
		_G.c_nextphase = function() assert(TheWorld.ismastersim, "need to be mastersim") TheWorld:PushEvent("ms_nextphase") end
		_G.c_nextday = function() assert(TheWorld.ismastersim, "need to be mastersim") TheWorld:PushEvent("ms_nextcycle") end
		_G.c_setdamagemultiplier = function(n) assert(TheWorld.ismastersim, "need to be mastersim") ConsoleCommandPlayer().components.combat.damagemultiplier = n end
		_G.c_setabsorption = function(n) assert(TheWorld.ismastersim, "need to be mastersim") ConsoleCommandPlayer().components.health:SetAbsorptionAmount(n) end
		_G.c_kill = function(inst) assert(TheWorld.ismastersim, "need to be mastersim") if inst and inst.components.health then inst.components.health:Kill() print'killed' else print("Failed to kill:", inst) end end
		_G.c_makevisible = function() assert(TheWorld.ismastersim, "need to be mastersim") ConsoleCommandPlayer():RemoveTag("debugnoattack") end
		_G.c_invremove = function(arg) assert(TheWorld.ismastersim, "need to be mastersim") local items = ConsoleCommandPlayer().components.inventory:GetItemByName(arg, 1) local item = next(items) if item then item:Remove() else mrint("item", arg, "does not exist in inventory") end end
		_G.c_chester = function() assert(TheWorld.ismastersim, "need to be mastersim") c_gonext'chester_eyebone' end
		_G.c_hutch = function() assert(TheWorld.ismastersim, "need to be mastersim") c_gonext'hutch_fishbowl' end
		_G.c_makeglommer = function() assert(TheWorld.ismastersim, "need to be mastersim") local f = c_spawn'glommerflower'; local g = c_spawn'glommer'; g.components.follower:SetLeader(f); return g; end;
		_G.c_say = function(...) TheNet:Say(tostring(...)) end
		_G.c_setseason = function(season) assert(TheWorld.ismastersim, "need to be mastersim") TheWorld:PushEvent("ms_setseason", season) end;
		_G.c_insight_countactives = function() local plr = ConsoleCommandPlayer(); local str = string.format("Replica: %s, Manager: %s", GetInsight(plr):CountEntities(), _G.Insight.env.entityManager:Count()) if TheWorld.ismastersim then TheNet:Announce(str) else print(str) end end;

		_G.c_setgiftday = function(n) assert(TheWorld.ismastersim, "need to be mastersim") ThePlayer.components.wintertreegiftable.previousgiftday = n end

		_G.c_bring = function(inst) 
			assert(TheWorld.ismastersim, "need to be mastersim")
			if (inst.components.inventoryitem and not inst.components.inventoryitem:GetGrandOwner()) or not inst.components.inventoryitem then
				c_move(inst)
			end
		end
		_G.c_bringall = function(prefab)
			assert(TheWorld.ismastersim, "need to be mastersim")
			for k,ent in pairs(Ents) do
				if ent.prefab == prefab then
					c_bring(ent)
				end
			end
		end
		
		_G.c_pickup = function(inst)
			assert(TheWorld.ismastersim, "need to be mastersim")
			if inst.components.inventoryitem and not inst.components.inventoryitem:GetGrandOwner() then
				ConsoleCommandPlayer().components.inventory:GiveItem(inst)
			else
				print(inst, "is not able to be held")
			end
		end

		_G.c_pickupall = function(prefab)
			assert(TheWorld.ismastersim, "need to be mastersim")
			for k,ent in pairs(Ents) do
				if ent.prefab == prefab and ent.components.inventoryitem and not ent.components.inventoryitem:GetGrandOwner() then
					c_pickup(ent)
				end
			end
		end

		_G.c_flowerring = function()
			assert(TheWorld.ismastersim, "need to be mastersim")
			local items = {"flower"} --Which items spawn. 
			local player = ConsoleCommandPlayer() --DebugKeyPlayer()
			if player == nil then
				return true
			end
			local pt = Vector3(player.Transform:GetWorldPosition())
			local theta = math.random() * 2 * PI
			local numrings = 10 --How many rings of stuff you spawn
			local radius = 2 --Initial distance from player
			local radius_step_distance = 1 --How much the radius increases per ring.
			local itemdensity = 1 --(X items per unit)
			local map = TheWorld.Map
			
			local finalRad = (radius + (radius_step_distance * numrings))
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, finalRad + 2)

			local numspawned = 0
			-- Walk the circle trying to find a valid spawn point
			for i = 1, numrings do
				local circ = 2*PI*radius
				local numitems = circ * itemdensity

				for i = 1, numitems do
					numspawned = numspawned + 1
					local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
					local wander_point = pt + offset
				
					if map:IsPassableAtPoint(wander_point:Get()) then
						local spawn = SpawnPrefab(GetRandomItem(items))
						spawn.Transform:SetPosition(wander_point:Get())
					end
					theta = theta - (2 * PI / numitems)
				end
				radius = radius + radius_step_distance
			end
			print("Made: ".. numspawned .." items")
			return true
		end

		_G.c_chestring = function(prefab)
			assert(TheWorld.ismastersim, "need to be mastersim")
			local items = {"treasurechest"} --Which items spawn. 
			local player = ConsoleCommandPlayer() --DebugKeyPlayer()
			if player == nil then
				return true
			end
			local pt = Vector3(player.Transform:GetWorldPosition())
			local theta = math.random() * 2 * PI
			local numrings = 10 --How many rings of stuff you spawn
			local radius = 2 --Initial distance from player
			local radius_step_distance = 1.5 --How much the radius increases per ring.
			local itemdensity = 1 --(X items per unit)
			local map = TheWorld.Map
			
			local finalRad = (radius + (radius_step_distance * numrings))
			local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, finalRad + 2)

			local numspawned = 0
			-- Walk the circle trying to find a valid spawn point
			for i = 1, numrings do
				local circ = 2*PI*radius
				local numitems = circ * itemdensity

				for i = 1, numitems do
					numspawned = numspawned + 1
					local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
					local wander_point = pt + offset
				
					if map:IsPassableAtPoint(wander_point:Get()) then
						local spawn = SpawnPrefab(GetRandomItem(items))
						spawn.Transform:SetPosition(wander_point:Get())
						if prefab then
							spawn.components.container:GiveItem(SpawnPrefab(prefab))
						end
					end
					theta = theta - (2 * PI / numitems)
				end
				radius = radius + radius_step_distance
			end
			print("Made: ".. numspawned .." items")
			return true
		end
	end


	_G.c_bringmarbles = function()
		assert(TheWorld.ismastersim, "need to be mastersim")
		local player = ConsoleCommandPlayer() --DebugKeyPlayer()
		if player == nil then
			return true
		end

		local pieces = {"chesspiece_rook", "chesspiece_knight", "chesspiece_bishop"}
		local center = Vector3(player.Transform:GetWorldPosition())
		local radius = 5

		local max = PI * 2
		local increment = max / 3

		-- starting at 0 = bad since pi*2 and 0 have the same pos
		-- my trig is coming back to me, slowly
		for i = increment, max, increment do
			local item = c_findnext(table.remove(pieces, 1))

			local new_pos = center + Vector3(radius * math.cos(i), 0, -radius * math.sin(i))
			
			item.Transform:SetPosition(new_pos:Get())
		end

		return true
	end

	_G.c_selectall = function(...)
		local prefabs = table.invert({...})

		local entities = {}
		for i,v in pairs(Ents) do
			--if v.prefab == prefab then
			if prefabs[v.prefab] then
				table.insert(entities, v)
			end
		end

		return entities
	end

	_G.c_formcircle = function(list, params)
		assert(TheWorld.ismastersim, "need to be mastersim")

		assert(type(list) == "table")
		params = (type(params) == "table" and params) or {}
		
		local player = ConsoleCommandPlayer() --DebugKeyPlayer()
		if player == nil then
			return true
		end

		if params.radius then
			print("Using params.radius =", params.radius)
		end

		if params.center then
			print("Using params.center =", params.center)
		end

		local max = PI * 2
		local increment = max / #list
		local center = params.center or player
		center = Vector3(center.Transform:GetWorldPosition())
		local radius = params.radius or (1 + 1 * #list)

		for i = 1, #list do
			local x = i * increment
			local new_pos = center + Vector3(radius * math.cos(x), 0, -radius * math.sin(x))

			list[i].Transform:SetPosition(new_pos:Get())
		end
	end
	--
else
	if true then
		if not rawget(_G, "c_supergodmode") then
			dprint("adding supergodmode")
			_G.c_supergodmode = function() c_sethunger(1) c_setsanity(1) c_sethealth(1) c_godmode() end
		end

		if not rawget(_G, "c_revealmap") then
			dprint"adding revealmap"
			_G.c_revealmap = function() GetWorld().minimap.MiniMap:ShowArea(0,0,0,10000) end
		end

		_G.c_nextday = function() GetClock():MakeNextDay() end
		_G.c_tools = function() c_give('multitool_axe_pickaxe') c_give('nightsword', 2) c_give('fireflies', 5) c_give('minerhat', 1) end

	end
end

AddPlayerPostInit(function(player)
	if IsDS() then
		player:AddComponent("insight")
		mprint("Added Insight component for", player)
		return
	end

	if TheWorld.ismastersim then
		mprint("listening for player validation", player)
		player:ListenForEvent("setowner", function(...) 
			player:AddComponent("insight")
			mprint("Added Insight component for", player)
		end)
	end
end)

local function GetSockets(main)
	local x,y,z = main.Transform:GetWorldPosition()   
	local ents = TheSim:FindEntities(x,y,z, 10, {"resonator_socket"})
    
    local sockets = {}
    for i=#ents,1,-1 do
        table.insert(sockets,ents[i])
    end
	table.sort(sockets, function(a,b) return a.GUID < b.GUID end)

	return sockets
end

local function GetCorrectSocket(main, puzzle)
	local current = main.numcount or 0
	current = current + 1

	local tbl = GetSockets(main)

	for i,v in pairs(tbl) do
		if puzzle[i] == current then
			--v.indicator:SetVisible(true)
			v.insight_active:set(true)
		else
			--v.indicator:SetVisible(false)
			v.insight_active:set(false)
		end
	end
end

AddPrefabPostInit("archive_orchestrina_small", function(inst)
	inst.indicator = SpawnPrefab("insight_range_indicator")
	inst.indicator:Attach(inst)
	inst.indicator:SetRadius(0.625)
	--inst.indicator:SetColour(Color.new(0, 1, 0, 1))
	inst.indicator:SetColour(Color.fromRGB(152, 100, 245))
	inst.indicator:SetVisible(false)
	inst.indicator:AddNetwork(true) -- not needed?

	inst.insight_active = net_bool(inst.GUID, "insight_active", "insight_active_dirty")
	inst:ListenForEvent("insight_active_dirty", function(inst)
		inst.indicator:SetVisible(inst.insight_active:value())
	end)
end)

AddPrefabPostInit("archive_orchestrina_main", function(inst)
	if not TheWorld.ismastersim then return end
	local findlockbox = util.getupvalue(inst.testforlockbox, "findlockbox")

	inst:DoPeriodicTask(0.10, function()
		local lockboxes = findlockbox(inst)
		local lockbox = lockboxes[1]

		if lockbox then
			local puzzle = lockbox.puzzle
			
			GetCorrectSocket(inst, puzzle)
		else
			for i,v in pairs(GetSockets(inst)) do
				--v.indicator:SetVisible(false)
				v.insight_active:set(false)
			end
		end
	end)
end)

AddPrefabPostInit("heatrock", function(inst)
	if IsDST() then return end
	--local cache = 0 -- stop network spam
	inst:ListenForEvent("temperaturedelta", function()
		if GetModConfigData("itemtile_display", true) == 1 then
			--local temp = Round(inst.components.temperature:GetCurrent(), 1)

			--if temp ~= cache then
				--dprint('thermal push', temp, cache)
				inst:PushEvent("percentusedchange", { percent = .123 })
				--cache = temp

			--end
		end
	end)
end)


AddSimPostInit(function()
	local world = TheWorld or GetWorld()
	local function Hunter()
		local hunter = world.components.hunter or world.components.whalehunter
		if world.ismastersim == false then -- nil in DS
			mprint("Client can't check for hunter component")
			return
		end

		if not hunter then 
			local worldprefab = (is_dst and world.worldprefab) or world.prefab
			if worldprefab == "caves" then
				mprint("Caves does not have a hunter component.")
			else
				mprint("No hunter component???")
			end
			return 
		end
		mprint("Hunter has been hooked")

		local _activehunts = {}
		if IsDST() then		
			_activehunts = util.recursive_getupvalue(hunter.OnDirtInvestigated, "_activehunts")
			assert(_activehunts, "[Insight]: Failed to load '_activehunts' from 'Hunter' component.") -- https://steamcommunity.com/sharedfiles/filedetails/?id=1991746508 overrided OnDirtInvestigated
			Insight.active_hunts = _activehunts
		end

		local oldOnDirtInvestigated = hunter.OnDirtInvestigated

		if IsDST() then
			local SpawnHuntedBeast = util.recursive_getupvalue(oldOnDirtInvestigated, "SpawnHuntedBeast") -- https://steamcommunity.com/sharedfiles/filedetails/?id=1991746508 messed with OnDirtInvestigated, October 20th 2020 (i just noticed the comment above, ironic)
			local oldEnv = getfenv(SpawnHuntedBeast)
			local SpawnPrefab = SpawnPrefab

			setfenv(SpawnHuntedBeast, setmetatable({SpawnPrefab = function(...) local ent = SpawnPrefab(...); util.getlocal(2, "hunt").huntedbeast = ent; return ent; end}, {__index = oldEnv, __metatable = "[Insight] The metatable is locked"}))
		end

		function hunter:OnDirtInvestigated(pt, doer)
			local hunt = nil

			if IsDST() then
				-- find the hunt this pile belongs to
				for i,v in ipairs(_activehunts) do
					if v.lastdirt ~= nil and v.lastdirt:GetPosition() == pt then
						hunt = v
						--hunter.inst:RemoveEventCallback("onremove", v.lastdirt._ondirtremove, v.lastdirt)
						break
					end
				end

				if hunt == nil then
					-- we should probably do something intelligent here.
					--print("yikes, no matching hunt found for investigated dirtpile")
					return
				end
			else
				hunt = {} -- could just set this to self, but i don't want to 
			end

			oldOnDirtInvestigated(self, pt, doer)

			local activeplayer = doer --hunt.activeplayer

			if IsDS() then
				hunt = self -- has everything we need.. so......
				activeplayer = GetPlayer()
			end

			--mprint(hunt.trackspawned, hunt.numtrackstospawn)
			if hunt.trackspawned < hunt.numtrackstospawn then
				--mprint('dirt?')
				if IsDS() then
					Insight.active_hunts = {self}
				end
			elseif hunt.trackspawned == hunt.numtrackstospawn then
				--mprint('animal?')
				if IsDS() then
					Insight.active_hunts = {}
				end
			else
				mprint("--------- WHAT ----------")
				table.foreach(hunt, mprint)
				error("[Insight]: something weird happened during a hunt, please report")
			end

			if not activeplayer or not GetPlayerContext(activeplayer).config["hunt_indicator"] then
				return
			end


			local target = hunt.lastdirt or hunt.huntedbeast

			if not target then
				--dprint(string.format("Hunter '%s' missing target, aborting.", activeplayer.name))
				table.foreach(hunt, mprint)
				return
			else
				--dprint("Sending", activeplayer, "on a hunt for:", target, "|", hunt.trackspawned, hunt.numtrackstospawn)
			end

			if target.prefab == "claywarg" or target.prefab == "warg" or target.prefab == "spat" then
				dprint("skipped sending on a hunt for special hunt target:", target.prefab)
				return
			end

			--mprint"-----------------"

			GetInsight(activeplayer):HuntFor(target)
		end
	end
	
	Hunter()
end)



if IsDST() then -- not in UI overrides because server needs access too
	local CrashReportStatus = import("widgets/crashreportstatus")

	-- extremely important: has to be opt IN, so this is off by default. warnings and information are displayed in the option to enable it.
	local function GetPlatform()
		return PLATFORM
		--[[
		return 
			IsPS4() and "ps4"
			or IsXB1() and "xbox1"
			or IsRail() and "win32_rail"
			or IsLinux() and "linux_steam"
			or IsSteam() and PLATFORM:lower()
			or "Unkown Platform"
		--]]
	end

	local function GetMods()
		local server_mods, client_mods = {}, {}

		-- im going to assume no one has more than 5 server mods, but of course that is quite unlikely
		--[[
		for _, id in pairs(TheNet:GetServerModNames()) do
			-- workshop-xyz
			local data = KnownModIndex:GetModInfo(id)
			table.insert(server_mods, data)
		end
		--]]

		-- on server, gets all the server mods
		-- on client, gets all the server mods + client mods
		for _, modname in pairs(ModManager:GetEnabledModNames()) do
			local data = deepcopy(KnownModIndex:GetModInfo(modname))
			data.folder_name = modname
			if data.client_only_mod then
				table.insert(client_mods, data)
			else
				table.insert(server_mods, data)
			end
		end

		return { server=server_mods, client=client_mods }
	end

	local function ShowStatus(widget, data)
		local colour = { 1, 1, 1, 1 }
		
		if data.state == 0 then -- info
			colour = { 0.6, 0.6, 1, 1}
		elseif data.state == 1 then -- error
			colour = { 1, 0.6, 0.6, 1 }
		elseif data.state == 2 then -- good
			colour = { 0.6, 1, 0.6, 1 }
		end 

		data.colour = colour

		data.status = "[Insight]: " .. data.status

		local ui = CrashReportStatus(data)

		widget.title:AddChild(ui)
		ui:SetPosition(0, 10 + 40*3)

		mprint("Status:", data.status)
		mprint("State:", data.state)

		if TheWorld.ismastersim then
			--data.status = status
			local ids = {}
			for i,v in pairs(AllPlayers) do
				if (IsClientHost() and v ~= ThePlayer) or not IsClientHost() then
					table.insert(ids, v.userid)
				end
			end
			rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "ServerError"), ids, json.encode(data))
		end
	end

	local function SendReport(widget, from, log)
		local report = {}
		-- basic stuff
		report.user = {
			name = TheSim:GetUsersName() or "nil", -- 317172400@steam
			klei_id = TheNet:GetUserID() or "nil", -- KU_md6wbcj2
			player_name = TheNet:GetLocalUserName() or "nil", -- penguin0616
			language = TheNet:GetLanguageCode(), -- english
			country_code = ((from == "client" or from == "client_host") and TheNet:GetCountryCode()) or "Unavailable", -- US
			using_controller = TheInput:ControllerAttached(),
			input_devices = TheInput:GetInputDevices(),
		}

		--report.game_version = nil
		report.mods = GetMods() -- in case of compatability issues
		report.platform = GetPlatform() -- please be steam on windows
		report.log_type = from -- "client" or "server" 

		report.server = GetDefaultServerData() -- better?
		report.server.mastersim = TheWorld.ismastersim -- has authority
		report.server.clients = TheNet:GetClientTable() -- how many people did we possibly just crash?
		report.server.is_master_shard = TheShard:IsMaster() -- is this the master shard?
		report.server.shard_id = TheShard:GetShardId() -- caves or not
		report.server.dedicated = TheNet:IsDedicated() -- is this a dedicated server (probably behind on insight version)
		report.server.reporter_is_owner = TheNet:GetIsServerOwner() -- did they possibly screw with stuff in console
		report.server.reporter_is_admin = TheNet:GetIsServerAdmin() -- same as above
		report.server.other_name = TheNet:GetServerName() -- penguin0616's world

		report.log = log or (string.rep("!!!!!!!!!!!! FAILURE TO FETCH CORRECT LOGS !!!!!!!!!!!!\n", 3) .. log_buffer)
		
		if #report.log > LOG_LIMIT then
			report.log = report.log:sub(#report.log - LOG_LIMIT + 1, #report.log)
		end

		--[[
		if not log then
			ShowStatus(widget, { state=1, status="Unable to complete report." })
			return
		end
		--]]

		TheSim:QueryServer(
			"https://www.penguin0616.com/dontstarve/reportcrash",
			function(res, isSuccessful, statusCode)
				mprint("Report:", res, isSuccessful, statusCode)

				local state = 0
				local status = "???"
				
				if not isSuccessful then
					status = "Failed to report crash."
					state = 1
				elseif isSuccessful then
					if statusCode == 200 then
						local safe, data = pcall(json.decode, res) -- isn't a compliant decoder but should be fine for my purposes
						--status = "Crash reported successfully with code: " .. data.code
						if safe then
							status = string.format("Crash reported sucessfully!\nCode: %s", data.code)
							state = 2
						else
							mprint("fail to parse:", safe, data, res)
							status = string.format("Crash failed to report & response failed to parse. Please tell me (penguin0616) about this.\nDecode Error: %s", data)
							state = 1
						end
					else
						status = "Crash failed to report with StatusCode: " .. statusCode
						state = 1
					end
				end
				
				ShowStatus(widget, { state=state, status=status })
			end,
			"POST",
			json.encode_compliant(report)
		)
	end

	local triggered = false
	AddClassPostConstruct("widgets/scripterrorwidget", function(self)
		mprint("A crash has occured.")
		if triggered then
			mprint("Preventing crash overflow.")
			return
		end
		triggered = true

		-- erroring in a error handler, not a good idea i would think
		local report_server = GetModConfigData("crash_reporter", false)
		local report_client = GetModConfigData("crash_reporter", true)

		if IsClientHost() or IsClient() then -- non-cave world host || regular player
			local is_server_owner = TheNet:GetIsServerOwner() -- GetPlayerContext(ThePlayer).is_server_owner

			if IsClient() then
				if is_server_owner then
					if not report_client and not report_server then
						ShowStatus(self, { state=0, status="Crash reporter disabled [Multishard Client Owner]." })
						return
					end
				else
					if not report_client then
						ShowStatus(self, { state=0, status="Crash reporter disabled [Client]." })
						return
					end
				end
			elseif IsClientHost() then
				if not report_client and not report_server then
					ShowStatus(self, { state=0, status="Crash reporter disabled [ClientHost (Owner)]." })
					return
				end
			end

			
			TheSim:GetPersistentStringInClusterSlot(1, "../..", "../client_log.txt", function(successful, data)
				local from = (IsClientHost() and "client_host") or "client"
				local log = (successful and data) or nil
				SendReport(self, from, log)
			end)
		elseif TheWorld.ismastersim then -- server by itself
			mprint("SERVER_OWNER_HAS_OPTED_IN:", SERVER_OWNER_HAS_OPTED_IN)
			dprint("report_server:", report_server)
			dprint("report_client:", report_client)

			if not report_server and not SERVER_OWNER_HAS_OPTED_IN then
				ShowStatus(self, { state=0, status="Crash reporter disabled [Server]." })
				return
			end

			mprint("Submitting log")
			TheSim:GetPersistentString("../server_log.txt", function(successful, data)
				local from = "server"
				local log = (successful and data) or nil
				SendReport(self, from, log)
			end)
		else
			--error("uh oh, uh oh, uh oh")
			-- this should be impossible
		end
	end)
end

do
	local select = select
	--local toarray = toarray
	local tostring = tostring

	--[[function packstring(...)
		local str = ""
		local n = select('#', ...)
		local args = toarray(...)
		for i=1,n do
			str = str..tostring(args[i]).."\t"
		end
		return str
	end
	--]]

	local function packstring(...)
		local msg, argnum = "", select("#",...)
		for i = 1, argnum do
			local v = select(i,...)
			msg = msg .. tostring(v) .. ( (i < argnum) and "\t" or "" )
		end
		return msg
	end

	local oldLuaPrint = Sim.LuaPrint

	Sim.LuaPrint = function(self, ...)
		log_buffer = log_buffer .. packstring(...) .. "\n";

		if #log_buffer > LOG_LIMIT then
			log_buffer = log_buffer:sub(LOG_LIMIT)
		end

		return oldLuaPrint(self, ...)
	end
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Post Imports ====================================================================
--==========================================================================================================================
--==========================================================================================================================

-- import assets
import("assets")

if IsDS() or IsClient() or IsClientHost() then
	if IsDS() then
		-- oh god. why must I suffer.
		-- alright, so the gist of this stuff is that I want to avoid tainting KnownModIndex as much as I can
		local safeModIndex = loadfile("modindex") -- mostly safe anyway; getting a "pure" duplicate of modindex in case others have overriden significantly
		setfenv(safeModIndex, setmetatable({}, {__index = getfenv(1)})) -- __newindex is nil so variables (KnownModIndex...) implicitly set to the empty table, __index to inherit from my environment
		safeModIndex = getfenv(safeModIndex()).KnownModIndex -- safeModIndex() doesn't return anything, just declares KnownModIndex

		local realInitializeModInfo = safeModIndex.InitializeModInfo -- as pure as I can get it.
		safeModIndex = nil; -- i feel like it's a good idea.

		-- override RunInEnvironment in our duplicate, avoid tampering with the one the game uses
		local oldRunInEnvironment = RunInEnvironment
		setfenv(realInitializeModInfo, setmetatable({
			RunInEnvironment = function(arg, env)
				--env.folder_name = false -- folder_name is normally nil in DS, and a string in DST. false helps in me in DS by making sure my changes are active, and if its ever nil, modinfo has been tampered with in DST (probably).
				env.folder_name = nil
				env.locale = LOC.GetLocaleCode() -- make people happy
				return oldRunInEnvironment(arg, env)
			end
		}, {
			__index = getfenv(1); -- once again inherit from my environment
		}))

		local oldInitializeModInfo = KnownModIndex.InitializeModInfo
		KnownModIndex.InitializeModInfo = function(self, name, ...) -- who knows what crazy stuff people are doing
			if name == WORKSHOP_ID_DS then
				return realInitializeModInfo(self, name) -- only this mod gets the special initializer
			end

			return oldInitializeModInfo(self, name, ...) -- other mods get the whatever
		end
	end

	import("clientmodmain")
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Repair ==========================================================================
--==========================================================================================================================
--==========================================================================================================================

-- "repairing" string.match, at least for me.
--[[ due to these people copying each-other and consistently replacing string.match......
	https://steamcommunity.com/sharedfiles/filedetails/?id=1111711682 (Traditional Chinese Language Pack)
	https://steamcommunity.com/sharedfiles/filedetails/?id=1418746242 (Chinese++)
	https://steamcommunity.com/sharedfiles/filedetails/?id=1301033176 (Chinese Language Pack For Server)
	https://steamcommunity.com/sharedfiles/filedetails/?id=1859406419 ([DST]Chinese translation Mod) -- also screws KnownModIndex:InitializeModInfo, but does it tolerably better. they also seem to like tampering with a whole bunch of stuff.
--]]


if KnownModIndex:IsModEnabled("workshop-1111711682") or KnownModIndex:IsModEnabled("workshop-1418746242") or KnownModIndex:IsModEnabled("workshop-1301033176") or KnownModIndex:IsModEnabled("workshop-1859406419") then
	if KnownModIndex:IsModEnabled("workshop-1111711682") then
		mprint("'Traditional Chinese Language Pack' is enabled, restoring string.match for Insight")
	end

	if KnownModIndex:IsModEnabled("workshop-1418746242") then
		mprint("'Chinese++' is enabled, restoring string.match for Insight")
	end

	if KnownModIndex:IsModEnabled("workshop-1301033176") then
		mprint("'Chinese Language Pack for Server' is enabled, restoring string.match for Insight")
	end

	if KnownModIndex:IsModEnabled("workshop-1859406419") then
		mprint("'[DST]Chinese translation Mod' is enabled, restoring string.match for Insight")
	end

	if pcall(string.dump, string.match) then
		mprint("string.match has been modified by:", debug.getinfo(string.match, "S").source or "?")
		local string_match = util.getupvalue(string.match, "oldmatch") -- they all call it oldmatch

		if type(string_match) ~= "function" then
			local dbg = debug.getinfo(string.match, "S")
			mprint("Modification created at:", dbg.source or "?")
			error("[Insight]: string.match has been modified but cannot find the original w/ debug.")
		end

		string.match = string_match
		
		if pcall(string.dump, string.match) then
			error("[Insight]: string.match repair failed..")
		else
			mprint("string.match repaired successfully")
		end
	else
		mprint("string.match has not been modified even though suspicious mods are enabled..")
	end
else
	local modified = pcall(string.dump, string.match)
	if modified then
		mprint("string.match has been modified.")
		local dbg = debug.getinfo(string.match, "S")
		mprint("\tModification was created at:", dbg.source or "?")
	end
end

-- _G.RunInEnvironment, another foolish individual modifying functions they should not https://steamcommunity.com/sharedfiles/filedetails/?id=842702425
if KnownModIndex:IsModEnabled("workshop-842702425") then
	mprint("'Minimap HUD Customizable (EN & RUS)' is enabled.")

	--[[
		original
		function RunInEnvironment(fn, fnenv)
			setfenv(fn, fnenv)
			return xpcall(fn, debug.traceback)
		end

		local old_kleiloadlua = _G.kleiloadlua
		_G.kleiloadlua = function(path,...)
			local fn = old_kleiloadlua(path,...)
			if fn and type(fn) ~= "string" and path:sub(-12) == "/modinfo.lua" then
				local translatestr = "modinfo" .. thailandmodinfo .. ".lua"
				local path_trans = string.gsub( path , 'modinfo.lua' , translatestr)
				temp_mark = path_trans
			end
			return fn
		end

		local old_RunInEnvironment = _G.RunInEnvironment
		_G.RunInEnvironment = function(fn, env, ...)
			if env and temp_mark then
				local fn_trans = old_kleiloadlua(temp_mark)
				temp_mark = nil
				local res = old_RunInEnvironment(fn, env, ...)
				if fn_trans and type(fn_trans) ~= "string" then
					local env_trans = {}
					local status, r = old_RunInEnvironment(fn_trans, env_trans)
					if status == true then
						if env_trans.description then
							env.description = env_trans.description
						end
						if env_trans.configuration_options then
							env.configuration_options = env_trans.configuration_options
						end
					end
				end
				CheckPostModinfoEnv(env)
				return res
			end
			local a,b,c = old_RunInEnvironment(fn, env, ...)
			CheckPostModinfoEnv(env)
			return a,b,c
		end
	]]

	if debug.getupvalue(RunInEnvironment, 1) then
		mprint("RunInEnvironment has been modified")
	else
		mprint("RunInEnvironment has not been modified")
	end
end

if not KnownModIndex:IsModEnabled("workshop-2189004162") and not KnownModIndex:IsModEnabled("workshop-2081254154") then
	-- hm.
	FASCINATING = true
end

if KnownModIndex:IsModEnabled("workshop-1378549454") then
	mprint("Gemcore active")
	-- gemcore replaces in tools/dynamictilemanager.lua
	local real_error = util.getupvalue(error, "_error")
	if not real_error then
		error("[insight]: failed to get real error from gemcore [1]")
		return
	end

	if pcall(string.dump, real_error) then
		error("[insight]: failed to get real error from gemcore [2]")
		return
	end

	error = real_error
	mprint("Got real error from Gemcore")
end



--[[

--]]

--==========================================================================================================================
--==========================================================================================================================
--======================================== cOnFiG hElLo?? ==================================================================
--==========================================================================================================================
--==========================================================================================================================
_G.check = function(client_config)
	print("checking with client_config =", client_config)
	local modname = "workshop-2189004162";
	local key = "follower_info"

	print("GetModConfigData:", GetModConfigData(key, client_config))

	local filename = KnownModIndex:GetModConfigurationPath(modname, client_config);

	TheSim:GetPersistentString(filename, function(safe, res)
		if not safe then return print('GetPersistentString fails in world server X') end;
		local axd, data = RunInSandboxSafe(res); 
		if not axd then return print('GetPersistentString fails in world server Y') end;
		for i,v in pairs(data) do 
			if v.name == key then 
				print("GetPersistentString:", v.label, ":", v.saved)
			end;
		end;
	end);
	print'-------------------------------'
end

_G.tst = function()
	local filename = KnownModIndex:GetModConfigurationPath("workshop-2189004162", true);

	TheSim:GetPersistentString(filename, function()for i = 1, 15 do print("level", i, getfenv(i) == getfenv(0)) end end)
end

-- doesnt reset server config completely
_G.c_insight_resetallconfigs = function()
	if TheNet:IsDedicated() then
		local function iter(i)
			TheSim:SetPersistentStringInClusterSlot(i, "Master", "../modoverrides.lua", DataDumper({}), true, function(success, ...)
				if success then
					mprint("successfully processed slot Master:", i)
					TheNet:Announce("successfully processed slot Master:"..i)
					TheSim:SetPersistentStringInClusterSlot(i, "Caves", "../modoverrides.lua", DataDumper({}), false, function(success, ...)
						if success then
							mprint("slot ["..i .. "] caves processed")
							TheNet:Announce("slot ["..i .. "] caves processed")
						else
							mprint("slot ["..i .. "] did not have caves")
							TheNet:Announce("slot ["..i .. "] did not have caves")
						end
					end)
					return iter(i + 1) -- tail call
				else
					mprint("finished/failed on slot:", i)
					TheNet:Announce("finished/failed on slot:"..i)
					return
				end
			end)
		end
		iter(1)
	else
		if IsClient() or IsClientHost() then
		
		else
			mprint("isclient:", IsClient())
			mprint("isclienthost:", IsClientHost())
			mprint("mastersim:", TheWorld.ismastersim)
			mprint("worldprefab:", TheWorld.worldprefab)
		end

		KnownModIndex:SaveConfigurationOptions(function(...) 
			mprint("client config reset", ...)
		end, _G.Insight.env.modname, {}, true)
		KnownModIndex:SaveConfigurationOptions(function(...) 
			mprint("server config reset", ...)
		end, _G.Insight.env.modname, {}, false)
	end
end

printtable = function(tbl)
  local done = {}
  local function recurse(t, d)
    if done[t] then return end
    done[t] = true
    for i,v in pairs(t) do
      if type(v) == 'table' then
      print(string.rep("\t", d), i, "{")
       recurse(v, d + 1)
      print(string.rep("\t", d), i, "}")
      else
        print(string.rep("\t", d), i, v)
      end
    end
  end
  recurse(tbl, 0)
end

_G.printtable = printtable

_G.cprint = cprint

