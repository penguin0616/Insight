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
-- Something
-- @module modworldgenmain
-- @author penguin0616

do
	-- ds/scripts/strict.lua is why _G stuff keeps being rude
	-- get that sweet sweet local optimization
	local GLOBAL = GLOBAL
	local modEnv = GLOBAL.getfenv(1)
	local rawget, setmetatable = GLOBAL.rawget, GLOBAL.setmetatable
	setmetatable(modEnv, {
		__index = function(self, index)
			return rawget(GLOBAL, index)
		end
	})

	_G = GLOBAL
end

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal,collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo,pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui,ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim

function mprint(...)
	local msg, argnum = "", select("#", ...)
	for i = 1, argnum do
		local v = select(i, ...)
		msg = msg .. tostring(v) .. ((i < argnum) and "\t" or "")
	end

	local prefix = ""

	if false then
		local d = debug.getinfo(2, "Sl")
		prefix = string.format("%s:%s:", d.source or "?", d.currentline or 0)
	end

	return print(prefix .. "[" .. ModInfoname(modname) .. "]:", msg)
end

function mprintf(...)
	return mprint(string.format(...))
end

--mprint("heyo!", modinfo, modinfo and modinfo.configuration_options)
--table.foreach(ShardGameIndex, mprint)
--[[
table.foreach(ShardGameIndex, mprint)
[00:59:41]: [workshop-2189004162 (Insight)]:	heyo!	
[00:59:41]: [workshop-2189004162 (Insight)]:	enabled_mods	table: 000000012F5F1CD0	
[00:59:41]: [workshop-2189004162 (Insight)]:	version	4	
[00:59:41]: [workshop-2189004162 (Insight)]:	invalid	true	
[00:59:41]: [workshop-2189004162 (Insight)]:	server	table: 000000012F5F11E0	
[00:59:41]: [workshop-2189004162 (Insight)]:	ismaster	false	
[00:59:41]: [workshop-2189004162 (Insight)]:	world	table: 000000012F5F2450	
]]
--table.foreach(ShardSaveGameIndex.slot_cache[9].Master, mprint)
--[[
table.foreach(ShardSaveGameIndex.slot_cache[9].Master, mprint)
[00:59:41]: [workshop-2189004162 (Insight)]:	valid	true	
[00:59:41]: [workshop-2189004162 (Insight)]:	slot	9	
[00:59:41]: [workshop-2189004162 (Insight)]:	session_id	05A029DA4E66F666	
[00:59:41]: [workshop-2189004162 (Insight)]:	ismaster	true	
[00:59:41]: [workshop-2189004162 (Insight)]:	version	4	
[00:59:41]: [workshop-2189004162 (Insight)]:	server	table: 000000004AA23140	
[00:59:41]: [workshop-2189004162 (Insight)]:	isdirty	false	
[00:59:41]: [workshop-2189004162 (Insight)]:	shard	Master	
[00:59:41]: [workshop-2189004162 (Insight)]:	enabled_mods	table: 000000004AA22420	
[00:59:41]: [workshop-2189004162 (Insight)]:	world	table: 000000004AA22560	
]]

-- Pretty much any code with this isn't exactly coded for performance.
function isConfigValid(configName, savedValue)
	local configurationOptions = modinfo.configuration_options

	for _, cfg in pairs(configurationOptions) do
		if cfg.name == configName then
			for i, v in pairs(cfg.options) do
				if v.data == savedValue then
					return true
				end
			end

			return false, cfg.default
		end
	end

	return nil
end

function CheckShardSaveGameIndex()
	mprint("Checking server slots for invalid config saves.")
	for slot, shards in pairs(ShardSaveGameIndex.slot_cache) do
		for shardName, shardIndex in pairs(shards) do
			if shardIndex.enabled_mods[modname] then
				mprintf("\tLooks like slot '%s' shard '%s' has had Insight used on it.", slot, shardName)
				if shardIndex:IsValid() then
					CheckShardIndex(shardIndex)
				else
					mprint("\t\tSeems like it's not a valid shardindex though...?")
				end
			end
		end
	end
