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


	
	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}