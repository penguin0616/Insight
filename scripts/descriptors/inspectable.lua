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

-- inspectable.lua
-- only using this for stuff i want information on but doesn't have any distinguishable components

local CUSTOM_RANGES = {
	book_tentacles = {
		range = 8,
		color = "#3B2249"
	},
	book_birds = {
		range = 10,
		color = Insight.COLORS.EGG
	},
	book_brimstone = {
		range = 15,
		color = "#DED15E"
	},
	book_sleep = {
		range = 30,
		color = "#525EAC",
	},
	book_gardening = { -- old one
		range = 30,
		color = Insight.COLORS.NATURE
	},

	book_meteor = {
		range = TUNING.VOLCANOBOOK_FIRERAIN_RADIUS, -- im hoping that when book_meteor exists, this exists. == 5 in SW anyway.
		color = Insight.COLORS.VEGGIE
	},

	book_horticulture = { -- new one
		range = 30,
		color = Insight.COLORS.NATURE
	},
	book_silviculture = {
		range = 30,
		color = Insight.COLORS.INEDIBLE
	},


	horn = {
		range = TUNING.HORN_RANGE,
		color = Insight.COLORS.EGG
	},
	onemanband = {
		range = TUNING.ONEMANBAND_RANGE,
		color = Insight.COLORS.MONSTER
	},
	panflute = {
		range = TUNING.PANFLUTE_SLEEPRANGE,
		color = Insight.COLORS.SHALLOWS
	},
	gnarwail_horn = {
		range = TUNING.GNARWAIL_HORN_FARM_PLANT_INTERACT_RANGE,
		color = Insight.COLORS.WET
	},
	trident = {
		range = TUNING.TRIDENT_FARM_PLANT_INTERACT_RANGE,
		color = Insight.COLORS.WET
	},

	fruitflyfruit = {
		range = 20, --upvalue in behaviours/findfarmplant
		color = "#C46A99",
		attach_player = false
	},
}

local function IsWinter()
	if IsDST() then
		return TheWorld.state.iswinter
	else
		return GetSeasonManager():IsWinter()
	end
end

local base_canary_poison_chance = 10*(100 / 12)/100
local function GetCanaryData(inst)
	if inst._gaslevel == nil then
		return {}
	end

	local data = { gas_level=inst._gaslevel }

	if inst._gasuptask then
		data.increasing = true
		data.decreasing = false
		data.time = GetTaskRemaining(inst._gasuptask)
	elseif inst._gasdowntask then
		data.increasing = false
		data.decreasing = true
		data.time = GetTaskRemaining(inst._gasdowntask)
	end

	return data
end

local function GetCanaryDescription(inst, context)
    local description = nil
    local data = GetCanaryData(inst)

    -- gaslevel > 12 and math.random() * 12 < gaslevel - 12

    --[[
	math.random() <= 1
		10% chance seems to be fair
			
	math.random() * 12 <= 1
		* 12 means its harder to fall in <= 1 
		
	]]
    -- math.random() <= 1== 1 / 10 == 10% chance
    -- math.random() * 12 < 1, *12 means its harder to be under <1, which means lesser chance...
    -- but how much less...?
    -- perhaps i could argue that its 12 times less often

    --[[
		> x=0; for i = 1, 10000 do local r = math.random() if r <= .1 then x = x + 1 end end; print(x);
		987

		we'll call this 1.0

		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		824
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		824
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		835
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		827
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		808
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		805
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		857
		> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; print(x);
		836

		-- we'll call it 0.8333
	]]
    if data.gas_level then
        -- 0.8333 = 10*(100 / 12)/100
        local strs = {}
        local poison_string

        table.insert(strs, string.format(context.lstr.canary.gas_level, data.gas_level, 13))
        if data.increasing then
            table.insert(strs, string.format(context.lstr.canary.gas_level_increase, TimeToText(time.new(data.time, context))))
        elseif data.decreasing then
            table.insert(strs, string.format(context.lstr.canary.gas_level_decrease, TimeToText(time.new(data.time, context))))
        end

        description = table.concat(strs, ", ")

        if data.gas_level > 12 then
            poison_string = string.format(context.lstr.canary.poison_chance, 10 * base_canary_poison_chance * (data.gas_level - 12))
        end

        description = CombineLines(description, poison_string)
	end
	
	return description
