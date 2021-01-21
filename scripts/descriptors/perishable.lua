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

-- perishable.lua
local function Perish(self, bundle)
	local inst
	if bundle then
		assert(self == nil, "[Insight]: Perish called with both 'self' and 'bundle'.")
		inst = bundle
	else
		assert(self ~= nil, "[Insight]: Perish called without 'self'.")
		inst = self.inst
	end
	
	assert(inst, "[Insight]: Perish called without inst")

	local modifier = 1
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil

	if owner then
		if owner:HasTag("fridge") then
			if GetWorldType() == 0 then
				modifier = TUNING.PERISH_FRIDGE_MULT 
			else -- rog, sw, hamlet
				if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
					modifier = TUNING.PERISH_COLD_FROZEN_MULT
				else
					modifier = TUNING.PERISH_FRIDGE_MULT 
				end
			end
		-- accounts for all world types
		elseif owner:HasTag("spoiler") and owner:HasTag("poison") then
			modifier = TUNING.PERISH_POISON_MULT
		elseif owner:HasTag("spoiler") then
			modifier = TUNING.PERISH_GROUND_MULT 
		end
	else
		modifier = TUNING.PERISH_GROUND_MULT
	end

	if GetWorldType() > 0 then -- dlcs
		-- Cool off hot foods over time (faster if in a fridge)
		if inst.components.edible and inst.components.edible.temperaturedelta and inst.components.edible.temperaturedelta > 0 then
			if owner and owner:HasTag("fridge") then
				if not owner:HasTag("nocool") then
					inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - 1
				end
			elseif GetSeasonManager() and GetSeasonManager():GetCurrentTemperature() < TUNING.OVERHEAT_TEMP - 5 then
				inst.components.edible.temperatureduration = inst.components.edible.temperatureduration - .25
			end
			if inst.components.edible.temperatureduration < 0 then inst.components.edible.temperatureduration = 0 end
		end

		local mm = GetWorld().components.moisturemanager
		if mm:IsEntityWet(inst) then
			modifier = modifier * TUNING.PERISH_WET_MULT
		end
	end

	if GetSeasonManager() and GetSeasonManager():GetCurrentTemperature() < 0 then
		-- PERISHABLE only
		if self then
			-- only dlcs have frozen tag
			if inst:HasTag("frozen") and not inst.components.perishable.frozenfiremult then
				modifier = TUNING.PERISH_COLD_FROZEN_MULT
			else
				modifier = modifier * TUNING.PERISH_WINTER_MULT
			end
		end
	end

	-- PERISHABLE only
	if self and inst.components.perishable.frozenfiremult then
		modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
	end

	if GetWorldType() > 0 then
		if GetSeasonManager() and GetSeasonManager():GetCurrentTemperature() > TUNING.OVERHEAT_TEMP then
			modifier = modifier * TUNING.PERISH_SUMMER_MULT
		end	
	end

	if GetAporkalypse and GetAporkalypse() then
		local aporkalypse = GetAporkalypse()
		if aporkalypse and aporkalypse:IsActive() then
			modifier = modifier * TUNING.PERISH_APORKALYPSE_MULT
		end
	end
	
	modifier = modifier * TUNING.PERISH_GLOBAL_MULT

	return modifier
end

local function DST_Perish(self, bundle)
	local inst
	if bundle then
		assert(self == nil, "[Insight]: DST_Perish called with both 'self' and 'bundle'.")
		inst = bundle
	else
		assert(self ~= nil, "[Insight]: DST_Perish called without 'self'.")
		inst = self.inst
	end

	assert(inst, "[Insight]: DST_Perish called without inst")

	local modifier = 1
	local owner = inst.components.inventoryitem and inst.components.inventoryitem.owner or nil
	if not owner and inst.components.occupier then
		owner = inst.components.occupier:GetOwner()
	end

	if owner then
		if owner.components.preserver ~= nil then
			modifier = owner.components.preserver:GetPerishRateMultiplier(inst) or modifier
		elseif owner:HasTag("fridge") then
			if inst:HasTag("frozen") and not owner:HasTag("nocool") and not owner:HasTag("lowcool") then
				modifier = TUNING.PERISH_COLD_FROZEN_MULT
			else
				modifier = TUNING.PERISH_FRIDGE_MULT
			end
		elseif owner:HasTag("foodpreserver") then
			modifier = TUNING.PERISH_FOOD_PRESERVER_MULT
		elseif owner:HasTag("cage") and inst:HasTag("small_livestock") then
			modifier = TUNING.PERISH_CAGE_MULT
		end

		if owner:HasTag("spoiler") then
			modifier = modifier * TUNING.PERISH_GROUND_MULT
		end
	else
		modifier = TUNING.PERISH_GROUND_MULT
	end

	-- PERISHABLE ONLY
	if self and inst:GetIsWet() and not self.ignorewentness then -- its actually not a typo trust me
		modifier = modifier * TUNING.PERISH_WET_MULT
	end

	if TheWorld.state.temperature < 0 then
		if inst:HasTag("frozen") and not self.frozenfiremult then
			modifier = TUNING.PERISH_COLD_FROZEN_MULT
		else
			modifier = modifier * TUNING.PERISH_WINTER_MULT
		end
	end

	-- PERISHABLE only
	if self and self.frozenfiremult then
		modifier = modifier * TUNING.PERISH_FROZEN_FIRE_MULT
	end

	if TheWorld.state.temperature > TUNING.OVERHEAT_TEMP then
		modifier = modifier * TUNING.PERISH_SUMMER_MULT
	end

	-- PERISHABLE only
	if self then
		modifier = modifier * self.localPerishMultiplyer
	end

	modifier = modifier * TUNING.PERISH_GLOBAL_MULT

	return modifier
