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

-- terrarium.lua [Prefab]
local HEALTH_PER_DAY = TUNING.EYEOFTERROR_HEALTHPCT_PERDAY * TUNING.EYEOFTERROR_HEALTH -- =250
local MAX_GAIN_DAYS = 1/TUNING.EYEOFTERROR_HEALTHPCT_PERDAY -- =20


local function DescribeCooldown(inst, context)
	local cooldown = TheWorld.shard.components.shard_insight:GetTerrariumCooldown() or -1

	if cooldown < 0 then
		return
	end

	return {
		name = "terrarium",
		priority = 0,
		description = context.time:SimpleProcess(cooldown),
		icon = {
			atlas = "images/Terrarium.xml",
			tex = "Terrarium.tex",
		},
		worldly = true,
		prefably = true,
		from = "prefab",
		cooldown = cooldown,
	}
end


local function Describe(inst, context)
	local description, alt_description = nil, nil

	local daily_recover = string.format(context.lstr.terrarium.day_recovery, HEALTH_PER_DAY)
	local next_health = nil

	local eot = inst.eyeofterror

	if eot then
		if eot.prefab == "eyeofterror" then
			if eot:IsInLimbo() then
				local day_difference = eot._leftday and math.min(TheWorld.state.cycles - eot._leftday, MAX_GAIN_DAYS) or nil
				description = string.format("cycles: %s, leftday:", TheWorld.state.cycles or "x", eot._leftday or "y")
				
				-- calculate health restore
				local health_restore = 0
				if day_difference and day_difference > 0 then
					health_restore = HEALTH_PER_DAY * day_difference
				end

				-- figure out new health
				local health, max_health = (eot.components.health and eot.components.health.currenthealth or nil), (eot.components.health and eot.components.health:GetMaxWithPenalty())
				if health and max_health then
					next_health = string.format(context.lstr.terrarium.eot_health, health + health_restore, max_health)
				end
			end
			description = CombineLines(next_health, daily_recover)
		elseif eot.prefab == "twinmanager" then
			--description = string.format("\"twinsmanager\" -> IsValid: <color=#00D1FF>%s</color>, IsInLimbo: <color=#00D1FF>%s</color>", tostring(eot:IsValid()), tostring(eot:IsInLimbo()))
			--local hardmode_days_left = eot._hardmode_days_reset_counter and eot._hardmode_days_reset_counter - TheWorld.state.cycles or nil
			local retinazor = eot.components.entitytracker and eot.components.entitytracker:GetEntity("twin1")
			local spazmatism = eot.components.entitytracker and eot.components.entitytracker:GetEntity("twin2")

			-- calculate health restore
			local health_restore = 0
			-- they despawn if not fought for a day so...
			--[[
			if day_difference and day_difference > 0 then
				health_restore = HEALTH_PER_DAY * day_difference
			end
			--]]


			--local hardmode = string.format("hardmode days left:", hardmode_days_left)
			local retinazor_next_health = nil
			if retinazor then
				local health, max_health = (retinazor.components.health and retinazor.components.health.currenthealth or nil), (retinazor.components.health and retinazor.components.health:GetMaxWithPenalty())
				if health and max_health then
					retinazor_next_health = string.format(context.lstr.terrarium.retinazor_health, health + health_restore, max_health)
				end
			end

			local spazmatism_next_health = nil
			if spazmatism then
				local health, max_health = (spazmatism.components.health and spazmatism.components.health.currenthealth or nil), (spazmatism.components.health and spazmatism.components.health:GetMaxWithPenalty())
				if health and max_health then
					spazmatism_next_health = string.format(context.lstr.terrarium.spazmatism_health, health + health_restore, max_health)
				end
			end

			description = CombineLines(retinazor_next_health, spazmatism_next_health)
		end
	else
		--alt_description = string.format("eot exists: %s", tostring(eot ~= nil))
	end
	
	-- so i have to display information about the cooldown and the boss health stuff
	-- if i want to do the latter, it can't be worldly but can't show cooldown
	-- if i want to do the former, it has to be worldly but can't show health
	-- this is what i am resorting to
	-- i don't even remember why i put the worldly check in place. wonder what would happen if i removed it.
	-- but i don't want to bother with it for now, so i'll do this.
	return {
		name = "terrarium_health",
		priority = 0,
		description = description,
		prefably = true,
	}

end

local function StatusAnnoucementsDescribe(special_data, context)
	if not special_data.cooldown then
		return
	end

	return ProcessRichTextPlainly(string.format(
		context.lstr.terrarium.announce_cooldown,
		context.time:TryStatusAnnouncementsTime(special_data.cooldown)
	))
end

return {
	Describe = Describe,
	DescribeCooldown = DescribeCooldown,
	StatusAnnoucementsDescribe = StatusAnnoucementsDescribe
}