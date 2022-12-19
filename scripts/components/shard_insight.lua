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
local notables = {
	antlion = nil,
	atrium_gate = nil,
	dragonfly_spawner = nil,
	beequeenhive = nil,
	crabking_spawner = nil,
	terrarium = nil
}
local DRAGONFLY_SPAWNTIMER = R15_QOL_WORLDSETTINGS and assert(util.recursive_getupvalue(_G.Prefabs.dragonfly_spawner.fn, "DRAGONFLY_SPAWNTIMER"), "Unable to find \"DRAGONFLY_SPAWNTIMER\"") --"regen_dragonfly"

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local function OnNotableRemove(inst)
	notables[inst.prefab] = nil
end

local function GetWorldData()
	local antlion = notables.antlion and notables.antlion.components.sinkholespawner and _G.Insight.descriptors.sinkholespawner and _G.Insight.descriptors.sinkholespawner.GetAntlionData and _G.Insight.descriptors.sinkholespawner.GetAntlionData(notables.antlion) or nil

	local atriumgate_timer
	if notables.atrium_gate then
		-- destabilizing = time before reset
		-- cooldown = time before can resocket the key
		-- destabilizedelay = time before can pulse on rejoin
		if R15_QOL_WORLDSETTINGS then
			atriumgate_timer = notables.atrium_gate.components.worldsettingstimer:GetTimeLeft("cooldown")
		else
			atriumgate_timer = notables.atrium_gate.components.timer:GetTimeLeft("cooldown")
		end
	end

	local dragonfly_spawner_timer = notables.dragonfly_spawner and notables.dragonfly_spawner.components.worldsettingstimer:GetTimeLeft(DRAGONFLY_SPAWNTIMER) or nil
	if notables.dragonfly_spawner then
		if R15_QOL_WORLDSETTINGS then
			dragonfly_spawner_timer = notables.dragonfly_spawner.components.worldsettingstimer:GetTimeLeft(DRAGONFLY_SPAWNTIMER)
		else
			dragonfly_spawner_timer = notables.dragonfly_spawner.components.timer:GetTimeLeft("regen_dragonfly")
		end
	end

	local beequeenhive_timer
	if notables.beequeenhive then
		local remaining_time

		for stage, name in pairs(BEE_QUEEN_HIVE_STAGES) do
			local t = notables.beequeenhive.components.timer:GetTimeElapsed(name) -- how far we are in the timer, instead of how much time left
			if t then
				remaining_time = TUNING.BEEQUEEN_RESPAWN_TIME
				for _ = 1, stage-1 do
					remaining_time = remaining_time - TUNING.BEEQUEEN_RESPAWN_TIME / #BEE_QUEEN_HIVE_STAGES
				end
				remaining_time = remaining_time - t
				break
			end
		end

		beequeenhive_timer = remaining_time
	end

	local terrarium_timer
	if notables.terrarium then
		if notables.terrarium.components.worldsettingstimer then
			terrarium_timer = notables.terrarium.components.worldsettingstimer:GetTimeLeft("cooldown")
		end
	end

	local bearger = TheWorld.components.beargerspawner and _G.Insight.descriptors.beargerspawner and _G.Insight.descriptors.beargerspawner.GetBeargerData(TheWorld.components.beargerspawner) or nil
	--[[
	if TheWorld.components.beargerspawner then
		bearger = _G.Insight.descriptors.beargerspawner.GetBeargerData(TheWorld.components.beargerspawner)
	end
	--]]

	local crabking = TheWorld.components.crabkingspawner and notables.crabking_spawner and _G.Insight.descriptors.crabkingspawner and _G.Insight.descriptors.crabkingspawner.GetCrabKingData(notables.crabking_spawner) or nil

	local deerclops = TheWorld.components.deerclopsspawner and _G.Insight.descriptors.deerclopsspawner and _G.Insight.descriptors.deerclopsspawner.GetDeerclopsData(TheWorld.components.deerclopsspawner) or nil

	local klaussack = TheWorld.components.klaussackspawner and _G.Insight.descriptors.klaussackspawner and _G.Insight.descriptors.klaussackspawner.GetKlausSackData(TheWorld.components.klaussackspawner) or nil

	local malbatross = TheWorld.components.malbatrossspawner and _G.Insight.descriptors.malbatrossspawner and _G.Insight.descriptors.malbatrossspawner.GetMalbatrossData(TheWorld.components.malbatrossspawner) or nil

	local toadstool = TheWorld.components.toadstoolspawner and _G.Insight.descriptors.toadstoolspawner and _G.Insight.descriptors.toadstoolspawner.GetToadstoolData(TheWorld.components.toadstoolspawner) or nil
	
	return {
		antlion = antlion,
		atriumgate_timer = atriumgate_timer,
		dragonfly_spawner_timer = dragonfly_spawner_timer,
		beequeenhive_timer = beequeenhive_timer,
		terrarium_timer = terrarium_timer,

		bearger = bearger,
		crabking = crabking,
		deerclops = deerclops,
		klaussack = klaussack,
		malbatross = malbatross,
		toadstool = toadstool,
	}
