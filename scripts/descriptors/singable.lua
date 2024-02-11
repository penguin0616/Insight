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

-- singable.lua
local song_tunings = require("prefabs/battlesongdefs").song_defs

local function Describe(self, context)
	local description = nil
	
	if not self.inst.songdata then
		return
	end

	local effect
	-- Songs
	if self.inst.songdata == song_tunings.battlesong_durability then
		effect = string.format(context.lstr.singable.battlesong.battlesong_durability, Round((1 - TUNING.BATTLESONG_DURABILITY_MOD) * 100, 0))
		
	elseif self.inst.songdata == song_tunings.battlesong_healthgain then
		effect = string.format(context.lstr.singable.battlesong.battlesong_healthgain, TUNING.BATTLESONG_HEALTHGAIN_DELTA, TUNING.BATTLESONG_HEALTHGAIN_DELTA_SINGER)
		
	elseif self.inst.songdata == song_tunings.battlesong_sanitygain then
		effect = string.format(context.lstr.singable.battlesong.battlesong_sanitygain, TUNING.BATTLESONG_SANITYGAIN_DELTA)

	elseif self.inst.songdata == song_tunings.battlesong_sanityaura then
		effect = string.format(context.lstr.singable.battlesong.battlesong_sanityaura, Round((1 - TUNING.BATTLESONG_NEG_SANITY_AURA_MOD) * 100, 0))

	elseif self.inst.songdata == song_tunings.battlesong_fireresistance then
		effect = string.format(context.lstr.singable.battlesong.battlesong_fireresistance, Round((1 - TUNING.BATTLESONG_FIRE_RESIST_MOD) * 100, 0))
	
	elseif self.inst.songdata == song_tunings.battlesong_lunaraligned then
		effect = string.format(context.lstr.singable.battlesong.battlesong_lunaraligned, 
			(1 - TUNING.BATTLESONG_LUNARALIGNED_LUNAR_RESIST) * 100, 
			(TUNING.BATTLESONG_LUNARALIGNED_VS_SHADOW_BONUS - 1) * 100
		)
	
	elseif self.inst.songdata == song_tunings.battlesong_shadowaligned then
		effect = string.format(context.lstr.singable.battlesong.battlesong_shadowaligned, 
			(1 - TUNING.BATTLESONG_SHADOWALIGNED_SHADOW_RESIST) * 100, 
			(TUNING.BATTLESONG_SHADOWALIGNED_VS_LUNAR_BONUS - 1) * 100
		)
		
	-- Stingers
	elseif self.inst.songdata == song_tunings.battlesong_instant_taunt then
		effect = context.lstr.singable.battlesong.battlesong_instant_taunt
		
	elseif self.inst.songdata == song_tunings.battlesong_instant_panic then
		effect = string.format(context.lstr.singable.battlesong.battlesong_instant_panic, TUNING.BATTLESONG_PANIC_TIME)
	
	elseif self.inst.songdata == song_tunings.battlesong_instant_revive then
		effect = string.format(context.lstr.singable.battlesong.battlesong_instant_revive, TUNING.BATTLESONG_INSTANT_REVIVE_NUM_PLAYERS)

	end

	local cost
	if self.inst.songdata.DELTA then
		cost = string.format(context.lstr.singable.cost, Round(self.inst.songdata.DELTA, 0))
	end

	local cooldown
	if self.inst.songdata.COOLDOWN then
		cooldown = string.format(context.lstr.singable.cooldown, context.time:SimpleProcess(self.inst.songdata.COOLDOWN, "realtime_short"))
	end

	description = CombineLines(effect, cost)
	alt_description = CombineLines(effect, cost, cooldown)

	if context.player.components.skilltreeupdater and context.player.components.skilltreeupdater:IsActivated("wathgrithr_songs_instantsong_cd") then
		description = alt_description
	end

	return {
		priority = 5,
		description = description,
		alt_description = alt_description,
	}
end



return {
	Describe = Describe
}