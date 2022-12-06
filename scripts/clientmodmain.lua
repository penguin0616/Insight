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
-- Main Insight client logic is handled here.
-- @module clientmodmain
-- @author penguin0616

local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim

--==========================================================================================================================
--==========================================================================================================================
--======================================== Variables =======================================================================
--==========================================================================================================================
--==========================================================================================================================
insightSaveData = import("helpers/savedata")("mod_config_data/Insight_SaveData_CLIENT");
controlHelper = import("helpers/control")
localPlayer = nil
currentlySelectedItem = nil
shard_players = {}
highlighting = import("highlighting")
local onLocalPlayerReady = setmetatable({}, { __newindex = function(self, index, value) 
	assert(type(value.fn)=="function", "onLocalPlayerReady invalid value"); 
	if localPlayer then value.fn(GetInsight(localPlayer), GetPlayerContext(localPlayer)) end;
	if value.persists or not localPlayer then rawset(self, index, value) end; 
end; })
local onLocalPlayerRemove = setmetatable({}, { __newindex = function(self, index, value) 
	assert(type(value.fn)=="function", "onLocalPlayerRemove invalid value"); 
	rawset(self, index, value) 
end; })
local delayed_actives = {}
insight_subscribed = IS_DS or KnownModIndex.savedata.known_mods["workshop-2189004162"].enabled ~= nil
-- game has to be exited and reopened for the savedata to update i guess
-- the difference between unsubbed and subbed is that subbed has "enabled" and "temp_disabled" fields
-- if subscribed and the world is just forest, nonhosts have enabled=false but temp_enabled = true

--==========================================================================================================================
--==========================================================================================================================
--======================================== Functions =======================================================================
--==========================================================================================================================
--==========================================================================================================================

