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

-- This file is responsible for dealing with controls.
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local lib = {}

local CONTROLS_REVERSE = {}
local control_cache = {}

--[[
local c = 0;
local ignore = {"CONTROL_CUSTOM_START"};
for i,v in pairs(getfenv(0)) do 
	if i:sub(1, #("CONTROL_")) == "CONTROL_" then 
		TheGlobalInstance:DoTaskInTime(c*0.5, function() 
			print(i, v);
			if table.contains(ignore, i) then 
				print("\tignoring this garbage");
			else
				print("\t", TheInput:GetLocalizedControl(TheInput:GetControllerID(), v, true))
			end
		end);
		c=c+1
	end;
end;

print("dingy:", c)
]]

--[[
local KNOWN_CONTROLS = {
	MK = {

	},
	CONTROLLER = {
		SCROLLBACK = (IS_DST and CONTROL_SCROLLBACK) or CONTROL_INVENTORY_UP, -- SCROLLBACK doesn't have anything selected for controllers. DS Alt: CONTROL_INVENTORY_UP
		SCROLLFWD = (IS_DST and CONTROL_SCROLLFWD) or CONTROL_INVENTORY_DOWN, -- SCROLLBACK doesn't have anything selected for controllers. DS Alt: CONTROL_INVENTORY_DOWN
	},
	--LEFT_ANALOG_CLICK = (IS_DST and CONTROL_MENU_MISC_3) or nil, -- 70 | nil
	--RIGHT_ANALOG_CLICK = (IS_DST and CONTROL_MENU_MISC_4) or CONTROL_OPEN_DEBUG_MENU, -- 71 | 62
	
}
--]]

local control_groups = {}
local control_schemes = {}

--[[
setmetatable(KNOWN_CONTROLS, {
	__index = function(self, index)
		errorf("Attempt to retrieve KNOWN_CONTROL '%s', which does not exist right now.", index)
	end
})
--]]

-- print(TheInput:GetLocalizedControl(TheInput:GetControllerID(), CONTROL_OPEN_DEBUG_MENU))

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local function OnControlMapped(deviceId, controlId, inputId, hasChanged)
	print("CTRL CHANGE:", deviceId, controlId, inputId, hasChanged) -- does this ever actually happen?
end

local function OnControl() end

local function ControlGroup_IsAcceptedControl(self, control)
	for i = 1, #self.controls do
		local v = self.controls[i]
		if control == v then
			return true
		end
	end
end

local function ControlGroup_IsAnyControlPressed(self)
	--[[
	for i,v in pairs(self.controls) do
		if TheInput:IsControlPressed(v) then
			return true, v
		end
	end
	--]]
	for i = 1, #self.controls do
		local v = self.controls[i]
		if TheInput:IsControlPressed(v) then
			return true, v
		end
	end
end

local function ControlGroup_ToString(self)
	local str = self.name .. ": {"
 	str = str .. table.concat(self.controls, ", ")
	str = str .. "}"
	
	return str
end

local function Scheme_IsAcceptedControl(self, control_group_name, control)
	local group = self.control_groups[control_group_name]
	if not group then
		return errorf("Unable to find control group '%s' in scheme '%s'", control_group_name, self.name)
	end
	return group:IsAcceptedControl(control)
end

--------------------------------------------------------------------------
--[[ Exported Functions ]]
--------------------------------------------------------------------------
function lib.Prettify(control)
	return "[" .. (CONTROLS_REVERSE[control] or "<UNKNOWN>") .. " - " .. control .. "]"
end

--- Makes a control group. 
function lib.MakeControlGroup(name, controls)
	name = name:lower()
	if control_groups[name] then
		return errorf("Control group '%s' already exists as (%s)", name, tostring(control_groups[name]))
		--return control_groups[name]
	end

	--mprint("\tmaking control group", name)
	--dumptable(controls)
	local group = {
		name = name,
		controls = controls,
	}

	group.IsAcceptedControl = ControlGroup_IsAcceptedControl
	group.IsAnyControlPressed = ControlGroup_IsAnyControlPressed

	setmetatable(group, {
		__index = group.controls,
		__tostring = ControlGroup_ToString
	})

	control_groups[name] = group
	return group
end

--- Makes a control scheme.
function lib.MakeScheme(name, data)
	name = name:lower()
	
	if control_schemes[name] then
		return control_schemes[name]
	end

	if not (name == "mouse_keyboard" or name == "controller") then
		error("invalid controller scheme")
	end

	local scheme = {
		name = name,
		control_groups = {},
	}

	--mprint("making scheme", name)
	for groupname, ctrls in pairs(data) do
		groupname = groupname:lower()
		local group = lib.MakeControlGroup(name .. "_" .. groupname, ctrls)
		scheme.control_groups[groupname] = group
	end

	scheme.IsAcceptedControl=Scheme_IsAcceptedControl

	setmetatable(scheme, {
		__index = scheme.control_groups
	})

	control_schemes[name] = scheme
	return scheme
end

function lib.GetCurrentScheme()
	if TheInput:ControllerAttached() then
		return control_schemes.controller
	else
		return control_schemes.mouse_keyboard
	end
end

--[[
function lib.GetScheme(name)
	return control_schemes[name]
end
--]]


--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
require("constants")
for i,v in pairs(getfenv(0)) do
	if i:sub(1, #("CONTROL_")) == "CONTROL_" and type(v) == "number" then
		CONTROLS_REVERSE[v] = i
	end
end
--[[
-- Probably will need these, but whatever for now.
CONTROLS_REVERSE[1] = MOVE_UP
CONTROLS_REVERSE[2] = MOVE_DOWN
CONTROLS_REVERSE[3] = MOVE_LEFT
CONTROLS_REVERSE[4] = MOVE_RIGHT
--]]

--TheInput:OnControlMapped(OnControlMapped)
--TheInput:AddControlHandler(OnControl)

--[[
local public = {
	KNOWN_CONTROLS = KNOWN_CONTROLS,
	CONTROLS_REVERSE = CONTROLS_REVERSE,
}
--]]

-- I try to add controls in terms of best to least. The first control is the prioritized one for tips and stuff.
if IS_DST then
	-- CONTROL_PAGELEFT and CONTROL_PAGERIGHT are gone in DST
	lib.mk_scheme = lib.MakeScheme("mouse_keyboard", {
		exit = {CONTROL_PAUSE},
		--open_insight_menu

		scroll_up = {CONTROL_SCROLLBACK},
		scroll_down = {CONTROL_SCROLLFWD},
		previous_value = {CONTROL_FOCUS_LEFT}, -- CONTROL_MOVE_LEFT?
		next_value = {CONTROL_FOCUS_RIGHT}, -- CONTROL_MOVE_RIGHT?

		page_up = {},
		page_down = {},
	})

	lib.controller_scheme = lib.MakeScheme("controller", {
		exit = {CONTROL_OPEN_CRAFTING, CONTROL_CANCEL},
		open_insight_menu = {CONTROL_OPEN_CRAFTING},

		scroll_up = {CONTROL_INVENTORY_UP},
		scroll_down = {CONTROL_INVENTORY_DOWN},
		previous_value = {CONTROL_PREVVALUE, CONTROL_FOCUS_LEFT},
		next_value = {CONTROL_NEXTVALUE, CONTROL_FOCUS_RIGHT},

		page_up = {},
		page_down = {},
	})
else
	lib.mk_scheme = lib.MakeScheme("mouse_keyboard", {
		exit = {CONTROL_PAUSE},
		--open_insight_menu

		scroll_up = {CONTROL_SCROLLBACK}, -- CONTROL_FOCUS_UP
		scroll_down = {CONTROL_SCROLLFWD}, -- CONTROL_FOCUS_DOWN
		previous_value = {CONTROL_FOCUS_LEFT}, -- CONTROL_MOVE_LEFT?
		next_value = {CONTROL_FOCUS_RIGHT}, -- CONTROL_MOVE_RIGHT?
		
		page_up = {CONTROL_PAGELEFT},
		page_down = {CONTROL_PAGERIGHT},
	})
	lib.controller_scheme = lib.MakeScheme("controller", {
		exit = {CONTROL_OPEN_DEBUG_MENU, CONTROL_CANCEL}, -- CONTROL_PAUSE?
		open_insight_menu = {CONTROL_OPEN_DEBUG_MENU},

		scroll_up = {CONTROL_PAGELEFT, CONTROL_INVENTORY_UP}, -- CONTROL_MOVE_UP?
		scroll_down = {CONTROL_PAGERIGHT, CONTROL_INVENTORY_DOWN}, -- CONTROL_MOVE_DOWN?
		previous_value = {CONTROL_PREVVALUE, CONTROL_FOCUS_LEFT}, -- CONTROL_MOVE_LEFT?
		next_value = {CONTROL_NEXTVALUE, CONTROL_FOCUS_RIGHT}, -- CONTROL_MOVE_RIGHT?

		page_up = {},
		page_down = {},
	})
end

return lib