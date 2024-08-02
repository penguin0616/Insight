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

---------------------------------------
-- Utilities.
-- @module util
-- @author penguin0616

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local STRINGS = STRINGS

local infotext_common = import("uichanges/infotext_common")

local module = {
	temperature = {
		conversion_fns = {
			game = function(temp)
				return temp
			end,
			celsius = function(temp)
				return temp/2
			end,
			fahrenheit = function(temp)
				return 1.8 * (temp/2) + 32
			end,
		}
	}
}

if IS_DS and not UICOLOURS then
	_G.GOLD = {202/255, 174/255, 118/255, 255/255}
	_G.GREY = {.57, .57, .57, 1}
	_G.BLACK = {.1, .1, .1, 1}
	_G.WHITE = {1, 1, 1, 1}
	_G.BROWN = {97/255, 73/255, 46/255, 255/255}
	_G.RED = {.7, .1, .1, 1}
	_G.DARKGREY = {.12, .12, .12, 1}

	function _G.RGB(r, g, b)
		return { r / 255, g / 255, b / 255, 1 }
	end

	_G.UICOLOURS = {
		GOLD_CLICKABLE = RGB(215, 210, 157), -- interactive text & menu
		GOLD_FOCUS = RGB(251, 193, 92), -- menu active item
		GOLD_SELECTED = RGB(245, 243, 222), -- titles and non-interactive important text
		GOLD_UNIMPORTANT = RGB(213, 213, 203), -- non-interactive non-important text
		HIGHLIGHT_GOLD = RGB(243, 217, 161),
		GOLD = GOLD,
		BROWN_MEDIUM = RGB(107, 84, 58),
		BROWN_DARK = RGB(80, 61, 39),
		BLUE = RGB(80, 143, 244),
		GREY = GREY,
		BLACK = BLACK,
		WHITE = WHITE,
		BRONZE = RGB(180, 116, 36, 1),
		EGGSHELL = RGB(252, 230, 201),
		IVORY = RGB(236, 232, 223, 1),
		IVORY_70 = RGB(165, 162, 156, 1),
		PURPLE = RGB(152, 86, 232, 1),
		RED = RGB(207, 61, 61, 1),
		SLATE = RGB(155, 170, 177, 1),
		SILVER = RGB(192, 192, 192, 1),
	}
end

--- Returns the default if the number is not a valid number.
---@param num number
---@param default
---@return number @Returns the sanitized number.
function SanitizeNumber(num, default)
	if num ~= num or num == math.inf or num == -math.inf then
		return default
	end
	return num
end

if IS_DS then
	function _G.ClickMouseoverSoundReduction() return nil end

	function isnan(x) return x ~= x end
	math.inf = 1/0 
	function isinf(x) return x == math.inf or x == -math.inf end
	function isbadnumber(x) return isinf(x) or isnan(x) end
	
	function _G.FunctionOrValue(func_or_val, ...)
		if type(func_or_val) == "function" then
			return func_or_val(...)
		end
		return func_or_val
	end

	-- RunInSandboxSafe uses an empty environement
	-- By default this function does not assert
	-- If you wish to run in a safe sandbox, with normal assertions:
	-- RunInSandboxSafe( untrusted_code, debug.traceback )
	function _G.RunInSandboxSafe(untrusted_code, error_handler)
		if untrusted_code:byte(1) == 27 then return nil, "binary bytecode prohibited" end
		local untrusted_function, message = loadstring(untrusted_code)
		if not untrusted_function then return nil, message end
		setfenv(untrusted_function, {} )
		return xpcall(untrusted_function, error_handler or function() end)
	end

	function _G.metapairs(t, ...)
		local m = debug.getmetatable(t)
		local p = m and m.__pairs or pairs
		return p(t, ...)
	end
end

