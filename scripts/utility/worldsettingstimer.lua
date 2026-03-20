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

-- ok, zark. it's 4 AM. i'm about to release my attack range indicators, then i notice that childspawner's time is wrong. everything's wrong.
-- as the experienced ones have told me, always blame you
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
if not IS_DST then
	return {}
end

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim

local worldsettingstimer = require("components/worldsettingstimer")
local worldsettingsutil  = require("worldsettingsutil")

local stuff = {}

--| ChildSpawner |--
stuff.CHILDSPAWNER_SPAWNPERIOD_TIMERNAME = util.getupvalue(WorldSettings_ChildSpawner_PreLoad, "CHILDSPAWNER_SPAWNPERIOD_TIMERNAME") or false
stuff.CHILDSPAWNER_REGENPERIOD_TIMERNAME = util.getupvalue(WorldSettings_ChildSpawner_PreLoad, "CHILDSPAWNER_REGENPERIOD_TIMERNAME") or false

--| Spawner |--
stuff.SPAWNER_STARTDELAY_TIMERNAME = util.getupvalue(WorldSettings_Spawner_PreLoad, "SPAWNER_STARTDELAY_TIMERNAME") or false

--| Pickable |--
stuff.PICKABLE_REGENTIME_TIMERNAME = util.getupvalue(WorldSettings_Pickable_PreLoad, "PICKABLE_REGENTIME_TIMERNAME") or false

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

for name, upv in pairs(stuff) do
	assert(upv ~= false, string.format("[Insight]: Unable to fetch '%s'.", name))
end


return stuff