end

local function GetRobotChargeTime(self, context)
	if self.inst.charge_time <= 0 then
		return
	end
	
	return {
		priority = 1,
		description = string.format(context.lstr.wx78_charge, TimeToText(time.new(self.inst.charge_time, context))),
		icon = {
			tex = "ladybolt.tex",
			atlas = "images/ladybolt.xml"
		},
		playerly = true
	}
end

local function GetPlayerServerDeaths(context, amount)
	return {
		priority = 1,
		description = string.format("<color=#ffdddd>This person has died </color><color=#ff9999>%s</color><color=#ffeeee> time(s).</color>", amount),
		playerly = true
	}
end

local function PlayerDescribe(self, context)
	local inst = self.inst
	local stuff = {}

	if inst.prefab == "wx78" and inst.charge_time and inst.charge_time > 0 then -- inspectable manually added in DS
		table.insert(stuff, GetRobotChargeTime(self, context))
	end

	if false and (DEBUG_ENABLED or inst ~= context.player) and inst.userid ~= "" then
		local their_context = GetPlayerContext(inst)
		if their_context and their_context.etc.server_deaths then
			table.insert(stuff, GetPlayerServerDeaths(context, #their_context.etc.server_deaths))
		end
	end

	return unpack(stuff)
end

local function HasRange(inst)
	if CUSTOM_RANGES[inst.prefab] then
		return true
	end
end

local function RangedDescribe(self, context)
	local inst = self.inst

	local tool_range = CUSTOM_RANGES[inst.prefab].range
	local tool_range_color = CUSTOM_RANGES[inst.prefab].color
	local attach_player = CUSTOM_RANGES[inst.prefab].attach_player

	return {
		name = "insight_ranged",
		priority = 0,
		description = nil,
		range = tool_range,
		color = tool_range_color,
		attach_player = attach_player
	}
end



local function Describe(self, context)
	local inst = self.inst
	local description = nil

	if inst:HasTag("player") then
		return PlayerDescribe(self, context)
	end

	--mprint("checking range", HasRange(inst))
	if HasRange(inst) then
		return RangedDescribe(self, context)
	end

	--[[
	if DEBUG_ENABLED and inst.prefab == "razor" then
		return {
			priority = 0,
			description = "this has some  <color=#789789>damage</color>*",
			alt_description = "this has infinite <color=#789789>damage</color>."
		}
	end
	--]]

	if inst.prefab == "catcoonden" then
		if inst.lives_left then
			description = string.format(context.lstr.catcoonden.lives, inst.lives_left, 9)

			if inst.lives_left <= 0 and inst.delay_end then
				local remaining_time = inst.delay_end - GetTime()

				if remaining_time > 0 then
					description = description .. "\n" .. string.format(context.lstr.catcoonden.regenerate, TimeToText(time.new(remaining_time, context)))
				else
					description = description .. "\n" .. context.lstr.catcoonden.waiting_for_sleep
				end
			end
		end
	end

	if inst.prefab == "chester_eyebone" or inst.prefab == "hutch_fishbowl" then
		if inst.respawntask and inst.respawntime then
			description = string.format("Will respawn in: %s", TimeToText(time.new(inst.respawntime - GetTime(), context)))
		end
	end

	if inst.prefab == "stagehand" and IsDST() then -- lots of stuff here done to make it make more sense / flow better
		local mem = inst.sg.mem
		local hits_left = mem.hits_left or TUNING.STAGEHAND_HITS_TO_GIVEUP -- something to display if no hits registered
		local hit_string = nil
		local reset_string = nil

		if mem.prevtimeworked then
			local offset = GetTime() - mem.prevtimeworked
			local remaining_time = TUNING.SEG_TIME * 0.5 - offset

			if remaining_time >= 0 then
				reset_string = string.format(context.lstr.stagehand.time_to_reset, TimeToText(time.new(remaining_time, context)))
			else
				hits_left = TUNING.STAGEHAND_HITS_TO_GIVEUP -- we're technically reset to 86, though it doesn't take place until the next hit.
			end
		end
		
		hit_string = string.format(context.lstr.stagehand.hits_remaining, hits_left) 

		description = CombineLines(hit_string, reset_string)
	end

	if inst.prefab == "canary" then
		description = GetCanaryDescription(inst, context)
		--description = string.format("gas up: %s, gas down: %s, gas level: %s", up_time, down_time, inst._gaslevel or "?")
	end

	if inst:HasTag("winter_tree") then
		if context.player.components.wintertreegiftable then
			local days_remaining = Insight.descriptors.wintertreegiftable.GetDaysRemainingForRareGift(context.player.components.wintertreegiftable)

			if days_remaining > 0 then
				description = string.format(context.lstr.wintertreegiftable.not_ready, days_remaining)
			--elseif not inst.components.container:IsFull() then
				--description = context.lstr.winter_tree_needsstuff
			else
				description = context.lstr.wintertreegiftable.ready
			end
		end
	end

	if inst.prefab == "fossil_stalker" then
		local needed_pieces = 5 - inst.moundsize
		if needed_pieces > 0 then
			description = string.format(context.lstr.fossil_stalker.pieces_needed, needed_pieces)
		else
			if inst.form == 1 then
				description = context.lstr.fossil_stalker.correct
			else
				description = context.lstr.fossil_stalker.incorrect
			end
		end
	end

	if inst.prefab == "trap_starfish" and context.config["display_attack_range"] then
		local dmg, reset = string.format(context.lstr.damage, TUNING.STARFISH_TRAP_DAMAGE), nil
		if inst._reset_task then
			reset = string.format(context.lstr.trap_starfish_cooldown, TimeToText(time.new(GetTaskRemaining(inst._reset_task), context)))
		end

		description = CombineLines(dmg, reset)
	end

	if inst.prefab == "lureplant" then
		if inst.hibernatetask and not IsWinter() then
			description = string.format(context.lstr.lureplant_active, TimeToText(time.new(GetTaskRemaining(inst.hibernatetask), context)))
		end
	end

	if inst.prefab == "walrus_camp" then
		if inst.data.regentime then
			local strs = {}
			for prefab, targettime in pairs(inst.data.regentime) do
				local respawn_in = targettime - GetTime()
				if respawn_in >= 0 then
					respawn_in = TimeToText(time.new(respawn_in, context))
					table.insert(strs, string.format(context.lstr.walrus_camp_respawn, STRINGS.NAMES[string.upper(prefab)] or ("\"" .. prefab .. "\""), respawn_in))
				end
			end
			description = table.concat(strs, "\n")
		end
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
				if CurrentRelease.GreaterOrEqualTo("R15_QOL_WORLDSETTINGS") then
					frog_rain_chance = string.format(context.lstr.frog_rain_chance, Round(TUNING.FROG_RAIN_CHANCE * 100, 1))
				else
					frog_rain_chance = string.format(context.lstr.frog_rain_chance, Round(frog_rain:OnSave().chance * 100, 1))
				end
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

	if inst:HasTag("slingshotammo") and context.player:HasTag("slingshot_sharpshooter") then
		local data = Insight.descriptors.weapon.GetSlingshotAmmoData(inst)
		local damage = data and data.damage
		description = string.format(context.lstr.weapon_damage, context.lstr.weapon_damage_type.normal, damage or "?")
	end

	if inst:HasTag("abigail_flower") and context.player.components.ghostlybond then
		local ghostlybond = context.player.components.ghostlybond

		if ghostlybond.bondleveltimer then
			local ghostlybond_levelup_time = TimeToText(time.new(ghostlybond.bondlevelmaxtime - ghostlybond.bondleveltimer, context))
			description = string.format(context.lstr.ghostlybond_self, ghostlybond.bondlevel, ghostlybond.maxbondlevel, ghostlybond_levelup_time)
		end
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
	Describe = Describe,
	GetCanaryDescription = GetCanaryDescription
}