module.COLORS_ADD = { -- brighter but most color gets siphoned at night
	-- alpha doesn't matter? 
	RED = {0.6, 0, 0, 1}, -- red (by itself, #ff0000, it's red.)
	GREEN = {0, 0.5, 0, 1}, -- green (by itself, #00ff00, it's green.)
	BLUE = {0, 0, 1, 1}, -- blue (by itself, #0000ff, it's blue.)
	--GRAY = {0.4, 0.4, 1}, -- gray (by itself, #666666, is gray)
	--BLACK = {0, 0, 0, 1}, -- black (by itself, #000000, is black)
	NOTHING = {0, 0, 0, 0}, -- default without any changes

	LIGHT_BLUE = {0, 0.4, 0.6, 1}, -- light blue (by itself, #006699, its a nice ocean blue)
	PURPLE = {0.4, 0, 1, 1}, -- purple (by itself, #6600ff, dark blue with red tint) -- rgb(155, 89, 182) {0.6, 0.35, 0.71, 1} sin purple -- rgb(98, 37, 209) {0.38, 0.145, 0.82, 1} royal purple
	YELLOW = {0.4, 0.4, 0, 1}, -- yellow (by itself, #666600, ugly dark yellow)
	WHITE = {0.4, 0.4, 0.4, 1},
	ORANGE = {0.8, 0.35, 0, 1}, -- orange -- {1, 0.5, 0, 1}
	PINK = {1, 0, 1, 1}
}

module.COLORS_ADD.GRAY = module.COLORS_ADD.NOTHING
module.COLORS_ADD.BLACK = module.COLORS_ADD.NOTHING

module.COLORS_MULT = { -- more resistant to night siphoning color, but dimmer
	RED = {1, 0.4, 0.4, 1}, -- red (by itself, #ff6666, lighter version of MOB_COLOR)
	GREEN = {0.3, 1, 1, 1}, -- greenish (by itself, #4dffff, seems to be slightly lighter cyan)
	BLUE = {0.4, 0.4, 1, 1},
	GRAY = {0.4, 0.4, 0.4, 1}, -- gray (by itself, #666666, is gray)
	BLACK = {0, 0, 0, 1}, -- black (by itself, #000000, is black)
	NOTHING = {1, 1, 1, 1}, -- default without any changes

	LIGHT_BLUE = {0, 0.9, 1, 1},  -- 0, 0.5, 1
	PURPLE = {0.4, 0, 1, 1},
	--YELLOW = {0.5, 0.5, 0, 1},
	--WHITE = {1, 1, 1, 1},
	ORANGE = {1, 0.4, 0.4, 1},
	PINK = {1, 0, 1, 1},
}

module.COLORS_MULT.YELLOW = module.COLORS_MULT.GREEN
module.COLORS_MULT.WHITE = module.COLORS_MULT.GREEN

module.temperature.DEGREE_CHARACTER = string.char(0xb0) --utf8char(0xb0) -- utf8char doesn't exist in DS.
module.temperature.GAME_FORMAT = "%.1f" .. module.temperature.DEGREE_CHARACTER
module.temperature.CELSIUS_FORMAT = module.temperature.GAME_FORMAT .. "C"
module.temperature.FAHRENHEIT_FORMAT = module.temperature.GAME_FORMAT .. "F"

local Reader = import("reader")
local Text = require("widgets/text") --FIXED_TEXT
local known_bundles = setmetatable({}, {__mode = "k"})

WALL_STUDS_PER_TILE = 4 
ATTACK_RANGE_PER_WALL_STUD = 2

-- is it worth putting the module's table/string funcs in the lua state's counterparts?
-- if the changes were was constant and i could guarantee no parasites, it would make sense
-- but i don't want to modify the original state if i can avoid it, even if it makes my life a bit harder

local entity_network_cache = setmetatable({}, { __mode = "v" })

-- extremely expensive
function GetEntityByNetworkID(network_id, to_search)
	assert(false, "I should not be using GetEntityByNetworkID.")

	if entity_network_cache[network_id] then
		return entity_network_cache[network_id]
	end

	to_search = to_search or Ents

	for i,v in pairs(to_search) do
		if v.Network:GetNetworkID() == network_id then
			entity_network_cache[network_id] = v
			return v
		end
	end
end


function ProcessRichTextPlainly(string)
	-- Assumes string is just a single line
	local str = ""
	local chunks = Reader:new(string):Read()
	
	for i = 1, #chunks do
		local chunk = chunks[i]
		 
		local next = nil
		if chunk:IsObject() then
			if chunk.object.class == "prefab" then
				local prefab = chunk.object.value
				next = GetPrefabNameOrElse(prefab, "[prefab \"%s\"]")
			end
		else
			next = chunk.text
		end

		str = str .. UnescapeRichText(next)
	end

	return str
end


function EscapeRichText(str)
	return str:gsub("<", "&lt;"):gsub(">", "&gt;")
end

function UnescapeRichText(str)
	return str:gsub("&lt;", "<"):gsub("&gt;", ">")
end


function GetReduxListItemPrefix(row_width, row_height)
	local prefix = "listitem_thick" -- 320 / 90 = 3.6
	local ratio = row_width / row_height
	if ratio > 6 then
		-- Longer texture will look better at this aspect ratio.
		prefix = "serverlist_listitem" -- 1220.0 / 50 = 24.4
	end
	return prefix
end

function GetReduxButtonPrefix(size)
	local prefix = "button_carny_long"
	if size and #size == 2 then
		local ratio = size[1] / size[2]
		if ratio > 4 then
			-- Longer texture will look better at this aspect ratio.
			prefix = "button_carny_xlong"
		elseif ratio < 1.1 then
			-- The closest we have to a tall button.
			prefix = "button_carny_square"
		end
	end
	return prefix
end


--[==[
function GetEntityDebugData(ent)
	--[[
		116786 - purplemooneye age 1220.57
GUID:116786 Name:  Tags: _inventoryitem inspectable 
Prefab: purplemooneye
AnimState: bank: mooneyes build: mooneyes anim: purplegem_idle anim/mooneyes.zip:purplegem_idle Frame: 55.00/2 Facing: 0:right
Transform: Pos=(-323.32,0.00,482.53) Scale=(1.00,1.00,1.00) Heading=0.00
Network: NetworkID=184193 Owner=UNASSIGNED_RAKNET_GUID NetSleep=1111111111111111111111111111111111111111111111111111111111111110
MiniMapEntity: 
Physics: Collision Group: 256 Mask: 32,64,128,512,8192, (ACTIVE) Vel: 0.00
SoundEmitter: 
Buffered Action: nil
	]]
	local str = ent.entity:GetDebugString() -- only need entity

	local age = string.match(str, "age ([%d.]+)")
	local network_id = string.match(str, "NetworkID=(%d+)")
	local network_owner = nil -- network owner is same as [Connect] InternalInitClient <NUMBERS>

	return {
		network_id = tonumber(network_id)
	}
end
--]==]

function GetWidgetChildByName(widget, name)
	for child in pairs(widget:GetChildren()) do
		if child.name == name then
			return child
		end
	end
end

function DoesEntityExistForClient(ent, client)
	if not TheWorld.ismastersim then
		return false
	end
	--if the entity is within 64 units of the client(ThePlayer), it will exist on the client; except, if its InLimbo, unless its Network:SetClassifiedTarget == ThePlayer

	-- EntityScript:IsInLimbo() has note

	if ent.inlimbo then
		
	end
end

function IsDataValidForConfigOptions(options, data)
	for i,v in pairs(options) do
		if v.data == data then
			return true
		end
	end
	return false
end

function ListenForEventOnce(ent, event, eventfn, source)
	local callback; callback = function(...)
		eventfn(...)
		ent:RemoveEventCallback(event, callback, source);
	end

	ent:ListenForEvent(event, callback, source);
end

function IsBundleWrap(inst)
	if known_bundles[inst] ~= nil then
		return known_bundles[inst]
	end
	-- ACTION_COMPONENT_IDS in EntityScript is "component" = id
	-- entity.actioncomponents is {index = id}
	-- these 2 ids are the same
	local res = (inst.components and inst.components.unwrappable) or (inst.HasActionComponent and HasVanillaActionComponent(inst, "unwrappable"))
	
	if res then
		known_bundles[inst] = true
	else
		if inst.HasTag and inst:HasTag("unwrappable") then
			if not inst.prefab:sub(1, 19) == "quagmire_seedpacket" then -- carl said this would drastically decrease the world's energy consumption
				error("[Insight]: Attempt to disable known bundle") --quagmire_seedpacket
			end
		end

		known_bundles[inst] = false
	end

	return known_bundles[inst]
end

function AreEntityPrefabsEqual(inst1, inst2)
	if inst1.prefab == inst2.prefab then
		if inst1.components.named or inst1.replica.named then
			-- stands to reason the second one is the same
			return inst1.name == inst2.name
		end

		return true
	end

	return false
end


function ApplyColor(str, clr)
	if clr.ToHex ~= nil then
		clr = clr.hex or clr:ToHex()
	end
	
	return string.format("<color=%s>%s</color>", clr, str)
end

ApplyColour = ApplyColor

function front(widget)
	widget:MoveToFront()
	for i,v in pairs(widget:GetChildren()) do
		front(v)
	end
end

function back(widget)
	widget:MoveToBack()
	for i,v in pairs(widget:GetChildren()) do
		back(v)
	end
end

function GetPlayerColour(arg)
	if type(arg) == "string" then
		local client_table = TheNet:GetClientTable()
		for i = 1, #client_table do
			local v = client_table[i]
			if v.userid == arg or v.name == arg then
				return Color.new(unpack(v.colour))
			end
		end
	elseif IsPrefab(arg) and arg:HasTag("player") then
		return Color.new(unpack(arg.Network:GetPlayerColour())) -- 0,0,0,0 if not owned
	end
	
	local default = PORTAL_TEXT_COLOUR or {243/255, 244/255, 243/255, 255/255}

	return Color.new(unpack(default))
end

function SetTostring(thing, fn)
	setmetatable(thing, {
		__index = getmetatable(thing).__index,
		__newindex = getmetatable(thing).__newindex,
		__call = getmetatable(thing).__call,
		__tostring = fn
	})
end

function DEBUG_IMAGE(bool) 
	if bool then
		return "images/White_Square.xml", "White_Square.tex"
	end

	return nil, nil
end

-- functions i took out of modmain for organization reasons

--- Checks if number is an integer.
---@param num number
---@return boolean
function IsInt(num)
	-- http://web.archive.org/web/20210325065927/http://lua.2524044.n2.nabble.com/Fastest-way-to-determine-number-is-integer-in-plain-Lua-td7639129.html
	return num%1 == 0
end

function pack(...) 
	return { n=select("#", ...), ...} 
end
function vararg(packed) 
	return unpack(packed, 1, packed.n) 
end

--- best description
local function ResolveColorsReplaceFn(clr, str)
	return string.format("<color=%s>", Insight.COLORS[clr] or clr, str)
end

function ResolveColors(str)
	local res = str:gsub("<color=([#%w_]+)>", ResolveColorsReplaceFn)

	return res
	--return string.format("<color=%s>%s</color>", Insight.COLORS[c] or c, s)
end

function GetPrefabNameOrElse(prefab, other)
	if not prefab then
		return string.format(other or "ERROR: %s</color>", ApplyColor(tostring(nil), "#ff0000"))
	end

	local upper = prefab:upper()

	-- a seed?
	if STRINGS.NAMES["KNOWN_" .. upper] then
		return STRINGS.NAMES["KNOWN_" .. upper]
	end

	-- easy peasy
	if STRINGS.NAMES[upper] then
		return STRINGS.NAMES[upper]
	end

	-- moose/goose logic?
	if upper == "MOOSE" then
		return STRINGS.NAMES.MOOSE1 .. "/" .. STRINGS.NAMES.MOOSE2
	elseif upper == "MOOSEEGG" then
		local t = GetTime()/10 % 1
		if t < 0.5 then
			return STRINGS.NAMES.MOOSEEGG1
		else
			return STRINGS.NAMES.MOOSEEGG2
		end
	elseif upper == "MOOSENEST" then
		local t = GetTime()/10 % 1
		if t < 0.5 then
			return STRINGS.NAMES.MOOSENEST1
		else
			return STRINGS.NAMES.MOOSENEST2
		end
	end

	-- specific override names?
	if upper == "STALKER_FOREST" then
		return STRINGS.NAMES.STALKER
	end

	-- antler?
	if string.sub(upper, 1, 11) == "DEER_ANTLER" then
		return STRINGS.NAMES.DEER_ANTLER
	end
	
	-- ornament?
	local ornaments = Insight.prefab_descriptors.winter_ornaments and Insight.prefab_descriptors.winter_ornaments.ORNAMENT_DATA
	if ornaments and ornaments[prefab] then
		local override = string.upper(ornaments[prefab].overridename or "?")
		return STRINGS.NAMES[override] or override
	end

	-- blueprint? (blueprint.lua onload)
	local blueprint_match = string.match(upper, "([%w_]+)_BLUEPRINT")
	if blueprint_match then
		return GetPrefabNameOrElse(blueprint_match, other) .. " " .. STRINGS.NAMES.BLUEPRINT
	end

	-- spiced food?
	local spiced, spice = string.match(upper, "(%w+)_SPICE_(%w+)") -- meatballs_spice_chili
	if spice then
		-- yep its spiced
		--[[
			SPICE_GARLIC_FOOD = "Garlic {food}",
			SPICE_SUGAR_FOOD = "Sweet {food}",
	   		SPICE_CHILI_FOOD = "Spicy {food}",
			SPICE_SALT_FOOD = "Salty {food}",
		--]]
		local str = STRINGS.NAMES["SPICE_" .. spice .. "_FOOD"]
		if str then
			return subfmt(str, { food = GetPrefabNameOrElse(spiced, other) })
		end
	end

	return string.format(other or "no_name: %s", prefab)
end

function FormatDecimal(num, places)
	if not places then
		local x = string.match(num, "%.(.+)")
		places = x and #x or 1
	end
	
	return string.format("%+." .. places .. "f", num)
end

--- Formats a number into a string. Adds a + if positive.
---@param num number
---@return string
function FormatNumber(num)
	--[[
	num = tonumber(num)
	local s = tostring(num)

	if num > 0 then
		s = "+" .. s
	end

	return s
	--]]

	return string.format("%+d", num)
end

--- Rounds float.
---@param num number
---@param places integer How many decimal places to round to.
---@return number
function Round(num, places)
	places = places or 1
	return tonumber(string.format("%." .. places .. "f", num)) or 0
end

function FormatTemperature(num, mode)
	if mode == "game" then
		return string.format(module.temperature.GAME_FORMAT, num)
	elseif mode == "celsius" then
		return string.format(
			module.temperature.CELSIUS_FORMAT, 
			module.temperature.conversion_fns.celsius(tonumber(num))
		)
	elseif mode == "fahrenheit" then
		return string.format(
			module.temperature.FAHRENHEIT_FORMAT, 
			module.temperature.conversion_fns.fahrenheit(tonumber(num))
		)
	else
		return error("bad temperature mode")
	end
end

--- Calculates Region Size of a Text Widget
---@param str string The text you want to measure.
---@param font string
---@param sz integer Font size
---@return number, number @Calculated width and height
function CalculateSize(str, font, sz)
	font = font or UIFONT
	sz = sz or 30
	local obj = Text(font, sz, str)
	obj:SetAlpha(0)
	local w, h = obj:GetRegionSize()
	obj:Kill()
	return w, h
end

--- Combines inputs into a single string seperated by newlines.
-- @tparam ?string|nil ...
---@return string
function CombineLines(...)
	local lines, argnum = nil, select("#",...)

	for i = 1, argnum do
		local v = select(i, ...)
		
		if v ~= nil then
			lines = lines or {}
			lines[#lines+1] = tostring(v)
		end
	end

	return (lines and table.concat(lines, "\n")) or nil
end

--- Combines inputs into a single string seperated by a separator.
-- @tparam ?string|nil ...
---@return string
function CombineStrings(separator, ...)
	local lines, argnum = nil, select("#",...)

	for i = 1, argnum do
		local v = select(i, ...)
		
		if v ~= nil then
			lines = lines or {}
			lines[#lines+1] = tostring(v)
		end
	end

	return (lines and table.concat(lines, separator)) or nil
end

-- This is originally from https://stackoverflow.com/a/53038524/887438
-- I edited it to be able to pass in a value in place of a function and pass in additional arguments.
-- For some reason, this runs better in a normal 5.1 than the hardcoded version in the pastebin test in the source link though. Weird.
function ArrayPurge(t, fnKeep, ...)
	local is_fn = type(fnKeep) == "function"
    local j, n = 1, #t;

    for i=1,n do
        if (is_fn and fnKeep(t, i, j, ...)) or (not is_fn and t[i] == fnKeep) then
            -- Move i's kept value to j's position, if it's not already there.
            if (i ~= j) then
                t[j] = t[i];
                t[i] = nil;
            end
            j = j + 1; -- Increment position of where we'll place the next kept value.
        else
            t[i] = nil;
        end
    end

    return t;
end

function module.GetInsightFont()
	if infotext_common and infotext_common.initialized then
		return Insight.env[infotext_common.configs.insight_font]
	end

	return UIFONT
end

--- Clamps a math value.
---@param num number (required) The number to clamp.
---@param min ?number|nil (optional) The minimum value.
---@param max ?number|nil (optional) The minimum value.
---@return number
function module.math_clamp(num, min, max)
	-- previous code was a disgrace
	return (num < min and min) or (num > max and max) or num
end

--- Returns the first result of the table that agrees with param 'fn'
---@param tbl table
---@param fn function
---@return any
function module.table_find(tbl, fn)
	local typ = type(fn)

	if typ ~= "function" and typ ~= "string" then
		error("bad argument #2 to table_find (string/function expected, got " .. typ .. ")")
	end
	
	for i,v in pairs(tbl) do
		if v == fn or (typ == 'function' and fn(v)) then
			return v
		end
	end
end

--- Parses a string into a bool, if possible.
---@param b string The string.
---@return boolean|string @Returns the boolean if it succeeded, the string you passed in otherwise.
function module.parsebool(b)
	local typ = type(b)
	if typ ~= "string" then
		return error("bad argument #1 to parsebool (string expected, got " .. typ .. ")")
	end

	if b == "true" then
		return true
	elseif b == "false" then
		return false
	end

	return b
end

--- Checks if a string ends with the provided input.
---@param str string The string.
---@param chunk string What the ending should be.
---@return boolean
function module.string_endsWith(str, chunk)
	return str:sub(#str - #chunk) == chunk
end

--- Checks if a string begins with the provided input.
---@param str string The string.
---@param chunk string What the beginning should be.
---@return boolean
function module.string_startsWith(str, chunk)
	return str:sub(1, #chunk) == chunk
end

--- Retrives value from a table and removes the key.
---@param tbl table
---@param index ?int|string
---@return any
function module.table_extract(tbl, index)
	local typ = type(tbl)
	if typ ~= "table" then
		error("bad argument #1 to table_foreach (table expected, got " .. typ .. ")")
		return
	end

	local value = tbl[index]
	if value then
		if type(index)=="number" and IsInt(index) then
			table.remove(index)
		else
			tbl[index] = nil
		end
	end
	return value
end

--- Retrieves all of a function's upvalues.
---@param func function
---@return table
function module.getupvalues(func) 
	local upvs = {}
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then return upvs end
		table.insert(upvs, {name=n, value=v}) -- ISSUE:PERFORMANCE (TEST#12)
		i = i + 1
	end
	return upvs
end

function module.recursive_getupvalues(func)
	local checked = {}
	local upvs = {}

	local function scan(fn)
		if checked[fn] then
			return nil
		end

		checked[fn] = true

		for i, upv in pairs(module.getupvalues(fn)) do
			table.insert(upvs, upv) 

			if type(i) == "function" then -- in case some wise guy decides to store something with the index as a function.
				scan(i)
			elseif type(upv.value) == "function" then
				scan(upv.value)
			--elseif type(upv.name) == "function" then -- in case some wise guy decides to store something with the index as a function.
				--scan(upv.name)
			end
		end
	end

	scan(func)

	return upvs
end

--[[
function module.getupvaluesandenvironment(func)
	local checked = {}
	local stuff = {}

	local function scan(arg)
		if checked[arg] then
			return
		end

		checked[arg] = true

		for i,v in pairs(getfenv(arg)) do
			table.insert(stuff, {name=i, value=v})

			if type(i) == "function" then
				scan(i)
			end
			if type(v) == "function" then
				scan(v)
			end
		end

		for i, upv in pairs(module.getupvalues(fn)) do
			table.insert(upvs, upv)

			if type(i) == "function" then -- in case some wise guy decides to store something with the index as a function.
				scan(i)
			elseif type(upv.value) == "function" then
				scan(upv.value)
			--elseif type(upv.name) == "function" then -- in case some wise guy decides to store something with the index as a function.
				--scan(upv.name)
			end
		end
	end


	scan(func)

	return stuff
end
--]]

--- Retrives the first upvalue that matches the arguments.
---@param func function
---@param name string
---@return any, boolean @The boolean indicates whether the serach was successful or not.
function module.getupvalue(func, name)
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then 
			return v, true
		end
		i = i + 1
	end

	return nil, false
end

function module.getupvalue_chain(func, ...)
	if func == nil then
		return error("util.getupvalue_chain got nil for func")
	end

	-- last function we got upvalues from
	local last = func
	-- last argument we processed
	local end_pos = nil
	-- all arguments to process
	local args = {...}
	-- number of arguments to process
	local argn = select("#", ...)

	for n = 1, argn do
		local i = 1

		while true do
			local name, value = debug.getupvalue(last, i)

			if not name then
				-- we've checked every upvalue present but didn't find the current one in the chain
				-- this indicates to the caller that we had a failure
				end_pos = args[n]
				break
			end

			if name == args[n] then 
				-- we've found the upvalue we were looking for
				last = value
				break
			end

			i = i + 1
		end
	end

	
	-- Why did I do this return? I can't fathom the use case for this right now.
	return last, end_pos
end

function module.recursive_getupvalue(func, name)
	local checked = {}

	local function scan(fn)
		if checked[fn] then
			return nil
		end

		checked[fn] = true

		for _, upv in pairs(module.getupvalues(fn)) do
			if (type(name) == 'function' and name(upv.name, upv.value)) or upv.name == name then
				return upv.value
			elseif type(upv.value) == 'function' then
				local res = scan(upv.value)
				if res then
					return res
				end
			end
		end
	end

	return scan(func)
end

--- Retrives the first local that matches the arguments.
---@param level integer
---@param name string
---@return any
function module.getlocal(level, name) 
	local i = 1
	while true do
		local n, v = debug.getlocal(level + 1, i)
		if not n then break end
		if n == name then return v end
		i = i + 1
	end
end

function module.getlocals(level) 
	local locals = {}
	local i = 1
	while true do
		local n, v = debug.getlocal(level + 1, i)
		if not n then return locals end
		table.insert(locals, {name = n, value = v})
		i = i + 1
	end
end

function module.setlocal(level, name, replacement)
	if type(name) ~= "string" then
		error("argument #2 expected string, got " .. type(name))
	end

	local i = 1
	while true do
		local n, v = debug.getlocal(level + 1, i)
		if not n then break end
		if n == name then
			debug.setlocal(level + 1, i, replacement)
			return v
		end
		i = i + 1
	end
	
	error(string.format("Unable to find local '%s' for replacing.", name))
end

--- Retrives and replaces the first upvalue that matches the arguments.
---@param func function
---@param name string Name of the upvalue to search for.
---@param replacement
---@return any
function module.replaceupvalue(func, name, replacement)
	if type(name) ~= "string" then
		error("argument #2 expected string, got " .. type(name))
	end

	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then
			debug.setupvalue(func, i, replacement)
			return v
		end
		i = i + 1
	end
	error(string.format("Unable to find upvalue '%s' for replacing.", name))
end

if not table.invert then
	-- whatever
	function table.invert(t)
		local invt = {}
		for k, v in pairs(t) do
			invt[v] = k
		end
		return invt
	end
end

if not table.reverselookup then
	function table.reverselookup(t, lookup_value)
		for k, v in pairs(t) do
			if v == lookup_value then
				return k
			end
		end
		return nil
	end
end

if not table.getkeys then
	-- Return an array table of the keys of the input table.
	function table.getkeys(t)
		local keys = {}
		for key,val in pairs(t) do
			table.insert(keys, key)
		end
		return keys
	end
end

-- Sourced from https://web.archive.org/web/20131225070434/http://snippets.luacode.org/snippets/Deep_Comparison_of_Two_Values_3
function deepcompare(t1, t2, ignore_mt)
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	local mt = getmetatable(t1)
	if not ignore_mt and mt and mt.__eq then return t1 == t2 end
	for k1,v1 in pairs(t1) do
		local v2 = t2[k1]
		if v2 == nil or not deepcompare(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
		local v1 = t1[k2]
		if v1 == nil or not deepcompare(v1,v2) then return false end
	end
	return true
end

if not shallowcopy then
	-- http://lua-users.org/wiki/CopyTable
	function shallowcopy(orig, dest)
		local copy
		if type(orig) == 'table' then
			copy = dest or {}
			for k, v in pairs(orig) do
				copy[k] = v
			end
		else -- number, string, boolean, etc
			copy = orig
		end
		return copy
	end
end

if IS_DST then
	module.COMPONENT_ACTIONS = module.getupvalue(_G.EntityScript.IsActionValid, "COMPONENT_ACTIONS")
	module.IsValidScytheTarget = module.getupvalue(module.COMPONENT_ACTIONS.ISVALID.pickable, "IsValidScytheTarget")

	module.MOD_COMPONENT_ACTIONS = module.getupvalue(_G.AddComponentAction, "MOD_COMPONENT_ACTIONS")
	module.MOD_ACTION_COMPONENT_NAMES = module.getupvalue(_G.AddComponentAction, "MOD_ACTION_COMPONENT_NAMES")
	module.MOD_ACTION_COMPONENT_IDS = module.getupvalue(_G.AddComponentAction, "MOD_ACTION_COMPONENT_IDS")
	module.ACTION_COMPONENT_IDS = module.getupvalue(_G.EntityScript.HasActionComponent, "ACTION_COMPONENT_IDS")

	function HasVanillaActionComponent(inst, name)
		local id = module.ACTION_COMPONENT_IDS[name]
		if id ~= nil then
			for i, v in ipairs(inst.actioncomponents) do
				if v == id then
					return true
				end
			end
		end
		return false
	end
end


module.LoadComponent = assert(module.getupvalue(EntityScript.AddComponent, "LoadComponent"), "Failed to retrieve EntityScript -> LoadComponent")

-- class tweaking should be done before class gets instantiated
-- tweaks do not retroactively apply to previous instances
module.classTweaker = {
	__index = module.getupvalue(Class, "__index"),
	__newindex = module.getupvalue(Class, "__newindex"),
	tracked = {},
}

module.classTweaker.DestroyAllTrackedInstances = function()
	if true then return end
	for filename, insts in pairs(module.classTweaker.tracked) do
		for j, inst in pairs(insts) do
			inst:Kill()
		end
		module.classTweaker.tracked[filename] = {}
	end
end

module.classTweaker.TrackClassInstances = function(class)
	if true then return end
	--[[
		../mods/workshop-2189004162/scripts/screens/insightconfigurationscreen.lua	
		 ..\mods\workshop-2189004162\scripts\screens\insightconfigurationscreen.lua	
	]]
	--local dataroot = "@"..CWD.."\\"
	local dbg = debug.getinfo(class._ctor, "S")
	
	local filename = dbg.source:match("([%w_]+)%.lua$")
	module.classTweaker.tracked[filename] = module.classTweaker.tracked[filename] or {}

	local mt = getmetatable(class)
	local old = mt.__call
	mt.__call = function(...)
		local res = old(...)
		table.insert(module.classTweaker.tracked[filename], res)
		return res
	end
end

module.classTweaker.GetClassProps = function(class)
	-- could be nil in a good way (class isn't setup for them) or a bad way (unable to find props upvalue)
	return util.getupvalue(getmetatable(class).__call, "props")
end

module.classTweaker.SetupClassForProps = function(class)
	if class.__newindex == nil then
		-- TODO: This has issues with classes that inherit from another.
		local props = {}
		util.replaceupvalue(getmetatable(class).__call, "props", props)
		class.__index = module.classTweaker.__index
		class.__newindex = module.classTweaker.__newindex
		return props
	else
		dprint("Class is already setup for props.")
		return module.classTweaker.GetClassProps(class)
	end
end

-- end
return module