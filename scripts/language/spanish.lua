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

-- Translated by: https://steamcommunity.com/id/Dislekzi4

-- TheNet:GetLanguageCode() == "spanish" & LOC.GetLocaleCode() == "es"

return {
	-- insightservercrash.lua
	crash_reporter = {
		title = "[Insight Crash Reporter]",
		crashed = "El servidor no responde.",
		report_status = {
			unknown = "Unknown",
			disabled = "The crash reporter is <color=#666666>disabled</color>: <color=#666666>%s</color>",
			sending = "Sending crash report",
			success = "Crash reported to Insight. <u>This does NOT mean that Insight caused the issue!</u>",
			failure = "Crash report failed to send (%s): %s",
		},
	},
	
	-- modmain.lua
	dragonfly_ready = "Listo para luchar.",

	-- time.lua
	time_segments = "%s segmento(s)",
	time_days = "%s día(s), ",
	time_days_short = "%s día(s)",
	time_seconds = "%s segundo(s)",
	time_minutes = "%s minuto(s), ",
	time_hours = "%s hora(s), ",

	-- meh
	seasons = {
		autumn = "<color=#CE5039>Otoño</color>",
		winter = "<color=#95C2F4>Invierno</color>",
		spring = "<color=#7FC954>Primavera</color>",
		summer = "<color=#FFCF8C>Verano</color>",
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
	unbind = "Desvincular",
	keybinds = {
		label = "Atajos de Teclado (Solo Teclado)",
		togglemenu = {
			name = "Abrir Menú Insight",
			description = "Abre/Cierra el menú de Insight"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[Anuncio de Peligro]: ",
		boss = "[Anuncio de Jefe]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "Nuevo Jugador",
				description = "Recomendado para jugadores nuevos.",
			},
			simple = {
				label = "Simple",
				description = "Una cantidad baja de información, similar a Show Me.",
			},
			decent = {
				label = "Decente",
				description = "Una cantidad promedio de información. Muy similar a la configuración predeterminada.",
			},
			advanced = {
				label = "Avanzado",
				description = "Bueno para personas que les gusta la información.",
			},
		},
	},

	-- Insight Menu
	insightmenu = {
		tabs = {
			world = "Mundo",
			player = "Jugador",
		},
	},
	
	indicators = {
		dismiss = "%s Descartar",
	},

	-- Damage helper
	damage_types = {
		explosive = "Explosivo",
		lunar_aligned = "Alineado Lunar",
		shadow_aligned = "Alineado de Sombras",
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
		minimum_sanity = "Proporciona luz sobre: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>) de <color=SANITY>cordura</color>",
		current_sanity = "Tu <color=SANITY>cordura</color> es: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "Invoca <color=ENLIGHTENMENT>Gestalts</color> con <color=HEALTH>%s</color> de <color=HEALTH>daño</color>",
	},

	-- ancienttree_seed.lua [Prefab]
	ancienttree_seed = {
		type = "Type: <color=%s><prefab=%s></color>",
		fruit_regen_time = "Fruit time: %s",
		fruit_regen_time_bounded = "Fruit time: %s <= %s <= %s",
	},

	-- aoeweapon_base.lua
	aoeweapon_base = {
		weapon_damage = "AoE %s: <color=HEALTH>{damage}</color>",
	},

	-- aoeweapon_leap.lua
	aoeweapon_leap = {

	},

	-- aoeweapon_lunge.lua
	aoeweapon_lunge = {
		lunge_damage = "Lunge {damageType}: <color=HEALTH>{damage}</color>",
	},

	-- appeasement.lua
	appease_good = "Retrasa la erupción en %s segmento(s).",
	appease_bad = "Acelera la erupción en %s segmento(s).",

	-- appraisable.lua
	appraisable = "Temible: %s, Festivo: %s, Formal: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "Desbloquea: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>Protección</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>Durabilidad</color>: <color=#C0C0C0>%s</color>/<color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>Durabilidad</color>: <color=#C0C0C0>%s</color>",

	-- armordreadstone.lua
	armordreadstone = {
		regen = "Regenerates <color=%s>%.1f</color> <color=#C0C0C0>durability</color>/%ds",
		regen_complete = "Regenerates <color=%s>%.1f<sub>min</sub></color> / <color=%s>%.1f<sub>current</sub></color> / <color=%s>%.1f<sub>max</sub></color> <color=#C0C0C0>durability</color>/%ds based on insanity"
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate> se reiniciará en %s",
	},

	-- attunable.lua
	attunable = {
		linked = "Vinculado a: %s",
		offline_linked = "Vinculado (no en línea) a: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "Restaura <color=HEALTH>%s</color> de <color=HEALTH>salud</color> por golpe",
		sanity_cost = "Drena <color=SANITY>%s</color> de <color=SANITY>cordura</color> por golpe",
	},

	-- beard.lua
	beard = "La barba crecerá en %s día(s).",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>Objetivo: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger> aparecerá sobre %s (<prefab=%s>) en %s.",
		bearger_attack = "<prefab=bearger> atacará en %s."
	},

	-- beef_bell.lua [Prefab]
	beef_bell = {
		beefalo_name = "Name: %s",
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen> reaparecerá en %s.",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "Arrastre: %.5f",
		max_velocity_mod = "Máx. velocidad de mod.: %.3f",
		force_dampening = "Amortiguación de fuerza: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- book.lua
	book = {
		wickerbottom = {
			tentacles = "Invoca <color=%s>%d tentáculos</color>",
			birds = "Invoca hasta <color=%s>%d pájaros</color>",
			brimstone = "Invoca <color=%s>%d rayos</color>",
			horticulture = "Hace crecer hasta <color=%s>%d plantas</color>",
			horticulture_upgraded = "Hace crecer y cuida hasta <color=%s>%d plantas</color>",
			silviculture = "Hace crecer plantas de recursos básicos.",
			fish = "Invoca un estanque con <color=%s>%d peces</color>",
			fire = "Invoca <color=%s>%d bolas de fuego</color>",
			web = "Invoca una <color=%s>telaraña</color> que dura <color=%s>%s</color>",
			temperature = "Ajusta la <color=%s>temperatura</color> a <color=%s>%s</color>",
			light = "Invoca una <color=LIGHT>luz</color> por <color=LIGHT>%s</color>",
			rain = "Activa/Desactiva la <color=WET>lluvia</color> y <color=WET>riega las plantas cercanas</color>",
			bees = "Invoca <color=%s>%d abejas</color> hasta un máximo de <color=%s>%d</color>",
			research_station = "Cargas de prototipo: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "Invoca <color=%s>%d meteoritos</color>",
		},
	},

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>Pez Tropical</color>",
	breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>Mero Morado</color>",
	breeder_fish4 = "<color=#DED15E>Pez Pierrot</color>",
	breeder_fish5 = "<color=#9ADFDE>Neón Quattro</color>",
	breeder_fishstring = "%s: %s/%s",
	breeder_nextfishtime = "Pez adicional en: %s",
	breeder_possiblepredatortime = "Puede generar un depredador en: %s",

	-- brushable.lua
	brushable = {
		last_brushed = "Cepillado hace %s días"
	},

	-- burnable.lua
	burnable = {
		smolder_time = "<color=LIGHT>Ignición</color> en: <color=LIGHT>%s</color>",
		burn_time = "<color=LIGHT>Combustión</color> restante: <color=LIGHT>%s</color>",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "Valor decorativo: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "Raro",
			uncommon = "Poco común",
			common = "Común",
			unknown = "Desconocido",
		},
		shape = "Forma: %s",
		rarity = "Rareza: %s",
		season = "Temporada: %d",
		undecided = "Debe colocarse antes para determinar el contenido."
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>Posición</color>: <color=%s>%s</color>/<color=%s>%s</color>",
		decor = "Decoración total: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>Nivel de gas</color>: %s/%s", -- canary, max saturation canary
		poison_chance = "Posibilidad de ser <color=#522E61>envenenado</color>: <color=#D8B400>%d%%</color>",
		gas_level_increase = "Aumenta en %s",
		gas_level_decrease = "Disminuye en %s"
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "Gapaches: %s/%s",
		regenerate = "Regenerando gapaches en: %s",
		waiting_for_sleep = "Esperando a que los jugadores cercanos se alejen.",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "Esperando a que regreses a la escena del crimen.",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> reaparecerá en: %s",
	announce_chester_respawn = "My <prefab=chester> will respawn in %s.",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fuera</sub>/%s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fuera</sub>/%s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "Regenerando {to_regen} dentro de {regen_time}",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>Daño</color>: <color=HEALTH>%s</color>",
		damageToYou = " (<color=HEALTH>%s</color> a ti)",
		age_damage = "<color=HEALTH>Daño <color=AGE>(Edad)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> a ti)",
		yotr_pillows = {
			--@@ Weapons
			knockback = "<color=VEGGIE>Retroceso</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "Multiplicador de retroceso: %s",
			laglength = "<color=VEGGIE>Enfriamiento</color>: %s",
			
			--@@ Armor
			defense_amount = "<color=VEGGIE>Defensa</color>: %s",
			
			--@@ Both
			prize_value = "Valor del premio: %s",
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
	cooldown = "Enfriamiento: %s",

	-- crabkingspawner.lua
	crabkingspawner = {
		crabking_spawnsin = "%s",
		time_to_respawn = "<prefab=crabking> reaparecerá en %s.",
	},

	-- crittertraits.lua
	dominant_trait = "Rasgo dominante: %s",

	-- crop.lua
	crop_paused = "En pausa.",
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "Paso: %s/%s",
		note = ", nota: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> daño a entidades %s",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> daño de ataques %s",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>Cordura</color>: <color=SANITY>%s/min</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER> reaparecerá en %s día(s)",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>Bonificación</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = {
			name = nil,
			description = "Inflige <color=HEALTH>{percent}%</color> de <color=HEALTH>daño</color> extra por {duration}(s)",
		},
		["buff_playerabsorption"] = {
			name = nil,
			description = "Mitiga <color=MEAT>{percent}%</color> del <color=HEALTH>daño</color> por {duration}(s)",
		},
		["buff_workeffectiveness"] = {
			name = nil,
			description = "El trabajo es <color=#DED15E>{percent}%</color> más efectivo por {duration}(s)",
		},
		
		["buff_moistureimmunity"] = {
			name = nil,
			description = "Inmunidad a la <color=WET>humedad</color> por {duration}(s)",
		},
		["buff_electricattack"] = {
			name = nil,
			description = "Tus ataques son <color=WET>eléctricos</color> por {duration}(s)",
		},
		["buff_sleepresistance"] = {
			name = nil,
			description = "Resistes el <color=MONSTER>sueño</color> por {duration}(s)",
		},
		
		["healingsalve_acidbuff"] = {
			name = "<color=#ded15e>Acid Resistance</color>",
			description = "Immune to <color=#ded15e>acid rain</color> for {duration}(s)."
		},
		["tillweedsalve_buff"] = {
			name = nil,
			description = "Regenera <color=HEALTH>{amount}</color> de <color=HEALTH>salud</color> por {duration}(s)",
		},
		["healthregenbuff"] = {
			name = nil,
			description = "Regenera <color=HEALTH>{amount}</color> de <color=HEALTH>salud</color> por {duration}(s)",
		},
		["sweettea_buff"] = {
			name = nil,
			description = "Regenera <color=SANITY>{amount}</color> de <color=SANITY>cordura</color> por {duration}(s)",
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
			name = "<color=FROZEN>Bonificación del Festín Invernal</color>",
			description = nil
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER><prefab=batnosehat> Bonificación</color>",
			description = "Regenera <color=HUNGER>{amount} hambre</color> durante {duration}(s).",
		},
		
		["halloweenpotion_health_buff"] = {
			name = "<color=HEALTH>Regeneración de salud</color>",
			description = nil
		},
		["halloweenpotion_sanity_buff"] = {
			name = "<color=SANITY>Regeneración de cordura</color>",
			description = nil
		},
		["halloweenpotion_bravery_small_buff"] = {
			name = "<color=SANITY>Valentía</color> contra los murciélagos.",
			description = nil
		},
		["halloweenpotion_bravery_large_buff"] = (function(parent)
			return deepcopy(parent.halloweenpotion_bravery_small_buff)
		end)
	},

	-- deerclopsspawner.lua
	deerclopsspawner = {
		incoming_deerclops_targeted = "<color=%s>Objetivo: %s</color> -> %s",
		announce_deerclops_target = "<prefab=deerclops> aparecerá sobre %s (<prefab=%s>) en %s.",
		deerclops_attack = "<prefab=deerclops> atacará en %s.",
	},

	-- diseaseable.lua
	disease_in = "Enferma en: %s",
	disease_spread = "Propagará la enfermedad en: %s",
	disease_delay = "Retrasa la enfermedad por: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "Domesticación: %s%%",
		obedience = "Obediencia: %s%%",
		obedience_extended = "Obediencia: %s%% (<%s%%<sub>montura de ciervo</sub>, %s%%<sub>mínimo</sub>)",
		tendency = "Tendencia: %s",
		tendencies = {
			["NONE"] = "Ninguna",
			[TENDENCY.DEFAULT] = "Por defecto",
			[TENDENCY.ORNERY] = "Gruñón",
			[TENDENCY.RIDER] = "Jinete",
			[TENDENCY.PUDGY] = "Rechoncho"
		},
	},

	-- dragonfly_spawner.lua [Prefab]
	dragonfly_spawner = {
		time_to_respawn = "<prefab=dragonfly> reaparecerá en %s.",
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "Secado en pausa.",
	dry_time = "Tiempo restante: %s",

	-- eater.lua
	eater = {
		eot_loot = "La comida restaura <color=HUNGER>hambre %s%%</color> + <color=HEALTH>salud %s%%</color> como durabilidad",
		eot_tofeed_restore = "Alimentar con <color=MEAT><prefab=%s></color> restaura <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) de durabilidad",
		eot_tofeed_restore_advanced = "Alimentar con <color=MEAT><prefab=%s></color> restaura <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) de durabilidad",
		tofeed_restore = "Alimentar con <color=MEAT><prefab=%s></color> restaura %s",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> unidad(es) de <color=%s>%s</color>", 
	edible_interface = "<color=HUNGER>Hambre</color>: <color=HUNGER>%s</color> / <color=SANITY>Cordura</color>: <color=SANITY>%s</color> / <color=HEALTH>Salud</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>Salud</color>: <color=HEALTH>%s</color> / <color=HUNGER>Hambre</color>: <color=HUNGER>%s</color> / <color=SANITY>Cordura</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "carne",
		monster = "monstruo",
		fish = "pescado",
		veggie = "vegetal",
		fruit = "fruta",
		egg = "huevo",
		sweetener = "endulzante",
		frozen = "congelado",
		fat = "grasa",
		dairy = "lácteo",
		decoration = "decoración",
		magic = "mágico",
		precook = "precocido",
		dried = "seco",
		inedible = "incomestible",
		bug = "insecto",
		seed = "semilla",
		antihistamine = "antihistamínico", -- Only "cutnettle"
	},
	edible_foodeffect = {
		temperature = "Temperatura: %s, %s",
		caffeine = "Velocidad: %s, %s",
		surf = "Velocidad de la nave: %s, %s",
		autodry = "Velocidad de la nave: %s, %s",
		instant_temperature = "Temperatura: %s, (Instantánea)",
		antihistamine = "Retraso de la fiebre del heno: %ss",
	},
	foodmemory = "Comido hace: %s/%s, olvida en: %s",
	wereeater = "<color=MONSTER>Carne de monstruo</color> comida: %s/%s, olvida en: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>Velocidad</color>: %s%%",
	hunger_slow = "Reduce el <color=HUNGER>hambre</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "Drena el <color=HUNGER>hambre</color>: <color=HUNGER>%s%%</color>",
	insulated = "Te protege de los rayos.",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>Daño por explosión</color>: %s",
	explosive_range = "<color=LIGHT>Rango de explosión</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "Se convertirá en <color=NATURE><prefab=%s></color>.",
		nutrient_consumption = "ΔNutrientes: [<color=NATURE>%d<sub>Fórmula</sub></color>, <color=CAMO>%d<sub>Composta</sub></color>, <color=INEDIBLE>%d<sub>Estiércol</sub></color>]",
		good_seasons = "Estaciones: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "Puntos de estrés: %s",
		display = "Estresores: %s",
		stress_tier = "Nivel de estrés: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "Ninguno",
			[FARM_PLANT_STRESS.LOW] = "Bajo",
			[FARM_PLANT_STRESS.MODERATE] = "Moderado",
			[FARM_PLANT_STRESS.HIGH] = "Alto",
		} or {}),
		categories = {
			["nutrients"] = "Nutrientes", -- missing nutrients
			["moisture"] = "Humedad", -- needs water
			["killjoys"] = "Malas hierbas", -- weeds nearby
			["family"] = "Familia", -- no similar plants nearby
			["overcrowding"] = "Hacinamiento", -- too crowded
			["season"] = "Estación", -- out of season
			["happiness"] = "Felicidad", -- not tended to
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>Agua</color>: <color=WET>%s<sub>baldosa</sub></color>*",
		soil_plant = "<color=WET>Agua</color>: <color=WET>%s<sub>baldosa</sub></color> (<color=WET>%s/min<sub>planta</sub></color>)*",
		soil_plant_tile = "<color=WET>Agua</color>: <color=WET>%s<sub>baldosa</sub></color> (<color=WET>%s<sub>planta</sub></color> [<color=#2f96c4>%s<sub>baldosa</sub></color>])<color=WET>/min</color>*",
		soil_plant_tile_net = "<color=WET>Agua</color>: <color=WET>%s<sub>baldosa</sub></color> (<color=WET>%s<sub>planta</sub></color> [<color=#2f96c4>%s<sub>baldosa</sub></color> + <color=SHALLOWS>%s<sub>mundo</sub></color> = <color=#DED15E>%+.1f<sub>red</sub></color>])<color=WET>/min</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>baldosa</sub>*",
		soil_plant = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>baldosa</sub> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>Δplanta</sub>)*",
		soil_plant_tile = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>baldosa</sub>   ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>Δplanta</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>baldosaΔ</sub>)",
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "Reduce el tiempo de <color=NATURE>crecimiento</color> en <color=NATURE>%s</color> segundos.",
		nutrient_value = "Nutrientes: [<color=NATURE>%s<sub>Fórmula</sub></color>, <color=CAMO>%s<sub>Composta</sub></color>, <color=INEDIBLE>%s<sub>Estiércol</sub></color>]",
		wormwood = {
			formula_growth = "Acelera el <color=LIGHT_PINK>crecimiento</color> por <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>Cura</color> <color=HEALTH>{healing}</color> de salud durante <color=HEALTH>{duration}</color> segundo(s).",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "Puede llenarse con agua del mar.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s/%s",
	actions = {
		USES_PLAIN = "Usos",
		TERRAFORM = "Terraformar",
		GAS = "Gas", -- hamlet
		DISARM = "Desarmar", -- hamlet
		PAN = "Sartén", -- hamlet
		DISLODGE = "Desalojar", -- hamlet
		SPY = "Espiar", -- hamlet
		THROW = "Lanzar", -- sw -- Action string is "Throw At"
		ROW_FAIL = "Fallido",
		ATTACK = "Ataques", -- "STRINGS.ACTIONS.ATTACK.GENERIC"
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>",
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>Peces</color>: <color=WET>%s</color>/<color=WET>%s</color>",
	fish_recharge = ": +1 pez en: %s",
	fish_wait_time = "Tardará <color=SHALLOWS>%s segundos</color> en capturar un pez.",

	-- fishingrod.lua
	fishingrod_waittimes = "Tiempo de espera: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Tiempo máx. de lucha: <color=SHALLOWS>%s</color>",

	-- flotsamgenerator.lua
	flotsamgenerator = {
		messagebottle_cooldown = "Next <prefab=messagebottle> spawn: %s",
	},

	-- follower.lua
	leader = "Líder: %s",
	loyalty_duration = "Lealtad: %s",

	-- forcecompostable.lua
	forcecompostable = "Valor de composta: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "20%% de prob. de salir mal con %s de pieza(s) más.",
		correct = "Está correctamente montado.",
		incorrect = "Está mal montado.",
		gateway_too_far = "El esqueleto está demasiado lejos (%s baldosa(s)).",
	},

	-- friendlevels.lua
	friendlevel = "Nivel de amistad: %s/%s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> segundo(s) de combustible.",
		fuel_verbose = "<color=LIGHT>%s</color> segundo(s) de <color=LIGHT>%s</color>.",
		type = "Tipo de combustible: %s",
		types = {
			BURNABLE = "Combustible",
			CAVE = "Luz", -- miner hat / lanterns, light bulbs n stuff
			CHEMICAL = "Combustible",
			CORK = "Combustible",
			GASOLINE = "Gasolina", -- DS: not actually used anywhere?
			MAGIC = "Durabilidad", -- amulets that aren't refuelable (ex. chilled amulet)
			MECHANICAL = "Durabilidad", -- SW: iron wind
			MOLEHAT = "Visión nocturna", -- Moggles
			NIGHTMARE = "Combustible pesadilla",
			NONE = "Tiempo", -- will never be refueled
			ONEMANBAND = "Durabilidad",
			PIGTORCH = "Combustible",
			SPIDERHAT = "Durabilidad", -- Spider Hat
			TAR = "Alquitrán", -- SW
			USAGE = "Durabilidad",
		},
	},

	-- fueled.lua
	fueled = {
		time = "<color=LIGHT>Combustible</color> restante (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color> restante (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>Eficiencia de combustible</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>Combustible</color>: <color=LIGHT>%s</color>",
		held_refuel = "Echar <color=SWEETENER><prefab=%s></color> repostará <color=LIGHT>%s%%</color>.",
	},

	-- gelblobspawner.lua
	gelblobspawner = {
		
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>Nivel de vínculo</color>: %s/%s",
		flower = "Nivel de <color=%s>vínculo fraternal</color>: %s/%s",
		levelup = "\n +1 en %s",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "Regenera <color=HEALTH>%s</color> de <color=HEALTH>salud</color> en %s (<color=HEALTH>+%s</color>/<color=HEALTH>%ss</color>)",
		ghostlyelixir_fastregen = "Regenera <color=HEALTH>%s</color> de <color=HEALTH>salud</color> en %s (<color=HEALTH>+%s</color>/<color=HEALTH>%ss</color>)",
		ghostlyelixir_attack = "Maximiza el <color=HEALTH>daño</color> por %s",
		ghostlyelixir_speed = "Aumenta la <color=DAIRY>velocidad</color> en <color=DAIRY>%s%%</color> por %s",
		ghostlyelixir_shield = "Aumenta la duración del escudo a 1s por %s",
		ghostlyelixir_retaliation = "El escudo refleja <color=HEALTH>%s</color> de <color=HEALTH>daño</color> por %s", -- concatenated with shield
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "<color=#737CD0><prefab=%s></color> duración: %s",
	},

	-- growable.lua
	growable = {
		stage = "Etapa <color=#8c8c8c>'%s'</color>: %s/%s: ",
		paused = "Crecimiento en pausa.",
		next_stage = "Próxima etapa en %s.",
	},

	-- grower.lua
	harvests = "<color=NATURE>Cosecha</color>: <color=NATURE>%s</color>/<color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s/%s",
		grow = "+1 en %s",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "Malestar: %s/%s",
		progress = "Progreso de la eclosión: %s/%s",
	},

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>Salud</color>: <color=HEALTH>%+d</color>",
		webber_heal = "Webber <color=HEALTH>Salud</color>: <color=HEALTH>%+d</color>",
		spider_heal = "Spider <color=HEALTH>Salud</color>: <color=HEALTH>%+d</color>",
	},

	-- health.lua
	health = "<color=HEALTH>Salud</color>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color>/<color=HEALTH>%ss</color>)",
	absorption = " : Absorción de %s%% del daño",
	naughtiness = "Maldad: %s",
	player_naughtiness = "Tu maldad: %s/%s",

	-- heatrock.lua [Prefab]
	heatrock_temperature = "Temperatura: %s < %s < %s",

	-- herdmember.lua
	herd_size = "Tamaño de la manada: %s/%s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "Rango de escondite: %s a %s",
		needed_hiding_spots = "Escondites necesarios: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "Los sabuesos atacarán en %s.",
		time_until_worms = "<prefab=worm> attack in %s",
		time_until_worm_boss = "<prefab=worm_boss> attack in %s",
		time_until_crocodog = "<prefab=crocodog> attack in %s",
		worm_boss_chance = "<prefab=worm_boss> chance: %.1f%%",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>Hambre</color>: <color=HUNGER>%s</color>/<color=HUNGER>%s</color>",
	hunger_burn = "Drenaje de <color=HUNGER>hambre</color>: <color=HUNGER>%+d/día</color> (<color=HUNGER>%s/s</color>)",
	hunger_paused = "Drenaje de <color=HUNGER>hambre</color> en pausa.",

	-- hunter.lua
	hunter = {
		hunt_progress = "Pista: %s/%s",
		impending_ambush = "Hay una emboscada esperando en la siguiente pista.",
		alternate_beast_chance = "<color=#b51212>%s%%</color> de <color=#b51212>prob.</color> de <color=MOB_SPAWN>Huargo</color> o <color=MOB_SPAWN>Ewecus</color>",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> reaparecerá en: %s",
	announce_hutch_respawn = "Mi <prefab=hutch> reaparecerá en %s.",

	-- inspectable.lua
	wagstaff_tool = "Esta herramienta se llama: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "Valor en pesas de gimnasio: %s",
	ruins_statue_gem = "Contiene una <color=%s><prefab=%s></color>.",

	-- inspectacleshat.lua [Prefab]
	inspectacleshat = {
		ready_to_use = "Ready to inspect",
	},

	-- insulator.lua
	insulation_winter = "<color=FROZEN>Aislamiento (Invierno)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>Aislamiento (Verano)</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		head_describe = "[Sombrero]: ",
		hands_describe = "[Tool]: ",
	},

	-- itemmimic.lua
	itemmimic = {
		time_to_reveal = "<prefab=itemmimic_revealed> reveal in: %s",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "Número de Kitcoons: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>Botín notable</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "Desaparece en el día: %s",
	},

	-- leader.lua
	followers = "Seguidores: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "Alcance de protección contra rayos: %s unidades",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "Se descarga en %s día(s).",

	-- linkeditem.lua
	linkeditem = {
		owner = "Owner: %s",
	},

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>disponible</sub> / %d<sub>total</sub> / %d<sub>máx</sub>", -- I can't think of a way to word 
		next_crystal = "El próximo <color=#4093B2><prefab=lunarrift_crystal_big></color> aparecerá en %s",
		close = "<prefab=LUNARRIFT_PORTAL> se cerrará en aproximadamente %s",
	},
	
	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "%d",
		spawn = "Los Gestalts aparecerán en %s",
		next_wave = "Próxima oleada en %s",
		remain_waves = "%d oleadas restantes",
	},

	-- lunarthrall_plant.lua [Prefab]
	lunarthrall_plant = {
		time_to_aggro = "La vulnerabilidad termina en: <color=%s>%.1f</color>",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "Se activa en: %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "Termina en: %s",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "Esperando que alguien vaya a un cardumen.",
		time_to_respawn = "<prefab=malbatross> reaparecerá en %s.",
	},
	
	-- mast.lua
	mast_sail_force = "Fuerza de la vela: %s",
	mast_max_velocity = "Velocidad máxima: %s",

	-- mermcandidate.lua
	mermcandidate = "Calorías: %s/%s",

	-- messagebottlemanager.lua
	messagebottlemanager = "Treasures to grab: %d / %d",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>Fuerza</color>: <color=MIGHTINESS>%s</color>/<color=MIGHTINESS>%s</color> - <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>Fuerza</color> por uso: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "Peso de gimnasio: %s",
		mighty_gains = "<color=MIGHTINESS>Elevación</color> normal: <color=MIGHTINESS>%+.1f</color>, <color=MIGHTINESS>Elevación</color> perfecta: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>Drenaje de hambre</color>: <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "Comprueba disparadores cada %s segundo(s).",
		inactive = "No se comprueba si hay disparadores.",
		beemine_bees = "Liberará %s abeja(s).",
		trap_starfish_cooldown = "Se rearma en: %s",
	},

	-- moisture.lua
	moisture = "<color=WET>Humedad</color>: <color=WET>%s%%</color>", --moisture = "<color=WET>Wetness</color>: %s/%s (%s%%)",

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "Interacción con el mástil y el ancla: {feature_speed}\nUso de durabilidad del remo: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "Reducción de daño del barco: {reduction}",

	-- mood.lua
	mood = {
		exit = "Saldrá del estado de ánimo en %s día(s).",
		enter = "Entrará en el estado de ánimo en %s día(s).",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "Progreso hacia el destino: %s/%s",
			time_for_next_tool = "Otra herramienta necesaria en %s.",
			experiment_time = "El experimento se completa en %s.",
		},
		storm_move = "%s%% de prob. de mover las tormentas lunares en el día %s",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>Fase: %s</color>, %s",
		phase_locked = "Bloqueado por la <color=#CE3D45>Llave antigua</color>.",
		announce_phase_locked = "Las ruinas están actualmente bloqueadas en la fase de pesadilla.",
		announce_phase = "Las ruinas están en la fase %s (%s restante).",
		phases = {
			calm = "Calma",
			warn = "Advertencia",
			wild = "Pesadilla",
			dawn = "Amanecer"
		},
	},

	-- oar.lua
	oar_force = "<color=INEDIBLE>Fuerza</color>: <color=INEDIBLE>%s%%</color>",

	-- oceanfishingrod.lua
	oceanfishingrod = {
		hook = {
			interest = "Interés: %.2f",
			num_interested = "Peces interesados: %s",
		},
		battle = {
			tension = "Tensión: <color=%s>%.1f</color> / %.1f<sub>línea se rompe</sub>",
			slack = "Holgura: <color=%s>%.1f</color> / %.1f<sub>pez escapa</sub>",
			distance = "Distancia: %.1f<sub>captura</sub> / <color=%s>%.1f<sub>actual</sub></color> / %.1f<sub>huir</sub>",
		},
	},

	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "Distancia adicional: %s",
			bonus_accuracy = "Precisión adicional: <color=#66CC00>%+.1f%%<sub>min</sub></color> / <color=#5B63D2>%+.1f%%<sub>máx</sub></color>",
		},
		lure = {
			charm = "Encanto: <color=#66CC00>%.1f<sub>base</sub></color> + <color=#5B63D2>%.1f<sub>carrete</sub></color>",
			stamina_drain = "Drenaje de resistencia adicional: %.1f",
			time_of_day_modifier = "Eficacia según fase del día: <color=DAY_BRIGHT>%d%%<sub>día</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>atardecer</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>noche</sub></color>",
			weather_modifier = "Eficacia según clima: <color=#bbbbbb>%d%%<sub>despejado</sub></color> / <color=#7BA3F2>%d%%<sub>lluvioso</sub></color> / <color=FROZEN>%d%%<sub>nevando</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "Progreso del crecimiento superalto: %s / %s",
	
	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>Edad</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "<color=#E3D740>Nivel de oro</color>: %.1f / %.1f",
		gold_level = "<color=#E3D740>Nivel de oro</color>: %.1f",
	},
	
	-- parryweapon.lua
	parryweapon = {
		parry_duration = "Duración del parry: {duration}",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "Caduca",
		stale = "Rancio",
		spoil = "Estropeado",
		dies = "Muere",
		starves = "Muere de hambre",
		transition = "<color=MONSTER>{next_stage}</color> en {time}",
		transition_extended = "<color=MONSTER>{next_stage}</color> en {time} (<color=MONSTER>{percent}%</color>)",
		paused = "Actualmente no se descompone.",
	},

	-- petrifiable.lua
	petrify = "Se petrifica en %s.",

	-- pickable.lua
	pickable = {
		regrowth = "<color=NATURE>Vuelve a crecer</color> en: <color=NATURE>%s</color>",
		regrowth_paused = "El crecimiento se detuvo.",
		cycles = "<color=DECORATION>Cosechas restantes</color>: <color=DECORATION>%s</color>/<color=DECORATION>%s</color>",
		mushroom_rain = "<color=WET>Lluvia</color> necesaria: %s",
	},

	-- planardamage.lua
	planardamage = {
		planar_damage = "<color=PLANAR>Daño Planar</color>: <color=PLANAR>%s</color>",
		additional_damage = " (<color=PLANAR>+%s<sub>bonus</sub></color>)",
	},

	-- planardefense.lua
	planardefense = {
		planar_defense = "<color=PLANAR>Defensa Planar</color>: <color=PLANAR>%s</color>",
		additional_defense = " (<color=PLANAR>+%s<sub>bonus</sub></color>)",
	},

	-- poisonable.lua
	poisonable = {
		remaining_time = "<color=NATURE>Veneno</color> expira en %s",
	},

	-- pollinator.lua
	pollination = "Flores polinizadas: (%s)/%s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "Mi <prefab=polly_rogers> reaparecerá en %s."
	},

	-- preservative.lua
	preservative = "Restaura %s%% de frescura",

	-- preserver.lua
	preserver = {
		spoilage_rate = "<color=#ad5db3>Tasa de descomposición</color>: <color=#ad5db3>%.1f%%</color>",
		freshness_rate = "<color=FROZEN>Tasa de frescura</color>: <color=FROZEN>%.1f%%</color>",
	},

	-- quaker.lua
	quaker = {
		next_quake = "<color=INEDIBLE>Terremoto</color> en %s",
	},

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Juguetes restantes: %s",
			assisted_by = "Este Pipspook está siendo asistido por %s.",
		},
	},

	-- rabbitkingmanager.lua
	rabbitkingmanager = {
		carrots = "<color=VEGGIE>Carrots</color>: <color=VEGGIE>%d</color> / <color=VEGGIE>%d</color>",
		naughtiness = "Naughtiness: %d / %d",
		king_status = "%s is alive.", -- Gets a prefab tag inserted with king type.
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>Humedad global</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>Índice de precipitación</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>Prob. de lluvia de ranas</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "Id. de shard: %s",
		shard_type = "Tipo de shard: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "Cargado en: %s",
		charge = "Carga: %s/%s"
	},

	-- repairer.lua
	repairer = {
		type = "Material de reparación: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>Restauración de salud</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>salud plana</sub></color> + <color=HEALTH>%s%%<sub>por ciento de salud</sub></color>",
		work = "<color=#DED15E>Reparación de estructura</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>estructura</sub></color>",
		perish = "<color=MONSTER>Frescor</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>Frescor</color>: <color=MONSTER>%s%%</color>",
		held_repair = "Held <color=SWEETENER><prefab=%s></color> will repair <color=LIGHT>%s</color> uses (<color=LIGHT>%s%%</color>).",
		materials = (IS_DST and {
			[MATERIALS.WOOD] =  "Madera",
			[MATERIALS.STONE] =  "Piedra",
			[MATERIALS.HAY] =  "Heno",
			[MATERIALS.THULECITE] =  "Tulecita",
			[MATERIALS.GEM] =  "Gema",
			[MATERIALS.GEARS] =  "Engranajes",
			[MATERIALS.MOONROCK] =  "Piedra lunar",
			[MATERIALS.ICE] =  "Hielo",
			[MATERIALS.SCULPTURE] =  "Escultura",
			[MATERIALS.FOSSIL] =  "Fósil",
			[MATERIALS.MOON_ALTAR] =  "Altar Lunar",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "<color=#99635D>Engranajes</color> necesarios: <color=#99635D>%s</color>",
	},

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL> aparecerá en %s",
		announce_spawn = "A <prefab=LUNARRIFT_PORTAL> aparecerá en %s",

		stage = "Etapa: %d / %d", -- augmented by growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "No se puede generar."
	},

	-- roseglasseshat.lua [Prefab]
	roseglasseshat = {
		ready_to_use = "Ready to inspect",
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>Daño adicional</color>: <color=HEALTH>%s</color>",
		absorption = "<color=HEALTH>Absorción de daño</color>: <color=HEALTH>%s%%</color>",
		bonus_speed = "<color=DAIRY>Velocidad extra</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>Cordura</color>: <color=SANITY>%s</color>/<color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>Iluminación</color>: <color=ENLIGHTENMENT>%s</color>/<color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		interaction = "<color=SANITY>Cordura</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = "<color=SANITY>Aura de cordura</color>: <color=SANITY>%s/min</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "Ya ha sido abierto.",
		chest_labyrinth = {
			sanity = "66% de prob. de cambiar la <color=SANITY>cordura</color> de <color=SANITY>-20</color> a <color=SANITY>20</color>.",
			hunger = "66% de prob. de cambiar el <color=HUNGER>hambre</color> de <color=HUNGER>-20</color> a <color=HUNGER>20</color>.",
			health = "66% de prob. de cambiar la <color=HEALTH>salud</color> de <color=HEALTH>0</color> a <color=HEALTH>20</color>.",
			inventory = "66% de prob. de cambiar la <color=LIGHT>durabilidad</color> o <color=MONSTER>frescura</color> en un 20%.",
			summonmonsters = "66% de probabilidad de invocar 1-3 <color=MOB_SPAWN>Depth Dweller(s)</color>.",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>Nivel de sombra</color>: %s",
		level_diff = "<color=BLACK>Nivel de sombra</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s daño</color>)",
		total_shadow_level = "<color=BLACK>Nivel total de sombra</color>: %s",
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
		close = "<prefab=SHADOWRIFT_PORTAL> se cerrará en %s",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "Generado por %s.",
			sanity_reward = "Recompensa de <color=SANITY>cordura</color>: <color=SANITY>%s</color>",
			sanity_reward_split = "Recompensa de <color=SANITY>cordura</color>: <color=SANITY>%s</color>/<color=SANITY>%s</color>",
		},
	},

	-- shadowthrall_mimics.lua
	shadowthrall_mimics = {
		mimic_count = "<string=UI.CUSTOMIZATIONSCREEN.ITEMMIMICS>: %s / %s",
		next_spawn = "<prefab=itemmimic_revealed> will try to spawn in %s",
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "La próxima fisura estará lista para ser tomada en %s",
		waiting_for_players = "Esperando a que un jugador se acerque",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		thralls_alive = "<color=MOB_SPAWN>Thralls alive (%d)</color>: %s",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color> regenerará en %s",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		--trades_remaining = "Trades left: %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "Alcance del refugio: %s unidades",
		shelter = "Refugio ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "Las <color=HEALTH>armas</color> duran <color=#aaaaee>%s%%</color> más",
			battlesong_healthgain = "Golpear enemigos restaura <color=HEALTH>%s</color> de <color=HEALTH>salud</color> (<color=HEALTH>%s</color> para Wigfrids)",
			battlesong_sanitygain = "Golpear enemigos restaura <color=SANITY>%s</color> de <color=SANITY>cordura</color>",
			battlesong_sanityaura = "Las <color=SANITY>auras de cordura</color> son <color=SANITY>%s%%</color> menos efectivas",
			battlesong_fireresistance = "Mitiga <color=HEALTH>%s%%</color> el <color=HEALTH>daño</color> por <color=LIGHT>fuego</color>",
			battlesong_lunaraligned = "Recibe <color=HEALTH>%s%% menos daño</color> de <color=LUNAR_ALIGNED>enemigos lunares</color>.\nInflige <color=HEALTH>%s%% más daño</color> a <color=SHADOW_ALIGNED>enemigos de sombras</color>.",
			battlesong_shadowaligned = "Recibe <color=HEALTH>%s%% menos daño</color> de <color=SHADOW_ALIGNED>enemigos de sombras</color>.\nInflige <color=HEALTH>%s%% más daño</color> a <color=LUNAR_ALIGNED>enemigos lunares</color>.",
			battlesong_instant_taunt = "Provoca a todos los enemigos cercanos",
			battlesong_instant_panic = "Asusta a todos enemigos menores por %s segundo(s)",
			battlesong_instant_revive = "Revive hasta %d aliados cercanos.",
		},
		cost = "Cuesta <color=INSPIRATION>%s de inspiración</color>",
		cooldown = "Recarga de canción: %s",
	},

	-- sinkholespawner.lua
	antlion_rage = "Antlion se enfurecerá en %s",

	-- skinner_beefalo.lua
	skinner_beefalo = "Temible: %s, Festivo: %s, Formal: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "Despertará en %s",
	},

	-- soul.lua
	wortox_soul_heal = "Restaura <color=HEALTH>%s</color> - <color=HEALTH>%s</color> de <color=HEALTH>salud</color>",
	wortox_soul_heal_range = "<color=HEALTH>Cura</color> a aliados dentro de <color=#DED15E>%s balsosas</color>",

	-- spawner.lua
	spawner = {
		next = "Generará <color=MOB_SPAWN><prefab={child_name}></color> en {respawn_time}.",
		child = "Genera <color=MOB_SPAWN><prefab=%s></color>",
		occupied = "Ocupado: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>Cura</color> a Webber por <color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>Cura</color> a las arañas por <color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>Golpes</color> restantes: <color=#aaaaee>%s</color>",
		time_to_reset = "Se reiniciará en %s" 
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>) se cocinará en %s segundo(s).",
		cooker = "Cocinado por <color=%s>%s</color>.",
		cooktime_modifier_slower = "Cocina <color=#DED15E>%s%%</color> más lento.",
		cooktime_modifier_faster = "Cocina <color=NATURE>%s%%</color> más rápido.",
	},

	-- stickable.lua
	stickable = "<color=FISH>Mejillones</color>: %s",

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
	temperature = "Temperatura: <temperature=%s>",
	
	-- tentacle_pillar_hole.lua [Prefab]
	tentacle_pillar_hole = {
		immunity_time = "<prefab=tentacle> immunity time: %s",
	},

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "Recupera <color=HEALTH>%s</color> de <color=HEALTH>salud</color> por día sin combatir.",
		eot_health = "<color=HEALTH>Salud</color> de <prefab=eyeofterror>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
		retinazor_health = "<color=HEALTH>Salud</color> de <prefab=TWINOFTERROR1>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
		spazmatism_health = "<color=HEALTH>Salud</color> de <prefab=TWINOFTERROR2>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium> estará listo en %s.",
	},

	-- tigersharker.lua
	tigershark_spawnin = "Puede desovar en: %s",
	tigershark_waiting = "Listo para desovar.",
	tigershark_exists = "El Tiburón Tigre está presente.",

	-- timer.lua
	timer = {
		label = "Temporizador <color=#8c8c8c>'%s'</color>: %s",
		paused = "En pausa",
	},

	-- toadstoolspawner.lua
	toadstoolspawner = {
		time_to_respawn = "<prefab=toadstool> reaparecerá en %s.",
	},

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>Eficiencia</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "Vale %s pepita(s) de oro",
	tradable_gold_dubloons = "Vale %s pepita(s) de oro y %s doblón(es)",
	tradable_rocktribute = "Retrasa la rabia de la <color=LIGHT>Hormigaleón</color> en %s",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "Mejora %s/%s: ",
	upgradeable_complete = "Mejora %s%% completa.",
	upgradeable_incomplete = "No se pueden hacer más mejoras.",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "Aumenta la <color=HEALTH>salud máxima</color> en <color=HEALTH>%d</color>.",
			maxsanity = "Aumenta la <color=SANITY>cordura máxima</color> en <color=SANITY>%d</color>.",
			movespeed = "Aumenta la <color=DAIRY>velocidad</color> en %s.",
			heat = "Aumenta la <color=#cc0000>temperatura mínima</color> en <color=#cc0000>%d</color>.",
			heat_drying = "Aumenta la <color=#cc000>velocidad de secado</color> en <color=#cc0000>%.1f</color>.",
			cold = "Disminuye la <color=#00C6FF>temperatura mínima</color> en <color=#00C6FF>%d</color>.",
			taser = "Inflige <color=WET>%d</color> %s a los atacantes (recarga: %.1f).",
			light = "Proporciona un <color=LIGHT>radio de luz</color> de <color=LIGHT>%.1f</color> (extras solo <color=LIGHT>%.1f</color>).",
			maxhunger = "Aumenta el <color=HUNGER>hambre máximo</color> en <color=HUNGER>%d</color>.",
			music = "Proporciona un <color=SANITY>aura de cordura</color> de <color=SANITY>%+.1f/min</color> dentro de <color=SANITY>%.1f</color> baldosas.",
			music_tend = "Cuida de las plantas dentro de <color=NATURE>%.1f</color> baldosas.",
			bee = "Regenera <color=HEALTH>%d salud/%ds</color> (<color=HEALTH>%d/día</color>).",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> reaparece en: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>Impermeabilidad</color>: <color=WET>%s%%</color>",
	
	-- watersource.lua
	watersource = "Es una fuente de agua.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "Aumenta la humedad en <color=WET>%s</color>."
	},

	-- wathgrithr_shield.lua [Prefab]
	wathgrithr_shield = {
		parry_duration_complex = "Duración del parry: <color=%s>%.1f<sub>normal</sub></color> | <color=%s>%.1f<sub>habilidad</sub></color>",
	},

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>Daño</color>",
		electric = "<color=WET>(Eléctrico)</color> <color=HEALTH>Daño</color>",
		poisonous = "<color=NATURE>(Venenoso)</color> <color=HEALTH>Daño</color>",
		thorns = "<color=HEALTH>(Espinoso)</color> <color=HEALTH>Daño</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Rango: %s",

	-- weather.lua
	weather = {
		progress_to_rain = "Progreso hacia la <color=WET>lluvia</color>", -- Numbers appended by code
		remaining_rain = "<color=WET>Lluvia restante</color>", -- Numbers appended by code

		progress_to_hail = "Progreso hacia el <color=LUNAR_ALIGNED>granizo</color>", -- Numbers appended by code
		remaining_hail = "<color=LUNAR_ALIGNED>Granizo restante</color>", -- Numbers appended by code

		progress_to_acid_rain = "Progreso hacia la <color=SHADOW_ALIGNED>lluvia <color=WET>ácida</color></color>", -- Numbers appended by code
		remaining_acid_rain = "<color=SHADOW_ALIGNED>Lluvia <color=WET>ácida</color> restante</color>", -- Numbers appended by code
	},

	-- weighable.lua
	weighable = {
		weight = "Peso: %s (%s%%)",
		weight_bounded = "Peso: %s <= %s (%s) <= %s",
		owner_name = "Dueño: %s"
	},

	-- werebeast.lua
	werebeast = "Troncómetro: %s/%s",

	-- wereness.lua
	wereness_remaining = "Troncómetro: %s/%s",

	-- winch.lua
	winch = {
		not_winch = "Tiene un componente de cabrestante, pero no pasa el control de prefabricación.",
		sunken_item = "Hay un <color=#66ee66>%s</color> debajo de este cabrestante.",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>Temperatura</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "Eres <color=#bbffbb>elegible</color> para <color=#DED15E>regalo especial</color>.",
		not_ready = "Debes <color=#ffbbbb>esperar %s día(s)</color> antes de poder conseguir otro <color=#DED15E>regalo especial</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "El cambio de estado se retrasa por: %s",
		wither = "Se marchita en: %s",
		rejuvenate = "Rejuvenece en: %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>Prob. de Árbol Guardián</color>: %s%%<sub>Tú</sub> & %s%%<sub>NPC</sub>",
		treeguard_chance = "<color=#636C5C>Prob. de Árbol Guardián</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "Desagüe desactivado.",
		target_shard = "Shard objetivo: %s",
		received_portal = "Portal de destino: %s", -- Shard Migrator
		id = "Portal N°: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "Temporizador <color=#8c8c8c>'%s'</color>: %s",
		paused = "En pausa.",
	},

	-- wortox.lua [Prefab]
	wortox = {
		time_untl_panflute_inspiration = "Wortox will get a free <prefab=panflute> use in %s",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "Carga restante: %s",
		gain_charge_time = "Ganarás una <color=LIGHT>carga</color> en: <color=LIGHT>%s</color>",
		full_charge = "¡Totalmente cargado!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "Progreso de escaneo: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "Terminará de coser en: %s",
}