end

function CheckShardIndex(shardIndex)
	local issueFound = false

	-- So something to note about this is that when an invalid option is saved, it'll appear as whatever the default should be despite it not actually being the default.
	local savedInsightOptions = shardIndex.enabled_mods[modname].configuration_options
	for name, saved in pairs(savedInsightOptions) do
		local valid, defaultValue = isConfigValid(name, saved)
		if valid == nil then
			issueFound = true
			mprintf("\t\tThe option '%s' no longer exists. Deleting key.", name)
			savedInsightOptions[name] = nil

		elseif valid == false then
			issueFound = true
			mprintf("\t\tThe option '%s' has an invalid config saved '%s'! Resetting option to default '%s'.", name,
				tostring(saved), tostring(defaultValue))
			savedInsightOptions[name] = defaultValue
		else
			-- All good! :)
		end
	end

	if issueFound then
		mprint("\t\tUpdating ShardIndex...")
		shardIndex:MarkDirty()
		shardIndex:Save(function(result, msg)
			if result == true then
				mprint("\t\t\tSave was successful.")
			elseif result == false then
				mprintf("\t\t\tSave was not successful, msg: %s", tostring(msg))
			else
				mprint("\t\t\tSave was not attempted?")
			end
		end)
		--table.foreach(shardIndex, print)
	else
		mprint("\t\tNo issues found!")
	end
end


function CheckModOverrides(shardGameIndex)
	mprint("\tAttempting to validate modoverrides.lua")
	local modoverrides = KnownModIndex:LoadModOverides(shardGameIndex)
	if not modoverrides[modname] then
		mprint("\t\tUnable to find ourselves in the modoverrides.")
		return
	end

	local issueFound = false

	local savedInsightOptions = modoverrides[modname].configuration_options
	for name, saved in pairs(savedInsightOptions) do
		local valid, defaultValue = isConfigValid(name, saved)
		if valid == nil then
			issueFound = true
			mprintf("\t\t!!!!!!!!!!!The option '%s' no longer exists. Deleting key.", name)
			savedInsightOptions[name] = nil

		elseif valid == false then
			issueFound = true
			mprintf("\t\t!!!!!!!!!!!The option '%s' has an invalid config saved '%s'! Resetting option to default '%s'.", name,tostring(saved), tostring(defaultValue))
			savedInsightOptions[name] = defaultValue
		else
			-- All good! :)
		end
	end

	if issueFound then
		local function OnSave(result, msg)
			if result == true then
				mprint("\t\t\tSave was successful.")
			elseif result == false then
				mprintf("\t\t\tSave was not successful, msg: %s", tostring(msg))
			end
		end

		mprint("\t\tUpdating modoverrides...")
		local filename = "../modoverrides.lua"
		local toSave = DataDumper(modoverrides, nil, false)
		if not TheNet:IsDedicated() and shardGameIndex:IsValid() and not shardGameIndex:GetServerData().use_legacy_session_path then
			TheSim:SetPersistentStringInClusterSlot(shardGameIndex:GetSlot(), "Master", filename, toSave, false, OnSave)
		else
			TheSim:SetPersistentString(filename, toSave, OnSave)
		end
	else
		mprint("\tNo issues found!")
	end

	--[[
	for i,v in pairs(KnownModIndex:GetModConfigurationOptions_Internal(modname, true)) do
		local valid, defaultValue = isConfigValid(v.name, v.saved)
	end
	--]]


	--[[
	for _modname, env in pairs(modoverrides) do
		local actual_modname = ResolveModname(_modname)
		if modname == actual_modname and env.configuration_options ~= nil then
			local config_options = 

		end
	--]]

end

if ShardSaveGameIndex then
	mprint("Looks like we're viewing the game server from a client's Host Game.")
	CheckShardSaveGameIndex()