function AddLocalPlayerPostInit(fn, persists)
	-- table.insert uses rawset internally
	onLocalPlayerReady[#onLocalPlayerReady+1] = {fn = fn, persists = persists or false}
end

function AddLocalPlayerPostRemove(fn, persists)
	-- table.insert uses rawset internally
	onLocalPlayerRemove[#onLocalPlayerRemove+1] = {fn = fn, persists = persists or false}
end



local function GetMorgueDeathsForWorld(name)
	local deaths = {}

	for i,v in pairs(Morgue:GetRows()) do
		if v.server == name then
			table.insert(deaths, deepcopy(v))
		end
	end

	return deaths
end

local function GenerateExternalConfiguration()
	local external_config = {}

	local important_ds = {
		["workshop-574636989"] = { -- Combined status: https://steamcommunity.com/sharedfiles/filedetails/?id=574636989
			name = "combined_status",
			fetch = {"SHOWNAUGHTINESS", "SHOWWORLDTEMP"},
		}
	}

	local important_dst = { -- https://steamcommunity.com/sharedfiles/filedetails/?id=376333686
		["workshop-376333686"] = {
			name = "combined_status",
			fetch = {"SHOWNAUGHTINESS", "SHOWWORLDTEMP"},
		}
	}

	local winner = IS_DST and important_dst or important_ds
	for modname, data in pairs(winner) do
		if not external_config[data.name] then
			external_config[data.name] = {}
		end
		if KnownModIndex:IsModEnabled(modname) then
			for _, config_name in pairs(data.fetch) do	
				external_config[data.name][config_name] = _G.GetModConfigData(config_name, modname, true)
			end
		end
	end

	return external_config
end

local function GenerateConfiguration()
	--[[
	mprint("TheNet:GetIsClient() ==", TheNet:GetIsClient())
	mprint("TheNet:GetIsServer() ==", TheNet:GetIsServer())
	mprint("TheNet:IsDedicated() ==", TheNet:IsDedicated())

	mprint("Server:", GetModConfigData("crash_reporter", false))
	mprint("Client:", GetModConfigData("crash_reporter", true))

	t=KnownModIndex:LoadModConfigurationOptions(modname, false)[42]; print(t.name, t.saved);
	--]]



	--local fat = KnownModIndex:LoadModConfigurationOptions(modname, false)

	--util.table_find(fat, function(v) return v.name == "crash_reporter")

	--local mod_info = KnownModIndex:InitializeModInfo(modname)

	

	mprint("CALLED FOR CONFIG GEN")
	local config_data = deepcopy(KnownModIndex:LoadModConfigurationOptions(modname, true))

	if not config_data then
		error("[insight]: unable to fetch config")
		return
	end

	local local_config = {}

	if IS_DS then
		mprint("DS config generation")
		for i,v in pairs(config_data) do
			if not util.table_find(v.tags, "ignore") then 
				local_config[v.name] = GetModConfigData(v.name)
			end
		end
		return local_config
	end
	
	-- should be on server but eh.
	for i,v in pairs(config_data) do
		if not util.table_find(v.tags, "ignore") then
			local server_choice = GetModConfigData(v.name, false)
			local client_choice = GetModConfigData(v.name, true)
			
			local winner = server_choice
			
			if client_choice == "undefined" then
				client_choice = v.original_default
				--client_choice = GetDefaultSetting(v).data -- use the real default
			end

			if v.client then
				--print(v.name, insight_subscribed, (util.table_find(v.tags, "undefined") and server_choice == "undefined"))
				if insight_subscribed or (util.table_find(v.tags, "undefined") and server_choice == "undefined") then
					winner = client_choice
				else
					winner = server_choice
				end

			elseif util.table_find(v.tags, "undefined") and server_choice == "undefined" then
				winner = client_choice

			elseif util.table_find(v.tags, "independent") then
				if TheNet:GetIsClient() then
					winner = client_choice
				else -- clienthost is TheNet:GetIsServer() == true
					winner = server_choice
				end
			end

			local_config[v.name] = winner
			v.selected = client_choice
		end
	end
	
	return local_config
end

local function IsPlayerClientLoaded(player)
	return (player and player.HUD and GetInsight(player) and GetPlayerContext(player) and true) or false
end

function OnCurrentlySelectedItemChanged(old, new, itemInfo)
	if old and old.insight_hover_range then
		old.insight_hover_range:Remove()
		old.insight_hover_range = nil
	end

	if old and old.insight_combat_range_indicator and old.insight_combat_range_indicator.state_forced then
		old.insight_combat_range_indicator:ForceStateChange(combatHelper.NET_STATES.NOTHING)
	end

	if not new then
		return
	end

	local context = GetPlayerContext(localPlayer)
	if not context then
		return
	end

	if context.config["display_attack_range"] and itemInfo.special_data.combat then
		local ind = new.insight_combat_range_indicator
		if not ind or not ind.client_ready then -- DS: spawning a beehive with an immediate hover could sometimes error because the client combat side hadn't loaded yet but the server had
			return
		end

		if ind.is_visible then
			return	
		end

		ind:ForceStateChange(combatHelper.NET_STATES.TARGETTING)
		return
	end

	-- should i handle weapon range?
	if not itemInfo.special_data.insight_ranged then
		return
	end

	local range = itemInfo.special_data.insight_ranged.range-- or (itemInfo.special_data.soul and itemInfo.special_data.soul.soul_heal_range)
	local color = itemInfo.special_data.insight_ranged.color-- or (itemInfo.special_data.soul and itemInfo.special_data.soul.soul_heal_range_color)

	if range then
		new.insight_hover_range = SpawnPrefab("insight_range_indicator")
		if itemInfo.special_data.insight_ranged.attach_player == false then
			if new:HasTag("INLIMBO") then
				--print'moved to player'
				new.insight_hover_range:Attach(localPlayer)
			else
				--print'moved to self'
				new.insight_hover_range:Attach(new)
			end
		else
			new.insight_hover_range:Attach(localPlayer)
		end
		new.insight_hover_range:SetRadius(range / WALL_STUDS_PER_TILE)
		if color then
			new.insight_hover_range:SetColour(Color.fromHex(color))
		end
		new.insight_hover_range:SetVisible(true)
	end
end

--- Retrives the current selected item, be it from hud or world.
-- @treturn ?Item|nil
function GetMouseTargetItem()
	local target = TheInput:GetHUDEntityUnderMouse()
	-- target.widget.parent is ItemTile
	
	-- game prefers inventory items over world items
	target = (target and target.widget and target.widget:GetParent() ~= nil and target.widget:GetParent().item) or TheInput:GetWorldEntityUnderMouse() or nil

	--mprint('target', target, TheInput:GetWorldEntityUnderMouse())	
	if target and target == localPlayer then
		-- only way for this to happen is if they mouse over the player while an item is in the same spot, or if we are riding something

		-- if someone else is riding something, will select player over mount
		-- todo: turns out it sets secondarystring, so it doesn't trigger an update to get the new mouse target for Insight
		--[[
		local mount = (IS_DS and localPlayer.components.rider:GetMount()) or localPlayer.replica.rider:GetMount()
		mprint("\tmount", mount)
		if mount then
			return mount
		end
		--]]
		
		return nil
	end

	-- some mods (https://steamcommunity.com/sharedfiles/filedetails/?id=2081254154) were setting .item to a non-prefab
	-- 5/2/2020
	if target ~= nil and (not IsPrefab(target) or not target:IsValid()) then
		return nil
	end

	return target
end


local function CanBlink(player)
	local inventory = (IS_DST and player.replica and player.replica.inventory) or (IS_DS and player.components.inventory) or error("CanBlink called on entity missing inventory")

	local holding = inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	local cursor = inventory:GetActiveItem()

	if holding and (holding.components.blinkstaff or (IS_DST and holding:HasActionComponent("blinkstaff"))) then
		return true
	elseif cursor and (cursor.components.blinkstaff or (IS_DST and cursor:HasActionComponent("blinkstaff"))) then
		return true
	end

	return false

	--return (holding and (holding.components.blinkstaff or holding:HasActionComponent("blinkstaff"))) or (cursor and (cursor.components.blinkstaff or cursor:HasActionComponent("blinkstaff"))) or (player:HasTag("soulstealer") and inventory:Has("wortox_soul", 1))
end

local function OnHelperStateChange(inst, active, recipename, placerinst)
	inst.components.dst_deployhelper.helping = active

	if inst.prefab == "lightning_rod" then
		inst.lightningrod_range:SetVisible(active)
	elseif inst.prefab == "firesuppressor" then
		inst.snowball_range:SetVisible(active)
	else
		inst.range_indicator:SetVisible(active)
	end
end

local function AttachWigfridSongRangeIndicator(player)
	if not player:HasTag("battlesinger") then
		return
	end

	player.battlesong_attach_range = SpawnPrefab("insight_range_indicator")
	player.battlesong_attach_range:Attach(player)
	player.battlesong_attach_range:SetRadius(TUNING.BATTLESONG_ATTACH_RADIUS / WALL_STUDS_PER_TILE)
	player.battlesong_attach_range:SetColour(Color.fromHex("#6F3483")) -- default color
	player.battlesong_attach_range:SetVisible(false)

	player.battlesong_detach_range = SpawnPrefab("insight_range_indicator")
	player.battlesong_detach_range:Attach(player)
	player.battlesong_detach_range:SetRadius(TUNING.BATTLESONG_DETACH_RADIUS / WALL_STUDS_PER_TILE)
	player.battlesong_detach_range:SetColour(Color.fromHex("#3c0150"))
	player.battlesong_detach_range:SetVisible(false)

	player:ListenForEvent("insight_battlesong_active_dirty", function(inst)
		local visible = inst.replica.insight.net_battlesong_active:value()
			
		local config = GetModConfigData("battlesong_range", true)
		if config == "attach" then
			player.battlesong_attach_range:SetVisible(visible)
		elseif config == "detach" then
			player.battlesong_detach_range:SetVisible(visible)
		elseif config == "both" then
			player.battlesong_attach_range:SetVisible(visible)
			player.battlesong_detach_range:SetVisible(visible)
		end
	end)
end

local function AttachBlinkRangeIndicator(player)
	player.blink_indicator = SpawnPrefab("insight_range_indicator")
	player.blink_indicator:Attach(player)
	player.blink_indicator:SetRadius(ACTIONS.BLINK.distance / WALL_STUDS_PER_TILE)
	player.blink_indicator:SetColour(Color.fromHex(Insight.COLORS.VEGGIE))
	player:DoTaskInTime(0, function() player.blink_indicator:SetVisible(CanBlink(player)) end)

	-- Inventory:Equip {item=item, eslot=eslot}, Inventory:Unequip {item=item, eslot=equipslot, (server only) slip=slip}
	player:ListenForEvent("equip", function(inst, data)
		--mprint("equip")
		if data.eslot == EQUIPSLOTS.HANDS then
			player.blink_indicator:SetVisible(CanBlink(inst))
		end
	end)

	player:ListenForEvent("unequip", function(inst, data)
		--mprint("unequip")
		if data.eslot == EQUIPSLOTS.HANDS then
			player.blink_indicator:SetVisible(CanBlink(inst))
		end
	end)

	player:ListenForEvent("itemget", function(inst, data)
		--mprint("itemget")
		if data.item.prefab == "wortox_soul" then
			player.blink_indicator:SetVisible(CanBlink(inst))
		end
	end)

	player:ListenForEvent("itemlose", function(inst, data)
		--mprint("itemlose")
		-- {slot = slot}
		player.blink_indicator:SetVisible(CanBlink(inst))
	end)

	player:ListenForEvent("newactiveitem", function(inst, data)
		--mprint("newactiveitem")
		-- {item = item}
		player.blink_indicator:SetVisible(CanBlink(inst))
	end)
end

local function placer_postinit_fn(inst, radius)
	inst.placer_range = SpawnPrefab("insight_range_indicator")
	inst.placer_range:Attach(inst)
	inst.placer_range:SetRadius(radius)
	inst.placer_range:AddTag("placer")
	inst.placer_range:SetVisible(true)

	if IS_DST or GetWorldType() == 3 then
		inst.components.placer:LinkEntity(inst.placer_range) -- i don't remember why i need to do this
	end
end

local function LocalPlayerRemoved()
	localPlayer = nil
	dprint("LOCALPLAYER REMOVED")

	local x = 0
	mprint(x, #onLocalPlayerRemove)
	while #onLocalPlayerRemove > x do
		mprint(string.format("Processing deconstructors with [%s] remaining.", #onLocalPlayerRemove))

		local todo = onLocalPlayerRemove[x + 1]
		todo.fn()
			
		if todo.persists then
			x = x + 1
			mprint("\tIt persists.")
		else
			table.remove(onLocalPlayerRemove, x + 1)
		end
	end
end

local function LoadLocalPlayer(player)
	--mprint("loadlocalplayer", player)

	if not player:IsValid() then
		error("[INSIGHT]: PLAYER ENTITY INVALIDATED!!")
		return
	end

	if IsPlayerClientLoaded(player) then
		localPlayer = player
		localPlayer._insight_context = GetPlayerContext(localPlayer)

		player:ListenForEvent("onremove", LocalPlayerRemoved)
		--mprint("LOCALPLAYER FOUND")

		local x = 0
		while #onLocalPlayerReady > x do
			mprint(string.format("Processing initializers with [%s] remaining.", #onLocalPlayerReady - x))

			local todo = onLocalPlayerReady[x + 1]
			todo.fn(GetLocalInsight(localPlayer), localPlayer._insight_context)
			
			if todo.persists then
				x = x + 1
			else
				table.remove(onLocalPlayerReady, x + 1)
			end
		end
		mprint("Initializers complete" ..  ((SIM_DEV and "...") or "!"))

		if IS_DST then 
			rpcNetwork.SendModRPCToServer(GetModRPC(modname, "ClientInitialized"))
		end


	else
		player:DoTaskInTime(1 / 30, LoadLocalPlayer)
	end
end

function SendConfigurationToServer()
	rpcNetwork.SendModRPCToServer(GetModRPC(modname, "ProcessConfiguration"), json.encode({
		config = GenerateConfiguration(),
		external_config = GenerateExternalConfiguration(),
		etc = {
			is_server_owner = TheNet:GetIsServerOwner(),
			locale = LOC.GetLocaleCode(),
			DEBUG_ENABLED = DEBUG_ENABLED,
			server_deaths = GetMorgueDeathsForWorld(TheNet:GetServerName()),
		},
	}))
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== UI Overrides ====================================================================
--==========================================================================================================================
--==========================================================================================================================

import("uioverrides")

--==========================================================================================================================
--==========================================================================================================================
--======================================== Saved Data ======================================================================
--==========================================================================================================================
--==========================================================================================================================
-- Load Save Data
insightSaveData:Load()

-- Keep track of last played save version
if insightSaveData:Get("last_version") then
	local is_newer = modinfo.version:match("%d+.%d+.%d+") > insightSaveData:Get("last_version")
else
	insightSaveData:Set("last_version", modinfo.version)
	insightSaveData:Save()
end
--==========================================================================================================================
--==========================================================================================================================
--======================================== PostInits =======================================================================
--==========================================================================================================================
--==========================================================================================================================

do

	local function AddBossIndicator(inst)
		if not inst:IsValid() then return end
		
		AddLocalPlayerPostInit(function(insight, context)
			if not context.config["boss_indicator"] then
				return
			end

			local clr = Insight.COLORS.HEALTH
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	local function AddMiniBossIndicator(inst)
		if not inst:IsValid() then return end
		
		AddLocalPlayerPostInit(function(insight, context)
			if not context.config["boss_indicator"] then -- maybe add a config for mini bosses?
				return
			end

			local clr = Insight.COLORS.HEALTH
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr) + Color.new(1, .3, .3)})
		end)
	end

	local function AddNotableIndicator(inst)
		if not inst:IsValid() then return end

		AddLocalPlayerPostInit(function(insight, context)
			if not context.config["notable_indicator"] then
				return
			end

			local clr = Insight.COLORS.SWEETENER
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	-- 
	local function AddBottleIndicator(inst)
		if not inst:IsValid() then return end

		AddLocalPlayerPostInit(function(insight, context)
			if not context.config["bottle_indicator"] then
				return
			end

			local clr = "#609779" or Insight.COLORS.FROZEN -- from message bottle scroll
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	-- https://dontstarve.fandom.com/wiki/Category%3ABoss_Monsters
	local bosses = {
		"minotaur", "ancient_herald", "antlion", "bearger", "beequeen", "crabking", "deerclops", "dragonfly", "ancient_hulk", "klaus",
		"malbatross", "moose", "pugalisk", "kraken", "antqueen", "stalker_forest", "stalker", "stalker_atrium", "twister", "twister_seal", "tigershark", 
		"toadstool", "eyeofterror", "twinofterror1", "twinofterror2"
		-- "shadow_knight", "shadow_bishop", "shadow_rook"
	}

	local mini_bosses = {
		"warg", "claywarg", "gingerbreadwarg", "spat", "leif", "leif_sparse", "treeguard", "spiderqueen", "lordfruitfly",

		"ancient_robot_ribs", "ancient_robot_claw", "ancient_robot_leg", "ancient_robot_head"
	}

	local notable = {
		"hutch_fishbowl", "chester_eyebone", "atrium_key", "klaus_sack", "gingerbreadpig"
	}

	--[[
	mprint("BOSS CHECK:", GetModConfigData("boss_indicator", true))
	
	local r = false
	AddPrefabPostInitAny(function(x)
		if r then return end
		r = true
		mprint("BOSS CHECK 2:", GetModConfigData("boss_indicator", true))
		x:DoPeriodicTask(1 / 15, function()
			mprint("BOSS CHECK X:", GetModConfigData("boss_indicator", true))
		end)
	end)
	--]]
	 
	for _, name in pairs(bosses) do 
		AddPrefabPostInit(name, AddBossIndicator)
	end

	for _, name in pairs(mini_bosses) do 
		AddPrefabPostInit(name, AddMiniBossIndicator)
	end

	for _, name in pairs(notable) do
		AddPrefabPostInit(name, AddNotableIndicator)
	end

	AddPrefabPostInit("messagebottle", AddBottleIndicator)

end

AddPrefabPostInitAny(function(inst)
	if inst.prefab:sub(1, 9) == "lost_toy_" then
		AddLocalPlayerPostInit(function(insight)
			if not localPlayer:HasTag("ghostlyfriend") then
				return
			end

			inst:DoTaskInTime(0.1, function()
				insight:PipspookToyFound(inst)
			end)
		end)
	end
end)

--[[
AddPrefabPostInit("redgem", function(inst)
	local a = SpawnPrefab("insight_range_indicator")
	a:Attach(inst)
	a:SetRadius(4 / WALL_STUDS_PER_TILE)
	a:SetColour(Color.fromHex("#ff0000"))
	a:SetVisible(true)

	a:DoPeriodicTask(1, function()
		if not localPlayer then return end
		print(FindEntity(a, 4, nil, {"player"}))
		print(distsq(a:GetPosition(), localPlayer:GetPosition()), 4 * 4) -- physics range doesn't matter in this case. just need half the entity as usual.
		print'--------'
	end)
end)
--]]

--[[
AddPrefabPostInit("deerclops", function(inst)
	-- tuning says default range is 15
	f = SpawnPrefab("insight_range_indicator")
	f:Attach(inst)
	f:SetRadius(8 / WALL_STUDS_PER_TILE)
	f:SetColour(Color.fromHex("#00ff00"))
	f:SetVisible(true)


	g = SpawnPrefab("insight_range_indicator")
	g:Attach(inst)
	g:SetRadius(15 / WALL_STUDS_PER_TILE)
	g:SetColour(Color.fromHex("#0000ff"))
	g:SetVisible(true)

	--inst:AddComponent("dst_deployhelper")
	--inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end)
--]]

AddPrefabPostInit("insight_combat_range_indicator", import("helpers/combat").HookClientIndicator)
AddPrefabPostInit("insight_ghost_klaus_sack", function(inst)
	AddLocalPlayerPostInit(function(insight, context)
		if not context.config["klaus_sack_markers"] then
			inst.AnimState:OverrideMultColour(0, 0, 0, 0)
		end
	end)
end)

--[[
AddPrefabPostInit("klaus_sack", function(inst)
	inst:DoTaskInTime(0, function()
	local x, y, z = inst.Transform:GetWorldPosition() -- located at 0,0,0 on postinit
	local found = TheSim:FindEntities(x, y, z, 8, {"insight_map_marker", "possible_klaus_sack", "classified"})
	if #found > 0 then
		--inst.MiniMapEntity:SetEnabled(false)
		for i,v in pairs(found) do
			v.MiniMapEntity:SetEnabled(false)
		end
		inst:ListenForEvent("onremove", function()
			for i,v in pairs(found) do
				if v:IsValid() then
					v.MiniMapEntity:SetEnabled(true)
				end
			end
		end)
		inst:ListenForEvent("entitysleep", function() mprint'entitysleep' end)
	else
		--inst.MiniMapEntity:SetEnabled(true)
		mprint'empty'
	end
	end)
end)
--]]

AddPrefabPostInit("cave_entrance_open", function(inst)
	if IS_DS then return end -- does this even exist in DS
	local cfg = GetModConfigData("sinkhole_marks", true)
	if cfg == 0 then return end

	--AddLocalPlayerPostInit(function() GetInsight(localPlayer):RequestInformation(inst) end)
	--dprint('postinit', inst)
	ListenForEventOnce(inst, "insight_ready", function(inst)
		dprint(inst, "- migrator has loaded")
		local info = GetInsight(localPlayer):GetInformation(inst)
		local id = info.special_data.worldmigrator.receivedPortal
		--dprint("id:", id)

		if FOREST_MIGRATOR_IMAGES[id] then
			--inst.MiniMapEntity:SetIcon(FOREST_MIGRATOR_IMAGES[id][1])
			--inst.MiniMapEntity:SetCanUseCache(false)

			if cfg == 2 then
				local clr = FOREST_MIGRATOR_IMAGES[id][2]
				local new = clr
				inst.AnimState:SetMultColour(unpack(new))
				--inst.AnimState:SetHighlightColour(unpack(new))
				--inst.AnimState:SetAddColour(unpack(new))
			end
		else
			--dprint("no icon for", id)
		end
	end)
end)

AddPrefabPostInit("cave_exit", function(inst)
	if IS_DS then return end
	local cfg = GetModConfigData("sinkhole_marks", true)
	if cfg == 0 then return end

	ListenForEventOnce(inst, "insight_ready", function(inst)
		dprint(inst, "- migrator has loaded")
		local info = GetInsight(localPlayer):GetInformation(inst)
		local id = info.special_data.worldmigrator.id -- intentional
		--dprint("id:", id)

		if CAVE_MIGRATOR_IMAGES[id] then
			--inst.MiniMapEntity:SetIcon(CAVE_MIGRATOR_IMAGES[id][1])

			if cfg == 2 then
				local clr = CAVE_MIGRATOR_IMAGES[id][2]
				local new = clr
				inst.AnimState:SetMultColour(unpack(new))
				--inst.AnimState:SetHighlightColour(unpack(new))
				--inst.AnimState:SetAddColour(unpack(new))
			end
		else
			--dprint("no icon for", id)
		end
	end)
end)

--[[
AddPrefabPostInit("redgem", function(inst) 
	if not DEBUG_ENABLED then
		return
	end

	-- tuning says default range is 15
	inst.snowball_range = SpawnPrefab("insight_range_indicator")
	inst.snowball_range:Attach(inst)
	inst.snowball_range:SetRadius(12 / WALL_STUDS_PER_TILE)
	inst.snowball_range:SetColour(Color.fromHex(Insight.COLORS.FROZEN))
	inst.snowball_range:SetVisible(true)

	--inst:AddComponent("dst_deployhelper")
	--inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end)
--]]

AddPrefabPostInit("firesuppressor", function(inst) 
	-- tuning says default range is 15
	if IS_DST then return end
	inst.snowball_range = SpawnPrefab("insight_range_indicator")
	inst.snowball_range:Attach(inst)
	inst.snowball_range:SetRadius(TUNING.FIRE_DETECTOR_RANGE / WALL_STUDS_PER_TILE)
	inst.snowball_range:SetColour(Color.fromHex(Insight.COLORS.WET))
	inst.snowball_range:SetVisible(false)

	inst:AddComponent("dst_deployhelper")
	inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end)

AddPrefabPostInit("sprinkler", function(inst) 
	if IS_DST then return end
	inst.range_indicator = SpawnPrefab("insight_range_indicator")
	inst.range_indicator:Attach(inst)
	inst.range_indicator:SetRadius(8 / WALL_STUDS_PER_TILE)
	inst.range_indicator:SetColour(Color.fromHex(Insight.COLORS.WET))
	inst.range_indicator:SetVisible(false)

	inst:AddComponent("dst_deployhelper")
	inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end)

AddPrefabPostInit("basefan", function(inst) 
	-- tuning says default range is 15
	if IS_DST then return end
	inst.range_indicator = SpawnPrefab("insight_range_indicator")
	inst.range_indicator:Attach(inst)
	inst.range_indicator:SetRadius(30 / WALL_STUDS_PER_TILE)
	inst.range_indicator:SetColour(Color.fromHex(Insight.COLORS.WET))
	inst.range_indicator:SetVisible(false)

	inst:AddComponent("dst_deployhelper")
	inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end)

--[[
AddPrefabPostInit("eyeturret", function(inst)
	inst.range = SpawnPrefab("insight_range_indicator")
	inst.range:Attach(inst)
	inst.range:SetRadius(TUNING.EYETURRET_RANGE / WALL_STUDS_PER_TILE)
	inst.range:SetColour(Color.fromHex(Insight.COLORS.HEALTH))
	inst.range:SetVisible(true)
end)
--]]



AddPrefabPostInit("eyeturret_item_placer", function(inst)
	placer_postinit_fn(inst, TUNING.EYETURRET_RANGE / WALL_STUDS_PER_TILE)
end)

AddPrefabPostInit("lightning_rod_placer", function(inst)
	placer_postinit_fn(inst, 40 / WALL_STUDS_PER_TILE)
end)

AddPrefabPostInit("lightning_rod", function(inst) -- or i could just listen to any entity with tag "lightningrod"
	local config = GetModConfigData("lightningrod_range", true)

	if config == 0 then return end -- off

	inst.lightningrod_range = SpawnPrefab("insight_range_indicator")
	inst.lightningrod_range:Attach(inst)
	inst.lightningrod_range:SetRadius(40 / WALL_STUDS_PER_TILE)
	inst.lightningrod_range:SetColour(Color.fromHex(Insight.COLORS.LIGHT))

	if config == 1 then	-- strategic
		inst.lightningrod_range:SetVisible(false)
		inst:AddComponent("dst_deployhelper")
		inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
	elseif config == 2 then -- always
		inst.lightningrod_range:SetVisible(true)
	else
		error("invalid config for lightning_range: " .. tostring(config))
	end
end)

AddPrefabPostInit("wortox_soul_spawn", function(inst) -- the dropped one
	if not (localPlayer and localPlayer:HasTag("soulstealer")) then
		return
	end

	if not GetModConfigData("wortox_soul_range", true) then
		return
	end

	inst.pickup_indicator = SpawnPrefab("insight_range_indicator")
	inst.pickup_indicator:Attach(inst)
	inst.pickup_indicator:SetRadius(TUNING.WORTOX_SOULSTEALER_RANGE / WALL_STUDS_PER_TILE) 
	inst.pickup_indicator:SetColour(Color.fromHex(Insight.COLORS.HEALTH))

	--[[
	local yes2 = SpawnPrefab("insight_range_indicator")
	yes2.entity:SetParent(inst.entity)

	yes2:SetRadius_Zark(TUNING.WORTOX_SOULSTEALER_RANGE / WALL_STUDS_PER_TILE - offset)
	yes2:SetColour(0, 1, 0, 1)
	--]]
end)

AddPlayerPostInit(function(player)
	if IS_DS then
		LoadLocalPlayer(player)

		AddLocalPlayerPostInit(function(insight, context)
			if context.config["blink_range"] then
				AttachBlinkRangeIndicator(player)
			end
		end)

		player:ListenForEvent("newactiveitem", function(...)
			highlighting.SetActiveItem(...)
		end)

		local insight = GetInsight(player)
		for ent in pairs(delayed_actives) do
			insight:EntityActive(ent)
		end
		delayed_actives = {}

		CreatePlayerContext(player, GenerateConfiguration(), GenerateExternalConfiguration(), {
			is_server_owner = true,
			locale = LOC.GetLocaleCode(),
		})

		return
	end

	player:DoTaskInTime(0, function()
		AttachWigfridSongRangeIndicator(player)

		if player ~= ThePlayer then
			return
		end

		--[[
		local old = rawget(_G, "StackTrace")
		local mprint = mprint
		mprint("stacktrace:", old)
		_G.StackTrace = function() end
		_G._TRACEBACK = function() end
		--]]

		LoadLocalPlayer(player)

		AddLocalPlayerPostInit(function(insight, context)
			if context.config["blink_range"] then
				AttachBlinkRangeIndicator(localPlayer)
			end

			for ent in pairs(delayed_actives) do
				insight:EntityActive(ent)  -- apparently can be nil, though very rare.
			end
			delayed_actives = {}
		end)
			
		-- [host] triggers for anyone that joins
		-- [client] triggers for all current players (same time) and those that join 

		-- comes from Inventory.SetActiveItem, not InventoryBar...
		player:ListenForEvent("newactiveitem", function(...)
			highlighting.SetActiveItem(...)
		end)

		if IsClient() then -- create local copy for clients
			CreatePlayerContext(player, GenerateConfiguration(), GenerateExternalConfiguration(), {
				is_server_owner = TheNet:GetIsServerOwner(),
				locale = LOC.GetLocaleCode(),
			})
		end
		
		-- server shares this if client host
		SendConfigurationToServer()
	end)
end)

if IS_DS then
	require("components/dst_deployhelper")
	AddComponentPostInit("placer", function(self)
		local oldOnUpdate = self.OnUpdate

		function self.OnUpdate(...)
			local x, y, z = self.inst.Transform:GetWorldPosition()
    		TriggerDeployHelpers({ x=x, y=y, z=z }, 64, self.recipe, self.inst)
			oldOnUpdate(...)
		end
	end)

	local sizetbl = setmetatable({}, {__mode = "k"}) -- k, v, kv

	local oldSetSize = TextWidget.SetSize
	TextWidget.SetSize = function(self, sz)
		sizetbl[self] = sz
		return oldSetSize(self, sz)
	end

	TextWidget.GetSize = function(self, sz)
		return sizetbl[self]
	end
end

-- Misc
AddPrefabPostInitAny(entityManager.Manage)

local function OnEntityManagerEventDST(self, event, inst)
	if event == "sleep" then
		if (IS_CLIENT_HOST and localPlayer) then 
			inst:DoTaskInTime(0, highlighting.SetEntitySleep)

			if localPlayer.replica.insight and localPlayer.replica.insight.EntityInactive then
				localPlayer.replica.insight:EntityInactive(inst)
			end

		end
		delayed_actives[inst] = nil
	elseif event == "awake" then
		if localPlayer and localPlayer.replica.insight and localPlayer.replica.insight.EntityActive then
			localPlayer.replica.insight:EntityActive(inst)
		else
			delayed_actives[inst] = true
		end
	end
end

local function OnEntityManagerEventDS(self, event, inst)

end


if IS_DST then
	entityManager:AddListener("insight", OnEntityManagerEventDST)
else
	entityManager:AddListener("insight", OnEntityManagerEventDS)
end

--[[
entityManager:AddListener("insight", function(self, event, inst)
	if event == "sleep" then
		-- highlighting
		if IS_DS or (not IS_DS and localPlayer) then 
			highlighting.SetEntitySleep(inst)
		end

		if not IS_DS then
			-- networking
			if localPlayer and GetInsight(localPlayer) then
				GetInsight(localPlayer):EntityInactive(inst)
			else
				delayed_actives[inst] = nil
			end
		end
	elseif event == "awake" then
		-- highlighting
		if IS_DS or (not IS_DS and localPlayer) then 
			inst:DoTaskInTime(0, function()
				-- give entities time to get their replicas
				highlighting.SetEntityAwake(inst)
			end)
		end

		if not IS_DS then
			-- networking
			if localPlayer and GetInsight(localPlayer) then
				GetInsight(localPlayer):EntityActive(inst)
			else
				delayed_actives[inst] = true
			end
		end
	end
end)

--]]

--[[
entityManager:AddListener("insight", function(self, event, inst)
	if event == "sleep" then
		-- highlighting
		if IS_DS or (not IS_DS and localPlayer) then 
			highlighting.SetEntitySleep(inst)
		end

		if not IS_DS then
			-- networking
			if localPlayer and localPlayer.components.insight then
				--localPlayer.components.insight:EntityInactive(inst)
			else
				delayed_actives[inst] = nil
			end
		end
	elseif event == "awake" then
		-- highlighting
		if IS_DS then 
			-- give entities time to get their replicas
			inst:DoTaskInTime(0, highlighting.SetEntityAwake)
		end

		if not IS_DS then
			-- networking
			if localPlayer and localPlayer.replica.insight then
				localPlayer.replica.insight:EntityActive(inst)
			else
				delayed_actives[inst] = true
			end
		end
	end
end)
--]]


AddLocalPlayerPostInit(highlighting.Activate, true)
AddLocalPlayerPostRemove(highlighting.Deactivate, true)
AddLocalPlayerPostInit(combatHelper.Activate, true)
AddLocalPlayerPostInit(function(insight_replica, context) 
	insight_replica.context = context
end, true)
--AddLocalPlayerPostRemove(combatHelper.Deactivate, true)

if IS_DST then
	--[[
	local oldLearnPlantStage = ThePlantRegistry.LearnPlantStage
	ThePlantRegistry.LearnPlantStage = function(...)
		rpcNetwork.SendModRPCToServer(GetModRPC(modname, "PlantRegistry"), ThePlantRegistry)
		return oldLearnPlantStage(...)
	end
	--]]
end

-- until i can think of a better place for this
if IS_DST then
	AddLocalPlayerPostInit(function(insight_replica, context)
		if not localPlayer.HUD._StatusAnnouncer or not localPlayer.HUD._StatusAnnouncer.RegisterInterceptor then
			return
		end

		localPlayer.HUD._StatusAnnouncer:RegisterInterceptor(modname, "ITEM", function(announcement_string, data)
			--[[
				local data = {
					item = item,
					container = container,
					slot = slot,
				}
			]]
			if Insight.prefab_descriptors[data.item.prefab] and Insight.prefab_descriptors[data.item.prefab].StatusAnnoucementsDescribe then
				local info = insight_replica:GetInformation(data.item)
				--table.foreach(info, dprint)
				--table.foreach(info.special_data, dprint)

				
				

				if info then 
					-- why is this missing on rare occasion?
					if not info.special_data[data.item.prefab] then
						dumptable(info)
					end

					local data = Insight.prefab_descriptors[data.item.prefab].StatusAnnoucementsDescribe(info.special_data[data.item.prefab], context, data.item)
					if data and data.description then
						if data.append then
							return announcement_string .. " " .. data.description
						else
							return data.description
						end
					end
				end
			end
		end)
	end, true)
end