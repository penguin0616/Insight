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

local module = {}

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

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--[[ Module Functions ]]
--------------------------------------------------------------------------


--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
module.DAMAGE_TYPE_DEFS = DAMAGE_TYPE_DEFS
module.DAMAGE_TYPE_COLORS = setmetatable({}, {
	__index = function(self, index)
		return DAMAGE_TYPE_DEFS[index] and DAMAGE_TYPE_DEFS[index].text_color or nil
	end
})
module.DAMAGE_PRIORITY = 100000

return module