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
local function ShouldShowLocalPlayerNaughtiness(context)
	--[[
	if IS_DST then
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

	-- Piggybacking off of health (since all things with naughtiness are living things) to display naughtiness value.
	local naughtiness_value_info = nil
	local player_naughtiness_info = nil

	if type(context.config["naughtiness_verbosity"]) == "number" and context.config["naughtiness_verbosity"] > 0 then
		if inst:HasTag("player") then
			if inst ~= context.player and context.config["naughtiness_verbosity"] == 2 then
				naughtiness_value_info = Insight.descriptors.kramped 
										and Insight.descriptors.kramped.DescribePlayer 
										and Insight.descriptors.kramped.DescribePlayer(inst, context)
			end
		else
			naughtiness_value_info = Insight.descriptors.kramped 
									and Insight.descriptors.kramped.DescribeCreature 
									and Insight.descriptors.kramped.DescribeCreature(inst, context)
			if ShouldShowLocalPlayerNaughtiness(context) then
				player_naughtiness_info = Insight.descriptors.kramped 
										and Insight.descriptors.kramped.DescribePlayer 
										and Insight.descriptors.kramped.DescribePlayer(context.player, context)
			end
		end
	end

	return {
		name = "health",
		priority = 200000,
		forge_enabled = true,
		description = description,
		alt_description = alt_description,
	}, naughtiness_value_info, player_naughtiness_info
end 

return {
	Describe = Describe,
	GetData = GetData,
}