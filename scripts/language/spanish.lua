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
	server_crash = "El servidor no responde.",
	
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

	-------------------------------------------------------------------------------------------------------------------------
	
	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "Proporciona luz sobre: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>) de <color=SANITY>cordura</color>",
		current_sanity = "Tu <color=SANITY>cordura</color> es: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "Invoca <color=ENLIGHTENMENT>Gestalts</color> con <color=HEALTH>%s</color> de <color=HEALTH>daño</color>",
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
	incoming_bearger_targeted = "<color=%s>Objetivo: %s</color> -> %s",

	-- boatdrag.lua
	boatdrag = {
		drag = "Arrastre: %.5f",
		max_velocity_mod = "Máx. velocidad de mod.: %.3f",
		force_dampening = "Amortiguación de fuerza: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>Pez Tropical</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
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

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fuera</sub>/%s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fuera</sub>/%s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "Regenerating {to_regen} dentro {regen_time}",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>Daño</color>: <color=HEALTH>%s</color>",
		damageToYou = " (<color=HEALTH>%s</color> a ti)",
		age_damage = "<color=HEALTH>Daño <color=AGE>(Edad)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> a ti)",
	},

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "Enfriamiento: %s",

	-- crabkingspawner.lua
	crabking_spawnsin = "%s",

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

	-- dapperness.lua
	dapperness = "<color=SANITY>Cordura</color>: <color=SANITY>%s/min</color>",

	-- debuffable.lua
	buff_text = "<color=MAGIC>Bonificación</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = "Infringe <color=HEALTH>{percent}%</color> de <color=HEALTH>daño</color> extra por {duration}(s)",
		["buff_playerabsorption"] = "Mitiga <color=MEAT>{percent}%</color> del <color=HEALTH>daño</color> por {duration}(s)",
		["buff_workeffectiveness"] = "El trabajo es <color=#DED15E>{percent}%</color> más efectivo por {duration}(s)",
		
		["buff_moistureimmunity"] = "Inmunidad a la <color=WET>humedad</color> por {duration}(s)",
		["buff_electricattack"] = "Tus ataques son <color=WET>eléctricos</color> por {duration}(s)",
		["buff_sleepresistance"] = "Resistes el <color=MONSTER>sueño</color> por {duration}(s)",
		
		["tillweedsalve_buff"] = "Regenera <color=HEALTH>{amount}</color> de <color=HEALTH>salud</color> por {duration}(s)",
		["healthregenbuff"] = "Regenera <color=HEALTH>{amount}</color> de <color=HEALTH>salud</color> por {duration}(s)",
		["sweettea_buff"] = "Regenera <color=SANITY>{amount}</color> de <color=SANITY>cordura</color> por {duration}(s)",
	},

	-- deerclopsspawner.lua
	incoming_deerclops_targeted = "<color=%s>Objetivo: %s</color> -> %s",

	-- diseaseable.lua
	disease_in = "Enferma en: %s",
	disease_spread = "Propagará la enfermedad en: %s",
	disease_delay = "Retrasa la enfermedad por: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "Domesticación: %s%%",
		obedience = "Obediencia: %s%%",
		obedience_extended = "Obediencia: %s%% (Montura: >=%s%%, Mantiene montura: >%s%%, Pierde domesticación: <=%s%%)",
		tendency = "Tendencia: %s",
		tendencies = {
			["NONE"] = "Ninguna",
			[TENDENCY.DEFAULT] = "Por defecto",
			[TENDENCY.ORNERY] = "Gruñón",
			[TENDENCY.RIDER] = "Jinete",
			[TENDENCY.PUDGY] = "Rechoncho"
		},
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
		dairy = "diario",
		decoration = "decoración",
		magic = "mágico",
		precook = "precocido",
		dried = "seco",
		inedible = "incomestible",
		bug = "insecto",
		seed = "semilla",
	},
	edible_foodeffect = {
		temperature = "Temperatura: %s, %s",
		caffeine = "Velocidad: %s, %s",
		surf = "Velocidad de la nave: %s, %s",
		autodry = "Velocidad de la nave: %s, %s",
		instant_temperature = "Temperatura: %s, (Instant)",
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

	-- example.lua
	why = "[¿por qué estoy vacío?]",

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
		tiers = (IsDST() and {
			[FARM_PLANT_STRESS.NONE] = "Ninguno",
			[FARM_PLANT_STRESS.LOW] = "Bajo",
			[FARM_PLANT_STRESS.MODERATE] = "Moderado",
			[FARM_PLANT_STRESS.HIGH] = "Alto",
		} or {}),
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
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=#bee391>%+d<sub>F</sub></color>, <color=#7a9c6e>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		--soil_plant_tile = "Nutrients: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		soil_plant_tile = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>baldosa</sub>   ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>Δplanta</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>E</sub></color>]<sub>baldosaΔ</sub>)",
		--soil_plant_tile_net = "Nutrients: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] + [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] = [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])"
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
		SPY = "Investigar", -- hamlet
		THROW = "Lanzar", -- sw -- Action string is "Throw At"
		ROW_FAIL = "Row Fail",
		ATTACK = "Ataques", -- "STRINGS.ACTIONS.ATTACK.GENERIC"
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>Peces</color>: <color=WET>%s</color>/<color=WET>%s</color>",
	fish_recharge = ": +1 pez en: %s",
	fish_wait_time = "Tardará <color=SHALLOWS>%s segundos</color> en capturar un pez.",

	-- fishingrod.lua
	fishingrod_waittimes = "Tiempo de espera: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Tiempo máx. de lucha: <color=SHALLOWS>%s</color>",

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

	-- herdmember.lua
	herd_size = "Tamaño de la manada: %s/%s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "Rango de escondite: %s a %s",
		needed_hiding_spots = "Escondites necesarios: %s",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>Hambre</color>: <color=HUNGER>%s</color>/<color=HUNGER>%s</color>",
	hunger_burn = "Drenaje de <color=HUNGER>hambre</color>: <color=HUNGER>%+d/day</color> (<color=HUNGER>%s/s</color>)",
	hunger_paused = "Drenaje de <color=HUNGER>hambre</color> en pausa.",

	-- hunter.lua
	hunter = {
		hunt_progress = "Pista: %s/%s",
		impending_ambush = "Hay una emboscada esperando en la siguiente pista.",
		alternate_beast_chance = "<color=#b51212>%s%%</color> de <color=#b51212>prob.</color> de <color=MOB_SPAWN>Huargo</color> o <color=MOB_SPAWN>Ewecus</color>",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> reaparecerá en: %s",

	-- inspectable.lua
	wagstaff_tool = "Esta herramienta se llama: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "Valor en pesas de gimnasio: %s",
	mushroom_rain = "<color=WET>Lluvia</color> necesaria: %s",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>Aislamiento (Invierno)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>Aislamiento (Verano)</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		hat_describe = "[Sombrero]: ",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "Número de Kitcoons: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "Botín notable:",

	-- klaussackspawner.lua
	klaussack_spawnsin = "%s",
	klaussack_despawn = "Desaparece en el día: %s",

	-- leader.lua
	followers = "Seguidores: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "Alcance de protección contra rayos: %s unidades",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "Se descarga en %s día(s).",

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "Se activa en: %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "Termina en: %s",

	-- malbatrossspawner.lua
	malbatross_spawnsin = "%s",
	malbatross_waiting = "Esperando que alguien vaya a un cardumen.",

	-- mast.lua
	mast_sail_force = "Fuerza de la vela: %s",
	mast_max_velocity = "Velocidad máxima: %s",

	-- mermcandidate.lua
	mermcandidate = "Calorías: %s/%s",

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
	nightmareclock = "<color=%s>Fase: %s</color>, %s",
	nightmareclock_lock = "Cerrado por la <color=#CE3D45>Llave antigua</color>.",

	-- oar.lua
	oar_force = "<color=INEDIBLE>Fuerza</color>: <color=INEDIBLE>%s%%</color>",

	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>Edad</color>: <color=714E85>%+d</color>",
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
	regrowth = "<color=NATURE>Vuelve a crecer</color> en: <color=NATURE>%s</color>",
	regrowth_paused = "El crecimiento se detuvo.",
	pickable_cycles = "<color=DECORATION>Cosechas restantes</color>: <color=DECORATION>%s</color>/<color=DECORATION>%s</color>",

	-- pollinator.lua
	pollination = "Flores polinizadas: (%s)/%s",

	-- preservative.lua
	preservative = "Restaura %s%% de frescura",

	-- quaker.lua
	next_quake = "<color=INEDIBLE>Terremoto</color> en %s",

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Juguetes restantes: %s",
			assisted_by = "Este Pipspook está siendo asistido por 2 %s.",
		},
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
		perish = "<color=MONSTER>Freshen</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>Freshen</color>: <color=MONSTER>%s%%</color>",
		materials = (IsDST() and {
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

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "No se puede generar."
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>Daño adicional</color>: <color=HEALTH>%s</color>",
		bonus_speed = "<color=DAIRY>Velocidad extra</color>: %s%%",
	},

	-- sanity.lua
	sanity = "<color=SANITY>Cordura</color>: <color=SANITY>%s</color>/<color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
	enlightenment = "<color=ENLIGHTENMENT>Iluminación</color>: <color=ENLIGHTENMENT>%s</color>/<color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",

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

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "Generado por %s.",
			sanity_reward = "Recompensa de <color=SANITY>cordura</color>: <color=SANITY>%s</color>",
			sanity_reward_split = "Recompensa de <color=SANITY>cordura</color>: <color=SANITY>%s</color>/<color=SANITY>%s</color>",
		},
	},

	-- sheltered
	sheltered = {
		range = "Alcance del refugio: %s unidades",
		shelter = "Refugio ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "Las <color=HEALTH>armas</color> duran <color=#aaaaee>%s%%</color> más",
			battlesong_healthgain = "Golpear enemigos restaura <color=HEALTH>%s</color> de <color=HEALTH>health</color> (<color=HEALTH>%s</color> para Wigfrids)",
			battlesong_sanitygain = "Golpear enemigos restaura <color=SANITY>%s</color> de <color=SANITY>sanity</color>",
			battlesong_sanityaura = "Las <color=SANITY>auras de cordura</color> son <color=SANITY>%s%%</color> menos efectivas",
			battlesong_fireresistance = "Mitiga <color=HEALTH>%s%%</color> el <color=HEALTH>daño</color> por <color=LIGHT>fuego</color>",
			battlesong_instant_taunt = "Provoca a todos los enemigos cercanos",
			battlesong_instant_panic = "Asusta a todos enemigos menores por %s segundo(s)",
		},
		cost = "Cuesta %s de inspiración",
	},

	-- sinkholespawner.lua
	antlion_rage = "%s",

	-- skinner_beefalo.lua
	skinner_beefalo = "Temible: %s, Festivo: %s, Formal: %s",

	-- soul.lua
	wortox_soul_heal = "Restaura <color=HEALTH>%s</color> - <color=HEALTH>%s</color> de <color=HEALTH>salud</color>",
	wortox_soul_heal_range = "<color=HEALTH>Cura</color> a aliados dentro de <color=#DED15E>%s balsosas</color>",

	-- spawner.lua
	spawner = {
		next = "Generará <color=MOB_SPAWN><prefab={child_name}></color> en {respawn_time}.",
		child = "Genera <color=MOB_SPAWN><prefab=%s></color>",
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

	-- temperature.lua
	temperature = "Temperatura: %s",

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "Recupera <color=HEALTH>%s</color> de <color=HEALTH>salud</color> por día sin combatir.",
		eot_health = "<color=HEALTH>Salud</color> de <prefab=eyeofterror>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
		retinazor_health = "<color=HEALTH>Salud</color> de <prefab=TWINOFTERROR1>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
		spazmatism_health = "<color=HEALTH>Salud</color> de <prefab=TWINOFTERROR2>: <<color=HEALTH>%s</color>/<color=HEALTH>%s</color>>",
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

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>Daño</color>",
		electric = "<color=WET>(Eléctrico)</color> <color=HEALTH>Daño</color>",
		poisonous = "<color=NATURE>(Venenoso)</color> <color=HEALTH>Daño</color>",
		thorns = "<color=HEALTH>(Espinoso)</color> <color=HEALTH>Daño</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Rango: %s",

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

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "Carga restante: %s",
		gain_charge_time = "Will gain a charge in: %s",
	},

	-- yotb_sewer.lua
	yotb_sewer = "Terminará de coser en: %s",
}