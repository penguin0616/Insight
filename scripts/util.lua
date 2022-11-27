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

--[[
if IS_DS and not UICOLOURS then
	UICOLORS = {
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
--]]


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
		if chunk:IsObject() then
			if chunk.object.class == "prefab" then
				local prefab = chunk.object.value
				str = str .. GetPrefabNameOrElse(prefab, "[prefab \"%s\"]")
			end
		else
			str = str .. chunk.text
		end
	end

	return str
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
	local res = (inst.components and inst.components.unwrappable) or (inst.HasActionComponent and inst:HasActionComponent("unwrappable"))
	
	if res then
		known_bundles[inst] = true
	else
		if inst.HasTag and inst:HasTag("unwrappable") then
			if not inst.prefab:sub(1, #("quagmire_seedpacket")) == "quagmire_seedpacket" then
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

function ApplyColour(str, clr)
	if clr.ToHex ~= nil then
		clr = clr.hex or clr:ToHex()
	end
	
	return string.format("<color=%s>%s</color>", clr, str)
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

function DEBUG_IMAGE(bool) 
	if bool then
		return "images/White_Square.xml", "White_Square.tex"
	end

	return nil, nil
end

-- functions i took out of modmain for organization reasons

--- Checks if number is an integer.
-- @number num
-- @treturn boolean
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
		return string.format(other or "ERROR: %s</color>", ApplyColour(tostring(nil), "#ff0000"))
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

	-- antler?
	if string.sub(upper, 1, 11) == "DEER_ANTLER" then
		return STRINGS.NAMES.DEER_ANTLER
	end
	
	-- ornament?
	local ornament_type = string.match(upper, "WINTER_ORNAMENT_(%a+)")
	if ornament_type then
		ornament_type = ((ornament_type == "FANCY" or ornament_type=="PLAIN") and "") or ornament_type
		if ornament_type == "FESTIVALEVENTS" then
			if tonumber(upper:sub(-1)) <= 3 then
				ornament_type = "FORGE"
			else
				ornament_type = "GORGE"
			end
		end
		
		local name = STRINGS.NAMES["WINTER_ORNAMENT" .. ornament_type]
		if name then
			return name
		end
	end

	--[[
		table.insert(ornament, MakeOrnament("festivalevents1", "winter_ornamentforge", nil, "winter_ornaments2018", 0.95))
table.insert(ornament, MakeOrnament("festivalevents2", "winter_ornamentforge", nil, "winter_ornaments2018", 0.95))
table.insert(ornament, MakeOrnament("festivalevents3", "winter_ornamentforge", nil, "winter_ornaments2018", 1.00))
table.insert(ornament, MakeOrnament("festivalevents4", "winter_ornamentgorge", nil, "winter_ornaments2018", 0.80))
table.insert(ornament, MakeOrnament("festivalevents5", "winter_ornamentgorge", nil, "winter_ornaments2018", 0.80))
	]]

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
-- @tparam number num
-- @treturn string
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

-- didn't know rounding was this easy, thanks star/serp
--- Rounds float.
-- @tparam Number num
-- @tparam Integer places How many decimal places to round to.
-- @treturn number
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
-- @tparam string str The text you want to measure.
-- @tparam Font font
-- @tparam integer sz Size
-- @treturn number, number
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
-- @treturn string
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

--- Clamps a math value.
-- @number num (required) The number to clamp.
-- @tparam ?number|nil min (optional) The minimum value.
-- @tparam ?number|nil max (optional) The minimum value.
-- @treturn number
function module.math_clamp(num, min, max)
	-- previous code was a disgrace
	return (num < min and min) or (num > max and max) or num
end

--- Returns the first result of the table that agrees with param 'fn'
-- @tparam table tbl The string.
-- @tparam function fn Returns the first value in a table
-- @return anything
function module.table_find(tbl, fn)
	local typ = type(fn)

	assert(typ, "bad argument #2 to table_find (function expected, got " .. typ .. ")")
	
	for i,v in pairs(tbl) do
		if v == fn or (typ == 'function' and fn(v)) then
			return v
		end
	end
end

--- Parses a string into a bool, if possible.
-- @string b The string.
-- @treturn ?boolean|string Returns the boolean if it succeeded, the string you passed in otherwise.
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
-- @string str The string.
-- @string chunk What the ending should be.
-- @treturn boolean
function module.string_endsWith(str, chunk)
	return str:sub(#str - #chunk) == chunk
end

--- Checks if a string begins with the provided input.
-- @string str The string.
-- @string chunk What the beginning should be.
-- @treturn boolean
function module.string_startsWith(str, chunk)
	return str:sub(1, #chunk) == chunk
end

--- Retrives value from a table and removes the key.
-- @tparam table tbl
-- @tparam ?int|string index
-- @return
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
-- @tparam function func
-- @treturn table
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
-- @tparam function func
-- @string name
-- @return
--[[
function module.getupvalue(func, name)
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then break end
		if n == name then return v end
		i = i + 1
	end
end
--]]
function module.getupvalue(func, ...)
	if func == nil then
		return error("util.getupvalue got nil for func")
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
-- @tparam integer level
-- @string name
-- @return
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

--- Retrives and replaces the first upvalue that matches the arguments.
-- @tparam function func
-- @string name
-- @param replacement
-- @return
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

--[[
module.MOD_COMPONENT_ACTIONS = module.getupvalue(AddComponentAction, "MOD_COMPONENT_ACTIONS")
module.MOD_ACTION_COMPONENT_NAMES = module.getupvalue(AddComponentAction, "MOD_ACTION_COMPONENT_NAMES")
module.MOD_ACTION_COMPONENT_IDS = module.getupvalue(AddComponentAction, "MOD_ACTION_COMPONENT_IDS")

function HasVanillaActionComponent(inst, name)
	local id = module.ACTION_COMPONENT_IDS[name]
    if id ~= nil then
        for i, v in ipairs(inst.actioncomponents) do
            if v == id then
                return true
            end
        end
    end
end
--]]

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