else
	mprint("Looks like we're in the actual launch process.")
	if not ShardIndex then
		return mprint("\t!!!!!!!!!!!!!!!! SHARDINDEX IS MISSING GLOBALLY")
	end
	shardGameIndex = ShardIndex()
	--[[
	if not shardGameIndex then
		--Don't Starve Alone (workshop-2657513551)
	end
	--]]

	if KnownModIndex:IsModEnabled("workshop-2657513551") then
		-- Don't Starve Alone has a crash when calling :Load() at this point.
		--[[
		[00:02:26]: [string "../mods/workshop-2657513551/modmain/save.lu..."]:214: attempt to index global 'ShardSaveGameIndex' (a nil value)
		LUA ERROR stack traceback:
        ../mods/workshop-2657513551/modmain/save.lua(214,1) in function 'Load'
        ../mods/workshop-2189004162/modworldgenmain.lua(243,1) in main chunk
        =[C] in function 'xpcall'
        scripts/util.lua(781,1) in function 'RunInEnvironment'
        scripts/mods.lua(569,1) in function 'InitializeModMain'
        scripts/mods.lua(539,1) in function 'LoadMods'
        scripts/main.lua(364,1) in function 'ModSafeStartup'
        scripts/main.lua(485,1)
        =[C] in function 'SetPersistentString'
        scripts/mainfunctions.lua(29,1) in function 'SavePersistentString'
        scripts/modindex.lua(119,1)
        =[C] in function 'GetPersistentString'
        scripts/modindex.lua(106,1) in function 'BeginStartupSequence'
        scripts/main.lua(484,1) in function 'callback'
        scripts/modindex.lua(735,1)
        =[C] in function 'GetPersistentString'
        scripts/modindex.lua(709,1) in function 'Load'
        scripts/main.lua(483,1) in main chunk
		]]
		mprint("!!!!!!!!!!!!!!!!!! Don't Starve Alone is enabled, so not doing corrective configuration.")
		return
	end

	shardGameIndex:Load()
	if shardGameIndex:IsValid() then
		mprint("Checking shardindex.")
		--dumptable(shardGameIndex.enabled_mods)
		if false or shardGameIndex.enabled_mods[modname] then
			CheckShardIndex(shardGameIndex)
		else
			mprint("\tInsight hasn't been enabled on this save?")
		end
	else
		mprint("ShardIndex is invalid?")
	end

	CheckModOverrides(shardGameIndex)
end




-- modindex
--[[
		return {
			disable_special_event_warning=false,
			known_api_version=10,
			known_mods={
				sneaky={
					enabled=false,
					temp_enabled=false,
					temp_disabled=false,
					seen_api_version=10
				},
			}
		}	
	]]

--[[
	1. KnownModIndex:BeginStartupSequence(ModSafeStartup)
	2. ModSafeStartup calls ModManager:LoadMods()
	-- yadda yadda
	• KnownModIndex:LoadModOverides() gets called
	• mods get enabled
	• configs loaded with KnownModIndex:LoadModConfigurationOptions
	• configs get overwritten by ModIndex:ApplyConfigOptionOverrides
]]

--[[
from viewing the server in host game:
	[00:41:27]: enabled_mods	table: 00000000617B04F0	
[00:41:27]: version	4	
[00:41:27]: invalid	true	
[00:41:27]: server	table: 00000000617B14E0	
[00:41:27]: ismaster	false	
[00:41:27]: world	table: 00000000617B1440	

from the master when you press resume world:
[00:00:01]: valid	true	
[00:00:01]: slot	0	
[00:00:01]: session_id	05A029DA4E66F666	
[00:00:01]: version	4	
[00:00:01]: server	table: 000000000DEFCA60	
[00:00:01]: isdirty	false	
[00:00:01]: ismaster	false	
[00:00:01]: enabled_mods	table: 000000000DEFBF20	
[00:00:01]: world	table: 000000000DEFCBA0	

from a standalone dedi:
[00:00:01]: valid	true	
[00:00:01]: slot	0	
[00:00:01]: session_id	00A843D4FE9A865C	
[00:00:01]: version	4	
[00:00:01]: server	table: 0B1364A8	
[00:00:01]: isdirty	false	
[00:00:01]: ismaster	false	
[00:00:01]: enabled_mods	table: 0B136390	
[00:00:01]: world	table: 0B1365E8	
]]

