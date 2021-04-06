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

-- me

return {
	-- insightservercrash.lua
	server_crash = "This server has crashed. The cause is unknown.",
	
	-- modmain.lua
	dragonfly_ready = "Ready to fight.",

	-- time.lua
	time_segments = "%s segment(s)",
	time_days = "%s day(s), ",
	time_days_short = "%s day(s)",
	time_seconds = "%s second(s)",
	time_minutes = "%s minute(s), ",
	time_hours = "%s hour(s), ",

	-- meh
	seasons = {
		autumn = "<color=#CE5039>Autumn</color>",
		winter = "<color=#95C2F4>Winter</color>",
		spring = "<color=#7FC954>Spring</color>",
		summer = "<color=#FFCF8C>Summer</color>",
	},

	-------------------------------------------------------------------------------------------------------------------------

	-- appeasement.lua
	appease_good = "Delays eruption by %s segment(s).",
	appease_bad = "Hastens eruption by %s segment(s).",

	-- appraisable.lua
	appraisable = "Fearsome: %s, Festive: %s, Formal: %s",

	-- armor.lua
	protection = "<color=HEALTH>Protection</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>Durability</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>Durability</color>: <color=#C0C0C0>%s</color>",

	-- beard.lua
	beard = "Your beard will improve in %s day(s).",

	-- beargerspawner.lua
	incoming_bearger_targeted = "<color=%s>Target: %s</color> -> %s",

	-- boathealth.lua
	-- use 'health' from 'health'

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>Tropical Fish</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>Purple Grouper</color>",
	breeder_fish4 = "<color=#DED15E>Pierrot Fish</color>",
	breeder_fish5 = "<color=#9ADFDE>Neon Quattro</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "Additional fish in: %s",
	breeder_possiblepredatortime = "May spawn a predator in: %s",

	-- burnable.lua
	burnable = {
		smolder_time = "Will <color=LIGHT>ignite</color> in: <color=LIGHT>%s</color>",
		burn_time = "Remaining <color=LIGHT>burn time</color>: <color=LIGHT>%s</color>",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "Waiting for you to return to a crime scene.",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN>%s</color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN>%s</color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		both_regen = "<color=MOB_SPAWN>%s</color> & <color=MOB_SPAWN>%s</color>",
		regenerating = "Regenerating %s in: %s",
		entity = "<color=MOB_SPAWN>%s</color>",
	},

	-- combat.lua
	damage = "<color=HEALTH>Damage</color>: <color=HEALTH>%s</color>",
	damageToYou = " (<color=HEALTH>%s</color> to you)",

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "Cooldown: %s",

	-- crabkingspawner.lua
	crabking_spawnsin = "%s",

	-- crittertraits.lua
	dominant_trait = "Dominant trait: %s",

	-- crop.lua
	crop_paused = "Paused.",
	growth = "<color=NATURE>%s</color>: <color=NATURE>%s</color>",

	-- dapperness.lua
	dapperness = "<color=SANITY>Sanity</color>: <color=SANITY>%s/min</color>",

	-- debuffable.lua
	buff_text = "<color=MAGIC>Buff</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = "Makes attacks <color=HEALTH>%s%% stronger</color> for %s(s).",
		["buff_playerabsorption"] = "Take <color=MEAT>%s%%</color> less damage for %s(s).",
		["buff_workeffectiveness"] = "Your work is <color=#DED15E>%s%%</color> more effective for %s(s).",
		
		["buff_moistureimmunity"] = "You are immune to <color=WET>wetness</color> for %s(s).",
		["buff_electricattack"] = "Your attacks are <color=WET>electric</color> for %s(s).",
		["buff_sleepresistance"] = "You resist <color=MONSTER>sleep</color> for %s(s).",
		
		["tillweedsalve_buff"] = "Regenerates <color=HEALTH>%s health</color> over %s(s).",
		["healthregenbuff"] = "Regenerates <color=HEALTH>%s health</color> over %s(s).",
		["sweettea_buff"] = "Regenerates <color=SANITY>%s sanity</color> over %s(s).",
	},

	-- deerclopsspawner.lua
	incoming_deerclops_targeted = "<color=%s>Target: %s</color> -> %s",

	-- diseaseable.lua
	disease_in = "Will become diseased in: %s",
	disease_spread = "Will spread disease in: %s",
	disease_delay = "Disease is delayed for: %s",

	-- domesticable.lua
	domesticable = {
		domestication = "Domestication: %s%%",
		obedience = "Obedience: %s%%",
		tendency = "Tendency: %s"
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "Drying paused.",
	dry_time = "Remaining time: %s",

	-- edible.lua
	food_unit = "<color=%s>%s</color> unit(s) of <color=%s>%s</color>", 
	edible_interface = "<color=HUNGER>Hunger</color>: <color=HUNGER>%s</color> / <color=SANITY>Sanity</color>: <color=SANITY>%s</color> / <color=HEALTH>Health</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>Health</color>: <color=HEALTH>%s</color> / <color=HUNGER>Hunger</color>: <color=HUNGER>%s</color> / <color=SANITY>Sanity</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "meat",
		monster = "monster",
		fish = "fish",
		veggie = "veggie",
		fruit = "fruit",
		egg = "egg",
		sweetener = "sweetener",
		frozen = "frozen",
		fat = "fat",
		dairy = "dairy",
		decoration = "decoration",
		magic = "magic",
		precook = "precook",
		dried = "dried",
		inedible = "inedible",
		bug = "bug",
		seed = "seed",
	},
	edible_foodeffect = {
		temperature = "Temperature: %s, %s",
		caffeine = "Speed: %s, %s",
		surf = "Ship Speed: %s, %s",
		autodry = "Drying Bonus: %s, %s",
		instant_temperature = "Temperature: %s, (Instant)",
		antihistamine = "Hayfever Delay: %ss",
	},
	foodmemory = "Recently eaten: %s / %s, will forget in: %s",
	wereeater = "<color=MONSTER>Monster meat</color> eaten: %s / %s, will forget in: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>Speed</color>: %s%%",
	hunger_slow = "<color=HUNGER>Hunger slow</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>Hunger drain</color>: <color=HUNGER>%s%%</color>",
	insulated = "Protects you from lightning.",

	-- example.lua
	why = "[why am i empty]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>Explosion Damage</color>: %s",
	explosive_range = "<color=LIGHT>Explosion Range</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "Will grow into a <color=NATURE>%s</color>.",
		nutrient_consumption = "ΔNutrients: [<color=NATURE>%d<sub>Formula</sub></color>, <color=CAMO>%d<sub>Compost</sub></color>, <color=INEDIBLE>%d<sub>Manure</sub></color>]",
		good_seasons = "Seasons: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "Stress Points: %s",
		display = "Stressors: %s",
		stress_tier = "Stress level: %s",
		tiers = (IsDST() and {
			[FARM_PLANT_STRESS.NONE] = "None",
			[FARM_PLANT_STRESS.LOW] = "Low",
			[FARM_PLANT_STRESS.MODERATE] = "Moderate",
			[FARM_PLANT_STRESS.HIGH] = "High",
		} or {}),
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color>*",
		soil_plant = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s/min<sub>plant</sub></color>)*",
		soil_plant_tile = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color>])<color=WET>/min</color>*",
		soil_plant_tile_net = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color> + <color=SHALLOWS>%s<sub>world</sub></color> = <color=#DED15E>%+.1f<sub>net</sub></color>])<color=WET>/min</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>*",
		soil_plant = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplant</sub>)*",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=#bee391>%+d<sub>F</sub></color>, <color=#7a9c6e>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		soil_plant_tile = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>   ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplant</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δtile</sub>)",
		--soil_plant_tile_net = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] + [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] = [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "Shortens <color=NATURE>growth time</color> by <color=NATURE>%s</color> seconds.",
		nutrient_value = "Nutrients: [<color=NATURE>%s<sub>Formula</sub></color>, <color=CAMO>%s<sub>Compost</sub></color>, <color=INEDIBLE>%s<sub>Manure</sub></color>]",
		wormwood = {
			formula_growth = "Accelerates your <color=LIGHT_PINK>blooming</color> by <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>Heals</color> you for <color=HEALTH>%+d</color> over <color=HEALTH>%s</color> second(s).",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "Can be filled with ocean water.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	actions = {
		uses_plain = "Uses",
		sleepin = "Sleep",
		fan = "Fan",
		play = "Play", -- beefalo horn
		hammer = "Hammer",
		chop = "Chop",
		mine = "Mine",
		net = "Catch",
		hack = "Hack", -- sw
		terraform = "Terraform",
		dig = "Dig",
		brush = "Brush",
		gas = "Gas", -- hamlet
		disarm = "Disarm", -- hamlet
		pan = "Pan", -- hamlet
		dislodge = "Chisel", -- hamlet
		spy = "Investigate", -- hamlet
		throw = "Throw", -- sw -- Action string is "Throw At"
		unsaddle = "Unsaddle",
		shear = "Shear",
		attack = "Attack",
		fish = "Fish",
		row = "Row",
		row_fail = "Failed row",
		till = "Till",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>Fish</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": +1 fish in: %s",
	fish_wait_time = "Will take <color=SHALLOWS>%s seconds</color> to catch a fish.",

	-- fishingrod.lua
	fishingrod_waittimes = "Wait time: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Max wrangle time: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "Leader: %s",
	loyalty_duration = "Loyalty duration: %s",
	ghostlybond = "Sisterly bond: %s / %s. +1 in %s.",
	ghostlybond_self = "Your sisterly bond: %s / %s. +1 in %s.",

	-- forcecompostable.lua
	forcecompostable = "Compost value: %s",

	-- friendlevels.lua
	friendlevel = "Friendliness level: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> second(s) of fuel.",
		fuel_verbose = "<color=LIGHT>%s</color> second(s) of <color=LIGHT>%s</color>.",
		type = "Fueltype: %s",
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>Fuel</color> remaining (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color> remaining (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>Fuel efficiency</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>Fuel</color>: <color=LIGHT>%s</color>",
	},

	-- growable.lua
	growth_stage = "Stage '%s': %s / %s: ",
	growth_paused = "Growth paused.",
	growth_next_stage = "Next stage in %s.",

	-- grower.lua
	harvests = "<color=NATURE>Harvests</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 in %s.",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "Discomfort: %s / %s",
		progress = "Hatching progress: %s / %s",
	},

	-- healer.lua
	heal = "<color=HEALTH>Health</color>: <color=HEALTH>%+d</color>",

	-- health.lua
	health = "<color=HEALTH>Health</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
	absorption = " : Absorbing %s%% of damage.",
	naughtiness = "Naughtiness: %s",
	player_naughtiness = "Your naughtiness: %s / %s",

	-- herdmember.lua
	herd_size = "Herd size: %s / %s",

	-- hunger.lua
	hunger = "<color=HUNGER>Hunger</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>Hunger decay</color>: <color=HUNGER>%+d/day</color> (<color=HUNGER>%s/s</color>)",
	hunger_paused = "<color=HUNGER>Hunger</color> decay paused.",

	-- hunter.lua
	hunter = {
		hunt_progress = "Track: %s / %s",
		impending_ambush = "There is an ambush waiting on the next track.",
		alternate_beast_chance = "<color=#b51212>%s%% chance</color> for a <color=MOB_SPAWN>Varg</color> or <color=MOB_SPAWN>Ewecus</color>.",
	},

	-- inspectable.lua
	catcoonden = {
		lives = "Cat lives: %s / %s",
		regenerate = "Cats regenerate in: %s",
		waiting_for_sleep = "Waiting for nearby players to go away.",
	},
	wx78_charge = "Remaining charge: %s",
	stagehand = {
		hits_remaining = "<color=#aaaaee>Hits</color> remaining: <color=#aaaaee>%s</color>",
		time_to_reset = "Will reset in %s." 
	},
	canary = {
		gas_level = "<color=#DBC033>Gas level</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "Chance of becoming <color=#522E61>poisoned</color>: <color=#D8B400>%d%%</color>",
		gas_level_increase = "Increases in %s.",
		gas_level_decrease = "Decreases in %s."
	},
	fossil_stalker = {
		pieces_needed = "20%% chance of going wrong with %s more piece(s).",
		correct = "This is correctly assembled.",
		incorrect = "This is assembled wrong.",
	},
	trap_starfish_cooldown = "Rearms in: %s",
	lureplant_active = "Will become active in: %s",
	walrus_camp_respawn = "<color=FROZEN>%s</color> respawns in: %s",
	global_wetness = "<color=FROZEN>Global Wetness</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>Precipitation Rate</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>Frog rain chance</color>: <color=FROG>%s%%</color>",
	world_temperature = "<color=LIGHT>World Temperature</color>: <color=LIGHT>%s</color>",
	unlocks = "Unlocks: %s",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>Insulation (Winter)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>Insulation (Summer)</color>: <color=FROZEN>%s</color>",

	-- klaussackloot.lua
	klaussackloot = "Notable loot:",

	-- klaussackspawner.lua
	klaussack_spawnsin = "%s",
	klaussack_despawn = "Despawns on day: %s",

	-- leader.lua
	followers = "Followers: %s",

	-- madsciencelab.lua
	madsciencelab_finish = "Will finish in: %s",

	-- malbatrossspawner.lua
	malbatross_spawnsin = "%s",
	malbatross_waiting = "Waiting for someone to go to a shoal.",

	-- mast.lua
	mast_sail_force = "Sail force: %s",
	mast_max_velocity = "Max velocity: %s",

	-- mermcandidate.lua
	mermcandidate = "Calories: %s / %s",

	-- moisture.lua
	moisture = "<color=WET>Wetness</color>: <color=WET>%s%%</color>", --moisture = "<color=WET>Wetness</color>: %s / %s (%s%%)",

	-- nightmareclock.lua
	nightmareclock = "<color=%s>Phase: %s</color>, %s",
	nightmareclock_lock = "Locked by the <color=#CE3D45>Ancient Key</color>.",

	-- oar.lua
	oar_force = "<color=INEDIBLE>Force</color>: <color=INEDIBLE>%s%%</color>",

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "Rots",
		stale = "Stale",
		spoil = "Spoils",
		dies = "Dies",
		starves = "Starves",
		transition = "<color=MONSTER>%s</color> in: %s",
		transition_extended = "<color=MONSTER>%s</color> in: %s (<color=MONSTER>%s%%</color>)",
		paused = "Currently not decaying.",
	},

	-- petrifiable.lua
	petrify = "Will become petrified in %s.",

	-- pickable.lua
	regrowth = "<color=NATURE>Regrows</color> in: <color=NATURE>%s</color>",
	regrowth_paused = "Regrowth paused.",
	pickable_cycles = "<color=DECORATION>Remaining harvests</color>: <color=DECORATION>%s</color> / <color=DECORATION>%s</color>",

	-- pollinator.lua
	pollination = "Flowers pollinated: (%s) / %s",

	-- preservative.lua
	preservative = "Restores %s%% of freshness.",

	-- quaker.lua
	next_quake = "<color=INEDIBLE>Earthquake</color> in %s",

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Toys remaining: %s",
			assisted_by = "This pipspook is being assisted by %s.",
		},
	},

	-- repairer.lua
	repairer = {
		type = "Repair material: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>Health restore</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>flat HP</sub></color> + <color=HEALTH>%s%%<sub>percent HP</sub></color>",
		work = "<color=#DED15E>Work repair</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>work</sub></color>",
		perish = "<color=MONSTER>Freshen</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>Freshen</color>: <color=MONSTER>%s%%</color>",
		materials = (IsDST() and {
			[MATERIALS.WOOD] =  "Wood",
			[MATERIALS.STONE] =  "Stone",
			[MATERIALS.HAY] =  "Hay",
			[MATERIALS.THULECITE] =  "Thulecite",
			[MATERIALS.GEM] =  "Gem",
			[MATERIALS.GEARS] =  "Gears",
			[MATERIALS.MOONROCK] =  "Moonrock",
			[MATERIALS.ICE] =  "Ice",
			[MATERIALS.SCULPTURE] =  "Sculpture",
			[MATERIALS.FOSSIL] =  "Fossil",
			[MATERIALS.MOON_ALTAR] =  "Moon Altar",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "<color=#99635D>Gears</color> needed: <color=#99635D>%s</color>",
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "Unable to spawn."
	},

	-- sanity.lua
	sanity = "<color=SANITY>Sanity</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<color=ENLIGHTENMENT>Enlightenment</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

	-- sanityaura.lua
	sanityaura = "<color=SANITY>Sanity Aura</color>: <color=SANITY>%s/min</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "This has been opened already.",
		chest_labyrinth = {
			sanity = "66% chance to change <color=SANITY>sanity</color> by <color=SANITY>-20</color> to <color=SANITY>20</color>.",
			hunger = "66% chance to change <color=HUNGER>hunger</color> by <color=HUNGER>-20</color> to <color=HUNGER>20</color>.",
			health = "66% chance to change <color=HEALTH>health</color> by <color=HEALTH>0</color> to <color=HEALTH>20</color>.",
			inventory = "66% chance to change <color=LIGHT>durability</color> or <color=MONSTER>freshness</color> by 20%.",
			summonmonsters = "66% chance to summon 1-3 <color=MOB_SPAWN>Depth Dwellers</color>.",
		},
	},

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- skinner_beefalo.lua
	skinner_beefalo = "Fearsome: %s, Festive: %s, Formal: %s",

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>Heals</color> for <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Heals</color> people within <color=#DED15E>%s tiles</color>.",

	-- spawner.lua
	spawner_next = "Will spawn a <color=MOB_SPAWN>%s</color> in %s.",
	spawner_child = "Spawns a <color=#ff9999>%s</color>",

	-- stewer.lua
	stewer_product = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>)",
	cooktime_remaining = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>) will be done in %s second(s).",
	cooker = "Cooked by <color=%s>%s</color>.",
	cooktime_modifier_slower = "Cooks food <color=#DED15E>%s%%</color> slower.",
	cooktime_modifier_faster = "Cooks food <color=NATURE>%s%%</color> faster.",

	-- stickable.lua
	stickable = "<color=FISH>Mussels</color>: %s",

	-- temperature.lua
	temperature = "Temperature: %s",

	-- tigersharker.lua
	tigershark_spawnin = "Can spawn in: %s",
	tigershark_waiting = "Ready to spawn.",
	tigershark_exists = "Tiger shark is present.",

	-- timer.lua
	timer_paused = "Paused",
	timer = "Timer '%s': %s",

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>Efficiency</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "Worth %s gold nugget(s).",
	tradable_gold_dubloons = "Worth %s gold nugget(s) and %s dubloon(s).",
	tradable_rocktribute = "Delays <color=LIGHT>Antlion</color> rage by %s day(s).",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "Stage %s / %s: ",
	upgradeable_complete = "Upgrade %s%% complete.",
	upgradeable_incomplete = "No upgrades possible.",

	-- waterproofer.lua
	waterproofness = "<color=WET>Waterproofness</color>: <color=WET>%s%%</color>",
	
	-- watersource.lua
	watersource = "This is a source of water.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "Increases moisture by <color=WET>%s</color>."
	},

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>Damage</color>",
		electric = "<color=WET>Electric</color> <color=HEALTH>Damage</color>",
		poisonous = "<color=NATURE>(Poisonous)</color> <color=HEALTH>Damage</color>",
		thorns = "<color=HEALTH>(Thorns)</color> <color=HEALTH>Damage</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Range: %s",

	-- weighable.lua
	weighable = {
		weight = "Weight: %s (%s%%)",
		weight_bounded = "Weight: %s <= %s (%s) <= %s",
		owner_name = "Owner: %s"
	},

	-- werebeast.lua
	werebeast = "Wereness: %s / %s",

	-- wereness.lua
	wereness_remaining = "Wereness: %s / %s",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "You are <color=#bbffbb>eligible</color> for <color=#DED15E>rare gifts</color>.",
		not_ready = "You must <color=#ffbbbb>wait %s more day(s)</color> before you can get another <color=#DED15E>rare gift</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "State change is delayed for %s",
		wither = "Will wither in %s",
		rejuvenate = "Will rejuvenate in %s"
	},

	-- workable.lua
	workable = {
		chance = "<color=#636C5C>Treeguard chance</color>: %s%%<sub>You</sub> & %s%%<sub>NPC</sub>"
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "Worldmigrator disabled.",
		target_shard = "Target Shard: %s",
		received_portal = "Shard Migrator: %s",
		id = "This #: %s",
	},

	-- yotb_sewer.lua
	yotb_sewer = "Will finish sewing in: %s",
}