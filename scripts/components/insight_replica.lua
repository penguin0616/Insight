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

setfenv(1, _G.Insight.env)
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local Indicators = import("indicators")
local cooking = require("cooking")

local Entity_HasTag = Entity.HasTag
local IS_CLIENT_HOST = IsClientHost()
local IS_CLIENT = IsClient()

--[[
	c_chestring({'spear', 'thulecite', 'redgem', 'bluegem', 'yellowgem', 'orangegem', 'purplegem', 'rocks', 'flint'})
	5 of c_prefabring('spear') in the center of the chestring
	
	highlighting went from 0.2 to 0.019
	aWOOOOOOOOOgah
]]



--------------------------------------------------------------------------
--[[ PerformanceRatings ]]
--------------------------------------------------------------------------
local PerformanceRatings = Class(function(self)
	self.ratings = {}
	self.client_id = nil
	self.host_id = nil
	self.last_update = nil

	self:Refresh()
end)

function PerformanceRatings:GetHost()
	return self.ratings.host or 0
end

function PerformanceRatings:GetClient()
	if self.client_id and self.client_id == self.host_id then
		return self:GetHost() -- hmmm
	end

	return self.ratings.client or 0
end

function PerformanceRatings:Refresh()
	local host_performance, my_performance

	if self.client_id == nil or self.host_id == nil then
		local client_table = TheNet:GetClientTable() or {}
		for i = 1, #client_table do
			local v = client_table[i]
			if v.performance then
				self.host_id = v.userid
			elseif v.userid == TheNet:GetUserID() then
				self.client_id = v.userid
			end
		end
	end

	host_performance = self.host_id and TheNet:GetClientTableForUser(self.host_id) or {} -- two pre-emptives
	my_performance = self.client_id and TheNet:GetClientTableForUser(self.client_id) or {}	-- two pre-emptives

	host_performance = host_performance.performance
	my_performance = my_performance.performance or my_performance.netscore

	self.last_update = GetTime()

	self.ratings = {
		host = host_performance or self:GetHost(),
		client = my_performance or self:GetClient()
	}
end

local function ClearDebounce(inst, self)
	self.entity_debounces[inst] = nil
end

local function SetDebounce(self, inst, debounce)
	if debounce then
		self.entity_debounces[inst] = inst:DoTaskInTime(debounce, ClearDebounce, self)
	else
		self.entity_debounces[inst] = true
	end
