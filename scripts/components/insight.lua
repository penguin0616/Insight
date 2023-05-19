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

if IS_DS then
	return import("components/insight_replica")
end

local function OnPlayerDied(inst, data)
	-- data.skeleton
	-- data.fromload

	if data.skeleton then
		rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "YouDied"), inst.userid, inst.Transform:GetWorldPosition())
	end
end

--------------------------------------------------------------------------
--[[ Queuer ]]
--------------------------------------------------------------------------
local Queuer = Class(function(self, queues)
	self.last_added_queue = 1
	self.queue_count = queues

	assert(self.queue_count >= self.last_added_queue)

	self.queues = {}


	self.entity_to_queue = {} -- {{queue_id=queue_id, queue_position=queue_position}}

	for i = 1, self.queue_count do
		-- lua_getn has logarithmic cost (in 5.2 anyway)
		self.queues[i] = {
			length = 0,
			items = {}
		}
	end
end)

function Queuer:Add(entity, data)
	--mprint('add', entity, data)
	local place = self.entity_to_queue[entity]
	if place then
		--mprint('tweaking', entity)
		-- existing in a queue
		self.queues[place.queue_id].items[place.queue_position] = data
		return
	end

	self.last_added_queue = self.last_added_queue + 1
	if self.last_added_queue > self.queue_count then
		self.last_added_queue = 1
	end

	local selected = self.queues[self.last_added_queue]
	selected.length = selected.length + 1
	selected.items[selected.length] = data

	self.entity_to_queue[entity] = { queue_id = self.last_added_queue, queue_position = selected.length }

	--mprint(string.format("Queue %s Length: %s", self.last_added_queue, selected.length))

	-- could just keep track of last queue added and pick next queue?
	--[[
	local min, q = math.huge, nil
	for i = 1, self.queue_count do
		local v = self.queue_count[i]

		local len = #v
		if len < min then
			min = len, q = v
		end 
	end
	--]]
end

function Queuer:Flush()
	self.entity_to_queue = {}
	for i = 1, self.queue_count do
		self.queues[i] = {
			length = 0,
			items = {}
		}
	end
end

--------------------------------------------------------------------------
--[[ Insight ]]
--------------------------------------------------------------------------
--- Server-side portion of Insight's networking. 
--- Provides interfaces for the server to send certain types of data to the client.
---@param self table
---@param inst EntityScript Player
---@class Insight
local Insight = Class(function(self, inst)
	self.inst = inst
	self.is_local_host = IS_CLIENT_HOST and inst == ThePlayer

	self.queuer = Queuer(10) -- shouldn't encounter crashes with this
	--[[
		with the above listed setup, 
			5 queues: had text lengths of roughly 14000-18000
			6 queues: had text lengths of roughly 10000-15000
		
		ideally want to keep it around 10000 i think, so 7 probably works.
		
		RPC was cutting off around 40k iirc

		when setting info_preload to 0, (nothing), massive strings
	]]

	--[==========[ Entity information sender ]==========]
	self.inst:DoPeriodicTask(0.1, function() -- 0.07 normally
		for i = 1, self.queuer.queue_count do
			local queue = self.queuer.queues[i]
			if queue.length > 0 then
				rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "EntityInformation"), self.inst.userid, compress(queue.items))
			end
		end
		self.queuer:Flush()
	end)

	if GetGhostEnabled() then
		self.inst:ListenForEvent("makeplayerghost", OnPlayerDied)
	else
		self.inst:ListenForEvent("playerdied", OnPlayerDied)
	end

	--[==========[ Battlesongs ]==========]
	self.inst:ListenForEvent("inspirationsongchanged", function(player, data)
		self:SetBattleSongActive(player.components.singinginspiration:IsSinging())
	end)
	self:SetBattleSongActive(false)

	--[==========[ Moon Cycle ]==========]
	self:SendMoonCycle(GetMoonCycle())


	self.inst:ListenForEvent("newfishingtarget", function(player, data)
		--mprint("newfishingtarget", data.target, data.target and data.target.components.oceanfishable, data.target and data.target.components.oceanfishable and type(data.target.fish_def))
		if data.target and data.target.components.oceanfishable and type(data.target.fish_def) == "table" then
			-- Hooked a fish.
			-- I could just send which fish it is and check the data on the client side,
			-- but there could be a server-only mod modifying the data.
			Insight.descriptors.oceanfishingrod.SERVER_OnFishHooked(player, data.target)
		elseif data.target == nil then
			--Insight.descriptors.oceanfishingrod.SERVER_OnFishLost(player)
		end
	end)
