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
local IS_DST = IsDST()
local IS_DS = IsDS()
local IS_CLIENT_HOST = IsClientHost()

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

	self.menus = setmetatable({}, { __mode="kv" })

	self.entity_count = 0
	self.world_data = nil -- await
	self.entity_data = setmetatable({}, { __mode="k" }) -- {[entity] = {data}}
	self.entity_debounces = setmetatable({}, { __mode="kv" })

	self.hunt_target = nil
	self.tracked_entities = {}
	self.pipspook_toys = {}
	self.pipspook_queue = setmetatable({}, { __mode="v" })
	
	if IS_DST then
		self.net_battlesong_active = net_bool(self.inst.GUID, "insight_battlesong_active", "insight_battlesong_active_dirty") -- 4283835343
	end

	if IS_DS or IS_CLIENT_HOST then
		self:SetupIndicators()
	end

	if IS_DST then
		if TheWorld.ismastersim then
			self.classified = inst.insight_classified
		elseif self.classified == nil and inst.insight_classified ~= nil then
			self:AttachClassified(inst.insight_classified)
		end
	end
end)

function Insight:OnRemoveFromEntity()
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
-- @tparam EntityScript ent
function Insight:AttachClassified(ent)
	assert(TheWorld.ismastersim == false, "AttachClassified on server-side")
	assert(self.classified == nil, "Attempt to attach classified with one existing already.")

	-- Classified stuff
	self.classified = ent
	self.ondetachclassified = function() self:DetachClassified() end
	self.classified:ListenForEvent("onremove", self.ondetachclassified)

	-- Insight cool stuff
	self.performance_ratings = PerformanceRatings()
	self.entity_request_queue = {}
	self:SetupIndicators()
	
	self:ListenForEvent("insight_entity_information", GotEntityInformation)

	self:BeginUpdateLoop()
	self:SetBattleSongActive(false)
end

--- Detaches classified
function Insight:DetachClassified()
	assert(TheWorld.ismastersim == false, "DetachClassified on server-side")
	assert(self.classified, "Attempt to detach classified without existing one.")
	error("Why is this happening?")

	self.classified = nil
	self.ondetachclassified = nil
	
	self:KillIndicators()
	self:StopUpdateLoop()
end

--- Sets world data. 
-- @tparam string data_string World data table encoded as json string
function Insight:SetWorldData(data_string)
	if self.classified ~= nil then
		-- ...Why don't I just move this to an RPC?
		self.classified.net_world_data:set(data_string)
	end
end

--- Sets naughtiness on netvar.
-- @tparam string str String format can be represented as string.format("%d|%d", accumulated, threshold)
function Insight:SetNaughtiness(str)
	if self.classified ~= nil then
		self.classified.net_naughtiness:set(str)
	end
end

--- Removes an entity from the local cache.
-- @tparam EntityScript entity
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
-- @tparam EntityScript target The target entity that will be get an indicator. 
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
-- @tparam bool bool
function Insight:SetBattleSongActive(bool)
	self.net_battlesong_active:set(bool)
end

--- Sets moon cycle on netvar.
-- @tparam integer int The current position in the moon cycle.
function Insight:SetMoonCycle(int)
	if self.classified ~= nil then
		self.classified.net_moon_cycle:set_local(int)
		self.classified.net_moon_cycle:set(int)
	end
end

--------------------------------------------------------------------------
--[[ Classified Handlers ]]
--------------------------------------------------------------------------

---
-- @tparam EntityScript entity
function Insight:OnInvalidateCachedEntity(entity)
	self.entity_data[entity] = nil
	self:RequestInformation(entity)
end

--- Called when there needs to be a new hunt target.
-- @tparam EntityScript target
function Insight:OnHuntTargetDirty(target)
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

--------------------------------------------------------------------------
--[[ Methods ]]
--------------------------------------------------------------------------

--- Initializes indicators.
function Insight:SetupIndicators()
	assert(self.indicators == nil, "Attempt to setup indicators more than once")
	self.indicators = Indicators(inst)
end

function Insight:KillIndicators()
	assert(self.indicators, "Attempt to kill nonexistant indicators")
	self.indicators:Kill()
	self.indicators = nil
end

--- Starts the main information loop for DST.
function Insight:BeginUpdateLoop()
	if self.updating then
		error("Attempt to begin update loop more than once")
		return
	end

	self.updating = true
	mprint("\tInsight replica update loop has begun")

	-- self.inst:StartUpdatingComponent(self)
	-- hud was sometimes missing in OnUpdate
	self.update_task = self.inst:DoPeriodicTask(1, function(inst)
		self:Update()
		if self.performance_ratings then
			self.performance_ratings:Refresh()
		end
	end)

	if IsClient() then
		-- Request Entity Information queuer
		self.request_task = self.inst:DoPeriodicTask(0.1, function()
			local idx = 1
			local array = {}
			for ent, params in pairs(self.entity_request_queue) do
				array[idx] = ent
				array[idx + 1] = EncodeRequestParams(params)
				idx = idx + 2

				self.entity_request_queue[ent] = nil

				if idx >= 50 then -- max rpc arguments
					break
				end
			end

			if #array > 0 then
				SendModRPCToServer(GetModRPC(modname, "RequestEntityInformation"), unpack(array))
			end
		end)
	end
end

function Insight:StopUpdateLoop()
	self.update_task:Cancel()
	self.update_task = nil
	self.request_task:Cancel()
	self.request_task = nil
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



