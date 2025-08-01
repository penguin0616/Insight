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

-- acidbatwavemanager.lua
local easing = require("easing")

local low_chance = Color.fromHex("#ffffff")
local high_chance = Color.fromHex("#ded15e")

local function DescribeBatWaveData(self, context, data)
	local description = nil

	-- target_prefab_count = num
	-- spawn_wave_time = time
	-- odds_to_spawn_wave = 1
	-- last_warn_time = time



	-- TODO: There's currently a bug where items in backpack or open chests don't count towards the raid.
	-- Looks like a bug with that inventory method used to count them?
	local chance_string
	if data.target_prefab_count and data.odds_to_spawn_wave then
		local official_chance = data.odds_to_spawn_wave
		local estimated_chance = easing.inQuad(data.target_prefab_count, 0, 1, self.max_target_prefab)

		chance_string = string.format(context.lstr.acidbatwavemanager.chance,
			low_chance:Lerp(high_chance, official_chance):ToHex(),
			official_chance * 100,
			low_chance:Lerp(high_chance, estimated_chance):ToHex(),
			estimated_chance * 100
		)
	end

	local spawn_wave_string
	if data.spawn_wave_time then
		-- Incoming raid
		local items_percent = data.target_prefab_count / self.max_target_prefab
		local number_of_bats = math.floor(items_percent * (TUNING.ACIDBATWAVE_SPAWN_COUNT_MAX - TUNING.ACIDBATWAVE_SPAWN_COUNT_MIN) + TUNING.ACIDBATWAVE_SPAWN_COUNT_MIN)

		local next_spawn_time = (data.spawn_wave_time - GetTime()) + self.update_time_seconds
		spawn_wave_string = string.format(context.lstr.acidbatwavemanager.next_wave_spawn, 
			number_of_bats,
			context.time:SimpleProcess(next_spawn_time)
		)
	end
	
	local wave_cooldown_string
	if data.next_wave_time then
		-- This is the cooldown (i.e. "immunity period") after being subject to a bat raid.
		local wave_cooldown = (data.next_wave_time - GetTime())
		if wave_cooldown >= 0 then
			wave_cooldown_string = string.format(context.lstr.cooldown, context.time:SimpleProcess(wave_cooldown))
		end
	end

	-- I don't really see the benefit of warn time, so we'll ignore that.
	--[[
	local warn_time_string
	if data.last_warn_time then
		warn_time_string = string.format("Last warn time: %.1f", data.last_warn_time)
	end
	--]]

	--[[
	if type(data.target_prefab_count) == "number" then
	
		local chance = data.target_prefab_count / self.max_target_prefab
		
		chance_string = string.format("Chance of bat raid: %s / %s (<color=%s>%d%%</color>)", 
			ApplyColor(data.target_prefab_count, low_chance:Lerp(high_chance, chance)),
			ApplyColor(self.max_target_prefab, high_chance),
			low_chance:Lerp(high_chance, chance):ToHex(),
			chance * 100
		)
	end
	--]]

	-- Put it all together!
	local priority = 0

	if spawn_wave_string then
		priority = 10
		description = spawn_wave_string
	elseif wave_cooldown_string then
		description = wave_cooldown_string
	else
		-- Only show the wave chance if we don't have an incoming wave.
		description = chance_string
	end

	--description = CombineLines(description, spawn_wave_string, wave_cooldown_string)

	return {
		name = "acidbatwavemanager_" .. context.player.userid .. "_watch",
		priority = 0,
		worldly = true,
		playerly = true,
		icon = {
			-- Wiki says they apparently have an inventoryimage. I'll take it!
			atlas = "images/Bat.xml",
			tex = "Bat.tex",
		},
		description = description,
	}
end

local function Describe(self, context)
	local description = nil

	if not context.config["display_batwave_information"] then
		return
	end

	local returns = {}

	--[[
	for userid, data in pairs(self.savedplayermetadata) do
		x = ""
		table.foreach(data, function(i,v) x = x .. tostring(i) .. " = " .. tostring(v) .. "\n" end)

		returns[#returns+1] = {
			name = "acidbatwavemanager_" .. userid .. "_save",
			priority = 0,
			worldly = true,
			playerly = true,
			description = x,
		}
	end
	--]]


	local my_watcher_data = self.watching[context.player]
	if my_watcher_data then
		returns[#returns+1] = DescribeBatWaveData(self, context, my_watcher_data)
	end

	--[[
	for player, data in pairs(self.watching) do
		x=tostring(player) .. "--"; table.foreach(data, function(i,v) x = x .. tostring(i) .. " = " .. tostring(v) .. "\n" end)

		returns[#returns+1] = {
			name = "acidbatwavemanager_" .. context.player.userid .. "_asd",
			priority = 0,
			worldly = true,
			playerly = true,
			description = x,
		}
	end

	return {
		name = "acidbatwavemanager",
		priority = 0,
		worldly = true,
		description = description,
	}, 
	--]]
	
	return unpack(returns)
end

return {
	Describe = Describe
}