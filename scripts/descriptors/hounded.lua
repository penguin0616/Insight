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

-- hounded.lua [Worldly]
local icons = {
	hound = {
		atlas = "images/Hound.xml",
		tex = "Hound.tex",
	},
	worm = {
		atlas = "images/Depths_Worm.xml",
		tex = "Depths_Worm.tex",
	},
	worm_boss = {
		atlas = "images/Worm_boss.xml",
		tex = "Worm_boss.tex",
	},
	crocodog = {
		atlas = "images/Crocodog.xml",
		tex = "Crocodog.tex",
	},
}

local function GetAttackType(next_wave_is_wormboss)
	if IS_DST then
		world_prefab = TheWorld.worldprefab
	else
		world_prefab = GetWorld().prefab
	end

	local attack_type
	if world_prefab == "forest" then
		attack_type = "hound"
	elseif world_prefab == "cave" then
		if next_wave_is_wormboss then
			attack_type = "worm_boss"
		else
			attack_type = "worm"
		end
	elseif world_prefab == "shipwrecked" then
		attack_type = "crocodog"
	end

	return attack_type
end

local function GetAttackString(context, attack_type)
	if attack_type == "hound" then
		return context.lstr.hounded.time_until_hounds
	elseif attack_type == "worm" then
		return context.lstr.hounded.time_until_worms
	elseif attack_type == "worm_boss" then
		return context.lstr.hounded.time_until_worm_boss
	elseif attack_type == "crocodog" then
		return context.lstr.hounded.time_until_crocodog
	end
end

local function Describe(self, context)
	local description = nil

	local time_to_attack = nil
	local warning = nil
	
	if IS_DST then
		time_to_attack = self:GetTimeToAttack()
		warning = self:GetWarning()
	else
		time_to_attack = self.timetoattack
		warning = self.warning
	end

	-- I don't remember why I had this behaviour originally.
	-- I think there was a bug with a client side dependency on time to attack,
	-- probably something along the lines of it not clearing for announcements.
	if time_to_attack <= 0 then
		return
	end
	
	--[[
	WORM_BOSS_DAYS is 25, daycount must exceed to start accumulating chance

	"houndwarning" event pushed for players to start getting the effects
	PlanNextAttack looks for spawndata.specialupgradecheck 
		_wave_pre_upgraded, _wave_override_chance = _spawndata.specialupgradecheck(
			_wave_pre_upgraded, 
			_wave_override_chance, 
			_wave_override_settings
		)

	wave override settings: 0, 0.5, 1, 2, 9999 

	each time specialupgradecheck is called (PlanNextAttack called), 
		if we roll < wave_override_chance, set override chance to zero and say pre_upgraded is "available"
		otherwise, return nil and wave override chance += 0.05, up to 50%
	
	add who the boss is targeting - maybe not
	--]]

	local can_wormbosses_spawn = TUNING.WORM_BOSS_DAYS ~= nil and TheWorld.state.cycles > TUNING.WORM_BOSS_DAYS
	local next_wave_is_wormboss = nil
	local wormboss_chance_string = nil

	if IS_DST and can_wormbosses_spawn then
		next_wave_is_wormboss = util.recursive_getupvalue(self.DoWarningSpeech, "_wave_pre_upgraded")
		local _wave_override_chance = self:OnSave().wave_override_chance

		if type(_wave_override_chance) == "number" then
			wormboss_chance_string = string.format(context.lstr.hounded.worm_boss_chance, _wave_override_chance * 100)
		end

		--local asd = string.format("pre: %s, chance: %.2f", tostring(_wave_pre_upgraded), _wave_override_chance)
	end


	local attack_type = GetAttackType(next_wave_is_wormboss)
	local attack_string = GetAttackString(context, attack_type)

	if not attack_string then
		return
	end

	description = string.format(attack_string, context.time:SimpleProcess(time_to_attack))

	if attack_type == "worm" then
		-- If the next wave is a worm boss, we don't really care about the chance, 
		-- since the chance will have reset to zero. So we'll only show it if the next
		-- attack type is normal depth worms.
		description = CombineLines(description, wormboss_chance_string)
	end

	return {
		priority = 5,
		description = description,
		icon = icons[attack_type],
		time_to_attack = time_to_attack,
		warning = warning,
		next_wave_is_wormboss = next_wave_is_wormboss,
		worldly = true
	}
end

local function StatusAnnouncementsDescribe(special_data, context)
	if not special_data.time_to_attack then
		-- Not like we can do anything...
		return
	end

	local description = nil
	local attack_type = GetAttackType(special_data.next_wave_is_wormboss)
	local attack_type_string = GetAttackString(context, attack_type)

	if not attack_type_string then
		return
	end

	description = string.format(
		ProcessRichTextPlainly(attack_type_string),
		context.time:TryStatusAnnouncementsTime(special_data.time_to_attack)
	)

	return {
		description = description,
		append = true
	}
end

local function DangerAnnouncementDescribe(special_data, context)
	if not special_data.time_to_attack then
		return
	end

	local time_string = context.time:SimpleProcess(special_data.time_to_attack, "realtime")
	
	local description = nil
	local attack_type = GetAttackType(special_data.next_wave_is_wormboss)
	local attack_type_string = GetAttackString(context, attack_type)

	if not attack_type_string then
		return
	end
	
	return string.format(
		attack_type_string, 
		time_string
	)
end

return {
	Describe = Describe,
	StatusAnnouncementsDescribe = StatusAnnouncementsDescribe,
	DangerAnnouncementDescribe = DangerAnnouncementDescribe
}