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

-- TheNet:GetLanguageCode() == "english" & LOC.GetLocaleCode() == "en"

return {
	-- insightservercrash.lua
	crash_reporter = {
		title = "[Insight Crash Reporter]",
		crashed = "The game has crashed.",
		report_status = {
			unknown = "Unknown",
			disabled = "The crash reporter is <color=#666666>disabled</color>: <color=#666666>%s</color>",
			sending = "Sending crash report",
			success = "Crash reported to Insight. <u>This does NOT mean that Insight caused the issue!</u>",
			failure = "Crash report failed to send (%s): %s",
		},
	},
	
	-- modmain.lua
	dragonfly_ready = "พร้อมต่อสู้แล้ว",

	-- time.lua
	time_segments = "%s เสี้ยววัน",
	time_days = "%s วัน, ",
	time_days_short = "%s วัน",
	time_seconds = "%s วินาที",
	time_minutes = "%s นาที, ",
	time_hours = "%s ชั่วโมง, ",

	-- meh
	seasons = {
		autumn = "<color=#CE5039>ฤดูใบไม้ร่วง</color>",
		winter = "<color=#95C2F4>ฤดูหนาว</color>",
		spring = "<color=#7FC954>ฤดูใบไม้ผลิ</color>",
		summer = "<color=#FFCF8C>ฤดูร้อน</color>",
	},

	-- Keybinds
	unbind = "ลบคีย์ลัด",
	keybinds = {
		label = "คีย์ลัด (คีย์บอร์ดเท่านั้น)",
		togglemenu = {
			name = "เปิดเมนู Insight",
			description = "เปิด/ปิดเมนูของ Insight"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[อันตราย]: ",
		boss = "[แจ้งเตือนบอส]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "มือใหม่",
				description = "ข้อมูลพอเหมาะสำหรับคนที่เพิ่งเคยเล่นเกมนี้"
			},
			simple = {
				label = "เรียบง่าย",
				description = "ข้อมูลเรียบง่าย จะคล้ายๆ ม็อด Show Me",
			},
			decent = {
				label = "พอประมาณ",
				description = "แสดงข้อมูลไม่เยอะมาก จะใกล้เคียงกับการตั้งค่าเริ่มต้น",
			},
			advanced = {
				label = "ขั้นสูง",
				description = "เหมาะสำหรับคนที่ต้องการข้อมูลเยอะๆ",
			},
		},
	},

	-- Insight Menu
	insightmenu = {
		tabs = {
			world = "โลก",
			player = "ผู้เล่น",
		},
	},

	indicators = {
		dismiss = "ปิด %s ทิ้ง",
	},

	-- Damage helper
	damage_types = {
		-- Normal
		explosive = "ประเภทระเบิด",
		
		-- Planar
		lunar_aligned = "ประเภทพระจันทร์",
		shadow_aligned = "ประเภทเงา",
	},

	map = {
		land_exploration = "Land Explored: <color=%s>%.1f%%</color>",
	},

	-------------------------------------------------------------------------------------------------------------------------
	
	-- acidbatwavemanager.lua
	acidbatwavemanager = {
		chance = "Chance of bat raid: <color=%s>%.1f%%</color> (estimated=<color=%s>%.1f%%</color>)",
		next_wave_spawn = "<prefab=bat> raid (%d) arrives in %s"
	},

	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "ต้องการ<color=SANITY>ค่าสติ</color>อย่างน้อย <color=SANITY>%s</color> (<color=SANITY>%s%%</color>) เพื่อให้แสง",
		current_sanity = "<color=SANITY>ค่าสติ</color>ของคุณ: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "<color=ENLIGHTENMENT>Gestalt</color> จากมงกุฏจะทำ <color=HEALTH>%s</color> ดาเมจ",
	},
	
	-- ancienttree_seed.lua [Prefab]
	ancienttree_seed = {
		type = "ชนิด: <color=%s><prefab=%s></color>",
		fruit_regen_time = "เวลาออกผล: %s",
		fruit_regen_time_bounded = "เวลาออกผล: %s <= %s <= %s",
	},

	-- aoeweapon_base.lua
	aoeweapon_base = {
		--weapon_damage = "ดาเมจรอบตัว %s: <color=HEALTH>{damage}</color>",
	},

	-- aoeweapon_leap.lua
	aoeweapon_leap = {

	},

	-- aoeweapon_lunge.lua
	aoeweapon_lunge = {
		lunge_damage = "ท่าพุ่ง {damageType}: <color=HEALTH>{damage}</color>",
	},
	

	-- appeasement.lua
	appease_good = "ชะลอภูเขาไฟระเบิดได้ %s เสี้ยววัน",
	appease_bad = "เร่งภูเขาไฟระเบิดได้ %s เสี้ยววัน",

	-- appraisable.lua
	appraisable = "ความน่าเกรงขามชุด: %s, ความรื่นเริงชุด: %s, ความสุภาพชุด: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "จะปลดล็อค: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>การป้องกัน</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>ความคงทนเหลือ</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>ความคงทนเหลือ</color>: <color=#C0C0C0>%s</color>",

	-- armordreadstone.lua
	armordreadstone = {
		regen = "จะซ่อมแซม <color=%s>%.1f</color> <color=#C0C0C0>durability</color>/%ds",
		regen_complete = "จะซ่อมแซม <color=%s>%.1f<sub>min</sub></color> / <color=%s>%.1f<sub>current</sub></color> / <color=%s>%.1f<sub>max</sub></color> <color=#C0C0C0>ค่าความคงทน</color>/%ds โดยขึ้นอยู่กับค่าสติ"
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate> จะรีเซ็ตใน %s",
	},

	-- attunable.lua
	attunable = {
		linked = "ถูกผูกไว้กับ %s",
		offline_linked = "คนที่ผูกไว้แต่ออฟไลน์: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "จะเพิ่มพลังชีวิต <color=HEALTH>%s</color> ต่อการโจมตีหนึ่งครั้ง",
		sanity_cost = "จะลดค่าสติ <color=SANITY>%s</color> ต่อการโจมตีหนึ่งครั้ง",
	},

	-- beard.lua
	beard = "หนวดจะโตในอีก %s วัน",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>จะไปเกิดที่: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger> จะเกิดที่ %s (<prefab=%s>) ในอีก %s",
		bearger_attack = "<prefab=bearger> จะโจมตีในอีก %s"
	},

	-- beef_bell.lua [Prefab]
	beef_bell = {
		beefalo_name = "ชื่อ: %s",
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen>จะเกิดใหม่ในอีก %s",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "แรงลากเรือ: %.5f",
		max_velocity_mod = "ความเร็วสูงสุด: %.3f",
		force_dampening = "แรงหน่วง: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- book.lua
	book = {
		wickerbottom = {
			tentacles = "สามารถเรียก<color=%s>หนวด %d</color> ตัว",
			birds = "สามารถเรียกนกได้สูงสุด <color=%s>%d</color> ตัว",
			brimstone = "สามารถเรียก<color=%s>ฟ้าผ่า %d</color> ครั้ง",
			horticulture = "เร่งโตให้พืชได้สูงสุด <color=%s>%d ต้น</color>",
			horticulture_upgraded = "เร่งโตและถนอมพืชได้สูงสุด <color=%s>%d ต้น</color>",
			--silviculture = "จะเร่งโตพืชประเภททรัพยากร",
			--fish = "",
			--fire = ""
			web = "สามารถเรียก<color=%s>ใยแมงมุมบนพื้น</color>ได้ ซึ่งจะอยู่ได้ <color=%s>%s</color>",
			--temperature = ""
			light = "สามารถเรียก<color=LIGHT>แสง</color>ออกมาได้ ซึ่งจะอยู่ได้ <color=LIGHT>%s</color>",
			-- light_upgraded is just light
			rain = "สามารถเรียกหรือไล่<color=WET>ฝน</color> และจะ<color=WET>รดน้ำพืชโดยรอบ</color>ได้",
			bees = "สามารถเรียก<color=%s>ผึ้ง %d ตัว</color>ได้ และเสกได้สูงสุด <color=%s>%d</color>",
			research_station = "จะให้สูตรคราฟท์: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "สามารถเรียก <color=%s>อุกกาบาตจำนวน %d</color> ลูกได้",
		},
	},

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>ปลาเขตร้อน</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>เพอร์เพิล กรุ๊ปเปอร์</color>",
	breeder_fish4 = "<color=#DED15E>ปลาพีเอโร่ต์</color>",
	breeder_fish5 = "<color=#9ADFDE>นีออน ควอตโตร</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "จะมีปลาเพิ่มในอีก %s",
	breeder_possiblepredatortime = "อาจจะมีอะไรมากินปลาในอีก %s",

	-- brushable.lua
	brushable = {
		last_brushed = "แปรงขนล่าสุด %s วันที่แล้ว"
	},

	-- burnable.lua
	burnable = {
		smolder_time = "จะ<color=LIGHT>ไหม้</color>ในอีก <color=LIGHT>%s</color>",
		burn_time = "เวลา<color=LIGHT>ไหม้</color>ที่เหลือ: <color=LIGHT>%s</color>",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "ค่าประดับงานคาร์นิวัล: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "หายาก",
			uncommon = "ไม่พบบ่อย",
			common = "หาได้ทั่วไป",
			unknown = "ไม่ทราบ",
		},
		shape = "รูปทรง: %s",
		rarity = "ความหายาก: %s",
		season = "ฤดู: %d",
		undecided = "ต้องวางลงก่อนที่จะให้ข้อมูลได้"
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>ระดับ</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "จำนวนของประดับ: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>ค่าความเป็นพิษ</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "โอกาสที่นกจะ<color=#522E61>ป่วย</color>: <color=#D8B400>%d%%</color>",
		gas_level_increase = "จะเพิ่มในอีก %s",
		gas_level_decrease = "จะลดลงในอีก %s"
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "ชีวิตแมวที่เหลือ: %s / %s",
		regenerate = "แมวจะกลับมาในอีก %s",
		waiting_for_sleep = "กำลังรอให้ผู้เล่นเดินออกห่าง",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "กำลังรอให้คุณกลับไปจุดที่ฆ่าสัตว์น้ำไว้",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> จะเกิดใหม่ในอีก %s",
	announce_chester_respawn = "My <prefab=chester> จะเกิดใหม่ในอีก %s",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>อยู่ข้างใน</sub> + %s<sub>อยู่ข้างนอก</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>อยู่ข้างใน</sub> + %s<sub>อยู่ข้างนอก</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "{to_regen} กำลังจะเกิดใหม่ในอีก {regen_time}",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>ดาเมจ</color>: <color=HEALTH>%s</color>",
		damageToYou = " (<color=HEALTH>%s</color> หากโดนคุณ)",
		age_damage = "<color=HEALTH>ดาเมจ <color=AGE>(เป็นอายุ)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> หากโดนคุณ)",
		yotr_pillows = {
			--@@ Weapons
			knockback = "<color=VEGGIE>แรงกระเด็น</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "Knockback Multiplier: %s",
			laglength = "<color=VEGGIE>คูลดาวน์</color>: %s",
			
			--@@ Armor
			defense_amount = "<color=VEGGIE>ค่าการป้องกัน</color>: %s",
			
			--@@ Both
			prize_value = "มูลค่ารางวัล: %s",
		},
	},

	-- compostingbin.lua
	compostingbin = {
		contents_amount = "ของในถัง: %s / %s",
		detailed_contents_amount = "ของในถัง: <color=NATURE>%s<sub>เขียว</sub></color> + <color=INEDIBLE>%s<sub>น้ำตาล</sub></color> / %s",
	},

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "คูลดาวน์: %s",

	-- crabkingspawner.lua
	crabkingspawner = {
		crabking_spawnsin = "%s",
		time_to_respawn = "<prefab=crabking>จะเกิดใหม่ในอีก %s",
	},

	-- crittertraits.lua
	dominant_trait = "Dominant trait: %s",

	-- crop.lua
	crop_paused = "การเติบโตหยุดอยู่",
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "ขั้นเพลง: %s / %s",
		note = ", โน้ตเพลง: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> ดาเมจต่อสิ่งมีชีวิต %s",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> ดาเมจจากสิ่งมีชีวิต %s",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>ค่าสติ</color>: <color=SANITY>%s/min</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER> จะเกิดใหม่ในอีก %s วัน",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>บัฟ:</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = {
			name = "<color=HEALTH>บัฟดาเมจ</color>",
			description = "เพิ่มดาเมจ <color=HEALTH>{percent}% ให้คุณ</color>เป็นเวลา {duration} วินาที",
		},
		["buff_playerabsorption"] = {
			name = "<color=MEAT>Damage absorption</color>",
			description = "รับดาเมจน้อยลง <color=MEAT>{percent}%</color> เป็นเวลา {duration} วินาที",
		},
		["buff_workeffectiveness"] = {
			name = "<color=SWEETENER>Work efficiency</color>",
			description = "ทำงานไวขึ้น <color=#DED15E>{percent}%</color> เมื่อใช้อุปกรณ์เป็นเวลา {duration} วินาที",
		},
		
		["buff_moistureimmunity"] = {
			name = "<color=WET>Moisture immunity</color>",
			description = "คุณไม่สามารถรับ<color=WET>ค่าความชื้น</color>ได้เป็นเวลา {duration} วินาที",
		},
		["buff_electricattack"] = {
			name = "<color=WET>Electric attacks</color>",
			description = "การโจมตีของคุณจะติด <color=WET>ช็อต</color>เป็นเวลา {duration} วินาที",
		},
		["buff_sleepresistance"] = {
			name = "<color=MONSTER>Sleep resistance</color>",
			description = "คุณต้านทาน<color=MONSTER>ความง่วง</color>เป็นเวลา {duration} วินาที",
		},
		
		["healingsalve_acidbuff"] = {
			name = "<color=#ded15e>Acid Resistance</color>",
			description = "คุณไม่ได้รับผลของ<color=#ded15e>ฝนกรด</color>เป็นเวลา {duration} วินาที"
		},
		["tillweedsalve_buff"] = {
			name = "<color=HEALTH>Health regeneration</color>",
			description = "ฟื้นฟูค่า<color=HEALTH>พลังชีวิต {amount} หน่วย</color>ภายในเวลา {duration} วินาที",
		},
		["healthregenbuff"] = {
			name = "<color=HEALTH>Health regeneration</color>",
			description = "ฟื้นฟูค่า<color=HEALTH>พลังชีวิต {amount} หน่วย</color>ภายในเวลา {duration} วินาที",
		},
		["sweettea_buff"] = {
			name = "<color=SANITY>Sanity regeneration</color>",
			description = "ฟื้นฟู<color=HEALTH>ค่าสติ {amount} หน่วย</color>ภายในเวลา {duration} วินาที",
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
			name = "<color=FROZEN>Winter's Feast Buff</color>",
			description = "ฟื้นฟู<color=HUNGER>ค่าความหิว</color>, <color=SANITY>ค่าสติ</color>, และ<color=HEALTH>ค่าพลังชีวิต</color>."
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER><prefab=batnosehat> Buff</color>",
			description = "ฟื้นฟู<color=HUNGER>ค่าความหิว {amount} หน่วย</color>ภายในเวลา {duration} วินาที",
		},
		
		["halloweenpotion_health_buff"] = {
			name = "<color=HEALTH>กำลังฟื้นฟูค่าพลังชีวิต</color>",
			description = nil
		},
		["halloweenpotion_sanity_buff"] = {
			name = "<color=SANITY>กำลังฟื้นฟูค่าสติ</color>",
			description = nil
		},
		["halloweenpotion_bravery_small_buff"] = {
			name = "คุณจะ<color=SANITY>ไม่เกรงกลัว</color>ฝูงค้างคาว",
			description = nil
		},
		["halloweenpotion_bravery_large_buff"] = (function(parent)
			return deepcopy(parent.halloweenpotion_bravery_small_buff)
		end)
	},

	-- deerclopsspawner.lua
	deerclopsspawner = {
		incoming_deerclops_targeted = "<color=%s>จะไปเกิดที่: %s</color> -> %s",
		announce_deerclops_target = "<prefab=deerclops> จะเกิดที่ %s (<prefab=%s>) ในอีก %s",
		deerclops_attack = "<prefab=deerclops> จะโจมตีในอีก %s",
	},

	-- diseaseable.lua
	disease_in = "จะติดเชื้อในอีก: %s",
	disease_spread = "จะแพร่เชื้อในอีก: %s",
	disease_delay = "การแพร่เชื้อถูกเว้นระยะไป: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "ความเชื่อง: %s%%",
		obedience = "ความเชื่อฟัง: %s%%",
		--obedience_extended = "Obedience: %s%% (%s%%<sub>to saddle</sub>, <%s%%<sub>buck saddle</sub>, %s%%<sub>to ride</sub>)",
		obedience_extended = "ความเชื่อง: %s%% (<%s%%<sub>จะสะบัดอาน</sub>, %s%%<sub>เป็นอย่างน้อย</sub>)",
		tendency = "ประเภทของบีฟาโล่: %s",
		tendencies = {
			["NONE"] = "ไม่มี",
			[TENDENCY.DEFAULT] = "ธรรมดา",
			[TENDENCY.ORNERY] = "นักสู้",
			[TENDENCY.RIDER] = "นักวิ่ง",
			[TENDENCY.PUDGY] = "แก้มป่อง"
		},
	},

	-- dragonfly_spawner.lua [Prefab]
	dragonfly_spawner = {
		time_to_respawn = "<prefab=dragonfly>จะเกิดใหม่ในอีก %s",
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "ขณะนี้ยังตากต่อไม่ได้",
	dry_time = "ตากเสร็จในอีก %s",

	-- eater.lua
	eater = {
		eot_loot = "อาหารที่ถืออยู่ รวม<color=HUNGER>ค่าอาหาร %s%%</color>และ<color=HEALTH>ค่าพลังชีวิต %s%%</color> จะซ่อมแซมความคงทนได้",
		eot_tofeed_restore = "<color=MEAT><prefab=%s></color> จะซ่อมแซมความคงทนได้ <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) หน่วย",
		eot_tofeed_restore_advanced = "<color=MEAT><prefab=%s></color> จะซ่อมแซมความคงทนได้ <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) หน่วย",
		tofeed_restore = "<color=MEAT><prefab=%s></color> สามารถซ่อมแซมได้ %s หน่วย",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> หน่วยประเภท<color=%s>%s</color>", 
	edible_interface = "<color=HUNGER>ค่าความหิว</color>: <color=HUNGER>%s</color> / <color=SANITY>ค่าสติ</color>: <color=SANITY>%s</color> / <color=HEALTH>ค่าพลังชีวิต</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>ค่าพลังชีวิต</color>: <color=HEALTH>%s</color> / <color=HUNGER>ค่าความหิว</color>: <color=HUNGER>%s</color> / <color=SANITY>ค่าสติ</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "เนื้อ",
		monster = "ประหลาด",
		fish = "ปลา",
		veggie = "ผัก",
		fruit = "ผลไม้",
		egg = "ไข่",
		sweetener = "หวาน",
		frozen = "แช่แข็ง",
		fat = "ไขมัน",
		dairy = "นม",
		decoration = "ของตกแต่ง",
		magic = "เวทย์",
		precook = "สำเร็จรูป",
		dried = "ตากแห้ง",
		inedible = "กินไม่ได้",
		bug = "แมลง",
		seed = "เมล็ด",
		antihistamine = "แก้ภูมิแพ้", -- Only "cutnettle"
	},
	edible_foodeffect = {
		temperature = "อุณหภูมิ: %s, %s",
		caffeine = "ความเร็วเคลื่อนที่: %s, %s",
		surf = "ความเร็วล่องเรือ: %s, %s",
		autodry = "โบนัสลดความชื้น: %s, %s",
		instant_temperature = "อุณหภูมิ: %s, (มีผลทันที)",
		antihistamine = "ป้องกันภูมิแพ้เป็นเวลา: %ss",
	},
	foodmemory = "กินไปแล้วล่าสุด %s / %s, จะลืมในอีก %s",
	wereeater = "<color=MONSTER>เนื้อมอนสเตอร์</color>ที่กินไปแล้ว: %s / %s, จะลืมในอีก %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>ความเร็วเคลื่อนที่</color>: %s%%",
	hunger_slow = "<color=HUNGER>ชะลอความหิว</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>จะเร่งความหิว</color>: <color=HUNGER>%s%%</color>",
	insulated = "สามารถปกป้องคุณจากฟ้าผ่าได้",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>ดาเมจระเบิด</color>: %s",
	explosive_range = "<color=LIGHT>รัศมีระเบิด</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "จะโตออกมาเป็น <color=NATURE><prefab=%s></color>",
		nutrient_consumption = "Δสารอาหาร: [<color=NATURE>%d<sub>สารเร่งโต</sub></color>, <color=CAMO>%d<sub>ปุ๋ยหมัก</sub></color>, <color=INEDIBLE>%d<sub>ปุ๋ยคอก</sub></color>]",
		good_seasons = "ฤดูที่เหมาะ: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "ค่าความเครียด: %s",
		display = "ตัวการทำเครียด: %s",
		stress_tier = "ระดับความเครียด: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "ไม่มีเลย",
			[FARM_PLANT_STRESS.LOW] = "น้อย",
			[FARM_PLANT_STRESS.MODERATE] = "ปานกลาง",
			[FARM_PLANT_STRESS.HIGH] = "สูง",
		} or {}),
		categories = {
			["nutrients"] = "สารอาหารไม่พอ", -- missing nutrients
			["moisture"] = "ขาดน้ำ", -- needs water
			["killjoys"] = "วัชพืช", -- weeds nearby
			["family"] = "ขาดครอบครัว", -- no similar plants nearby
			["overcrowding"] = "ความอัดแน่น", -- too crowded
			["season"] = "นอกฤดู", -- out of season
			["happiness"] = "ไม่ได้ถนอม", -- not tended to
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>ความชื้น</color>: <color=WET>%s<sub>แปลง</sub></color>*",
		soil_plant = "<color=WET>ความชื้น</color>: <color=WET>%s<sub>แปลง</sub></color> (<color=WET>%s/min<sub>พืช</sub></color>)*",
		soil_plant_tile = "<color=WET>ความชื้น</color>: <color=WET>%s<sub>แปลง</sub></color> (<color=WET>%s<sub>พืช</sub></color> [<color=#2f96c4>%s<sub>แปลง</sub></color>])<color=WET>/min</color>*",
		soil_plant_tile_net = "<color=WET>ความชื้น</color>: <color=WET>%s<sub>แปลง</sub></color> (<color=WET>%s<sub>พืช</sub></color> [<color=#2f96c4>%s<sub>แปลง</sub></color> + <color=SHALLOWS>%s<sub>โลก</sub></color> = <color=#DED15E>%+.1f<sub>โดยรวม</sub></color>])<color=WET>/นาที</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "สารอาหาร: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>แปลง</sub>*",
		soil_plant = "สารอาหาร: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>แปลง</sub> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δพืช</sub>)*",
		--soil_plant_tile = "สารอาหาร: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>แปลง</sup> ([<color=#bee391>%+d<sub>F</sub></color>, <color=#7a9c6e>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>Δพืช</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		--soil_plant_tile = "สารอาหาร: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>แปลง</sup> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>Δพืช</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		soil_plant_tile = "สารอาหาร: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>แปลง</sub>   ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δพืช</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>แปลงΔ</sub>)",
		--soil_plant_tile_net = "สารอาหาร: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] + [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] = [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "เร่ง<color=NATURE>การเติบโต</color>ของพืช <color=NATURE>%s</color> วินาที",
		nutrient_value = "ค่าสารอาหาร: [<color=NATURE>%s<sub>สารเร่งโต</sub></color>, <color=CAMO>%s<sub>ปุ๋ยหมัก</sub></color>, <color=INEDIBLE>%s<sub>ปุ๋ยคอก</sub></color>]",
		wormwood = {
			formula_growth = "ใช้เร่งการ<color=LIGHT_PINK>ผลิบาน</color>ของคุณได้ <color=LIGHT_PINK>%s</color>",
			compost_heal = "<color=HEALTH>ฟื้นฟูค่าพลังชีวิต</color>ให้คุณได้ <color=HEALTH>{healing}</color> หน่วย ภายในเวลา <color=HEALTH>{duration}</color> วินาที",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "สามารถใช้น้ำทะเลเติมได้",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s / %s",
	actions = {
		USES_PLAIN = "ใช้ได้",
		TERRAFORM = "ขุดพื้น",
		GAS = "รมควัน", -- hamlet
		DISARM = "ตัดวงจร", -- hamlet
		PAN = "กรองตะกอน", -- hamlet
		DISLODGE = "แกะสลัก", -- hamlet
		SPY = "ตรวจสอบของ", -- hamlet
		THROW = "โยน", -- sw -- Action string is "Throw At"
		ROW_FAIL = "พายผิดจังหวะ",
		--ATTACK = "<string=ACTIONS.ATTACK.GENERIC>", --STRINGS.ACTIONS.ATTACK.GENERIC,
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>", --STRINGS.ACTIONS.POUR_WATER.GENERIC,
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>ปลาในบ่อ</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": ปลาจะเพิ่ม +1 ในอีก: %s",
	fish_wait_time = "จะใช้เวลา <color=SHALLOWS>%s วินาที</color>เพื่อจับปลา",

	-- fishingrod.lua
	fishingrod_waittimes = "เวลารอ: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "เวลาสูงสุดก่อนเสียปลา: <color=SHALLOWS>%s</color>",

	-- flotsamgenerator.lua
	flotsamgenerator = {
		messagebottle_cooldown = "<prefab=messagebottle>อันต่อไปจะมาในอีก: %s",
	},

	-- follower.lua
	leader = "ผู้นำ: %s",
	loyalty_duration = "เวลาจ้างที่เหลือ: %s",

	-- forcecompostable.lua
	forcecompostable = "สีในถังหมักปุ๋ย: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "มีโอกาส 20%% ที่จะประกอบผิดในอีก %s ชิ้น",
		correct = "ประกอบถูกต้องแล้ว",
		incorrect = "ประกอบไม่ถูกต้อง",
		gateway_too_far = "โครงกระดูกนี้สร้างไกลไป %s กระเบื้อง",
	},

	-- friendlevels.lua
	friendlevel = "ความเป็นมิตร: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "เป็นเชื้อเพลิง <color=LIGHT>%s</color> วินาที",
		fuel_verbose = "เป็นเชื้อเพลิง <color=LIGHT>%s</color> วินาที (ประเภท <color=LIGHT>%s</color>)",
		type = "ประเภทเชื้อเพลิง: %s",
		types = {
			BURNABLE = "เชื้อเพลิง",
			CAVE = "แสง", -- miner hat / lanterns, light bulbs n stuff
			CHEMICAL = "เชื้อเพลิง",
			CORK = "เชื้อเพลิง",
			GASOLINE = "แก๊สโซลีน", -- DS: not actually used anywhere?
			MAGIC = "ความคงทน", -- amulets that aren't refuelable (ex. chilled amulet)
			MECHANICAL = "ความคงทน", -- SW: iron wind
			MOLEHAT = "การมองกลางคืน", -- Moggles
			NIGHTMARE = "เชื้อเพลิงฝันร้าย",
			NONE = "เวลา", -- will never be refueled...............................
			ONEMANBAND = "ค่าความคงทน",
			PIGTORCH = "เชื้อเพลิง",
			SPIDERHAT = "ค่าความคงทน", -- Spider Hat
			TAR = "น้ำมัน", -- SW
			USAGE = "ค่าความคงทน",
		},
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>เชื้อเพลิง</color>คงเหลือ(<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color>คงเหลือ(<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>ประสิทธิภาพเชื้อเพลิง</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>เชื้อเพลิง</color>: <color=LIGHT>%s</color>",
		held_refuel = "<color=SWEETENER><prefab=%s></color>ที่ถืออยู่ จะเติมเชื้อเพลิงได้ <color=LIGHT>%s%%</color>",
	},

	-- gelblobspawner.lua
	gelblobspawner = {
		
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>ค่าความผูกพันธ์</color>: %s / %s.",
		flower = "<color=%s>ค่าความผูกพันธ์ของคุณ</color>: %s / %s. ",
		levelup = " +1 ในอีก %s",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "ฟื้นฟูพลังชีวิต <color=HEALTH>%s</color> หน่วย ภายในเวลา %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
		ghostlyelixir_fastregen = "ฟื้นฟูพลังชีวิต <color=HEALTH>%s</color> หน่วย ภายในเวลา %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
		ghostlyelixir_attack = "ทำให้<color=HEALTH>ดาเมจ</color>สูงสุด เป็นเวลา %s",
		ghostlyelixir_speed = "เพิ่ม<color=DAIRY>ความเร็ว</color>โดย <color=DAIRY>%s%%</color> เป็นเวลา %s",
		ghostlyelixir_shield = "เพิ่มระยะเวลาโล่ขึ้นเป็น 1 วินาที เป็นเวลา %s",
		ghostlyelixir_retaliation = "โล่จะสะท้อน <color=HEALTH>%s ดาเมจ</color> เป็นเวลา %s", -- concatenated with shield
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "<color=#737CD0><prefab=%s></color> เหลืออีก: %s",
	},

	-- growable.lua
	growable = {
		stage = "ขั้น <color=#8c8c8c>'%s'</color>: %s / %s: ",
		paused = "การเติบโตหยุดอยู่",
		next_stage = "ขั้นต่อไปในอีก %s",
	},

	-- grower.lua
	harvests = "<color=NATURE>เก็บได้อีก</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 ในอีก %s",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "ความอึดอัด: %s / %s",
		progress = "เวลาฟัก: %s / %s",
	},

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>พลังชีวิต</color>: <color=HEALTH>%+d</color>",
		webber_heal = "ฟื้นฟู<color=HEALTH>พลังชีวิต</color>ให้ Webber: <color=HEALTH>%+d</color> หน่วย",
		spider_heal = "ฟื้นฟู<color=HEALTH>พลังชีวิต</color>ให้แมงมุม: <color=HEALTH>%+d</color> หน่วย",
	},

	-- health.lua
	health = "<color=HEALTH>พลังชีวิต</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%s วินาที</color>)",
	absorption = " : กันดาเมจอยู่ %s%%",
	naughtiness = "ค่ากรรม: %s",
	player_naughtiness = "ค่ากรรมของคุณ: %s / %s",

	-- heatrock.lua [Prefab]
	heatrock_temperature = "อุณหภูมิ: %s < %s < %s",

	-- herdmember.lua
	herd_size = "ขนาดฝูง: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "ระยะซ่อนแอบ: %s to %s",
		needed_hiding_spots = "จุดซ่อนแอบที่ต้องมีอีก: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "<prefab=hound>จะโจมตีในอีก %s",
		time_until_worms = "<prefab=worm>จะโจมตีในอีก %s",
		time_until_worm_boss = "<prefab=worm_boss>จะโจมตีในอีก %s",
		time_until_crocodog = "<prefab=crocodog>จะโจมตีในอีก %s",
		worm_boss_chance = "โอกาสเกิดของ<prefab=worm_boss>: %.1f%%",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>ค่าอาหาร</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>เผาผลาญ</color>: <color=HUNGER>%+d/วัน</color> (<color=HUNGER>%s/วินาที</color>)",
	hunger_paused = "<color=HUNGER>ค่าอาหาร</color>หยุดอยู่ขณะนี้",

	-- hunter.lua
	hunter = {
		hunt_progress = "รอยเท้าที่: %s / %s",
		impending_ambush = "จะมีการซุ่มโจมตีที่รอยเท้าต่อไป",
		alternate_beast_chance = "มีโอกาส <color=#b51212>%s%%</color> ที่จะเป็น<color=MOB_SPAWN>หมาป่าจ่าฝูง</color>หรือ<color=MOB_SPAWN>แกะขนเหล็ก</color>.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> จะเกิดใหม่ในอีก %s",
	announce_hutch_respawn = "<prefab=hutch>ของฉันจะเกิดใหม่ในอีก %s",

	-- inspectable.lua
	wagstaff_tool = "ชื่อของเครื่องมือนี้คือ: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "ค่าออกกำลังกายในยิม: %s",
	ruins_statue_gem = "มี<color=%s><prefab=%s></color>อยู่",

	-- inspectacleshat.lua [Prefab]
	inspectacleshat = {
		ready_to_use = "พร้อมใช้งานแล้ว",
	},

	-- insulator.lua
	insulation_winter = "<color=FROZEN>ค่ากันหนาว</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>ค่ากันร้อน</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		head_describe = "[หมวก]: ",
		hands_describe = "[อุปกรณ์]: ",
	},

	-- itemmimic.lua
	itemmimic = {
		time_to_reveal = "<prefab=itemmimic_revealed>จะปรากฏตัวในอีก %s",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "จำนวนคิทคูน: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>รางวัลปีนี้</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "จะหายวันที่ %s",
		announce_despawn = "<prefab=klaus_sack>จะหายไปวันที่ %s",
		announce_spawn = "<prefab=klaus_sack>จะเกิดตอนวันที่ %s",
	},

	-- leader.lua
	followers = "ผู้ติดตาม: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "ระยะป้องกันฟ้าผ่า: %s หน่วยกำแพง",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "จะหายช็อตในอีก %s วัน",

	-- linkeditem.lua
	linkeditem = {
		owner = "เจ้าของ: %s",
	},

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>เก็บได้</sub> / %d<sub>ทั้งหมด</sub> / %d<sub>สูงสุด</sub>", -- I can't think of a way to word 
		next_crystal = "Next <color=#4093B2><prefab=lunarrift_crystal_big></color>จะเกิดในอีก %s",
		close = "<prefab=LUNARRIFT_PORTAL>จะปิดในอีกประมาณ %s",
	},

	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "มีพืช %d ต้นถูกยึดไว้",
		spawn = "Gestalt จะเกิดในอีก %s",
		next_wave = "รอบถัดไปในอีก %s",
		remain_waves = "%d รอบที่เหลือ",
	},

	-- lunarthrall_plant.lua [Prefab]
	lunarthrall_plant = {
		time_to_aggro = "จะหายสตั้นในอีก <color=%s>%.1f</color>",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "จะเริ่มล่อเหยื่อในอีก %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "จะเสร็จในอีก %s",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "กำลังรอให้ผู้เล่นไปแหล่งปลาน้ำลึก",
		time_to_respawn = "<prefab=malbatross>จะเกิดใหม่ในอีก %s",
	},

	-- mast.lua
	mast_sail_force = "กำลังใบเรือ: %s",
	mast_max_velocity = "ความเร็วสูงสุด: %s",

	-- mermcandidate.lua
	mermcandidate = "แคลอรี่: %s / %s",

	-- messagebottlemanager.lua
	messagebottlemanager = "สมบัติที่เก็บได้: %d / %d",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>ความแข็งแกร่ง</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color> - <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>ความแข็งแกร่ง</color>ต่อการใช้งาน: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "น้ำหนักยิมปัจจุบัน: %s",
		mighty_gains = "<color=MIGHTINESS>ยกกล้าม</color>ปกติ: <color=MIGHTINESS>%+.1f</color>, <color=MIGHTINESS>ยกกล้าม</color>สมบูรณ์แบบ: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>จะลดค่าอาหาร</color> <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "กำลังเช็คทุกๆ %s วินาที",
		inactive = "ขณะนี้ยังไม่เช็คอะไร",
		beemine_bees = "จะปล่อยผึ้ง %s ตัว",
		trap_starfish_cooldown = "จะกลับมาใช้ได้ในอีก %s",
	},

	-- moisture.lua
	moisture = "<color=WET>ค่าความชื้น</color>: <color=WET>%s%%</color>", --moisture = "<color=WET>Wetness</color>: %s / %s (%s%%)",

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "ความเร็วตอบสนองใบเรือและสมอ: {feature_speed}\nใช้ไม้พายดีขึ้น: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "ลดดาเมจต่อเรือ {reduction}",

	-- mood.lua
	mood = {
		exit = "จะออกช่วงผสมพันธุ์ในอีก %s วัน",
		enter = "จะเข้าช่วงผสมพันธุ์ในอีก %s วัน",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "จะถึงจุดหมาย: %s / %s",
			time_for_next_tool = "ต้องการอุปกรณ์ในอีก %s",
			experiment_time = "การทดลองจะสำเร็จในอีก %s",
		},
		storm_move = "จะมีโอกาส %s%% ที่พายุพระจันทร์จะเปลี่ยนที่เช้าวันที่ %s",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>เฟสปัจจุบัน: %s</color>, %s",
		phase_locked = "ถูกล็อคโดย<color=#CE3D45>กุญแจโบราณ</color>",
		announce_phase_locked = "ขณะนี้เมืองโบราณถูกล็อคในเฟสฝันร้าย",
		announce_phase = "ขณะนี้เมืองโบราณอยู่ในเฟส%s (เหลืออีก %s)",
		phases = {
			["calm"] = "สงบ",
			["warn"] = "เตือน",
			["wild"] = "ฝันร้าย",
			["dawn"] = "กำลังสงบ"
		},
	},

	-- oar.lua
	oar_force = "<color=INEDIBLE>แรงผลัก</color>: <color=INEDIBLE>%s%%</color>",

	-- oceanfishingrod.lua
	oceanfishingrod = {
		hook = {
			interest = "ความสนใจ: %.2f",
			num_interested = "จำนวนปลาที่สนเหยื่อ: %s",
		},
		battle = {
			tension = "ความตึง: <color=%s>%.1f</color> / %.1f<sub>สายขาด</sub>",
			slack = "ความหย่อน: <color=%s>%.1f</color> / %.1f<sub>ปลาหนีเบ็ต</sub>",
			distance = "ระยะ: %.1f<sub>จับได้</sub> / <color=%s>%.1f<sub>ปัจจุบัน</sub></color> / %.1f<sub>ปลาหนี</sub>",
		},
	},

	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "โบนัสระยะ: %s",
			bonus_accuracy = "โบนัสความแม่นยำ: <color=#66CC00>%+.1f%%<sub>ต่ำสุด</sub></color> / <color=#5B63D2>%+.1f%%<sub>สูงสุด</sub></color>",
		},
		lure = {
			charm = "ค่าล่อปลา: <color=#66CC00>%.1f<sub>พื้นฐาน</sub></color> + <color=#5B63D2>%.1f<sub>หากดึงเบ็ต</sub></color>",
			stamina_drain = "ปลาหมดแรงง่ายขึ้น %.1f",
			time_of_day_modifier = "ล่อปลาได้ดีช่วง: <color=DAY_BRIGHT>%d%%<sub>กลางวัน</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>เย็น</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>กลางคืน</sub></color>",
			weather_modifier = "ล่อในอากาศดังนี้ได้: <color=#bbbbbb>%d%%<sub>ฟ้าสว่าง</sub></color> / <color=#7BA3F2>%d%%<sub>ฝนตก</sub></color> / <color=FROZEN>%d%%<sub>หิมะตก</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "ระดับการโตเป็นต้นใหญ่: %s / %s",

	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>อายุ</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "ระดับ<color=#E3D740>ทองคำ</color>: %.1f / %.1f",
		gold_level = "ระดับ<color=#E3D740>ทองคำ</color>: %.1f",
	},

	-- parryweapon.lua
	parryweapon = {
		parry_duration = "ระยะเวลาปัดป้อง: {duration}",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "จะเน่าเสียใน",
		stale = "จะเหม็นบูดใน",
		spoil = "จะเหม็นเน่าใน",
		dies = "จะตายใน",
		starves = "จะอดอยากใน",
		transition = "<color=MONSTER>{next_stage}</color> ใน {time}",
		transition_extended = "<color=MONSTER>{next_stage}</color> ใน {time} (<color=MONSTER>{percent}%</color>)",
		paused = "ขณะนี้ไม่เน่าเสีย",
	},

	-- petrifiable.lua
	petrify = "จะกลายเป็นหินใน %s",

	-- pickable.lua
	pickable = {
		regrowth = "จะ<color=NATURE>โตใหม่</color>ใน: <color=NATURE>%s</color>",
		regrowth_paused = "การเติบโตหยุดอยู่",
		cycles = "<color=DECORATION>เก็บได้อีก</color>: <color=DECORATION>%s</color> / <color=DECORATION>%s</color>",
		mushroom_rain = "<color=WET>ปริมาณฝน</color>ที่ต้องการ: %s",
	},

	-- planardamage.lua
	planardamage = {
		planar_damage = "<color=PLANAR>Planar Damage</color>: <color=PLANAR>%s</color>",
		additional_damage = " (<color=PLANAR>+%s<sub>bonus</sub></color>)",
	},

	-- planardefense.lua
	planardefense = {
		planar_defense = "<color=PLANAR>Planar Defense</color>: <color=PLANAR>%s</color>",
		additional_defense = " (<color=PLANAR>+%s<sub>bonus</sub></color>)",
	},

	-- poisonable.lua
	poisonable = {
		remaining_time = "<color=NATURE>พิษ</color>จะหมดฤทธิ์ใน %s",
	},
	
	-- pollinator.lua
	pollination = "ผสมเกสรไปแล้ว (%s) / %s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "<prefab=polly_rogers>ของฉันจะเกิดใหม่ในอีก %s"
	},

	-- preservative.lua
	preservative = "คืนความสดอาหารได้ %s%%",

	-- preserver.lua
	preserver = {
		spoilage_rate = "<color=#ad5db3>ความเร็วการเน่าเสีย</color>: <color=#ad5db3>%.1f%%</color>",
		freshness_rate = "<color=FROZEN>ความเร็วการคืนความสด</color>: <color=FROZEN>%.1f%%</color>",
	},

	-- quaker.lua
	quaker = {
		next_quake = "จะเกิด<color=INEDIBLE>แผ่นดินไหว</color>ในอีก %s",
	},

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "ของเล่นที่เหลือ: %s",
			assisted_by = "ผีเด็กตนนี้กำลังถูกช่วยเหลือโดย %s",
		},
	},

	-- rabbitkingmanager.lua
	rabbitkingmanager = {
		carrots = "<color=VEGGIE>แครอท</color>: <color=VEGGIE>%d</color> / <color=VEGGIE>%d</color>",
		naughtiness = "ค่ากรรมกระต่าย: %d / %d",
		king_status = "%s มีชีวิตอยู่ขณะนี้", -- Gets a prefab tag inserted with king type.
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>ค่าความชื้นโลก</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>อัตราความชื้นของฝน</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>โอกาสเกิดฝนกบ</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "Shard Id: %s",
		shard_type = "Shard type: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "ชาร์จเสร็จใน: %s",
		charge = "จำนวนชาร์จ: %s / %s"
	},

	-- repairer.lua
	repairer = {
		type = "ของที่ใช้ซ่อม: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>จะฟื้นฟูพลังชีวิต</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub> หน่วย</sub></color> + <color=HEALTH>%s%%<sub></sub></color>",
		work = "<color=#DED15E>จำนวนซ่อมแซม</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>รอบ</sub></color>",
		perish = "<color=MONSTER>คืนความสดได้</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>คืนความสดได้</color>: <color=MONSTER>%s%%</color>",
		held_repair = "<color=SWEETENER><prefab=%s></color>ที่ถืออยู่ จะซ่อมได้ <color=LIGHT>%s</color>จำนวนครั้งใช้งาน (<color=LIGHT>%s%%</color>)",
		materials = (IS_DST and {
			[MATERIALS.WOOD] =  "ไม้",
			[MATERIALS.STONE] =  "หิน",
			[MATERIALS.HAY] =  "ฟาง",
			[MATERIALS.THULECITE] =  "หินโบราณ",
			[MATERIALS.GEM] =  "อัญมณี",
			[MATERIALS.GEARS] =  "ฟันเฟือง",
			[MATERIALS.MOONROCK] =  "หินพระจันทร์",
			[MATERIALS.ICE] =  "น้ำแข็ง",
			[MATERIALS.SCULPTURE] =  "รูปปั้น",
			[MATERIALS.FOSSIL] =  "ซากกระดูก",
			[MATERIALS.MOON_ALTAR] =  "แท่นพระจันทร์",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "ขาด<color=#99635D>ฟันเฟือง</color>อีก: <color=#99635D>%s</color>",
	},

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL>จะเกิดในอีก %s",
		announce_spawn = "จะมี<prefab=LUNARRIFT_PORTAL>เกิดขึ้นมาใน %s",

		stage = "ระดับรอยแยก: %d / %d", -- augmented by growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "ไม่สามารถเกิดได้ตอนนี้"
	},

	-- roseglasseshat.lua [Prefab]
	roseglasseshat = {
		ready_to_use = "พร้อมใช้งานแล้ว",
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>โบนัสดาเมจ</color>: <color=HEALTH>%s</color>",
		absorption = "<color=HEALTH>กันดาเมจได้</color>: <color=HEALTH>%s%%</color>",
		bonus_speed = "<color=DAIRY>โบนัสความเร็ว</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>ค่าสติ</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>ค่าปัญญา</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		interaction = "<color=SANITY>ค่าสติ</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = "<color=SANITY>ออร่าค่าสติ</color>: <color=SANITY>%s/min</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "กล่องนี้ถูกเปิดไปแล้ว",
		chest_labyrinth = {
			sanity = "มีโอกาส 66% ที่จะเปลี่ยน<color=SANITY>ค่าสติ</color>โดย<color=SANITY>-20</color> ถึง <color=SANITY>20</color>.",
			hunger = "มีโอกาส 66% ที่จะเปลี่ยน<color=HUNGER>ค่าความหิว</color>โดย<color=HUNGER>-20</color> ถึง <color=HUNGER>20</color>.",
			health = "มีโอกาส 66% ที่จะเปลี่ยน<color=HEALTH>ค่าพลังชีวิต</color>โดย<color=HEALTH>0</color> ถึง <color=HEALTH>20</color>.",
			inventory = "มีโอกาส 66% ที่จะเปลี่ยน<color=LIGHT>ค่าความคงทน</color>หรือ<color=MONSTER>ค่าความสด</color>โดย 20%.",
			summonmonsters = "มีโอกาส 66% ที่จะเสก<color=MOB_SPAWN>แมงมุมห้อยเพดาน</color> 1-3 ตัว",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>ระดับพลังเงา</color>: %s",
		level_diff = "<color=BLACK>ระดับพลังเงา</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s ดาเมจ</color>)",
		total_shadow_level = "<color=BLACK>ระดับพลังเงาโดยรวม</color>: %s",
	},

	-- shadowparasitemanager.lua
	shadowparasitemanager = {
		num_waves = "เหลืออีก %d กลุ่ม",
	}, 

	-- shadow_battleaxe.lua [Prefab]
	shadow_battleaxe = {
		level = "ระดับขั้น: %s / %s",
		boss_progress = "จำนวนบอสที่ล้มแล้ว: %s / %s",
		lifesteal = "<color=HEALTH>ดูดเลือดได้</color>: <color=HEALTH>%.2f</color> (<color=SANITY>%.2f</color>)",
	},

	-- shadowrift_portal.lua [Prefab]
	shadowrift_portal = {
		close = "<prefab=SHADOWRIFT_PORTAL>จะปิดในอีก %s",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "กำลังติดตาม %s",
			sanity_reward = "<color=SANITY>ค่าสติ</color>เมื่อสังหาร: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>ค่าสติ</color>เมื่อสังหาร: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- shadowthrall_mimics.lua
	shadowthrall_mimics = {
		mimic_count = "<string=UI.CUSTOMIZATIONSCREEN.ITEMMIMICS>: %s / %s",
		next_spawn = "<prefab=itemmimic_revealed>จะพยายามเกิดในอีก %s",
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "รอยแยกต่อไปจะถูกยึดใน %s",
		waiting_for_players = "กำลังรอผู้เล่นเข้าใกล้",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		thralls_alive = "<color=MOB_SPAWN>จำนวนมอนที่เหลือ(%d)</color>: %s",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color>จะงอกใหม่ใน %s",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		trades_remaining = "แลกของได้อีก %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "ระยะกันสภาพอากาศ: %s หน่วยกำแพง",
		shelter = "กันสภาพอากาศได้ ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>อาวุธ</color>จะคงทนขึ้น <color=#aaaaee>%s%%</color>",
			battlesong_healthgain = "ทุกการโจมตีจะฟื้นฟู<color=HEALTH>พลังชีวิต %s</color> หน่วย (<color=HEALTH>%s</color> กับ Wigfrid)",
			battlesong_sanitygain = "ทุกการโจมตีจะฟื้นฟู<color=SANITY>ค่าสติ %s</color> หน่วย",
			battlesong_sanityaura = "<color=SANITY>ออร่าค่าสติ</color>ลบจะมีผลน้อยลง <color=SANITY>%s%%</color>",
			battlesong_fireresistance = "รับดาเมจน้อยลง <color=HEALTH>%s%%</color> จาก<color=LIGHT>เพลิง</color>",
			battlesong_lunaraligned = "รับดาเมจน้อยลง <color=HEALTH>%s%%</color> จาก<color=LUNAR_ALIGNED>สิ่งมีชีวิตประเภทพระจันทร์</color>\nทำดาเมจมากขึ้น <color=HEALTH>%s%%</color> ต่อ<color=SHADOW_ALIGNED>สิ่งมีชีวิตประเภทเงา</color>",
			battlesong_shadowaligned = "รับดาเมจน้อยลง <color=HEALTH>%s%%</color> จาก<color=SHADOW_ALIGNED>สิ่งมีชีวิตประเภทเงา</color>\nDeal <color=HEALTH>%s%% more damage</color> ต่อ<color=LUNAR_ALIGNED>สิ่งมีชีวิตประเภทพระจันทร์</color>",

			battlesong_instant_taunt = "ล่อศัตรูเข้าหาตัวในระยะเพลง",
			battlesong_instant_panic = "ทำให้ศัตรูบางส่วนกลัวเป็นเวลา %s วินาที",
			battlesong_instant_revive = "ชุบชีวิตเพื่อนรอบตัวได้สูงสุด %d",
		},
		cost = "ใช้<color=INSPIRATION>แรงบันดาลใจ %s</color> หน่วย",
		cooldown = "คูลดาวน์เพลง: %s",
	},

	-- sinkholespawner.lua
	antlion_rage = "แมลงช้างจะโกรธในอีก %s",

	-- skinner_beefalo.lua
	skinner_beefalo = "ความน่าเกรงขาม: %s, ความรื่นเริง: %s, ความสุภาพ: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "จะตื่นในอีก %s",
	},

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>ฟื้นฟูพลังชีวิต</color>ได้ <color=HEALTH>%s</color> - <color=HEALTH>%s</color>",
	wortox_soul_heal_range = "<color=HEALTH>ฟื้นฟูพลังชีวิต</color>เพื่อนรอบตัวได้ในระยะ <color=#DED15E>%s กระเบื้อง</color>",

	-- spawner.lua
	spawner = {
		next = "จะมี<color=MOB_SPAWN><prefab={child_name}></color>เพิ่มขึ้นมาในอีก {respawn_time}",
		child = "จะมี<color=MOB_SPAWN><prefab=%s></color>ออกมา",
		occupied = "มีคนอยู่: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "ฟื้นฟู<color=HEALTH>พลังชีวิต</color>ให้ Webber: <color=HEALTH>%+d</color> หน่วย",
		spider_heal = "ฟื้นฟู<color=HEALTH>พลังชีวิต</color>ให้แมงมุม: <color=HEALTH>%+d</color> หน่วย",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>จำนวนทุบ</color>ที่เหลือ: <color=#aaaaee>%s</color>",
		time_to_reset = "จะรีเซ็ตใน %s",
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)จะทำเสร็จใน %s วินาที",
		cooker = "อาหารเตรียมโดย <color=%s>%s</color>",
		cooktime_modifier_slower = "ทำอาหารช้าลง <color=#DED15E>%s%%</color>",
		cooktime_modifier_faster = "ทำอาหารไวขึ้น <color=NATURE>%s%%</color>",
	},

	-- stickable.lua
	stickable = "<color=FISH>หอยแมลงภู่</color>: %s",

	-- support_pillar.lua [Prefab]
	support_pillar = {
		reinforcement = "ความคงกระพัน: %s / %s",
		durability = "ความคงทน: %s / %s",
	},

	-- support_pillar_dreadstone.lua [Prefab]
	support_pillar_dreadstone = {
		time_until_reinforcement_regen = "ซ่อมแซมรอบต่อไปใน %s",
	},

	-- temperature.lua
	temperature = "อุณหภูมิ: <temperature=%s>",

	-- tentacle_pillar_hole.lua [Prefab]
	tentacle_pillar_hole = {
		immunity_time = "<prefab=tentacle> ยังกระโดดได้อีก %s",
	},

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "ฟื้นฟูพลังชีวิต <color=HEALTH>%s</color> หน่วยต่อวันที่ไม่ได้เรียกสู้",
		eot_health = "<prefab=eyeofterror> <color=HEALTH>พลังชีวิต</color>ตอนเรียกมา: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>พลังชีวิตเหลือ</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>พลังชีวิตเหลือ</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium>จะพร้อมใช้งานในอีก %s",
	},

	-- tigersharker.lua
	tigershark_spawnin = "สามารถเกิดได้ในอีก %s",
	tigershark_waiting = "พร้อมเกิดแล้ว",
	tigershark_exists = "ฉลามเสือยังมีชีวิตอยู่",

	-- timer.lua
	timer = {
		label = "เวลานับถอยหลัง <color=#8c8c8c>'%s'</color>: %s",
		paused = "หยุดอยู่",
	},

	-- toadstoolspawner.lua
	toadstoolspawner = {
		time_to_respawn = "<prefab=toadstool>จะเกิดใหม่ในอีก %s",
	},

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>ประสิทธิภาพ</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "แลกทองคำได้ %s ก้อน",
	tradable_gold_dubloons = "แลกทองคำได้ %s ก้อน และมีค่า %s เหรียญทอง",
	tradable_rocktribute = "ชะลอเวลาโกรธ<color=LIGHT>แมลงช้าง</color>ได้ %s",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "ระดับ %s / %s: ",
	upgradeable_complete = "อัพเกรดแล้ว %s%%",
	upgradeable_incomplete = "ไม่สามารถอัพเกรดได้",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "เพิ่ม<color=HEALTH>พลังชีวิตสูงสุด</color> <color=HEALTH>%d</color> หน่วย",
			maxsanity = "เพิ่ม<color=SANITY>ค่าสติสูงสุด</color> <color=SANITY>%d</color> หน่วย",
			movespeed = "เพิ่ม<color=DAIRY>ความเร็วเคลื่อนที่</color> %s",
			heat = "เพิ่ม<color=#cc0000>อุณหภูมิต่ำสุด</color>ขึ้น <color=#cc0000>%d</color> หน่วย",
			heat_drying = "เร่งการ<color=#cc000>คายความชื้น</color> <color=#cc0000>%.1f</color> หน่วย",
			cold = "ลด <color=#00C6FF>อุณหภูมิต่ำสุด</color>ลง <color=#00C6FF>%d</color> หน่วย",
			taser = "สะท้อนดาเมจ <color=WET>%d</color> %s ต่อศัตรู (คูลดาวน์: %.1f).",
			light = "ให้<color=LIGHT>แสงรอบตัว</color>ในระยะ <color=LIGHT>%.1f</color> (ใส่เพิ่มได้แค่ <color=LIGHT>%.1f</color>)",
			maxhunger = "เพิ่ม<color=HUNGER>ค่าความหิว</color>สูงสุด <color=HUNGER>%d</color> หน่วย",
			music = "ให้<color=SANITY>ออร่าค่าสติ</color> <color=SANITY>%+.1f/min</color> ในระยะ <color=SANITY>%.1f</color> กระเบื้อง",
			music_tend = "ถนอมพืชในสวนเป็นระยะ <color=NATURE>%.1f</color> กระเบื้อง",
			bee = "ฟื้นฟู<color=HEALTH>%d พลังชีวิต/%d วินาที</color> (<color=HEALTH>%d/วัน</color>).",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> จะเกิดใหม่ใน: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>ป้องกันความชื้นได้</color>: <color=WET>%s%%</color>",
	
	-- watersource.lua
	watersource = "นี่เป็นแหล่งน้ำ",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "เพิ่มความชื้นได้ <color=WET>%s</color>"
	},

	-- wathgrithr_shield.lua [Prefab]
	wathgrithr_shield = {
		parry_duration_complex = "ระยะเวลาปัดป้อง: <color=%s>%.1f<sub>ปกติ</sub></color> | <color=%s>%.1f<sub>หากมีสกิล</sub></color>",
	},
	
	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>ดาเมจ</color>",
		electric = "<color=WET>(เป็นไฟฟ้า)</color> <color=HEALTH>ดาเมจ</color>",
		poisonous = "<color=NATURE>(เป็นพิษ)</color> <color=HEALTH>ดาเมจ</color>",
		thorns = "<color=HEALTH>(เป็นหนาม)</color> <color=HEALTH>ดาเมจ</color>",
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "ระยะโจมตี: %s",

	-- weather.lua
	weather = {
		progress_to_rain = "ความคืบหน้า<color=WET>ฝนตก</color>", -- Numbers appended by code
		remaining_rain = "<color=WET>ปริมาณฝนที่เหลือ</color>", -- Numbers appended by code

		progress_to_hail = "ความคืบหน้า<color=LUNAR_ALIGNED>ลูกเห็บตก</color>", -- Numbers appended by code
		remaining_hail = "<color=LUNAR_ALIGNED>ปริมาณลูกเห็บที่เหลือ</color>", -- Numbers appended by code
	
		progress_to_acid_rain = "ความคืบหน้า<color=WET>ฝน<color=SHADOW_ALIGNED>กรด</color></color>", -- Numbers appended by code
		remaining_acid_rain = "<color=WET>ปริมาณฝน<color=SHADOW_ALIGNED>กรดที่เหลือ</color></color>", -- Numbers appended by code
	},

	-- weighable.lua
	weighable = {
		weight = "น้ำหนัก: %s (%s%%)",
		weight_bounded = "น้ำหนัก: %s <= %s (%s) <= %s",
		owner_name = "เจ้าของ: %s"
	},

	-- werebeast.lua
	werebeast = "ค่ากลายร่าง: %s / %s",

	-- wereness.lua
	wereness_remaining = "ค่ากลายร่าง: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "สิ่งนี้ดูเหมือนจะคีบได้ แต่ไม่ผ่านการเช็ค prefab",
		sunken_item = "มี<color=#66ee66>%s</color>อยู่ใต้เหล็กคีบ",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>อุณหภูมิโลก</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "คุณ<color=#bbffbb>สามารถ</color>รับ<color=#DED15E>ของขวัญหายาก</color>ได้",
		not_ready = "คุณต้อง<color=#ffbbbb>รออีก %s วัน</color>ก่อนจะรับ<color=#DED15E>ของขวัญหายาก</color>ได้อีก",
	},

	-- witherable.lua
	witherable = {
		delay = "ไม่สามารถเปลี่ยนสถานะได้เป็นเวลา %s",
		wither = "จะแห้งใน %s",
		rejuvenate = "จะฟื้นฟูใน %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>โอกาสทรีการ์ด</color>: %s%%<sub>ของคุณ</sub> & %s%%<sub>ของ NPC</sub>",
		treeguard_chance = "<color=#636C5C>โอกาสทรีการ์ด</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "Worldmigrator ใช้งานไม่ได้",
		target_shard = "Shard เป้าหมาย: %s",
		received_portal = "Portal เป้าหมาย: %s", -- Shard Migrator
		id = "Portal นี้: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "นับถอยหลังตามค่าโลก <color=#8c8c8c>'%s'</color>: %s",
		paused = "หยุดอยู่",
	},

	-- wortox.lua [Prefab]
	wortox = {
		time_untl_panflute_inspiration = "Wortox will get a free <prefab=panflute> use in %s",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "ชาร์จคงเหลือ: %s",
		gain_charge_time = "ชาร์จ: %d / %d, <color=LIGHT>ชาร์จ</color>ต่อไปใน: <color=LIGHT>%s</color>",
		full_charge = "ชาร์จเต็มแล้ว!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "ความคืบหน้าสแกน: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "จะเย็บเสร็จใน: %s",
}