end

local function GetPerishModifier(...)
	if IsDST() then
		return DST_Perish(...)
	elseif IsDS() then
		return Perish(...)
	end
	
	return nil
end

local function Describe(self, context) 
	local description, alt_description

	local formatType = context.config["perishable_format"]

	if context.bundleitem then
		local modifier = GetPerishModifier(nil, context.bundleitem.bundle)

		return {
			priority = 0,
			description = string.format(context.lstr.perishable_transition, context.lstr.rot, TimeToText(time.new(context.bundleitem.perishremainingtime, context))),
			perishmodifier = modifier,
		}
	end

	local inst = self.inst
	--local modifier = GetPerishModifier(inst)
	if formatType > 0 then
		--if (hasSpecialTag(inst) and player) or not hasSpecialTag(inst) then -- captured animals should not have a perishable description unless in our inventory
		if context.player then
			local modifier = GetPerishModifier(self)

			if modifier ~= 0 and self.perishremainingtime and self.updatetask and self.updatetask:NextTime() then
				-- SmartCrockPot (https://steamcommunity.com/sharedfiles/filedetails/?id=732554330) when mousing over the prediction, NextTime returns nil
				-- not sure why, but self.updatetask.nexttick is nil, so :NextTime() is nil
				-- 5/3/2020

				local nextUpdateIn = self.updatetask:NextTime() - GetTime() -- used to give the illusion of perishing being realtime when in reality it perishes every 10 seconds
				
				-- wont be perfect but im frustrated at this point
				local remaining_time, str
				
				if inst.components.health then
					remaining_time = self.perishremainingtime
					str = context.lstr.dies

				elseif self:IsSpoiled() or formatType == 1 then -- spoiled or only until rot
					remaining_time = self.perishremainingtime
					str = context.lstr.rot

				elseif self:IsFresh() then
					remaining_time = self.perishremainingtime - (self.perishtime * 0.5) -- >=
					str = context.lstr.stale

				elseif self:IsStale() then
					remaining_time = self.perishremainingtime - (self.perishtime * 0.2) -- >
					str = context.lstr.spoil

				end

				-- Refresh Your Foods Back (https://steamcommunity.com/sharedfiles/filedetails/?id=732554330) reverses the remaining time.
				-- makes the modifier negative when you put in ice box, so time.new panics
				-- i don't think I'll need to change nextUpdateIn
				-- 5/4/2020
				
				remaining_time = remaining_time / modifier + nextUpdateIn
				local percent = (self.perishremainingtime and self.perishtime and self.perishtime > 0 and math.min(1, (self.perishremainingtime / modifier + nextUpdateIn) / self.perishtime)) or 0 -- do percent ourself because perishable is periodic

				remaining_time = time.new(math.abs(remaining_time), context)
				remaining_time = TimeToText(remaining_time)

				description = string.format(context.lstr.perishable_transition, str, remaining_time)
				
				alt_description = string.format(context.lstr.perishable_transition_extended, str, remaining_time, Round(percent * 100, 1))
			else
				if self.updatetask and self.updatetask:NextTime() == nil then
					-- if the update task is missing, I don't think I actually want to classify this as "perishable"
					-- because there's a difference between a paused perishing and something that doesn't perish correctly
					-- yknow?
					-- wish I didn't have to put this here specifically anyway, but the mod in question creates a physical prefab and puts it in the slot, so it gets through the IsPrefab check
					description = nil
				else
					if inst:HasTag("critter") or (inst.components.health and inst.components.inventoryitem and inst.components.inventoryitem:IsHeld() == false) then
						-- no description for non-held creatures, or critters
						description = nil
					else
						description = context.lstr.perishable_paused
					end
				end
			end 
		end
	end

	-- self.updatetask

	return {
		priority = 1,
		description = description,
		alt_description = (description and alt_description) or nil,
	}
end



return {
	Describe = Describe
}