end)

--- Sets entity data for networking.
---@param entity EntityScript The entity that has information
---@param data table The information for the entity
function Insight:SetEntityData(entity, data)
	if self.is_local_host then
		self.inst.replica.insight.entity_data[entity] = data
	else
		self.queuer:Add(entity, data)
	end

	--[==[
	if self.queue_tracker[entity] then -- tracks index
		self.queue[self.queue_tracker[entity]] = data -- replace old index
	else
		self.queue[#self.queue+1] = data
		self.queue_tracker[entity] = #self.queue
	end
	--]==]
end

--- Sets world data for networking.
---@param data table
function Insight:SetWorldData(data)
	if self.is_local_host then
		self.inst.replica.insight.world_data = data
	else
		local encoded = json.encode(data)
		self.inst.replica.insight:SetWorldData(encoded)
	end
end

--- Sends the client's naughtiness.
function Insight:SendNaughtiness()
	-- GetNaughtiness normally requires a context for the second arg, but as of right now it doesn't seem like the context gets checked for anything at the moment.
	local tbl = GetNaughtiness(self.inst, nil)

	-- This will fail intially in client hosted since it'll get called before the player shows up in kramped data.
	if type(tbl) ~= "table" or type(tbl.actions) ~= "number" or type(tbl.threshold) ~= "number" then
		mprint("GetNaughtiness failed:", tbl)
		return
	end

	if self.is_local_host then
		self.inst.replica.insight:OnNaughtinessDirty(tbl)
	else
		self.inst.replica.insight:SetNaughtiness(tbl.actions .. "|" .. tbl.threshold)
	end
end

--- Tells the client to remove an entity from its information cache.
---@param entity EntityScript
function Insight:InvalidateCachedEntity(entity)
	if self.is_local_host then
		self.inst.replica.insight:OnInvalidateCachedEntity(entity)
	else
		self.inst.replica.insight:InvalidateCachedEntity(entity)
	end
end

--- Tells the client to set the current hunt target.
---@param target EntityScript
function Insight:SetHuntTarget(target)
	if self.is_local_host then
		self.inst.replica.insight:OnHuntTargetDirty(target)
	else
		self.inst.replica.insight:SetHuntTarget(target)
	end
end

--- Sets whether the player has a battlesong active.
---@param bool boolean
function Insight:SetBattleSongActive(bool)
	self.inst.replica.insight:SetBattleSongActive(bool)
end

--- Networks the current rate for stats.
function Insight:SendStatRates()
	if self.inst.components.hunger then
		self.inst.replica.insight:SetHungerRate(self.inst.components.hunger.hungerrate)
	end

	if self.inst.components.sanity then
		self.inst.replica.insight:SetSanityRate(self.inst.components.sanity.rate)
	end

	if self.inst.components.moisture then
		self.inst.replica.insight:SetMoistureRate(self.inst.components.moisture.rate)
	end
end

--- Sends the current moon cycle to the client for Combined Status.
---@param int integer Current section of the moon cycle.
function Insight:SendMoonCycle(int)
	if not int then
		dprint("Missing int for SendMoonCycle?")
		return
	end

	self.inst.replica.insight:SetMoonCycle(int)
end

return Insight