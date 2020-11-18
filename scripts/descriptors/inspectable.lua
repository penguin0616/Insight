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

-- inspectable.lua
-- only using this for stuff i want information on but doesn't have any distinguishable components

local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if inst == context.player then
		-- no thanks
		return
	end

	if inst:HasTag("abigail_flower") and context.player.components.ghostlybond then
		local ghostlybond = context.player.components.ghostlybond

		if ghostlybond.bondleveltimer then
			local ghostlybond_levelup_time = TimeToText(time.new(ghostlybond.bondlevelmaxtime - ghostlybond.bondleveltimer, context))
			description = string.format(context.lstr.ghostlybond_self, ghostlybond.bondlevel, ghostlybond.maxbondlevel, ghostlybond_levelup_time)
		end
	end

	if inst.prefab == "lureplant" then
		if inst.hibernatetask and not TheWorld.state.iswinter then
			description = string.format("Will become active in: %s", TimeToText(time.new(GetTaskRemaining(inst.hibernatetask), context)))
		end
	end

	if inst.prefab == "walrus_camp" and inst.data.regentime then
		local strs = {}
		for prefab, targettime in pairs(inst.data.regentime) do
			local respawn_in = targettime - GetTime()
			if respawn_in >= 0 then
				respawn_in = TimeToText(time.new(respawn_in, context))
				table.insert(strs, string.format("%s respawns in: %s", STRINGS.NAMES[string.upper(prefab)] or ("\"" .. prefab .. "\""), respawn_in))
			end
		end
		description = table.concat(strs, "\n")
	end

	if inst.prefab == "archive_lockbox" and inst.product_orchestrina then
		description = string.format(context.lstr.unlocks, STRINGS.NAMES[inst.product_orchestrina:upper()] or ("\"" .. inst.product_orchestrina .. "\""))
	end
	
	if inst.prefab == "dirtpile" or inst.prefab == "whale_bubbles" then
		for _, hunt in pairs(Insight.active_hunts) do
			if hunt.lastdirt == inst then
				local ambush_track_num = hunt.ambush_track_num
				description = string.format(context.lstr.hunt_progress, hunt.trackspawned + 1, hunt.numtrackstospawn)

				if ambush_track_num == hunt.trackspawned + 1 then
					description = CombineLines(description, "There is an ambush waiting on the next track.")
				end
				break
			end
		end
	end

	if inst.prefab == "rainometer" then
		local wetness = nil
		local precipitation_rate = nil
		local frog_rain_chance = nil

		if IsDST() then
			wetness = string.format(context.lstr.global_wetness, Round(TheWorld.state.wetness, 1))
			
			if TheWorld.state.precipitationrate > 0 then
				precipitation_rate = string.format(context.lstr.precipitation_rate, Round(TheWorld.state.precipitationrate, 2))
			end

			local frog_rain = TheWorld.components.frograin
			if frog_rain and TheWorld.state.isspring then
				frog_rain_chance = string.format(context.lstr.frog_rain_chance, Round(frog_rain:OnSave().chance * 100, 1))
			end
		end

		description = CombineLines(wetness, precipitation_rate, frog_rain_chance)
	end

	if inst.prefab == "winterometer" then
		local world_temperature = nil

		if IsDST() then
			-- SHOWWORLDTEMP
			if not context.external_config["combined_status"]["SHOWWORLDTEMP"] then
				world_temperature = string.format(context.lstr.world_temperature, Round(TheWorld.state.temperature, 0))
			end
		end

		description = world_temperature
	end

	--[[
	if IsDST() and inst.components.inventoryitem then
		if context.player.components.itemaffinity then
			for i,v in pairs(context.player.components.itemaffinity.affinities) do
				if v.prefab and context.player.components.inventory:Has(v.prefab, 1) or v.tag and self.inst.components.inventory:HasItemWithTag(v.tag, 1) then

				end
			end
		--local em = context.player.components.sanity.externalmodifiers
		--print(inst, em._base, em:CalculateModifierFromSource(inst))
		--if context.player.components.sanity.externalmodifiers:RemoveModifier
	end
	--]]

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}