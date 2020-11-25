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

	-------------------------------------------------------------------------------------------------------------------------

	-- appeasement.lua
	appease_good = "<icon=volcano> %s segment(s).",
	appease_bad = "<icon=volcano_active> -%s segment(s).",

	-- armor.lua
	protection = "<icon=armorwood> %s%%",
	durability = "<icon=health> %s / %s",

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

	-- chessnavy.lua
	--chessnavy_timer = "%s",
	--chessnavy_ready = "Waiting for you to return to a crime scene.",

	-- combat.lua
	damage = "<icon=swords> <color=HEALTH>%s</color>",
	--damageToYou = " (<color=HEALTH>%s</color> to you)",

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

	-- deerclopsspawner.lua
	--incoming_deerclops_targeted = "<color=%s>Target: %s</color> -> %s",

	-- diseaseable.lua
	--disease_in = "Will become diseased in: %s",
	--disease_spread = "Will spread disease in: %s",
	--disease_delay = "Disease is delayed for: %s",

	-- domesticable.lua
	--domestication = "Domestication: %s%%",
	--obedience = "Obedience: %s%%",

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

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<icon=cane> %s%%",
	hunger_slow = "<icon=hunger> <color=HUNGER>-%s%%</color>",

	-- example.lua
	--why = "[why am i empty]",

	-- explosive.lua
	--explosive_damage = "<color=LIGHT>Explosion Damage</color>: %s",
	--explosive_range = "<color=LIGHT>Explosion Range</color>: %s",

	-- fertilizer.lua
	growth_value = "<icon=poop> %ss",

	-- finiteuses.lua
	action_uses = "<icon=%s> %s",
	--[[action_sleepin = "Sleep",
	action_fan = "Fan",
	action_play = "Play", -- beefalo horn
	action_hammer = "Hammer",
	action_chop = "Chop",
	action_mine = "Mine",
	action_net = "Catch",
	action_hack = "Hack", -- sw
	action_terraform = "Terraform",
	action_dig = "Dig",
	action_brush = "Brush",
	action_gas = "Gas", -- hamlet
	action_disarm = "Disarm", -- hamlet
	action_pan = "Pan", -- hamlet
	action_dislodge = "Dislodge", -- hamlet
	action_spy = "Spy", -- hamlet
	action_throw = "Throw", -- sw
	action_unsaddle = "Unsaddle",
	action_shear = "Shear",
	action_attack = "Attack",
	action_fish = "Fish",
	action_row = "Row",
	action_row_fail = "Failed row",--]]

	-- fishable.lua
	fish_count = "<icon=fish> %s / %s",
	--fish_recharge = ": <color=WET>+1</color> fish in: %s",

	-- fishingrod.lua
	fishingrod_waittimes = "<icon=pocket_scale> <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "<icon=pigcrownhat> %s",
	loyalty_duration = "<icon=pigcrownhat><icon=pocket_scale> %s",
	ghostlybond = "<icon=abigail_flower_level3> %s / %s. +1 in %s.",
	ghostlybond_self = "<icon=abigail_flower_level3>Your sisterly bond: %s / %s. +1 in %s.",

	-- friendlevels.lua
	--friendlevel = "Friendliness level: %s / %s",

	-- fuel.lua
	fuel = "<icon=fire> %ss",
	fuel_verbose = "<icon=fire> %ss (<color=LIGHT>'%s'</color>)",

	-- fueled.lua
	fueled_time = "<icon=fire> %s%%: %s",
	fueled_time_verbose = "<icon=fire> (<color=LIGHT>'%s'</color>) %s%%: %s", -- type, percent, time
	--fuel_efficiency = "<color=#FF9300><icon=fire> %s%%</color>", -- no good way i can think of for this

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

	-- inspectable.lua
	fossil_stalker = {
		--pieces_needed = "20% chance of going wrong with %s more piece(s).",
		--correct = "This is correctly assembled.",
		--incorrect = "This is assembled wrong.",
	},
	--trap_starfish_cooldown = "Rearms in: %s",
	--lureplant_active = "Will become active in: %s",
	--walrus_camp_respawn = "<color=FROZEN>%s</color> respawns in: %s",
	hunt_progress = "<icon=dirtpile> %s / %s",
	--global_wetness = "<color=WET>Global Wetness</color>: <color=WET>%s</color>",
	--precipitation_rate = "<color=WET>Precipitation Rate</color>: <color=WET>%s</color>",
	frog_rain_chance = "<icon=frog> <color=FROG>%s%%</color>", -- icon is screwed up with white bg
	--world_temperature = "<color=LIGHT>World Temperature</color>: <color=LIGHT>%s</color>",
	unlocks = "<icon=blueprint> %s",

	-- insulator.lua
	insulation_winter = "<icon=beargervest> <color=FROZEN>%s</color>",
	insulation_summer = "<icon=icehat> <color=FROZEN>%s</color>",

	-- klaussackspawner.lua
	--klaussack_spawnsin = "%s",
	--klaussack_despawn = "Despawns on day: %s",

	-- leader.lua
	--followers = "Followers: %s",

	-- malbatrossspawner.lua
	--malbatross_spawnsin = "%s",
	--malbatross_waiting = "Waiting for someone to go to a shoal.",

	-- mast.lua
	--mast_sail_force = "Sail force: %s",
	--mast_max_velocity = "Max velocity: %s",

	-- mermcandidate.lua
	--mermcandidate = "Calories: %s / %s",

	-- moisture.lua
	moisture = "<icon=wetness> %s%%",

	-- nightmareclock.lua
	--nightmareclock = "<color=%s>Phase: %s</color>, %s",
	--nightmareclock_lock = "Locked by the <color=#CE3D45>Ancient Key</color>.",

	-- oar.lua
	--oar_force = "<color=INEDIBLE>Force</color>: <color=INEDIBLE>%s%%</color>",

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	--rot = "Rots",
	--stale = "Stale",
	--spoil = "Spoils",
	--dies = "Dies",
	--perishable_transition = "<color=MONSTER>%s</color> in: %s",
	--perishable_paused = "Currently not decaying.",

	-- petrifiable.lua
	--petrify = "Will become petrified in %s.",

	-- pickable.lua
	regrowth = "<icon=%s> <color=NATURE>%s</color>",
	--regrowth_paused = "Regrowth paused.",
	--pickable_cycles = "Remaining harvests: %s / %s",

	-- pollinator.lua
	pollination = "Flowers pollinated: (%s) / %s",

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

	-- sanity.lua
	sanity = "<icon=sanity> <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<icon=enlightenment> <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

	-- sanityaura.lua
	sanityaura = "<icon=sanity> <color=SANITY>%s/min</color>",

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- soul.lua
	wortox_soul_heal = "<icon=health> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",

	-- spawner.lua
	--spawner_next = "Will spawn a %s in %s.",

	-- stewer.lua
	cooktime_remaining = "<icon=%s>(<color=HUNGER>%s</color>) %s",
	--cooker = "Cooked by <color=%s>%s</color>.",
	--cooktime_modifier_slower = "Cooks food <color=#DED15E>%s%%</color> slower.", -- some sort of double side-chevron (like a slow down sign) <<
	--cooktime_modifier_faster = Cooks food <color=NATURE>%s%%</color> faster.",-- some sort of double side-chevron (like a speed up sign) >>

	-- stickable.lua
	stickable = "<icon=n> %s",

	-- temperature.lua
	temperature = "<icon=winterometer> %s",

	-- tigersharker.lua
	--tigershark_spawnin = "Can spawn in: %s",
	--tigershark_waiting = "Ready to spawn.",
	--tigershark_exists = "Tiger shark is present.",

	-- timer.lua
	--timer_paused = "Paused",
	--timer = "Timer '%s': %s",

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

	-- waterproofer.lua
	waterproofness = "<icon=wetness> <color=WET>%s%%</color>",

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>Damage</color>",
		electric = "<color=WET>Electric</color> <color=HEALTH>Damage</color>",
		poisonous = "<color=NATURE>(Poisonous)</color> <color=HEALTH>Damage</color>",
		thorns = "<color=HEALTH>(Thorns)</color> <color=HEALTH>Damage</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Range: %s",

	-- wereness
	wereness_remaining = "Wereness: %s / %s",

	-- witherable.lua
	witherable = {
		--delay = "State change is delayed for %s",
		--wither = "Will wither in %s",
		--rejuvenate = "Will rejuvenate in %s"
	}
}