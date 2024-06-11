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
insightSaveData = import("helpers/savedata")("mod_config_data/Insight_SaveData" .. (IS_DST and "_CLIENT" or ""));
controlHelper = import("helpers/control")
localPlayer = nil
currentlySelectedItem = nil
shard_players = {}

local delayed_actives = {}
insight_subscribed = IS_DS or KnownModIndex.savedata.known_mods["workshop-2189004162"].enabled ~= nil
-- game has to be exited and reopened for the savedata to update i guess
-- the difference between unsubbed and subbed is that subbed has "enabled" and "temp_disabled" fields
-- if subscribed and the world is just forest, nonhosts have enabled=false but temp_enabled = true


-- Client Event Core
ClientCoreEventer = import("helpers/eventer")()
OnLocalPlayerPostInit = ClientCoreEventer:CreateEvent("OnLocalPlayerPostInit")
OnLocalPlayerPostInit.onlisteneradded = function(listener)
	if localPlayer then
		listener:Run(GetLocalInsight(localPlayer), GetPlayerContext(localPlayer))
	end
end
OnLocalPlayerRemove = ClientCoreEventer:CreateEvent("OnLocalPlayerRemove")
OnContextUpdate = ClientCoreEventer:CreateEvent("OnContextUpdate")

highlighting = import("highlighting")

--==========================================================================================================================
--==========================================================================================================================
--======================================== Functions =======================================================================
--==========================================================================================================================
--==========================================================================================================================
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

local function PrimeComplexConfiguration()
	if modinfo._ready ~= nil then
		return
	end

	local complex_config = modinfo.complex_configuration_options

	local map = {}
	modinfo.complex_configuration_options_map = map

	local env = getfenv(1)

	local function_env = setmetatable({}, {
		__index = function(self, index)
			-- Check to see if it's somethinng inside modinfo.
			local ret = modinfo[index]
			if ret ~= nil then
				return ret
			end
			
			-- It's not, so fall back to our environment here.
			ret = env[index]
			return ret
		end
	})

	for i, config in ipairs(complex_config) do
		if not table.contains(config.tags, "ignore") then
			-- First thing to do: Go through the configs and process their options and default
			if type(config.options) == "function" then
				config.options = setfenv(config.options, function_env)()
			end
			if type(config.default) == "function" then
				config.default = setfenv(config.default, function_env)()
			end

			-- Then do localization
			modinfo.AddConfigurationOptionStrings(config)
			
			-- Map it for reversing
			map[config.name] = config
		end
	end

	modinfo._ready = true
end

function LoadComplexConfiguration()
	if modinfo._ready == nil then
		PrimeComplexConfiguration()
	end

	local info = {}

	local saved_options = insightSaveData:Get("configuration_options") or {}

	-- Validate the config to make sure the saved data is still valid.
	for name, saved in pairs(saved_options) do
		local config = modinfo.complex_configuration_options_map[name]
		if config == nil then
			-- This option doesn't exist anymore.
			saved_options[name] = nil
			mprintf("Deleting nonexistant saved option key: %q", name)
			insightSaveData:SetDirty(true)
		else
			-- Validate the saved
			if config.config_type == "listbox" then
				for i = #saved, 1, -1 do
					local v = saved[i]
					if not util.table_find(config.options, function(x) return x.data == v end) then
						table.remove(saved, i)
						mprintf("Nonexistant entry %q in saved option %q, removing.", v, name)
						insightSaveData:SetDirty(true)
					end
				end
			else
				errorf("Unable to validate unknown configuration type %q", opt.config_type)
			end
		end
	end

	if insightSaveData:IsDirty() then
		insightSaveData:Save()
	end

	-- "Load" the config
	local loaded_data = deepcopy(modinfo.complex_configuration_options)

	for i, config in ipairs(loaded_data) do
		info[i] = config
		if saved_options[config.name] ~= nil then
			info[i].saved = deepcopy(saved_options[config.name])
		end
	end

	return info
