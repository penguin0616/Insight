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

-- Translated by: https://steamcommunity.com/id/interesting28/ and https://steamcommunity.com/id/cloudyyoung

-- CY notes: Not break Chinese characters with space, even with color tag. Only break when meeting pucntuations or numbers.


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
		autumn = "秋天",
		winter = "冬天",
		spring = "春天",
		summer = "夏天",
	},

	-------------------------------------------------------------------------------------------------------------------------
	
	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "最低<color=SANITY>理智</color>光源: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_sanity = "你的<color=SANITY>理智</color>: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "召唤<color=ENLIGHTENMENT>月灵</color>造成<color=HEALTH>%s</color>伤害.",
	},

	-- appeasement.lua
	appease_good = "延迟火山喷发 %s 个时段",
	appease_bad = "加速火山喷发 %s 个时段",

	-- appraisable.lua
	appraisable = "凶猛: %s, 喜庆: %s, 正式: %s",

	-- armor.lua
	protection = "<color=HEALTH>保护度</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color>",

	-- beard.lua
	beard = "你的胡子将在 %s 天后长好.",

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
	breeder_nextfishtime = "加鱼于: %s 后", -- cy "额外的鱼: %s", but GT says latter is "extra fish" while former is "add fish".
	breeder_possiblepredatortime = "可能生成捕食者于: %s",

	-- burnable.lua
	burnable = {
		smolder_time = "即将<color=LIGHT>燃起</color>: <color=LIGHT>%s</color>",
		burn_time = "剩余<color=LIGHT>燃烧时间</color>: <color=LIGHT>%s</color>",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "等待你回到犯罪地点",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN>%s</color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN>%s</color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		both_regen = "<color=MOB_SPAWN>%s</color> & <color=MOB_SPAWN>%s</color>",
		regenerating = "%s 重新生长于: %s",
		entity = "<color=MOB_SPAWN>%s</color>",
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
	buff_text = "<color=MAGIC>加成</color>: <color=MAGIC>%s</color>, %s",
	debuffs = { -- ugh
		["buff_attack"] = "攻击加强 <color=HEALTH>%s%%</color>, 持续 %s 秒.",
		["buff_playerabsorption"] = "伤害减少 <color=MEAT>%s%%</color>, 持续 %s 秒.",
		["buff_workeffectiveness"] = "效率提升 <color=#DED15E>%s%%</color>, 持续 %s 秒.",

		["buff_moistureimmunity"] = "免疫<color=WET>潮湿</color>, 持续 %s 秒.",
		["buff_electricattack"] = "攻击<color=WET>带电</color>, 持续 %s 秒.",
		["buff_sleepresistance"] = "抵抗<color=MONSTER>睡眠</color>, 持续 %s 秒.",
		
		["tillweedsalve_buff"] = "回复 <color=HEALTH>%s 健康</color> 于 %s 秒.",
		["healthregenbuff"] = "回复 <color=HEALTH>%s 健康</color> 于 %s 秒.",
		["sweettea_buff"] = "回复 <color=SANITY>%s 理智</color> 于 %s 秒.",
	},

	-- deerclopsspawner.lua
	incoming_deerclops_targeted = "<color=%s>目标: %s</color> -> %s",

	-- diseaseable.lua
	disease_in = "将感染疾病于: %s",
	disease_spread = "将传播疾病于: %s",
	disease_delay = "疾病被延迟: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "驯化: %s%%",
		obedience = "顺从: %s%%",
		obedience_extended = "顺从: %s%% (鞍具: >=%s%%, 保持鞍具: >%s%%, 失去驯化: <=%s%%)",
		tendency = "倾向: %s",
		tendencies = {
			["NONE"] = "无",
			[TENDENCY.DEFAULT] = "默认",
			[TENDENCY.ORNERY] = "战斗",
			[TENDENCY.RIDER] = "骑乘",
			[TENDENCY.PUDGY] = "肥胖"
		},
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "暂停晾干",
	dry_time = "完成还需: %s",

	-- edible.lua
	food_unit = "<color=%s>%s</color> 个单位的 <color=%s>%s</color>",
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
		temperature = "温度变化: %s, %s",
		caffeine = "速度: %s, %s",
		surf = "船只速度: %s, %s",
		autodry = "干燥: %s, %s",
		instant_temperature = "温度变化: %s, (瞬间)",
		antihistamine = "花粉症延时: %ss",
	},
	foodmemory = "最近食用: %s / %s，会忘记于: %s后",
	wereeater = "已食用<color=MONSTER>怪兽肉</color>: %s / %s, 将消逝于: %s", 

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>移动速度</color>: %s%%",
	hunger_slow = "<color=HUNGER>饥饿速度降低</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>饥饿度降低</color>: <color=HUNGER>%s%%</color>",
	insulated = "保护你免遭雷击.",

	-- example.lua
	why = "[为什么我是空的]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>爆炸伤害</color>: %s",
	explosive_range = "<color=LIGHT>爆炸范围</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "会长成 <color=NATURE>%s</color>.",
		nutrient_consumption = "Δ养分: [<color=NATURE>%d<sub>催长剂</sub></color>, <color=CAMO>%d<sub>堆肥</sub></color>, <color=INEDIBLE>%d<sub>粪肥</sub></color>]",
		good_seasons = "生长季节: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "压力值: %s",
		display = "压力来源: %s",
		stress_tier = "压力级别: %s",
		tiers = (IsDST() and {
			[FARM_PLANT_STRESS.NONE] = "无",
			[FARM_PLANT_STRESS.LOW] = "低",
			[FARM_PLANT_STRESS.MODERATE] = "中",
			[FARM_PLANT_STRESS.HIGH] = "高",
		} or {}),
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color>",
		soil_plant = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color> (<color=WET>%s/分<sub>植物</sub></color>)",
		soil_plant_tile = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color> (<color=WET>%s<sub>植物</sub></color> [<color=#2f96c4>%s<sub>格</sub></color>])<color=WET>/分</color>",
		soil_plant_tile_net = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color> (<color=WET>%s<sub>植物</sub></color> [<color=#2f96c4>%s<sub>格</sub></color> + <color=SHALLOWS>%s<sub>世界</sub></color> = <color=#DED15E>%+.1f<sub>网</sub></color>])<color=WET>/分</color>"
	},

	farmsoildrinker_nutrients = { -- Formula 催长剂, Compost 堆肥, Manure 粪肥
		soil_only = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]",
		soil_plant = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>])",
		--soil_plant_tile = "养分: [%+d<color=NATURE><sub>催</sub></color>, %+d<color=CAMO><sub>堆</sub></color>, %+d<color=INEDIBLE><sub>粪</sub></color>]<sup>格</sup> ([<color=#bee391>%+d<sub>催</sub></color>, <color=#7a9c6e>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>格Δ</sup>)",
		--soil_plant_tile = "养分: [%+d<color=NATURE><sub>催</sub></color>, %+d<color=CAMO><sub>堆</sub></color>, %+d<color=INEDIBLE><sub>粪</sub></color>]<sup>格</sup> ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>格Δ</sup>)",
		soil_plant_tile = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>tile</sub>   (Δ[<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>]<sub>植物</sub> [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>格Δ</sub>)",
		--soil_plant_tile_net = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>] + [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] = [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>])"
	},
	
	-- fertilizer.lua
	fertilizer = {
		growth_value = "缩短 <color=NATURE>%s</color> 秒<color=NATURE>生长时间</color>",
		nutrient_value = "养分: [<color=NATURE>%s<sub>催长剂</sub></color>, <color=CAMO>%s<sub>堆肥</sub></color>, <color=INEDIBLE>%s<sub>粪肥</sub></color>]",
		wormwood = {
			formula_growth = "加速<color=LIGHT_PINK>开花</color> <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>回复</color>你的<color=HEALTH>%+d</color>于 <color=HEALTH>%s</color> 秒.",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "可被海水填充",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	actions = {
		uses_plain = "使用",
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
		till = "耕种",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>鱼</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = "+1 条鱼于: %s",
	--fish_wait_time = "抓一条鱼将花费 <color=SHALLOWS>%s 秒</color>.",

	-- fishingrod.lua
	fishingrod_waittimes = "等待时间: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "最大缠绕时间: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "领导者: %s", -- cy "主人: %s", but GT says it comes out to "the host". CY: Should mean "master" here by context, but this is fine
	loyalty_duration = "忠诚持续时间: %s",
	ghostlybond = "等级: %s / %s. +1 于 %s 后",
	ghostlybond_self = "你的等级: %s / %s. +1 于 %s 后", -- i did this one myself ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

	-- forcecompostable.lua
	forcecompostable = "肥料值: %s",

	-- friendlevels.lua
	friendlevel = "友善等级: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> 秒的燃料.",
		fuel_verbose = "<color=LIGHT>%s</color> 秒的 <color=LIGHT>%s</color>",
		type = "燃料类型: %s",
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>燃料</color>持续时间 (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color>持续时间 (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>燃烧效率</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>燃料</color>: <color=LIGHT>%s</color>",
	},

	-- growable.lua
	growth_stage = "'%s' 阶段: %s / %s: ",
	growth_paused = "暂停生长",
	growth_next_stage = "下一阶段于 %s 后",

	-- grower.lua
	harvests = "<color=NATURE>剩余使用次数</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 于 %s后",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "不适感: %s / %s",
		progress = "孵化过程: %s / %s",
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
		hunt_progress = "脚印: %s / %s",
		impending_ambush = "下一个脚印为猎物。",
		alternate_beast_chance = "<color=#b51212>%s%% 概率</color> 是一只 <color=MOB_SPAWN>座狼</color> or <color=MOB_SPAWN>钢羊</color>.",
	},

	-- inspectable.lua
	catcoonden = {
		lives = "浣熊猫寿命: %s / %s",
		regenerate = "浣熊猫将复活于: %s",
		waiting_for_sleep = "等待附近玩家走开。",
	},
	wx78_charge = "剩余充能: %s",
	stagehand = {
		hits_remaining = "剩余<color=#aaaaee>敲击</color>: <color=#aaaaee>%s</color>",
		time_to_reset = "将重置于 %s."  
	},
	canary = { -- 金丝雀（在洞穴）
		gas_level = "<color=#DBC033>空气值</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "变为<color=#522E61>有毒</color>的概率: <color=#D8B400>%d%%</color>",
		gas_level_increase = "增加于 %s.",
		gas_level_decrease = "减少于 %s."
	},
	fossil_stalker = {
		pieces_needed = "有 20%% 几率组装错误在组装上 %s 片后",
		correct = "组装正确",
		incorrect = "组装错误",
	},
	lureplant_active = "开始活动于: %s后",
	walrus_camp_respawn = "<color=FROZEN>%s</color> 重生于: %s后",
	global_wetness = "<color=FROZEN>世界潮湿度</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>降水率</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>青蛙雨几率</color>: <color=FROG>%s%%</color>",
	world_temperature = "<color=LIGHT>世界温度</color>: <color=LIGHT>%s</color>",
	unlocks = "解锁: %s",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>保暖效果</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>隔热效果</color>: <color=FROZEN>%s</color>",

	-- klaussackloot.lua
	klaussackloot = "重要战利品:",

	-- klaussackspawner.lua
	klaussack_spawnsin = "%s",
	klaussack_despawn = "消失在第 %s 天",

	-- leader.lua
	followers = "跟随者数量: %s",

	-- madsciencelab.lua
	madsciencelab_finish = "完成于: %s 后",

	-- malbatrossspawner.lua
	malbatross_spawnsin = "%s",
	malbatross_waiting = "等待某人前往鱼群",

	-- mast.lua
	mast_sail_force = "帆力: %s",
	mast_max_velocity = "最高速度: %s",

	-- mermcandidate.lua
	mermcandidate = "卡路里: %s / %s",

	-- mine.lua
	mine = {
		active = "每 %s 秒检查一次触发器",
		inactive = "不检查触发器",
		beemine_bees = "将飞出 %s 个蜜蜂",
		trap_starfish_cooldown = "重组于: %s 后",
	},

	-- moisture.lua
	moisture = "<color=WET>潮湿</color>: <color=WET>%s%%</color>",

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "目的地进度: %s / %s",
			time_for_next_tool = "另一个工具将需要于 %s.",
			experiment_time = "实验将完成于 %s.",
		},
		storm_move = "%s%% 概率于第 %d 天月球风暴",
	},

	-- nightmareclock.lua
	nightmareclock = "<color=%s>阶段: %s</color>, %s", -- weird one, 时期 VS 阶段?
	nightmareclock_lock = "被<color=#CE3D45>远古钥匙</color>锁住",

	-- oar.lua
	oar_force = "<color=INEDIBLE>力度</color>: <color=INEDIBLE>%s%%</color>",

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	-- TODO: Pull translations directly from DST, as some language mods would overwrite official translations
	-- eg. Officially "stale" woule be 不新鲜 and Chinese++ would give it as 陈旧 for more native expression if player subscribed this mod
	-- So Insight could display different translations accordingly? Actually do this to all the other possible strings...
	perishable = {
		rot = "腐烂",
		stale = "不新鲜", -- cy: "陈旧", GT says "obsolete"
		spoil = "变质",
		dies = "死亡",
		starves = "饿死",
		transition = "<color=MONSTER>%s</color>于: %s 后", -- cy: for this and extended, remove "后", but GT says right now its "after" and removing makes it "on"
		transition_extended = "<color=MONSTER>%s</color>于: %s 后 (<color=MONSTER>%s%%</color>)",
		paused = "当前暂停腐烂",
	},

	-- petrifiable.lua
	petrify = "石化于: %s",

	-- pickable.lua
	regrowth = "<color=NATURE>重新生长</color> 在: <color=NATURE>%s</color> 后", -- has grammar problem, left because too annoying
	regrowth_paused = "重生暂停",
	pickable_cycles = "剩余收获次数: %s / %s",

	-- pollinator.lua
	pollination = "花朵授粉: (%s) / %s",

	-- preservative.lua
	preservative = "恢复 %s%% 新鲜度.",

	-- quaker.lua
	next_quake = "<color=INEDIBLE>地震</color> 于%s后", -- same thing as perishable transition

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "剩余玩具数: %s",
			assisted_by = "这个小惊吓正在受到 %s 的帮助",
		},
	},

	-- repairer.lua
	repairer = {
		type = "修复工具: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>生命恢复</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>flat HP</sub></color> + <color=HEALTH>%s%%<sub>percent HP</sub></color>",
		work = "<color=#DED15E>工作修复</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>work</sub></color>",
		perish = "<color=MONSTER>提鲜</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>提鲜</color>: <color=MONSTER>%s%%</color>",
		materials = (IsDST() and {
			[MATERIALS.WOOD] =  "木头",
			[MATERIALS.STONE] =  "石头",
			[MATERIALS.HAY] =  "干草",
			[MATERIALS.THULECITE] =  "图勒信物",
			[MATERIALS.GEM] =  "宝石",
			[MATERIALS.GEARS] =  "齿轮",
			[MATERIALS.MOONROCK] =  "月岩石",
			[MATERIALS.ICE] =  "冰",
			[MATERIALS.SCULPTURE] =  "雕像",
			[MATERIALS.FOSSIL] =  "化石",
			[MATERIALS.MOON_ALTAR] =  "天体祭坛",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "需要<color=#99635D>齿轮</color>: <color=#99635D>%s</color>",
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "无法生成"
	},

	-- sanity.lua
	sanity = "<color=SANITY>理智</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<color=ENLIGHTENMENT>启蒙</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

	-- sanityaura.lua
	sanityaura = "<color=SANITY>理智光环</color>: <color=SANITY>%s/分</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "这个已经打开过了",
		chest_labyrinth = {
			sanity = "66% 概率改变<color=SANITY>理智</color>，从 <color=SANITY>-20</color> 到 <color=SANITY>20</color>",
			hunger = "66% 概率改变<color=HUNGER>饥饿</color>，从 <color=HUNGER>-20</color> 到 <color=HUNGER>20</color>",
			health = "66% 概率改变<color=HEALTH>健康</color>，从 <color=HEALTH>0</color> 到 <color=HEALTH>20</color>",
			inventory = "66% 概率增加 20% <color=LIGHT>耐久</color>或<color=MONSTER>新鲜</color>",
			summonmonsters = "66% 概率召唤 1-3 个<color=MOB_SPAWN>穴居悬蛛</color>",
		},
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "生成于 %s.",
			sanity_reward = "<color=SANITY>理智</color>奖励: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>理智</color>奖励: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- skinner_beefalo.lua
	skinner_beefalo = "凶猛: %s, 喜庆: %s, 正式: %s",

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>治疗</color> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>治疗</color> <color=#DED15E>%s 个格子</color> 内的玩家.",

	-- spawner.lua
	spawner_next = "将生成 <color=MOB_SPAWN>%s</color> 于 %s",
	spawner_child = "生成一个 <color=#ff9999>%s</color>",

	-- stewer.lua
	stewer_product = "<color=HUNGER>%s</color>(<color=HUNGER>%s</color>)",
	cooktime_remaining ="<color=HUNGER>%s</color>(<color=HUNGER>%s</color>) 将在 %s 秒后完成",
	cooker = "由 <color=%s>%s</color> 烹饪",
	cooktime_modifier_slower = "烹调食物 <color=#DED15E>%s%%</color> 减慢.",
	cooktime_modifier_faster = "烹调食物 <color=NATURE>%s%%</color> 加快.",

	-- stickable.lua
	stickable = "<color=FISH>贻贝</color>: %s",

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
	tradable_rocktribute = "延迟<color=LIGHT>蚁狮</color>愤怒 %s 天", -- needs to get updated to english equivelant

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "阶段: %s / %s: ",
	upgradeable_complete = "升级 %s%% 完成",
	upgradeable_incomplete = "不可升级",

	-- waterproofer.lua
	waterproofness = "<color=WET>防水</color>: <color=WET>%s%%</color>",

	-- watersource.lua
	watersource = "这是一个水源.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "增加 <color=WET>%s</color> 土壤湿度"
	},

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>伤害</color>",
		electric = "<color=WET>(电击)</color> <color=HEALTH>伤害</color>",
		poisonous = "<color=NATURE>(毒性)</color> <color=HEALTH>伤害</color>",
		thorns = "<color=HEALTH>(反弹)</color> <color=HEALTH>伤害</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "范围: %s",

	-- weighable.lua
	weighable = {
		weight = "重量: %s (%s%%)",
		weight_bounded = "重量: %s <= %s (%s) <= %s",
		owner_name = "主人: %s",
	},

	-- werebeast.lua
	werebeast = "木头值: %s / %s",

	-- wereness.lua
	wereness_remaining = "木头值: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "这是一个夹夹绞盘组件，但是预设检查失败",
		sunken_item = "夹夹绞盘底下有一个<color=#66ee66>%s</color>",
	},

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "你已可以打开<color=#DED15E>稀有礼物</color>.",
		not_ready = "你必须<color=#ffbbbb>等待 %s 天</color>才能再次获得一个<color=#DED15E>稀有礼物</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "状态变化延迟 %s",
		wither = "将枯萎于 %s",
		rejuvenate = "将复长于 %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance = "<color=#636C5C>树精守卫几率</color>: <sub>你</sub> %s%% & <sub>NPC</sub> %s%%"
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "切换世界已被禁用.",
		target_shard = "目标世界: %s",
		received_portal = "传送门: %s",
		id = "这是 #: %s",
	},

	-- yotb_sewer.lua
	yotb_sewer = "缝制将完成于: %s",
}