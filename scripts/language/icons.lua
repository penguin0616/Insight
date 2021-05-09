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
	--server_crash = "This server has crashed. Whether Insight is the cause is unknown.",

	-- modmain.lua
	--dragonfly_ready = "Ready to fight.",

	-- time.lua
	--[[time_segments = "%s segment(s)",
	time_days = "%s day(s), ",
	time_days_short = "%s day(s)",
	time_seconds = "%s second(s)",
	time_minutes = "%s minute(s), ",
	time_hours = "%s hour(s), ",--]]

	-- meh
	seasons = {
		--autumn = "Autumn",
		--winter = "Winter",
		--spring = "Spring",
		--summer = "Summer",
	},

	-------------------------------------------------------------------------------------------------------------------------

	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		--minimum_sanity = "Minimum <color=SANITY>sanity</color> for light: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		--current_sanity = "Your <color=SANITY>sanity</color> is: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		--summoned_gestalt_damage = "Summoned <color=ENLIGHTENMENT>gestalts</color> deal <color=HEALTH>%s</color> damage.",
	},

	-- appeasement.lua
	appease_good = "<icon=volcano> %s segment(s).",
	appease_bad = "<icon=volcano_active> -%s segment(s).",

	-- appraisable.lua
	--appraisable = "Fearsome: %s, Festive: %s, Formal: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "<icon=blueprint> <prefab=%s>",

	-- armor.lua
	protection = "<icon=armorwood> %s%%",
	durability = "<icon=health> %s / %s",
	durability_unwrappable = "<icon=armorwood> %s",

	-- batbat.lua [Prefab]
	batbat = {
		--health_restore = "Restores <color=HEALTH>%s health</color> per hit.",
		--sanity_cost = "Drains <color=SANITY>%s sanity</color> per hit.",
	},

	-- beard.lua
	--beard = "Beard will improve in %s day(s).",

	-- beargerspawner.lua
	--incoming_bearger_targeted = "<color=%s>Target: %s</color> -> %s",

	-- boathealth.lua
	-- use 'health' from 'health'

	-- breeder.lua
	--breeder_tropical_fish = "<color=#64B08C>Tropical Fish</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	--breeder_fish3 = "<color=#6C5186>Purple Grouper</color>",
	--breeder_fish4 = "<color=#DED15E>Pierrot Fish</color>",
	--breeder_fish5 = "<color=#9ADFDE>Neon Quattro</color>",
	--breeder_fishstring = "%s: %s / %s",
	--breeder_nextfishtime = "Additional fish in: %s",
	--breeder_possiblepredatortime = "May spawn a predator in: %s",

	-- burnable.lua
	burnable = {
		--smolder_time = "Will <color=LIGHT>ignite</color> in: <color=LIGHT>%s</color>",
		--burn_time = "Remaining <color=LIGHT>burn time</color>: <color=LIGHT>%s</color>",
	},

	-- canary.lua [Prefab]
	canary = {
		--gas_level = "<color=#DBC033>Gas level</color>: %s / %s", -- canary, max saturation canary
		--poison_chance = "Chance of becoming <color=#522E61>poisoned</color>: <color=#D8B400>%d%%</color>",
		--gas_level_increase = "Increases in %s.",
		--gas_level_decrease = "Decreases in %s."
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		--lives = "Cat lives: %s / %s",
		--regenerate = "Cats regenerate in: %s",
		--waiting_for_sleep = "Waiting for nearby players to go away.",
	},

	-- chessnavy.lua
	--chessnavy_timer = "%s",
	--chessnavy_ready = "Waiting for you to return to a crime scene.",

	-- chester_eyebone.lua [Prefab]
	--chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> %s",

	-- childspawner.lua
	childspawner = {
		--children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		--emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		--both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		--regenerating = "Regenerating %s in: %s",
		--entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	damage = "<icon=swords> <color=HEALTH>%s</color>",
	--damageToYou = " (<color=HEALTH>%s</color> to you)",

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	--cooldown = "Cooldown: %s",

	-- crabkingspawner.lua
	--crabking_spawnsin = "%s",

	-- crittertraits.lua
	--dominant_trait = "Dominant trait: %s",

	-- crop.lua
	--crop_paused = "Paused.",
	growth = "<icon=%s> <color=NATURE>%s</color>",

	-- dapperness.lua
	dapperness = "<icon=sanity> <color=SANITY>%s/min</color>",

	-- debuffable.lua
	--buff_text = "<color=MAGIC>Buff</color>: <color=MAGIC>%s</color>, %s",
	debuffs = { -- ugh
		--["buff_attack"] = "Makes attacks <color=HEALTH>%s%% stronger</color> for %s(s).",
		--["buff_playerabsorption"] = "Take <color=MEAT>%s%%</color> less damage for %s(s).",
		--["buff_workeffectiveness"] = "Your work is <color=#DED15E>%s%%</color> more effective for %s(s).",
		
		--["buff_moistureimmunity"] = "You are immune to <color=WET>wetness</color> for %s(s).",
		--["buff_electricattack"] = "Your attacks are <color=WET>electric</color> for %s(s).",
		--["buff_sleepresistance"] = "You resist <color=MONSTER>sleep</color> for %s(s).",
		
		--["tillweedsalve_buff"] = "Regenerates <color=HEALTH>%s health</color> over %s(s).",
		--["healthregenbuff"] = "Regenerates <color=HEALTH>%s health</color> over %s(s).",
		--["sweettea_buff"] = "Regenerates <color=SANITY>%s sanity</color> over %s(s).",
	},

	-- deerclopsspawner.lua
	--incoming_deerclops_targeted = "<color=%s>Target: %s</color> -> %s",

	-- diseaseable.lua
	--disease_in = "Will become diseased in: %s",
	--disease_spread = "Will spread disease in: %s",
	--disease_delay = "Disease is delayed for: %s",

	-- domesticatable.lua
	domesticatable = {
		--domestication = "Domestication: %s%%",
		--obedience = "Obedience: %s%%",
		--obedience_extended = "Obedience: %s%% (Saddle: >=%s%%, Keep Saddle: >%s%%, Lose Domestication: <=%s%%)",
		--tendency = "Tendency: %s",
		tendencies = {
			--["NONE"] = "None",
			--[TENDENCY.DEFAULT] = "Default",
			--[TENDENCY.ORNERY] = "Ornery",
			--[TENDENCY.RIDER] = "Rider",
			--[TENDENCY.PUDGY] = "Pudgy"
		},
	},

	-- drivable.lua

	-- dryer.lua
	--dryer_paused = "Drying paused.",
	dry_time = "<icon=%s> %s",

	-- edible.lua
	food_unit = "<color=%s>%s</color><icon=%s>", 
	edible_interface = "<icon=hunger> <color=HUNGER>%s</color> / <icon=sanity> <color=SANITY>%s</color> / <icon=health> <color=HEALTH>%s</color>",
	edible_wiki = "<icon=health> <color=HEALTH>%s</color> / <icon=hunger> <color=HUNGER>%s</color> / <icon=sanity> <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "meats",
		monster = "monster_foods",
		fish = "fishes",
		veggie = "vegetable",
		fruit = "fruit",
		egg = "eggs",
		sweetener = "sweetener",
		frozen = "ice",
		fat = "fat",
		dairy = "dairy",
		decoration = "butterflywings",
		magic = "nightmarefuel",
		precook = "coldfire",
		dried = "meatrack",
		inedible = "inedible",
		bug = "bugs",
		seed = "acorn_cooked"
	},
	edible_foodeffect = {
		temperature = "<icon=pocket_scale> <icon=winterometer> %s, %s",
		caffeine = "<icon=cane> %s, %s",
		surf = "<icon=surfboard_item> %s, %s",
		--autodry = "<icon=meatrack> %s, %s",
		instant_temperature = "<icon=winterometer> %s",
		antihistamine = "<icon=cutnettle> %ss",
	},
	--foodmemory = "Recently eaten: %s / %s, will forget in: %s",
	--wereeater = "<color=MONSTER>Monster meat</color> eaten: %s / %s, will forget in: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<icon=cane> %s%%",
	hunger_slow = "<icon=hunger> <color=HUNGER>-%s%%</color>",
	hunger_drain = "<icon=hunger> <color=HUNGER>%s%%</color>",
	--insulated = "Protects you from lightning.",

	-- example.lua
	--why = "[why am i empty]",

	-- explosive.lua
	--explosive_damage = "<color=LIGHT>Explosion Damage</color>: %s",
	--explosive_range = "<color=LIGHT>Explosion Range</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "<icon=%s>",
		--nutrient_consumption = "Plant consumes: [<color=NATURE>%d<sub>Formula</sub></color>, <color=CAMO>%d<sub>Compost</sub></color>, <color=INEDIBLE>%d<sub>Manure</sub></color>]",
		good_seasons = "Seasons: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		--stress_points = "Stress Points: %s",
		--display = "Stressors: %s",
		--stress_tier = "Stress level: %s",
		tiers = (IsDST() and {
			--[FARM_PLANT_STRESS.NONE] = ":)",
			--[FARM_PLANT_STRESS.LOW] = ":|",
			--[FARM_PLANT_STRESS.MODERATE] = ":(",
			--[FARM_PLANT_STRESS.HIGH] = ">:(",
		} or {}),
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		--soil_only = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color>",
		--soil_plant = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s/min<sub>plant</sub></color>)",
		--soil_plant_tile = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color>])<color=WET>/min</color>",
		--soil_plant_tile_net = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color> + <color=SHALLOWS>%s<sub>world</sub></color> = <color=#DED15E>%+.1f<sub>net</sub></color>])<color=WET>/min</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]",
		soil_plant = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=#bee391>%+d<sub>F</sub></color>, <color=#7a9c6e>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		soil_plant_tile = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>   (Δ[<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplant</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δtile</sub>)",
		--soil_plant_tile_net = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] + [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] = [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "<icon=poop> %ss",
		--nutrient_value = "Nutrients: [<color=NATURE>%s</color>, <color=CAMO>%s</color>, <color=INEDIBLE>%s</color>]",
		wormwood = {
			--formula_growth = "Accelerates your <color=LIGHT_PINK>blooming</color> by <color=LIGHT_PINK>%s</color>.",
			--compost_heal = "<color=HEALTH>Heals</color> you for <color=HEALTH>%+d</color> over <color=HEALTH>%s</color> second(s).",
		},
	},

	-- fillable.lua
	fillable = {
		--accepts_ocean_water = "Can be filled with ocean water.",
	},

	-- finiteuses.lua
	action_uses = "<icon=%s> %s",
	action_uses_verbose = "<icon=%s> %s / %s",
	actions = {
		--uses_plain = "Uses",
		sleepin = "bedroll_straw",
		fan = "featherfan",
		play = "horn", -- beefalo horn
		hammer = "hammer",
		chop = "axe",
		mine = "pickaxe",
		net = "bugnet",
		hack = "machete", -- sw
		terraform = "pitchfork",
		dig = "shovel",
		brush = "brush",
		gas = "bugrepellant", -- hamlet
		disarm = "disarmingkit", -- hamlet
		pan = "goldpan", -- hamlet
		dislodge = "littlehammer", -- hamlet
		spy = "magnifying_glass", -- hamlet
		throw = "monkeyball", -- sw
		unsaddle = "saddlehorn",
		shear = "shears",
		attack = "spear",
		fish = "fishingrod",
		row = "oar",
		--row_fail = "oar",
		till = "farm_hoe",
	},

	-- fishable.lua
	fish_count = "<icon=fish> %s / %s",
	--fish_recharge = ": <color=WET>+1</color> fish in: %s",
	--fish_wait_time = "Will take <color=SHALLOWS>%s seconds</color> to catch a fish.",

	-- fishingrod.lua
	fishingrod_waittimes = "<icon=pocket_scale> <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	--fishingrod_loserodtime = "Max wrangle time: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "<icon=pigcrownhat> %s",
	loyalty_duration = "<icon=pigcrownhat><icon=pocket_scale> %s",
	ghostlybond = "<icon=abigail_flower_level3> %s / %s. +1 in %s.",
	ghostlybond_self = "<icon=abigail_flower_level3>Your sisterly bond: %s / %s. +1 in %s.",

	-- forcecompostable.lua
	--forcecompostable = "Compost value: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		--pieces_needed = "20%% chance of going wrong with %s more piece(s).",
		--correct = "This is correctly assembled.",
		--incorrect = "This is assembled wrong.",
		--gateway_too_far = "This skeleton is %s tile(s) too far.",
	},

	-- friendlevels.lua
	--friendlevel = "Friendliness level: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<icon=fire> %ss",
		fuel_verbose = "<icon=fire> %ss (<color=LIGHT>%s</color>)",
		--type = "Fueltype: %s",
	},

	-- fueled.lua
	fueled = {
		time = "<icon=fire> %s%%: %s",
		time_verbose = "<icon=fire> (<color=LIGHT>'%s'</color>) %s%%: %s", -- type, percent, time
		--efficiency = "<color=LIGHT>Fuel efficiency</color>: <color=LIGHT>%s%%</color>", -- no good way i can think of for this
		units = "<icon=fire> %s",
	},

	-- growable.lua
	--growth_stage = "Stage '%s': %s / %s: ",
	--growth_paused = "Growth paused.",
	growth_next_stage = "<icon=arrow> %s.",

	-- grower.lua
	harvests = "<icon=fast_farmplot> <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "<icon=%s> %s / %s",
		grow = "+1 %s.",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "<icon=magic> %s / %s",
		progress = "<icon=fire> %s / %s",
	},

	-- healer.lua
	heal = "<icon=health> %+d",

	-- health.lua
	health = "<icon=health> <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	--health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
	absorption = " : <icon=armorsnurtleshell> %s%%",
	naughtiness = "<icon=krampus> %s",
	--player_naughtiness = "Your naughtiness: %s / %s", -- "Random" from character select?

	-- herdmember.lua
	--herd_size = "Herd size: %s / %s",

	-- hunger.lua
	hunger = "<icon=hunger> <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	--hunger_burn = "<color=HUNGER>Hunger</color> decay: <color=HUNGER>%+d/day</color> (<color=HUNGER>%+d/s</color>)",
	--hunger_paused = "<color=HUNGER>Hunger</color> decay paused.",

	-- hunter.lua
	hunter = {
		hunt_progress = "<icon=dirtpile> %s / %s",
		--impending_ambush = "There is an ambush waiting on the next track.",
		--alternate_beast_chance = "<color=#b51212>%s%% chance</color> for a <color=MOB_SPAWN>Varg</color> or <color=MOB_SPAWN>Ewecus</color>.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> will respawn in: %s",

	-- inspectable.lua
	--wagstaff_tool = "The name of this tool is: <color=ENLIGHTENMENT><prefab=%s></color>",
	
	-- insulator.lua
	insulation_winter = "<icon=beargervest> <color=FROZEN>%s</color>",
	insulation_summer = "<icon=icehat> <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		hat_describe = "[Hat]: ",
	},

	-- klaussackloot.lua
	klaussackloot = "Notable loot:",

	-- klaussackspawner.lua
	--klaussack_spawnsin = "%s",
	--klaussack_despawn = "Despawns on day: %s",

	-- leader.lua
	--followers = "Followers: %s",

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "Will become active in: %s",
	},

	-- madsciencelab.lua
	--madsciencelab_finish = "Will finish in: %s",

	-- malbatrossspawner.lua
	--malbatross_spawnsin = "%s",
	--malbatross_waiting = "Waiting for someone to go to a shoal.",

	-- mast.lua
	--mast_sail_force = "Sail force: %s",
	--mast_max_velocity = "Max velocity: %s",

	-- mermcandidate.lua
	--mermcandidate = "Calories: %s / %s",

	-- mine.lua
	mine = {
		--active = "Checks for triggers every %s second(s).",
		--inactive = "Not checking for triggers.",
		--beemine_bees = "Will release %s bee(s).",
		--trap_starfish_cooldown = "Rearms in: %s",
	},

	-- moisture.lua
	moisture = "<icon=wetness> %s%%",

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			--progress = "Progress to destination: %s / %s",
			--time_for_next_tool = "Will need another tool in %s.",
			--experiment_time = "Experiment will complete in %s.",
		},
		--storm_move = "%s%% chance to move moonstorms on day %s.",
	},

	-- nightmareclock.lua
	--nightmareclock = "<color=%s>Phase: %s</color>, %s",
	--nightmareclock_lock = "Locked by the <color=#CE3D45>Ancient Key</color>.",

	-- oar.lua
	--oar_force = "<color=INEDIBLE>Force</color>: <color=INEDIBLE>%s%%</color>",

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		--rot = "Rots",
		--stale = "Stale",
		--spoil = "Spoils",
		--dies = "Dies",
		--starves = "Starves",
		--transition = "<color=MONSTER>%s</color> in: %s",
		--transition_extended = "<color=MONSTER>%s</color> in: %s (<color=MONSTER>%s%%</color>)",
		--paused = "Currently not decaying.",
	},

	-- petrifiable.lua
	--petrify = "Will become petrified in %s.",

	-- pickable.lua
	regrowth = "<icon=%s> <color=NATURE>%s</color>",
	--regrowth_paused = "Regrowth paused.",
	--pickable_cycles = "Remaining harvests: %s / %s",

	-- pollinator.lua
	--pollination = "Flowers pollinated: (%s) / %s",

	-- preservative.lua
	--preservative = "Restores %s%% of freshness.",

	-- quaker.lua
	--next_quake = "<color=INEDIBLE>Earthquake</color> in %s",

	-- questowner.lua
	questowner = {
		pipspook = {
			--toys_remaining = "Toys remaining: %s",
			--assisted_by = "This pipspook is being assisted by %s.",
		},
	},

	-- rainometer.lua [Prefab]
	--global_wetness = "<color=WET>Global Wetness</color>: <color=WET>%s</color>",
	--precipitation_rate = "<color=WET>Precipitation Rate</color>: <color=WET>%s</color>",
	frog_rain_chance = "<icon=frog> <color=FROG>%s%%</color>", -- icon is screwed up with white bg

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
		--cant_spawn = "Unable to spawn."
	},

	-- saddler.lua
	saddler = {
		--bonus_damage = "<color=HEALTH>Bonus damage</color>: <color=HEALTH>%s</color>",
		--bonus_speed = "<color=DAIRY>Bonus speed</color>: %s%%",
	},

	-- sanity.lua
	sanity = "<icon=sanity> <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<icon=enlightenment> <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

	-- sanityaura.lua
	sanityaura = "<icon=sanity> <color=SANITY>%s/min</color>",

	-- scenariorunner.lua
	scenariorunner = {
		--opened_already = "This has been opened already.",
		chest_labyrinth = {
			--sanity = "66% chance to change <color=SANITY>sanity</color> by <color=SANITY>-20</color> to <color=SANITY>20</color>.",
			--hunger = "66% chance to change <color=HUNGER>hunger</color> by <color=HUNGER>-20</color> to <color=HUNGER>20</color>.",
			--health = "66% chance to change <color=HEALTH>health</color> by <color=HEALTH>0</color> to <color=HEALTH>20</color>.",
			--inventory = "66% chance to change <color=LIGHT>durability</color> or <color=MONSTER>freshness</color> by 20%.",
			--summonmonsters = "66% chance to summon 1-3 <color=MOB_SPAWN>Depth Dwellers</color>.",
		},
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			--spawned_for = "Spawned by %s.",
			--sanity_reward = "<color=SANITY>Sanity</color> reward: <color=SANITY>%s</color>",
			--sanity_reward_split = "<color=SANITY>Sanity</color> reward: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>Weapons</color> last <color=#aaaaee>%s%%</color> longer.",
			battlesong_healthgain = "Hitting enemies restores <color=HEALTH>%s health</color> (<color=HEALTH>%s</color> for Wigfrids).",
			battlesong_sanitygain = "Hitting enemies restores <color=SANITY>%s sanity</color>.",
			battlesong_sanityaura = "Negative <color=SANITY>sanity auras</color> are <color=SANITY>%s%%</color> less effective.",
			battlesong_fireresistance = "Take <color=HEALTH>%s%% less damage</color> from <color=LIGHT>fire</color>.",
			battlesong_instant_taunt = "Taunts all nearby enemies within song radius.",
			battlesong_instant_panic = "Panics nearby hauntable enemies for %s second(s).",
		},
		cost = "Costs %s inspiration to use.",
	},

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- skinner_beefalo.lua
	skinner_beefalo = "Fearsome: %s, Festive: %s, Formal: %s",

	-- soul.lua
	wortox_soul_heal = "<icon=health> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Heals</color> people within <color=#DED15E>%s tiles</color>.",

	-- spawner.lua
	spawner = {
		--next = "Will spawn a <color=MOB_SPAWN><prefab=%s></color> in %s.",
		--child = "Spawns a <color=#ff9999><prefab=%s></color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>Hits</color> remaining: <color=#aaaaee>%s</color>",
		time_to_reset = "Will reset in %s." 
	},

	-- stewer.lua
	stewer = {
		product = "<icon=%s>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<icon=%s>(<color=HUNGER>%s</color>) %s",
		--cooker = "Cooked by <color=%s>%s</color>.",
		--cooktime_modifier_slower = "Cooks food <color=#DED15E>%s%%</color> slower.", -- some sort of double side-chevron (like a slow down sign) <<
		--cooktime_modifier_faster = Cooks food <color=NATURE>%s%%</color> faster.",-- some sort of double side-chevron (like a speed up sign) >>
	},

	-- stickable.lua
	stickable = "<icon=n> %s",

	-- temperature.lua
	temperature = "<icon=winterometer> %s",

	-- tigersharker.lua
	--tigershark_spawnin = "Can spawn in: %s",
	--tigershark_waiting = "Ready to spawn.",
	--tigershark_exists = "Tiger shark is present.",

	-- timer.lua
	timer = {
		label = "Timer '%s': %s",
		paused = "Paused",
	},

	-- tool.lua
	--action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	--tool_efficiency = "<color=NATURE>Efficiency</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "<icon=goldnugget> %s",
	tradable_gold_dubloons = "<icon=goldnugget> %s  <icon=dubloon> %s",
	tradable_rocktribute = "<icon=antlion> %s.",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	--upgradeable_stage = "Stage %s / %s: ",
	--upgradeable_complete = "Upgrade %s%% complete.",
	--upgradeable_incomplete = "No upgrades possible.",

	-- walrus_camp.lua [Prefab]
	--walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> respawns in: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<icon=wetness> <color=WET>%s%%</color>",

	-- watersource.lua
	watersource = "This is a source of water.",

	-- wateryprotection.lua
	wateryprotection = {
		--wetness = "Increases moisture by <color=WET>%s</color>."
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
		--weight = "Weight: %s (%s%%)",
		--weight_bounded = "Weight: %s <= %s (%s) <= %s",
		--owner_name = "Owner: %s"
	},

	-- werebeast.lua
	--werebeast = "Wereness: %s / %s",

	-- wereness.lua
	wereness_remaining = "Wereness: %s / %s",

	-- winch.lua
	winch = {
		--not_winch = "This has a winch component, but fails prefab check.",
		--sunken_item = "There is a <color=#66ee66>%s</color> underneath this winch.",
	},

	-- winterometer.lua [Prefab]
	--world_temperature = "<color=LIGHT>World Temperature</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		--ready = "You are <color=#bbffbb>eligible</color> for <color=#DED15E>rare gifts</color>.",
		--not_ready = "You must <color=#ffbbbb>wait %s more day(s)</color> before you can get another <color=#DED15E>rare gift</color>.",
	},

	-- witherable.lua
	witherable = {
		--delay = "State change is delayed for %s",
		--wither = "Will wither in %s",
		--rejuvenate = "Will rejuvenate in %s"
	},

	-- workable.lua
	workable = {
		--treeguard_chance = "<color=#636C5C>Treeguard chance</color>: %s%%<sub>You</sub> & %s%%<sub>NPC</sub>"
	},

	-- worldmigrator.lua
	worldmigrator = {
		--disabled = "Worldmigrator disabled.",
		--target_shard = "Target Shard: %s",
		--received_portal = "Shard Migrator: %s",
		--id = "This #: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "WSTimer '%s': %s",
		paused = "Paused",
	},

	-- wx78.lua [Prefab]
	--wx78_charge = "Remaining charge: %s",

	-- yotb_sewer.lua
	--yotb_sewer = "Will finish sewing in: %s",
}