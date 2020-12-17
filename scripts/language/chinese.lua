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

-- Translated by: https://steamcommunity.com/id/interesting28/

return {
	-- insightservercrash.lua
	server_crash = "This server has crashed. The cause is unknown.",

	-- modmain.lua
	dragonfly_ready = "准备战斗",

	-- time.lua
	time_segments = "%s 个时段",
	time_days = "%s 天, ",
	time_days_short = "%s 天",
	time_seconds = "%s 秒",
	time_minutes = "%s 分, ",
	time_hours = "%s 小时, ",

	-------------------------------------------------------------------------------------------------------------------------

	-- appeasement.lua
	appease_good = "延迟火山喷发 %s 个时段",
	appease_bad = "加速火山喷发 %s 个时段",

	-- armor.lua
	protection = "<color=HEALTH>保护程度</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",

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

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "等待你回到犯罪地点",

	-- combat.lua
	damage = "<color=HEALTH>伤害</color>: <color=HEALTH>%s</color>",
	damageToYou = " (对你的伤害 <color=HEALTH>%s</color>)",

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
		tendency = "Tendency: %s"
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

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>移速</color>: %s%%",
	hunger_slow = "<color=HUNGER>饥饿速度降低</color>: <color=HUNGER>%s%%</color>",

	-- example.lua
	--why = "[why am i empty]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>爆炸伤害</color>: %s",
	explosive_range = "<color=LIGHT>爆炸范围</color>: %s",

	-- farmplantable.lua
	farmplantable = "Will grow into a <color=NATURE>%s</color>.",

	-- farmplantstress.lua
	farmplantstress = {
		display = "Stressors: %s",
	},

	-- farmsoildrinker.lua
	--farmsoildrinker = "<color=WET>Water</color>: <color=WET>%s%%</color>",
	
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
		accepts_ocean_water = "Can be filled with ocean water.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_sleepin = "睡觉",
	action_fan = "扇风",
	action_play = "演奏", -- beefalo horn
	action_hammer = "锤",
	action_chop = "砍",
	action_mine = "开采",
	action_net = "抓",
	action_hack = "劈", -- sw
	action_terraform = "铲地",
	action_dig = "挖",
	action_brush = "刷",
	action_gas = "喷", -- hamlet
	action_disarm = "拆", -- hamlet
	action_pan = "淘", -- hamlet
	action_dislodge = "凿", -- hamlet
	action_spy = "调查", -- hamlet
	action_throw = "扔", -- sw
	action_unsaddle = "解鞍",
	action_shear = "剪",
	action_attack = "攻击",
	action_fish = "钓",
	action_row = "划",
	action_row_fail = "划（失败）",

	-- fishable.lua
	fish_count = "<color=SHALLOWS>鱼</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": 加1条鱼在：%s 后",

	-- fishingrod.lua
	fishingrod_waittimes = "等待时间: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",

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
	fuel = "<color=LIGHT>%s</color> 秒的燃料.",
	fuel_verbose = "<color=LIGHT>%s</color> 秒的 <color=LIGHT>'%s'</color>",

	-- fueled.lua
	fueled_time = "<color=LIGHT>燃料</color> 持续时间 (<color=LIGHT>%s%%</color>): %s", -- percent, time
	fueled_time_verbose = "<color=LIGHT>%s</color> 持续时间 (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
	fuel_efficiency = "<color=LIGHT>燃烧效率</color>: <color=LIGHT>%s%%</color>",

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
		grow = "+1 in %s.",
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

	-- inspectable.lua
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
	hunt_progress = "追踪：%s / %s",
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
	madsciencelab_finish = "Will finish in: %s",

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
	rot = "腐烂",
	stale = "不新鲜",
	spoil = "变质",
	dies = "死",
	perishable_transition = "<color=MONSTER>%s</color>于: %s后",
	perishable_paused = "当前暂停腐烂",

	-- petrifiable.lua
	petrify = "Will become petrified in %s.",

	-- pickable.lua
	regrowth = "<color=NATURE>重新生长</color> 在: <color=NATURE>%s</color> 后", -- has grammar problem, left because too annoying
	regrowth_paused = "重生暂停",
	pickable_cycles = "剩余收获次数：%s / %s",

	-- pollinator.lua
	pollination = "Flowers pollinated: (%s) / %s",

	-- preservative.lua
	preservative = "Restores %s%% of freshness.",

	-- quaker.lua
	next_quake = "<color=INEDIBLE>地震</color> 于%s后",

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Toys remaining: %s",
			assisted_by = "This pipspook is being assisted by %s.",
		},
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "Unable to spawn."
	},

	-- sanity.lua
	sanity = "<color=SANITY>理智</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<color=ENLIGHTENMENT>启蒙值</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

	-- sanityaura.lua
	sanityaura = "<color=SANITY>理智光环</color>: <color=SANITY>%s/分</color>",

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>治疗</color> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Heals</color> people within <color=#DED15E>%s tiles</color>.",

	-- spawner.lua
	spawner_next = "将生成 %s 于 %s后",

	-- stewer.lua
	stewer_product = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>)",
	cooktime_remaining = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>) 会在 %s 秒后完成",
	cooker = "Cooked by <color=%s>%s</color>.",
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
		owner_name = "Owner: %s"
	},

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
	}
}