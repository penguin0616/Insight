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

local function AdjectiveToNoun(str)
	return str:gsub('%的', '')
end
--[[
local beard = STRINGS.UI.COLLECTIONSCREEN.BEARD
local catcoon = STRINGS.UI.HUD.TROPHYSCALE_PREFAB_OVERRIDE_OWNER.catcoon
local stale = AdjectiveToNoun(STRINGS.UI.HUD.STALE)
--]]

-- in case string is missing
local function proxy(real)
	return setmetatable({_real = real}, {
		__index = function(self, index)
			print("proxy index", self, index, value)
			local value = self._real[index]
			if type(value) == "table" then
				return proxy(value)
			else
				return value
			end
		end,
		__tostring = function(self)
			return "proxy of " .. tostring(self._real)
		end,
		__mode = "kv"
	})
end

--local _STRINGS = STRINGS
--local STRINGS = proxy(_STRINGS)

return {
	-- insightservercrash.lua
	server_crash = "服务器崩溃",

	-- modmain.lua
	dragonfly_ready = "准备战斗",

	-- time.lua
	time_segments = " %s 个时段",
	time_days = " %s 天",
	time_days_short = " %s 天",
	time_seconds = " %s 秒",
	time_minutes = " %s 分",
	time_hours = " %s 小时",

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
		summoned_gestalt_damage = "召唤<color=ENLIGHTENMENT>月灵</color>造成<color=HEALTH>%s</color>伤害",
	},

	-- appeasement.lua
	appease_good = "延迟火山喷发 %s 个时段",
	appease_bad = "加速火山喷发 %s 个时段",

	-- appraisable.lua
	appraisable = "凶猛: %s, 喜庆: %s, 正式: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "解锁: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>保护度</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>耐久度</color>: <color=#C0C0C0>%s</color>",

	-- attunable.lua
	attunable = {
		linked = "Linked to: %s",
		offline_linked = "Offline links: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "Restores <color=HEALTH>%s health</color> per hit.",
		sanity_cost = "Drains <color=SANITY>%s sanity</color> per hit.",
	},

	-- beard.lua
	beard = "你的" .. "胡须" .. "将于 %s 天后长好", -- 胡须 used to be STRINGS.UI.COLLECTIONSCREEN.BEARD

	-- beargerspawner.lua
	incoming_bearger_targeted = "<color=%s>目标: %s</color> -> %s",

	-- boatdrag.lua
	boatdrag = {
		drag = "Drag: %.5f",
		max_velocity_mod = "Max Velocity Mod: %.3f",
		force_dampening = "Force Dampening: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>热带鱼</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>紫石斑鱼</color>",
	breeder_fish4 = "<color=#DED15E>小丑鱼</color>",
	breeder_fish5 = "<color=#9ADFDE>霓虹鱼</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "%s后有新鱼", -- cy "额外的鱼: %s", but GT says latter is "extra fish" while former is "add fish".
	breeder_possiblepredatortime = "可能于%s后生成捕食者",

	-- brushable.lua
	brushable = {
		last_brushed = "Brushed %s days ago."
	},

	-- burnable.lua
	burnable = {
		smolder_time = "即将<color=LIGHT>燃起</color>: <color=LIGHT>%s</color>",
		burn_time = "剩余<color=LIGHT>燃烧时间</color>: <color=LIGHT>%s</color>",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "Decor value: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "Rare",
			uncommon = "Uncommon",
			common = "Common",
			unknown = "Unknown",
		},
		shape = "Shape: %s",
		rarity = "Rarity: %s",
		undecided = "Must be placed before contents are determined."
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>Rank</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "Total decor: %s",
	},
	
	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>Gas level</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "Chance of becoming <color=#522E61>poisoned</color>: <color=#D8B400>%d%%</color>",
		gas_level_increase = "Increases in %s.",
		gas_level_decrease = "Decreases in %s."
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "一只浣熊" .. "寿命: %s / %s", -- STRINGS.UI.HUD.TROPHYSCALE_PREFAB_OVERRIDE_OWNER.catcoon
		regenerate = "一只浣熊" .. "%s后复活", -- STRINGS.UI.HUD.TROPHYSCALE_PREFAB_OVERRIDE_OWNER.catcoon
		waiting_for_sleep = "等待附近的玩家走开.",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "等待你回到犯罪地点",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> will respawn in: %s",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>in</sub> + %s<sub>out</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "{regen_time}后{to_regen}重新生长",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>伤害</color>: <color=HEALTH>%s</color>",
		damageToYou = " (对你的伤害 <color=HEALTH>%s</color>)",
		age_damage = "<color=HEALTH>Damage <color=AGE>(Age)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> to you)",
	},

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
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "Step: %s / %s",
		note = ", note: %s",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>理智</color>: <color=SANITY>%s/分</color>",

	-- debuffable.lua
	buff_text = "<color=MAGIC>加成</color>: <color=MAGIC>%s</color>, %s",
	debuffs = { -- ugh
		["buff_attack"] = "攻击加强 <color=HEALTH>{percent}%</color>, 持续 {duration} 秒。",
		["buff_playerabsorption"] = "伤害减少 <color=MEAT>{percent}%</color>, 持续 {duration} 秒。",
		["buff_workeffectiveness"] = "效率提升 <color=#DED15E>{percent}%</color>, 持续 {duration} 秒。",

		["buff_moistureimmunity"] = "免疫<color=WET>潮湿</color>, 持续 {duration} 秒。",
		["buff_electricattack"] = "攻击<color=WET>带电</color>, 持续 {duration} 秒。",
		["buff_sleepresistance"] = "抵抗<color=MONSTER>睡眠</color>, 持续 {duration} 秒。",

		["tillweedsalve_buff"] = "{duration} 秒内回复 <color=HEALTH>{amount} 健康</color>。",
		["healthregenbuff"] = "{duration} 秒内回复 <color=HEALTH>{amount} 健康</color>。",
		["sweettea_buff"] = "{duration} 秒内回复 <color=SANITY>{amount} 理智</color>。",
	},

	-- deerclopsspawner.lua
	incoming_deerclops_targeted = "<color=%s>目标: %s</color> -> %s",

	-- diseaseable.lua
	disease_in = "将于%s后感染疾病",
	disease_spread = "将于%s后传播疾病",
	disease_delay = "疾病被延迟%s",

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
			[TENDENCY.PUDGY] = "肥胖",
		},
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "暂停晾干",
	dry_time = "完成还需: %s",

	-- eater.lua
	eater = {
		eot_loot = "Food restores <color=HUNGER>hunger %s%%</color> + <color=HEALTH>health %s%%</color> as durability.",
		eot_tofeed_restore = "Feeding held <color=MEAT><prefab=%s></color> will restore <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) durability.",
		eot_tofeed_restore_advanced = "Feeding held <color=MEAT><prefab=%s></color> will restore <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) durability.",
		tofeed_restore = "Feeding held <color=MEAT><prefab=%s></color> will restore %s.",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> 个单位的<color=%s>%s</color>",
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
		seed = "种子",
	},
	edible_foodeffect = {
		temperature = "温度变化: %s, %s",
		caffeine = "速度: %s, %s",
		surf = "船只速度: %s, %s",
		autodry = "干燥: %s, %s",
		instant_temperature = "温度变化: %s, (瞬间)",
		antihistamine = "花粉症延时: %ss",
	},
	foodmemory = "最近食用: %s / %s，将忘记于%s后",
	wereeater = "已食用<color=MONSTER>怪兽肉</color>: %s / %s, 将消逝于%s后",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>移动速度</color>: %s%%",
	hunger_slow = "<color=HUNGER>饥饿速度降低</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>饥饿度降低</color>: <color=HUNGER>%s%%</color>",
	insulated = "保护你免遭雷击。",

	-- example.lua
	why = "[为什么我是空的]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>爆炸伤害</color>: %s",
	explosive_range = "<color=LIGHT>爆炸范围</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "将长成 <color=NATURE><prefab=%s></color>。",
		nutrient_consumption = "消耗养分: [<color=NATURE>%d<sub>催长剂</sub></color>, <color=CAMO>%d<sub>堆肥</sub></color>, <color=INEDIBLE>%d<sub>粪肥</sub></color>]",
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
			[FARM_PLANT_STRESS.HIGH] = "高"
		} or {}),
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color>",
		soil_plant = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color> (<color=WET>%s/分<sub>植物</sub></color>)",
		soil_plant_tile = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color> (<color=WET>%s<sub>植物</sub></color> [<color=#2f96c4>%s<sub>格</sub></color>])<color=WET>/分</color>",
		soil_plant_tile_net = "<color=WET>水分</color>: <color=WET>%s<sub> 格</sub></color> (<color=WET>%s<sub>植物</sub></color> [<color=#2f96c4>%s<sub>格</sub></color> + <color=SHALLOWS>%s<sub>世界</sub></color> = <color=#DED15E>%+.1f<sub>网</sub></color>])<color=WET>/分</color>",
	},

	farmsoildrinker_nutrients = {
		soil_only = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]",
		soil_plant = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>])",
		--soil_plant_tile = "养分: [%+d<color=NATURE><sub>催</sub></color>, %+d<color=CAMO><sub>堆</sub></color>, %+d<color=INEDIBLE><sub>粪</sub></color>]<sup>格</sup> ([<color=#bee391>%+d<sub>催</sub></color>, <color=#7a9c6e>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>格Δ</sup>)",
		--soil_plant_tile = "养分: [%+d<color=NATURE><sub>催</sub></color>, %+d<color=CAMO><sub>堆</sub></color>, %+d<color=INEDIBLE><sub>粪</sub></color>]<sup>格</sup> ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>格Δ</sup>)",
		soil_plant_tile = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>tile</sub>   (Δ[<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>]<sub>植物</sub> [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>格Δ</sub>)"
		--soil_plant_tile_net = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>便</sub></color>] + [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] = [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>])",
	},
	
	-- fertilizer.lua
	fertilizer = {
		growth_value = "缩短 <color=NATURE>%s</color> 秒<color=NATURE>生长时间</color>",
		nutrient_value = "养分: [<color=NATURE>%s<sub>催长剂</sub></color>, <color=CAMO>%s<sub>堆肥</sub></color>, <color=INEDIBLE>%s<sub>粪肥</sub></color>]",
		wormwood = {
			formula_growth = "你的<color=LIGHT_PINK>开花</color>加速 <color=LIGHT_PINK>%s</color>。",
			compost_heal = "<color=HEALTH>回复</color> <color=HEALTH>{duration}</color> 秒你的<color=HEALTH>{healing}</color>。",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "可被海水填充",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s / %s",
	actions = {
		USES_PLAIN = "使用",
		TERRAFORM = "铲地",
		GAS = "喷", -- hamlet
		DISARM = "拆", -- hamlet
		PAN = "淘", -- hamlet
		DISLODGE = "凿", -- hamlet
		SPY = "调查", -- hamlet
		THROW = "扔", -- sw
		ROW_FAIL = "划（失败）",
		ATTACK = STRINGS.ACTIONS.ATTACK.GENERIC,
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>鱼</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = "%s后增加一条鱼",
	--fish_wait_time = "抓一条鱼将花费 <color=SHALLOWS>%s 秒</color>。",

	-- fishingrod.lua
	fishingrod_waittimes = "等待时间: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "最大缠绕时间: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "主人: %s", -- "主人" should mean "master" here by free translation, "领导者" is literal translation and not precise?
	loyalty_duration = "忠诚持续时间: %s",
	
	-- forcecompostable.lua
	forcecompostable = "肥料值: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "还有 %s 片组装的错误几率为 20%%",
		correct = "组装正确",
		incorrect = "组装错误",
		gateway_too_far = "这个骷髅距离是 %s 个格子",
	},

	-- friendlevels.lua
	friendlevel = "友善等级: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> 秒的燃料",
		fuel_verbose = "<color=LIGHT>%s</color> 秒的<color=LIGHT>%s</color>",
		type = "燃料类型: %s",
		types = {
			BURNABLE = "Fuel",
			CAVE = "Light", -- miner hat / lanterns, light bulbs n stuff
			CHEMICAL = "Fuel",
			CORK = "Fuel",
			GASOLINE = "Gasoline", -- DS: not actually used anywhere?
			MAGIC = "Durability", -- amulets that aren't refuelable (ex. chilled amulet)
			MECHANICAL = "Durability", -- SW: iron wind
			MOLEHAT = "Night vision", -- Moggles
			NIGHTMARE = "Nightmare fuel",
			NONE = "Time", -- will never be refueled...............................
			ONEMANBAND = "Durability",
			PIGTORCH = "Fuel",
			SPIDERHAT = "Durability", -- Spider Hat
			TAR = "Tar", -- SW
			USAGE = "Durability",
		},
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>燃料</color>持续时间 (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color>持续时间 (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>燃烧效率</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>燃料</color>: <color=LIGHT>%s</color>",
		held_refuel = "Held <color=SWEETENER><prefab=%s></color> will refuel <color=LIGHT>%s%%</color>.",
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>等级</color>: %s / %s.",
		flower = "你的<color=%s>等级</color>: %s / %s.",
		levelup = " %s后升级",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "Regenerates <color=HEALTH>%s health</color> over %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_fastregen = "Regenerates <color=HEALTH>%s health</color> over %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_attack = "Maximizes <color=HEALTH>damage</color> for %s.",
		ghostlyelixir_speed = "Increases <color=DAIRY>speed</color> by <color=DAIRY>%s%%</color> for %s.",
		ghostlyelixir_shield = "Increases shield duration to 1 second for %s.",
		ghostlyelixir_retaliation = "Shield reflects <color=HEALTH>%s damage</color> for %s.", -- concatenated with shield
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "<color=#737CD0><prefab=%s></color> buff duration: %s.",
	},

	-- growable.lua
	growable = {
		stage = "<color=#8c8c8c>'%s'</color> 阶段: %s / %s: ",
		paused = "暂停生长",
		next_stage = "%s后进入下一阶段",
	},

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
	healer = {
		heal = "<color=HEALTH>生命</color>: <color=HEALTH>%+d</color>",
		webber_heal = "Webber <color=HEALTH>Health</color>: <color=HEALTH>%+d</color>",
		spider_heal = "Spider <color=HEALTH>Health</color>: <color=HEALTH>%+d</color>",
	},

	-- health.lua
	health = "<color=HEALTH>生命</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%s 秒</color>)",
	absorption = " : 吸收 %s%% 伤害",
	naughtiness = "增加淘气值: %s",
	player_naughtiness = "你的淘气值: %s / %s",

	-- herdmember.lua
	herd_size = "群体大小: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "Hiding range: %s to %s",
		needed_hiding_spots = "Needed hiding spots: %s",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>饥饿速度</color>: <color=HUNGER>%+d/天</color> (<color=HUNGER>%s/秒</color>)",
	hunger_paused = "<color=HUNGER>饥饿值</color>暂停",

	-- hunter.lua
	hunter = {
		hunt_progress = "脚印: %s / %s",
		impending_ambush = "下一个脚印为猎物。",
		alternate_beast_chance = "<color=#b51212>%s%% 几率</color>是一只<color=MOB_SPAWN>座狼</color>或<color=MOB_SPAWN>钢羊</color>.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn ="%s后将生成<color=MOB_SPAWN><prefab=hutch></color>",

	-- inspectable.lua
	wagstaff_tool = "The name of this tool is: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "Gym weight value: %s",
	mushroom_rain = "<color=WET>Rain</color> needed: %s",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>保暖效果</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>隔热效果</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		hat_describe = "[Hat]: ",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "Number of kitcoons: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "重要战利品:",

	-- klaussackspawner.lua
	klaussack_spawnsin = "%s",
	klaussack_despawn = "消失于第 %s 天",

	-- leader.lua
	followers = "跟随者数量: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "Lightning protection range: %s wall units",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "Will discharge in %s day(s).",

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "%s后开始活动",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "%s后完成",

	-- malbatrossspawner.lua
	malbatross_spawnsin = "%s",
	malbatross_waiting = "等待某人前往鱼群",

	-- mast.lua
	mast_sail_force = "帆力: %s",
	mast_max_velocity = "最高速度: %s",

	-- mermcandidate.lua
	mermcandidate = "卡路里: %s / %s",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>Mightiness</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color>",
	
	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>Mightiness</color> per use: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "Gym weight: %s",
		mighty_gains = "Normal <color=MIGHTINESS>lift</color>: <color=MIGHTINESS>%+.1f</color>, Perfect <color=MIGHTINESS>lift</color>: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>Hunger drain</color>: <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "每 %s 秒检查一次触发器",
		inactive = "不检查触发器",
		beemine_bees = "将飞出 %s 个蜜蜂",
		trap_starfish_cooldown = "%s后重组",
	},

	-- moisture.lua
	moisture = "<color=WET>潮湿</color>: <color=WET>%s%%</color>",

	-- mood.lua
	mood = {
		exit = "Will exit mood in %s day(s).",
		enter = "Will enter mood in %s day(s).",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "目的地进度: %s / %s",
			time_for_next_tool = "%s后需要另一个工具",
			experiment_time = "%s后实验完成",
		},
		storm_move = "%s%% 几率于第 %d 天月球风暴。",
	},

	-- nightmareclock.lua
	nightmareclock = "<color=%s>阶段: %s</color>, %s", -- "阶段 Stage" by free translation, same term used in dst wiki
	nightmareclock_lock = "被<color=#CE3D45>远古钥匙</color>锁住。",

	-- oar.lua
	oar_force = "<color=INEDIBLE>力度</color>: <color=INEDIBLE>%s%%</color>",

	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>Age</color>: <color=714E85>%+d</color>",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "腐烂",
		stale = AdjectiveToNoun("陈腐"), -- AdjectiveToNoun(STRINGS.UI.HUD.STALE)
		spoil = "变质",
		dies = "死亡",
		starves = "饿死",
		transition = "{time}后<color=MONSTER>{next_stage}</color>", -- This is correct
		transition_extended = "{time}后<color=MONSTER>{next_stage}</color> (<color=MONSTER>{percent}%</color>)",
		paused = "当前暂停腐烂",
	},

	-- petrifiable.lua
	petrify = "%s后石化",

	-- pickable.lua
	regrowth = "<color=NATURE>重新生长</color>于 <color=NATURE>%s</color>后", -- has grammar problem, left because too annoying
	regrowth_paused = "重生暂停",
	pickable_cycles = "剩余收获次数: %s / %s",

	-- pollinator.lua
	pollination = "花朵授粉: (%s) / %s",

	-- preservative.lua
	preservative = "恢复 %s%% 新鲜度。",

	-- quaker.lua
	next_quake = "%s后<color=INEDIBLE>地震</color>", -- same thing as perishable transition

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "剩余玩具数: %s",
			assisted_by = "这个小惊吓正在受到 %s 的帮助。",
		},
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>世界潮湿度</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>降水率</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>青蛙雨几率</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "Shard Id: %s",
		shard_type = "Shard type: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "Charged in: %s",
		charge = "Charge: %s / %s"
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
			[MATERIALS.WOOD] = "木头",
			[MATERIALS.STONE] = "石头",
			[MATERIALS.HAY] = "干草",
			[MATERIALS.THULECITE] = "图勒信物",
			[MATERIALS.GEM] = "宝石",
			[MATERIALS.GEARS] = "齿轮",
			[MATERIALS.MOONROCK] = "月岩石",
			[MATERIALS.ICE] = "冰",
			[MATERIALS.SCULPTURE] = "雕像",
			[MATERIALS.FOSSIL] = "化石",
			[MATERIALS.MOON_ALTAR] = "天体祭坛"
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "需要<color=#99635D>齿轮</color>: <color=#99635D>%s</color>",
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "无法生成。",
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>额外伤害</color>: <color=HEALTH>%s</color>",
		bonus_speed = "<color=DAIRY>额外速度</color>: %s%%",
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
			sanity = "66% 几率让<color=SANITY>理智</color>从 <color=SANITY>-20</color> 上升到 <color=SANITY>20</color>。",
			hunger = "66% 几率让<color=HUNGER>饥饿</color>从 <color=HUNGER>-20</color> 上升到 <color=HUNGER>20</color>。",
			health = "66% 几率让<color=HEALTH>健康</color>从 <color=HEALTH>0</color> 上升到 <color=HEALTH>20</color>。",
			inventory = "66% 几率增加 20% <color=LIGHT>耐久</color>或<color=MONSTER>新鲜</color>。",
			summonmonsters = "66% 几率召唤 1-3 个<color=MOB_SPAWN>穴居悬蛛</color>.",
		},
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "生成于 %s。",
			sanity_reward = "<color=SANITY>理智</color>奖励: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>理智</color>奖励: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- sheltered
	sheltered = {
		range = "Shelter range: %s wall units",
		shelter = "Shelter ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>武器</color>持续时间增加 <color=#aaaaee>%s%%</color>。",
			battlesong_healthgain = "攻击敌人回复 <color=HEALTH>%s 生命</color> (薇格弗德为 <color=HEALTH>%s</color>)。",
			battlesong_sanitygain = "攻击敌人回复 <color=SANITY>%s 理智</color>。",
			battlesong_sanityaura = "<color=SANITY>负理智光环</color>效果减少 <color=SANITY>%s%%</color>。",
			battlesong_fireresistance = "受到的<color=LIGHT>火焰</color>伤害<color=HEALTH>减少 %s%%</color>。", -- need optimization
			battlesong_instant_taunt = "嘲讽所有战歌范围内附近的敌人。",
			battlesong_instant_panic = "惊恐附近可惊恐的敌人 %s 秒.",
		},
		cost = "Costs %s inspiration to use.",
	},

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- skinner_beefalo.lua
	skinner_beefalo = "凶猛: %s, 喜庆: %s, 正式: %s",

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>治疗</color> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>。",
	wortox_soul_heal_range = "<color=HEALTH>治疗</color> <color=#DED15E>%s 个格子</color> 内的玩家。",

	-- spawner.lua
	spawner = {
		next = "{respawn_time}后生成 <color=MOB_SPAWN><prefab={child_name}></color>",
		child = "生成一个 <color=MOB_SPAWN><prefab=%s></color>",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>Heals</color> Webber for <color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>Heals</color> spiders for <color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "剩余<color=#aaaaee>敲击</color>: <color=#aaaaee>%s</color>",
		time_to_reset = "%s后重置", 
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>) 将在 %s 秒后完成。",
		cooker = "由 <color=%s>%s</color> 烹饪",
		cooktime_modifier_slower = "烹调食物 <color=#DED15E>%s%%</color> 减慢。",
		cooktime_modifier_faster = "烹调食物 <color=NATURE>%s%%</color> 加快.",
	},

	-- stickable.lua
	stickable = "<color=FISH>贻贝</color>: %s",

	-- temperature.lua
	temperature = "温度: %s",

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "Recovers <color=HEALTH>%s</color> health per unfought day.",
		eot_health = "<prefab=eyeofterror> <color=HEALTH>Health</color> on return: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>Health</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>Health</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	},

	-- tigersharker.lua
	tigershark_spawnin = "%s后重生",
	tigershark_waiting = "重生准备就绪",
	tigershark_exists = "当前虎鲨出没",

	-- timer.lua
	timer = {
		label = "计时 <color=#8c8c8c>'%s'</color>: %s",
		paused = "暂停",
	},

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

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color>重生于<color=FROZEN>%s后</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>防水</color>: <color=WET>%s%%</color>",

	-- watersource.lua
	watersource = "这是一个水源。",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "增加 <color=WET>%s</color> 土壤湿度",
	},

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>伤害</color>",
		electric = "<color=WET>(电击)</color> <color=HEALTH>伤害</color>",
		poisonous = "<color=NATURE>(毒性)</color> <color=HEALTH>伤害</color>",
		thorns = "<color=HEALTH>(反弹)</color> <color=HEALTH>伤害</color>",
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

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>世界温度</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "你已可以打开<color=#DED15E>稀有礼物</color>。",
		not_ready = "你必须<color=#ffbbbb>等待 %s 天</color>才能再次获得一个<color=#DED15E>稀有礼物</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "状态变化延迟%s",
		wither = "%s后枯萎",
		rejuvenate = "%s后复长",
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>树精守卫几率</color>: <sub>你</sub> %s%% & <sub>NPC</sub> %s%%",
		treeguard_chance = "<color=#636C5C>树精守卫几率</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "切换世界已被禁用。",
		target_shard = "目标世界: %s",
		received_portal = "传送门: %s",
		id = "这是 #: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "世界计时器 <color=#8c8c8c>'%s'</color>: %s",
		paused = "已暂停",
	},

	-- wx78.lua [Prefab]
	wx78_charge = "剩余充能: %s",

	-- yotb_sewer.lua
	yotb_sewer = "缝制将完成于 %s",
}