end

local function GenerateComplexConfiguration()
	local info = LoadComplexConfiguration()

	local complex_config = {}

	for i, config in ipairs(info) do
		if not util.table_find(config.tags, "ignore") then
			complex_config[config.name] = config.default
			if config.saved ~= nil then
				complex_config[config.name] = config.saved
			end

			if config.config_type == "listbox" then
				local converted = {}
				for _, opt in pairs(config.options) do
					converted[opt.data] = table.contains(complex_config[config.name], opt.data)
				end
				complex_config[config.name] = converted
				

				--[[
				-- Works fine except when config sent to server on a client host, wipes the metatable since it gets sent with a JSON encode.
				setmetatable(complex_config[config.name], {
					__index = function(self, index)
						return table.contains(self, index)
					end,
				})
				--]]
			end
		end
	end

	return complex_config
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

	--mprint("CALLED FOR CONFIG GEN")
	local config_data = deepcopy(LoadModConfigurationOptions(modname, true))

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
					-- Originally, If the client isn't subscribed to Insight, the server could choose to enforce client options on the client.
					-- This was because clients couldn't configure the mod.
					-- But with the introduction of the configuration menu, that problem should be gone.
					-- So what do I do about this?

					-- For now, I'll revert it back to client choice and see who complains.
					--winner = server_choice
					winner = client_choice
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
	return (player and player.HUD and GetLocalInsight(player) and GetPlayerContext(player) and true) or false
end

local function AddDeployHelper(inst)
	-- Courtesy of Hornet 🗿
	inst:AddComponent(IS_DST and "deployhelper" or "dst_deployhelper")
end

local function GetDeployHelper(inst)
	if IS_DST then
		return inst.components.deployhelper
	else
		return inst.components.dst_deployhelper
	end
end



