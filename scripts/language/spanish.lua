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

-- Translated by: https://steamcommunity.com/profiles/76561198214514027

-- TheNet:GetLanguageCode() == "spanish" & LOC.GetLocaleCode() == "es"

return {
	-- insightservercrash.lua
	crash_reporter = {
		title = "[Reporte de crash de Insight]",
		crashed = "El juego se crasheó.",
		report_status = {
			unknown = "Desconocido",
			disabled = "El crash reporter está <color=#666666>desactivado</color>: <color=#666666>%s</color>",
			sending = "Enviando reporte de crash",
			success = "Crash report enviado a Insight. <u>¡Esto NO significa que Insight causó el problema!</u>",
			failure = "Falló el envío del crash report (%s): %s",
		},
	},
	
	-- modmain.lua
	dragonfly_ready = "Lista para pelear.",

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
		title = "¡Bienvenido a Insight!",
		description = "Parece que es tu primera vez usando Insight.\nTe recomiendo revisar la configuración o aplicar un preset.",
		no = "No gracias",
		configuration = "Configuración",
		presets = "Presets",
	},

	-- insightconfigurationscreen.lua
	preset_button = "Presets",

	-- insightpresetscreen.lua
	presetscreen = {
		title = "Presets de configuración",
		description = "Selecciona un preset.",
	},

	-- Keybinds
	unbind = "Desvincular",
	keybinds = {
		label = "Keybinds (solo teclado)",
		togglemenu = {
			name = "Abrir menú de Insight",
			description = "Abre/Cierra el menú de Insight"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[Aviso de peligro]: ",
		boss = "[Aviso de boss]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "Jugador nuevo",
				description = "Recomendado para quienes van empezando."
			},
			simple = {
				label = "Simple",
				description = "Poca info, similar a Show Me.",
			},
			decent = {
				label = "Decente",
				description = "Cantidad media de info, muy similar a los ajustes default.",
			},
			advanced = {
				label = "Avanzado",
				description = "Ideal para la gente que quiere ver datos.",
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
		dismiss = "Descartar %s",
	},

	-- Damage helper
	damage_types = {
		-- Normal
		explosive = "Explosivo",
		
		-- Planar
		lunar_aligned = "Alineado lunar",
		shadow_aligned = "Alineado sombrío",
	},

	-- mapscreen and related
	map = {
		land_exploration = "Terreno explorado: <color=%s>%.1f%%</color>",
	},

	-------------------------------------------------------------------------------------------------------------------------
	
	-- acidbatwavemanager.lua
	acidbatwavemanager = {
		chance = "Probabilidad de raid de murciélagos: <color=%s>%.1f%%</color> (estimado=<color=%s>%.1f%%</color>)",
		next_wave_spawn = "La raid de <prefab=bat> (%d) llega en %s"
	},

	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "<color=SANITY>Cordura mínima</color> para luz: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_sanity = "Tu <color=SANITY>cordura</color> es: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "Los <color=ENLIGHTENMENT>gestalt</color> invocados hacen <color=HEALTH>%s</color> de daño.",
	},
	
	-- ancienttree_seed.lua [Prefab]
	ancienttree_seed = {
		type = "Tipo: <color=%s><prefab=%s></color>",
		fruit_regen_time = "Tiempo de fruto: %s",
		fruit_regen_time_bounded = "Tiempo de fruto: %s <= %s <= %s",
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
		lunge_damage = "Embestida {damageType}: <color=HEALTH>{damage}</color>",
	},
	

	-- appeasement.lua
	appease_good = "Retrasa la erupción %s segmento(s).",
	appease_bad = "Acelera la erupción %s segmento(s).",

	-- appraisable.lua
	appraisable = "Temible: %s, Festivo: %s, Formal: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "Desbloquea: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>Protección</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>Durabilidad</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>Durabilidad</color>: <color=#C0C0C0>%s</color>",

	-- armordreadstone.lua
	armordreadstone = {
		regen = "Regenera <color=%s>%.1f</color> de <color=#C0C0C0>durabilidad</color> cada %ds",
		regen_complete = "Regenera <color=%s>%.1f<sub>mín</sub></color> / <color=%s>%.1f<sub>actual</sub></color> / <color=%s>%.1f<sub>máx</sub></color> de <color=#C0C0C0>durabilidad</color> cada %ds según la locura"
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate> se reiniciará en %s.",
	},

	-- attunable.lua
	attunable = {
		linked = "Vinculado a: %s",
		offline_linked = "Vínculos sin conexión: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "Restaura <color=HEALTH>%s de salud</color> por golpe.",
		sanity_cost = "Consume <color=SANITY>%s de cordura</color> por golpe.",
	},

	-- beard.lua
	beard = "La barba mejorará en %s día(s).",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>Objetivo: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger> aparecerá sobre %s (<prefab=%s>) en %s.",
		bearger_attack = "<prefab=bearger> atacará en %s."
	},

	-- beef_bell.lua [Prefab]
	beef_bell = {
		beefalo_name = "Nombre: %s",
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen> reaparecerá en %s.",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "Resistencia: %.5f",
		max_velocity_mod = "Mod. de velocidad máxima: %.3f",
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
			horticulture_upgraded = "Hace crecer y atiende hasta <color=%s>%d plantas</color>",
			--silviculture = "Grows basic resource plants.",
			--fish = "",
			--fire = ""
			web = "Invoca una <color=%s>telaraña</color> que dura <color=%s>%s</color>",
			--temperature = ""
			light = "Invoca una <color=LIGHT>luz</color> por <color=LIGHT>%s</color>",
			-- light_upgraded is just light
			rain = "Activa la <color=WET>lluvia</color> y <color=WET>riega las plantas cercanas</color>",
			bees = "Invoca <color=%s>%d abejas</color> hasta <color=%s>%d</color>",
			research_station = "Cargas de prototipo: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "Invoca <color=%s>%d meteoritos</color>",
		},
	},

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>Pez tropical</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>Mero púrpura</color>",
	breeder_fish4 = "<color=#DED15E>Pez Pierrot</color>",
	breeder_fish5 = "<color=#9ADFDE>Neon Quattro</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "Pez adicional en: %s",
	breeder_possiblepredatortime = "Puede aparecer un depredador en: %s",

	-- brushable.lua
	brushable = {
		last_brushed = "Cepillado hace %s día(s)."
	},

	-- burnable.lua
	burnable = {
		smolder_time = "Se <color=LIGHT>encenderá</color> en: <color=LIGHT>%s</color>",
		burn_time = "Tiempo <color=LIGHT>de combustión restante</color>: <color=LIGHT>%s</color>",
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
		undecided = "Debes colocarlo antes de conocer el contenido."
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>Rango</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "Decor total: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "Nivel de <color=#DBC033>gas</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "Probabilidad de quedar <color=#522E61>envenenado</color>: <color=#D8B400>%d%%</color>",
		gas_level_increase = "Aumenta en %s.",
		gas_level_decrease = "Disminuye en %s."
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "Vidas de gato: %s / %s",
		regenerate = "Los gatos reaparecen en: %s",
		waiting_for_sleep = "Esperando a que los jugadores cercanos se alejen.",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "Esperando a que regreses a la escena del crimen.",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> reaparecerá en: %s",
	announce_chester_respawn = "Mi <prefab=chester> reaparecerá en %s.",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fuera</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fuera</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> y <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "Regenerando {to_regen} en {regen_time}",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>Daño</color>: <color=HEALTH>%s</color>",
		damageToYou = " (<color=HEALTH>%s</color> hacia ti)",
		age_damage = "<color=HEALTH>Daño <color=AGE>(Edad)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> hacia ti)",
		yotr_pillows = {
			--@@ Weapons
			knockback = "<color=VEGGIE>Empuje</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "Knockback Multiplier: %s",
			laglength = "<color=VEGGIE>Cooldown</color>: %s",
			
			--@@ Armor
			defense_amount = "<color=VEGGIE>Defensa</color>: %s",
			
			--@@ Both
			prize_value = "Valor del premio: %s",
		},
	},

	-- compostingbin.lua
	compostingbin = {
		contents_amount = "Material: %s / %s",
		detailed_contents_amount = "Material: <color=NATURE>%s<sub>Verde</sub></color> + <color=INEDIBLE>%s<sub>Marrón</sub></color> / %s",
	},

	-- container.lua
	container = {
		
	},

	-- containerinstallableitem.lua
	containerinstallableitem = {
		slingshot_band = {
			range = "Aumenta el alcance en <color=FRUIT>%s</color>",
			speed = "Aumenta la velocidad del proyectil en <color=FRUIT>%.0f%%</color>"
		},
		slingshot_handle = {
			firing_rate = "Cadencia: %s ataques/segundo",
		}
	},

	-- cooldown.lua
	cooldown = "Cooldown: %s",

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
		step = "Paso: %s / %s",
		note = ", nota: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> de daño a entidades %s",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> de daño recibido de ataques %s",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>Cordura</color>: <color=SANITY>%s/min</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER> reaparecerá en %s día(s)",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>Buff</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = {
			name = "<color=HEALTH>Boost de ataque</color>",
			description = "Tus ataques son <color=HEALTH>{percent}% más fuertes</color> por {duration} s.",
		},
		["buff_playerabsorption"] = {
			name = "<color=MEAT>Absorción de daño</color>",
			description = "Recibes <color=MEAT>{percent}%</color> menos daño por {duration} s.",
		},
		["buff_workeffectiveness"] = {
			name = "<color=SWEETENER>Eficiencia laboral</color>",
			description = "Tu trabajo es <color=#DED15E>{percent}%</color> más efectivo por {duration} s.",
		},
		
		["buff_moistureimmunity"] = {
			name = "<color=WET>Inmunidad a la humedad</color>",
			description = "Eres inmune a la <color=WET>humedad</color> por {duration} s.",
		},
		["buff_electricattack"] = {
			name = "<color=WET>Ataques eléctricos</color>",
			description = "Tus ataques se vuelven <color=WET>eléctricos</color> por {duration} s.",
		},
		["buff_sleepresistance"] = {
			name = "<color=MONSTER>Resistencia al sueño</color>",
			description = "Resistes el <color=MONSTER>sueño</color> por {duration} s.",
		},
		
		["healingsalve_acidbuff"] = {
			name = "<color=#ded15e>Resistencia ácida</color>",
			description = "Inmune a la <color=#ded15e>lluvia ácida</color> por {duration} s."
		},
		["tillweedsalve_buff"] = {
			name = "<color=HEALTH>Regeneración de salud</color>",
			description = "Regenera <color=HEALTH>{amount} de salud</color> en {duration} s.",
		},
		["healthregenbuff"] = {
			name = "<color=HEALTH>Regeneración de salud</color>",
			description = "Regenera <color=HEALTH>{amount} de salud</color> en {duration} s.",
		},
		["sweettea_buff"] = {
			name = "<color=SANITY>Regeneración de cordura</color>",
			description = "Regenera <color=SANITY>{amount} de cordura</color> en {duration} s.",
		},
		["nightvision_buff"] = {
			name = "<color=#258cd3>Visión nocturna</color>",
			description = "Otorga <color=#258cd3>visión nocturna</color> por {duration} s.",
		},
		["wormlight_light"] = {
			name = "<color=#6AD1EF>Luz de <prefab=wormlight></color>",
			--description = "Provides light for {duration}(s).",
		},
		["wormlight_light_lesser"] = function(parent) return deepcopy(parent.wormlight_light) end,
		["wormlight_light_greater"] = function(parent) return deepcopy(parent.wormlight_light) end,

		["wintersfeastbuff"] = {
			name = "<color=FROZEN>Buff de Winter's Feast</color>",
			description = "Restaura <color=HUNGER>Hambre</color>, <color=SANITY>Cordura</color> y <color=HEALTH>Salud</color>."
		},
		["wortox_panflute_buff"] = {
			name = "<color=FROZEN>Inspiración de flauta</color>",
			description = "Wortox obtiene un uso gratis de una <prefab=panflute>."
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER>Buff de <prefab=batnosehat></color>",
			description = "Regenera <color=HUNGER>{amount} de hambre</color> en {duration} s.",
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
			name = "<color=SANITY>Valentía</color> contra murciélagos.",
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
	disease_in = "Se enfermará en: %s",
	disease_spread = "Propagará la enfermedad en: %s",
	disease_delay = "La enfermedad se retrasa por: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "Domesticación: %s%%",
		obedience = "Obediencia: %s%%",
		--obedience_extended = "Obedience: %s%% (%s%%<sub>to saddle</sub>, <%s%%<sub>buck saddle</sub>, %s%%<sub>to ride</sub>)",
		obedience_extended = "Obediencia: %s%% (<%s%%<sub>se sacude la montura</sub>, %s%%<sub>mínimo</sub>)",
		tendency = "Tendencia: %s",
		tendencies = {
			["NONE"] = "Ninguna",
			[TENDENCY.DEFAULT] = "Normal",
			[TENDENCY.ORNERY] = "Fiera",
			[TENDENCY.RIDER] = "Jinete",
			[TENDENCY.PUDGY] = "Gordito"
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
		eot_loot = "La comida restaura <color=HUNGER>%s%% de hambre</color> + <color=HEALTH>%s%% de salud</color> como durabilidad.",
		eot_tofeed_restore = "Alimentar con <color=MEAT><prefab=%s></color> restaurará <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) de durabilidad.",
		eot_tofeed_restore_advanced = "Alimentar con <color=MEAT><prefab=%s></color> restaurará <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) de durabilidad.",
		tofeed_restore = "Alimentar con <color=MEAT><prefab=%s></color> restaurará %s.",
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
		inedible = "inedible",
		bug = "insecto",
		seed = "semilla",
		antihistamine = "antihistamínico", -- Only "cutnettle"
	},
	edible_foodeffect = {
		temperature = "Temperatura: %s, %s",
		caffeine = "Velocidad: %s, %s",
		surf = "Velocidad del barco: %s, %s",
		autodry = "Bono de secado: %s, %s",
		instant_temperature = "Temperatura: %s (instantánea)",
		antihistamine = "Retraso de alergias: %ss",
	},
	foodmemory = "Comido recientemente: %s / %s, lo olvidará en: %s",
	wereeater = "<color=MONSTER>Carne de monstruo</color> comida: %s / %s, lo olvidará en: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>Velocidad</color>: %s%%",
	hunger_slow = "<color=HUNGER>Consumo de hambre reducido</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>Consumo de hambre</color>: <color=HUNGER>%s%%</color>",
	insulated = "Te protege de los rayos.",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>Daño explosivo</color>: %s",
	explosive_range = "<color=LIGHT>Rango explosivo</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "Crecerá como un <color=NATURE><prefab=%s></color>.",
		nutrient_consumption = "ΔNutrientes: [<color=NATURE>%d<sub>Fórmula</sub></color>, <color=CAMO>%d<sub>Composta</sub></color>, <color=INEDIBLE>%d<sub>Estiércol</sub></color>]",
		good_seasons = "Temporadas: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "Puntos de estrés: %s",
		display = "Factores de estrés: %s",
		stress_tier = "Nivel de estrés: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "Ninguno",
			[FARM_PLANT_STRESS.LOW] = "Bajo",
			[FARM_PLANT_STRESS.MODERATE] = "Medio",
			[FARM_PLANT_STRESS.HIGH] = "Alto",
		} or {}),
		categories = {
			["nutrients"] = "Nutrientes", -- missing nutrients
			["moisture"] = "Humedad", -- needs water
			["killjoys"] = "Hierbajos", -- weeds nearby
			["family"] = "Familia", -- no similar plants nearby
			["overcrowding"] = "Hacinamiento", -- too crowded
			["season"] = "Temporada", -- out of season
			["happiness"] = "Cuidado", -- not tended to
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>Agua</color>: <color=WET>%s<sub>tile</sub></color>*",
		soil_plant = "<color=WET>Agua</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s/min<sub>planta</sub></color>)*",
		soil_plant_tile = "<color=WET>Agua</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>planta</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color>])<color=WET>/min</color>*",
		soil_plant_tile_net = "<color=WET>Agua</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>planta</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color> + <color=SHALLOWS>%s<sub>mundo</sub></color> = <color=#DED15E>%+.1f<sub>neto</sub></color>])<color=WET>/min</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>*",
		soil_plant = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplanta</sub>)*",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=#bee391>%+d<sub>F</sub></color>, <color=#7a9c6e>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		soil_plant_tile = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>   ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplanta</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tileΔ</sub>)",
		--soil_plant_tile_net = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] + [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] = [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "Reduce el <color=NATURE>tiempo de crecimiento</color> en <color=NATURE>%s</color> segundos.",
		nutrient_value = "Nutrientes: [<color=NATURE>%s<sub>Fórmula</sub></color>, <color=CAMO>%s<sub>Composta</sub></color>, <color=INEDIBLE>%s<sub>Estiércol</sub></color>]",
		wormwood = {
			formula_growth = "Acelera tu <color=LIGHT_PINK>floración</color> en <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>Te cura</color> <color=HEALTH>{healing}</color> durante <color=HEALTH>{duration}</color> segundo(s).",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "Se puede llenar con agua del mar.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s / %s",
	actions = {
		USES_PLAIN = "Usos",
		TERRAFORM = "Terraformar",
		GAS = "Gas", -- hamlet
		DISARM = "Desarmar", -- hamlet
		PAN = "Panear", -- hamlet
		DISLODGE = "Cincelar", -- hamlet
		SPY = "Investigar", -- hamlet
		THROW = "Lanzar", -- sw -- Action string is "Throw At"
		ROW_FAIL = "Remar (fallo)",
		--ATTACK = "<string=ACTIONS.ATTACK.GENERIC>", --STRINGS.ACTIONS.ATTACK.GENERIC,
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>", --STRINGS.ACTIONS.POUR_WATER.GENERIC,
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>Peces</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": +1 pez en: %s",
	fish_wait_time = "Tardará <color=SHALLOWS>%s segundos</color> en picar un pez.",

	-- fishingrod.lua
	fishingrod_waittimes = "Tiempo de espera: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Tiempo máximo de forcejeo: <color=SHALLOWS>%s</color>",

	-- flotsamgenerator.lua
	flotsamgenerator = {
		messagebottle_cooldown = "Siguiente <prefab=messagebottle> en: %s",
	},

	-- follower.lua
	leader = "Líder: %s",
	loyalty_duration = "Duración de lealtad: %s",

	-- forcecompostable.lua
	forcecompostable = "Valor de composta: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "20%% de probabilidad de fallar con %s pieza(s) más.",
		correct = "Esto está ensamblado correctamente.",
		incorrect = "Esto está mal ensamblado.",
		gateway_too_far = "Este esqueleto está a %s tile(s) de más.",
	},

	-- friendlevels.lua
	friendlevel = "Nivel de amistad: %s / %s",

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
			NIGHTMARE = "Combustible de pesadilla",
			NONE = "Tiempo", -- will never be refueled...............................
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
		held_refuel = "El <color=SWEETENER><prefab=%s></color> cargará <color=LIGHT>%s%%</color>.",
	},

	-- gelblobspawner.lua
	gelblobspawner = {
		
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>Vínculo fraternal</color>: %s / %s.",
		flower = "Tu <color=%s>vínculo fraternal</color>: %s / %s. ",
		levelup = " +1 en %s.",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "Regenera <color=HEALTH>%s de salud</color> en %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_fastregen = "Regenera <color=HEALTH>%s de salud</color> en %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_attack = "Maximiza el <color=HEALTH>daño</color> por %s.",
		ghostlyelixir_speed = "Aumenta la <color=DAIRY>velocidad</color> en <color=DAIRY>%s%%</color> por %s.",
		ghostlyelixir_shield = "Extiende la duración del escudo a 1 segundo por %s.",
		ghostlyelixir_retaliation = "El escudo refleja <color=HEALTH>%s de daño</color> por %s.", -- concatenated with shield
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "Duración de <color=#737CD0><prefab=%s></color>: %s.",
	},

	-- growable.lua
	growable = {
		stage = "Etapa <color=#8c8c8c>'%s'</color>: %s / %s: ",
		paused = "Crecimiento en pausa.",
		next_stage = "Siguiente etapa en %s.",
	},

	-- grower.lua
	harvests = "<color=NATURE>Cosechas</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 en %s.",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "Incomodidad: %s / %s",
		progress = "Progreso de eclosión: %s / %s",
	},

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>Salud</color>: <color=HEALTH>%+d</color>",
		webber_heal = "Salud de Webber: <color=HEALTH>%+d</color>",
		spider_heal = "Salud de araña: <color=HEALTH>%+d</color>",
	},

	-- health.lua
	health = "<color=HEALTH>Salud</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
	absorption = " : Absorbiendo %s%% del daño.",

	-- heatrock.lua [Prefab]
	heatrock_temperature = "Temperatura: %s < %s < %s",

	-- herdmember.lua
	herd_size = "Tamaño de la manada: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "Rango para esconderse: %s a %s",
		needed_hiding_spots = "Escondites necesarios: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "<prefab=hound> atacan en %s",
		time_until_worms = "<prefab=worm> atacan en %s",
		time_until_worm_boss = "<prefab=worm_boss> ataca en %s",
		time_until_crocodog = "<prefab=crocodog> ataca en %s",
		worm_boss_chance = "Probabilidad de <prefab=worm_boss>: %.1f%%",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>Hambre</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "<color=HUNGER>Consumo de hambre</color>: <color=HUNGER>%+d/día</color> (<color=HUNGER>%s/s</color>)",
	hunger_paused = "Decaimiento de <color=HUNGER>hambre</color> en pausa.",

	-- hunter.lua
	hunter = {
		hunt_progress = "Rastro: %s / %s",
		impending_ambush = "Hay una emboscada esperando en el siguiente rastro.",
		alternate_beast_chance = "<color=#b51212>%s%% de probabilidad</color> de un <color=MOB_SPAWN>Varg</color> o <color=MOB_SPAWN>Ewecus</color>.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> reaparecerá en: %s",
	announce_hutch_respawn = "Mi <prefab=hutch> reaparecerá en %s.",

	-- inspectable.lua
	wagstaff_tool = "El nombre de esta herramienta es: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "Peso del gimnasio: %s",
	ruins_statue_gem = "Contiene un <color=%s><prefab=%s></color>.",

	-- inspectacleshat.lua [Prefab]
	inspectacleshat = {
		ready_to_use = "Lista para inspeccionar",
	},

	-- insulator.lua
	insulation_winter = "<color=FROZEN>Aislamiento (Invierno)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>Aislamiento (Verano)</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		head_describe = "[Sombrero]: ",
		hands_describe = "[Herramienta]: ",
	},

	-- itemmimic.lua
	itemmimic = {
		time_to_reveal = "<prefab=itemmimic_revealed> se revelará en: %s",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "Número de mapachitos: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>Botín notable</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "Desaparece el día: %s",
		announce_despawn = "<prefab=klaus_sack> desaparecerá el día %s.",
		announce_spawn = "<prefab=klaus_sack> aparecerá en %s.",
	},

	-- kramped.lua
	kramped = {
		naughtiness = "Traviesura: %s",
		localplayer_naughtiness = "Tus travesuras: %s / %s",
	},

	-- leader.lua
	followers = "Seguidores: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "Rango de protección contra rayos: %s unidades",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "Se descargará en %s día(s).",

	-- linkeditem.lua
	linkeditem = {
		owner = "Dueño: %s",
	},

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>disponible</sub> / %d<sub>total</sub> / %d<sub>máx</sub>", -- I can't think of a way to word 
		next_crystal = "El próximo <color=#4093B2><prefab=lunarrift_crystal_big></color> aparece en %s",
		close = "<prefab=LUNARRIFT_PORTAL> se cerrará aproximadamente en %s",
	},

	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "%d plantas infestadas",
		spawn = "Los gestalts aparecen en %s",
		next_wave = "Siguiente oleada en %s",
		remain_waves = "%d oleadas restantes",
	},

	-- lunarthrall_plant.lua [Prefab]
	lunarthrall_plant = {
		time_to_aggro = "La vulnerabilidad termina en: <color=%s>%.1f</color>",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "Se activará en: %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "Terminará en: %s",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "Esperando a que alguien vaya a un banco de peces.",
		time_to_respawn = "<prefab=malbatross> reaparecerá en %s.",
	},

	-- mast.lua
	mast_sail_force = "Fuerza de vela: %s",
	mast_max_velocity = "Velocidad máxima: %s",

	-- mermcandidate.lua
	mermcandidate = "Calorías: %s / %s",

	-- messagebottlemanager.lua
	messagebottlemanager = "Tesoros por recoger: %d / %d",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>Fuerzudo</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color> - <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>Fuerzudo</color> por uso: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "Peso del gimnasio: %s",
		mighty_gains = "<color=MIGHTINESS>Levantamiento</color> normal: <color=MIGHTINESS>%+.1f</color>, <color=MIGHTINESS>Levantamiento</color> perfecto: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>Consumo de hambre</color>: <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "Revisa detonadores cada %s segundo(s).",
		inactive = "No está revisando detonadores.",
		beemine_bees = "Liberará %s abeja(s).",
		trap_starfish_cooldown = "Se rearma en: %s",
	},

	-- moisture.lua
	moisture = "<color=WET>Humedad</color>: <color=WET>%s%%</color>", --moisture = "<color=WET>Wetness</color>: %s / %s (%s%%)",

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "Velocidad de interacción con mástil/ancla: {feature_speed}\nUso de durabilidad del remo: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "Reducción de daño al barco: {reduction}",

	-- mood.lua
	mood = {
		exit = "Saldrá de este estado en %s día(s).",
		enter = "Entrará en este estado en %s día(s).",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "Progreso hacia el destino: %s / %s",
			time_for_next_tool = "Necesitará otra herramienta en %s.",
			experiment_time = "El experimento terminará en %s.",
		},
		storm_move = "%s%% de probabilidad de mover las tormentas lunares el día %s.",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>Fase: %s</color>, %s",
		phase_locked = "Bloqueado por la <color=#CE3D45>Llave antigua</color>.",
		announce_phase_locked = "Las ruinas están bloqueadas en la fase pesadilla.",
		announce_phase = "Las ruinas están en la fase %s (quedan %s).",
		phases = {
			["calm"] = "Calma",
			["warn"] = "Alerta",
			["wild"] = "Pesadilla",
			["dawn"] = "Amanecer"
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
			distance = "Distancia: %.1f<sub>pescar</sub> / <color=%s>%.1f<sub>actual</sub></color> / %.1f<sub>huir</sub>",
		},
	},

	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "Distancia extra: %s",
			bonus_accuracy = "Precisión extra: <color=#66CC00>%+.1f%%<sub>mín</sub></color> / <color=#5B63D2>%+.1f%%<sub>máx</sub></color>",
		},
		lure = {
			charm = "Encanto: <color=#66CC00>%.1f<sub>base</sub></color> + <color=#5B63D2>%.1f<sub>recogida</sub></color>",
			stamina_drain = "Drenaje extra de stamina: %.1f",
			time_of_day_modifier = "Efectividad por fase: <color=DAY_BRIGHT>%d%%<sub>día</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>atardecer</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>noche</sub></color>",
			weather_modifier = "Efectividad por clima: <color=#bbbbbb>%d%%<sub>despejado</sub></color> / <color=#7BA3F2>%d%%<sub>lluvia</sub></color> / <color=FROZEN>%d%%<sub>nieve</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "Progreso de crecimiento gigante: %s / %s",

	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>Edad</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "Nivel de <color=#E3D740>oro</color>: %.1f / %.1f",
		gold_level = "Nivel de <color=#E3D740>oro</color>: %.1f",
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
		rot = "Se pudre",
		stale = "Se echa a perder",
		spoil = "Se arruina",
		dies = "Se muere",
		starves = "Se seca",
		transition = "<color=MONSTER>{next_stage}</color> en {time}",
		transition_extended = "<color=MONSTER>{next_stage}</color> en {time} (<color=MONSTER>{percent}%</color>)",
		paused = "Actualmente no se deteriora.",
	},

	-- petrifiable.lua
	petrify = "Se petrificará en %s.",

	-- pickable.lua
	pickable = {
		regrowth = "<color=NATURE>Vuelve a crecer</color> en: <color=NATURE>%s</color>",
		regrowth_paused = "Recrecimiento en pausa.",
		cycles = "<color=DECORATION>Cosechas restantes</color>: <color=DECORATION>%s</color> / <color=DECORATION>%s</color>",
		mushroom_rain = "Se necesita <color=WET>lluvia</color>: %s",
	},

	-- planardamage.lua
	planardamage = {
		planar_damage = "<color=PLANAR>Daño planar</color>: <color=PLANAR>%s</color>",
		additional_damage = " (<color=PLANAR>+%s<sub>bono</sub></color>)",
	},

	-- planardefense.lua
	planardefense = {
		planar_defense = "<color=PLANAR>Defensa planar</color>: <color=PLANAR>%s</color>",
		additional_defense = " (<color=PLANAR>+%s<sub>bono</sub></color>)",
	},

	-- poisonable.lua
	poisonable = {
		remaining_time = "El <color=NATURE>veneno</color> expira en %s",
	},
	
	-- pollinator.lua
	pollination = "Flores polinizadas: (%s) / %s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "Mi <prefab=polly_rogers> reaparecerá en %s."
	},

	-- preservative.lua
	preservative = "Restaura el %s%% de frescura.",

	-- preserver.lua
	preserver = {
		spoilage_rate = "<color=#ad5db3>Tasa de deterioro</color>: <color=#ad5db3>%.1f%%</color>",
		freshness_rate = "<color=FROZEN>Tasa de frescura</color>: <color=FROZEN>%.1f%%</color>",
	},

	-- quaker.lua
	quaker = {
		next_quake = "Próximo <color=INEDIBLE>terremoto</color> en %s.",
	},

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Juguetes restantes: %s",
			assisted_by = "Este pipspook está siendo asistido por %s.",
		},
	},

	-- rabbitkingmanager.lua
	rabbitkingmanager = {
		carrots = "<color=VEGGIE>Zanahorias</color>: <color=VEGGIE>%d</color> / <color=VEGGIE>%d</color>",
		naughtiness = "Traviesura: %d / %d",
		king_status = "%s está vivo.", -- Gets a prefab tag inserted with king type.
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>Humedad global</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>Tasa de precipitación</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>Probabilidad de lluvia de ranas</color>: <color=FROG>%s%%</color>",

	-- recallmark.lua
	recallmark = {
		shard_id = "ID del fragmento: %s",
		shard_type = "Tipo de fragmento: %s",
	},

	-- rechargeable.lua
	rechargeable = {
		charged_in = "Se carga en: %s",
		charge = "Carga: %s / %s"
	},

	-- repairer.lua
	repairer = {
		type = "Material de reparación: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>Curación</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>HP fijo</sub></color> + <color=HEALTH>%s%%<sub>HP porcentual</sub></color>",
		work = "<color=#DED15E>Reparación de trabajo</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>trabajo</sub></color>",
		perish = "<color=MONSTER>Refresca</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>Refresca</color>: <color=MONSTER>%s%%</color>",
		held_repair = "El <color=SWEETENER><prefab=%s></color> en mano reparará <color=LIGHT>%s</color> usos (<color=LIGHT>%s%%</color>).",
		materials = (IS_DST and {
			[MATERIALS.WOOD] =  "Madera",
			[MATERIALS.STONE] =  "Piedra",
			[MATERIALS.HAY] =  "Heno",
			[MATERIALS.THULECITE] =  "Thulecite",
			[MATERIALS.GEM] =  "Gema",
			[MATERIALS.GEARS] =  "Engranes",
			[MATERIALS.MOONROCK] =  "Roca lunar",
			[MATERIALS.ICE] =  "Hielo",
			[MATERIALS.SCULPTURE] =  "Escultura",
			[MATERIALS.FOSSIL] =  "Fósil",
			[MATERIALS.MOON_ALTAR] =  "Altar lunar",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "Necesitas <color=#99635D>Engranes</color>: <color=#99635D>%s</color>",
	},

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL> aparece en %s",
		announce_spawn = "Un <prefab=LUNARRIFT_PORTAL> aparecerá en %s",

		stage = "Etapa: %d / %d", -- augmented by growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "No puede aparecer."
	},

	-- roseglasseshat.lua [Prefab]
	roseglasseshat = {
		ready_to_use = "Lista para inspeccionar",
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>Daño extra</color>: <color=HEALTH>%s</color>",
		absorption = "<color=HEALTH>Absorción de daño</color>: <color=HEALTH>%s%%</color>",
		bonus_speed = "<color=DAIRY>Velocidad extra</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>Cordura</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>Iluminación</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		dapperness_mult = "<color=SANITY>Dapperness Multiplier</color>: <color=SANITY>%+.1f%%</color>",
		interaction = "<color=SANITY>Cordura</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = {
		aura_value = "<color=SANITY>Aura de cordura</color>: <color=SANITY>%s/min</color>",
		negative_aura_modifier = "Negative <color=SANITY>sanity aura</color> resistance: <color=SANITY>%+.0f%%</color>",
	},

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "Esto ya fue abierto.",
		chest_labyrinth = {
			sanity = "66% de probabilidad de cambiar la <color=SANITY>cordura</color> entre <color=SANITY>-20</color> y <color=SANITY>20</color>.",
			hunger = "66% de probabilidad de cambiar el <color=HUNGER>hambre</color> entre <color=HUNGER>-20</color> y <color=HUNGER>20</color>.",
			health = "66% de probabilidad de cambiar la <color=HEALTH>salud</color> entre <color=HEALTH>0</color> y <color=HEALTH>20</color>.",
			inventory = "66% de probabilidad de cambiar la <color=LIGHT>durabilidad</color> o la <color=MONSTER>frescura</color> en 20%.",
			summonmonsters = "66% de probabilidad de invocar 1-3 <color=MOB_SPAWN>habitantes de profundidad</color>.",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>Nivel sombrío</color>: %s",
		level_diff = "<color=BLACK>Nivel sombrío</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s de daño</color>)",
		total_shadow_level = "<color=BLACK>Nivel sombrío total</color>: %s",
	},

	-- shadowparasitemanager.lua
	shadowparasitemanager = {
		num_waves = "Oleadas: %d",
	}, 

	-- shadow_battleaxe.lua [Prefab]
	shadow_battleaxe = {
		level = "Nivel: %s / %s",
		boss_progress = "Jefes derrotados: %s / %s",
		lifesteal = "<color=HEALTH>Robo de vida</color>: <color=HEALTH>%.2f</color> (<color=SANITY>%.2f</color>)",
	},

	-- shadowrift_portal.lua [Prefab]
	shadowrift_portal = {
		close = "<prefab=SHADOWRIFT_PORTAL> se cerrará en %s",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "Invocado por %s.",
			sanity_reward = "Recompensa de <color=SANITY>cordura</color>: <color=SANITY>%s</color>",
			sanity_reward_split = "Recompensa de <color=SANITY>cordura</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- shadowthrall_mimics.lua
	shadowthrall_mimics = {
		mimic_count = "<string=UI.CUSTOMIZATIONSCREEN.ITEMMIMICS>: %s / %s",
		next_spawn = "<prefab=itemmimic_revealed> intentará aparecer en %s",
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "La siguiente fisura estará lista para capturar en %s",
		waiting_for_players = "Esperando a que un jugador se acerque",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		thralls_alive = "<color=MOB_SPAWN>Esbirros vivos (%d)</color>: %s",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color> regenerará en %s",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		trades_remaining = "Trueques restantes: %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "Rango de refugio: %s unidades",
		shelter = "Refugio ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "Las <color=HEALTH>armas</color> duran <color=#aaaaee>%s%%</color> más.",
			battlesong_healthgain = "Golpear enemigos restaura <color=HEALTH>%s de salud</color> (<color=HEALTH>%s</color> para Wigfrid).",
			battlesong_sanitygain = "Golpear enemigos restaura <color=SANITY>%s de cordura</color>.",
			battlesong_sanityaura = "Las <color=SANITY>auras negativas de cordura</color> son <color=SANITY>%s%%</color> menos efectivas.",
			battlesong_fireresistance = "Recibes <color=HEALTH>%s%% menos daño</color> de <color=LIGHT>fuego</color>.",
			battlesong_lunaraligned = "Recibes <color=HEALTH>%s%% menos daño</color> de <color=LUNAR_ALIGNED>enemigos lunares</color>.\nInfliges <color=HEALTH>%s%% más daño</color> a <color=SHADOW_ALIGNED>enemigos sombríos</color>.",
			battlesong_shadowaligned = "Recibes <color=HEALTH>%s%% menos daño</color> de <color=SHADOW_ALIGNED>enemigos sombríos</color>.\nInfliges <color=HEALTH>%s%% más daño</color> a <color=LUNAR_ALIGNED>enemigos lunares</color>.",

			battlesong_instant_taunt = "Provoca a todos los enemigos cercanos dentro del radio de la canción.",
			battlesong_instant_panic = "Asusta a enemigos embrujables cercanos por %s segundo(s).",
			battlesong_instant_revive = "Revive hasta %d aliados cercanos.",
		},
		cost = "Cuesta <color=INSPIRATION>%s de inspiración</color> usarla.",
		cooldown = "Cooldown del canto: %s",
	},

	-- sinkholespawner.lua
	antlion_rage = "El antlion se enojará en %s.",

	-- skinner_beefalo.lua
	skinner_beefalo = "Temible: %s, Festivo: %s, Formal: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "Despertará en %s",
	},

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>Cura</color> entre <color=HEALTH>%s</color> y <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Cura</color> a quienes estén dentro de <color=#DED15E>%s tiles</color>.",

	-- spawner.lua
	spawner = {
		next = "Aparecerá un <color=MOB_SPAWN><prefab={child_name}></color> en {respawn_time}.",
		child = "Genera un <color=MOB_SPAWN><prefab=%s></color>",
		occupied = "Ocupado: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>Cura</color> a Webber <color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>Cura</color> a las arañas <color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>Golpes</color> restantes: <color=#aaaaee>%s</color>",
		time_to_reset = "Se reiniciará en %s." 
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>) estará listo en %s segundo(s).",
		cooker = "Cocinado por <color=%s>%s</color>.",
		cooktime_modifier_slower = "Cocina la comida <color=#DED15E>%s%%</color> más lento.",
		cooktime_modifier_faster = "Cocina la comida <color=NATURE>%s%%</color> más rápido.",
	},

	-- stickable.lua
	stickable = "<color=FISH>Mejillones</color>: %s",

	-- support_pillar.lua [Prefab]
	support_pillar = {
		reinforcement = "Refuerzo: %s / %s",
		durability = "Durabilidad: %s / %s",
	},

	-- support_pillar_dreadstone.lua [Prefab]
	support_pillar_dreadstone = {
		time_until_reinforcement_regen = "Próxima regeneración: %s",
	},

	-- temperature.lua
	temperature = "Temperatura: <temperature=%s>",

	-- tentacle_pillar_hole.lua [Prefab]
	tentacle_pillar_hole = {
		immunity_time = "Tiempo de inmunidad del <prefab=tentacle>: %s",
	},

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "Recupera <color=HEALTH>%s</color> de salud por cada día sin pelear.",
		eot_health = "<prefab=eyeofterror> <color=HEALTH>Salud</color> al volver: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>Salud</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>Salud</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium> estará listo en %s.",
	},

	-- tigersharker.lua
	tigershark_spawnin = "Puede aparecer en: %s",
	tigershark_waiting = "Listo para aparecer.",
	tigershark_exists = "El tiburón tigre está presente.",

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
	tradable_gold = "Vale %s pepita(s) de oro.",
	tradable_gold_dubloons = "Vale %s pepita(s) de oro y %s doblón(es).",
	tradable_rocktribute = "Retrasa la furia del <color=LIGHT>Antlion</color> en %s.",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "Etapa %s / %s: ",
	upgradeable_complete = "Mejora completada al %s%%.",
	upgradeable_incomplete = "No es posible mejorar.",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "Aumenta la <color=HEALTH>salud máxima</color> en <color=HEALTH>%d</color>.",
			maxhealth_armor = "Post-armor combat damage reduction: <color=HEALTH>%.1f%%</color>",
			maxsanity = "Aumenta la <color=SANITY>cordura máxima</color> en <color=SANITY>%d</color>.",
			movespeed = "Aumenta la <color=DAIRY>velocidad</color> en %s.",
			heat = "Aumenta la <color=#cc0000>temperatura mínima</color> en <color=#cc0000>%d</color>.",
			heat_drying = "Aumenta la <color=#cc000>velocidad de secado</color> en <color=#cc0000>%.1f</color>.",
			cold = "Reduce la <color=#00C6FF>temperatura mínima</color> en <color=#00C6FF>%d</color>.",
			taser = "Inflige <color=WET>%d</color> %s a los atacantes (cooldown: %.1f).",
			light = "Proporciona un <color=LIGHT>radio de luz</color> de <color=LIGHT>%.1f</color> (extras solo <color=LIGHT>%.1f</color>).",
			maxhunger = "Aumenta el <color=HUNGER>hambre máximo</color> en <color=HUNGER>%d</color>.",
			music = "Proporciona un <color=SANITY>aura de cordura</color> de <color=SANITY>%+.1f/min</color> en un radio de <color=SANITY>%.1f</color> tile(s).",
			music_tend = "Atiende plantas en un radio de <color=NATURE>%.1f</color> tile(s).",
			bee = "Regenera <color=HEALTH>%d de salud/%ds</color> (<color=HEALTH>%d/día</color>).",
			bee_shield = "Max Shield: <color=HEALTH>%d</color> (<color=HEALTH>%d%%</color> of <color=HEALTH>max health</color>)",
			bee_shield_regen = "Shield charge per second: %.1f",
			radar = "Bonus Drone Range: %d",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> reaparece en: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>Impermeabilidad</color>: <color=WET>%s%%</color>",
	
	-- watersource.lua
	watersource = "Esto es una fuente de agua.",

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
		thorns = "<color=HEALTH>(Espinas)</color> <color=HEALTH>Daño</color>",
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Alcance: %s",

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
	werebeast = "Licantropía: %s / %s",

	-- wereness.lua
	wereness_remaining = "Licantropía: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "Esto tiene un componente de torno, pero falla la comprobación de prefab.",
		sunken_item = "Hay un <color=#66ee66>%s</color> bajo este torno.",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>Temperatura global</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "Estás <color=#bbffbb>apto</color> para recibir <color=#DED15E>regalos raros</color>.",
		not_ready = "<color=#ffbbbb>Espera %s día(s) más</color> para obtener otro <color=#DED15E>regalo raro</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "El cambio de estado se retrasa %s",
		wither = "Se marchitará en %s",
		rejuvenate = "Se recuperará en %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>Prob. de guardian del bosque</color>: %s%%<sub>Tú</sub> y %s%%<sub>NPC</sub>",
		treeguard_chance = "<color=#636C5C>Prob. de guardian del bosque</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "Worldmigrator desactivado.",
		target_shard = "Fragmento objetivo: %s",
		received_portal = "Portal destino: %s", -- Shard Migrator
		id = "Este portal: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "Temporizador de ajustes <color=#8c8c8c>'%s'</color>: %s",
		paused = "Pausado",
	},

	-- wortox.lua [Prefab]
	wortox = {
		time_untl_panflute_inspiration = "Wortox tendrá un uso gratis de la <prefab=panflute> en %s",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "Carga restante: %s",
		gain_charge_time = "Carga: %d / %d, siguiente <color=LIGHT>carga</color> en: <color=LIGHT>%s</color>",
		full_charge = "¡Carga completa!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "Progreso de escaneo: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "Terminará de coser en: %s",
}