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
--[[ Constants ]]
--------------------------------------------------------------------------

local R15_QOL_WORLDSETTINGS = CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS")
local BEE_QUEEN_HIVE_STAGES = {
	[1] = "hivegrowth1",
	[2] = "hivegrowth2",
	[3] = "hivegrowth",
}

--[[
return {
  ["413393113"]={
	ready=true,
	tags="english,endless,friendsonly,caves,gemcore,insight_2.6.5",
	world={
	  {
		background_node_range={ 0, 1 },
		desc="Delve into the caves... together!",
		hideminimap=false,
		id="DST_CAVE",
		location="cave",
		max_playlist_position=999,
		min_playlist_position=0,
		name="The Caves",
		numrandom_set_pieces=0,
		override_level_string=false,
		overrides={ start_location="caves", task_set="cave_default" },
		required_prefabs={ "multiplayer_portal" },
		substitutes={  },
		version=4 
	  } 
	} 
  } 
}	
]]

--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local DRAGONFLY_SPAWNTIMER = R15_QOL_WORLDSETTINGS and assert(util.recursive_getupvalue(_G.Prefabs.dragonfly_spawner.fn, "DRAGONFLY_SPAWNTIMER"), "Unable to find \"DRAGONFLY_SPAWNTIMER\"") --"regen_dragonfly"

--------------------------------------------------------------------------
--[[ Event Handlers ]]
--------------------------------------------------------------------------

local function OnWorldDataDirty(src, event_data, world_data)
	local self = src.shard.components.shard_insight

	local data
	local sending_shard_id
	
	if not world_data then
		sending_shard_id = event_data.sending_shard_id
		data = decompress(event_data.data)
	else
		sending_shard_id = TheShard:GetShardId()
		data = world_data
	end

	self.extra_data = data
	-- print("extra_data got", data)
end

--------------------------------------------------------------------------
--[[ Remain Descriptors ]]
--------------------------------------------------------------------------

local function AtriumGate(data, context)
	local atrium_gate_cooldown = data or -1
	if atrium_gate_cooldown >= 0 then
		local description = context.time:SimpleProcess(atrium_gate_cooldown)
		return {
			description = description,
			icon = {
				atlas = "images/Atrium_Gate.xml",
				tex = "Atrium_Gate.tex"
			},
			worldly = true, -- meeeh
			prefably = true,
			from = "prefab",
			cooldown = atrium_gate_cooldown,
		}
	end
	return nil
end

local function Dragonfly(data, context)
	local dragonfly_respawn = data or -1
	if dragonfly_respawn >= 0 then
		local description = context.time:SimpleProcess(dragonfly_respawn)
		return {
			description = description,
			icon = {
				atlas = "images/Dragonfly.xml",
				tex = "Dragonfly.tex",
			},
			worldly = true, -- meeeh
			prefably = true,
			from = "prefab",
			time_to_respawn = dragonfly_respawn,
		}
	end
	return nil
end
local function BeeQueen(data, context)
	local beequeen_respawn = data or -1
	if beequeen_respawn >= 0 then
		local description = context.time:SimpleProcess(beequeen_respawn)
		return {
			description = description,
			icon = {
				atlas = "images/Beequeen.xml",
				tex = "Beequeen.tex",
			},
			worldly = true, -- meeeh
			prefably = true,
			from = "prefab",
			time_to_respawn = beequeen_respawn,
		}
	end
	return nil
end

--------------------------------------------------------------------------
--[[ Shard_Insight ]]
--------------------------------------------------------------------------

local Shard_Insight = Class(function(self, inst)
	assert(TheWorld.ismastersim, "Shard_Insight should not exist on client")
	self.inst = inst

	self.shard_data_fetcher = {}
	self.shard_descriptors = {
		atrium_gate = AtriumGate,
		dragonfly_spawner = Dragonfly,
		beequeenhive = BeeQueen,
		terrarium = Insight.prefab_descriptors.terrarium and Insight.prefab_descriptors.terrarium.RemoteDescribe or nil,
	}
	for index, value in ipairs({
		"sinkholespawner",
		"beargerspawner",
		"crabkingspawner",
		"deerclopsspawner",
		"klaussackspawner",
		"malbatrossspawner",
		"toadstoolspawner",
	}) do
		self.shard_descriptors[value] = Insight.descriptors[value] and Insight.descriptors[value].RemoteDescribe or nil
	end

	self.local_data = nil
	self.extra_data = nil

	self.inst:ListenForEvent("insight_gotworlddata", OnWorldDataDirty, TheWorld)
end)

--------------------------------------------------------------------------
--[[ Class Getters ]]
--------------------------------------------------------------------------
function Shard_Insight:UpdateLocalWorldData()
	local data = {}
	--OnWorldDataDirty(TheWorld, nil, data)

	-- print("local_data fetching..")
	for name, descriptor in pairs(self.shard_data_fetcher) do
		data[name] = descriptor()
	end
	-- printwrap("local_data fetched", data)
	self.local_data = data
	return data
end

function Shard_Insight:GetWorldDescriptors()
	return self.shard_descriptors
end

