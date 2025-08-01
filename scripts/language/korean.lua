--[[
Copyright (퇴비) 2020, 2021 penguin0616

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

-- Translated by: https://steamcommunity.com/profiles/76561199503229520
-- Some of the tags were cut during translation: so something that should be <sub>최소</sub> ends up as <sub>최소/sub>
-- Pattern: ([^\u0000-\u007F]+)/
-- Fix: $1</

-- TheNet:GetLanguageCode() == "korean" & LOC.GetLocaleCode() == "ko"

return {
	-- insightservercrash.lua
	crash_reporter = {
		title = "[Insight Crash Reporter]",
		crashed = "서버가 충돌했습니다.",
		report_status = {
			unknown = "Unknown",
			disabled = "The crash reporter is <color=#666666>disabled</color>: <color=#666666>%s</color>",
			sending = "Sending crash report",
			success = "Crash reported to Insight. <u>This does NOT mean that Insight caused the issue!</u>",
			failure = "Crash report failed to send (%s): %s",
		},
	},
	
	-- modmain.lua
	dragonfly_ready = "전투 준비 완료.",

	-- time.lua
	time_segments = "%s 세그먼트",
	time_days = "%s 일, ",
	time_days_short = "%s 일",
	time_seconds = "%s 초",
	time_minutes = "%s 분, ",
	time_hours = "%s 시간, ",

	-- meh
	seasons = {
		autumn = "<color=#CE5039>가을</color>",
		winter = "<color=#95C2F4>겨울</color>",
		spring = "<color=#7FC954>봄</color>",
		summer = "<color=#FFCF8C>여름</color>",
	},

	-- first time using insight
	first_time_insight = {
		title = "Welcome to Insight!",
		description = "This is probably your first time using Insight.\nI recommend checking out the configuration or using one of the presets!",
		no = "No thanks",
		configuration = "Configuration",
		presets = "Presets",
	},

	-- insightconfigurationscreen.lua
	preset_button = "Presets",

	-- insightpresetscreen.lua
	presetscreen = {
		title = "Configuration Presets",
		description = "Select a configuration preset.",
	},

	-- Keybinds
	unbind = "할당 해제",
	keybinds = {
		label = "단축키 (키보드 전용)",
		togglemenu = {
			name = "Insight 메뉴 열기",
			description = "Insight 메뉴 열기/닫기"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[위험 알림]: ",
		boss = "[보스 알림]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "새 플레이어",
				description = "게임을 처음 접한 플레이어에게 적합합니다.",
			},
			simple = {
				label = "간단",
				description = "Show Me 모드처럼 소량의 정보만 표시합니다.",
			},
			decent = {
				label = "적당",
				description = "평균적인 양의 정보. 기본 설정과 유사합니다.",
			},
			advanced = {
				label = "고급",
				description = "다양한 정보를 표시하고 싶은 플레이어에게 적합합니다.",
			},
		},
	},

	-- Insight Menu
	insightmenu = {
		tabs = {
			world = "세계",
			player = "플레이어",
		},
	},

	indicators = {
		dismiss = "%s 해제",
	},

	-- Damage helper
	damage_types = {
		-- Normal
		explosive = "폭발",
		
		-- Planar
		lunar_aligned = "달 진영",
		shadow_aligned = "그림자 진영",
	},

	-------------------------------------------------------------------------------------------------------------------------
	
	-- acidbatwavemanager.lua
	acidbatwavemanager = {
		chance = "Chance of bat raid: <color=%s>%.1f%%</color> (estimated=<color=%s>%.1f%%</color>)",
		next_wave_spawn = "<prefab=bat> raid (%d) arrives in %s"
	},
	
	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "빛을 위한 최소 <color=SANITY>정신력</color>: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_sanity = "당신의 <color=SANITY>정신력</color>: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "소환된 <color=ENLIGHTENMENT>게슈탈트</color>의 데미지: <color=HEALTH>%s</color>",
	},

	-- ancienttree_seed.lua [Prefab]
	ancienttree_seed = {
		type = "Type: <color=%s><prefab=%s></color>",
		fruit_regen_time = "Fruit time: %s",
		fruit_regen_time_bounded = "Fruit time: %s <= %s <= %s",
	},

	-- aoeweapon_base.lua
	aoeweapon_base = {
		--weapon_damage = "광역공격 %s: <color=HEALTH>{damage}</color>",
	},

	-- aoeweapon_leap.lua
	aoeweapon_leap = {

	},

	-- aoeweapon_lunge.lua
	aoeweapon_lunge = {
		lunge_damage = "돌진 {damageType}: <color=HEALTH>{damage}</color>",
	},
	

	-- appeasement.lua
	appease_good = "분출 지연: %s 세그먼트",
	appease_bad = "분출 가속: %s 세그먼트",

	-- appraisable.lua
	appraisable = "무서움: %s, 화려함: %s, 단정함: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "잠금 해제: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>방어력</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>내구도</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>내구도</color>: <color=#C0C0C0>%s</color>",

	-- armordreadstone.lua
	armordreadstone = {
		regen = "<color=%s>%.1f</color> <color=#C0C0C0>내구도</color>/%d초 재생.",
		regen_complete = "정신력에 반비례하여 <color=%s>%.1f<sub>분</sub></color> / <color=%s>%.1f<sub>현재</sub></color> / <color=%s>%.1f<sub>최대</sub></color> <color=#C0C0C0>내구도</color>/%d초 재생."
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate> 재설정까지: %s",
	},

	-- attunable.lua
	attunable = {
		linked = "연결됨: %s",
		offline_linked = "연결됨(오프라인): %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "타격 시 <color=HEALTH>%s 체력</color> 회복.",
		sanity_cost = "타격 시 <color=SANITY>%s 정신력</color> 소모.",
	},

	-- beard.lua
	beard = "수염이 자라기까지: %s 일",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>목표: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger>이(가) %s (<prefab=%s>) 목표로 %s 후에 생성됩니다.",
		bearger_attack = "<prefab=bearger>이(가) %s 후에 공격합니다."
	},

	-- beef_bell.lua [Prefab]
	beef_bell = {
		beefalo_name = "이름: %s",
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen>이(가) %s 후에 재생성됩니다.",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "저항: %.5f",
		max_velocity_mod = "최대 속도 변경: %.3f",
		force_dampening = "힘 감쇠: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- book.lua
	book = {
		wickerbottom = {
			tentacles = "<color=%s>%d 개의 촉수</color> 소환.",
			birds = "최대 <color=%s>%d 마리의 새</color> 소환.",
			brimstone = "<color=%s>%d 번의 번개</color> 소환.",
			horticulture = "최대 <color=%s>%d 개의 식용 식물</color> 성장.",
			horticulture_upgraded = "최대 <color=%s>%d 개의 식용 식물</color> 성장 및 관리.",
			--silviculture = "기본 자원 식물 성장.",
			--fish = "",
			--fire = ""
			web = "<color=%s>거미줄</color> 소환, 지속 시간: <color=%s>%s</color>",
			--temperature = ""
			light = "<color=LIGHT>광원</color> 소환, 지속 시간: <color=LIGHT>%s</color>",
			-- light_upgraded is just light
			rain = "<color=WET>비 또는 눈</color> 토글, 근처 식물에 <color=WET>수분 공급</color>.",
			bees = "<color=%s>%d 마리의 병정벌</color> 소환, 최대 <color=%s>%d 마리</color> 소환 가능.",
			research_station = "프로토타입 잠금 해제: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "<color=%s>%d 개의 운석</color> 소환.",
		},
	},

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>열대어</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>보라색 그루퍼</color>",
	breeder_fish4 = "<color=#DED15E>광대 물고기</color>",
	breeder_fish5 = "<color=#9ADFDE>네온 콰트로</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "추가 물고기 생성까지: %s",
	breeder_possiblepredatortime = "포식자 생성 가능: %s",

	-- brushable.lua
	brushable = {
		last_brushed = "%s 일 전에 빗질함."
	},

	-- burnable.lua
	burnable = {
		smolder_time = "남은 <color=LIGHT>발화 시간</color>: <color=LIGHT>%s</color>",
		burn_time = "남은 <color=LIGHT>연소 시간</color>: <color=LIGHT>%s</color>",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "장식 가치: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "희귀",
			uncommon = "드문",
			common = "일반",
			unknown = "알 수 없음",
		},
		shape = "모양: %s",
		rarity = "희귀도: %s",
		season = "계절: %d",
		undecided = "내용물이 결정되기 전에 배치 필요."
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>등급</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "장식 총합: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>가스 수준</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "<color=#522E61>중독</color> 가능성: <color=#D8B400>%d%%</color>",
		gas_level_increase = "%s 후에 증가.",
		gas_level_decrease = "%s 후에 감소."
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "캣쿤 생명: %s / %s",
		regenerate = "캣쿤 재생성: %s",
		waiting_for_sleep = "근처 플레이어가 멀어지기를 기다리는 중.",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "범죄 현장으로 돌아오기를 기다리는 중.",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color>이(가) %s 후에 재생성됩니다.",
	announce_chester_respawn = "내 <prefab=chester>이(가) %s 후에 재생성됩니다.",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>내부</sub> + %s<sub>외부</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>내부</sub> + %s<sub>외부</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "{to_regen}을(를) {regen_time} 후에 재생성.",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>공격력</color>: <color=HEALTH>%s</color>",
		damageToYou = " (나에게 적용되는 공격력: <color=HEALTH>%s</color>)",
		age_damage = "<color=HEALTH>공격력<color=AGE>(나이)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (나에게 적용되는 공격력(나이): <color=AGE>%+d</color>)",
		yotr_pillows = {
			--@@ Weapons
			knockback = "<color=VEGGIE>넉백</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "넉백 배수: %s",
			laglength = "<color=VEGGIE>쿨타임</color>: %s",
			
			--@@ Armor
			defense_amount = "<color=VEGGIE>방어</color>: %s",
			
			--@@ Both
			prize_value = "상금: %s",
		},
	},

	-- compostingbin.lua
	compostingbin = {
		contents_amount = "Material: %s / %s",
		detailed_contents_amount = "Material: <color=NATURE>%s<sub>Green</sub></color> + <color=INEDIBLE>%s<sub>Brown</sub></color> / %s",
	},

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "쿨타임: %s",

	-- crabkingspawner.lua
	crabkingspawner = {
		crabking_spawnsin = "%s",
		time_to_respawn = "<prefab=crabking>이(가) %s 후에 재생성됩니다.",
	},

	-- crittertraits.lua
	dominant_trait = "특성: %s",

	-- crop.lua
	crop_paused = "일시 중지됨.",
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "단계: %s / %s",
		note = ", 참고: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> 피해를 %s 개체에 가함.",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> 피해를 %s 공격으로부터 받음.",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>정신력</color>: <color=SANITY>%s/분</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER>이(가) %s 일 후에 재생성됩니다.",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>버프</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = {
			name = "<color=HEALTH>공격력 증가</color>",
			description = "공격력 <color=HEALTH>{percent}% 증가</color>, {duration}(초) 지속.",
		},
		["buff_playerabsorption"] = {
			name = "<color=MEAT>피해 흡수</color>",
			description = "피해 <color=MEAT>{percent}% 흡수</color>, {duration}(초) 지속.",
		},
		["buff_workeffectiveness"] = {
			name = "<color=SWEETENER>작업 효율</color>",
			description = "작업 효율 <color=#DED15E>{percent}% 증가</color>, {duration}(초) 지속.",
		},
		
		["buff_moistureimmunity"] = {
			name = "<color=WET>습기 면역</color>",
			description = "습기 <color=WET>면역</color>, {duration}(초) 지속.",
		},
		["buff_electricattack"] = {
			name = "<color=WET>전기 공격</color>",
			description = "공격에 <color=WET>전기 속성 부여</color>, {duration}(초) 지속.",
		},
		["buff_sleepresistance"] = {
			name = "<color=MONSTER>수면 저항</color>",
			description = "수면 <color=MONSTER>내성 증가</color>, {duration}(초) 지속.",
		},
		
		["healingsalve_acidbuff"] = {
			name = "<color=#ded15e>Acid Resistance</color>",
			description = "Immune to <color=#ded15e>acid rain</color> for {duration}(s)."
		},
		["tillweedsalve_buff"] = {
			name = "<color=HEALTH>체력 재생</color>",
			description = "<color=HEALTH>{amount} 체력 재생</color>, {duration}(초) 지속.",
		},
		["healthregenbuff"] = {
			name = "<color=HEALTH>체력 재생</color>",
			description = "<color=HEALTH>{amount} 체력 재생</color>, {duration}(초) 지속.",
		},
		["sweettea_buff"] = {
			name = "<color=SANITY>정신력 재생</color>",
			description = "<color=SANITY>{amount} 정신력 재생</color>, {duration}(초) 지속.",
		},
		["nightvision_buff"] = {
			name = "<color=#258cd3>Night vision</color>",
			description = "Provides <color=#258cd3>night vision</color> for {duration}(s).",
		},
		["wormlight_light"] = {
			name = "<color=#6AD1EF><prefab=wormlight> light</color>",
			--description = "Provides light for {duration}(s).",
		},
		["wormlight_light_lesser"] = function(parent) return deepcopy(parent.wormlight_light) end,
		["wormlight_light_greater"] = function(parent) return deepcopy(parent.wormlight_light) end,


		["wintersfeastbuff"] = {
			name = "<color=FROZEN>겨울 축제 버프</color>",
			description = "<color=HUNGER>허기</color>, <color=SANITY>정신력</color>, <color=HEALTH>체력</color> 회복."
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER><prefab=batnosehat> 버프</color>",
			description = "<color=HUNGER>{amount} 허기 재생</color>, {duration}(초) 지속.",
		},
		
		["halloweenpotion_health_buff"] = {
			name = "<color=HEALTH>체력 재생</color>",
			description = nil
		},
		["halloweenpotion_sanity_buff"] = {
			name = "<color=SANITY>정신력 재생</color>",
			description = nil
		},
		["halloweenpotion_bravery_small_buff"] = {
			name = "<color=SANITY>박쥐에 대한 용기</color>",
			description = nil
		},
		["halloweenpotion_bravery_large_buff"] = (function(parent)
			return deepcopy(parent.halloweenpotion_bravery_small_buff)
		end)
	},

	-- deerclopsspawner.lua
	deerclopsspawner = {
		incoming_deerclops_targeted = "<color=%s>목표: %s</color> -> %s",
		announce_deerclops_target = "<prefab=deerclops>이(가) %s (<prefab=%s>) 목표로 %s 후에 생성됩니다.",
		deerclops_attack = "<prefab=deerclops>이(가) %s 후에 공격합니다.",
	},

	-- diseaseable.lua
	disease_in = "병에 걸리기까지: %s",
	disease_spread = "병이 퍼지기까지: %s",
	disease_delay = "병이 지연되기까지: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "길들임: %s%%",
		obedience = "충성도: %s%%",
		--obedience_extended = "충성도: %s%% (%s%%<sub>안장</sub>, <%s%%<sub>안장 벗음</sub>, %s%%<sub>탑승</sub>)",
		obedience_extended = "충성도: %s%% (<%s%%<sub>안장 벗음</sub>, %s%%<sub>최소</sub>)",
		tendency = "성향: %s",
		tendencies = {
			["NONE"] = "없음",
			[TENDENCY.DEFAULT] = "기본",
			[TENDENCY.ORNERY] = "고약한",
			[TENDENCY.RIDER] = "재빠른",
			[TENDENCY.PUDGY] = "뚱뚱한"
		},
	},

	-- dragonfly_spawner.lua [Prefab]
	dragonfly_spawner = {
		time_to_respawn = "<prefab=dragonfly>이(가) %s 후에 재생성됩니다.",
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "건조 일시 중지됨.",
	dry_time = "남은 시간: %s",

	-- eater.lua
	eater = {
		eot_loot = "음식으로 회복하는 <color=HUNGER>허기 %s%%</color> + <color=HEALTH>체력 %s%%</color> 값을 내구도로 치환.",
		eot_tofeed_restore = "<color=MEAT><prefab=%s></color>을(를) 먹일 시 <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) 내구도 회복.",
		eot_tofeed_restore_advanced = "<color=MEAT><prefab=%s></color>을(를) 먹일 시 <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) 내구도 회복.",
		tofeed_restore = "<color=MEAT><prefab=%s></color>을(를) 먹일 시 %s 회복.",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> 개의 <color=%s>%s</color>", 
	edible_interface = "<color=HUNGER>허기</color>: <color=HUNGER>%s</color> / <color=SANITY>정신력</color>: <color=SANITY>%s</color> / <color=HEALTH>체력</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>체력</color>: <color=HEALTH>%s</color> / <color=HUNGER>허기</color>: <color=HUNGER>%s</color> / <color=SANITY>정신력</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "고기",
		monster = "괴물",
		fish = "물고기",
		veggie = "채소",
		fruit = "과일",
		egg = "알",
		sweetener = "감미료",
		frozen = "얼음",
		fat = "지방",
		dairy = "유제품",
		decoration = "장식품",
		magic = "마법",
		precook = "조리식품",
		dried = "건조식품",
		inedible = "비식품",
		bug = "벌레",
		seed = "씨앗",
		antihistamine = "알레르기 치료제", -- Only "cutnettle"
	},
	edible_foodeffect = {
		temperature = "온도: %s, %s",
		caffeine = "속도: %s, %s",
		surf = "배 속도: %s, %s",
		autodry = "건조 보너스: %s, %s",
		instant_temperature = "온도: %s, (일시적)",
		antihistamine = "꽃가루 알레르기 지연: %s 초",
	},
	foodmemory = "최근 섭취: %s / %s, 섭취 기억 망각: %s",
	wereeater = "<color=MONSTER>괴물 고기</color> 섭취: %s / %s, 섭취 기억 망각: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>속도</color>: %s%%",
	hunger_slow = "<color=HUNGER>허기 속도 감소</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>허기 소모율 감소</color>: <color=HUNGER>%s%%</color>",
	insulated = "번개로부터 보호함.",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>폭발 피해</color>: %s",
	explosive_range = "<color=LIGHT>폭발 범위</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "성장 결과: <color=NATURE><prefab=%s></color>.",
		nutrient_consumption = "Δ영양소: [<color=NATURE>%d<sub>성장 촉진제</sub></color>, <color=CAMO>%d<sub>퇴비</sub></color>, <color=INEDIBLE>%d<sub>거름</sub></color>]",
		good_seasons = "계절: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "스트레스 점수: %s",
		display = "스트레스 요인: %s",
		stress_tier = "스트레스 레벨: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "없음",
			[FARM_PLANT_STRESS.LOW] = "낮음",
			[FARM_PLANT_STRESS.MODERATE] = "보통",
			[FARM_PLANT_STRESS.HIGH] = "높음",
		} or {}),
		categories = {
			["nutrients"] = "영양소", -- missing nutrients
			["moisture"] = "수분", -- needs water
			["killjoys"] = "잡초", -- weeds nearby
			["family"] = "가족", -- no similar plants nearby
			["overcrowding"] = "과밀", -- too crowded
			["season"] = "계절", -- out of season
			["happiness"] = "행복", -- not tended to
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>물</color>: <color=WET>%s<sub>타일</sub></color>*",
		soil_plant = "<color=WET>물</color>: <color=WET>%s<sub>타일</sub></color> (<color=WET>%s/분<sub>식물</sub></color>)*",
		soil_plant_tile = "<color=WET>물</color>: <color=WET>%s<sub>타일</sub></color> (<color=WET>%s<sub>식물</sub></color> [<color=#2f96c4>%s<sub>타일</sub></color>])<color=WET>/분</color>*",
		soil_plant_tile_net = "<color=WET>물</color>: <color=WET>%s<sub>타일</sub></color> (<color=WET>%s<sub>식물</sub></color> [<color=#2f96c4>%s<sub>타일</sub></color> + <color=SHALLOWS>%s<sub>세계</sub></color> = <color=#DED15E>%+.1f<sub>순수량</sub></color>])<color=WET>/분</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "영양소: [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sub>타일</sub>*",
		soil_plant = "영양소: [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sub>타일</sub> ([<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sub>Δ식물</sub>)*",
		--soil_plant_tile = "영양소: [%+d<color=NATURE><sub>성장 촉진제</sub></color>, %+d<color=CAMO><sub>퇴비</sub></color>, %+d<color=INEDIBLE><sub>거름</sub></color>]<sup>타일</sup> ([<color=#bee391>%+d<sub>성장 촉진제</sub></color>, <color=#7a9c6e>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sup>식물Δ</sup>   [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sup>타일Δ</sup>)",
		--soil_plant_tile = "영양소: [%+d<color=NATURE><sub>성장 촉진제</sub></color>, %+d<color=CAMO><sub>퇴비</sub></color>, %+d<color=INEDIBLE><sub>거름</sub></color>]<sup>타일</sup> ([<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sup>식물Δ</sup>   [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sup>타일Δ</sup>)",
		soil_plant_tile = "영양소: [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sub>타일</sub>   ([<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sub>Δ식물</sub> [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>]<sub>타일Δ</sub>)",
		--soil_plant_tile_net = "영양소: [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>] ([<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>] + [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>] = [<color=NATURE>%+d<sub>성장 촉진제</sub></color>, <color=CAMO>%+d<sub>퇴비</sub></color>, <color=INEDIBLE>%+d<sub>거름</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "<color=NATURE>성장 시간</color> 단축: <color=NATURE>%s</color> 초",
		nutrient_value = "영양소: [<color=NATURE>%s<sub>성장 촉진제</sub></color>, <color=CAMO>%s<sub>퇴비</sub></color>, <color=INEDIBLE>%s<sub>거름</sub></color>]",
		wormwood = {
			formula_growth = "<color=LIGHT_PINK>개화</color> 가속: <color=LIGHT_PINK>%s</color>",
			compost_heal = "<color=HEALTH>치유량</color>: <color=HEALTH>{healing}</color>, <color=HEALTH>{duration}</color> 초 지속.",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "바닷물로 채울 수 있음.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s / %s",
	actions = {
		USES_PLAIN = "사용",
		TERRAFORM = "테라포밍",
		GAS = "가스", -- hamlet
		DISARM = "무장 해제", -- hamlet
		PAN = "팬", -- hamlet
		DISLODGE = "끌기", -- hamlet
		SPY = "조사", -- hamlet
		THROW = "던지기", -- sw -- Action string is "Throw At"
		ROW_FAIL = "노젓기 실패",
		--ATTACK = "<string=ACTIONS.ATTACK.GENERIC>", --STRINGS.ACTIONS.ATTACK.GENERIC,
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>", --STRINGS.ACTIONS.POUR_WATER.GENERIC,
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>물고기</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": 물고기 1마리 추가까지: %s",
	fish_wait_time = "물고기 잡기까지: <color=SHALLOWS>%s 초</color>",

	-- fishingrod.lua
	fishingrod_waittimes = "대기 시간: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "최대 채집 시간: <color=SHALLOWS>%s</color>",

	-- flotsamgenerator.lua
	flotsamgenerator = {
		messagebottle_cooldown = "Next <prefab=messagebottle> spawn: %s",
	},

	-- follower.lua
	leader = "리더: %s",
	loyalty_duration = "충성 시간: %s",

	-- forcecompostable.lua
	forcecompostable = "퇴비 가치: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "20%% 확률로 %s 개의 조각이 추가될 시 잘못 조립됨.",
		correct = "올바르게 조립됨.",
		incorrect = "잘못 조립됨.",
		gateway_too_far = "이 해골은 %s 타일만큼 멀리 떨어져있음.",
	},

	-- friendlevels.lua
	friendlevel = "우정 레벨: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> 초의 연료.",
		fuel_verbose = "<color=LIGHT>%s</color> 초의 <color=LIGHT>%s</color>.",
		type = "연료 유형: %s",
		types = {
			BURNABLE = "연료",
			CAVE = "빛", -- miner hat / lanterns, light bulbs n stuff
			CHEMICAL = "연료",
			CORK = "연료",
			GASOLINE = "가솔린", -- DS: not actually used anywhere?
			MAGIC = "내구도", -- amulets that aren't refuelable (ex. chilled amulet)
			MECHANICAL = "내구도", -- SW: iron wind
			MOLEHAT = "야간 시야", -- Moggles
			NIGHTMARE = "악몽 연료",
			NONE = "시간", -- will never be refueled...............................
			ONEMANBAND = "내구도",
			PIGTORCH = "연료",
			SPIDERHAT = "내구도", -- Spider Hat
			TAR = "타르", -- SW
			USAGE = "내구도",
		},
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>남은 연료</color> (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color> 잔여 (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>연료 효율</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>연료</color>: <color=LIGHT>%s</color>",
		held_refuel = "<color=SWEETENER><prefab=%s></color> 사용 시 <color=LIGHT>%s%%</color> 연료 보충.",
	},

	-- gelblobspawner.lua
	gelblobspawner = {

	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>자매의 유대감</color>: %s / %s",
		flower = "당신의 <color=%s>자매의 유대감</color>: %s / %s ",
		levelup = "%s 후에 레벨 업.",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "<color=HEALTH>%s 체력</color>재생, %s 지속 (<color=HEALTH>+%s</color> / <color=HEALTH>%s초</color>).",
		ghostlyelixir_fastregen = "<color=HEALTH>%s 체력</color>재생, %s 지속 (<color=HEALTH>+%s</color> / <color=HEALTH>%s초</color>).",
		ghostlyelixir_attack = "<color=HEALTH>데미지</color> 최대치 고정, %s 지속.",
		ghostlyelixir_speed = "<color=DAIRY>이동 속도</color> <color=DAIRY>%s%%</color> 증가, %s 지속.",
		ghostlyelixir_shield = "보호막 지속 시간 1초로 증가, %s 지속.",
		ghostlyelixir_retaliation = "보호막을 공격한 적에게 <color=HEALTH>%s 데미지</color> 반사, %s 지속.", -- concatenated with shield
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "<color=#737CD0><prefab=%s></color> 버프 시간: %s",
	},

	-- growable.lua
	growable = {
		stage = "단계 <color=#8c8c8c>'%s'</color>: %s / %s: ",
		paused = "성장 일시 중지됨.",
		next_stage = "다음 단계까지: %s",
	},

	-- grower.lua
	harvests = "<color=NATURE>수확</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "%s 후에 +1.",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "불쾌함: %s / %s",
		progress = "부화 진행도: %s / %s",
	},

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>체력</color>: <color=HEALTH>%+d</color>",
		webber_heal = "Webber <color=HEALTH>체력</color>: <color=HEALTH>%+d</color>",
		spider_heal = "Spider <color=HEALTH>체력</color>: <color=HEALTH>%+d</color>",
	},

	-- health.lua
	health = "<color=HEALTH>체력</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
	absorption = " : 데미지 %s%% 흡수.",
	naughtiness = "악행 점수: %s",
	player_naughtiness = "당신의 악행 점수: %s / %s",

	-- heatrock.lua [Prefab]
	heatrock_temperature = "온도: %s < %s < %s",

	-- herdmember.lua
	herd_size = "무리 크기: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "숨는 범위: %s ~ %s",
		needed_hiding_spots = "숨을 곳: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "<prefab=hound>이(가) %s 후에 공격합니다.",
		time_until_worms = "<prefab=worm>이(가) %s 후에 공격합니다.",
		time_until_worm_boss = "<prefab=worm_boss>이(가) %s 후에 공격합니다.",
		time_until_crocodog = "<prefab=crocodog>이(가) %s 후에 공격합니다.",
		worm_boss_chance = "<prefab=worm_boss> chance: %.1f%%",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>허기</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>허기 감소</color>: <color=HUNGER>%+d/일</color> (<color=HUNGER>%s/초</color>)",
	hunger_paused = "<color=HUNGER>허기</color> 감소 일시중지됨.",

	-- hunter.lua
	hunter = {
		hunt_progress = "추적: %s / %s",
		impending_ambush = "다음 발자국에 무언가가 기다리는 중.",
		alternate_beast_chance = "<color=#b51212>%s%% 확률</color>로 <color=MOB_SPAWN>바르그</color> 또는 <color=MOB_SPAWN>점액양</color> 등장.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color>이(가) %s 후에 재생성됩니다.",
	announce_hutch_respawn = "내 <prefab=hutch>이(가) %s 후에 재생성됩니다.",

	-- inspectable.lua
	wagstaff_tool = "도구 이름: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "체육관 무게추 무게: %s",
	ruins_statue_gem = "<color=%s><prefab=%s></color> 포함.",

	-- inspectacleshat.lua [Prefab]
	inspectacleshat = {
		ready_to_use = "Ready to inspect",
	},

	-- insulator.lua
	insulation_winter = "<color=FROZEN>단열 (겨울)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>단열 (여름)</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		head_describe = "[모자]: ",
		hands_describe = "[도구]: ",
	},

	-- itemmimic.lua
	itemmimic = {
		time_to_reveal = "<prefab=itemmimic_revealed> reveal in: %s",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "킷쿤 수: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>주요 전리품</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "디스폰 날짜: %s",
		announce_despawn = "<prefab=klaus_sack>이(가) %s 후에 디스폰됩니다.",
		announce_spawn = "<prefab=klaus_sack>이(가) %s 후에 생성됩니다.",
	},

	-- leader.lua
	followers = "추종자: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "번개 보호 범위: %s 벽 단위",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "%s 일 후 방전.",

	-- linkeditem.lua
	linkeditem = {
		owner = "Owner: %s",
	},

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>가능</sub> / %d<sub>전체</sub> / %d<sub>최대</sub>", -- I can't think of a way to word 
		next_crystal = "다음 <color=#4093B2><prefab=lunarrift_crystal_big></color> 생성까지: %s",
		close = "<prefab=LUNARRIFT_PORTAL>이(가) 약 %s 후에 닫힙니다.",
	},

	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "%d 개의 식물 감염.",
		spawn = "%s 후 게슈탈트 생성.",
		next_wave = "다음 웨이브 까지: %s",
		remain_waves = "남은 웨이브: %d",
	},

	-- lunarthrall_plant.lua [Prefab]
	lunarthrall_plant = {
		time_to_aggro = "무력화 종료까지: <color=%s>%.1f</color>",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "활성화까지: %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "완료까지: %s",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "누군가가 물고기 떼에 접근하길 기다리는 중.",
		time_to_respawn = "<prefab=malbatross>이(가) %s 후에 재생성됩니다.",
	},

	-- mast.lua
	mast_sail_force = "돛의 힘: %s",
	mast_max_velocity = "최대 속도: %s",

	-- mermcandidate.lua
	mermcandidate = "칼로리: %s / %s",

	-- messagebottlemanager.lua
	messagebottlemanager = "Treasures to grab: %d / %d",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>강인함</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color> - <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>강인함</color> 증가: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "무게추 무게: %s",
		mighty_gains = "평범한 <color=MIGHTINESS>리프트</color>: <color=MIGHTINESS>%+.1f</color>, 완벽한 <color=MIGHTINESS>리프트</color>: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>허기 소모</color>: <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "%s 초마다 트리거 확인.",
		inactive = "트리거 확인 안함.",
		beemine_bees = "%s 마리의 벌 방출.",
		trap_starfish_cooldown = "재무장까지: %s",
	},

	-- moisture.lua
	moisture = "<color=WET>습기</color>: <color=WET>%s%%</color>", --moisture = "<color=WET>습기</color>: %s / %s (%s%%)",

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "돛 & 닻 상호 작용 속도: {feature_speed}\n노 내구도 사용: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "배 피해 감소: {reduction}",

	-- mood.lua
	mood = {
		exit = "%s 일 후에 기분이 나아짐.",
		enter = "%s 일 후에 기분이 나빠짐.",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "목적지까지 진행: %s / %s",
			time_for_next_tool = "다음 도구 필요 시간: %s",
			experiment_time = "실험 완료 시간: %s",
		},
		storm_move = "%s%% 확률로 달 폭풍이 %s 일에 이동.",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>주기: %s</color>, %s",
		phase_locked = "<color=#CE3D45>고대의 열쇠</color>에 의해 고정됨.",
		announce_phase_locked = "현재 유적은 악몽 주기로 고정되었습니다.",
		announce_phase = "유적은 %s 주기입니다. (%s 남음)",
		phases = {
			["calm"] = "고요",
			["warn"] = "경고",
			["wild"] = "악몽",
			["dawn"] = "여명"
		},
	},

	-- oar.lua
	oar_force = "<color=INEDIBLE>힘</color>: <color=INEDIBLE>%s%%</color>",

	-- oceanfishingrod.lua
	oceanfishingrod = {
		hook = {
			interest = "관심: %.2f",
			num_interested = "관심 있는 물고기: %s",
		},
		battle = {
			tension = "팽팽함: <color=%s>%.1f</color> / %.1f<sub>줄 끊김</sub>",
			slack = "느슨함: <color=%s>%.1f</color> / %.1f<sub>물고기 도망</sub>",
			distance = "거리: %.1f<sub>포획</sub> / <color=%s>%.1f<sub>현재</sub></color> / %.1f<sub>도망</sub>",
		},
	},

	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "거리 보너스: %s",
			bonus_accuracy = "정확도 보너스: <color=#66CC00>%+.1f%%<sub>최소</sub></color> / <color=#5B63D2>%+.1f%%<sub>최대</sub></color>",
		},
		lure = {
			charm = "매력: <color=#66CC00>%.1f<sub>기본</sub></color> + <color=#5B63D2>%.1f<sub>줄 감기</sub></color>",
			stamina_drain = "보너스 스태미너 소모: %.1f",
			time_of_day_modifier = "시간대 효율: <color=DAY_BRIGHT>%d%%<sub>낮</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>저녁</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>밤</sub></color>",
			weather_modifier = "날씨 효율: <color=#bbbbbb>%d%%<sub>맑음</sub></color> / <color=#7BA3F2>%d%%<sub>비</sub></color> / <color=FROZEN>%d%%<sub>눈</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "거대 성장 진행도: %s / %s",

	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>나이</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "<color=#E3D740>금</color> 레벨: %.1f / %.1f",
		gold_level = "<color=#E3D740>금</color> 레벨: %.1f",
	},

	-- parryweapon.lua
	parryweapon = {
		parry_duration = "패링 지속 시간: {duration}",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "부패",
		stale = "오래된",
		spoil = "상한",
		dies = "죽음",
		starves = "굶주림",
		transition = "<color=MONSTER>{next_stage}</color> 상태까지: {time}",
		transition_extended = "<color=MONSTER>{next_stage}</color> 상태까지: {time} (<color=MONSTER>{percent}%</color>)",
		paused = "부패 일시 중지됨.",
	},

	-- petrifiable.lua
	petrify = "%s 후 석화됨.",

	-- pickable.lua
	pickable = {
		regrowth = "<color=NATURE>재성장</color>: <color=NATURE>%s</color>",
		regrowth_paused = "재성장 일시 중지됨.",
		cycles = "<color=DECORATION>남은 수확 횟수</color>: <color=DECORATION>%s</color> / <color=DECORATION>%s</color>",
		mushroom_rain = "<color=WET>비</color> 필요: %s",
	},

	-- planardamage.lua
	planardamage = {
		planar_damage = "<color=PLANAR>차원 데미지</color>: <color=PLANAR>%s</color>",
		additional_damage = " (<color=PLANAR>+%s<sub>보너스</sub></color>)",
	},

	-- planardefense.lua
	planardefense = {
		planar_defense = "<color=PLANAR>차원 방어력</color>: <color=PLANAR>%s</color>",
		additional_defense = " (<color=PLANAR>+%s<sub>보너스</sub></color>)",
	},

	-- poisonable.lua
	poisonable = {
		remaining_time = "<color=NATURE>독</color>이 %s 후 종료됨.",
	},
	
	-- pollinator.lua
	pollination = "수분된 꽃: (%s) / %s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "내 <prefab=polly_rogers>이(가) %s 후에 재생성됩니다."
	},

	-- preservative.lua
	preservative = "%s%% 신선도 회복.",

	-- preserver.lua
	preserver = {
		spoilage_rate = "<color=#ad5db3>부패율</color>: <color=#ad5db3>%.1f%%</color>",
		freshness_rate = "<color=FROZEN>신선도 회복</color>: <color=FROZEN>%.1f%%</color>",
	},

	-- quaker.lua
	quaker = {
		next_quake = "<color=INEDIBLE>다음 지진</color>까지: %s",
	},

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "남은 장난감: %s",
			assisted_by = "이 핍스푹은 %s의 도움을 받는 중.",
		},
	},

	-- rabbitkingmanager.lua
	rabbitkingmanager = {
		carrots = "<color=VEGGIE>Carrots</color>: <color=VEGGIE>%d</color> / <color=VEGGIE>%d</color>",
		naughtiness = "Naughtiness: %d / %d",
		king_status = "%s is alive.", -- Gets a prefab tag inserted with king type.
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>세계 습도</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>강수율</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>개구리 비 확률</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "샤드 Id: %s",
		shard_type = "샤드 유형: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "충전 시간: %s",
		charge = "충전: %s / %s"
	},

	-- repairer.lua
	repairer = {
		type = "수리 재료: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>체력 회복</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>HP 고정값</sub></color> + <color=HEALTH>%s%%<sub>HP 비율값</sub></color>",
		work = "<color=#DED15E>작동 수리</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>작동</sub></color>",
		perish = "<color=MONSTER>신선도 회복</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>신선도 회복</color>: <color=MONSTER>%s%%</color>",
		held_repair = "<color=SWEETENER><prefab=%s></color>은(는) <color=LIGHT>%s</color> 사용 회복 (<color=LIGHT>%s%%</color>).",
		materials = (IS_DST and {
			[MATERIALS.WOOD] =  "나무",
			[MATERIALS.STONE] =  "돌",
			[MATERIALS.HAY] =  "풀",
			[MATERIALS.THULECITE] =  "툴루사이트",
			[MATERIALS.GEM] =  "보석",
			[MATERIALS.GEARS] =  "톱니바퀴",
			[MATERIALS.MOONROCK] =  "월석",
			[MATERIALS.ICE] =  "얼음",
			[MATERIALS.SCULPTURE] =  "조각상",
			[MATERIALS.FOSSIL] =  "화석",
			[MATERIALS.MOON_ALTAR] =  "천상의 구조물",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "<color=#99635D>톱니바퀴</color> 필요: <color=#99635D>%s</color>",
	},

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL>이(가) %s 후 생성됩니다.",
		announce_spawn = "<prefab=LUNARRIFT_PORTAL>이(가) %s 후 생성됩니다.",

		stage = "단계: %d / %d", -- augmented by growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "소환할 수 없음."
	},

	-- roseglasseshat.lua [Prefab]
	roseglasseshat = {
		ready_to_use = "Ready to inspect",
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>추가 피해</color>: <color=HEALTH>%s</color>",
		absorption = "<color=HEALTH>피해 흡수</color>: <color=HEALTH>%s%%</color>",
		bonus_speed = "<color=DAIRY>추가 속도</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>정신력</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>계몽</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		interaction = "<color=SANITY>정신력</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = "<color=SANITY>정신력 오라</color>: <color=SANITY>%s/분</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "이미 열림.",
		chest_labyrinth = {
			sanity = "66% 확률로 <color=SANITY>정신력</color> 변화: <color=SANITY>-20 ~ +20</color>",
			hunger = "66% 확률로 <color=HUNGER>허기</color> 변화: <color=HUNGER>-20 ~ +20</color>",
			health = "66% 확률로 <color=HEALTH>체력</color> 변화: <color=HEALTH>0 ~ +20</color>",
			inventory = "66% 확률로 <color=LIGHT>내구도</color> 또는 <color=MONSTER>신선도</color> 변화: -20% ~ +20%",
			summonmonsters = "66% 확률로 <color=MOB_SPAWN>땅끝대롱거미</color> 1 ~ 3마리 소환.",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>그림자 레벨</color>: %s",
		level_diff = "<color=BLACK>그림자 레벨</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s 데미지</color>)",
		total_shadow_level = "<color=BLACK>그림자 레벨 총합</color>: %s",
	},

	-- shadowparasitemanager.lua
	shadowparasitemanager = {
		num_waves = "Waves: %d",
	}, 

	-- shadow_battleaxe.lua [Prefab]
	shadow_battleaxe = {
		level = "Level: %s / %s",
		boss_progress = "Defeated Bosses: %s / %s",
		lifesteal = "<color=HEALTH>Life Steal</color>: <color=HEALTH>%.2f</color> (<color=SANITY>%.2f</color>)",
	},

	-- shadowrift_portal.lua [Prefab]
	shadowrift_portal = {
		close = "<prefab=SHADOWRIFT_PORTAL>이(가) %s 후 닫힘.",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "%s에 의해 소환됨.",
			sanity_reward = "<color=SANITY>정신력</color> 보상: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>정신력</color> 보상: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- shadowthrall_mimics.lua
	shadowthrall_mimics = {
		mimic_count = "<string=UI.CUSTOMIZATIONSCREEN.ITEMMIMICS>: %s / %s",
		next_spawn = "<prefab=itemmimic_revealed> will try to spawn in %s",
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "다음 균열 활성화 준비까지: %s",
		waiting_for_players = "플레이어가 근처에 올 때까지 기다리는 중.",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		thralls_alive = "<color=MOB_SPAWN>Thralls alive (%d)</color>: %s",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color> 재생성까지: %s",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		trades_remaining = "남은 거래 횟수: %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "피난처 범위: %s 벽 단위",
		shelter = "피난처 ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>무기</color> 내구도 소모량 <color=#aaaaee>%s%%</color> 감소.",
			battlesong_healthgain = "공격 시 <color=HEALTH>%s 체력</color> 회복 (위그프리드: <color=HEALTH>%s</color>).",
			battlesong_sanitygain = "공격 시 <color=SANITY>%s 정신력 </color> 회복.",
			battlesong_sanityaura = "<color=SANITY>정신력 감소 오라</color> <color=SANITY>%s%%</color> 저항.",
			battlesong_fireresistance = "<color=LIGHT>화염 데미지</color> <color=HEALTH>%s%%</color> 저항.",
			battlesong_lunaraligned = "<color=LUNAR_ALIGNED>달 진영 적</color>에게 받는 피해 <color=HEALTH>%s%%</color> 감소.\n<color=SHADOW_ALIGNED>그림자 진영 적</color>에게 주는 피해 <color=HEALTH>%s%%</color> 증가.",
			battlesong_shadowaligned = "<color=SHADOW_ALIGNED>그림자 진영 적</color>에게 받는 피해 <color=HEALTH>%s%%</color> 감소.\n<color=LUNAR_ALIGNED>달 진영 적</color>에게 주는 피해 <color=HEALTH>%s%%</color> 증가.",

			battlesong_instant_taunt = "범위 내의 적을 도발함.",
			battlesong_instant_panic = "%s 초 동안 범위 내의 적을 패닉에 빠트림.",
			battlesong_instant_revive = "최대 %d 명의 아군을 되살림.",
		},
		cost = "사용 비용: <color=INSPIRATION>%s 영감</color>",
		cooldown = "악보 쿨타임: %s",
	},

	-- sinkholespawner.lua
	antlion_rage = "개미 사자가 %s 후에 격노합니다.",

	-- skinner_beefalo.lua
	skinner_beefalo = "무서움: %s, 화려함: %s, 단정함: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "%s 후 일어남.",
	},

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>회복</color>: <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>회복 범위</color>: <color=#DED15E>%s 타일</color>",

	-- spawner.lua
	spawner = {
		next = "<color=MOB_SPAWN><prefab={child_name}></color> 생성까지: {respawn_time}",
		child = "<color=MOB_SPAWN><prefab=%s></color> 생성.",
		occupied = "점유 중: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>웨버 회복</color>: <color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>거미 회복</color>: <color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>남은 타격 횟수</color>: <color=#aaaaee>%s</color>",
		time_to_reset = "%s 후 재설정." 
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>) 제작까지: %s 초",
		cooker = "<color=%s>%s</color>에 의해 요리됨.",
		cooktime_modifier_slower = "음식 조리 시간 <color=#DED15E>%s%%</color> 증가.",
		cooktime_modifier_faster = "음식 조리 시간 <color=NATURE>%s%%</color> 단축.",
	},

	-- stickable.lua
	stickable = "<color=FISH>조개 더미</color>: %s",

	-- support_pillar.lua [Prefab]
	support_pillar = {
		reinforcement = "Reinforcement: %s / %s",
		durability = "Durability: %s / %s",
	},

	-- support_pillar_dreadstone.lua [Prefab]
	support_pillar_dreadstone = {
		time_until_reinforcement_regen = "Next regeneration: %s",
	},

	-- temperature.lua
	temperature = "온도: <temperature=%s>",

	-- tentacle_pillar_hole.lua [Prefab]
	tentacle_pillar_hole = {
		immunity_time = "<prefab=tentacle> immunity time: %s",
	},

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "테라리움 비활성화 시 하루에 <color=HEALTH>%s</color> 체력 회복.",
		eot_health = "<prefab=eyeofterror> <color=HEALTH>체력</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>체력</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>체력</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium> 준비까지 남은 시간: %s",
	},

	-- tigersharker.lua
	tigershark_spawnin = "생성 가능: %s",
	tigershark_waiting = "생성 준비 완료.",
	tigershark_exists = "타이거 샤크가 존재함.",

	-- timer.lua
	timer = {
		label = "타이머 <color=#8c8c8c>'%s'</color>: %s",
		paused = "일시 중지됨.",
	},

	-- toadstoolspawner.lua
	toadstoolspawner = {
		time_to_respawn = "<prefab=toadstool>이(가) %s 후에 재생성됩니다.",
	},

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>효율성</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "%s 개의 금덩어리 가치.",
	tradable_gold_dubloons = "%s 개의 금덩어리와 %s 개의 금화 가치.",
	tradable_rocktribute = "<color=LIGHT>개미사자</color> 격노 지연: %s",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "단계 %s / %s: ",
	upgradeable_complete = "업그레이드 %s%% 완료.",
	upgradeable_incomplete = "업그레이드 불가능.",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "<color=HEALTH>최대 체력</color> <color=HEALTH>%d</color> 증가.",
			maxsanity = "<color=SANITY>최대 정신력</color> <color=SANITY>%d</color> 증가.",
			movespeed = "<color=DAIRY>이동 속도</color> %s 증가.",
			heat = "<color=#cc0000>최저 체온</color> <color=#cc0000>%d</color> 증가 (동결 면역).",
			heat_drying = "<color=#cc000>건조 속도</color> <color=#cc0000>%.1f</color> 증가.",
			cold = "<color=#00C6FF>최대 체온</color> <color=#00C6FF>%d</color> 감소 (과열 면역).",
			taser = "피격 시 적에게 <color=WET>%d</color> %s 반사 (쿨타임: %.1f).",
			light = "<color=LIGHT>발광 반경</color> <color=LIGHT>%.1f</color> 제공, (2개 장착 시 <color=LIGHT>%.1f</color> 반경 추가)",
			maxhunger = "<color=HUNGER>최대 허기</color> <color=HUNGER>%d</color> 증가.",
			music = "<color=SANITY>정신력 오라</color> <color=SANITY>%+.1f/분</color> 제공, 범위: <color=SANITY>%.1f</color> 타일.",
			music_tend = "주변 식물에게 말을 걸어줌, <color=NATURE>%.1f</color> 타일.",
			bee = "<color=HEALTH>%d 체력 재생/%d초</color> (<color=HEALTH>%d/일</color>).",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> 재생성: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>방수성</color>: <color=WET>%s%%</color>",
	
	-- watersource.lua
	watersource = "물의 원천.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "습기 증가: <color=WET>%s</color>"
	},

	-- wathgrithr_shield.lua [Prefab]
	wathgrithr_shield = {
		parry_duration_complex = "패링 지속 시간: <color=%s>%.1f<sub>일반</sub></color> | <color=%s>%.1f<sub>스킬</sub></color>",
	},
	
	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>데미지</color>",
		electric = "<color=WET>(전기)</color> <color=HEALTH>데미지</color>",
		poisonous = "<color=NATURE>(독성)</color> <color=HEALTH>데미지</color>",
		thorns = "<color=HEALTH>(가시)</color> <color=HEALTH>데미지</color>",
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "사정 거리: %s",

	-- weather.lua
	weather = {
		progress_to_rain = "<color=WET>비</color> 진행도", -- Numbers appended by code
		remaining_rain = "<color=WET>잔여 비</color>", -- Numbers appended by code

		progress_to_hail = "<color=LUNAR_ALIGNED>우박</color> 진행도", -- Numbers appended by code
		remaining_hail = "<color=LUNAR_ALIGNED>잔여 우박</color>", -- Numbers appended by code
	
		progress_to_acid_rain = "<color=SHADOW_ALIGNED>산성 <color=WET>비</color></color> 진행도", -- Numbers appended by code
		remaining_acid_rain = "<color=SHADOW_ALIGNED>잔여 산성 <color=WET>비</color></color>", -- Numbers appended by code
	},

	-- weighable.lua
	weighable = {
		weight = "무게: %s (%s%%)",
		weight_bounded = "무게: %s <= %s (%s) <= %s",
		owner_name = "소유자: %s"
	},

	-- werebeast.lua
	werebeast = "변이: %s / %s",

	-- wereness.lua
	wereness_remaining = "변이: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "집게 도르래 구성 요소가 있지만, Prefab 확인에 실패함.",
		sunken_item = "집게 도르래 아래에 <color=#66ee66>%s</color>가 있음.",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>세계 온도</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "<color=#DED15E>희귀한 선물</color>을 받을 <color=#bbffbb>자격</color>이 있음.",
		not_ready = "다음 <color=#DED15E>희귀한 선물</color>을 받으려면 <color=#ffbbbb>%s 일 더 기다려야함</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "상태 변경 지연: %s",
		wither = "시들기까지: %s",
		rejuvenate = "회복까지: %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>트리가드 확률</color>: %s%%<sub>당신</sub> & %s%%<sub>NPC</sub>",
		treeguard_chance = "<color=#636C5C>트리가드 확률</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "월드 이동 비활성화됨.",
		target_shard = "목표 샤드: %s",
		received_portal = "목표 포탈: %s", -- Shard Migrator
		id = "현재 포탈: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "월드 설정 타이머 <color=#8c8c8c>'%s'</color>: %s",
		paused = "일시 중지됨.",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "남은 충전 시간: %s",
		gain_charge_time = "충전: %d / %d, 다음 <color=LIGHT>충전</color>까지: <color=LIGHT>%s</color>",
		full_charge = "충전 완료됨!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "스캔 진행률: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "봉제 완료 시간: %s",
}