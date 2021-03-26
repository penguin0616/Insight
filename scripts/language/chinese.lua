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

-- Translated by: https://steamcommunity.com/id/interesting28/

return {
	-- insightservercrash.lua
	server_crash = "由于未知原因，服务器崩溃",

	-- modmain.lua
	dragonfly_ready = "准备战斗",

	-- time.lua
	time_segments = "%s 个时段",
	time_days = "%s 天, ",
	time_days_short = "%s 天",
	time_seconds = "%s 秒",
	time_minutes = "%s 分, ",
	time_hours = "%s 小时, ",

	-- meh
	seasons = {
		autumn = "Autumn",
		winter = "Winter",
		spring = "Spring",
		summer = "Summer",
	},

	-------------------------------------------------------------------------------------------------------------------------

	-- appeasement.lua
	appease_good = "延迟火山喷发 %s 个时段",
	appease_bad = "加速火山喷发 %s 个时段",

	-- appraisable.lua
	appraisable = "Fearsome: %s, Festive: %s, Formal: %s",

	-- armor.lua
	protection = "<color=HEALTH>保护程度</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color>",

	-- beard.lua
	beard = "Your beard will improve in %s day(s).",

	-- beargerspawner.lua
	incoming_bearger_targeted = "<color=%s>目标: %s</color> -> %s",

	-- boathealth.lua
	-- use 'health' from 'health'

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>热带鱼</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>紫石斑鱼</color>",
	breeder_fish4 = "<color=#DED15E>小丑鱼</color>",
	breeder_fish5 = "<color=#9ADFDE>霓虹鱼</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "加鱼在：%s后",
	breeder_possiblepredatortime = "可能生成捕食者在: %s后",

	-- burnable.lua
	burnable = {
		smolder_time = "Will <color=LIGHT>ignite</color> in: <color=LIGHT>%s</color>",
		burn_time = "Remaining <color=LIGHT>burn time</color>: <color=LIGHT>%s</color>",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "等待你回到犯罪地点",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN>%s</color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN>%s</color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		both_regen = "<color=MOB_SPAWN>%s</color> & <color=MOB_SPAWN>%s</color>",
		regenerating = "Regenerating %s in: %s",
		--entity = "<color=MOB_SPAWN>%s</color>",
	},

	-- combat.lua
	damage = "<color=HEALTH>伤害</color>: <color=HEALTH>%s</color>",
	damageToYou = " (对你的伤害 <color=HEALTH>%s</color>)",

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "冷却: %s",

	-- crabkingspawner.lua
	crabking_spawnsin = "%s",

	-- crittertraits.lua
	dominant_trait = "特质: %s",

	-- crop.lua
	crop_paused = "暂停",
	growth = "<color=NATURE>%s</color>: <color=NATURE>%s</color>",

	-- dapperness.lua
	dapperness = "<color=SANITY>理智</color>: <color=SANITY>%s/分</color>",

	-- debuffable.lua
	buff_text = "<color=MAGIC>Buff</color>: <color=MAGIC>%s</color>, %s",
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
	incoming_deerclops_targeted = "<color=%s>目标: %s</color> -> %s",

	-- diseaseable.lua
	disease_in = "感染疾病在：%s后",
	disease_spread = "传播疾病在：%s后",
	disease_delay = "疾病延迟：%s",

	-- domesticable.lua
	domesticable = {
		domestication = "驯化值: %s%%",
		obedience = "顺从值: %s%%",
		tendency = "趋势：%s"
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "暂停晾干",
	dry_time = "完成还需: %s",

	-- edible.lua
	food_unit = "<color=%s>%s</color> 单位的 <color=%s>%s</color>",
	edible_interface = "<color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=SANITY>理智</color>: <color=SANITY>%s</color> / <color=HEALTH>生命</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>生命</color>: <color=HEALTH>%s</color> / <color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=SANITY>理智</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "肉度",
		monster = "怪物度",
		fish = "鱼度",
		veggie = "菜度",
		fruit = "水果度",
		egg = "蛋度",
		sweetener = "甜味剂",
		frozen = "冰度",
		fat = "脂肪度",
		dairy = "乳制品",
		decoration = "装饰物",
		magic = "魔法度",
		precook = "熟食",
		dried = "干货",
		inedible = "不可食用物",
		bug = "虫子",
		seed = "种子"
	},
	edible_foodeffect = {
		temperature = "温度变化：%s, %s",
		caffeine = "速度：%s, %s",
		surf = "船只速度: %s, %s",
		autodry = "干燥：%s, %s",
		instant_temperature = "温度变化：%s, (瞬间)",
		antihistamine = "花粉症延时：%ss",
	},
	foodmemory = "最近食用：%s / %s，会忘记于：%s后",
	wereeater = "<color=MONSTER>Monster meat</color> eaten: %s / %s, will forget in: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>移速</color>: %s%%",
	hunger_slow = "<color=HUNGER>饥饿速度降低</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>Hunger drain</color>: <color=HUNGER>%s%%</color>",
	insulated = "Protects you from lightning.",

	-- example.lua
	--why = "[why am i empty]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>爆炸伤害</color>: %s",
	explosive_range = "<color=LIGHT>爆炸范围</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "会长成<color=NATURE>%s</color>.",
		nutrient_consumption = "Plant consumes: [<color=NATURE>%d<sub>Formula</sub></color>, <color=CAMO>%d<sub>Compost</sub></color>, <color=INEDIBLE>%d<sub>Manure</sub></color>]",
		good_seasons = "Seasons: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "Stress Points: %s",
		display = "压力源：%s",
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
		soil_only = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color>",
		soil_plant = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s/min<sub>plant</sub></color>)",
		soil_plant_tile = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color>])<color=WET>/min</color>",
		soil_plant_tile_net = "<color=WET>Water</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color> + <color=SHALLOWS>%s<sub>world</sub></color> = <color=#DED15E>%+.1f<sub>net</sub></color>])<color=WET>/min</color>"
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
		growth_value = "缩短 <color=NATURE>%s</color> 秒<color=NATURE>生长时间</color>",
		nutrient_value = "Nutrients: [<color=NATURE>%s</color>, <color=CAMO>%s</color>, <color=INEDIBLE>%s</color>]",
		wormwood = {
			formula_growth = "Accelerates your <color=LIGHT_PINK>blooming</color> by <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>Heals</color> you for <color=HEALTH>%+d</color> over <color=HEALTH>%s</color> second(s).",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "能被海水填充",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	actions = {
		uses_plain = "Uses",
		sleepin = "睡觉",
		fan = "扇风",
		play = "演奏", -- beefalo horn
		hammer = "锤",
		chop = "砍",
		mine = "开采",
		net = "抓",
		hack = "劈", -- sw
		terraform = "铲地",
		dig = "挖",
		brush = "刷",
		gas = "喷", -- hamlet
		disarm = "拆", -- hamlet
		pan = "淘", -- hamlet
		dislodge = "凿", -- hamlet
		spy = "调查", -- hamlet
		throw = "扔", -- sw
		unsaddle = "解鞍",
		shear = "剪",
		attack = "攻击",
		fish = "钓",
		row = "划",
		row_fail = "划（失败）",
		till = "Till",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>鱼</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": 加1条鱼在：%s 后",
	--fish_wait_time = "Will take <color=SHALLOWS>%s seconds</color> to catch a fish.",

	-- fishingrod.lua
	fishingrod_waittimes = "等待时间: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Max wrangle time: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "领导者: %s",
	loyalty_duration = "忠臣持续时间: %s",
	ghostlybond = "等级: %s / %s. +1在%s后",
	ghostlybond_self = "你的等级: %s / %s. +1在%s后", -- i did this one myself ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	-- forcecompostable.lua
	forcecompostable = "Compost value: %s",

	-- friendlevels.lua
	friendlevel = "友善等级: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> 秒的燃料.",
		fuel_verbose = "<color=LIGHT>%s</color> 秒的 <color=LIGHT>%s</color>",
		type = "Fueltype: %s",
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>燃料</color> 持续时间 (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color> 持续时间 (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>燃烧效率</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>燃料</color>: <color=LIGHT>%s</color>",
	},

	-- growable.lua
	growth_stage = "阶段 '%s': %s / %s: ",
	growth_paused = "暂停生长",
	growth_next_stage = "下一阶段在%s 后",

	-- grower.lua
	harvests = "<color=NATURE>剩余使用次数</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1于%s后",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "不舒适感：%s / %s",
		progress = "孵化过程：%s / %s",
	},

	-- healer.lua
	heal = "<color=HEALTH>生命</color>: <color=HEALTH>%+d</color>",

	-- health.lua
	health = "<color=HEALTH>生命</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%s 秒</color>)",
	absorption = " : 吸收 %s%% 伤害",
	naughtiness = "增加淘气值: %s",
	player_naughtiness = "你的淘气值: %s / %s",

	-- herdmember.lua
	herd_size = "群体大小: %s / %s",

	-- hunger.lua
	hunger = "<color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>饥饿速度</color>: <color=HUNGER>%+d/天</color> (<color=HUNGER>%s/秒</color>)",
	hunger_paused = "<color=HUNGER>饥饿值</color>暂停",

	-- hunter.lua
	hunter = {
		hunt_progress = "追踪：%s / %s",
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
		pieces_needed = "有20%%几率组装错误在组装上%s片后",
		correct = "组装正确",
		incorrect = "组装错误",
	},
	trap_starfish_cooldown = "重组于：%s后",
	lureplant_active = "开始活动于: %s后",
	walrus_camp_respawn = "<color=FROZEN>%s</color> 重生于: %s后",
	global_wetness = "<color=FROZEN>世界潮湿度</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>降水率</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>青蛙雨几率</color>: <color=FROG>%s%%</color>",
	world_temperature = "<color=LIGHT>世界温度</color>: <color=LIGHT>%s</color>",
	unlocks = "Unlocks: %s",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>保暖效果</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>隔热效果</color>: <color=FROZEN>%s</color>",

	-- klaussackspawner.lua
	klaussack_spawnsin = "%s",
	klaussack_despawn = "消失在天数：%s",

	-- leader.lua
	followers = "跟随者数量: %s",

	-- madsciencelab.lua
	madsciencelab_finish = "完成于: %s后",

	-- malbatrossspawner.lua
	malbatross_spawnsin = "%s",
	malbatross_waiting = "等待某人去到鱼群",

	-- mast.lua
	mast_sail_force = "帆力: %s",
	mast_max_velocity = "最高速度: %s",

	-- mermcandidate.lua
	mermcandidate = "卡路里：%s / %s",

	-- moisture.lua
	moisture = "<color=WET>潮湿度</color>: <color=WET>%s%%</color>",

	-- nightmareclock.lua
	nightmareclock = "<color=%s>时期: %s</color>, %s",
	nightmareclock_lock = "被<color=#CE3D45>远古钥匙</color>锁住",

	-- oar.lua
	oar_force = "<color=INEDIBLE>力度</color>: <color=INEDIBLE>%s%%</color>",

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "腐烂",
		stale = "不新鲜",
		spoil = "变质",
		dies = "死",
		starves = "Starves",
		transition = "<color=MONSTER>%s</color>于: %s后",
		transition_extended = "<color=MONSTER>%s</color>于: %s后 (<color=MONSTER>%s%%</color>)",
		paused = "当前暂停腐烂",
	},

	-- petrifiable.lua
	petrify = "石化于：%s后",

	-- pickable.lua
	regrowth = "<color=NATURE>重新生长</color> 在: <color=NATURE>%s</color> 后", -- has grammar problem, left because too annoying
	regrowth_paused = "重生暂停",
	pickable_cycles = "剩余收获次数：%s / %s",

	-- pollinator.lua
	pollination = "花授粉：(%s) / %s",

	-- preservative.lua
	preservative = "Restores %s%% of freshness.",

	-- quaker.lua
	next_quake = "<color=INEDIBLE>地震</color> 于%s后",

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "剩余玩具数：%s",
			assisted_by = "这个小惊吓正在受到%s的帮助",
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
		cant_spawn = "无法生成"
	},

	-- sanity.lua
	sanity = "<color=SANITY>理智</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<color=ENLIGHTENMENT>启蒙值</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

	-- sanityaura.lua
	sanityaura = "<color=SANITY>理智光环</color>: <color=SANITY>%s/分</color>",

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
	wortox_soul_heal = "<color=HEALTH>治疗</color> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Heals</color> people within <color=#DED15E>%s tiles</color>.",

	-- spawner.lua
	spawner_next = "将生成 <color=MOB_SPAWN>%s</color> 于 %s后",
	spawner_child = "Spawns a <color=#ff9999>%s</color>",

	-- stewer.lua
	stewer_product = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>)",
	cooktime_remaining = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>) 会在 %s 秒后完成",
	cooker = "由<color=%s>%s</color>烹饪",
	cooktime_modifier_slower = "Cooks food <color=#DED15E>%s%%</color> slower.",
	cooktime_modifier_faster = "Cooks food <color=NATURE>%s%%</color> faster.",

	-- stickable.lua
	stickable = "<color=FISH>贻贝</color>：%s",

	-- temperature.lua
	temperature = "温度: %s",

	-- tigersharker.lua
	tigershark_spawnin = "重生于: %s后",
	tigershark_waiting = "重生准备就绪",
	tigershark_exists = "当前虎鲨出没",

	-- timer.lua
	timer_paused = "暂停",
	timer = "计时 '%s': %s",

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>效率</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "价值 %s 个金块",
	tradable_gold_dubloons = "价值 %s 个金块和 %s 个金币",
	tradable_rocktribute = "延迟<color=LIGHT>蚁狮</color>愤怒 %s天",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "阶段：%s / %s: ",
	upgradeable_complete = "升级 %s%% 完成",
	upgradeable_incomplete = "不可升级",

	-- waterproofer.lua
	waterproofness = "<color=WET>防水</color>: <color=WET>%s%%</color>",

	-- watersource.lua
	watersource = "This is a source of water.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "Increases soil moisture by <color=WET>%s</color>."
	},

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>伤害</color>",
		electric = "<color=WET>电系</color> <color=HEALTH>伤害</color>",
		poisonous = "<color=NATURE>(毒性)</color> <color=HEALTH>伤害</color>",
		thorns = "<color=HEALTH>(反弹)</color> <color=HEALTH>伤害</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "范围：%s",

	-- weighable.lua
	weighable = {
		weight = "Weight: %s (%s%%)",
		weight_bounded = "Weight: %s <= %s (%s) <= %s",
		owner_name = "Owner: %s"
	},

	-- werebeast.lua
	werebeast = "Wereness: %s / %s",

	-- wereness.lua
	wereness_remaining = "木头值：%s / %s",

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