end

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

	self.antlion = data.antlion
	self.atriumgate_timer = data.atriumgate_timer
	self.dragonfly_spawner_timer = data.dragonfly_spawner_timer
	self.beequeenhive_timer = data.beequeenhive_timer
	self.terrarium_timer = data.terrarium_timer

	self.bearger = data.bearger
	self.crabking = data.crabking
	self.deerclops = data.deerclops
	self.klaussack = data.klaussack
	self.malbatross = data.malbatross
	self.toadstool = data.toadstool

	--[[
	self.antlion = data.antlion or self.antlion
	self.atriumgate_timer = data.atriumgate_timer or self.atriumgate_timer
	self.dragonfly_spawner_timer = data.dragonfly_spawner_timer or self.dragonfly_spawner_timer
	self.beequeenhive_timer = data.beequeenhive_timer or self.beequeenhive_timer

	self.bearger = data.bearger or self.bearger
	self.crabking = data.crabking or self.crabking
	self.deerclops = data.deerclops or self.deerclops
	self.klaussack = data.klaussack or self.klaussack
	self.malbatross = data.malbatross or self.malbatross
	self.toadstool = data.toadstool or self.toadstool
	--]]
end

--------------------------------------------------------------------------
--[[ Shard_Insight ]]
--------------------------------------------------------------------------

local Shard_Insight = Class(function(self, inst)
	assert(TheWorld.ismastersim, "Shard_Insight should not exist on client")
	self.inst = inst

	self.antlion = nil
	self.atriumgate_timer = nil -- time until the ancient gateway can be reactivated
	self.dragonfly_spawner_timer = nil -- time until dragonfly respawns
	self.beequeenhive_timer = nil -- time until bee queen's hive respawns
	self.terrarium_timer = nil

	self.bearger = nil -- bearger data
	self.crabking = nil -- crabking data
	self.deerclops = nil -- deerclops data
	self.klaussack = nil
	self.malbatross = nil
	self.toadstool = nil

	self.notables = notables

	self.inst:ListenForEvent("insight_gotworlddata", OnWorldDataDirty, TheWorld)
end)

--------------------------------------------------------------------------
--[[ Class Getters ]]
--------------------------------------------------------------------------
Shard_Insight.GetWorldData = GetWorldData

function Shard_Insight:UpdateLocalWorldData()
	local data = GetWorldData()
	--OnWorldDataDirty(TheWorld, nil, data)

	return data
end

function Shard_Insight:GetAntlionData()
	return self.antlion or GetWorldData().antlion
end

function Shard_Insight:GetAtriumGateCooldown()
	return self.atriumgate_timer or GetWorldData().atriumgate_timer
end

function Shard_Insight:GetDragonflyRespawnTime()
	return self.dragonfly_spawner_timer or GetWorldData().dragonfly_spawner_timer
end

function Shard_Insight:GetBeeQueenRespawnTime()
	return self.beequeenhive_timer or GetWorldData().beequeenhive_timer
end

function Shard_Insight:GetTerrariumCooldown()
	return self.terrarium_timer or GetWorldData().terrarium_timer
end

function Shard_Insight:GetBeargerData()
	return self.bearger
end

function Shard_Insight:GetCrabKingData()
	return self.crabking
end

function Shard_Insight:GetDeerclopsData()
	return self.deerclops
end

function Shard_Insight:GetKlausSackData()
	return self.klaussack
end

function Shard_Insight:GetMalbatrossData()
	return self.malbatross
end

function Shard_Insight:GetToadstoolData()
	return self.toadstool
end

--------------------------------------------------------------------------
--[[ Class Setters ]]
--------------------------------------------------------------------------
function Shard_Insight:SetAntlion(entity)
	if notables.antlion then
		mprint("Attempt to replace antlion")
		return
	end

	notables.antlion = entity

	entity:ListenForEvent("onremove", OnNotableRemove)
	mprint("Got antlion")
end

function Shard_Insight:SetAtriumGate(entity)
	if notables.atrium_gate then
		mprint("Attempt to replace atrium_gate")
		return
	end

	notables.atrium_gate = entity

	entity:ListenForEvent("onremove", OnNotableRemove)
	mprint("Got atrium_gate")
end

function Shard_Insight:SetDragonflySpawner(entity)
	if notables.dragonfly_spawner then
		mprint("Attempt to replace dragonfly_spawner")
		return
	end

	notables.dragonfly_spawner = entity

	entity:ListenForEvent("onremove", OnNotableRemove)
	mprint("Got dragonfly_spawner")
end

function Shard_Insight:SetBeeQueenHive(entity)
	if notables.beequeenhive then
		mprint("Attempt to replace beequeenhive")
		return
	end

	notables.beequeenhive = entity

	entity:ListenForEvent("onremove", OnNotableRemove)
	mprint("Got beequeenhive")
end

function Shard_Insight:SetTerrarium(entity)
	if notables.terrarium then
		mprint("Attempt to replace terrarium.")
		return
	end

	notables.terrarium = entity

	entity:ListenForEvent("onremove", OnNotableRemove)
	mprint("Got terrarium")
end

function Shard_Insight:SetCrabKingSpawner(entity)
	if notables.crabking_spawner then
		mprint("Attempt to replace crabking_spawner")
		return
	end

	notables.crabking_spawner = entity

	entity:ListenForEvent("onremove", OnNotableRemove)
	mprint("Got crabking_spawner")
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

return Shard_Insight