end
--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local function GotEntityInformation(inst, data)
	local insight = inst.replica.insight

	if not insight then
		mprint("[GotEntityInformation] Missing Insight Replica")
		return
	end

	--mprint("got:", #data.data, data.data:sub(#data.data-32))
	local safe, items = true, decompress(data.data)

	if not safe then
		return
	end

	for i = 1, #items do
		local data = items[i]
		-- GUIDs are numbers. not strings. 
		local guid = tonumber(data.GUID)
		local ent = entityManager.active_entity_lookup[guid] --entityManager:LookupGUID(guid)
		--dprint("SAVING FOR:", ent, guid)
		if ent then
			insight.entity_data[ent] = data
			if data.special_data.fuel or data.special_data.fueled or ent.replica.container or IsBundleWrap(ent) then
				--dprint("set entity awake", ent)
				highlighting.SetEntityAwake(ent)
			elseif data.special_data.worldmigrator then
				ent:PushEvent("insight_ready")
			end
		else
			--dprint("Received information for inactive entity")
		end
	end

	--[[
	local info = decompress(data.data)

	insight.entity_data[data.entity] = info
	
	for ent, data in pairs(ents) do
		insight.entity_data[ent] = data
		if ent.replica.container or IsBundleWrap(ent) then
			highlighting.SetEntityAwake(ent)
		end
	end
	--]]
end

GotEntityInformation = ProfilerWrap(GotEntityInformation, "GotEntityInformation")

-- Dirty functions
local function OnEntityNetworkActive(ent, self)
	--[[
	if self.entity_data[ent] == nil then -- outside our range of caring about.
		return
	elseif self.entity_data[ent].GUID ~= nil then -- has gotten info already.
		return
	end
	--]]
	ClearDebounce(ent, self)
	
	local config_enabled = self.context and (self.context.config["info_preload"] == 2 or (self.context.config["info_preload"] == 1 and ent.replica.container)) 

	if (ent.prefab == "cave_entrance_open" or ent.prefab == "cave_exit") or (config_enabled) then
		local a, b = self:RequestInformation(ent, (ent == ThePlayer and {RAW = true}) or nil)
		if not a then
			--dprint("Failed to query:", b, ent)
		else
			--dprint("Queried:", ent)
		end
	end
end

--------------------------------------------------------------------------
--[[ Insight ]]
--------------------------------------------------------------------------
local Insight = Class(function(self, inst)
	--mprint("Registering Insight replica for", inst, "but I am", ThePlayer)
	self.inst = inst
	self.ready = false

	self.menus = setmetatable({}, { __mode="kv" })

	self.entity_count = 0
	self.world_data = nil -- await
	self.entity_data = setmetatable({}, { __mode="k" }) -- {[entity] = {data}}
	self.entity_debounces = setmetatable({}, { __mode="kv" })
	self.entity_request_queue = {}

	self.hunt_target = nil
	self.danger_notification_data = {}
	self.pipspook_toys = {}
	self.pipspook_queue = setmetatable({}, { __mode="v" })
	
	if IS_DST then
		self.net_battlesong_active = net_bool(self.inst.GUID, "insight_battlesong_active", "insight_battlesong_active_dirty") -- 4283835343
	end

	if IS_DS or (IS_CLIENT_HOST and inst == ThePlayer) then
		self.ready = true
		self:SetupIndicators()
		self:BeginUpdateLoop()
	end

	if IS_DST then
		-- TODO: See if I can hit a classified missing with this
		mprintf("Insight Replica (%s) added for %s", self, self.inst)
		if TheWorld.ismastersim then
			self.classified = SpawnPrefab("insight_classified")
			self.classified.entity:SetParent(inst.entity)
			self.classified.Network:SetClassifiedTarget(self.inst)

			if IS_CLIENT_HOST then
				self.inst:ListenForEvent("insight_entity_information", GotEntityInformation)
			end
		elseif self.classified == nil and inst.insight_classified ~= nil then
			self:AttachClassified(inst.insight_classified)
			inst.insight_classified.OnRemoveEntity = nil
			inst.insight_classified = nil
		end
	end
end)

function Insight:__tostring()
	if self._string == nil then
		-- This is fine. 
		local x = getmetatable(self)
		setmetatable(self, nil)
		self._string = tostring(self)
		setmetatable(self, x)
	end

	return self._string .. " ~ [" .. tostring(self.inst) .. "]"
end

function Insight:OnRemoveFromEntity()
	mprintf("Insight Replica (%s) removed", self)
	if self.classified ~= nil then
		if TheWorld.ismastersim then
			self.classified = nil

			if IS_CLIENT_HOST then
				self:KillIndicators()
			end
		else
			self.classified:RemoveEventCallback("onremove", self.ondetachclassified)
			self:DetachClassified()
		end
	end
end

--------------------------------------------------------------------------
--[[ Netvar/classified related functions ]]
--------------------------------------------------------------------------

--- Attaches classified for networking
---@param ent EntityScript Classified instance
function Insight:AttachClassified(ent)
	if TheWorld.ismastersim then
		error("AttachClassified on server-side")
	end
	
	if self.classified ~= nil then
		error("Attempt to attach classified with one existing already.")
	end

	mprint("Attach classified", ent, "to", self.inst)

	-- Classified stuff
	self.classified = ent
	self.ondetachclassified = function() self:DetachClassified() end
	self.classified:ListenForEvent("onremove", self.ondetachclassified)

	self.ready = true

	-- So apparently, a classified can be detached and reattached in less than a second for an unknown reason (likely the same one)
	if not self.entity_data then
		self.entity_data = setmetatable({}, { __mode="k" }) -- {[entity] = {data}}
	end
	if self._shutdown_debug then
		mprint("!!!!!!!!!!!!!!! THIS IS NOT THE FIRST ATTACHMENT TO THE REPLICA")
	end

	-- Insight cool stuff
	self.inst:ListenForEvent("insight_entity_information", GotEntityInformation)
	self.performance_ratings = PerformanceRatings()
	self:SetupIndicators()
	self:BeginUpdateLoop()
	self:SetBattleSongActive(false)
end

--- Detaches classified
function Insight:DetachClassified(shutdown)
	if shutdown == nil then shutdown = true end
	assert(TheWorld.ismastersim == false, "DetachClassified on server-side")
	assert(self.classified, "Attempt to detach classified without existing one.")
	mprint("Detached classified", self.classified, "from", self.inst)

	--mprint(debugstack())

	-- Classified stuff
	self.classified:RemoveEventCallback("onremove", self.ondetachclassified)
	self.classified = nil
	self.ondetachclassified = nil
	
	if shutdown then
		self:Shutdown()
	end
end

function Insight:Shutdown()
	mprint("InsightReplica::Shutdown", self.inst)
	self.ready = false

	-- Insight cool stuff
	self.inst:RemoveEventCallback("insight_entity_information", GotEntityInformation)
	self:StopUpdateLoop()
	self:KillIndicators()
	self:SetBattleSongActive(false)

	if self.classified and TheWorld.ismastersim == false then
		-- Kill the classified early so Shutdown doesn't get called again by it when the classified gets removed
		self:DetachClassified(false)
	end

	-- Misc
	self.entity_data = nil

	self._shutdown_debug = true
end

--- Sets world data. 
---@param data_string string World data table encoded as json string
function Insight:SetWorldData(data_string)
	if self.classified ~= nil then
		-- ...Why don't I just move this to an RPC?
		self.classified.net_world_data:set(data_string)
	end
end

--- Sets naughtiness on netvar.
---@param str string String format can be represented as string.format("%d|%d", accumulated, threshold)
function Insight:SetNaughtiness(str)
	if self.classified ~= nil then
		self.classified.net_naughtiness:set(str)
	end
end

--- Removes an entity from the local cache.
---@param entity EntityScript
function Insight:InvalidateCachedEntity(entity)
	-- If this in DST, this will need to go through the netvar. 
	-- Otherwise, we can just handle it here.
	if IS_DST then
		if self.classified ~= nil then
			self.classified.net_invalidate:set_local(nil) -- force next :set() to be dirty
			self.classified.net_invalidate:set(entity)
		end
	else
		self:OnInvalidateCachedEntity(entity)
	end
end

--- Sets hunt target.
---@param target EntityScript The target entity that will be get an indicator. 
function Insight:SetHuntTarget(target)
	-- If this is DST, this will need to go through the netvar.
	-- In DS, we can directly send it through the handler.
	if IS_DST then
		self.classified.net_hunt_target:set(target)
	else
		self:OnHuntTargetDirty(target)
	end
end

--- Sets whether the player is currently singing.
---@param bool boolean
function Insight:SetBattleSongActive(bool)
	self.net_battlesong_active:set(bool)
end

--- Sets hunger rate.
---@param rate number
function Insight:SetHungerRate(rate)
	if not IS_DST then
		error("Insight_Replica::SetHungerRate only works in DST.")
		return
	end

	if self.classified ~= nil then
		self.classified.net_hunger_rate:set(rate)
	end
end

--- Sets the sanity rate.
---@param rate number
function Insight:SetSanityRate(rate)
	if not IS_DST then
		error("Insight_Replica::SetSanityRate only works in DST.")
		return
	end

	if self.classified ~= nil then
		self.classified.net_sanity_rate:set(rate)
	end
end

--- Sets the moisture rate.
---@param rate number
function Insight:SetMoistureRate(rate)
	if not IS_DST then
		error("Insight_Replica::SetMoistureRate only works in DST.")
		return
	end

	if self.classified ~= nil then
		self.classified.net_moisture_rate:set(rate)
	end
end

--- Sets moon cycle on netvar.
---@param int integer The current position in the moon cycle.
function Insight:SetMoonCycle(int)
	if self.classified ~= nil then
		self.classified.net_moon_cycle:set_local(int)
		self.classified.net_moon_cycle:set(int)
	end
end

--------------------------------------------------------------------------
--[[ Classified Handlers ]]
--------------------------------------------------------------------------
--- Called when we receive new naughtiness data.
---@param data table
function Insight:OnNaughtinessDirty(data)
	-- { actions = actions, threshold = threshold }
	self.inst:PushEvent("naughtydelta", data) -- This is an event that gets listened to by Combined Status
end

---
---@param entity EntityScript
function Insight:OnInvalidateCachedEntity(entity)
	-- This can trigger when going into the caves because the backpack container closes.
	-- The replica has shutdown by then.
	if not self.ready then
		return
	end

	--if true then return end
	--dprint("Invalidate", entity)
	self.entity_data[entity] = nil
	self.entity_request_queue[entity] = nil
	self:RequestInformation(entity)
end

--- Called when there needs to be a new hunt target.
---@param target EntityScript
function Insight:OnHuntTargetDirty(target)
	if not self.ready then
		mprint("Insight_Replica:OnHuntTargetDirty called but client isn't ready")
		mprint("LocalPlayer:", localPlayer)
		return
	end

	if self.hunt_target then
		self:StopTrackingEntity(self.hunt_target)
		self.hunt_target = nil
	end

	if not target then
		return
	end

	self.hunt_target = target
	self:StartTrackingEntity(target, { 
		removeOnFound = target.components.health ~= nil or (target.replica and target.replica.health ~= nil) 
	})
end

--- Called when there's a new hunger rate.
---@param rate number
function Insight:OnHungerRateDirty(rate)
	self.current_hunger_rate = rate

	local hunger_badge = table.getfield(self.inst, "HUD.controls.status.stomach")
	if hunger_badge and hunger_badge.insight_rate then
		hunger_badge.insight_rate:SetString(string.format("%+.1f/min", rate * 60))
	end
end

--- Called when there's a new sanity rate.
---@param rate number
function Insight:OnSanityRateDirty(rate)
	self.current_sanity_rate = rate

	local sanity_badge = table.getfield(self.inst, "HUD.controls.status.brain")
	if sanity_badge and sanity_badge.insight_rate then
		sanity_badge.insight_rate:SetString(string.format("%+.1f/min", rate * 60))
	end
end

--[[
--- Called when there's a new health rate.
---@param rate number
function Insight:OnHealthRateDirty(rate)
	self.current_health_rate = rate

	local health_badge = table.getfield(self.inst, "HUD.controls.status.heart")
	if health_badge and health_badge.insight_rate then
		health_badge.insight_rate:SetString(string.format("%+.1f/min", rate * 60))
	end
end
--]]

--- Called when there's a new moisture rate.
---@param rate number
function Insight:OnMoistureRateDirty(rate)
	self.current_moisture_rate = rate

	local moisture_badge = table.getfield(self.inst, "HUD.controls.status.moisturemeter")
	if moisture_badge and moisture_badge.insight_rate then
		moisture_badge.insight_rate:SetString(string.format("%+.1f/min", rate * 60))
	end
end
--------------------------------------------------------------------------
--[[ Methods ]]
--------------------------------------------------------------------------

--- Initializes indicators.
function Insight:SetupIndicators()
	assert(self.indicators == nil, "Attempt to setup indicators more than once")
	self.indicators = Indicators(self.inst)
end

function Insight:KillIndicators()
	--assert(self.indicators, "Attempt to kill nonexistant indicators")
	if self.indicators then
		self.indicators:Kill()
		self.indicators = nil
	end
end

--- Starts the main information loop.
function Insight:BeginUpdateLoop()
	if self.updating then
		error("Attempt to begin update loop more than once")
		return
	end

	self.updating = true
	mprintf("\tInsight replica (%s) update loop has begun", self)

	self.inst:StartUpdatingComponent(self)

	-- self.inst:StartUpdatingComponent(self)
	-- hud was sometimes missing in OnUpdate
	self.update_task = self.inst:DoPeriodicTask(4/10, function(inst)
		self:HUDUpdate()
		if self.performance_ratings then
			self.performance_ratings:Refresh()
		end
	end)

	if IS_CLIENT then
		-- Request Entity Information queuer
		-- 0.1 vs FRAMES (1/30) -- 0.03333
		local num_server_mods = #ModManager:GetEnabledServerModNames()
		local delay = FRAMES * 2 -- 0.1 == 1/10
		self.request_task = self.inst:DoPeriodicTask(delay, function()
			ProfilerPush("InformationRequestTask")
			local idx = 1
			local array = {}
			local params_array = {}

			--[[
			local total_count = GetTableSize(self.entity_request_queue)
			if total_count > 0 then
				dprint("queue size:", total_count)
			end
			--]]

			-- max rpc arguments is 50

			-- So normally, I would put the params at the last available space.
			-- However, I wouldn't be able to fully unpack the array.
			-- So what I'm doing is starting the idx 1 higher than it should, and [1] will get filled in later.
			for ent, params in pairs(self.entity_request_queue) do
				params_array[idx] = EncodeRequestParams(params) -- Use "real" idx
				idx = idx + 1
				array[idx] = ent -- Use "fake" idx

				--[[
				if not ent.entity:IsValid() then
					mprint("wagh", ent)
					mprint(self.entity_data[ent])
				end
				--]]
				
				self.entity_request_queue[ent] = nil

				if idx >= 50 then
					break
				end
			end

			-- Without this, #array would return 0. Now, if the array has anything it, it'll return the "desired length" (number of elements + the nil)
			-- If not, #array will still return 0.
			array[1] = nil

			if #array > 0 then
				-- Normally, I would keep the params at the last but if I do then we can't fully unpack the array.
				-- So everything has to get shifted up.
				array[1] = table.concat(params_array, "|")
				--mprint("\t\t", params_array[1], ":::::", params_array[2], ":::::", table.concat(params_array, "|"))
				--mprint("\t\tunpack", unpack(array))
				rpcNetwork.SendModRPCToServer(GetModRPC(modname, "RequestEntityInformation"), unpack(array))
			end
			
			ProfilerPop()
		end)
	end
end

function Insight:StopUpdateLoop()
	if not self.updating then
		return
	end

	self.inst:StopUpdatingComponent(self)

	self.update_task:Cancel()
	self.update_task = nil

	mprintf("\tInsight replica (%s) update loop has stopped", self)

	if self.request_task then
		self.request_task:Cancel()
		self.request_task = nil
	end
	self.updating = false
end










function Insight:OnEntityGotInformation(ent)
	-- Only meant for use in DS
	local data = self.entity_data[ent]
	if not data or not data.special_data then
		return nil
	end
	if data.special_data.fuel or data.special_data.fueled or ent.components.container or IsBundleWrap(ent) then
		--dprint("set entity awake", ent)
		highlighting.SetEntityAwake(ent)
	end
end



function Insight:PipspookToyFound(inst) 
	local network_id = inst.Network:GetNetworkID()

	local toy_data = util.table_find(self.pipspook_toys, function(t) return t.network_id == network_id end) -- ISSUE:PERFORMANCE (TEST#8)

	if toy_data == nil then
		if not table.contains(self.pipspook_queue, inst) then
			table.insert(self.pipspook_queue, inst)
		end
		
		-- assume its not ours
		dprint("\tmissing toy data", inst)
		return
	end

	if toy_data.owner ~= self.inst.name then
		dprint("\ttoy not ours")
		-- definitely not ours
		return
	end

	local indicator = self.indicators:Get(toy_data.vector)
	if indicator then
		indicator.config_data.name = nil
		indicator:SetTarget(inst)
	else 
		--mprint("can't find indicator with vector for pipspook")

		--dprint("yessir", inst)
		-- already exists
		local img_data = ResolvePrefabToImageTable("trinket_" .. string.match(inst.prefab, "_(%d+)$"))
		local yep = { pipspook=true, tex=img_data.tex, atlas=img_data.atlas }

		self:StartTrackingEntity(inst, yep)
	end

	inst.marker = SpawnPrefab("insight_range_indicator")
	inst.marker:Attach(inst)
	inst.marker:SetRadius(TUNING.GHOST_HUNT.TOY_FADE.IN / WALL_STUDS_PER_TILE)
	--inst.marker:SetColour(Color.fromHex(Insight.COLORS.FROZEN))
	inst.marker:SetVisible(true)


	--[[
	if util.table_find(self.pipspook_toys, function(q) return GetEntityDebugData(q).network_id == inst.network_id end) then
		self:StartTrackingEntity(inst, ResolvePrefabToImageTable("trinket_" .. string.match(inst.prefab, "_(%d+)$")))

		inst.marker = SpawnPrefab("insight_range_indicator")
		inst.marker:Attach(inst)
		inst.marker:SetRadius(3 / WALL_STUDS_PER_TILE)
		--inst.marker:SetColour(Color.fromHex(Insight.COLORS.FROZEN))
		inst.marker:SetVisible(true)
	else
		mprint("pipspook missing ref for", inst)
	end
	--]]

	--mprint("spawned", inst, network_id, table.contains(GetInsight(localPlayer).pipspook_toys, network_id))
end

function Insight:HandlePipspookQuest(data, ...)
	dprint("handle begin", data.state, ...)
	if data.state == "begin" then
		self.pipspook_toys = data.toys

		for i,v in pairs(self.pipspook_toys) do
			-- v { network_id=network_id, position=Vector3 }
			local toy = util.table_find(self.pipspook_queue, function(q) return q.Network:GetNetworkID() == v.network_id end) -- ISSUE:PERFORMANCE (TEST#8)

			if toy then
				-- toy already exists
				--[[
				local toy = table.remove(self.pipspook_queue, index)

				local img_data = ResolvePrefabToImageTable("trinket_" .. string.match(toy.prefab, "_(%d+)$"))
				local yep = { tex=img_data.tex, atlas=img_data.atlas }

				self:StartTrackingEntity(toy, yep)
				--]]

				self:PipspookToyFound(toy) -- table.remove(self.pipspook_queue, index)
			elseif v.owner == self.inst.name then
				mprint("track vector:", v.prefab)
				-- toy does not exist
				local img_data = ResolvePrefabToImageTable("trinket_" .. string.match(v.prefab, "_(%d+)$"))
				local yep = { pipspook=true, tex=img_data.tex, atlas=img_data.atlas, name="<color=#aaaaaa>(Distant)</color> " .. v.display_name, vector=Vector3(v.position.x, v.position.y, v.position.z), max_distance=3000 }
				v.vector = yep.vector

				self:StartTrackingEntity(yep.vector, yep)
			end
		end

		--[[
		while #self.pipspook_queue > 0 do
			local q = table.remove(self.pipspook_queue, 1)
			
			self:StartTrackingEntity
		end
		--]]

		--[[
		for i = 1, select("#", ...) - offset do
			local toy = select(i, ...)

			if toy then
				local thing = ResolvePrefabToImageTable("trinket_" .. string.match(toy.prefab, "_(%d+)$"))
				self:StartTrackingEntity(toy, thing)
				mprint("tracking", toy)
			else
				mprint("missing toy")
			end
		end
		--]]
	elseif data.state == "end" then
		for i,v in pairs(self.indicators.indicators) do
			if v.config_data.pipspook then
				self.indicators:RemoveNextUpdate(v.target)
			end
		end

		self.pipspook_toys = {}
		self.pipspook_queue = setmetatable({}, { __mode="v" })
	end
end

function Insight:AddDeathSpot(x, y, z)
	if not self.context or not self.context.config["death_indicator"] then
		return
	end

	local data = { 
		name = "Your Death Spot", 
		vector = Vector3(x, y, z), 
		max_distance = 9e9,
		dismissable = true,
		tex = "Skeleton.tex",
		atlas = "images/Skeleton.xml",
	}

	self:StartTrackingEntity(data.vector, data)
end

function Insight:DoesFuelMatchFueled(fuel, fueled)
	if IS_DS or IS_CLIENT_HOST then
		if fuel.components.fuel and fueled.components.fueled then
			return fueled.components.fueled:CanAcceptFuelItem(fuel)
		end
	else
		-- This doesn't work in client hosted. So I just added client host to the check above.

		local ed_fuel = self.entity_data[fuel]
		--local ed_fuel = self:GetInformation(fuel)
		local ed_fueled = self.entity_data[fueled]
		--local ed_fueled = self:GetInformation(fueled)

		if not ed_fuel or not ed_fuel.GUID then
			self:RequestInformation(fuel, { debounce=1 })
		end
		if not ed_fueled or not ed_fueled.GUID then
			self:RequestInformation(fueled, { debounce=1 })
		end

		--[[
			function Fueled:CanAcceptFuelItem(item)
				return self.accepting and item and item.components.fuel and (item.components.fuel.fueltype == self.fueltype or item.components.fuel.fueltype == self.secondaryfueltype)
			end

		]]

		-- so much repetion makes this harder to read
		if ed_fuel and ed_fuel.special_data.fuel and ed_fueled and ed_fueled.special_data.fueled then
			return 
				ed_fueled.special_data.fueled.accepting and 
				(ed_fuel.special_data.fuel.fueltype == ed_fueled.special_data.fueled.fueltype or ed_fuel.special_data.fuel.fueltype == ed_fueled.special_data.fueled.secondaryfueltype)

			
		end
	end

	return false
end

function Insight:BundleHasPrefab(inst, prefab, isSearchingForFoodTag)
	local info = self:GetInformation(inst)

	if not info then
		self:RequestInformation(inst, { debounce=1 })
		return nil
	end

	-- Only time this will ever be nil is if there's a netvar desync.
	if not info.special_data["unwrappable"] then
		mprintf("Missing unwrappable information for [%s]", inst)
		return false
	end

	local contents = info.special_data["unwrappable"].contents
	for i = 1, #contents do
		local v = contents[i]
		if isSearchingForFoodTag == true then
			-- prefab arg is the food tag here
			if cooking.ingredients and cooking.ingredients[v.prefab] and cooking.ingredients[v.prefab].tags and cooking.ingredients[v.prefab].tags[prefab] then
				return true
			end
		elseif (not isSearchingForFoodTag and v.prefab == prefab) then --if AreEntityPrefabsEqual(inst, prefab) then
			return true
		end
	end

	return false
end

--- Checks if a container has something.
---@param container EntityScript
---@param inst EntityScript This is whatever is being searched for.
---@param isSearchingForFoodTag boolean
function Insight:ContainerHas(container, inst, isSearchingForFoodTag)
	--TheSim:ProfilerPush("ContainerHas")
	-- container is a container inst
	-- can't i just use the default container methods in DS?
	local prefab = inst.prefab
	if not prefab then
		if type(inst) ~= "string" then
			error("invalid container")
			return
		end
		prefab = inst
	end

	local is_unwrappable = not isSearchingForFoodTag and IsBundleWrap(inst)

	local container_info = self:GetInformation(container)
	local bundle_info
	--dprint("container:", container, container_info)

	-- Load Container Info
	if container_info == nil then
		--mprint("container info nil")
		self:RequestInformation(container, { debounce=1 }) -- issue with doing this in DS is that it all happens on the same runstack so it'll end up returning true then returning nil in the same original call
		-- explains alot
		--dprint(container, container:IsValid(), "missing container info")
		--TheSim:ProfilerPop()
		return nil -- 0
	end

	-- Load Bundle Info (pretty unlikely its not present already)
	if is_unwrappable then
		bundle_info = self:GetInformation(inst)
		if not bundle_info then
			self:RequestInformation(inst, { debounce=1 })
			--dprint(inst, "missing bundle info")
			--TheSim:ProfilerPop()
			return nil
		end
	end

	--dprint("begin searching", container, "for", inst)

	-- resolved named stuff (avoid IsPrefab check for overhead)
	local inst_name = inst and ( (inst.components and inst.components.named) or (inst.replica and inst.replica.named) )
	inst_name = (inst_name and inst.name) or ""

	-- for is_unwrappable
	local things = {}

	--push("ContainerHas")
	-- i check for is_unwrappable to provide the opportunity for non-bundles to terminate faster
	if not container_info.special_data["container"] then
		-- Okay, so this will happen if the server receives an information request from a client that hasn't sent their config yet.
		-- Commonly seen from cases with swapping players (see discussion with Niko), 
		-- requires split second timing to get the client to send a request to the server AFTER client is loaded but BEFORE server gets the context for the new player.

		-- Some options for mitigation:
		-- 1. Server detects player swapping and moves the context from the old player to the new player (see event ms_playerseamlessswaped)
		-- 		Could listen for the event on a player and when it triggers, find the new player (maybe through client table or something)
		--		This seems like the most reasonable approach and would be nice if nice if I implemented it with the addition of option #2.

		-- 2. Update RPCs to consolidate ClientInitialized and ProcessConfiguration into a single RPC that supports different operations
		--		Could be complex but would allow easier expansion later on if I decide to have encourage more handshake-like behaviour

		-- 3. Mark context-less requests from the server as invalid and have the client dump them or do some other logic with them
		-- 		This feels hacky and weird. We might as well just not have the server respond to the request if that's the case.

		-- 4. Whatever! (winner)
		-- 		Since this is the only place hitting a crash with specific evaluations of data from the server (we know what the special_data is supposed to be),
		--		We can just return nil here and call it a day. In the future though, option #2+#1 seems like a pretty good idea but I don't have time for that right now.


		-- This also seems to happen with sunken chests?
		mprint("!!!!!!!!!!!!!!!!!!!!! DUMPING CONTAINER")
		dumptable(container_info)

		return nil
	end

	local contents = container_info.special_data["container"].contents
	for i = 1, #contents do -- explore the inside of the container
		local v = contents[i]
		-- v { prefab=v.prefab, stacksize=stacksize, contents=unwrappable_contents, name=name } 

		if v.contents then -- there is a bundle for this slot
			--print("hey this chest", container, "has a bundle", v)

			-- check the contents of the bundle
			for j = 1, #v.contents do
				local k = v.contents[j]
				if is_unwrappable and k.prefab then -- if what the original thing we were searching for is a bundle
					things[k.prefab .. (k.name or "")] = true
				elseif k.prefab then
					if isSearchingForFoodTag == true then
						-- k.prefab == inventoryitem
						-- prefab == food_tag
						if cooking.ingredients and cooking.ingredients[k.prefab] and cooking.ingredients[k.prefab].tags and cooking.ingredients[k.prefab].tags[prefab] then
							--pop()
							return true
						end
					-- if the original thing we were searching for is an inventoryitem
					--print(k.prefab .. (k.name or ""), prefab .. inst_name)
					elseif not isSearchingForFoodTag and (k.prefab .. (k.name or "")) == (prefab .. inst_name) then -- compare to see if inventoryitem.prefab .. inventoryitem.name == search_for.prefab .. search_for.name
						--pop()
						return true
					end
				end
			end
		else -- there is a inventoryitem for this slot

			-- only check the inst
			if is_unwrappable then
				things[v.prefab .. (v.name or "")] = true
			else
				if isSearchingForFoodTag == true then
					-- v.prefab == inventoryitem
					-- prefab == food_tag
					if cooking.ingredients and cooking.ingredients[v.prefab] and cooking.ingredients[v.prefab].tags and cooking.ingredients[v.prefab].tags[prefab] then
						--pop()
						return true
					end
				elseif not isSearchingForFoodTag and (v.prefab .. (v.name or "")) == (prefab .. inst_name) then
					--pop()
					return true
				end
			end
		end
	end

	
	if is_unwrappable then
		local bundle_contents = bundle_info.special_data["unwrappable"].contents
		--mprint(DataDumper(bundle_info.special_data["unwrappable"]))

		for i = 1, #bundle_contents do
			local v = bundle_contents[i]
			if v.prefab and things[v.prefab .. (v.name or "")] then
				--pop()
				return true
			end
		end
	end
	
	--TheSim:ProfilerPop()
	return false
end

function Insight:GetWorldInformation()
	if IS_DST then
		rpcNetwork.SendModRPCToServer(GetModRPC(modname, "GetWorldInformation"))

		return self.world_data
	else
		--mprint("DS Get World Information")
		local data = GetWorldInformation(self.inst)
		self.world_data = data
		return self.world_data
	end
end

function Insight:GetInformation(item)
	local data = self.entity_data[item]
	if data and data.GUID ~= nil then -- GUID is nil until it gets some data set
		return data
	end
end

function Insight:RequestInformation(entity, params)
	params = params or { RAW=true }

	if IS_DST and not self.classified then
		mprint("Missing classified")
		--print(debugstack())
		return false, "NO_CLASSIFIED"
	end

	if TRACK_INFORMATION_REQUESTS then
		dprint("Client requesting information for", entity)
	end

	--if true then mprint("requestinfo denied client") return nil end

	-- Calculate Params

	if not IS_DS and entity.Network == nil then -- not networked
		--dprint('rejected', entity, self.entity_debounces[entity])
		return false, "NOT_NETWORKED"
	end

	-- check if there is a debounce
	if self.entity_debounces[entity] then
		--dprint('rejected', entity, self.entity_debounces[entity])
		return false, "DEBOUNCE"
	end

	-- check context
	local context = self.context
	if not context then
		-- cant do anything without context
		dprint('Insight:RequestEntityInformation missing context')
		return false, "NO_CONTEXT"
	end

	--[[
	if not self.entity_data[entity] then
		--dprint("requesting information for unregistered entity:", entity)
		return
	end
	--]]

	params.GUID = entity.GUID

	-- check for debounces
	--mprint("context", context)
	--table.foreach(context, mprint)
	local debounce = params.debounce or context.config["refresh_delay"]
	
	if debounce == true then
		local host = self.performance_ratings and self.performance_ratings:GetHost() or 0
		local client = self.performance_ratings and self.performance_ratings:GetClient() or 0
		local ents = math.floor(self:CountEntities() / 1000) -- (2000 - host * 500) -- host? client? who knows which is better.
		local plrs = TheNet and math.ceil(#(TheNet:GetClientTable() or {}) / 4) or 0
		-- min is 170, max seen is 3370
		
		debounce = (0.50 * host) + (1/3 * client) + (0.125 * ents) + (0.125 * plrs)
	elseif type(debounce) == "string" then
		debounce = debounce:gsub("_", ".")
		debounce = tonumber(debounce)
	elseif type(debounce) == "number" and debounce >= 0 then
		-- good
	else
		mprint("debounce set to 0 in weird case.", tostring(debounce), type(debounce))
		--error("debounce set to 0 in weird case.")
		--debounce = 0
		return false, "WEIRD_DEBOUNCE_CASE"
	end

	if debounce == nil then
		local orig = params.debounce or context.config["refresh_delay"]
		mprintf("(Something's broken?): Debounce is nil: [%s] (%s)", tostring(orig), type(orig))
	end

	if debounce and debounce > 0 then
		SetDebounce(self, entity, debounce)
	end

	params.debounce = nil

	if IS_DS then
		-- we don't care about the rest of this in DS
		
		-- push this to the next frame to simulate the delay in DST
		--RequestEntityInformation(entity, self.inst, params)
		entity:DoTaskInTime(0, RequestEntityInformation, self.inst, params) 
		return true
	end

	--SendModRPCToServer(GetModRPC(modname, "RequestEntityInformation"), entity, params)
	if IS_CLIENT then
		self.entity_request_queue[entity] = params
	else
		RequestEntityInformation(entity, self.inst, params)
		return true, "ClientHost directly calling RequestEntityInformation"
	end

	return true
end

-- entity functions
function Insight:EntityInactive(ent)
	if not self.ready then
		mprint("InsightReplica: EntityActive called when not ready", self.inst, "|", ent)
		return
	end
	--[[
	if self.entity_data[ent] == nil then
		dprint("attempt to sleep nonregistered entity", ent)
		return
	end
	--]]

	--dprint('inactive', ent)
	assert(IS_DST, "Insight:EntityInactive called outside DST")
	
	self.entity_data[ent] = nil
	self.entity_request_queue[ent] = nil -- No need to botch an entire RPC send because there was invalid data in it.
	--self.entity_count = self.entity_count - 1
end

function Insight:EntityActive(ent)
	if not self.ready then
		mprint("InsightReplica: EntityActive called when not ready", self.inst, "|", ent)
		return
	end

	if self.entity_data[ent] then
		--dprint("attempt to reawaken existing entity", ent)
		return
	end

	if DEBUG_ENABLED then assert(IS_DST, "Insight:EntityActive called outside DST") end

	self.entity_data[ent] = {
		GUID = nil,
		information = nil,
		special_data = {},
	}

	--self.entity_count = self.entity_count + 1

	--print(ent, Entity_HasTag(ent.entity, "INLIMBO"), ent.entity:GetDebugString())
	local delay = ((ent.prefab == "cave_entrance_open" or ent.prefab == "cave_exit" or false) and 0) or math.random(3, 10) / (TheWorld.ismastersim and 4 or 10)
	if delay > 0 then
		SetDebounce(self, ent)
	end
	--dprint('active', ent, delay)
	ent:DoTaskInTime(delay, OnEntityNetworkActive, self)
end

function Insight:CountEntities()
	return self.entity_count
end

-- tracker functions
function Insight:StartTrackingEntity(ent, data)
	if not self.indicators then
		mprint("!!!!!!!!!!!!! Attempt to start tracking entity while missing indicators")
		return
	end

	if self.indicators:Get(ent) then
		dprint("attempt to stack indicators for", ent)
		return
	end

	data = data or {}
	--local exists, tex, atlas = PrefabHasIcon(ent.prefab)
	if data.tex == nil and data.atlas == nil then
		local tbl = ent.prefab and ResolvePrefabToImageTable(ent.prefab)

		if tbl and tbl.tex and tbl.atlas then
			data.tex = tbl.tex
			data.atlas = tbl.atlas
		end
	end

	return self.indicators:Add(ent, data)
end

function Insight:StopTrackingEntity(ent)
	self.indicators:Remove(ent)
end

function Insight:MaintainMenu(insight_menu)
	table.insert(self.menus, insight_menu)
	self:HUDUpdate()
end

function Insight:OnUpdate(dt)
	if highlighting.activated and highlighting.OnUpdate then
		highlighting.OnUpdate(dt)
	end

	local HUD = self.inst.HUD
	

	if (IS_DST and not TheWorld.ismastersim) and 
		(HUD and HUD.controls.inv and HUD.controls.inv.equip) and 
		self.context and (self.context.config["itemtile_display"] == "numbers" or self.context.config["itemtile_display"] == "mixed") then
		-- only needs to be refreshed if a client, mastersim host gets free updates by nature of being the sim
		-- (APP_VERSION 478130, September 11 2021) this was in place to refresh usages for equipped items, so waiting on a percent change wasn't needed.
		-- however, this eventually calls inventoryitem_classified:DeserializeRecharge() and :DeserializeRechargeTime()
		-- these methods will trigger OnRechargeDirty, which replaces the stored inst._recharge with the netvar's value (inst.recharge:value() == 0)
		-- this continually resets the recharge back to 0, because inst.recharge:value() is 0 as it is never updated
		-- HUD.controls.inv:Refresh()
		for slotname, itemslot in pairs(HUD.controls.inv.equip) do
			local item = itemslot.tile and itemslot.tile.item
			if item then
				local classified = item.replica and item.replica.inventoryitem and item.replica.inventoryitem.classified
				if classified then
					if classified.DeserializePercentUsed then
						classified:DeserializePercentUsed()
					end
					if classified.DeserializePerish then
						classified:DeserializePerish()
					end

					--if SIM_DEV then
					--classified:DeserializeRecharge() -- messes up rechargeable
					--classified:DeserializeRechargeTime() -- messes up rechargeable
					--end
				end
			end
		end
	end
end

function Insight:HUDUpdate()
	if not self.updating then
		return
	end

	local HUD = self.inst.HUD

	if not HUD then
		mprint("Insight:HUDUpdate missing HUD")
		--table.foreach(self.inst, mprint)
		--mprint("===============================================================================================================================================")
		return
	end
	-- TheWorld and related analyzation
	local world_data = self:GetWorldInformation()
	self:RequestInformation(self.inst, { RAW=true })
	local player_data = self:GetInformation(self.inst)

	for i,v in pairs(self.menus) do
		if v.inst:IsValid() then -- might not be gc'd yet
			v:ApplyInformation(world_data, player_data)
		end	
	end

	if IS_DST and world_data and self.context and self.context.config["danger_announcements"] then
		for component, special_data in pairs(world_data.special_data) do
			-- Check if this is a boss spawner.
			if special_data and _G.Insight.descriptors[component] and _G.Insight.descriptors[component].DangerAnnouncementDescribe then
				-- Register the component in the notification data table
				local noti_data = self.danger_notification_data[component]
				if not self.danger_notification_data[component] then
					noti_data = {}
					self.danger_notification_data[component] = noti_data
				end

				-- Check if warning is different than the saved warning (which may not exist, but counts as 'false')
				if special_data.warning and noti_data.warning ~= special_data.warning then
					-- We've newly entered the warning phase.
					local str, typ = _G.Insight.descriptors[component].DangerAnnouncementDescribe(special_data, self.context)
					if str then
						local dangertype = typ and self.context.lstr.danger_announcement[typ] or self.context.lstr.danger_announcement.generic
						str = dangertype .. ProcessRichTextPlainly(str)
						local a = ChatHistory:AddToHistory(ChatTypes.Announcement, nil, nil, "InsightServer", str, WHITE, "insight", nil, true)
					end
				end

				noti_data.warning = special_data.warning
			end
		end
	end

	if self.context and (self.context.config["itemtile_display"] == "numbers" or self.context.config["itemtile_display"] == "mixed") then
		for _, itemslot in pairs(GetItemSlots()) do
			local item = itemslot.tile and itemslot.tile.item
			if item then
				local classified = item.replica and item.replica.inventoryitem and item.replica.inventoryitem.classified
				if classified then
					if classified.DeserializePercentUsed then
						classified:DeserializePercentUsed()
					end
					if classified.DeserializePerish then
						classified:DeserializePerish()
					end
				end
			end
		end
	end

	--[==[
	local inventoryBar = HUD.controls.inv
	for i = 1, #inventoryBar.inv do
		local itemslot = inventoryBar.inv[i]
		local item = itemslot.tile and itemslot.tile.item
		if item then
			local classified = item.replica and item.replica.inventoryitem and item.replica.inventoryitem.classified
			if classified then
				if classified.DeserializePercentUsed then
					classified:DeserializePercentUsed()
				end
				if classified.DeserializePerish then
					classified:DeserializePerish()
				end
			end
		end
	end

	--[[
	for _, c in pairs(localPlayer.HUD.controls.containers) do
		if c and c.inv then
			for i = 1, #c.inv do
				local v = c.inv[i]
				if v then
					len_slots = len_slots + 1
					slots[len_slots] = v
				end
			end
		end
	end
	--]]

	local backpackInventory = inventoryBar.backpackinv
	for i = 1, #backpackInventory do
		local itemslot = backpackInventory[i]
		local item = itemslot.tile and itemslot.tile.item
		if item then
			local classified = item.replica and item.replica.inventoryitem and item.replica.inventoryitem.classified
			if classified then
				if classified.DeserializePercentUsed then
					classified:DeserializePercentUsed()
				end
				if classified.DeserializePerish then
					classified:DeserializePerish()
				end
			end
		end
	end
	--]==]
	
	if IS_DST and HUD.controls.insight_menu and TheInput:ControllerAttached() then
		if HUD.controls.insight_menu.shown then
			HUD.controls.insight_menu:Hide()
		end
	end

	-- indicators
	self.indicators:OnUpdate()
end



return Insight