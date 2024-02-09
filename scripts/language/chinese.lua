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

-- Translated by: https://steamcommunity.com/id/interesting28/ and https://steamcommunity.com/id/cloudyyoung and (Placeholder) https://github.com/penguin0616/Insight/pull/29

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

	-- Keybinds
	unbind = "取消绑定",
	keybinds = {
		label = "快捷键 (仅键盘)",
		togglemenu = {
			name = "打开 Insight 菜单",
			description = "打开/关闭 Insight 菜单"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[危险宣告]: ",
		boss = "[Boss 宣告]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "新手",
				description = "适合刚开始玩这个游戏的玩家"
			},
			simple = {
				label = "简单",
				description = "显示较少数量信息, 与 Show Me 类似",
			},
			decent = {
				label = "中等",
				description = "显示中等数量信息, 与默认设置接近",
			},
			advanced = {
				label = "高级",
				description = "适合喜欢显示各种信息的玩家",
			},
		},
	},

	-- Insight Menu
	insightmenu = {
		tabs = {
			--world = "World",
			--player = "Player",
		},
	},

	indicators = {
		dismiss = "%s 关闭",
	},

	-- Damage helper
	damage_types = {
		-- Normal
		explosive = "爆炸",
		
		-- Planar
		lunar_aligned = "月亮阵营",
		shadow_aligned = "暗影阵营",
	},

	-------------------------------------------------------------------------------------------------------------------------

	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "照明最低<color=SANITY>理智</color>: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
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

	-- armordreadstone.lua
	armordreadstone = {
		regen = "恢复 <color=%s>%.1f</color> <color=#C0C0C0>耐久</color>/%d 秒",
		regen_complete = "恢复 <color=%s>%.1f<sub>最小</sub></color> / <color=%s>%.1f<sub>当前</sub></color> / <color=%s>%.1f<sub>最大</sub></color> <color=#C0C0C0>耐久</color>/%d 秒基于理智值"
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate>会重置于%s后",
	},

	-- attunable.lua
	attunable = {
		linked = "连接到: %s",
		offline_linked = "下线的连接者: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "每次攻击恢复 <color=HEALTH>%s 生命</color>",
		sanity_cost = "每次攻击消耗 <color=SANITY>%s 理智</color>",
	},

	-- beard.lua
	beard = "你的胡须将于 %s 天后长好",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>目标: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger>会生成在%s(<prefab=%s>)周围于%s后",
		bearger_attack = "<prefab=bearger>会在%s后攻击"
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen>会重生于%s后",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "拉力: %.5f",
		max_velocity_mod = "最大速度变化: %.3f",
		force_dampening = "阻力: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- book.lua
	book = {
		wickerbottom = {
			tentacles = "召唤 <color=%s>%d 条触手</color>",
			birds = "召唤至多 <color=%s>%d 只鸟</color>",
			brimstone = "召唤 <color=%s>%d 道闪电</color>",
			horticulture = "催熟至多 <color=%s>%d 株作物</color>",
			horticulture_upgraded = "催熟且照料至多 <color=%s>%d 株作物</color>",
			--silviculture = "Grows basic resource plants.",
			--fish = "",
			--fire = ""
			web = "召唤一个<color=%s>蜘蛛网</color> 持续 <color=%s>%s</color>",
			--temperature = ""
			light = "召唤<color=LIGHT>天光</color> 持续 <color=LIGHT>%s</color>",
			-- light_upgraded is just light
			rain = "切换<color=WET>雨天</color>并且<color=WET>浇灌附近作物</color>",
			bees = "召唤 <color=%s>%d 只蜜蜂</color> 至多 <color=%s>%d</color>",
			research_station = "制作原型解锁: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "召唤 <color=%s>%d 个流星</color>",
		},
	},

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
		last_brushed = " %s 天前刷过"
	},

	-- burnable.lua
	burnable = {
		smolder_time = "即将<color=LIGHT>燃起</color>: <color=LIGHT>%s</color>",
		burn_time = "剩余<color=LIGHT>燃烧时间</color>: <color=LIGHT>%s</color>",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "装饰值: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "稀有",
			uncommon = "不常见",
			common = "常见",
			unknown = "未知",
		},
		shape = "形状: %s",
		rarity = "稀有度: %s",
		season = "季节: %d",
		undecided = "需要放置后决定内容",
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>级别</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "总装饰: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>毒气等级</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "<color=#522E61>中毒</color>的概率: <color=#D8B400>%d%%</color>",
		gas_level_increase = "增加于%s后",
		gas_level_decrease = "减少于%s后"
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "浣猫寿命: %s / %s",
		regenerate = "浣猫将于%s后重生",
		waiting_for_sleep = "等待附近的玩家走开",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "等待你回到罪行地点",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color>会重生于%s后",
	announce_chester_respawn = "我的<prefab=chester>会重生于%s后",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>里</sub> + %s<sub>外</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>里</sub> + %s<sub>外</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "{regen_time}后{to_regen}再生",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>伤害</color>: <color=HEALTH>%s</color>",
		damageToYou = " (对玩家 <color=HEALTH>%s</color>)",
		age_damage = "<color=HEALTH>伤害<color=AGE>(年龄)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (对玩家 <color=AGE>%+d</color>)",
		yotr_pillows = {
			--@@ Weapons
			knockback = "<color=VEGGIE>击退</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "Knockback Multiplier: %s",
			laglength = "<color=VEGGIE>冷却</color>: %s",
			
			--@@ Armor
			defense_amount = "<color=VEGGIE>防守</color>: %s",
			
			--@@ Both
			prize_value = "奖励值: %s",
		},
	},

	-- container.lua
	container = {

	},

	-- cooldown.lua
	cooldown = "冷却: %s",

	-- crabkingspawner.lua
	crabkingspawner = {
		crabking_spawnsin = "%s",
		time_to_respawn = "<prefab=crabking>会重生于%s后",
	},

	-- crittertraits.lua
	dominant_trait = "特质: %s",

	-- crop.lua
	crop_paused = "暂停",
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "音级: %s / %s",
		note = ", 音符: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> 伤害对%s生物",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> 伤害自%s攻击",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>理智</color>: <color=SANITY>%s/分</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER>会重生于 %s 天后",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>加成</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = {
			name = "<color=HEALTH>攻击提升</color>",
			description = "攻击加强 <color=HEALTH>{percent}%</color>, 持续 {duration} 秒",
		},
		["buff_playerabsorption"] = {
			name = "<color=MEAT>伤害减免</color>",
			description = "伤害减少 <color=MEAT>{percent}%</color>, 持续 {duration} 秒",
		},
		["buff_workeffectiveness"] = {
			name = "<color=SWEETENER>工作效率</color>",
			description = "效率提升 <color=#DED15E>{percent}%</color>, 持续 {duration} 秒",
		},

		["buff_moistureimmunity"] = {
			name = "<color=WET>防潮</color>",
			description = "免疫<color=WET>潮湿</color>, 持续 {duration} 秒",
		},
		["buff_electricattack"] = {
			"<color=WET>电击</color>",
			description = "攻击<color=WET>带电</color>, 持续 {duration} 秒",
		},
		["buff_sleepresistance"] = {
			name = "<color=MONSTER>睡眠抵抗</color>",
			description = "抵抗<color=MONSTER>睡眠</color>, 持续 {duration} 秒",
		},

		["tillweedsalve_buff"] = {
			name = "<color=HEALTH>生命回复</color>",
			description = "{duration} 秒内回复 <color=HEALTH>{amount} 生命</color>",
		},
		["healthregenbuff"] = {
			name = "<color=HEALTH>生命回复</color>",
			description = "{duration} 秒内回复 <color=HEALTH>{amount} 生命</color>",
		},
		["sweettea_buff"] = {
			name = "<color=SANITY>理智回复</color>",
			description = "{duration} 秒内回复 <color=SANITY>{amount} 理智</color>",
		},

		["wintersfeastbuff"] = {
			name = "<color=FROZEN>冬季盛宴加成</color>",
			description = "恢复<color=HUNGER>饥饿</color>, <color=SANITY>理智</color>, <color=HEALTH>生命</color>"
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER><prefab=batnosehat>加成</color>",
			description = "{duration} 秒内回复 <color=HUNGER>{amount} 饥饿</color>",
		},
		
		["halloweenpotion_health_buff"] = {
			name = "<color=HEALTH>生命回复</color>",
			description = nil
		},
		["halloweenpotion_sanity_buff"] = {
			name = "<color=SANITY>理智回复</color>",
			description = nil
		},
		["halloweenpotion_bravery_small_buff"] = {
			name = "<color=SANITY>勇敢</color>面对蝙蝠",
			description = nil
		},
		["halloweenpotion_bravery_large_buff"] = (function(parent)
			return deepcopy(parent.halloweenpotion_bravery_small_buff)
		end)
	},

	-- deerclopsspawner.lua
	deerclopsspawner = {
		incoming_deerclops_targeted = "<color=%s>目标: %s</color> -> %s",
		announce_deerclops_target = "<prefab=deerclops>会生成在%s(<prefab=%s>)周围于%s后",
		deerclops_attack = "<prefab=deerclops>会在%s后攻击",
	},

	-- diseaseable.lua
	disease_in = "将于%s后感染疾病",
	disease_spread = "将于%s后传播疾病",
	disease_delay = "疾病被延迟%s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "驯化: %s%%",
		obedience = "顺从: %s%%",
		obedience_extended = "顺从: %s%% (<%s%%<sub>甩鞍</sub>, %s%%<sub>最小</sub>)",
		tendency = "倾向: %s",
		tendencies = {
			["NONE"] = "无",
			[TENDENCY.DEFAULT] = "默认",
			[TENDENCY.ORNERY] = "战斗",
			[TENDENCY.RIDER] = "骑乘",
			[TENDENCY.PUDGY] = "肥胖",
		},
	},

	-- dragonfly_spawner.lua [Prefab]
	dragonfly_spawner = {
		time_to_respawn = "<prefab=dragonfly>会重生于%s后",
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "暂停晾干",
	dry_time = "完成还需: %s",

	-- eater.lua
	eater = {
		eot_loot = "食物回复<color=HUNGER>饥饿值 %s%%</color> + <color=HEALTH>生命值 %s%%</color> 作为耐久度",
		eot_tofeed_restore = "使用<color=MEAT><prefab=%s></color>喂养会回复<color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) 耐久度",
		eot_tofeed_restore_advanced = "使用<color=MEAT><prefab=%s></color>喂养会回复<color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) 耐久度",
		tofeed_restore = "使用<color=MEAT><prefab=%s></color>喂养会回复%s",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> 单位<color=%s>%s</color>",
	edible_interface = "<color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=SANITY>理智</color>: <color=SANITY>%s</color> / <color=HEALTH>生命</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>生命</color>: <color=HEALTH>%s</color> / <color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=SANITY>理智</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "肉度",
		monster = "怪物度",
		fish = "鱼度",
		veggie = "蔬菜度",
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
		antihistamine = "抗组胺剂", -- Only "cutnettle"
	},
	edible_foodeffect = {
		temperature = "温度变化: %s, %s",
		caffeine = "速度: %s, %s",
		surf = "船只速度: %s, %s",
		autodry = "干燥: %s, %s",
		instant_temperature = "温度变化: %s, (瞬间)",
		antihistamine = "花粉症延时: %s 秒",
	},
	foodmemory = "最近食用: %s / %s, 将忘记于%s后",
	wereeater = "已食用<color=MONSTER>怪物肉</color>: %s / %s, 将忘记于%s后",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>移动速度</color>: %s%%",
	hunger_slow = "<color=HUNGER>饥饿速度降低</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>饥饿度降低</color>: <color=HUNGER>%s%%</color>",
	insulated = "保护你免遭雷击",

	-- example.lua
	why = "[为什么我是空的]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>爆炸伤害</color>: %s",
	explosive_range = "<color=LIGHT>爆炸范围</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "将长成<color=NATURE><prefab=%s></color>",
		nutrient_consumption = "消耗养分: [<color=NATURE>%d<sub>催长剂</sub></color>, <color=CAMO>%d<sub>堆肥</sub></color>, <color=INEDIBLE>%d<sub>粪肥</sub></color>]",
		good_seasons = "生长季节: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "压力值: %s",
		display = "压力来源: %s",
		stress_tier = "压力级别: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "无",
			[FARM_PLANT_STRESS.LOW] = "低",
			[FARM_PLANT_STRESS.MODERATE] = "中",
			[FARM_PLANT_STRESS.HIGH] = "高"
		} or {}),
		categories = {
			["nutrients"] = "养分", -- missing nutrients
			["moisture"] = "水分", -- needs water
			["killjoys"] = "杂物", -- weeds nearby
			["family"] = "家庭", -- no similar plants nearby
			["overcrowding"] = "拥挤", -- too crowded
			["season"] = "季节", -- out of season
			["happiness"] = "幸福", -- not tended to
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>水分</color>: <color=WET>%s<sub>格</sub></color>*",
		soil_plant = "<color=WET>水分</color>: <color=WET>%s<sub>格</sub></color> (<color=WET>%s/分<sub>株</sub></color>)*",
		soil_plant_tile = "<color=WET>水分</color>: <color=WET>%s<sub>格</sub></color> (<color=WET>%s<sub>株</sub></color> [<color=#2f96c4>%s<sub>格</sub></color>])<color=WET>/分</color>*",
		soil_plant_tile_net = "<color=WET>水分</color>: <color=WET>%s<sub>格</sub></color> (<color=WET>%s<sub>株</sub></color> [<color=#2f96c4>%s<sub>格</sub></color> + <color=SHALLOWS>%s<sub>世界</sub></color> = <color=#DED15E>%+.1f<sub>网</sub></color>])<color=WET>/分</color>",
	},

	farmsoildrinker_nutrients = {
		soil_only = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>格</sub>*",
		soil_plant = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>格</sub> ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>Δ株</sub>)*",
		--soil_plant_tile = "养分: [%+d<color=NATURE><sub>催</sub></color>, %+d<color=CAMO><sub>堆</sub></color>, %+d<color=INEDIBLE><sub>粪</sub></color>]<sup>格</sup> ([<color=#bee391>%+d<sub>催</sub></color>, <color=#7a9c6e>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>Δ格</sup>)",
		--soil_plant_tile = "养分: [%+d<color=NATURE><sub>催</sub></color>, %+d<color=CAMO><sub>堆</sub></color>, %+d<color=INEDIBLE><sub>粪</sub></color>]<sup>格</sup> ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sup>Δ格</sup>)",
		soil_plant_tile = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>格</sub> ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>Δ株</sub> [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>]<sub>Δ格</sub>)",
		--soil_plant_tile_net = "养分: [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] ([<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] + [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>] = [<color=NATURE>%+d<sub>催</sub></color>, <color=CAMO>%+d<sub>堆</sub></color>, <color=INEDIBLE>%+d<sub>粪</sub></color>])",
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "缩短 <color=NATURE>%s</color> 秒<color=NATURE>生长时间</color>",
		nutrient_value = "养分: [<color=NATURE>%s<sub>催长剂</sub></color>, <color=CAMO>%s<sub>堆肥</sub></color>, <color=INEDIBLE>%s<sub>粪肥</sub></color>]",
		wormwood = {
			formula_growth = "你的<color=LIGHT_PINK>开花</color>加速 <color=LIGHT_PINK>%s</color>",
			compost_heal = "<color=HEALTH>回复</color> <color=HEALTH>{healing}</color> 生命持续 <color=HEALTH>{duration}</color> 秒",
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
		ROW_FAIL = "划(失败)",
		--ATTACK = "<string=ACTIONS.ATTACK.GENERIC>",
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>",
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>鱼</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = "%s后增加一条鱼",
	fish_wait_time = "钓到一条鱼需要 <color=SHALLOWS>%s 秒</color>",

	-- fishingrod.lua
	fishingrod_waittimes = "等待时间: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "最大缠绕时间: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "主人: %s", -- "主人" should mean "master" here by free translation, "领导者" is literal translation and not precise?
	loyalty_duration = "忠诚持续时间: %s",

	-- forcecompostable.lua
	forcecompostable = "堆肥值: %s",

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
			BURNABLE = "燃料",
			CAVE = "照明", -- miner hat / lanterns, light bulbs n stuff
			CHEMICAL = "燃料",
			CORK = "燃料",
			GASOLINE = "汽油", -- DS: not actually used anywhere?
			MAGIC = "耐久度", -- amulets that aren't refuelable (ex. chilled amulet)
			MECHANICAL = "耐久度", -- SW: iron wind
			MOLEHAT = "夜视效果", -- Moggles
			NIGHTMARE = "噩梦燃料",
			NONE = "时间", -- will never be refueled...............................
			ONEMANBAND = "耐久度",
			PIGTORCH = "燃料",
			SPIDERHAT = "耐久度", -- Spider Hat
			TAR = "焦油", -- SW
			USAGE = "耐久度",
		},
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>燃料</color>持续时间 (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color>持续时间 (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>燃烧效率</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>燃料</color>: <color=LIGHT>%s</color>",
		held_refuel = "使用<color=SWEETENER><prefab=%s></color>将补充燃料 <color=LIGHT>%s%%</color>",
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>等级</color>: %s / %s",
		flower = "你的<color=%s>等级</color>: %s / %s",
		levelup = " %s后升级",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "回复 <color=HEALTH>%s 生命</color>在 %s 内 (<color=HEALTH>+%s</color> / <color=HEALTH>%s 秒</color>)",
		ghostlyelixir_fastregen = "回复 <color=HEALTH>%s 生命</color>在 %s 内 (<color=HEALTH>+%s</color> / <color=HEALTH>%s 秒</color>)",
		ghostlyelixir_attack = "最大化<color=HEALTH>伤害</color>持续%s",
		ghostlyelixir_speed = "增加<color=DAIRY>移速</color><color=DAIRY>%s%%</color>持续 %s",
		ghostlyelixir_shield = "增加护盾持续时间到1秒持续%s",
		ghostlyelixir_retaliation = "护盾反射 <color=HEALTH>%s 伤害</color>持续%s", -- concatenated with shield},
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "<color=#737CD0><prefab=%s></color>持续时间: %s",
	},

	-- growable.lua
	growable = {
		stage = "<color=#8c8c8c>'%s'</color> 阶段: %s / %s, ",
		paused = "暂停生长",
		next_stage = "%s后进入下一阶段",
	},

	-- grower.lua
	harvests = "<color=NATURE>剩余采集次数</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 于%s后",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "不适感: %s / %s",
		progress = "孵化过程: %s / %s",
	},

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>生命</color>: <color=HEALTH>%+d</color>",
		webber_heal = "韦伯<color=HEALTH>生命值</color>: <color=HEALTH>%+d</color>",
		spider_heal = "蜘蛛<color=HEALTH>生命值</color>: <color=HEALTH>%+d</color>",
	},

	-- health.lua
	health = "<color=HEALTH>生命</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%s 秒</color>)",
	absorption = " : 吸收 %s%% 伤害",
	naughtiness = "淘气值: %s",
	player_naughtiness = "你的淘气值: %s / %s",

	-- heatrock.lua [Prefab]
	heatrock_temperature = "温度: %s < %s < %s",

	-- herdmember.lua
	herd_size = "群体大小: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "躲藏范围: %s 到 %s",
		needed_hiding_spots = "需要的躲藏地点: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "<prefab=hound>会在%s后攻击",
		time_until_worms = "<prefab=worm>会在%s后攻击",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>饥饿</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>饥饿速度</color>: <color=HUNGER>%+d/天</color> (<color=HUNGER>%s/秒</color>)",
	hunger_paused = "<color=HUNGER>饥饿值</color>暂停",

	-- hunter.lua
	hunter = {
		hunt_progress = "脚印: %s / %s",
		impending_ambush = "下一个脚印为猎物",
		alternate_beast_chance = "<color=#b51212>%s%% 几率</color>是一只<color=MOB_SPAWN>座狼</color>或<color=MOB_SPAWN>钢羊</color>",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color>会重生于%s后",
	announce_hutch_respawn = "我的<prefab=hutch>会重生于%s后",
	
	-- inspectable.lua
	wagstaff_tool = "这个工具的名字是: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "健身房重量数值: %s",
	ruins_statue_gem = "包含一个<color=%s><prefab=%s></color>",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>保暖效果</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>隔热效果</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		hat_describe = "[帽子]: ",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "小浣猫数量: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>重要战利品</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "消失于第 %s 天",
		announce_despawn = "<prefab=klaus_sack>将消失于第 %s 天",
		announce_spawn = "<prefab=klaus_sack>会生成于%s后",
	},

	-- leader.lua
	followers = "随从数量: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "闪电保护范围: %s 墙体单位",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "充能将消失于%s后",

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>可用</sub> / %d<sub>总共</sub> / %d<sub>最大</sub>", -- I can't think of a way to word 
		next_crystal = "下一波<color=#4093B2><prefab=lunarrift_crystal_big></color>生成于%s后",
		close = "<prefab=LUNARRIFT_PORTAL>大约会关闭于%s后",
	},
	
	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "已寄生 %d 株",
		spawn = "%s 后开始寄生",
		next_wave = "%s 后开始下一波",
		remain_waves = "剩余 %d 波",
	},

	-- lunarthrall_plant.lua [Prefab]
	lunarthrall_plant = {
		time_to_aggro = "Vulnerability ends in: <color=%s>%1.f</color>",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "%s后开始活动",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "%s后完成",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "等待某人前往鱼群",
		time_to_respawn = "<prefab=malbatross>会重生于%s后",
	},

	-- mast.lua
	mast_sail_force = "帆力: %s",
	mast_max_velocity = "最大速度: %s",

	-- mermcandidate.lua
	mermcandidate = "卡路里: %s / %s",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>力量值</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>力量值</color>每次使用: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "健身房重量: %s",
		mighty_gains = "普通<color=MIGHTINESS>举起</color>: <color=MIGHTINESS>%+.1f</color>, 完美<color=MIGHTINESS>举起</color>: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>饥饿值消耗</color>: <color=HUNGER>x%d</color>",
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

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "收帆起锚速度: {feature_speed}\n船桨耐久消耗: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "船只损坏减少: {reduction}",
	-- mood.lua
	mood = {
		exit = "发情结束于 %s 天后",
		enter = "开始发情于 %s 天后",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "目的地进度: %s / %s",
			time_for_next_tool = "%s后需要另一个工具",
			experiment_time = "%s后实验完成",
		},
		storm_move = "%s%% 几率于第 %d 天月球风暴",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>阶段: %s</color>, %s", -- "阶段 Stage" by free translation, same term used in dst wiki
		phase_locked = "被<color=#CE3D45>远古钥匙</color>锁住",
		announce_phase_locked = "遗迹现在锁定在暴动期",
		announce_phase = "遗迹现在在%s期 (还剩%s)",
		phases = {
			["calm"] = "平静",
			["warn"] = "警告",
			["wild"] = "暴动",
			["dawn"] = "黎明"
		},
	},

	-- oar.lua
	oar_force = "<color=INEDIBLE>力度</color>: <color=INEDIBLE>%s%%</color>",

	-- oceanfishingrod.lua
	oceanfishingrod = {
		hook = {
			interest = "吸引力: %.2f",
			num_interested = "被吸引的鱼: %s",
		},
		battle = {
			tension = "收紧: <color=%s>%.1f</color> / %.1f<sub>断线</sub>",
			slack = "放松: <color=%s>%.1f</color> / %.1f<sub>逃离</sub>",
			distance = "距离: %.1f<sub>捕获</sub> / <color=%s>%.1f<sub>当前</sub></color> / %.1f<sub>逃脱</sub>",
		},
	},
	
	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "额外抛竿距离: %s",
			bonus_accuracy = "额外抛竿准度: <color=#66CC00>%+.1f%%<sub>min</sub></color> / <color=#5B63D2>%+.1f%%<sub>max</sub></color>",
		},
		lure = {
			charm = "吸引力: <color=#66CC00>%.1f<sub>基础</sub></color> + <color=#5B63D2>%.1f<sub>收线</sub></color>",
			stamina_drain = "额外精力消耗: %.1f",
			time_of_day_modifier = "时段效益: <color=DAY_BRIGHT>%d%%<sub>白天</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>黄昏</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>夜晚</sub></color>",
			weather_modifier = "天气效益: <color=#bbbbbb>%d%%<sub>晴天</sub></color> / <color=#7BA3F2>%d%%<sub>下雨</sub></color> / <color=FROZEN>%d%%<sub>下雪</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "疙瘩树生长进度: %s / %s",
	
	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>年龄</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "<color=#E3D740>金块</color>等级: %.1f / %.1f",
		gold_level = "<color=#E3D740>金块</color>等级: %.1f",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "腐烂",
		stale = "陈腐",
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
	pickable = {
		regrowth = "<color=NATURE>%s</color>后<color=NATURE>重新生长</color>",
		regrowth_paused = "生长暂停",
		cycles = "剩余收获次数: %s / %s",
		mushroom_rain = "需要的<color=WET>雨</color>: %s",
	},

	-- planardamage.lua
	planardamage = {
		planar_damage = "<color=PLANAR>位面伤害</color>: <color=PLANAR>%s</color>",
		additional_damage = " (<color=PLANAR>+%s<sub>额外</sub></color>)",
	},

	-- planardefense.lua
	planardefense = {
		planar_defense = "<color=PLANAR>位面防御</color>: <color=PLANAR>%s</color>",
		additional_defense = " (<color=PLANAR>+%s<sub>额外</sub></color>)",
	},

	-- poisonable.lua
	poisonable = {
		remaining_time = "<color=NATURE>毒</color>解除于%s后",
	},

	-- pollinator.lua
	pollination = "花朵授粉: (%s) / %s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "我的<prefab=polly_rogers>会重生于%s后"
	},

	-- preservative.lua
	preservative = "恢复 %s%% 新鲜度",

	-- quaker.lua
	quaker = {
		next_quake = "%s后<color=INEDIBLE>地震</color>",
	}, -- same thing as perishable transition

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "剩余玩具数: %s",
			assisted_by = "这个小惊吓正在受到 %s 的帮助",
		},
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>世界潮湿度</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>降水率</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>青蛙雨几率</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "世界编号: %s",
		shard_type = "世界类型: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "%s后充能",
		charge = "充能: %s / %s"
	},

	-- repairer.lua
	repairer = {
		type = "修复工具: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>生命恢复</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>净血量</sub></color> + <color=HEALTH>%s%%<sub>百分比血量</sub></color>",
		work = "<color=#DED15E>做工修复</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>做工</sub></color>",
		perish = "<color=MONSTER>提鲜</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>提鲜</color>: <color=MONSTER>%s%%</color>",
		held_repair = "使用<color=SWEETENER><prefab=%s></color>将修复 <color=LIGHT>%s</color> 耐久 (<color=LIGHT>%s%%</color>)",
		materials = (IS_DST and {
			[MATERIALS.WOOD] = "木头",
			[MATERIALS.STONE] = "石头",
			[MATERIALS.HAY] = "干草",
			[MATERIALS.THULECITE] = "图勒信物",
			[MATERIALS.GEM] = "宝石",
			[MATERIALS.GEARS] = "齿轮",
			[MATERIALS.MOONROCK] = "月岩",
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

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL>生成于%s后",
		announce_spawn = "一个<prefab=LUNARRIFT_PORTAL>将生成于%s后",

		stage = "阶段: %d / %d", -- augmented by growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "无法生成",
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>额外伤害</color>: <color=HEALTH>%s</color>",
		bonus_speed = "<color=DAIRY>额外速度</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>理智</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>启蒙</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		interaction = "<color=SANITY>理智</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = "<color=SANITY>理智光环</color>: <color=SANITY>%s/分</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "这个已经打开过了",
		chest_labyrinth = {
			sanity = "66% 几率让<color=SANITY>理智</color>从 <color=SANITY>-20</color> 上升到 <color=SANITY>20</color>",
			hunger = "66% 几率让<color=HUNGER>饥饿</color>从 <color=HUNGER>-20</color> 上升到 <color=HUNGER>20</color>",
			health = "66% 几率让<color=HEALTH>生命</color>从 <color=HEALTH>0</color> 上升到 <color=HEALTH>20</color>",
			inventory = "66% 几率增加 20% <color=LIGHT>耐久</color>或<color=MONSTER>新鲜</color>",
			summonmonsters = "66% 几率召唤 1-3 个<color=MOB_SPAWN>穴居悬蛛</color>",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>暗影等级</color>: %s",
		level_diff = "<color=BLACK>暗影等级</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s 伤害</color>)",
		total_shadow_level = "<color=BLACK>总暗影等级</color>: %s",
	},

	-- shadowrift_portal.lua [Prefab]
	shadowrift_portal = {
		close = "<prefab=SHADOWRIFT_PORTAL>将关闭于%s后",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "生成于%s",
			sanity_reward = "<color=SANITY>理智</color>奖励: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>理智</color>奖励: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "下一裂隙可控制于%s后",
		waiting_for_players = "等待一个玩家接近",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color>会再生于%s后",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		trades_remaining = "交易剩余: %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "遮蔽范围: %s 墙体单位",
		shelter = "遮蔽处",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>武器</color>持续时间增加 <color=#aaaaee>%s%%</color>",
			battlesong_healthgain = "攻击敌人回复 <color=HEALTH>%s 生命</color> (薇格弗德为 <color=HEALTH>%s</color>)",
			battlesong_sanitygain = "攻击敌人回复 <color=SANITY>%s 理智</color>",
			battlesong_sanityaura = "<color=SANITY>负理智光环</color>效果减少 <color=SANITY>%s%%</color>",
			battlesong_fireresistance = "受到的<color=LIGHT>火焰</color>伤害<color=HEALTH>减少 %s%%</color>", -- need optimization
			battlesong_instant_taunt = "嘲讽所有战歌范围内的敌人",
			battlesong_instant_panic = "使周围的敌人陷入恐慌 %s 秒",
		},
		cost = "消耗 %s 灵感值来使用",
	},

	-- sinkholespawner.lua
	antlion_rage = "蚁狮会发怒于%s后",

	-- skinner_beefalo.lua
	skinner_beefalo = "凶猛: %s, 喜庆: %s, 正式: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "%s后醒来",
	},

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>治疗</color> <color=HEALTH>%s</color> - <color=HEALTH>%s</color>",
	wortox_soul_heal_range = "<color=HEALTH>治疗</color> <color=#DED15E>%s 个格子</color>内的玩家",

	-- spawner.lua
	spawner = {
		next = "{respawn_time}后生成<color=MOB_SPAWN><prefab={child_name}></color>",
		child = "生成一个<color=MOB_SPAWN><prefab=%s></color>",
		occupied = "Occupied: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>治疗</color>韦伯<color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>治疗</color>蜘蛛<color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "剩余<color=#aaaaee>敲击</color>: <color=#aaaaee>%s</color>",
		time_to_reset = "%s后重置",
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)将在 %s 秒后完成",
		cooker = "由<color=%s>%s</color>烹饪",
		cooktime_modifier_slower = "烹调食物减慢 <color=#DED15E>%s%%</color>",
		cooktime_modifier_faster = "烹调食物加快 <color=NATURE>%s%%</color>",
	},

	-- stickable.lua
	stickable = "<color=FISH>贻贝</color>: %s",

	-- temperature.lua
	temperature = "温度: <temperature=%s>",

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "每个非战斗天恢复 <color=HEALTH>%s</color> 血量",
		eot_health = "<prefab=eyeofterror>在回归时的<color=HEALTH>血量</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>血量</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>血量</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium>会就绪于%s后",
	},

	-- tigersharker.lua
	tigershark_spawnin = "%s后重生",
	tigershark_waiting = "重生准备就绪",
	tigershark_exists = "当前虎鲨出没",

	-- timer.lua
	timer = {
		label = "计时<color=#8c8c8c>'%s'</color>: %s",
		paused = "暂停",
	},

	-- toadstoolspawner.lua
	toadstoolspawner = {
		time_to_respawn = "<prefab=toadstool>会重生于%s后",
	},

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>效率</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "价值 %s 个金块",
	tradable_gold_dubloons = "价值 %s 个金块和 %s 个金币",
	tradable_rocktribute = "延迟<color=LIGHT>蚁狮</color>发怒 %s 天", -- needs to get updated to english equivelant

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "阶段: %s / %s: ",
	upgradeable_complete = "升级完成 %s%%",
	upgradeable_incomplete = "不可升级",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "增加<color=HEALTH>最大生命值</color> <color=HEALTH>%d</color>",
			maxsanity = "增加<color=SANITY>最大理智值</color> <color=SANITY>%d</color>",
			movespeed = "增加<color=DAIRY>移速</color> %s",
			heat = "提高<color=#cc0000>最低体温</color> <color=#cc0000>%d</color>",
			heat_drying = "增加<color=#cc000>干燥速率</color> <color=#cc0000>%.1f</color>",
			cold = "降低<color=#00C6FF>最高体温</color> <color=#00C6FF>%d</color>",
			taser = "给攻击者造成 <color=WET>%d</color>%s (冷却时间: %.1f)",
			light = "提供<color=LIGHT>照明半径</color> <color=LIGHT>%.1f</color> (额外的只加 <color=LIGHT>%.1f</color>)",
			maxhunger = "增加<color=HUNGER>最大饥饿值</color> <color=HUNGER>%d</color>",
			music = "提供<color=SANITY>理智光环</color> <color=SANITY>%+.1f/分</color> 在 <color=SANITY>%.1f</color> 个地皮范围内",
			music_tend = "照料植物在 <color=NATURE>%.1f</color> 个地皮范围内",
			bee = "回复 <color=HEALTH>%d 生命/%d 秒</color> (<color=HEALTH>%d/天</color>)",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color>重生于<color=FROZEN>%s</color>后",

	-- waterproofer.lua
	waterproofness = "<color=WET>防水</color>: <color=WET>%s%%</color>",

	-- watersource.lua
	watersource = "这是一个水源",

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

	-- weather.lua
	weather = {
		progress_to_rain = "降雨进度: %s / %s",
		remaining_rain = "降雨持续: %s",
	},

	-- weighable.lua
	weighable = {
		weight = "重量: %s (%s%%)",
		weight_bounded = "重量: %s <= %s (%s) <= %s",
		owner_name = "主人: %s",
	},

	-- werebeast.lua
	werebeast = "变身值: %s / %s",

	-- wereness.lua
	wereness_remaining = "变身值: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "这是一个夹夹绞盘组件, 但是预设检查失败",
		sunken_item = "夹夹绞盘底下有一个<color=#66ee66>%s</color>",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>世界温度</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "你已可以打开<color=#DED15E>稀有礼物</color>",
		not_ready = "你必须<color=#ffbbbb>等待 %s 天</color>才能再次获得一个<color=#DED15E>稀有礼物</color>",
	},

	-- witherable.lua
	witherable = {
		delay = "状态变化延迟%s",
		wither = "%s后枯萎",
		rejuvenate = "%s后复长",
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>树精守卫几率</color>: <sub>玩家</sub> %s%% & <sub>NPC</sub> %s%%",
		treeguard_chance = "<color=#636C5C>树精守卫几率</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "切换世界已被禁用",
		target_shard = "目标世界: %s",
		received_portal = "传送门: %s",
		id = "这是 #: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "世界计时器<color=#8c8c8c>'%s'</color>: %s",
		paused = "已暂停",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "剩余充能: %s",
		gain_charge_time = "充能: %d / %d, 将会获得一<color=LIGHT>电荷</color>于<color=LIGHT>%s</color>",
		full_charge = "电量已充满!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "扫描进度: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "缝制将完成于%s",
}