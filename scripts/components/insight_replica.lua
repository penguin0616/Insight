--[[
Copyright (C) 2020 penguin0616

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
local Indicators = import("indicators")

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
		for i,v in pairs(TheNet:GetClientTable() or {}) do
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

--==========================================================================================================================
--==========================================================================================================================
--======================================== Dirty & Etc =====================================================================
--==========================================================================================================================
--==========================================================================================================================

local function GotEntityInformation(inst, data)
	local insight = GetInsight(inst)

	--[[
	if not data.entity then
		-- server sent a nil entity
		dprint("Got nil entity from server")
		return
	end
	--]]

	local items = decompress(data.data) --json.decode(str)

	for _, data in pairs(items) do
		-- GUIDs are numbers. not strings. 
		local guid = tonumber(data.GUID)
		local ent = entityManager:LookupGUID(guid)
		--dprint("SAVING FOR:", ent, guid)
		if ent then
			insight.entity_data[ent] = data
			if ent.replica.container or IsBundleWrap(ent) then
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
local function OnWorldDataDirty(inst)
	if not GetInsight(inst).is_client then
		--dprint("[OnWorldDataDirty]: Rejected for nonclient")
		return
	end

	local str = GetInsight(inst).net_world_data:value()
	local data = json.decode(str)

	GetInsight(inst).world_data = data
end

local function OnNaughtinessDirty(inst)
	if not GetInsight(inst).is_client then
		--dprint("[OnNaughtinessDirty]: Rejected for nonclient")
		return
	end

	local str = GetInsight(inst).net_naughtiness:value()
	local data = json.decode(str)

	--mprint("got and pushed", data.actions, data.threshold)
	inst:PushEvent("naughtydelta", data)
end

local function OnHuntTargetDirty(inst, target)
	if IsDST() and not GetInsight(inst).is_client then
		--dprint("[OnHuntTargetDirty]: Rejected for nonclient")
		return
	end

	if IsDS() and target == nil then
		error("[Insight]: OnHuntTargetDirty(DS) missing target.")
	end

	local target = target or GetInsight(inst).net_hunt_target:value()

	if GetInsight(inst).hunt_target then
		GetInsight(inst):StopTrackingEntity(GetInsight(inst).hunt_target)
		--inst.HUD:RemoveTargetIndicator(GetInsight(inst).hunt_target)
	end

	if not target then
		return
	end

	GetInsight(inst).hunt_target = target
	GetInsight(inst):StartTrackingEntity(target, {removeOnFound = target.components.health ~= nil or (target.replica and target.replica.health ~= nil)})

	--inst.HUD:AddTargetIndicator(target, {})
end

local Insight = Class(function(self, inst)
	mprint("Registering Insight replica for", inst, "but I am", ThePlayer)

	if IsClient() then
		assert(ThePlayer, "[Insight]: Failed to load replica since you're missing")
		if inst ~= ThePlayer then
			mprint("\tRejected Insight replica for non-localplayer")
			self.is_client = false
		else
			self.is_client = true
		end
	elseif IsClientHost() and ThePlayer == nil then
		-- /shrug
		self.is_client = true
	end

	--self.is_client = (self.is_client == nil and inst == ThePlayer) or self.is_client
	self.inst = inst
	
	self.performance_ratings = self.is_client and PerformanceRatings()

	-- Exceeded maximum data length serializing entity channel for entity woodie[117470]......
	-- could i possibly attach a secondary entity and listen to it?
	
	--self.receivers = 5
	self.queue_pop_count = 4
	--self.queue_threshold = 15 + self.receivers * self.queue_pop_count
	self.queue_flushing = false
	
	self.queue_tracker = {}
	self.queue = createTable(100)
	self.menus = setmetatable({}, { __mode="kv" })

	self.entity_count = 0
	self.world_data = nil -- await
	self.entity_data = setmetatable(createTable(500), { __mode="k" }) -- {[entity] = {data}}
	self.entity_debounces = {}
	self.hunt_target = nil
	self.tracked_entities = {}
	

	if IsDST() then
		self.inst:ListenForEvent("insight_entity_information", GotEntityInformation)
			
		-- net_string
		self.net_world_data = net_string(self.inst.GUID, "insight_world_data", "insight_world_data_dirty")
		self.net_naughtiness = net_string(self.inst.GUID, "insight_naughtiness", "insight_naughtiness_dirty")
		-- net_entity
		self.net_invalidate = net_entity(self.inst.GUID, "insight_invalidate", "insight_invalidate_dirty")
		self.net_hunt_target = net_entity(self.inst.GUID, "insight_hunt_target", "insight_hunt_target_dirty")
		-- net_bool
		self.net_battlesong_active = net_bool(self.inst.GUID, "insight_battlesong_active", "insight_battlesong_active_dirty")

		self.inst:ListenForEvent("insight_world_data_dirty", OnWorldDataDirty)

		self.inst:ListenForEvent("insight_naughtiness_dirty", OnNaughtinessDirty)

		self.inst:ListenForEvent("insight_hunt_target_dirty", OnHuntTargetDirty)

		if TheWorld.ismastersim then
			-- server
			self.inst:ListenForEvent("inspirationsongchanged", function(player, data)
				self.net_battlesong_active:set(player.components.singinginspiration:IsSinging())
			end)
			
			--[[
			local function Send()
				
				self.inst:DoTaskInTime(0.07 * (self.performance_ratings:GetHost() + 1), Send)
			end
			--]]

			self.inst:DoPeriodicTask(0.07, function()
				local to_send = {}
				to_send = self.queue -- meh

				if #to_send > 0 then
					--mprint(to_send[1] and to_send[1].information)
					rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "EntityInformation"), self.inst.userid, compress(to_send))

					self.queue = {}
					self.queue_tracker = {}
				end
			end)
			
			--[[
			self.inst:DoPeriodicTask(0.07, function()
				for i, r in pairs(self.net_entity_datas) do
					--dprint(string.format("Transmitter #%d has a queue length of [%d]", i, #r.queue))
					if #r.queue > 0 then
						local to_set = {}

						for _ = 1, math.min(self.queue_pop_count, #r.queue) do

							local item = table.remove(r.queue, 1)
							table.insert(to_set, item)
						end

						to_set = compress(to_set)

						r.net:set(to_set)
					end

					if #r.queue > self.queue_threshold then
						if self.queue_flushing and #r.queue > self.queue_threshold * 2 then
							mprint(string.format("[Insight]: !!CRITICAL!! Queue length is %s/%s for '%s' on transmitter [%s]. Queue has been cleared. Please report this on Insight's bug page.", #r.queue, self.queue_threshold, self.inst.name, i))
							r.queue = {}
						else
							mprint(string.format("[Insight]: Queue length is %s/%s for '%s' on transmitter [%s]. Dangerous queue length reached.", #r.queue, self.queue_threshold, self.inst.name, i))
						end
					end
				end
			end)
			--]]
		end

		if self.is_client then
			-- client
			self.inst:ListenForEvent("insight_invalidate_dirty", function(...)
				local inst = GetInsight(...).net_invalidate:value()
				if inst then -- some wx78 had a nil inst
					self:RequestInformation(inst)
				end
			end)
		end
	end

	if IsDS() or self.is_client then -- another check to make this is for us only
		mprint("\tInsight replica update loop has begun")
		self.indicators = Indicators(inst)

		-- self.inst:StartUpdatingComponent(self)
		-- hud was sometimes missing in OnUpdate
		self.inst:DoPeriodicTask(0.33, function(inst)
			self:Update()

			if self.performance_ratings then -- requires is_client, which is only true in DST
				self.performance_ratings:Refresh()
			end
		end)
	end
end)

function Insight:SetEntityData(entity, data)
	assert(TheWorld.ismastersim, "Insight:SetEntityData called from client.")

	if self.queue_tracker[entity] then -- tracks index
		self.queue[self.queue_tracker[entity]] = data -- replace old index
	else
		table.insert(self.queue, data)
		self.queue_tracker[entity] = #self.queue
	end
end

function Insight:SendNaughtiness()
	assert(TheWorld.ismastersim, "Insight:DidNaughty() called on client")

	local tbl = GetNaughtiness(self.inst, GetPlayerContext(self.inst))
	if not tbl or not tbl.actions or not tbl.threshold then
		mprint("GetNaughtiness failed:", tbl)
		if tbl then
			table.foreach(tbl, mprint)
		end
		return
	end

	--mprint("winner winner", tbl.actions, tbl.threshold)
	
	self.net_naughtiness:set(json.encode(tbl))
end

function Insight:HuntFor(target)
	if IsDST() then
		assert(TheWorld.ismastersim, "Insight:Hunt() called on client")
		self.net_hunt_target:set(target)
	else
		OnHuntTargetDirty(self.inst, target)
	end
end

function Insight:DoesFuelMatchFueled(fuel, fueled)
	if IsDS() then
		if fuel.components.fuel and fueled.components.fueled then
			return fueled.components.fueled:CanAcceptFuelItem(fuel)
		end
	else
		local ed_fuel = self.entity_data[fuel]
		local ed_fueled = self.entity_data[fueled]

		if ed_fuel == nil then
			self:RequestInformation(fuel)
		end
		if ed_fueled == nil then
			self:RequestInformation(fueled)
		end

		--[[
			function Fueled:CanAcceptFuelItem(item)
    			return self.accepting and item and item.components.fuel and (item.components.fuel.fueltype == self.fueltype or item.components.fuel.fueltype == self.secondaryfueltype)
			end

		]]

		-- so much repetion makes this harder to read
		if ed_fuel and ed_fuel.special_data.fuel and ed_fueled and ed_fueled.special_data.fueled then
			--dprint(fuel, fueled)
			return ed_fueled.accepting and ed_fuel.special_data.fuel.fueltype == ed_fueled.special_data.fueled.fueltype or ed_fuel.special_data.fuel.fueltype == ed_fueled.special_data.fueled.secondaryfueltype
		end
	end

	return false
end

function Insight:BundleHasPrefab(inst, prefab)
	local info = self:GetInformation(inst)

	if not info then
		self:RequestInformation(inst, { debounce=0.1 })
		return nil
	end

	for i,v in pairs(info.special_data["unwrappable"].contents) do
		--if AreEntityPrefabsEqual(inst, prefab) then
		if v.prefab == prefab then
			return true
		end
	end

	return false
end

function Insight:ContainerHas(container, inst)
	local prefab = inst.prefab or inst
	local is_unwrappable = IsBundleWrap(inst)

	local container_info, bundle_info = self:GetInformation(container)
	--dprint("container:", container, container_info)

	-- Load Container Info
	if container_info == nil then
		self:RequestInformation(container, { debounce=0.1 })
		--dprint(container, container:IsValid(), "missing container info")
		return nil -- 0
	end

	-- Load Bundle Info (pretty unlikely its not present already)
	if is_unwrappable then
		bundle_info = self:GetInformation(inst)
		if not bundle_info then
			self:RequestInformation(inst, { debounce=0.1 })
			--dprint(inst, "missing bundle info")
			return nil
		end
	end

	-- resolved named stuff (avoid IsPrefab check for overhead)
	local inst_name = inst and ( (inst.components and inst.components.named) or (inst.replica and inst.replica.named) )
	inst_name = (inst_name and inst.name) or ""

	-- for is_unwrappable
	local things = {}

	-- i check for is_unwrappable to provide the opportunity for non-bundles to terminate faster
	for i,v in pairs(container_info.special_data["container"].contents) do
		-- v { prefab=v.prefab, stacksize=stacksize, contents=unwrappable_contents, name=name } 
		if v.contents then
			-- only check the contents of the bundle
			for j,k in pairs(v.contents) do
				if is_unwrappable then
					things[k.prefab .. (k.name or "")] = true
				else
					if (k.prefab .. (k.name or "")) == (prefab .. inst_name) then
						return true
					end
				end
			end
		else
			-- only check the inst
			if is_unwrappable then
				things[v.prefab .. (v.name or "")] = true
			else
				if (v.prefab .. (v.name or "")) == (prefab .. inst_name) then
					return true
				end
			end
		end
	end

	
	if is_unwrappable then
		for i,v in pairs(bundle_info.special_data["unwrappable"].contents) do
			if things[v.prefab .. (v.name or "")] then
				return true
			end
		end
	end
	
	return false
end

function Insight:GetWorldInformation()
	if IsDST() then
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

function Insight:RequestInformation(item, params)
	if TRACK_INFORMATION_REQUESTS then
		dprint("Client requesting information for", item)
	end

	--if true then mprint("requestinfo denied client") return nil end

	local params = params or { raw=false }
	params.id = item.GUID

	if IsDS() then
		-- we don't care about the rest of this in DS
		RequestEntityInformation(item, self.inst, params)
		return
	end

	-- check if there is a debounce
	if self.entity_debounces[item] then
		--dprint('rejected', item, self.entity_debounces[item])
		return
	end

	-- check context
	local context = GetPlayerContext(self.inst)
	if not context then
		-- cant do anything without context
		mprint('Insight:RequestEntityInformation missing context')
		return
	end

	--[[
	if not self.entity_data[item] then
		--dprint("requesting information for unregistered entity:", item)
		return
	end
	--]]

	-- check for delays
	--mprint("context", context)
	--table.foreach(context, mprint)
	local delay = params.debounce or context.config["refresh_delay"]
	
	if type(delay) == "number" and delay >= 0 then
		-- good
	elseif delay == true then
		local host = self.performance_ratings:GetHost()
		local client = self.performance_ratings:GetClient()
		local ents = math.floor(self:CountEntities() / 1000) -- (2000 - host * 500) -- host? client? who knows which is better.
		local plrs = #TheNet:GetClientTable() / 4
		-- min is 170, max seen is 3370
		
		delay = (0.50 * host) + (1/3 * client) + (0.125 * ents)
	else
		mprint("Delay set to 0 in weird case.", tostring(delay), type(delay))
		--error("Delay set to 0 in weird case.")
		return
	end

	if delay > 0 then
		self.entity_debounces[item] = true
		self.inst:DoTaskInTime(delay, function()
			--mprint'clear'
			self.entity_debounces[item] = nil
		end)
	end

	params = json.encode(params) -- encode for rpc transfer
	SendModRPCToServer(GetModRPC(modname, "RequestEntityInformation"), item, params)
end

-- entity functions
function Insight:EntityInactive(ent)
	--[[
	if self.entity_data[ent] == nil then
		dprint("attempt to sleep nonregistered entity", ent)
		return
	end
	--]]

	assert(IsDST(), "Insight:EntityInactive called outside DST")
	
	--self.entity_data[ent] = nil
	--self.entity_count = self.entity_count - 1
end

function Insight:EntityActive(ent)
	if self.entity_data[ent] then
		dprint("attempt to reawaken existing entity", ent)
		return
	end

	assert(IsDST(), "Insight:EntityActive called outside DST")

	self.entity_data[ent] = {
		GUID = nil,
		info = "",
		special_data = {},
	}

	--self.entity_count = self.entity_count + 1

	if ent.prefab == "cave_entrance_open" or ent.prefab == "cave_exit" then
		ent:DoTaskInTime(0, function()
			self:RequestInformation(ent)
		end)
	else
		ent:DoTaskInTime(math.random() * 3, function()
			if not TheWorld.ismastersim then
				if ent.replica.container then
					self:RequestInformation(ent)
				end
			end
		end)
	end
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
		return
	end

	local img_data = data or {}
	--local exists, tex, atlas = PrefabHasIcon(ent.prefab)
	local tbl = ResolvePrefabToImageTable(ent.prefab)


	if tbl then
		img_data.image = tbl.tex
		img_data.atlas = tbl.atlas
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
	self:RequestInformation(self.inst, {raw=true})

	local world_data = self.world_data
	local player_data = self:GetInformation(self.inst)

	for i,v in pairs(self.menus) do
		if v.inst:IsValid() then -- might not be gc'd yet
			v:ApplyInformation(world_data, player_data)
		end	
	end

	if IsDST() then
		--rpcNetwork.SendModRPCToServer(GetModRPC(modname, "GetShardPlayers"))
	end
	
	-- inventory
	if IsDST() and HUD.controls.inv then
		-- self.inv:Hide()
		HUD.controls.inv:Refresh()
	end
	
	if IsDST() and HUD.controls.insight_menu and TheInput:ControllerAttached() then
		if HUD.controls.insight_menu.shown then
			HUD.controls.insight_menu:Hide()
		end
	end

	-- indicators
	self.indicators:OnUpdate()
end



return Insight