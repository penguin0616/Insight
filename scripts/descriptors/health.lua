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

-- health.lua
-- naughtiness is also handled here because anything with naughtiness is bound to have a health component as wello
-- its just logic right?
local function ShouldShowPlayerNaughtiness(context)
	--[[
	if IsDST() then
		return context.config["naughtiness_verbosity"] == 2
	end
	--]]

	local doesCombinedStatusDisplay = context.external_config["combined_status"]["SHOWNAUGHTINESS"]
	--dprint("external show naughtiness", doesCombinedStatusDisplay)

	if not doesCombinedStatusDisplay then
		--dprint("resorting to insight choice")
		return context.config["naughtiness_verbosity"] == 2
	end

	return not doesCombinedStatusDisplay
end

local function GetData(self)
	local max_health = (self.GetMaxWithPenalty and self:GetMaxWithPenalty()) or self:GetMaxHealth()

	return {
		health = tonumber(Round(self.currenthealth, 1)),
		max_health = tonumber(Round(max_health, 1)),
	}
end

local function Describe(self, context)
	local inst = self.inst
	--local description = string.format("<color=HEALTH>Health</color>: <color=HEALTH><%s / %s></color>", Round(self.currenthealth, 1), Round(self:GetMaxHealth(), 1)) -- encompass whole
	local description, alt_description = nil, nil
	local max_health = (self.GetMaxWithPenalty and self:GetMaxWithPenalty()) or self:GetMaxHealth()

	if context.config["display_health"] then
		description = string.format(context.lstr.health, Round(self.currenthealth, 1), Round(max_health, 1))
		local percent = self.currenthealth / max_health
		alt_description = description .. string.format(" (<color=HEALTH>%s%%</color>)", Round(percent * 100, 0))

		if self.regen then -- regeneration
			local regen = string.format(context.lstr.health_regeneration, Round(self.regen.amount, 1), Round(self.regen.period, 1))
			description = description .. regen
			alt_description = alt_description .. regen
		end

		if self.absorb > 0 then -- damage absorption
			local absorb = string.format(context.lstr.absorption, Round(self.absorb * 100, 0))
			description = description .. absorb
			alt_description = alt_description .. absorb
		end
	end

	local naughtiness_table = nil

	if context.config["naughtiness_verbosity"] > 0 and not inst:HasTag("player") then
		local naughtiness = GetNaughtiness(inst, context)
		if naughtiness and naughtiness ~= 0 then
			naughtiness_table = { name="naughtiness", priority=0 }
			naughtiness = string.format(context.lstr.naughtiness, naughtiness)

			local player_naughtiness
			if ShouldShowPlayerNaughtiness(context) then
				player_naughtiness = GetNaughtiness(context.player, context)
				player_naughtiness = player_naughtiness and string.format(context.lstr.player_naughtiness, player_naughtiness.actions, player_naughtiness.threshold) or nil
			end
			
			--[[
			local player_naughtiness = context.config["naughtiness_verbosity"] == 2 and GetNaughtiness(context.player, context)

			if player_naughtiness then
				
			end
			--]]

			--description = CombineLines(description, naughtiness, player_naughtiness)
			naughtiness_table.description = CombineLines(naughtiness, player_naughtiness)
		end
	end

	return {
		name = "health",
		priority = 1000,
		forge_enabled = true,
		description = description,
		alt_description = alt_description,
	}, naughtiness_table
end 

return {
	Describe = Describe,
	GetData = GetData,
}