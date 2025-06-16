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

-- archive_orchestrina_main.lua [Prefab]
local initialized = false


local function SortSockets(a, b) 
	return a.GUID < b.GUID 
end

local function GetSockets(main) -- ISSUE:PERFORMANCE
	local x,y,z = main.Transform:GetWorldPosition()   
	local ents = TheSim:FindEntities(x,y,z, 10, {"resonator_socket"})
	
	local sockets = {}
	for i = #ents, 1, -1 do
		sockets[#sockets+1] = ents[i]
	end
	table.sort(sockets, SortSockets)

	return sockets
end

--- Figures out what the next socket is and marks it as active, disabling the others.
--- @param main EntityScript archive_orchestrina_main
--- @param puzzle table The puzzle table for the lockbox.
local function GetCorrectSocket(main, puzzle)
	local current = main.numcount or 0 -- numcount = nil == its unlocking, or nothing stepped on yet
	current = current + 1

	local tbl = GetSockets(main)

	for i = 1, #tbl do
		local v = tbl[i]
		if puzzle[i] == current then
			v.insight_active:set(true)
		else
			v.insight_active:set(false)
		end
	end
end


--- Sets up the smaller circles and prepares them for triggers from the server.
--- @param inst EntityScript
local function OrchestrinaSmallPostInit(inst)
	inst.insight_active = net_bool(inst.GUID, "insight_active", "insight_active_dirty")

	if TheNet:IsDedicated() then
		return
	end

	inst:ListenForEvent("insight_active_dirty", function(inst)
		local context = localPlayer and GetPlayerContext(localPlayer)

		if not context or not context.config["orchestrina_indicator"] then
			return
		end

		--inst.indicator:SetVisible(inst.insight_active:value())
		if inst.insight_active:value() then
			inst.AnimState:SetHighlightColour(152/255, 100/255, 245/255, 1) --indicator was: 152/255, 100/255, 245/255
		else
			inst.AnimState:SetHighlightColour(0, 0, 0, 0)
		end
	end)
end

--- Triggers the smaller circles to update based off the puzzle progress.
--- @param inst EntityScript
local function OrchestrinaMainPostInit(inst)
	local findlockbox = util.getupvalue(inst.testforlockbox, "findlockbox")

	inst:DoPeriodicTask(0.25, function()
		local lockboxes = findlockbox(inst)
		local lockbox = lockboxes[1]

		if not inst.busy and lockbox and not lockbox.AnimState:IsCurrentAnimation("activation") then 
			local puzzle = lockbox.puzzle
			
			GetCorrectSocket(inst, puzzle)
		else
			local sockets = GetSockets(inst)
			for i = 1, #sockets do
				--v.indicator:SetVisible(false)
				sockets[i].insight_active:set(false)
			end
		end
	end)
end

local function OnServerInit()
	if initialized then
		return
	end

	initialized = true

	if not IS_DST then
		return
	end

	AddPrefabPostInit("archive_orchestrina_main", OrchestrinaMainPostInit)
	AddPrefabPostInit("archive_orchestrina_small", OrchestrinaSmallPostInit)
end

local function OnClientInit()
	if initialized then
		return
	end

	initialized = true
	
	if not IS_DST then
		return
	end

	AddPrefabPostInit("archive_orchestrina_small", OrchestrinaSmallPostInit)
end

return {
	OnServerInit = OnServerInit,
	OnClientInit = OnClientInit,
}