function Insight:DoesFuelMatchFueled(fuel, fueled)
	if IS_DS then
		if fuel.components.fuel and fueled.components.fueled then
			return fueled.components.fueled:CanAcceptFuelItem(fuel)
		end
	else
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

function Insight:ContainerHas(container, inst, isSearchingForFoodTag)
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

	local container_info, bundle_info = self:GetInformation(container)
	--dprint("container:", container, container_info)

	-- Load Container Info
	if container_info == nil then
		--mprint("container info nil")
		self:RequestInformation(container, { debounce=1 }) -- issue with doing this in DS is that it all happens on the same runstack so it'll end up returning true then returning nil in the same original call
		-- explains alot
		--dprint(container, container:IsValid(), "missing container info")
		return nil -- 0
	end

	-- Load Bundle Info (pretty unlikely its not present already)
	if is_unwrappable then
		bundle_info = self:GetInformation(inst)
		if not bundle_info then
			self:RequestInformation(inst, { debounce=1 })
			--dprint(inst, "missing bundle info")
			return nil
		end
	end

	--dprint("begin searching", container, "for", inst)

	-- resolved named stuff (avoid IsPrefab check for overhead)
	local inst_name = inst and ( (inst.components and inst.components.named) or (inst.replica and inst.replica.named) )
	inst_name = (inst_name and inst.name) or ""

	-- for is_unwrappable
	local things = {}

	-- i check for is_unwrappable to provide the opportunity for non-bundles to terminate faster
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
							return true
						end
					-- if the original thing we were searching for is an inventoryitem
					--print(k.prefab .. (k.name or ""), prefab .. inst_name)
					elseif not isSearchingForFoodTag and (k.prefab .. (k.name or "")) == (prefab .. inst_name) then -- compare to see if inventoryitem.prefab .. inventoryitem.name == search_for.prefab .. search_for.name
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
						return true
					end
				elseif not isSearchingForFoodTag and (v.prefab .. (v.name or "")) == (prefab .. inst_name) then
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
				return true
			end
		end
	end
	
	return false
end

function Insight:GetWorldInformation()
	if IS_DST then
		rpcNetwork.SendModRPCToServer(GetModRPC(modname, "GetWorldInformation"))
	else
		--mprint("DS Get World Information")
		local data = GetWorldInformation(self.inst)
		self.world_data = data
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

	if not self.classified then
		--dprint("insight for", self.inst, "tried to request information for", entity)
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
		--dprint('Insight:RequestEntityInformation missing context')
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

	if debounce > 0 then
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
	self.entity_request_queue[entity] = params
	return true
end

-- entity functions
function Insight:EntityInactive(ent)
	--[[
	if self.entity_data[ent] == nil then
		dprint("attempt to sleep nonregistered entity", ent)
		return
	end
	--]]

	--dprint('inactive', ent)
	assert(IS_DST, "Insight:EntityInactive called outside DST")
	
	self.entity_data[ent] = nil
	--self.entity_count = self.entity_count - 1
end

function Insight:EntityActive(ent)
	if self.entity_data[ent] then
		--dprint("attempt to reawaken existing entity", ent)
		return
	end

	if DEBUG_ENABLED then assert(IS_DST, "Insight:EntityActive called outside DST") end

	self.entity_data[ent] = {
		GUID = nil,
		info = "",
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
		mprint("!!!!!!!!!!!!! Attempt to start tracking entity for non-client")
		return
	end

	if self.indicators:Get(ent) then
		dprint("attempt to stack indicators for", ent)
		return
	end

	local img_data = data or {}
	--local exists, tex, atlas = PrefabHasIcon(ent.prefab)
	if img_data.tex == nil and img_data.atlas == nil then
		local tbl = ResolvePrefabToImageTable(ent.prefab)

		if tbl then
			img_data.tex = tbl.tex
			img_data.atlas = tbl.atlas
		end
	end

	self.indicators:Add(ent, img_data)
end

function Insight:StopTrackingEntity(ent)
	self.indicators:Remove(ent)
end

function Insight:MaintainMenu(insight_menu)
	table.insert(self.menus, insight_menu)
	self:Update()
end

function Insight:Update()
	local HUD = self.inst.HUD

	if not HUD then
		mprint("Insight:Update missing HUD 8/22 - 8/26 - 9/7")
		table.foreach(self.inst, mprint)
		mprint("===============================================================================================================================================")
		return
	end
	
	-- TheWorld and related analyzation
	self:GetWorldInformation()
	self:RequestInformation(self.inst, {RAW=true, debounce=1})

	local world_data = self.world_data
	local player_data = self:GetInformation(self.inst)

	for i,v in pairs(self.menus) do
		if v.inst:IsValid() then -- might not be gc'd yet
			v:ApplyInformation(world_data, player_data)
		end	
	end

	if IS_DST then
		--rpcNetwork.SendModRPCToServer(GetModRPC(modname, "GetShardPlayers"))
	end
	
	-- inventory
	if IS_DST and not TheWorld.ismastersim and HUD.controls.inv and HUD.controls.inv.equip then
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
	
	if IS_DST and HUD.controls.insight_menu and TheInput:ControllerAttached() then
		if HUD.controls.insight_menu.shown then
			HUD.controls.insight_menu:Hide()
		end
	end

	-- indicators
	self.indicators:OnUpdate()
end



return Insight