function OnCurrentlySelectedItemChanged(old, new, itemInfo)
	-- Somehow people are hovering something without a prefab that also fails IsPrefab on the server
	local old_desc = old and old.prefab and Insight.prefab_descriptors[old.prefab] or nil
	local new_desc = new and new.prefab and Insight.prefab_descriptors[new.prefab] or nil

	if old and old._scything then
		Insight.prefab_descriptors.voidcloth_scythe.OnScytheTargetUnselected(localPlayer)
		old._scything = nil
	end
	
	--mprint("OnCurrentlySelectedItemChanged", old, new)
	if old and old.insight_hover_range then
		old.insight_hover_range:Remove()
		old.insight_hover_range = nil
	end

	if old and old.insight_combat_range_indicator and old.insight_combat_range_indicator.state_forced then
		old.insight_combat_range_indicator:ForceStateChange(attackRangeHelper.NET_STATES.NOTHING)
	end

	if old and GetDeployHelper(old) then
		GetDeployHelper(old):StopHelper()
	end

	if old_desc and old_desc.OnUnselect then
		old_desc.OnUnselect(old)
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

		ind:ForceStateChange(attackRangeHelper.NET_STATES.TARGETTING)
		return
	end

	if context.complex_config["unique_info_prefabs"]["voidcloth_scythe"] and new:HasTag("pickable") then
		--print'a'
		local inventory = localPlayer.replica.inventory
		if inventory then
			--print'b'
			local holding = inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
			-- Was going to check for tag originally ("SCYTHE_tool") (Tag doesn't exist in client tag db but can still check for it)
			-- But then double checking the scythe code, the range stuff is specific to the prefab.
			if holding and holding.prefab == "voidcloth_scythe" then
				--print'c'
				if util.IsValidScytheTarget(new) then
					--print'd'
					local d = Insight.prefab_descriptors.voidcloth_scythe
					if d and d.OnScytheTargetSelected then
						--print'e'
						new._scything = true
						d.OnScytheTargetSelected(holding, new, localPlayer)
					end
				end
			end
		end
	end

	if new_desc and new_desc.OnSelect then
		new_desc.OnSelect(new)
	end

	-- should i handle weapon range?
	if itemInfo.special_data.insight_ranged then
		local range = itemInfo.special_data.insight_ranged.range -- or (itemInfo.special_data.soul and itemInfo.special_data.soul.soul_heal_range)
		local color = itemInfo.special_data.insight_ranged.color -- or (itemInfo.special_data.soul and itemInfo.special_data.soul.soul_heal_range_color)
		
		if color then
			color = Insight.COLORS[color:upper()] or color
		end

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
	elseif GetDeployHelper(new) then
		local cmp = GetDeployHelper(new)
		cmp:StartHelper(nil, nil)
		cmp.delay = math.huge -- Prevent it from disappearing instantly, since it's kept open by (what I assume) is TriggerDeployHelpers running over and over?
	end
end

--- Retrives the current selected item, be it from hud or world.
---@return EntityScript|nil
function GetMouseTargetItem()
	-- Winner
	local target

	local hudTarget = TheInput:GetHUDEntityUnderMouse()
	-- target.widget.parent is ItemTile

	-- Game prefers inventory items over world items
	if hudTarget and hudTarget.widget then
		local parent = hudTarget.widget:GetParent()
		if parent and parent.item then
			target = parent.item
		elseif parent then
			-- Wigfrid's "Charged Elding Spear" has an Image in the way instead of an ItemTile.
			-- I think it has something to do with the inventoryitem:ChangeImageName("spear_wathgrithr_lightning") that it does.
			parent = parent:GetParent()
			if parent and parent.item then
				target = parent.item
			end
		end
	end

	if not target then
		target = TheInput:GetWorldEntityUnderMouse()
	end

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

	if holding and (holding.components.blinkstaff or (IS_DST and HasVanillaActionComponent(holding, "blinkstaff"))) then
		return true
	elseif cursor and (cursor.components.blinkstaff or (IS_DST and HasVanillaActionComponent(cursor, "blinkstaff"))) then
		return true
	end

	return false

	--return (holding and (holding.components.blinkstaff or holding:HasActionComponent("blinkstaff"))) or (cursor and (cursor.components.blinkstaff or cursor:HasActionComponent("blinkstaff"))) or (player:HasTag("soulstealer") and inventory:Has("wortox_soul", 1))
end

local function OnHelperStateChange(inst, active, recipename, placerinst)
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
	if player.blink_indicator and player.blink_indicator:IsValid() then
		return
	end

	local indicator = SpawnPrefab("insight_range_indicator")
	local events = {}
	indicator._events = events
	player.blink_indicator = indicator

	indicator:Attach(player)
	indicator:SetRadius(ACTIONS.BLINK.distance / WALL_STUDS_PER_TILE)
	indicator:SetColour(Color.fromHex(Insight.COLORS.VEGGIE))
	player:DoTaskInTime(0, function() indicator:SetVisible(CanBlink(player)) end)

	-- Inventory:Equip {item=item, eslot=eslot}, Inventory:Unequip {item=item, eslot=equipslot, (server only) slip=slip}
	events[#events+1] = player:ListenForEvent("equip", function(inst, data)
		--mprint("equip")
		if data.eslot == EQUIPSLOTS.HANDS then
			indicator:SetVisible(CanBlink(inst))
		end
	end)

	events[#events+1] = player:ListenForEvent("unequip", function(inst, data)
		--mprint("unequip")
		if data.eslot == EQUIPSLOTS.HANDS then
			indicator:SetVisible(CanBlink(inst))
		end
	end)

	events[#events+1] = player:ListenForEvent("itemget", function(inst, data)
		--mprint("itemget")
		if data.item.prefab == "wortox_soul" then
			indicator:SetVisible(CanBlink(inst))
		end
	end)

	events[#events+1] = player:ListenForEvent("itemlose", function(inst, data)
		--mprint("itemlose")
		-- {slot = slot}
		indicator:SetVisible(CanBlink(inst))
	end)

	events[#events+1] = player:ListenForEvent("newactiveitem", function(inst, data)
		--mprint("newactiveitem")
		-- {item = item}
		indicator:SetVisible(CanBlink(inst))
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

local function LocalPlayerDeactivated(src)
	if not localPlayer then
		return
	end

	dprint("LOCALPLAYER DEACTIVATED", localPlayer, "FROM", src)

	ClientCoreEventer:PushEvent("force_insightui_exit")

	local insight = GetLocalInsight(localPlayer)
	insight.context = nil
	insight:Shutdown()
	localPlayer = nil
	--[[
	local x = 0
	--mprint(x, #onLocalPlayerRemove)
	
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
	--]]

	OnLocalPlayerRemove:Push()
end

local function LoadLocalPlayer(player)
	--mprint("loadlocalplayer", player)

	if not player:IsValid() then
		error("[INSIGHT]: PLAYER ENTITY INVALIDATED!!")
		return
	end

	if IsPlayerClientLoaded(player) then
		localPlayer = player
		dprint("LOCALPLAYER ADDED", localPlayer)
		local context = GetPlayerContext(player)
		local insight = GetLocalInsight(localPlayer)
		insight.context = context

		if IS_DST then
			-- This doesn't get triggered when the player gets removed via c_despawn() in a client hosted world.
			player:ListenForEvent("playerdeactivated", function() LocalPlayerDeactivated("playerdeactivated") end)
		end

		player:ListenForEvent("onremove", function() LocalPlayerDeactivated("onremove") end)

		local x = 0

		--mprint("LoadLocalPlayer", localPlayer, insight, context.player)
		OnLocalPlayerPostInit:Push(insight, context)
		OnContextUpdate:Push(context)
		-- attacked, healthdelta
		player:ListenForEvent("attacked", function()
			ClientCoreEventer:PushEvent("force_insightui_exit")
		end)

		mprint("Initializers complete" ..  ((SIM_DEV and "...") or "!"))

		if IS_DST then 
			rpcNetwork.SendModRPCToServer(GetModRPC(modname, "ClientInitialized"))
		end


	else
		player:DoTaskInTime(FRAMES, LoadLocalPlayer)
	end
end

function SendConfigurationToServer()
	local data = {
		configs = {
			vanilla = GenerateConfiguration(),
			external = GenerateExternalConfiguration(),
			complex = GenerateComplexConfiguration(),
		},
		etc = {
			is_server_owner = TheNet:GetIsServerOwner(),
			locale = LOC.GetLocaleCode(),
			DEBUG_ENABLED = DEBUG_ENABLED,
			server_deaths = GetMorgueDeathsForWorld(TheNet:GetServerName()),
		},
	}

	rpcNetwork.SendModRPCToServer(GetModRPC(modname, "ProcessConfiguration"), json.encode(data))
end

function NEW_VERSION_INFO_FN(button)
	local InsightPopupDialog = import("screens/insightpopupdialog")
	local InsightConfigurationScreen = import("screens/insightconfigurationscreen")
	local InsightPresetScreen = import("screens/insightpresetscreen")

	if FIRST_TIME_INSIGHT then
		local popup; popup = InsightPopupDialog(
			"Welcome to Insight!", 
[[This is probably your first time using Insight.
I recommend checking out the configuration or using one of the presets!]],
			{
				{ text="No thanks", cb=function() 
					popup:Close() 
				end },
				{ text="Configuration", cb=function() 
					popup:Close() 
					local scr = InsightConfigurationScreen() 
					TheFrontEnd:PushScreen(scr)
				end },
				{ text="Presets", cb=function() 
					popup:Close()
					local scr = InsightPresetScreen(GetPlayerContext(localPlayer), modname)
					TheFrontEnd:PushScreen(scr)
				end },
			}
		); -- Prevent ambiguous syntax
		(popup.black.image or popup.black):SetTint(0, 0, 0, 0)
		TheFrontEnd:PushScreen(popup)
	else
		button.onclick()
	end
end

--==========================================================================================================================
--==========================================================================================================================
--======================================== Initialization ==================================================================
--==========================================================================================================================
--==========================================================================================================================
ClientCoreEventer:ListenForEvent("configuration_update", function()
	--mprint("Got ConfigurationUpdate")
	local config = GenerateConfiguration()

	DEBUG_ENABLED = config["DEBUG_ENABLED"]

	if IS_DS or IsClient() then
		UpdatePlayerContext(localPlayer, {
			configs = {
				vanilla = config,
				external = GenerateExternalConfiguration(),
				complex = GenerateComplexConfiguration(),
			}
		})
	end

	if IS_DST then
		SendConfigurationToServer()
	end

	OnContextUpdate:Push(GetPlayerContext(localPlayer))
end)

OnLocalPlayerPostInit:AddListener("highlighting_activate", highlighting.Activate)
OnLocalPlayerRemove:AddListener("highlighting_deactivate", highlighting.Deactivate)

OnLocalPlayerPostInit:AddListener(attackRangeHelper.Activate)

OnContextUpdate:AddListener("blinkrange_attacher", function(context)
	if context.config["blink_range"] then
		AttachBlinkRangeIndicator(localPlayer)
	else
		if localPlayer.blink_indicator then
			localPlayer.blink_indicator:Remove()
			for i,v in pairs(localPlayer.blink_indicator._events) do
				v:Remove()
			end
			localPlayer.blink_indicator = nil
		end
	end
end)
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Saved Data ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Load Save Data
insightSaveData:Load()

-- Keep track of last played save version
-- Also a good indicator that the file exists.
if insightSaveData:Get("last_version") then
	-- Technically both versions should go through TrimString(str):lower()
	local is_newer = modinfo.version:match("%d+.%d+.%d+") > insightSaveData:Get("last_version")
	NEW_INSIGHT_VERSION = is_newer

	-- Retrofitting
	if insightSaveData:Get("keybinds") == nil then
		insightSaveData:Set("keybinds", {})
	end

	if insightSaveData:Get("configuration_options") == nil then
		insightSaveData:Set("configuration_options", {})
	end
   
	if insightSaveData:IsDirty() then
		-- We've retrofitted *something*.
		insightSaveData:Save()
	end

	FIRST_TIME_INSIGHT = false
else
	NEW_INSIGHT_VERSION = true
	FIRST_TIME_INSIGHT = true

	-- Safe to assume this is the first instance of this file happening! 
	insightSaveData:Set("last_version", modinfo.version)
	
	-- I'll keep this in for a while I think.
	TheSim:GetPersistentString("insightmenubutton", function(load_success, str)
		if not load_success then
			-- One of these didn't exist, so it's fine.
			return
		end

		local safe, pos = pcall(function() return json.decode(str).position end)
		if not safe then
			TheSim:ErasePersistentString("insightmenubutton")
			return
		end
		
		insightSaveData:Set("insightmenubutton_position", pos)
		TheSim:ErasePersistentString("insightmenubutton")
	end)

	insightSaveData:Set("keybinds", {})
	insightSaveData:Set("configuration_options", {})

	

	insightSaveData:Save()
end

--NEW_INSIGHT_VERSION = true
--FIRST_TIME_INSIGHT = true

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Keybinds ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- I wonder if I should move keybinds to mod config instead of a persistentstring. 
-- insightSaveData:Get("keybinds")

insightKeybinds = import("helpers/keybinds")()

if DEBUG_ENABLED then
	insightKeybinds:Register("test", "TestBind", "This is a test.", nil, function(down)
		if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" and localPlayer.components.playercontroller:IsEnabled() then
			mprint(":)")
		end
	end)
end

insightKeybinds:Register("togglemenu", language.en.keybinds.togglemenu.name, language.en.keybinds.togglemenu.description, nil, function(down)
	if not down and TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name == "HUD" and localPlayer.components.playercontroller:IsEnabled() then
		local insight_menu_toggle = table.getfield(localPlayer, "HUD.controls.insight_menu_toggle")
		if insight_menu_toggle and insight_menu_toggle.shown and insight_menu_toggle.onclick then
			insight_menu_toggle.onclick()
		end
	end
end)

insightKeybinds.onkeybindchanged = function(name, new, old)
	--mprint("BIGCHANGED::", name, "|", new, old, insightSaveData:Get("keybinds")[name])
	insightSaveData:SetDirty(true)
end
insightKeybinds:LoadSavedKeybindings(insightSaveData:Get("keybinds"))
insightKeybinds:SetReady()

OnLocalPlayerPostInit:AddListener("translate_keybinds", function(insight, context)
	for name, data in pairs(insightKeybinds:GetKeybinds()) do
		local trans = context.lstr.keybinds[name]
		if trans then
			data.pretty_name = trans.name or data.pretty_name
			data.description = trans.description or data.description
		end
	end
end)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ UI Overrides ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

import("uioverrides")

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PostInits ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

do
	-- TODO: Maybe I should loop over loaded ents to readd indicators AND add a context update listener to remove them
	local function AddBossIndicator(inst)
		if not inst:IsValid() then return end
		
		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			if not context.config["boss_indicator"] then
				return
			end
			
			if not context.complex_config["boss_indicator_prefabs"][inst.prefab] then
				return
			end

			local clr = Insight.COLORS.HEALTH
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	local function AddMiniBossIndicator(inst)
		if not inst:IsValid() then return end
		
		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			if not context.config["miniboss_indicator"] then
				return
			end

			local prefab = (inst.prefab == "leif_sparse" and "leif") or 
				(inst.prefab == "stalker_forest" and "stalker") or
				inst.prefab
			
			
			if not context.complex_config["miniboss_indicator_prefabs"][prefab] then
				return
			end

			local clr = Insight.COLORS.HEALTH
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr) + Color.new(1, .3, .3)})
		end)
	end

	local function AddNotableIndicator(inst)
		if not inst:IsValid() then return end

		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			if not context.config["notable_indicator"] then
				return
			end
			
			if not context.complex_config["notable_indicator_prefabs"][inst.prefab] then
				return
			end
			
			local clr = Insight.COLORS.SWEETENER
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	-- 
	local function AddBottleIndicator(inst)
		if not inst:IsValid() then return end

		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			if not context.config["bottle_indicator"] then
				return
			end

			local clr = "#609779" or Insight.COLORS.FROZEN -- from message bottle scroll
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	local function AddSuspiciousMarbleIndicator(inst)
		if not inst:IsValid() then return end

		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			if not context.config["suspicious_marble_indicator"] then
				return
			end

			local clr = "#c0c0c0"
			insight:StartTrackingEntity(inst, {color = Color.fromHex(clr)})
		end)
	end

	-- https://dontstarve.fandom.com/wiki/Category%3ABoss_Monsters
	local bosses = {
		"minotaur", "bearger", "deerclops", "dragonfly", -- Both

		"antlion", "beequeen", "crabking",  "klaus", "malbatross", "moose", "stalker_atrium", "toadstool", "eyeofterror", "twinofterror1", "twinofterror2", "daywalker", -- DST

		"ancient_herald", "ancient_hulk", "pugalisk", "twister", "twister_seal", "tigershark", "kraken", "antqueen", -- DS
		 -- "shadow_knight", "shadow_bishop", "shadow_rook"
	}

	local mini_bosses = {
		"leif", "warg", "spat", "spiderqueen", -- Both
		"leif_sparse",

		"claywarg", "gingerbreadwarg", "spat", "treeguard", "lordfruitfly", "stalker", -- DST
		"stalker_forest", 

		"ancient_robot_ribs", "ancient_robot_claw", "ancient_robot_leg", "ancient_robot_head" -- DS
	}

	local notable = {
		"chester_eyebone", "hutch_fishbowl",  -- Both
		
		"atrium_key", "klaus_sack", "gingerbreadpig", -- DST

		-- DS
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

	for _, name in pairs({"sculpture_knighthead", "sculpture_bishophead", "sculpture_rooknose"}) do
		AddPrefabPostInit(name, AddSuspiciousMarbleIndicator)
	end
end


AddPrefabPostInitAny(function(inst)
	if inst.prefab:sub(1, 9) == "lost_toy_" then
		OnLocalPlayerPostInit:AddWeakListener(function(insight)
			if not localPlayer:HasTag("ghostlyfriend") then
				return
			end

			inst:DoTaskInTime(0.1, function()
				insight:PipspookToyFound(inst)
			end)
		end)
	end
end)

--[==[
AddPrefabPostInit("redgem", function(inst)
	local a = SpawnPrefab("insight_range_indicator")
	rawset(_G, "b", a)
	a:Attach(inst)
	a:SetRadius(4 / WALL_STUDS_PER_TILE)
	a:SetColour(Color.fromHex("#ff0000"))
	a:SetVisible(true)

	--[[
	a:DoPeriodicTask(1, function()
		if not localPlayer then return end
		print(FindEntity(a, 4, nil, {"player"}))
		print(distsq(a:GetPosition(), localPlayer:GetPosition()), 4 * 4) -- physics range doesn't matter in this case. just need half the entity as usual.
		print'--------'
	end)
	--]]
end)
--]==]

--[[
AddPrefabPostInit("deerclops", function(inst)
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

AddPrefabPostInit("insight_combat_range_indicator", import("helpers/attack_range").HookClientIndicator)
AddPrefabPostInit("insight_ghost_klaus_sack", function(inst)
	OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
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
	
	-- This is a client postinit so we can use this config method.
	local cfg = GetModConfigData("sinkhole_marks", true)
	if cfg == 0 then return end

	--OnLocalPlayerPostInit:AddWeakListener(function() GetInsight(localPlayer):RequestInformation(inst) end)
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
	-- This is a client postinit so we can use this config method.
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
	
	inst.snowball_range = SpawnPrefab("insight_range_indicator")
	inst.snowball_range:Attach(inst)
	inst.snowball_range:SetRadius(12 / WALL_STUDS_PER_TILE)
	inst.snowball_range:SetColour(Color.fromHex(Insight.COLORS.FROZEN))
	inst.snowball_range:SetVisible(true)

	--inst:AddComponent("dst_deployhelper")
	--inst.components.dst_deployhelper.onenablehelper = OnHelperStateChange
end)
--]]

Insight.prefab_descriptors("firesuppressor")
Insight.prefab_descriptors("sprinkler")
Insight.prefab_descriptors("basefan")

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

AddPrefabPostInit("yotr_rabbitshrine_placer", function(inst)
	--mprint'morsey'
end)

AddPrefabPostInit("lightning_rod_placer", function(inst)
	placer_postinit_fn(inst, 40 / WALL_STUDS_PER_TILE)
end)

AddPrefabPostInit("lightning_rod", function(inst) -- or i could just listen to any entity with tag "lightningrod"
	local config = GetModConfigData("lightningrod_range", true)

	if config == 0 then return end -- off

	if inst.components.deployhelper ~= nil then
		return
	end

	inst.lightningrod_range = SpawnPrefab("insight_range_indicator")
	inst.lightningrod_range:Attach(inst)
	inst.lightningrod_range:SetRadius(40 / WALL_STUDS_PER_TILE)
	inst.lightningrod_range:SetColour(Color.fromHex(Insight.COLORS.LIGHT))

	if config == 1 then	-- strategic
		inst.lightningrod_range:SetVisible(false)
		AddDeployHelper(inst)
		GetDeployHelper(inst).onenablehelper = OnHelperStateChange
	elseif config == 2 then -- always
		inst.lightningrod_range:SetVisible(true)
	else
		error("invalid config for lightning_range: " .. tostring(config))
	end
end)

Insight.prefab_descriptors("wortox_soul_spawn")

AddPlayerPostInit(function(player)
	if IS_DS then
		LoadLocalPlayer(player)

		--[[
		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			if context.config["blink_range"] then
				AttachBlinkRangeIndicator(player)
			end
		end)
		--]]

		player:ListenForEvent("newactiveitem", function(...)
			highlighting.SetActiveItem(...)
		end)

		local insight = GetInsight(player)
		for ent in pairs(delayed_actives) do
			insight:EntityActive(ent)
		end
		delayed_actives = {}

		CreatePlayerContext(
			player, 
			{
				vanilla = GenerateConfiguration(),
				external = GenerateExternalConfiguration(),
				complex = GenerateComplexConfiguration(),
			},
			{
				is_server_owner = true,
				locale = LOC.GetLocaleCode(),
			}
		)

		return
	end

	-- When swapping to wonkey in a client hosted world, ThePlayer is messed up.
	-- For the first print, it's the old character.
	-- Second print: wonkey
	-- Third print: old character
	-- All in that order. Yikes.

	--[[
	mprint("new player", player, "|", ThePlayer)
	player:ListenForEvent("setowner", function()
		mprint("new player2", player, "|", ThePlayer)
	end)

	player:DoTaskInTime(0, function()
		mprint("new player3", player, "|", ThePlayer)
	end)
	--]]

	
	AttachWigfridSongRangeIndicator(player)
	player:ListenForEvent("playeractivated", function()
		if player ~= ThePlayer then
			return
		end
		
		LoadLocalPlayer(player)

		OnLocalPlayerPostInit:AddWeakListener(function(insight, context)
			--[[
			if context.config["blink_range"] then
				AttachBlinkRangeIndicator(localPlayer)
			end
			--]]

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
			CreatePlayerContext(
				player, 
				{
					vanilla = GenerateConfiguration(),
					external = GenerateExternalConfiguration(),
					complex = GenerateComplexConfiguration(),
				},
				{
					is_server_owner = TheNet:GetIsServerOwner(),
					locale = LOC.GetLocaleCode(),
				}
			)
		end
		
		-- server shares this if client host
		SendConfigurationToServer()
	end)
end)

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ DeployHelper ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

	--[[
	local sizetbl = setmetatable({}, {__mode = "k"}) -- k, v, kv
	local oldSetSize = TextWidget.SetSize
	TextWidget.SetSize = function(self, sz)
		sizetbl[self] = sz
		return oldSetSize(self, sz)
	end

	TextWidget.GetSize = function(self, sz)
		return sizetbl[self]
	end
	--]]
end

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ EntityManager ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Status Announcements ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


--AddLocalPlayerPostRemove(attackRangeHelper.Deactivate, true)

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
	OnLocalPlayerPostInit:AddListener("statusannouncer_registerinterceptor", function(insight_replica, context)
		if not localPlayer.HUD._StatusAnnouncer or not localPlayer.HUD._StatusAnnouncer.RegisterInterceptor then
			return
		end

		-- Registering the interceptor under modname clears previous instances of it.
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
	end)
end

--[==[
OnLocalPlayerPostInit:AddListener(function()
	rawset(_G, "asd", true)
	GetPlayer():DoPeriodicTask(0, function()
		if asd then
			local sel = TheInput:GetAllEntitiesUnderMouse()[1]
			if sel then
				sel = sel.widget
			end

			if wowza then
				wowza:SetString("Selected Widget: " .. tostring(sel))
			end
			--[[
			for i,v in pairs(TheInput:GetAllEntitiesUnderMouse()) do
				mprint(i, v.widget)
			end
			mprint("-----------------------------")
			--]]
		end
	end)
end)
--]==]