--------------------------------------------------------------------------
--[[ Class Setters ]]
--------------------------------------------------------------------------
function Shard_Insight:SetAntlion(entity)
	if self.shard_data_fetcher.sinkholespawner then
		mprint("Attempt to replace antlion")
		return
	end

	self:RegisterWorldDataFetcher("sinkholespawner", function()
		return entity and entity.components.sinkholespawner and
			Insight.descriptors.sinkholespawner and Insight.descriptors.sinkholespawner.GetAntlionData and
			Insight.descriptors.sinkholespawner.GetAntlionData(entity) or nil
	end)

	entity:ListenForEvent("onremove", function()
		self:RemoveWorldDataFetcher("sinkholespawner")
	end)
	mprint("Got antlion")
end

function Shard_Insight:SetAtriumGate(entity)
	if self.shard_data_fetcher.atrium_gate then
		mprint("Attempt to replace atrium_gate")
		return
	end

	self:RegisterWorldDataFetcher("atrium_gate", function()
		local atriumgate_timer
		if entity then
			-- destabilizing = time before reset
			-- cooldown = time before can resocket the key
			-- destabilizedelay = time before can pulse on rejoin
			if R15_QOL_WORLDSETTINGS then
				atriumgate_timer = entity.components.worldsettingstimer:GetTimeLeft("cooldown")
			else
				atriumgate_timer = entity.components.timer:GetTimeLeft("cooldown")
			end
		end
		return atriumgate_timer
	end)


	entity:ListenForEvent("onremove", function()
		self:RemoveWorldDataFetcher("atrium_gate")
	end)
	mprint("Got atrium_gate")
end

function Shard_Insight:SetDragonflySpawner(entity)
	if self.shard_data_fetcher.dragonfly_spawner then
		mprint("Attempt to replace dragonfly_spawner")
		return
	end

	self:RegisterWorldDataFetcher("dragonfly_spawner", function()
		local dragonfly_spawner_timer = nil
		if entity then
			if R15_QOL_WORLDSETTINGS then
				dragonfly_spawner_timer = entity.components.worldsettingstimer:GetTimeLeft(DRAGONFLY_SPAWNTIMER)
			else
				dragonfly_spawner_timer = entity.components.timer:GetTimeLeft("regen_dragonfly")
			end
		end
		return dragonfly_spawner_timer
	end)

	entity:ListenForEvent("onremove", function()
		self:RemoveWorldDataFetcher("dragonfly_spawner")
	end)
	mprint("Got dragonfly_spawner")
end

function Shard_Insight:SetBeeQueenHive(entity)
	if self.shard_data_fetcher.beequeenhive then
		mprint("Attempt to replace beequeenhive")
		return
	end

	self:RegisterWorldDataFetcher("beequeenhive", function()
		local beequeenhive_timer
		if entity then
			local remaining_time

			for stage, name in pairs(BEE_QUEEN_HIVE_STAGES) do
				local t = entity.components.timer:GetTimeElapsed(name) -- how far we are in the timer, instead of how much time left
				if t then
					remaining_time = TUNING.BEEQUEEN_RESPAWN_TIME
					for _ = 1, stage - 1 do
						remaining_time = remaining_time - TUNING.BEEQUEEN_RESPAWN_TIME / #BEE_QUEEN_HIVE_STAGES
					end
					remaining_time = remaining_time - t
					break
				end
			end

			beequeenhive_timer = remaining_time
		end
		return beequeenhive_timer
	end)

	entity:ListenForEvent("onremove", function()
		self:RemoveWorldDataFetcher("beequeenhive")
	end)
	mprint("Got beequeenhive")
end

function Shard_Insight:SetTerrarium(entity)
	if self.shard_data_fetcher.terrarium then
		mprint("Attempt to replace terrarium.")
		return
	end

	self:RegisterWorldDataFetcher("terrarium", function()
		local terrarium_timer
		if entity then
			if entity.components.worldsettingstimer then
				terrarium_timer = entity.components.worldsettingstimer:GetTimeLeft("cooldown")
			end
		end
		return terrarium_timer
	end)

	entity:ListenForEvent("onremove", function()
		self:RemoveWorldDataFetcher("terrarium")
	end)
	mprint("Got terrarium")
end

function Shard_Insight:SetCrabKingSpawner(entity)
	if self.shard_data_fetcher["crabkingspawner"] then
		mprint("Attempt to replace crabkingspawner")
		return
	end

	self:RegisterWorldDataFetcher("crabkingspawner", function()
		return TheWorld.components.crabkingspawner and entity and Insight.descriptors.crabkingspawner and Insight.descriptors.crabkingspawner.GetCrabKingData(entity) or nil
	end)

	entity:ListenForEvent("onremove", function()
		self:RemoveWorldDataFetcher("crabkingspawner")
	end)
	mprint("Got crabkingspawner")
end

-- dataFn is called in shard itself, which should provide infomation about name
-- data will be populated through WorldData rpc to other shards, which is stored in extra_data
-- descriptor is called using collected data and should return a description object
function Shard_Insight:RegisterWorldDataFetcher(name, dataFn)
	self.shard_data_fetcher[name] = dataFn
end

function Shard_Insight:RemoveWorldDataFetcher(name)
	self.shard_data_fetcher[name] = nil
end

function Shard_Insight:RegisterDescriptor(name, descriptor)
	self.shard_descriptors[name] = descriptor
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

return Shard_Insight