local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local STRINGS = STRINGS

if not UICOLOURS then
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

if not shallowcopy then
	-- http://lua-users.org/wiki/CopyTable
	function _G.shallowcopy(orig, dest)
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