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

-- Translated by: https://steamcommunity.com/id/lehasex/

return {
	-- insightservercrash.lua
	server_crash = "Этот сервер упал.",
	
	-- modmain.lua
	dragonfly_ready = "Готов к бою.",

	-- time.lua
	time_segments = "%s сегмент(ов)",
	time_days = "%s день(дней), ",
	time_days_short = "%s день(дней)",
	time_seconds = "%s день(дней)",
	time_minutes = "%s минут(а), ",
	time_hours = "%s час(ов), ",

	-- meh
	seasons = {
		autumn = "<color=#CE5039>Осень</color>",
		winter = "<color=#95C2F4>Зима</color>",
		spring = "<color=#7FC954>Весна</color>",
		summer = "<color=#FFCF8C>Лето</color>",
	},

	-- Keybinds
	unbind = "Разбиндить",
	keybinds = {
		label = "Горячие клавиши (Только Клавиатура)",
		togglemenu = {
			name = "Открыть Insight Menu",
			description = "Открывает/Закрывает Insight Menu"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[Объявление Об Опасности]: ",
		boss = "[Объявление О Боссе]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "Новый Игрок",
				description = "Рекомендуется для новичков."
			},
			simple = {
				label = "Простой",
				description = "Небольшое количество информации, похоже на Show Me.",
			},
			decent = {
				label = "Средний",
				description = "Среднее количество информации. Очень похоже на настройки по умолчанию.",
			},
			advanced = {
				label = "Продвинутый",
				description = "Для тех, кто любит информацию.",
			},
		},
	},

	-- Insight Menu
	insightmenu = {
		tabs = {
			world = "Мир",
			player = "Игрок",
		},
	},

	indicators = {
		dismiss = "%s Отменить",
	},

	-- Damage helper
	damage_types = {
		-- Normal
		explosive = "Взрывной",
		
		-- Planar
		lunar_aligned = "Сочетание с Луной",
		shadow_aligned = "Сочетание с Тенью",
	},

	-------------------------------------------------------------------------------------------------------------------------
	
	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "Минимум <color=SANITY>рассудка</color> для света: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_sanity = "Ваш <color=SANITY>рассудок</color>: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "Призванные <color=ENLIGHTENMENT>гештальты</color> наносят <color=HEALTH>%s</color> урона.",
	},

	-- aoeweapon_base.lua
	aoeweapon_base = {
		--weapon_damage = "AoE %s: <color=HEALTH>{damage}</color>",
	},

	-- aoeweapon_leap.lua
	aoeweapon_leap = {

	},

	-- aoeweapon_lunge.lua
	aoeweapon_lunge = {
		lunge_damage = "Удар {damageType}: <color=HEALTH>{damage}</color>",
	},
	

	-- appeasement.lua
	appease_good = "Отсрочка извержения на %s сегмент(ов).",
	appease_bad = "Ускоряет извержение на %s сегмент(ов).",

	-- appraisable.lua
	appraisable = "Грозный: %s, Праздничный: %s, Официальный: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "Открывает: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>Защита</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>Прочность</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>Прочность</color>: <color=#C0C0C0>%s</color>",

	-- armordreadstone.lua
	armordreadstone = {
		regen = "Восстанавливает <color=%s>%.1f</color> <color=#C0C0C0>прочности</color>/%ds",
		regen_complete = "Восстанавливает <color=%s>%.1f<sub>мин</sub></color> / <color=%s>%.1f<sub>тек</sub></color> / <color=%s>%.1f<sub>макс</sub></color> <color=#C0C0C0>прочности</color>/%ds в зависимости от безумия"
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate> сбросится через %s.",
	},

	-- attunable.lua
	attunable = {
		linked = "Связано с: %s",
		offline_linked = "Оффлайн связи: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "Восстанавливает <color=HEALTH>%s здоровья</color> за удар.",
		sanity_cost = "Тратит <color=SANITY>%s рассудка</color> за удар.",
	},

	-- beard.lua
	beard = "Борода улучшится через %s день(дней).",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>Цель: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger> появится на %s (<prefab=%s>) через %s.",
		bearger_attack = "<prefab=bearger> атакует через %s."
	},

	-- beef_bell.lua [Prefab]
	beef_bell = {
		beefalo_name = "Name: %s",
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen> возродится через %s.",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "Сопротивление: %.5f",
		max_velocity_mod = "Максимальная скорость: %.3f",
		force_dampening = "Сила торможения: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- book.lua
	book = {
		wickerbottom = {
			tentacles = "Призывает <color=%s>%d щупалец</color>",
			birds = "Призывает до <color=%s>%d птиц</color>",
			brimstone = "Призывает <color=%s>%d молний</color>",
			horticulture = "Выращивает до <color=%s>%d растений</color>",
			horticulture_upgraded = "Выращивает и ухаживает за до <color=%s>%d растениями</color>",
			--silviculture = "Выращивает основные ресурсные растения.",
			--fish = "",
			--fire = ""
			web = "Призывает <color=%s>паутину</color>, которая держится <color=%s>%s</color>",
			--temperature = ""
			light = "Призывает <color=LIGHT>свет</color> на <color=LIGHT>%s</color>",
			-- light_upgraded is just light
			rain = "Переключает <color=WET>дождь</color> и <color=WET>поливает рядом находящиеся растения</color>",
			bees = "Призывает <color=%s>%d пчел</color> до <color=%s>%d</color>",
			research_station = "Прототипы зарядов: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "Призывает <color=%s>%d метеоров</color>",
		},
	},

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>Тропическая рыба</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>Фиолетовый группер</color>",
	breeder_fish4 = "<color=#DED15E>Рыба-пьеро</color>",
	breeder_fish5 = "<color=#9ADFDE>Налобная рыба</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "Следующий %s через <color=FISH>%s</color>",

	-- brushable.lua
	brushable = {
		last_brushed = "В последний раз чесали %s назад.",
		next_brush = "Можно чесать через %s.",
	},

	-- burnable.lua
	burnable = {
		smolder_time = "Тлеет через: %s",
		burn_time = "Горит еще: %s",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "Оценка декора: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "Редкий",
			uncommon = "Необычный",
			common = "Обычный",
			unknown = "Неизвестный",
		},
		shape = "Форма: %s",
		rarity = "Редкость: %s",
		season = "Сезон: %d",
		undecided = "Необходимо разместить до определения содержимого."
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>Ранг</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "Общий декор: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>Уровень газа</color>: %s / %s", -- сантариум, макс. насыщение сантариума
		poison_chance = "Шанс отравления: <color=#522E61>%d%%</color>",
		gas_level_increase = "Увеличивается на %s.",
		gas_level_decrease = "Уменьшается на %s."
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "Жизни кота: %s / %s",
		regenerate = "Коты восстанавливаются через: %s",
		waiting_for_sleep = "Ожидание удаления ближайших игроков.",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "Ожидание вашего возвращения на место преступления.",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> воскреснет через: %s",
	announce_chester_respawn = "Мой <prefab=chester> воскреснет через %s.",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>вход</sub> + %s<sub>выход</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>вход</sub> + %s<sub>выход</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "Восстановление {to_regen} через {regen_time}",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>Урон</color>: <color=HEALTH>%s</color>",
		damageToYou = " (<color=HEALTH>%s</color> вам)",
		age_damage = "<color=HEALTH>Урон <color=AGE>(возраст)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> вам)",
		yotr_pillows = {
			--@@ Оружие
			knockback = "<color=VEGGIE>Отбрасывание</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "Множитель отбрасывания: %s",
			laglength = "<color=VEGGIE>Перезарядка</color>: %s",
			
			--@@ Броня
			defense_amount = "<color=VEGGIE>Защита</color>: %s",
			
			--@@ Оба
			prize_value = "Ценность приза: %s",
		},
	},

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "Перезарядка: %s",

	-- crabkingspawner.lua
	crabkingspawner = {
		crabking_spawnsin = "%s",
		time_to_respawn = "<prefab=crabking> возродится через %s.",
	},

	-- crittertraits.lua
	dominant_trait = "Доминирующий признак: %s",

	-- crop.lua
	crop_paused = "Приостановлено.",
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "Шаг: %s / %s",
		note = ", заметка: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> урон по %s существам",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> урон от %s атак",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>Разум</color>: <color=SANITY>%s/мин</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER> возродится через %s день(дней)",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>Положительный эффект</color>: %s, %s",
	debuffs = { -- ужас
		["buff_attack"] = {
			name = "<color=HEALTH>Усиление атаки</color>",
			description = "Усиливает атаки на <color=HEALTH>{percent}%</color> на {duration}(с).",
		},
		["buff_playerabsorption"] = {
			name = "<color=MEAT>Поглощение урона</color>",
			description = "Поглощает <color=MEAT>{percent}%</color> меньше урона в течение {duration}(с).",
		},
		["buff_workeffectiveness"] = {
			name = "<color=SWEETENER>Эффективность работы</color>",
			description = "Ваша работа становится на <color=#DED15E>{percent}%</color> эффективнее на {duration}(с).",
		},
		
		["buff_moistureimmunity"] = {
			name = "<color=WET>Иммунитет к влаге</color>",
			description = "Вы иммунны к <color=WET>влажности</color> на {duration}(с).",
		},
		["buff_electricattack"] = {
			name = "<color=WET>Электрические атаки</color>",
			description = "Ваши атаки становятся <color=WET>электрическими</color> на {duration}(с).",
		},
		["buff_sleepresistance"] = {
			name = "<color=MONSTER>Сопротивление сну</color>",
			description = "Вы сопротивляетесь <color=MONSTER>сну</color> на {duration}(с).",
		},
		
		["tillweedsalve_buff"] = {
			name = "<color=HEALTH>Регенерация здоровья</color>",
			description = "Восстанавливает <color=HEALTH>{amount} здоровья</color> за {duration}(с).",
		},
		["healthregenbuff"] = {
			name = "<color=HEALTH>Регенерация здоровья</color>",
			description = "Восстанавливает <color=HEALTH>{amount} здоровья</color> за {duration}(с).",
		},
		["sweettea_buff"] = {
			name = "<color=SANITY>Регенерация рассудка</color>",
			description = "Восстанавливает <color=SANITY>{amount} рассудка</color> за {duration}(с).",
		},

		["wintersfeastbuff"] = {
			name = "<color=FROZEN>Бонус Зимнего Праздника</color>",
			description = "Восстанавливает <color=HUNGER>Голод</color>, <color=SANITY>Рассудок</color> и <color=HEALTH>Здоровье</color>."
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER><prefab=batnosehat> Бонус</color>",
			description = "Восстанавливает <color=HUNGER>{amount} голода</color> за {duration}(с).",
		},
		
		["halloweenpotion_health_buff"] = {
			name = "<color=HEALTH>Регенерация здоровья</color>",
			description = nil
		},
		["halloweenpotion_sanity_buff"] = {
			name = "<color=SANITY>Регенерация рассудка</color>",
			description = nil
		},
		["halloweenpotion_bravery_small_buff"] = {
			name = "<color=SANITY>Отвага</color> против летучих мышей.",
			description = nil
		},
		["halloweenpotion_bravery_large_buff"] = (function(parent)
			return deepcopy(parent.halloweenpotion_bravery_small_buff)
		end)
	},

	-- deerclopsspawner.lua
	deerclopsspawner = {
		incoming_deerclops_targeted = "<color=%s>Цель: %s</color> -> %s",
		announce_deerclops_target = "<prefab=deerclops> появится на %s (<prefab=%s>) через %s.",
		deerclops_attack = "<prefab=deerclops> атакует через %s.",
	},

	-- diseaseable.lua
	disease_in = "Заболеет через: %s",
	disease_spread = "Распространит болезнь через: %s",
	disease_delay = "Болезнь отложена на: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "Одомашнивание: %s%%",
		obedience = "Послушание: %s%%",
		--obedience_extended = "Послушание: %s%% (%s%%<sub>к седлу</sub>, <%s%%<sub>против седла</sub>, %s%%<sub>катиться</sub>)",
		obedience_extended = "Послушание: %s%% (<%s%%<sub>против седла</sub>, %s%%<sub>минимум</sub>)",
		tendency = "Тенденция: %s",
		tendencies = {
			["NONE"] = "Нет",
			[TENDENCY.DEFAULT] = "Обычный",
			[TENDENCY.ORNERY] = "Боевой",
			[TENDENCY.RIDER] = "Быстрый",
			[TENDENCY.PUDGY] = "Пухлый"
		},
	},

	-- dragonfly_spawner.lua [Prefab]
	dragonfly_spawner = {
		time_to_respawn = "<prefab=dragonfly> возродится через %s.",
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "Сушка приостановлена.",
	dry_time = "Оставшееся время: %s",

	-- eater.lua
	eater = {
		eot_loot = "Еда восстанавливает <color=HUNGER>голод на %s%%</color> + <color=HEALTH>здоровье на %s%%</color> как прочность.",
		eot_tofeed_restore = "Покормив удерживаемого <color=MEAT><prefab=%s></color>, вы восстановите <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) прочности.",
		eot_tofeed_restore_advanced = "Покормив удерживаемого <color=MEAT><prefab=%s></color>, вы восстановите <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) прочности.",
		tofeed_restore = "Покормив удерживаемого <color=MEAT><prefab=%s></color>, вы восстановите %s.",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> единиц(а) <color=%s>%s</color>", 
	edible_interface = "<color=HUNGER>Голод</color>: <color=HUNGER>%s</color> / <color=SANITY>Рассудок</color>: <color=SANITY>%s</color> / <color=HEALTH>Здоровье</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>Здоровье</color>: <color=HEALTH>%s</color> / <color=HUNGER>Голод</color>: <color=HUNGER>%s</color> / <color=SANITY>Рассудок</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "мясо",
		monster = "монстр",
		fish = "рыба",
		veggie = "овощ",
		fruit = "фрукт",
		egg = "яйцо",
		sweetener = "подсластитель",
		frozen = "замороженное",
		fat = "жир",
		dairy = "молочное",
		decoration = "украшение",
		magic = "магия",
		precook = "предварительная обработка",
		dried = "сушеный",
		inedible = "не съедобное",
		bug = "жук",
		seed = "семя",
		antihistamine = "противоаллергенное", -- Только "cutnettle"
	},
	edible_foodeffect = {
		temperature = "Температура: %s, %s",
		caffeine = "Скорость: %s, %s",
		surf = "Скорость корабля: %s, %s",
		autodry = "Бонус сушки: %s, %s",
		instant_temperature = "Температура: %s, (Мгновенно)",
		antihistamine = "Задержка сенной лихорадки: %ss",
	},
	foodmemory = "Недавно съедено: %s / %s, забудется через: %s",
	wereeater = "<color=MONSTER>Мясо монстра</color> съедено: %s / %s, забудется через: %s",

	-- equippable.lua
	-- использование 'dapperness' из 'dapperness'
	speed = "<color=DAIRY>Скорость</color>: %s%%",
	hunger_slow = "<color=HUNGER>Замедление голода</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>Потребление голода</color>: <color=HUNGER>%s%%</color>",
	insulated = "Защищает вас от молний.",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>Урон от взрыва</color>: %s",
	explosive_range = "<color=LIGHT>Диапазон взрыва</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "Превратится в <color=NATURE><prefab=%s></color>.",
		nutrient_consumption = "ΔПитательные вещества: [<color=NATURE>%d<sub>Формула</sub></color>, <color=CAMO>%d<sub>Компост</sub></color>, <color=INEDIBLE>%d<sub>Навоз</sub></color>]",
		good_seasons = "Сезоны: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "Очки стресса: %s",
		display = "Стрессоры: %s",
		stress_tier = "Уровень стресса: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "Отсутствует",
			[FARM_PLANT_STRESS.LOW] = "Низкий",
			[FARM_PLANT_STRESS.MODERATE] = "Умеренный",
			[FARM_PLANT_STRESS.HIGH] = "Высокий",
		} or {}),
		categories = {
			["nutrients"] = "Питательные вещества", -- отсутствие питательных веществ
			["moisture"] = "Влажность", -- нуждается в поливе
			["killjoys"] = "Сорняки", -- сорняки поблизости
			["family"] = "Семья", -- нет похожих растений поблизости
			["overcrowding"] = "Перенаселенность", -- слишком много насаждений
			["season"] = "Сезон", -- несезонные условия
			["happiness"] = "Уход", -- не ухаживается
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>Вода</color>: <color=WET>%s<sub>плитка</sub></color>*",
		soil_plant = "<color=WET>Вода</color>: <color=WET>%s<sub>плитка</sub></color> (<color=WET>%s/мин<sub>растение</sub></color>)*",
		soil_plant_tile = "<color=WET>Вода</color>: <color=WET>%s<sub>плитка</sub></color> (<color=WET>%s<sub>растение</sub></color> [<color=#2f96c4>%s<sub>плитка</sub></color>])<color=WET>/мин</color>*",
		soil_plant_tile_net = "<color=WET>Вода</color>: <color=WET>%s<sub>плитка</sub></color> (<color=WET>%s<sub>растение</sub></color> [<color=#2f96c4>%s<sub>плитка</sub></color> + <color=SHALLOWS>%s<sub>мир</sub></color> = <color=#DED15E>%+.1f<sub>чистый</sub></color>])<color=WET>/мин</color>"
	},
	
	farmsoildrinker_nutrients = {
		soil_only = "Питательные вещества: [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sub>плитка</sub>*",
		soil_plant = "Питательные вещества: [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sub>плитка</sub> ([<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sub>Δрастение</sub>)*",		
		--soil_plant_tile = "Питательные вещества: [%+d<color=NATURE><sub>Ф</sub></color>, %+d<color=CAMO><sub>С</sub></color>, %+d<color=INEDIBLE><sub>М</sub></color>]<sup>плитка</sup> ([<color=#bee391>%+d<sub>Ф</sub></color>, <color=#7a9c6e>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sup>Δрастение</sup>   [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sup>плиткаΔ</sup>)"
		--soil_plant_tile = "Питательные вещества: [%+d<color=NATURE><sub>Ф</sub></color>, %+d<color=CAMO><sub>С</sub></color>, %+d<color=INEDIBLE><sub>М</sub></color>]<sup>плитка</sup> ([<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sup>Δрастение</sup>   [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>С</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sup>плиткаΔ</sup>)"
		soil_plant_tile = "Питательные вещества: [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sub>плитка</sub>   ([<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sub>Δрастение</sub> [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>]<sub>плиткаΔ</sub>)"
		--soil_plant_tile_net = "Питательные вещества: [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>] ([<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>] + [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>] = [<color=NATURE>%+d<sub>Ф</sub></color>, <color=CAMO>%+d<sub>К</sub></color>, <color=INEDIBLE>%+d<sub>М</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "Ускоряет <color=NATURE>время роста</color> на <color=NATURE>%s</color> секунд.",
		nutrient_value = "Питательные вещества: [<color=NATURE>%s<sub>Формула</sub></color>, <color=CAMO>%s<sub>Компост</sub></color>, <color=INEDIBLE>%s<sub>Навоз</sub></color>]",
		wormwood = {
			formula_growth = "Ускоряет ваше <color=LIGHT_PINK>цветение</color> на <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>Исцеляет</color> вас на <color=HEALTH>{healing}</color> за <color=HEALTH>{duration}</color> день(дней).",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "Можно наполнить океанской водой.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s / %s",
	actions = {
		USES_PLAIN = "Использования",
		TERRAFORM = "Терраформирование",
		GAS = "Газ", -- Гамлет
		DISARM = "Разоружение", -- Гамлет
		PAN = "Поворот", -- Гамлет
		DISLODGE = "Высечь", -- Гамлет
		SPY = "Расследование", -- Гамлет
		THROW = "Бросок", -- Южная Подземелья
		ROW_FAIL = "Неудачное гребание",
		--ATTACK = "<string=ACTIONS.ATTACK.GENERIC>", --STRINGS.ACTIONS.ATTACK.GENERIC,
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>", --STRINGS.ACTIONS.POUR_WATER.GENERIC,
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>Рыба</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": +1 рыба через: %s",
	fish_wait_time = "Потребуется <color=SHALLOWS>%s секунд</color>, чтобы поймать рыбу.",	

	-- fishingrod.lua
	fishingrod_waittimes = "Время ожидания: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Максимальное время ловли: <color=SHALLOWS>%s</color>",	

	-- follower.lua
	leader = "Лидер: %s",
	loyalty_duration = "Длительность преданности: %s",	

	-- forcecompostable.lua
	forcecompostable = "Значение компоста: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "20%% шанс ошибки при добавлении еще %s деталей.",
		correct = "Это правильно собрано.",
		incorrect = "Это собрано неправильно.",
		gateway_too_far = "Этот скелет слишком далеко находится на %s плит(ке).",
	},
	
	-- friendlevels.lua
	friendlevel = "Уровень дружелюбия: %s / %s",
	
	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> день(дней) топлива.",
		fuel_verbose = "<color=LIGHT>%s</color> день(дней) <color=LIGHT>%s</color>.",
		type = "Тип топлива: %s",
		types = {
			BURNABLE = "Топливо",
			CAVE = "Освещение", -- шахтерская шапка / фонари, лампочки и т.д.
			CHEMICAL = "Топливо",
			CORK = "Топливо",
			GASOLINE = "Бензин", -- DS: на самом деле нигде не используется?
			MAGIC = "Прочность", -- амулеты, которые нельзя заправить (например, охлажденный амулет)
			MECHANICAL = "Прочность", -- SW: железный ветер
			MOLEHAT = "Ночное видение", -- Moggles
			NIGHTMARE = "Кошмарное топливо",
			NONE = "Время", -- никогда не будет заправлено...............................
			ONEMANBAND = "Прочность",
			PIGTORCH = "Топливо",
			SPIDERHAT = "Прочность", -- Паучья шапка
			TAR = "Смола", -- SW
			USAGE = "Прочность",
		},
	},	

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>Оставшееся топливо</color> (<color=LIGHT>%s%%</color>): %s", -- процент, время
		time_verbose = "<color=LIGHT>%s</color> осталось (<color=LIGHT>%s%%</color>): %s", -- тип, процент, время
		efficiency = "<color=LIGHT>Эффективность топлива</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>Топлива</color>: <color=LIGHT>%s</color>",
		held_refuel = "Удерживаемый <color=SWEETENER><prefab=%s></color> заправит на <color=LIGHT>%s%%</color>.",
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>Сестринская связь</color>: %s / %s.",
		flower = "Ваша <color=%s>сестринская связь</color>: %s / %s. ",
		levelup = " +1 в %s.",
	},
	
	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "Восстанавливает <color=HEALTH>%s здоровья</color> за %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_fastregen = "Восстанавливает <color=HEALTH>%s здоровья</color> за %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_attack = "Максимизирует <color=HEALTH>урон</color> на %s.",
		ghostlyelixir_speed = "Увеличивает <color=DAIRY>скорость</color> на <color=DAIRY>%s%%</color> на %s.",
		ghostlyelixir_shield = "Увеличивает длительность щита до 1 секунды на %s.",
		ghostlyelixir_retaliation = "Щит отражает <color=HEALTH>%s урона</color> на %s.", -- объединено с щитом
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "Продолжительность <color=#737CD0><prefab=%s></color>: %s.",
	},

	-- growable.lua
	growable = {
		stage = "Этап <color=#8c8c8c>'%s'</color>: %s / %s: ",
		paused = "Рост приостановлен.",
		next_stage = "Следующий этап через %s.",
	},

	-- grower.lua
	harvests = "<color=NATURE>Урожаи</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 в %s.",
	},	

	-- hatchable.lua
	hatchable = {
		discomfort = "Дискомфорт: %s / %s",
		progress = "Прогресс вылупления: %s / %s",
	},	

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>Здоровье</color>: <color=HEALTH>%+d</color>",
		webber_heal = "Здоровье Уэббера: <color=HEALTH>%+d</color>",
		spider_heal = "Здоровье Паука: <color=HEALTH>%+d</color>",
	},	

	-- health.lua
	health = "<color=HEALTH>Здоровье</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
	absorption = " : Поглощает %s%% урона.",
	naughtiness = "Непослушание: %s",
	player_naughtiness = "Ваше непослушание: %s / %s",

	-- heatrock.lua [Prefab]
	heatrock_temperature = "Температура: %s < %s < %s",

	-- herdmember.lua
	herd_size = "Размер стада: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "Диапазон пряток: %s to %s",
		needed_hiding_spots = "Необходимое количество мест для пряток: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "<prefab=hound> Атакует через %s.",
		time_until_worms = "<prefab=worm> Атакует через %s.",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>Голод</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>Скорость голодания</color>: <color=HUNGER>%+d/день</color> (<color=HUNGER>%s/сек</color>)",
	hunger_paused = "<color=HUNGER>Скорость голодания</color> приостановлена.",

	-- hunter.lua
	hunter = {
		hunt_progress = "След: %s / %s",
		impending_ambush = "На следующем следе вас поджидает засада.",
		alternate_beast_chance = "<color=#b51212>%s%% шанс</color> на появление <color=MOB_SPAWN>Varg</color> или <color=MOB_SPAWN>Ewecus</color>.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> появится через: %s",
	announce_hutch_respawn = "Мой <prefab=hutch> появится через %s.",

	-- inspectable.lua
	wagstaff_tool = "Название этого инструмента: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "Ценность гантели: %s",
	ruins_statue_gem = "Содержит <color=%s><prefab=%s></color>.",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>Теплоизоляция (Зима)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>Теплоизоляция (Лето)</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		head_describe = "[Шляпа]: ",
		hands_describe = "[Tool]: ",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "Количество кошачьих-помощников: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>Ценная добыча</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "Исчезнет в день: %s",
		announce_despawn = "<prefab=klaus_sack> исчезнет в день %s.",
		announce_spawn = "<prefab=klaus_sack> появится через %s.",
	},

	-- leader.lua
	followers = "Последователи: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "Радиус защиты от молнии: %s единиц стены",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "Разрядится через %s день(дней).",

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>доступно</sub> / %d<sub>всего</sub> / %d<sub>макс</sub>",
		next_crystal = "Следующий <color=#4093B2><prefab=lunarrift_crystal_big></color> появится через %s",
		close = "<prefab=LUNARRIFT_PORTAL> закроется примерно через %s",
	},

	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "%d растений заражено",
		spawn = "Гестальты появятся через %s",
		next_wave = "Следующая волна через %s",
		remain_waves = "Осталось %d волн",
	},

	-- lunarthrall_plant.lua [Prefab]
	lunarthrall_plant = {
		time_to_aggro = "Уязвимость заканчивается через: <color=%s>%.1f</color>",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "Активируется через: %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "Закончится через: %s",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "Ожидание, пока кто-то отправится к отмели.",
		time_to_respawn = "<prefab=malbatross> появится через %s.",
	},

	-- mast.lua
	mast_sail_force = "Сила паруса: %s",
	mast_max_velocity = "Максимальная скорость: %s",

	-- mermcandidate.lua
	mermcandidate = "Калории: %s / %s",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>Мощь</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color> - <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>Мощь</color> за использование: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "Гиря: %s",
		mighty_gains = "Обычная <color=MIGHTINESS>тренировка</color>: <color=MIGHTINESS>%+.1f</color>, Идеальная <color=MIGHTINESS>тренировка</color>: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>Потребление голода</color>: <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "Проверяет наличие срабатываний каждые %s день(дней).",
		inactive = "Не проверяет наличие срабатываний.",
		beemine_bees = "Выпустит %s пчёл(ы).",
		trap_starfish_cooldown = "Подготовится к повторному срабатыванию через: %s",
	},

	-- moisture.lua
	moisture = "<color=WET>Влажность</color>: <color=WET>%s%%</color>",

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "Скорость взаимодействия с мачтой и якорем: {feature_speed}\nИспользование прочности весла: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "Снижение урона по кораблю: {reduction}",

	-- mood.lua
	mood = {
		exit = "Выход из настроения через %s день(дней).",
		enter = "Вход в настроение через %s день(дней).",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "Прогресс к месту назначения: %s / %s",
			time_for_next_tool = "Потребуется еще один инструмент через %s.",
			experiment_time = "Эксперимент завершится через %s.",
		},
		storm_move = "%s%% шанс передвинуть лунные бури в день %s.",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>Фаза: %s</color>, %s",
		phase_locked = "Заблокировано <color=#CE3D45>Древним Ключом</color>.",
		announce_phase_locked = "Руины в настоящее время заблокированы в кошмарной фазе.",
		announce_phase = "Руины находятся в фазе %s (осталось %s).",
		phases = {
			["спокойствие"] = "Спокойствие",
			["предупреждение"] = "Предупреждение",
			["буря"] = "Кошмар",
			["рассвет"] = "Рассвет"
		},
	},

	-- oar.lua
	oar_force = "<color=INEDIBLE>Сила</color>: <color=INEDIBLE>%s%%</color>",

	-- oceanfishingrod.lua
	oceanfishingrod = {
		hook = {
			interest = "Интерес: %.2f",
			num_interested = "Интересующиеся рыбы: %s",
		},
		battle = {
			tension = "Натяжение: <color=%s>%.1f</color> / %.1f<sub>разрыв лески</sub>",
			slack = "Потерянное: <color=%s>%.1f</color> / %.1f<sub>рыба сбежала</sub>",
			distance = "Расстояние: %.1f<sub>ловля</sub> / <color=%s>%.1f<sub>течение</sub></color> / %.1f<sub>убегание</sub>",
		},
	},

	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "Дополнительное расстояние: %s",
			bonus_accuracy = "Дополнительная точность: <color=#66CC00>%+.1f%%<sub>мин</sub></color> / <color=#5B63D2>%+.1f%%<sub>макс</sub></color>",
		},
		lure = {
			charm = "Обаяние: <color=#66CC00>%.1f<sub>база</sub></color> + <color=#5B63D2>%.1f<sub>катушка</sub></color>",
			stamina_drain = "Дополнительное истощение выносливости: %.1f",
			time_of_day_modifier = "Эффективность по фазам: <color=DAY_BRIGHT>%d%%<sub>день</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>сумерки</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>ночь</sub></color>",
			weather_modifier = "Эффективность по погоде: <color=#bbbbbb>%d%%<sub>ясно</sub></color> / <color=#7BA3F2>%d%%<sub>дождь</sub></color> / <color=FROZEN>%d%%<sub>снег</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "Прогресс выращивания супервысокого дерева: %s / %s",

	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>Возраст</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "<color=#E3D740>Уровень Золота</color>: %.1f / %.1f",
		gold_level = "<color=#E3D740>Уровень Золота</color>: %.1f",
	},

	-- parryweapon.lua
	parryweapon = {
		parry_duration = "Длительность парирования: {duration}",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "Гниение",
		stale = "Прогоркание",
		spoil = "Испортится",
		dies = "Умирает",
		starves = "Голодает",
		transition = "<color=MONSTER>{next_stage}</color> через {time}",
		transition_extended = "<color=MONSTER>{next_stage}</color> через {time} (<color=MONSTER>{percent}%</color>)",
		paused = "В настоящее время не портится.",
	},

	-- petrifiable.lua
	petrify = "Превратится в камень через %s.",

	-- pickable.lua
	pickable = {
		regrowth = "<color=NATURE>Подрастет</color> через: <color=NATURE>%s</color>",
		regrowth_paused = "Подрастание приостановлено.",
		cycles = "<color=DECORATION>Осталось урожаев</color>: <color=DECORATION>%s</color> / <color=DECORATION>%s</color>",
		mushroom_rain = "<color=WET>Дождь</color> необходим: %s",
	},

	-- planardamage.lua
	planardamage = {
		planar_damage = "<color=PLANAR>Планарный Урон</color>: <color=PLANAR>%s</color>",
		additional_damage = " (<color=PLANAR>+%s<sub>бонус</sub></color>)",
	},

	-- planardefense.lua
	planardefense = {
		planar_defense = "<color=PLANAR>Планарная Защита</color>: <color=PLANAR>%s</color>",
		additional_defense = " (<color=PLANAR>+%s<sub>бонус</sub></color>)",
	},

	-- poisonable.lua
	poisonable = {
		remaining_time = "<color=NATURE>Яд</color> истечет через %s",
	},

	-- pollinator.lua
	pollination = "Цветы опылены: (%s) / %s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "Моя <prefab=polly_rogers> возродится через %s."
	},

	-- preservative.lua
	preservative = "Восстанавливает %s%% свежести.",

	-- preserver.lua
	preserver = {
		spoilage_rate = "<color=#ad5db3>Скорость порчи</color>: <color=#ad5db3>%.1f%%</color>",
		freshness_rate = "<color=FROZEN>Скорость свежести</color>: <color=FROZEN>%.1f%%</color>",
	},

	-- quaker.lua
	quaker = {
		next_quake = "<color=INEDIBLE>Землетрясение</color> через %s.",
	},

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Осталось игрушек: %s",
			assisted_by = "Этот pipspook получает помощь от %s.",
		},
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>Общая Влажность</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>Скорость осадков</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>Шанс лягушачьего дождя</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "ID Осколка: %s",
		shard_type = "Тип Осколка: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "Заряжается через: %s",
		charge = "Заряд: %s / %s"
	},

	-- repairer.lua
	repairer = {
		type = "Материал для ремонта: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>Восстановление здоровья</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>фиксированное HP</sub></color> + <color=HEALTH>%s%%<sub>процентное HP</sub></color>",
		work = "<color=#DED15E>Ремонт работы</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>работа</sub></color>",
		perish = "<color=MONSTER>Обновление</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>Обновление</color>: <color=MONSTER>%s%%</color>",
		held_repair = "Удерживаемый <color=SWEETENER><prefab=%s></color> восстановит <color=LIGHT>%s</color> использований (<color=LIGHT>%s%%</color>).",
		materials = (IS_DST and {
			[MATERIALS.WOOD] =  "Дерево",
			[MATERIALS.STONE] =  "Камень",
			[MATERIALS.HAY] =  "Сено",
			[MATERIALS.THULECITE] =  "Тулекит",
			[MATERIALS.GEM] =  "Драгоценный камень",
			[MATERIALS.GEARS] =  "Шестеренка",
			[MATERIALS.MOONROCK] =  "Лунный камень",
			[MATERIALS.ICE] =  "Лёд",
			[MATERIALS.SCULPTURE] =  "Скульптура",
			[MATERIALS.FOSSIL] =  "Ископаемое",
			[MATERIALS.MOON_ALTAR] =  "Лунный Алтарь",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "<color=#99635D>Требуется Шестеренка</color>: <color=#99635D>%s</color>",
	},

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL> появится через %s",
		announce_spawn = "<prefab=LUNARRIFT_PORTAL> появится через %s",

		stage = "Стадия: %d / %d", -- дополнено из growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "Невозможно вызвать."
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>Дополнительный урон</color>: <color=HEALTH>%s</color>",
		absorption = "<color=HEALTH>Поглощение урона</color>: <color=HEALTH>%s%%</color>",
		bonus_speed = "<color=DAIRY>Дополнительная скорость</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>Рассудок</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>Просвещение</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		interaction = "<color=SANITY>Рассудок</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = "<color=SANITY>Аура Рассудка</color>: <color=SANITY>%s/мин</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "Это уже было открыто.",
		chest_labyrinth = {
			sanity = "66% шанс изменить <color=SANITY>рассудок</color> на <color=SANITY>-20</color> до <color=SANITY>20</color>.",
			hunger = "66% шанс изменить <color=HUNGER>голод</color> на <color=HUNGER>-20</color> до <color=HUNGER>20</color>.",
			health = "66% шанс изменить <color=HEALTH>здоровье</color> на <color=HEALTH>0</color> до <color=HEALTH>20</color>.",
			inventory = "66% шанс изменить <color=LIGHT>износ</color> или <color=MONSTER>свежесть</color> на 20%.",
			summonmonsters = "66% шанс призвать 1-3 <color=MOB_SPAWN>Обитателей Глубин</color>.",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>Уровень Тени</color>: %s",
		level_diff = "<color=BLACK>Уровень Тени</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s урона</color>)",
		total_shadow_level = "<color=BLACK>Общий уровень Тени</color>: %s",
	},

	-- shadowrift_portal.lua [Prefab]
	shadowrift_portal = {
		close = "<prefab=SHADOWRIFT_PORTAL> закроется через %s",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "Призвано игроком %s.",
			sanity_reward = "<color=SANITY>Награда за рассудок</color>: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>Награда за рассудок</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "Следующая трещина будет готова к захвату через %s",
		waiting_for_players = "Ожидание приближения игрока",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color> восстановится через %s",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		trades_remaining = "Осталось сделок: %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "Диапазон Укрытия: %s клеток",
		shelter = "Укрытие ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>Оружие</color> длится на <color=#aaaaee>%s%%</color> дольше.",
			battlesong_healthgain = "Попадание по врагам восстанавливает <color=HEALTH>%s здоровья</color> (<color=HEALTH>%s</color> для Вигфрид).",
			battlesong_sanitygain = "Попадание по врагам восстанавливает <color=SANITY>%s рассудка</color>.",
			battlesong_sanityaura = "Отрицательные <color=SANITY>ауры рассудка</color> на <color=SANITY>%s%%</color> менее эффективны.",
			battlesong_fireresistance = "Получайте <color=HEALTH>%s%% меньше урона</color> от <color=LIGHT>огня</color>.",
			battlesong_lunaraligned = "Получайте <color=HEALTH>%s%% меньше урона</color> от <color=LUNAR_ALIGNED>лунных врагов</color>.\nНаносите <color=HEALTH>%s%% больше урона</color> <color=SHADOW_ALIGNED>теневым врагам</color>.",
			battlesong_shadowaligned = "Получайте <color=HEALTH>%s%% меньше урона</color> от <color=SHADOW_ALIGNED>теневых врагов</color>.\nНаносите <color=HEALTH>%s%% больше урона</color> <color=LUNAR_ALIGNED>лунным врагам</color>.",

			battlesong_instant_taunt = "Привлекает внимание всех ближайших врагов в радиусе песни.",
			battlesong_instant_panic = "Паникует ближайших призрачных врагов на %s день(дней).",
			battlesong_instant_revive = "Возрождает до %d ближайших союзников.",
		},
		cost = "Стоимость использования: <color=INSPIRATION>%s вдохновения</color>.",
		cooldown = "Перезарядка песни: %s",
	},

	-- sinkholespawner.lua
	antlion_rage = "Муравейник впадет в ярость через %s.",

	-- skinner_beefalo.lua
	skinner_beefalo = "Устрашающий: %s, Праздничный: %s, Официальный: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "Проснется через %s",
	},

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>Исцеляет</color> на <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Исцеляет</color> людей в радиусе <color=#DED15E>%s клеток</color>.",

	-- spawner.lua
	spawner = {
		next = "Воспроизведет <color=MOB_SPAWN><prefab={child_name}></color> через {respawn_time}.",
		child = "Воспроизводит <color=MOB_SPAWN><prefab=%s></color>",
		occupied = "Занято: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>Исцеляет</color> Веббера на <color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>Исцеляет</color> пауков на <color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>Ударов</color> осталось: <color=#aaaaee>%s</color>",
		time_to_reset = "Сбросится через %s." 
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>) будет готов через %s день(дней).",
		cooker = "Приготовлено <color=%s>%s</color>.",
		cooktime_modifier_slower = "Готовит еду <color=#DED15E>%s%% медленнее</color>.",
		cooktime_modifier_faster = "Готовит еду <color=NATURE>%s%% быстрее</color>.",
	},

	-- stickable.lua
	stickable = "<color=FISH>Мидии</color>: %s",

	-- temperature.lua
	temperature = "Температура: <temperature=%s>",

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "Восстанавливает <color=HEALTH>%s</color> здоровья за каждый непрошедший день.",
		eot_health = "<prefab=eyeofterror> <color=HEALTH>Здоровье</color> при возвращении: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>Здоровье</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>Здоровье</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium> будет готов через %s.",
	},

	-- tigersharker.lua
	tigershark_spawnin = "Может появиться через: %s",
	tigershark_waiting = "Готов к появлению.",
	tigershark_exists = "Тигровая акула присутствует.",

	-- timer.lua
	timer = {
		label = "Таймер <color=#8c8c8c>'%s'</color>: %s",
		paused = "Пауза",
	},

	-- toadstoolspawner.lua
	toadstoolspawner = {
		time_to_respawn = "<prefab=toadstool> появится через %s.",
	},

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>Эффективность</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "Стоимость %s золотых самородков.",
	tradable_gold_dubloons = "Стоимость %s золотых самородков и %s дублонов.",
	tradable_rocktribute = "Отсрочивает ярость <color=LIGHT>Муравьиного Льва</color> на %s.",

	-- unwrappable.lua
	-- обработано klei?

	-- upgradeable.lua
	upgradeable_stage = "Стадия %s / %s: ",
	upgradeable_complete = "Прогресс улучшения %s%%.",
	upgradeable_incomplete = "Улучшения невозможны.",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "Увеличивает <color=HEALTH>максимальное здоровье</color> на <color=HEALTH>%d</color>.",
			maxsanity = "Увеличивает <color=SANITY>максимальный рассудок</color> на <color=SANITY>%d</color>.",
			movespeed = "Увеличивает <color=DAIRY>скорость</color> на %s.",
			heat = "Увеличивает <color=#cc0000>минимальную температуру</color> на <color=#cc0000>%d</color>.",
			heat_drying = "Увеличивает <color=#cc000>скорость сушки</color> на <color=#cc0000>%.1f</color>.",
			cold = "Уменьшает <color=#00C6FF>минимальную температуру</color> на <color=#00C6FF>%d</color>.",
			taser = "Наносит <color=WET>%d</color> %s атакующим (перезарядка: %.1f).",
			light = "Создает <color=LIGHT>радиус света</color> <color=LIGHT>%.1f</color> (дополнительно только <color=LIGHT>%.1f</color>).",
			maxhunger = "Увеличивает <color=HUNGER>максимальный уровень голода</color> на <color=HUNGER>%d</color>.",
			music = "Обеспечивает <color=SANITY>ауру рассудка</color> <color=SANITY>%+.1f/мин</color> в радиусе <color=SANITY>%.1f</color> клеток.",
			music_tend = "Ухаживает за растениями в радиусе <color=NATURE>%.1f</color> клеток.",
			bee = "Восстанавливает <color=HEALTH>%d здоровья/%ds</color> (<color=HEALTH>%d в день</color>).",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> воскреснет через: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>Водонепроницаемость</color>: <color=WET>%s%%</color>",
		
	-- watersource.lua
	watersource = "Это источник воды.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "Увеличивает влажность на <color=WET>%s</color>."
	},

	-- wathgrithr_shield.lua [Prefab]
	wathgrithr_shield = {
		parry_duration_complex = "Продолжительность парирования: <color=%s>%.1f<sub>обычный</sub></color> | <color=%s>%.1f<sub>навык</sub></color>",
	},
		
	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>Урон</color>",
		electric = "<color=WET>(Электрический)</color> <color=HEALTH>Урон</color>",
		poisonous = "<color=NATURE>(Ядовитый)</color> <color=HEALTH>Урон</color>",
		thorns = "<color=HEALTH>(Шипы)</color> <color=HEALTH>Урон</color>",
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Диапазон: %s",

	-- weather.lua
	weather = {
		progress_to_rain = "Прогресс к <color=WET>дождю</color>", -- Числа добавляются кодом
		remaining_rain = "<color=WET>Оставшийся дождь</color>", -- Числа добавляются кодом

		progress_to_hail = "Прогресс к <color=LUNAR_ALIGNED>граду</color>", -- Числа добавляются кодом
		remaining_hail = "<color=LUNAR_ALIGNED>Оставшийся град</color>", -- Числа добавляются кодом
		
		progress_to_acid_rain = "Прогресс к <color=SHADOW_ALIGNED>кислотному <color=WET>дождю</color></color>", -- Числа добавляются кодом
		remaining_acid_rain = "<color=SHADOW_ALIGNED>Оставшийся кислотный <color=WET>дождь</color></color>", -- Числа добавляются кодом
	},

	-- weighable.lua
	weighable = {
		weight = "Вес: %s (%s%%)",
		weight_bounded = "Вес: %s <= %s (%s) <= %s",
		owner_name = "Владелец: %s"
	},

	-- werebeast.lua
	werebeast = "Оборотень: %s / %s",

	-- wereness.lua
	wereness_remaining = "Оборотень: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "У этого есть компонент лебедки, но не проходит проверку предварительной компиляции.",
		sunken_item = "Под этой лебедкой находится <color=#66ee66>%s</color>.",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>Температура мира</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "Вы <color=#bbffbb>имеете право</color> на <color=#DED15E>редкие подарки</color>.",
		not_ready = "Вам <color=#ffbbbb>необходимо подождать еще %s день(дней)</color>, прежде чем вы сможете получить еще один <color=#DED15E>редкий подарок</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "Изменение состояния откладывается на %s",
		wither = "Засохнет через %s",
		rejuvenate = "Восстановится через %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>Шанс появления древнего стража</color>: %s%%<sub>Ваш</sub> & %s%%<sub>НПС</sub>",
		treeguard_chance = "<color=#636C5C>Шанс появления древнего стража</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "Мигратор миров отключен.",
		target_shard = "Целевой осколок: %s",
		received_portal = "Целевой портал: %s", -- Мигратор осколков
		id = "Этот портал: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "Таймер мировых настроек <color=#8c8c8c>'%s'</color>: %s",
		paused = "Приостановлено",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "Оставшееся время зарядки: %s",
		gain_charge_time = "Заряд: %d / %d, следующая <color=LIGHT>зарядка</color> через: <color=LIGHT>%s</color>",
		full_charge = "Полностью заряжен!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "Прогресс сканирования: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "Завершит шитье через: %s",
}