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

-- sanityaura.lua
local function IsAuraImmune(inst, player)
	local sanity = player.components.sanity

	if not sanity then
		return true -- can't be affected by sanity auras if you don't have sanity ;)
	end

	if sanity.sanity_aura_immune then
		return true
	end

	if sanity.sanity_aura_immunities ~= nil then
		for tag in pairs(sanity.sanity_aura_immunities) do
			if v:HasTag(tag) then
				return true
			end
		end
	end

	return false
end

local function GetAuraValue(self, player)
	if IsAuraImmune(self.inst, player) then
		return 0
	end

	local sanity = player.components.sanity

	local value = self:GetAura(player)

	--[[
		aura_val =
		(aura_val < 0 and (self.neg_aura_absorb > 0 and self.neg_aura_absorb * -aura_val or aura_val) * self:GetAuraMultipliers() or aura_val)

		aura_delta = aura_delta + ((aura_val < 0 and self.neg_aura_immune) and 0 or aura_val)
	]]
	
	if value < 0 then
		if sanity.neg_aura_absorb > 0 then
			-- having this means the aura gets inverted inside sanity (instead of hivehat) for some reason. 
			value = sanity.neg_aura_absorb * -value
		end

		value = value * sanity:GetAuraMultipliers()

		-- if we are still negative after the neg_aura_absorb check, need to nullify if we are immune to negative auras
		if value < 0 and sanity.neg_aura_immune then
			value = 0
		end
	end

	return value
end

local function Describe(self, context)
	-- note: this gets called by burnable.lua with self == burnable, so be careful about adding specifics to burnable
	if not context.config["display_sanityaura"] then
		return
	end
	
	local description = nil
	
	if not self.inst:IsValid() then
		return
	end

	local sanity = context.player.components.sanity
	if not context.player.components.sanity then
		return
	end
	
	local aura = context.burnable_sanity_aura or GetAuraValue(self, context.player)
	aura = aura * 60 * (context.player.components.sanity.rate_modifier or 1)

	if aura ~= 0 then
		description = string.format(context.lstr.sanityaura, FormatDecimal(aura, context.burnable_sanity_aura_round or 1))
	end

	return {
		name = "sanityaura",
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}