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

-- Traduzido por: https://steamcommunity.com/id/senhoritabuss/

-- TheNet:GetLanguageCode() == "brazilian" & LOC.GetLocaleCode() == "br"

return {
	-- insightservercrash.lua
	server_crash = "Este servidor travou.",
	
	-- modmain.lua
	dragonfly_ready = "Pronto para lutar!",

	-- time.lua
	time_segments = "%s segmento(s)",
	time_days = "%s dia(s), ",
	time_days_short = "%s dia(s)",
	time_seconds = "%s segundo(s)",
	time_minutes = "%s minuto(s), ",
	time_hours = "%s hora(s), ",

	-- meh
	seasons = {
		autumn = "<color=#CE5039>Outono</color>",
		winter = "<color=#95C2F4>Inverno</color>",
		spring = "<color=#7FC954>Primavera</color>",
		summer = "<color=#FFCF8C>Verão</color>",
	},

	-- Keybinds
	unbind = "Desvincular",
	keybinds = {
		label = "Atalhos de Teclas (Apenas Teclado)",
		togglemenu = {
			name = "Abrir Menu Insight",
			description = "Abrir/Fechar o Menu Insight"
		},
	},

	-- Danger Announcements
	danger_announcement = {
		generic = "[Anúncio de Perigo]: ",
		boss = "[Anúncio de Boss]: ",
	},

	-- Presets
	presets = {
		types = {
			new_player = {
				label = "Novo Jogador",
				description = "Recomendado para jogadores novos no jogo."
			},
			simple = {
				label = "Simples",
				description = "Uma quantidade baixa de informações, semelhante ao Show Me",
			},
			decent = {
				label = "Equilibrado",
				description = "Uma quantidade média de informações. Muito semelhante às configurações padrão.",
			},
			advanced = {
				label = "Avançado",
				description = "Bom para quem gosta de informação.",
			},
		},
	},
	
	-- Insight Menu
	insightmenu = {
		tabs = {
			world = "Mundo",
			player = "Jogador",
		},
	},

	indicators = {
		dismiss = "%s Dispensar",
	},

	-- Damage helper
	damage_types = {
		-- Normal
		explosive = "Explosive",
		
		-- Planar
		lunar_aligned = "Lunar Aligned",
		shadow_aligned = "Shadow Aligned",
	},
	-------------------------------------------------------------------------------------------------------------------------
	
	-- alterguardianhat.lua [Prefab]
	alterguardianhat = {
		minimum_sanity = "Mínimo de <color=SANITY>sanidade</color> para a luz: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_sanity = "Sua <color=SANITY>sanidade</color> é: <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		summoned_gestalt_damage = "Os <color=ENLIGHTENMENT>Espíritos da Lua</color> invocados causam <color=HEALTH>%s</color> de dano.",
	},

	-- appeasement.lua
	appease_good = "Atrasa a erupção por %s segmento(s).",
	appease_bad = "Acelera a erupção em %s segmento(s).",

	-- appraisable.lua
	appraisable = "Temível: %s, Festivo: %s, Formal: %s",

	-- archive_lockbox.lua [Prefab]
	archive_lockbox_unlocks = "Desbloqueia: <prefab=%s>",

	-- armor.lua
	protection = "<color=HEALTH>Proteção</color>: <color=HEALTH>%s%%</color>",
	durability = "<color=#C0C0C0>Durabilidade</color>: <color=#C0C0C0>%s</color> / <color=#C0C0C0>%s</color>",
	durability_unwrappable = "<color=#C0C0C0>Durabilidade</color>: <color=#C0C0C0>%s</color>",

	-- armordreadstone.lua
	armordreadstone = {
		regen = "Regenerates <color=%s>%.1f</color> <color=#C0C0C0>durability</color>/%ds",
		regen_complete = "Regenerates <color=%s>%.1f<sub>min</sub></color> / <color=%s>%.1f<sub>current</sub></color> / <color=%s>%.1f<sub>max</sub></color> <color=#C0C0C0>durability</color>/%ds based on insanity"
	},

	-- atrium_gate.lua [Prefab]
	atrium_gate = {
		cooldown = "<prefab=atrium_gate> irá reiniciar em %s",
	},

	-- attunable.lua
	attunable = {
		linked = "Conectado a: %s",
		offline_linked = "Desconectado de: %s",
		player = "<color=%s>%s</color> (<prefab=%s>)",	
	},

	-- batbat.lua [Prefab]
	batbat = {
		health_restore = "Restaura <color=HEALTH>%s de vida</color> por ataque.",
		sanity_cost = "Drena <color=SANITY>%s de sanidade</color> por ataque.",
	},

	batnosehat = {
		hunger_gain = "Restores %s hunger every %s second(s)",

	},

	-- beard.lua
	beard = "Texurso irá surgir em %s dia(s).",

	-- beargerspawner.lua
	beargerspawner = {
		incoming_bearger_targeted = "<color=%s>Alvo: %s</color> -> %s",
		announce_bearger_target = "<prefab=bearger> irá surgir em %s (<prefab=%s>) em %s.",
		bearger_attack = "<prefab=bearger> irá atacar em %s."
	},

	-- beequeenhive.lua [Prefab]
	beequeenhive = {
		time_to_respawn = "<prefab=beequeen> irá reiniciar em %s.",
	},

	-- boatdrag.lua
	boatdrag = {
		drag = "Arrastar: %.5f",
		max_velocity_mod = "Modificação de velocidade máxima: %.3f",
		force_dampening = "Força de amortecimento: %.3f",
	},

	-- boathealth.lua
	-- use 'health' from 'health'

	-- book.lua
	book = {
		wickerbottom = {
			tentacles = "Invoca <color=%s>%d tentáculos</color>",
			birds = "Evoca até <color=%s>%d pássaros</color>",
			brimstone = "Convoca <color=%s>%d relâmpagos</color>",
			horticulture = "Cresce até <color=%s>%d plantas</color>",
			horticulture_upgraded = "Cresce e cuida de <color=%s>%d plantas</color>",
			--silviculture = "Grows basic resource plants.",
			--fish = "",
			--fire = ""
			web = "Invoca uma <color=%s>teia de aranha</color> que dura por <color=%s>%s</color>",
			--temperature = ""
			light = "Invoca uma <color=LIGHT>luz</color> por <color=LIGHT>%s</color>",
			-- light_upgraded is just light
			rain = "Alterna <color=WET>chuva</color> e <color=WET>rega as plantas próximas</color>",
			bees = "Convoca <color=%s>%d abelhas</color> até <color=%s>%d</color>",
			research_station = "Taxas de protótipos: %s",
			_research_station_charge = "<color=#aaaaee>%s</color> (%d)",
			meteor = "Convoca <color=%s>%d meteoros</color>",
		},
	},

	-- breeder.lua
	breeder_tropical_fish = "<color=#64B08C>Peixe Tropical</color>",
	--breeder_fish2 = "Tropical Wanda", --in code but unused
	breeder_fish3 = "<color=#6C5186>Garoupa Roxa</color>",
	breeder_fish4 = "<color=#DED15E>Peixe Pierrot</color>",
	breeder_fish5 = "<color=#9ADFDE>Neon Quattro</color>",
	breeder_fishstring = "%s: %s / %s",
	breeder_nextfishtime = "Peixes adicionais em: %s",
	breeder_possiblepredatortime = "Pode gerar um predador em: %s",

	-- brushable.lua
	brushable = {
		last_brushed = "Escovado %s dia(s) atrás."
	},

	-- burnable.lua
	burnable = {
		smolder_time = "Irá <color=LIGHT>acender</color> em: <color=LIGHT>%s</color>",
		burn_time = "Tempo restante <color=LIGHT>queimando</color>: <color=LIGHT>%s</color>",
	},

	-- carnivaldecor.lua
	carnivaldecor = {
		value = "Valor de decoração: %s",
	},

	-- carnivaldecor_figure.lua [Prefab]

	-- carnivaldecor_figure_kit.lua [Prefab]
	carnivaldecor_figure_kit = {
		rarity_types = {
			rare = "Raro",
			uncommon = "Incomum",
			common = "Comum",
			unknown = "Desconhecido",
		},
		shape = "Forma: %s",
		rarity = "Raridade: %s",
		season = "Temporada: %d",
		undecided = "Deve ser colocado antes que o conteúdo seja determinado."
	},

	-- carnivaldecorranker.lua
	carnivaldecorranker = {
		rank = "<color=%s>Rank</color>: <color=%s>%s</color> / <color=%s>%s</color>",
		decor = "Decoração total: %s",
	},

	-- canary.lua [Prefab]
	canary = {
		gas_level = "<color=#DBC033>Nível de gás</color>: %s / %s", -- canary, max saturation canary
		poison_chance = "Chance de vir <color=#522E61>envenenado</color>: <color=#D8B400>%d%%</color>",
		gas_level_increase = "Aumenta em %s.",
		gas_level_decrease = "Diminui em %s."
	},

	-- catcoonden.lua [Prefab]
	catcoonden = {
		lives = "Gatos vivos: %s / %s",
		regenerate = "Gatos irão regenerar em: %s",
		waiting_for_sleep = "Esperando os jogadores próximos irem embora.",
	},

	-- chessnavy.lua
	chessnavy_timer = "%s",
	chessnavy_ready = "Esperando que você retorne à cena do crime.",

	-- chester_eyebone.lua [Prefab]
	chester_respawn = "<color=MOB_SPAWN><prefab=chester></color> irá ressurgir em: %s",
	announce_chester_respawn = "Meu <prefab=chester> vai reaparecer em %s.",

	-- childspawner.lua
	childspawner = {
		children = "<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fora</sub> / %s",
		emergency_children = "*<color=MOB_SPAWN><prefab=%s></color>: %s<sub>dentro</sub> + %s<sub>fora</sub> / %s",
		both_regen = "<color=MOB_SPAWN><prefab=%s></color> & <color=MOB_SPAWN><prefab=%s></color>",
		regenerating = "Regenerando {to_regen} em {regen_time}",
		entity = "<color=MOB_SPAWN><prefab=%s></color>",
	},

	-- combat.lua
	combat = {
		damage = "<color=HEALTH>Dano</color>: <color=HEALTH>%s</color>",
		damageToYou = " (<color=HEALTH>%s</color> em você)",
		age_damage = "<color=HEALTH>Dano <color=AGE>(Idade)</color></color>: <color=AGE>%+d</color>",
		age_damageToYou = " (<color=AGE>%+d</color> em você)",
		yotr_pillows = {
			--@@ Weapons
			knockback = "<color=VEGGIE>Knockback</color>: <color=VEGGIE>%s</color> (<color=VEGGIE>x%.1f%%</color>)",
			--knockback_multiplier = "Knockback Multiplier: %s",
			laglength = "<color=VEGGIE>Cooldown</color>: %s",
			
			--@@ Armor
			defense_amount = "<color=VEGGIE>Defensa</color>: %s",
			
			--@@ Both
			prize_value = "Valor do prêmio: %s",
		},
	},

	-- container.lua
	container = {
		
	},

	-- cooldown.lua
	cooldown = "Tempo restante: %s",

	-- crabkingspawner.lua
	crabkingspawner = {
		crabking_spawnsin = "%s",
		time_to_respawn = "<prefab=crabking> vai reaparecer em %s.",
	},

	-- crittertraits.lua
	dominant_trait = "Traço dominante: %s",

	-- crop.lua
	crop_paused = "Pausado.",
	growth = "<color=NATURE><prefab=%s></color>: <color=NATURE>%s</color>",

	-- cyclable.lua
	cyclable = {
		step = "Fase: %s / %s",
		note = ", nota: %s",
	},

	-- damagetypebonus.lua
	damagetypebonus = {
		modifier = "<color=%s>%+.1f%%</color> damage to %s entities",
	},

	-- damagetyperesist.lua
	damagetyperesist = {
		modifier = "<color=%s>%+.1f%%</color> damage from %s attacks",
	},

	-- dapperness.lua
	dapperness = "<color=SANITY>Sanidade</color>: <color=SANITY>%s/min</color>",

	-- daywalkerspawner.lua
	daywalkerspawner = {
		days_to_respawn = "<prefab=DAYWALKER> will respawn in %s day(s)",
	},

	-- debuffable.lua
	buff_text = "<color=MAGIC>Buff</color>: %s, %s",
	debuffs = { -- ugh
		["buff_attack"] = {
			name = nil,
			description = "Faz o ataque <color=HEALTH>{percent}% mais forte</color> por {duration}(s).",
		},
		["buff_playerabsorption"] = {
			name = nil,
			description = "Recebe <color=MEAT>{percent}%</color> menos dano por {duration}(s).",
		},
		["buff_workeffectiveness"] = {
			name = nil,
			description = "Seu trabalho é <color=#DED15E>{percent}%</color> mais efetivo por {duration}(s).",
		},
		
		["buff_moistureimmunity"] = {
			name = nil,
			description = "Você está imune à <color=WET>umidade</color> por {duration}(s).",
		},
		["buff_electricattack"] = {
			name = nil,
			description = "Seus ataques estão <color=WET>eletrizados</color> por {duration}(s).",
		},
		["buff_sleepresistance"] = {
			name = nil,
			description = "Você está resistente à <color=MONSTER>sonolência</color> por {duration}(s).",
		},
		
		["tillweedsalve_buff"] = {
			name = nil,
			description = "Regenera <color=HEALTH>{amount} vida</color> durante {duration}(s).",
		},
		["healthregenbuff"] = {
			name = nil,
			description = "Regenera<color=HEALTH>{amount} vida</color> durante {duration}(s).",
		},
		["sweettea_buff"] = {
			name = nil,
			description = "Regenera <color=SANITY>{amount} sanidade</color> durante {duration}(s).",
		},

		["wintersfeastbuff"] = {
			name = "<color=FROZEN>Buff do Festival de Inverno</color>",
			description = nil
		},
		["hungerregenbuff"] = {
			name = "<color=HUNGER><prefab=batnosehat> Buff</color>",
			description = "Regenerates <color=HUNGER>{amount} hunger</color> over {duration}(s).",
		},
		
		["halloweenpotion_health_buff"] = {
			name = "<color=HEALTH>Regeneração de vida</color>",
			description = nil
		},
		["halloweenpotion_sanity_buff"] = {
			name = "<color=SANITY>Regeneração de sanidade</color>",
			description = nil
		},
		["halloweenpotion_bravery_small_buff"] = {
			name = "<color=SANITY>Bravura</color> contra morcegos.",
			description = nil
		},
		["halloweenpotion_bravery_large_buff"] = (function(parent)
			return deepcopy(parent.halloweenpotion_bravery_small_buff)
		end)
	},

	-- deerclopsspawner.lua
	deerclopsspawner = {
		incoming_deerclops_targeted = "<color=%s>Alvo: %s</color> -> %s",
		announce_deerclops_target = "<prefab=deerclops> irá surgir em %s (<prefab=%s>) em %s.",
		deerclops_attack = "<prefab=deerclops> irá atacar em %s.",
	},

	-- diseaseable.lua
	disease_in = "Ficará doente em: %s",
	disease_spread = "Vai espalhar a doença em: %s",
	disease_delay = "A doença está atrasada em: %s",

	-- domesticatable.lua
	domesticatable = {
		domestication = "Domesticação: %s%%",
		obedience = "Obediência: %s%%",
		obedience_extended = "Obedience: %s%% (<%s%%<sub>bucks saddle</sub>, %s%%<sub>minimum</sub>)",
		tendency = "Tendência: %s",
		tendencies = {
			["NONE"] = "Nenhuma",
			[TENDENCY.DEFAULT] = "Padrão",
			[TENDENCY.ORNERY] = "Mal-humorada",
			[TENDENCY.RIDER] = "Cavaleiro",
			[TENDENCY.PUDGY] = "Rechonchuda"
		},
	},

	-- dragonfly_spawner.lua [Prefab]
	dragonfly_spawner = {
		time_to_respawn = "<prefab=dragonfly> irá ressurgir em %s.",
	},

	-- drivable.lua

	-- dryer.lua
	dryer_paused = "Secagem pausada.",
	dry_time = "Tempo restante: %s",

	-- eater.lua
	eater = {
		eot_loot = "Comida restaura <color=HUNGER>fome %s%%</color> + <color=HEALTH>vida %s%%</color> como durabilidade.",
		eot_tofeed_restore = "Comida guardada <color=MEAT><prefab=%s></color> irá restaurar <color=#C0C0C0>%s</color> (<color=#C0C0C0>%s%%</color>) de durabilidade.",
		eot_tofeed_restore_advanced = "Comida guardada <color=MEAT><prefab=%s></color> irá restaurar <color=#C0C0C0>%s</color> (<color=HUNGER>%s</color> + <color=HEALTH>%s</color>) (<color=#C0C0C0>%s%%</color>) de durabilidade.",
		tofeed_restore = "Comida guardada <color=MEAT><prefab=%s></color> irá restaurar %s.",
	},

	-- edible.lua
	food_unit = "<color=%s>%s</color> unidade(s) de <color=%s>%s</color>", 
	edible_interface = "<color=HUNGER>Fome</color>: <color=HUNGER>%s</color> / <color=SANITY>Sanidade</color>: <color=SANITY>%s</color> / <color=HEALTH>Vida</color>: <color=HEALTH>%s</color>",
	edible_wiki = "<color=HEALTH>Vida</color>: <color=HEALTH>%s</color> / <color=HUNGER>Fome</color>: <color=HUNGER>%s</color> / <color=SANITY>Sanidade</color>: <color=SANITY>%s</color>",
	edible_foodtype = {
		meat = "carne",
		monster = "monstro",
		fish = "peixe",
		veggie = "vegetal",
		fruit = "fruta",
		egg = "ovo",
		sweetener = "adoçante",
		frozen = "congelada",
		fat = "gordura",
		dairy = "latcíneo",
		decoration = "decoração",
		magic = "mágica",
		precook = "pré-cozida",
		dried = "seca",
		inedible = "não comestível",
		bug = "inseto",
		seed = "semente",
		antihistamine = "antihistamine", -- Only "cutnettle"
	},
	edible_foodeffect = {
		temperature = "Temperatura: %s, %s",
		caffeine = "Velocidade: %s, %s",
		surf = "Velocidade de Navegação: %s, %s",
		autodry = "Bônus de Secagem: %s, %s",
		instant_temperature = "Temperatura: %s, (Instante)",
		antihistamine = "Atraso da Febre do Feno: %ss",
	},
	foodmemory = "Recentemente comido: %s / %s, irá esquecer em: %s",
	wereeater = "<color=MONSTER>Carne de monstro</color> comida: %s / %s, irá esquecer em: %s",

	-- equippable.lua
	-- use 'dapperness' from 'dapperness'
	speed = "<color=DAIRY>Velocidade</color>: %s%%",
	hunger_slow = "<color=HUNGER>Fome lentamente</color>: <color=HUNGER>%s%%</color>",
	hunger_drain = "<color=HUNGER>Drenagem de fome</color>: <color=HUNGER>%s%%</color>",
	insulated = "Protege você contra raios.",

	-- example.lua
	why = "[Por que estou vazio?]",

	-- explosive.lua
	explosive_damage = "<color=LIGHT>Dano de Explosão</color>: %s",
	explosive_range = "<color=LIGHT>Raio de Explosão</color>: %s",

	-- farmplantable.lua
	farmplantable = {
		product = "Se tornará uma <color=NATURE><prefab=%s></color>.",
		nutrient_consumption = "ΔNutrientes: [<color=NATURE>%d<sub>Fórmula</sub></color>, <color=CAMO>%d<sub>Composto</sub></color>, <color=INEDIBLE>%d<sub>Esterco</sub></color>]",
		good_seasons = "Estações: %s",
	},

	-- farmplantstress.lua
	farmplantstress = {
		stress_points = "Pontos de Estresse: %s",
		display = "Estressores: %s",
		stress_tier = "Nível de Estresse: %s",
		tiers = (IS_DST and {
			[FARM_PLANT_STRESS.NONE] = "Nenhum",
			[FARM_PLANT_STRESS.LOW] = "Baixo",
			[FARM_PLANT_STRESS.MODERATE] = "Moderado",
			[FARM_PLANT_STRESS.HIGH] = "Alto",
		} or {}),
		categories = {
			["nutrients"] = "Nutrients", -- missing nutrients
			["moisture"] = "Moisture", -- needs water
			["killjoys"] = "Weeds", -- weeds nearby
			["family"] = "Family", -- no similar plants nearby
			["overcrowding"] = "Overcrowding", -- too crowded
			["season"] = "Season", -- out of season
			["happiness"] = "Happiness", -- not tended to
		},
	},

	-- farmsoildrinker.lua
	farmsoildrinker = {
		soil_only = "<color=WET>Água</color>: <color=WET>%s<sub>tile</sub></color>*",
		soil_plant = "<color=WET>Água</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s/min<sub>plant</sub></color>)*",
		soil_plant_tile = "<color=WET>Água</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color>])<color=WET>/min</color>*",
		soil_plant_tile_net = "<color=WET>Água</color>: <color=WET>%s<sub>tile</sub></color> (<color=WET>%s<sub>plant</sub></color> [<color=#2f96c4>%s<sub>tile</sub></color> + <color=SHALLOWS>%s<sub>world</sub></color> = <color=#DED15E>%+.1f<sub>net</sub></color>])<color=WET>/min</color>"
	},

	farmsoildrinker_nutrients = {
		soil_only = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>*",
		soil_plant = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplant</sub>)*",
		--soil_plant_tile = "Nutrientes: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=#bee391>%+d<sub>F</sub></color>, <color=#7a9c6e>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		--soil_plant_tile = "Nutrientes: [%+d<color=NATURE><sub>F</sub></color>, %+d<color=CAMO><sub>C</sub></color>, %+d<color=INEDIBLE><sub>M</sub></color>]<sup>tile</sup> ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>plantΔ</sup>   [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sup>tileΔ</sup>)",
		soil_plant_tile = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tile</sub>   ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>Δplant</sub> [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>]<sub>tileΔ</sub>)",
		--soil_plant_tile_net = "Nutrientes: [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] ([<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] + [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>] = [<color=NATURE>%+d<sub>F</sub></color>, <color=CAMO>%+d<sub>C</sub></color>, <color=INEDIBLE>%+d<sub>M</sub></color>])"
	},

	-- fertilizer.lua
	fertilizer = {
		growth_value = "Reduz o <color=NATURE>tempo de crescimento</color> em <color=NATURE>%s</color> segundos.",
		nutrient_value = "Nutrientes: [<color=NATURE>%s<sub>Fórmula</sub></color>, <color=CAMO>%s<sub>Composto</sub></color>, <color=INEDIBLE>%s<sub>Esterco</sub></color>]",
		wormwood = {
			formula_growth = "Acelera sua <color=LIGHT_PINK>florescência</color> em <color=LIGHT_PINK>%s</color>.",
			compost_heal = "<color=HEALTH>Cura</color> você <color=HEALTH>{healing}</color> durante <color=HEALTH>{duration}</color> segundo(s).",
		},
	},

	-- fillable.lua
	fillable = {
		accepts_ocean_water = "Pode ser preenchido com água do oceano.",
	},

	-- finiteuses.lua
	action_uses = "<color=#aaaaee>%s</color>: %s",
	action_uses_verbose = "<color=#aaaaee>%s</color>: %s / %s",
	actions = {
		USES_PLAIN = "Usos",
		TERRAFORM = "Terraformar",
		GAS = "Gás", -- hamlet
		DISARM = "Desarmar", -- hamlet
		PAN = "Pan", -- hamlet
		DISLODGE = "Cinzel", -- hamlet
		SPY = "Investigar", -- hamlet
		THROW = "Lançar", -- sw -- Action string is "Throw At"
		ROW_FAIL = "Falha na Linha",
		--ATTACK = "<string=ACTIONS.ATTACK.GENERIC>",
		--POUR_WATER = "<string=ACTIONS.POUR_WATER.GENERIC>",
		--BLINK = "<string=ACTIONS.BLINK.GENERIC>",
	},

	-- fishable.lua
	fish_count = "<color=SHALLOWS>Peixe</color>: <color=WET>%s</color> / <color=WET>%s</color>",
	fish_recharge = ": +1 peixe em: %s",
	fish_wait_time = "Vai levar <color=SHALLOWS>%s segundos</color> para pegar um peixe.",

	-- fishingrod.lua
	fishingrod_waittimes = "Tempo de espera: <color=SHALLOWS>%s</color> - <color=SHALLOWS>%s</color>",
	fishingrod_loserodtime = "Tempo máximo de disputa: <color=SHALLOWS>%s</color>",

	-- follower.lua
	leader = "Líder: %s",
	loyalty_duration = "Duração de lealdade: %s",

	-- forcecompostable.lua
	forcecompostable = "Valor do composto: %s",

	-- fossil_stalker.lua [Prefab]
	fossil_stalker = {
		pieces_needed = "20%% chance de dar errado com %s mais peça(s).",
		correct = "Isto está montado corretamente.",
		incorrect = "Isto está montado errado.",
		gateway_too_far = "Este esqueleto está %s ladrilho(s) longe demais.",
	},

	-- friendlevels.lua
	friendlevel = "Nível de amizade: %s / %s",

	-- fuel.lua
	fuel = {
		fuel = "<color=LIGHT>%s</color> segundo(s) de combustível.",
		fuel_verbose = "<color=LIGHT>%s</color> segundo(s) de <color=LIGHT>%s</color>.",
		type = "Tipo de combustível: %s",
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
		time = "<color=LIGHT>Combustível</color> restando (<color=LIGHT>%s%%</color>): %s", -- percent, time
		time_verbose = "<color=LIGHT>%s</color> restando (<color=LIGHT>%s%%</color>): %s", -- type, percent, time
		efficiency = "<color=LIGHT>Eficiência de Combustível</color>: <color=LIGHT>%s%%</color>",
		units = "<color=LIGHT>Combustível</color>: <color=LIGHT>%s</color>",
		held_refuel = "Guardado <color=SWEETENER><prefab=%s></color> irá reabastecer <color=LIGHT>%s%%</color>.",
	},

	-- ghostlybond.lua
	ghostlybond = {
		abigail = "<color=%s>Vínculo de irmã</color>: %s / %s.",
		flower = "Seu <color=%s>vínculo fraternal</color>: %s / %s. ",
		levelup = " +1 em %s.",
	},

	-- ghostlyelixir.lua
	ghostlyelixir = {
		ghostlyelixir_slowregen = "Regenera <color=HEALTH>%s vida</color> durante %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_fastregen = "Regenera <color=HEALTH>%s vida</color> durante %s (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>).",
		ghostlyelixir_attack = "Maxímiza o <color=HEALTH>dani</color> por %s.",
		ghostlyelixir_speed = "Aumenta a <color=DAIRY>velocidade</color> de <color=DAIRY>%s%%</color> por %s.",
		ghostlyelixir_shield = "Aumenta a duração do escudo de 1 segundo para %s.",
		ghostlyelixir_retaliation = "Escudo reflete o <color=HEALTH>%s dano</color> por %s.", -- concatenated with shield
	},

	-- ghostlyelixirable.lua
	ghostlyelixirable = {
		remaining_buff_time = "<color=#737CD0><prefab=%s></color> duração: %s.",
	},

	-- growable.lua
	growable = {
		stage = "Estágio <color=#8c8c8c>'%s'</color>: %s / %s: ",
		paused = "O crescimento pausou.",
		next_stage = "Próximo estágio em %s.",
	},

	-- grower.lua
	harvests = "<color=NATURE>Colheitas</color>: <color=NATURE>%s</color> / <color=NATURE>%s</color>",

	-- hackable.lua
	-- use 'regrowth' from 'pickable'
	-- use 'regrowth_paused' from 'pickable'

	-- harvestable.lua
	harvestable = {
		product = "%s: %s / %s",
		grow = "+1 em %s.",
	},

	-- hatchable.lua
	hatchable = {
		discomfort = "Desconforto: %s / %s",
		progress = "Progresso da incubação: %s / %s",
	},

	-- healer.lua
	healer = {
		heal = "<color=HEALTH>Vida</color>: <color=HEALTH>%+d</color>",
		webber_heal = "Webber <color=HEALTH>Vida</color>: <color=HEALTH>%+d</color>",
		spider_heal = "Aranha <color=HEALTH>Vida</color>: <color=HEALTH>%+d</color>",
	},

	-- health.lua
	health = "<color=HEALTH>Vida</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
	health_regeneration = " (<color=HEALTH>+%s</color> / <color=HEALTH>%ss</color>)",
	absorption = " : Absorvendo %s%% do dano.",
	naughtiness = "Travessura: %s",
	player_naughtiness = "Sua travessura: %s / %s",
	
	-- heatrock.lua
	heatrock_temperature = "Temperatura: %s < %s < %s",

	-- herdmember.lua
	herd_size = "Tamanho do rebanho: %s / %s",

	-- hideandseekgame.lua
	hideandseekgame = {
		hiding_range = "Intervalo de ocultação: %s to %s",
		needed_hiding_spots = "Esconderijos necessários: %s",
	},

	-- hounded.lua
	hounded = {
		time_until_hounds = "Hounds will attack in %s.",
	},

	-- hunger.lua
	hunger = "<color=HUNGER>Fome</color>: <color=HUNGER>%s</color> / <color=HUNGER>%s</color>",
	hunger_burn = "Decaimento de <color=HUNGER>Fome</color>: <color=HUNGER>%+d/day</color> (<color=HUNGER>%s/s</color>)",
	hunger_paused = "Decaimento de <color=HUNGER>Fome</color> pausado.",

	-- hunter.lua
	hunter = {
		hunt_progress = "Rastro: %s / %s",
		impending_ambush = "Há uma emboscada esperando no próximo rastro.",
		alternate_beast_chance = "<color=#b51212>%s%% chance</color> de um <color=MOB_SPAWN>Varg</color> ou uma <color=MOB_SPAWN>Mucovelha</color>.",
	},

	-- hutch_fishbowl.lua [Prefab]
	hutch_respawn = "<color=MOB_SPAWN><prefab=hutch></color> irá reaparecer em: %s",
	announce_hutch_respawn = "My <prefab=hutch> will respawn in %s.",

	-- inspectable.lua
	wagstaff_tool = "O nome desta ferramente é: <color=ENLIGHTENMENT><prefab=%s></color>",
	gym_weight_value = "Valor de peso da academia: %s",
	ruins_statue_gem = "Contains a <color=%s><prefab=%s></color>.",

	-- insulator.lua
	insulation_winter = "<color=FROZEN>Proteção (Inverno)</color>: <color=FROZEN>%s</color>",
	insulation_summer = "<color=FROZEN>Proteção (Verão)</color>: <color=FROZEN>%s</color>",

	-- inventory.lua
	inventory = {
		hat_describe = "[Chapéu]: ",
	},

	-- kitcoonden.lua
	kitcoonden = {
		number_of_kitcoons = "Número de gatinhos: %s"
	},

	-- klaussackloot.lua
	klaussackloot = "<color=#8c8c8c>Loot notável</color>:",

	-- klaussackspawner.lua
	klaussackspawner = {
		klaussack_spawnsin = "%s",
		klaussack_despawn = "Desaparece no dia: %s",
	},

	-- leader.lua
	followers = "Seguidores: %s",

	-- lightningblocker.lua
	lightningblocker = {
		range = "Raio de proteção contra raios: %s unidades de parede",
	},

	-- lightninggoat.lua
	lightninggoat_charge = "Irá descarregar em %s dia(s).",

	-- lunarrift_portal.lua [Prefab]
	lunarrift_portal = {
		crystals = "<color=#4093B2><prefab=lunarrift_crystal_big></color>: %d<sub>available</sub> / %d<sub>total</sub> / %d<sub>max</sub>", -- I can't think of a way to word 
		next_crystal = "Next <color=#4093B2><prefab=lunarrift_crystal_big></color> spawns in %s",
		close = "<prefab=LUNARRIFT_PORTAL> will close in approximately %s",
	},
	
	-- lunarthrall_plantspawner.lua
	lunarthrall_plantspawner = {
		infested_count = "%d",
		spawn = "Gestalts spawn in %s",
		next_wave = "Next wave in %s",
		remain_waves = "%d waves remaining",
	},

	-- lureplant.lua [Prefab]
	lureplant = {
		become_active = "Se tornará ativo em: %s",
	},

	-- madsciencelab.lua
	madsciencelab_finish = "Terminará em: %s",

	-- malbatrossspawner.lua
	malbatrossspawner = {
		malbatross_spawnsin = "%s",
		malbatross_waiting = "Esperando que alguém vá para um cardume.",
		time_to_respawn = "<prefab=malbatross> will respawn in %s.",
	},

	-- mast.lua
	mast_sail_force = "Força da vela: %s",
	mast_max_velocity = "Velocidade máxima: %s",

	-- mermcandidate.lua
	mermcandidate = "Calorias: %s / %s",

	-- mightiness.lua
	mightiness = "<color=MIGHTINESS>Potência</color>: <color=MIGHTINESS>%s</color> / <color=MIGHTINESS>%s</color> - <color=MIGHTINESS>%s</color>",

	-- mightydumbbell.lua
	mightydumbbell = {
		mightness_per_use = "<color=MIGHTINESS>Potência</color> por uso: ",
	},

	-- mightygym.lua
	mightygym = {
		weight = "Peso da academia: %s",
		mighty_gains = "<color=MIGHTINESS>Elevação</color> normal: <color=MIGHTINESS>%+.1f</color>, <color=MIGHTINESS>Elevação</color> perfeita: <color=MIGHTINESS>%+.1f</color>",
		hunger_drain = "<color=HUNGER>Dreno de fome</color>: <color=HUNGER>x%d</color>",
	},

	-- mine.lua
	mine = {
		active = "Verifica por gatilhos a cada %s segundo(s).",
		inactive = "Não verificando gatilhos.",
		beemine_bees = "Vai liberar %s abelha(s).",
		trap_starfish_cooldown = "Rearmar em: %s",
	},

	-- moisture.lua
	moisture = "<color=WET>Umidade</color>: <color=WET>%s%%</color>", --moisture = "<color=WET>Wetness</color>: %s / %s (%s%%)",

	-- monkey_smallhat.lua [Prefab]
	monkey_smallhat = "Mast & Anchor interaction speed: {feature_speed}\nOar durability use: {durability_efficiency}",

	-- monkey_mediumhat.lua [Prefab]
	monkey_mediumhat = "Boat damage reduction: {reduction}",

	-- mood.lua
	mood = {
		exit = "Vai sair do humor em %s dia(s).",
		enter = "Vai entrar no humor em %s dia(s).",
	},

	-- moonstormmanager.lua
	moonstormmanager = {
		wagstaff_hunt = {
			progress = "Progresso para o destino: %s / %s",
			time_for_next_tool = "Vai precisar de outra ferramenta em %s.",
			experiment_time = "A experiência estará completa em %s.",
		},
		storm_move = "%s%% chance de mover tempestades lunares no dia %s.",
	},

	-- nightmareclock.lua
	nightmareclock = {
		phase_info = "<color=%s>Fase: %s</color>, %s",
		phase_locked = "Bloqueada pela <color=#CE3D45>Chave Anciã</color>.",
		announce_phase_locked = "The ruins are currently locked in the nightmare phase.",
		announce_phase = "The ruins are in the %s phase (%s remaining).",
		phases = {
			["calm"] = "Calm",
			["warn"] = "Warning",
			["wild"] = "Nightmare",
			["dawn"] = "Dawn"
		},
	},

	-- oar.lua
	oar_force = "<color=INEDIBLE>Força</color>: <color=INEDIBLE>%s%%</color>",

	-- oceanfishingrod.lua
	oceanfishingrod = {
		hook = {
			interest = "Interest: %.2f",
			num_interested = "Interested fish: %s",
		},
		battle = {
			tension = "Tension: <color=%s>%.1f</color> / %.1f<sub>line snaps</sub>",
			slack = "Slack: <color=%s>%.1f</color> / %.1f<sub>fish escapes</sub>",
			distance = "Distance: %.1f<sub>catch</sub> / <color=%s>%.1f<sub>current</sub></color> / %.1f<sub>flee</sub>",
		},
	},

	-- oceanfishingtackle.lua
	oceanfishingtackle = {
		casting = {
			bonus_distance = "Bonus distance: %s",
			bonus_accuracy = "Bonus accuracy: <color=#66CC00>%+.1f%%<sub>min</sub></color> / <color=#5B63D2>%+.1f%%<sub>max</sub></color>",
		},
		lure = {
			charm = "Charm: <color=#66CC00>%.1f<sub>base</sub></color> + <color=#5B63D2>%.1f<sub>reel</sub></color>",
			stamina_drain = "Bonus stamina drain: %.1f",
			time_of_day_modifier = "Phase effectiveness: <color=DAY_BRIGHT>%d%%<sub>day</sub></color> / <color=DUSK_BRIGHT>%d%%<sub>dusk</sub></color> / <color=NIGHT_BRIGHT>%d%%<sub>night</sub></color>",
			weather_modifier = "Weather effectiveness: <color=#bbbbbb>%d%%<sub>clear</sub></color> / <color=#7BA3F2>%d%%<sub>raining</sub></color> / <color=FROZEN>%d%%<sub>snowing</sub></color>",
		},
	},

	-- oceantree.lua [Prefab]
	oceantree_supertall_growth_progress = "Supertall growth progress: %s / %s",
	
	-- oldager.lua
	oldager = {
		age_change = "<color=AGE>Idade</color>: <color=714E85>%+d</color>",
	},

	-- pangolden.lua [Prefab]
	pangolden = {
		gold_level_progress = "<color=#E3D740>Gold</color> level: %.1f / %.1f",
		gold_level = "<color=#E3D740>Gold</color> level: %.1f",
	},

	-- periodicthreat.lua
	worms_incoming = "%s",
	worms_incoming_danger = "<color=HEALTH>%s</color>",

	-- perishable.lua
	perishable = {
		rot = "Apodrecido",
		stale = "Vencido",
		spoil = "Estragado",
		dies = "Morto",
		starves = "Com fome",
		transition = "<color=MONSTER>{next_stage}</color> em {time}",
		transition_extended = "<color=MONSTER>{next_stage}</color> em {time} (<color=MONSTER>{percent}%</color>)",
		paused = "Atualmente não está apodrecendo.",
	},

	-- petrifiable.lua
	petrify = "Será petrificado(a) em %s.",

	-- pickable.lua
	pickable = {
		regrowth = "<color=NATURE>Recresce</color> em: <color=NATURE>%s</color>",
		regrowth_paused = "Recrescimento pausado.",
		cycles = "<color=DECORATION>Colheitas restantes</color>: <color=DECORATION>%s</color> / <color=DECORATION>%s</color>",
		mushroom_rain = "<color=WET>Chuva</color> necessária: %s",
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
		remaining_time = "<color=NATURE>Poison</color> expires in %s",
	},

	-- pollinator.lua
	pollination = "Flores polinizadas: (%s) / %s",

	-- polly_rogershat.lua [Prefab]
	polly_rogershat = {
		announce_respawn = "My <prefab=polly_rogers> irá ressurgir em %s."
	},

	-- preservative.lua
	preservative = "Restaura %s%% de frescor.",

	-- quaker.lua
	quaker = {
		next_quake = "<color=INEDIBLE>Terremoto</color> em %s",
	},

	-- questowner.lua
	questowner = {
		pipspook = {
			toys_remaining = "Brinquedos restantes: %s",
			assisted_by = "Este pipspook está sendo assistido por %s.",
		},
	},

	-- rainometer.lua [Prefab]
	global_wetness = "<color=FROZEN>Umidade Global</color>: <color=FROZEN>%s</color>",
	precipitation_rate = "<color=WET>Taxa de Precipitação</color>: <color=WET>%s</color>",
	frog_rain_chance = "<color=FROG>Chance de Chuva de Sapos</color>: <color=FROG>%s%%</color>",

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
		type = "Material de reparo: <color=#aaaaaa>%s</color>",
		health = "<color=HEALTH>Restauração de integridade</color>: <color=HEALTH>%s</color> + <color=HEALTH>%s%%</color>",
		health2 = "<color=HEALTH>%s<sub>flat HP</sub></color> + <color=HEALTH>%s%%<sub> %% de HP</sub></color>",
		work = "<color=#DED15E>Reparo de trabalho</color>: <color=#DED15E>%s</color>",
		work2 = "<color=#DED15E>%s<sub>Trabalho</sub></color>",
		perish = "<color=MONSTER>Reanimar</color>: <color=MONSTER>%s%%</color>",
		perish2 = "<color=MONSTER>Reanimar</color>: <color=MONSTER>%s%%</color>",
		held_repair = "Held <color=SWEETENER><prefab=%s></color> will repair <color=LIGHT>%s</color> uses (<color=LIGHT>%s%%</color>).",
		materials = (IS_DST and {
			[MATERIALS.WOOD] =  "Madeira",
			[MATERIALS.STONE] =  "Pedra",
			[MATERIALS.HAY] =  "Feno",
			[MATERIALS.THULECITE] =  "Tulecita",
			[MATERIALS.GEM] =  "Gema",
			[MATERIALS.GEARS] =  "Engrenagens",
			[MATERIALS.MOONROCK] =  "Pedra lunar",
			[MATERIALS.ICE] =  "Gelo",
			[MATERIALS.SCULPTURE] =  "Escultura",
			[MATERIALS.FOSSIL] =  "Fóssil",
			[MATERIALS.MOON_ALTAR] =  "Altar da Lua",
		} or {}),
	},

	-- repairable.lua
	repairable = {
		chess = "<color=#99635D>Engrenagens</color> necessárias: <color=#99635D>%s</color>",
	},

	-- riftspawner.lua
	riftspawner = {
		next_spawn = "<prefab=LUNARRIFT_PORTAL> spawns in %s",
		announce_spawn = "A <prefab=LUNARRIFT_PORTAL> will spawn in %s",

		stage = "Stage: %d / %d", -- augmented by growable
	},

	-- rocmanager.lua
	rocmanager = {
		cant_spawn = "Não foi possível gerar."
	},

	-- saddler.lua
	saddler = {
		bonus_damage = "<color=HEALTH>Bônus de dano</color>: <color=HEALTH>%s</color>",
		bonus_speed = "<color=DAIRY>Bônus de velocidade</color>: %s%%",
	},

	-- sanity.lua
	sanity = {
		current_sanity = "<color=SANITY>Sanidade</color>: <color=SANITY>%s</color> / <color=SANITY>%s</color> (<color=SANITY>%s%%</color>)",
		current_enlightenment = "<color=ENLIGHTENMENT>Iluminação</color>: <color=ENLIGHTENMENT>%s</color> / <color=ENLIGHTENMENT>%s</color> (<color=ENLIGHTENMENT>%s%%</color>)",
		interaction = "<color=SANITY>Sanity</color>: <color=SANITY>%+.1f</color>",
	},

	-- sanityaura.lua
	sanityaura = "<color=SANITY>Aura de Sanidade</color>: <color=SANITY>%s/min</color>",

	-- scenariorunner.lua
	scenariorunner = {
		opened_already = "Isto já foi aberto.",
		chest_labyrinth = {
			sanity = "66% de chance de mudar sua <color=SANITY>sanidade</color> de <color=SANITY>-20</color> à <color=SANITY>20</color>.",
			hunger = "66% de chance de mudar sua <color=HUNGER>fome</color> de <color=HUNGER>-20</color> à <color=HUNGER>20</color>.",
			health = "66% de chance de mudar sua <color=HEALTH>vida</color> de <color=HEALTH>0</color> à <color=HEALTH>20</color>.",
			inventory = "66% de chance de mudar <color=LIGHT>durabilidade</color> ou <color=MONSTER>frescura</color> em 20%.",
			summonmonsters = "66% de chance de invocar 1-3 <color=MOB_SPAWN>Moradores das Profundezas</color>.",
		},
	},

	-- shadowlevel.lua
	shadowlevel = {
		level = "<color=BLACK>Nível de sombra</color>: %s",
		level_diff = "<color=BLACK>Nível de sombra</color>: %s/%s",
		damage_boost = " (<color=HEALTH>+%s dano</color>)",
		total_shadow_level = "<color=BLACK>Nível total de sombra</color>: %s",
	},

	-- shadowrift_portal.lua [Prefab]
	shadowrift_portal = {
		close = "<prefab=SHADOWRIFT_PORTAL> will close in %s",
	},

	-- shadowsubmissive.lua
	shadowsubmissive = {
		shadowcreature = {
			spawned_for = "Gerado por %s.",
			sanity_reward = "<color=SANITY>Sanidade</color> recuperada: <color=SANITY>%s</color>",
			sanity_reward_split = "<color=SANITY>Sanidade</color> recuperada: <color=SANITY>%s</color> / <color=SANITY>%s</color>",
		},
	},

	-- shadowthrallmanager.lua
	shadowthrallmanager = {
		fissure_cooldown = "Next fissure will be ready for takeover in %s",
		waiting_for_players = "Waiting for a player to come near",
		thrall_count = "<color=MOB_SPAWN><prefab=SHADOWTHRALL_HANDS></color>: %d",
		dreadstone_regen = "<color=#942429><prefab=DREADSTONE></color> will regenerate in %s",
	},

	-- sharkboi.lua [Prefab]
	sharkboi = {
		trades_remaining = "Trades left: %d",
	},

	-- sheltered.lua
	sheltered = {
		range = "Alcance do abrigo: %s unidade(s) de parede",
		shelter = "Abrigo ",
	},

	-- singable.lua
	singable = {
		battlesong = {
			battlesong_durability = "<color=HEALTH>Armas</color> duram <color=#aaaaee>%s%%</color> mais.",
			battlesong_healthgain = "Atingir inimigos restaura <color=HEALTH>%s de vida</color> (<color=HEALTH>%s</color> para Wigfrids).",
			battlesong_sanitygain = "Atingir inimigos restaura  <color=SANITY>%s de sanidade</color>.",
			battlesong_sanityaura = "As <color=SANITY>auras de sanidade</color> negativas são <color=SANITY>%s%%</color> menos eficazes.",
			battlesong_fireresistance = "Recebe <color=HEALTH>%s%% menos dano</color> de <color=LIGHT>fogo</color>.",
			battlesong_instant_taunt = "Provoca todos os inimigos próximos dentro do raio da música.",
			battlesong_instant_panic = "Apavora inimigos assombráveis próximos durante %s segundo(s).",
		},
		cost = "Custa %s de inspiração para usar.",
	},

	-- sinkholespawner.lua
	antlion_rage = "Formileão irá atacar em %s",

	-- skinner_beefalo.lua
	skinner_beefalo = "Temível: %s, Festivo: %s, Formal: %s",

	-- sleeper.lua
	sleeper = {
		wakeup_time = "Irá acordar em %s",
	},

	-- soul.lua
	wortox_soul_heal = "<color=HEALTH>Cura</color> em <color=HEALTH>%s</color> - <color=HEALTH>%s</color>.",
	wortox_soul_heal_range = "<color=HEALTH>Cura</color> pessoas em um raio de <color=#DED15E>%s blocos</color>.",

	-- spawner.lua
	spawner = {
		next = "Irá surgir um(a) <color=MOB_SPAWN><prefab={child_name}></color> em {respawn_time}.",
		child = "Surgiu um(a) <color=MOB_SPAWN><prefab=%s></color>",
		occupied = "Occupied: %s",
	},

	-- spider_healer.lua [Prefab]
	spider_healer = {
		webber_heal = "<color=HEALTH>Cura</color> o Webber em <color=HEALTH>%+d</color>",
		spider_heal = "<color=HEALTH>Cura</color> as aranhas em <color=HEALTH>%+d</color>",
	},

	-- stagehand.lua [Prefab]
	stagehand = {
		hits_remaining = "<color=#aaaaee>Batidas</color> restantes: <color=#aaaaee>%s</color>",
		time_to_reset = "Reiniciará em %s." 
	},

	-- stewer.lua
	stewer = {
		product = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>)",
		cooktime_remaining = "<color=HUNGER><prefab=%s></color>(<color=HUNGER>%s</color>) estará pronto em %s segundo(s).",
		cooker = "Feito por <color=%s>%s</color>.",
		cooktime_modifier_slower = "Cozinha comida <color=#DED15E>%s%%</color> mais devagar.",
		cooktime_modifier_faster = "Cozinha comida <color=NATURE>%s%%</color> mais rápido.",
	},

	-- stickable.lua
	stickable = "<color=FISH>Mexilhões</color>: %s",

	-- temperature.lua
	temperature = "Temperatura: <temperature=%s>",

	-- terrarium.lua [Prefab]
	terrarium = {
		day_recovery = "Recupera <color=HEALTH>%s</color> de vida por dia sem lutar.",
		eot_health = "<prefab=eyeofterror> <color=HEALTH>Vida</color> no retorno: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		retinazor_health = "<prefab=TWINOFTERROR1> <color=HEALTH>Vida</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		spazmatism_health = "<prefab=TWINOFTERROR2> <color=HEALTH>Vida</color>: <<color=HEALTH>%s</color> / <color=HEALTH>%s</color>>",
		announce_cooldown = "<prefab=terrarium> will be ready in %s.",
	},

	-- tigersharker.lua
	tigershark_spawnin = "Pode aparecer em: %s",
	tigershark_waiting = "Pronto para aparecer.",
	tigershark_exists = "O Tubarão Tigre está presente.",

	-- timer.lua
	timer = {
		label = "Temporizador <color=#8c8c8c>'%s'</color>: %s",
		paused = "Pausado",
	},

	-- toadstoolspawner.lua
	toadstoolspawner = {
		time_to_respawn = "<prefab=toadstool> will respawn in %s.",
	},

	-- tool.lua
	action_efficiency = "<color=#DED15E>%s</color>: %s%%",
	tool_efficiency = "<color=NATURE>Eficiência</color> < %s >", -- #A5CEAD

	-- tradable.lua
	tradable_gold = "Vale %s pepita(s) de ouro.",
	tradable_gold_dubloons = "Vale %s pepita(s) de ouro e %s dubloon(s).",
	tradable_rocktribute = "Atrasa a raiva do <color=LIGHT>Formileão</color> em %s.",

	-- unwrappable.lua
	-- handled by klei?

	-- upgradeable.lua
	upgradeable_stage = "Estágio %s / %s: ",
	upgradeable_complete = "Atualização %s%% completa.",
	upgradeable_incomplete = "Não é possível atualizar.",

	-- upgrademodule.lua
	upgrademodule = {
		module_describers = {
			maxhealth = "Aumenta a <color=HEALTH>saúde máxima</color> em <color=HEALTH>%d</color>.",
			maxsanity = "Aumenta  <color=SANITY>sanidade máxima</color> em <color=SANITY>%d</color>.",
			movespeed = "Aumenta a <color=DAIRY>velocidade</color> em %s.",
			heat = "Aumenta a <color=#cc0000>temperatura mínima</color> em <color=#cc0000>%d</color>.",
			heat_drying = "Aumenta a <color=#cc000>taxa de secagem</color> em <color=#cc0000>%.1f</color>.",
			cold = "Diminui a <color=#00C6FF>temperatura mínima</color> em <color=#00C6FF>%d</color>.",
			taser = "Causa <color=WET>%d</color> %s aos atacantes (cooldown: %.1f).",
			light = "Promove um <color=LIGHT>raio de luz</color> de <color=LIGHT>%.1f</color> (extras apenas <color=LIGHT>%.1f</color>).",
			maxhunger = "Increases <color=HUNGER>max hunger</color> by <color=HUNGER>%d</color>.",
			music = "Promove uma <color=SANITY>aura de sanidade</color> de <color=SANITY>%+.1f/min</color> dentro de <color=SANITY>%.1f</color> bloco(s).",
			music_tend = "Cuida de plantas dentro de <color=NATURE>%.1f</color> blocos.",
			bee = "Regenera <color=HEALTH>%d vida/%ds</color> (<color=HEALTH>%d/day</color>).",
		},
	},

	-- walrus_camp.lua [Prefab]
	walrus_camp_respawn = "<color=MOB_SPAWN><prefab=%s></color> ressurgirar em: <color=FROZEN>%s</color>",

	-- waterproofer.lua
	waterproofness = "<color=WET>Impermeabilidade</color>: <color=WET>%s%%</color>",
	
	-- watersource.lua
	watersource = "Esta é uma fonte de água.",

	-- wateryprotection.lua
	wateryprotection = {
		wetness = "Aumenta a umidade em <color=WET>%s</color>."
	},

	-- weapon.lua
	weapon_damage_type = {
		normal = "<color=HEALTH>Dano</color>",
		electric = "<color=WET>(Elétrico)</color> <color=HEALTH>Dano</color>",
		poisonous = "<color=NATURE>(Veneno)</color> <color=HEALTH>Dano</color>",
		thorns = "<color=HEALTH>(Espinhos)</color> <color=HEALTH>Dano</color>"
	},
	weapon_damage = "%s: <color=HEALTH>%s</color>",
	attack_range = "Alcance: %s",

	-- weather.lua
	weather = {
		progress_to_rain = "Progresso para chover: %s / %s",
		remaining_rain = "Chuva restante: %s",
	},

	-- weighable.lua
	weighable = {
		weight = "Peso: %s (%s%%)",
		weight_bounded = "Peso: %s <= %s (%s) <= %s",
		owner_name = "Proprietário: %s"
	},

	-- werebeast.lua
	werebeast = "Lobisomem: %s / %s",

	-- wereness.lua
	wereness_remaining = "Lobisomem: %s / %s",

	-- winch.lua
	winch = {
		not_winch = "Este item tem um componente de guincho, mas houve falha na verificação de pré-fabricação.",
		sunken_item = "Há um <color=#66ee66>%s</color> embaixo deste guincho.",
	},

	-- winterometer.lua [Prefab]
	world_temperature = "<color=LIGHT>Temperatura do Mundo</color>: <color=LIGHT>%s</color>",

	-- wintersfeasttable.lua

	-- wintertreegiftable.lua
	wintertreegiftable = {
		ready = "Você está <color=#bbffbb>elegível</color> para <color=#DED15E>presentes de Natal</color>.",
		not_ready = "Você deve <color=#ffbbbb>esperar mais %s dia(s)</color> antes de ganhar outro <color=#DED15E>presente de Natal</color>.",
	},

	-- witherable.lua
	witherable = {
		delay = "A mudança de estado está atrasada em %s",
		wither = "Vai murchar em %s",
		rejuvenate = "Rejuvenescerá em %s"
	},

	-- workable.lua
	workable = {
		treeguard_chance_dst = "<color=#636C5C>Chance de Treeguard</color>: %s%%<sub>Você</sub> & %s%%<sub>NPC</sub>",
		treeguard_chance = "<color=#636C5C>Chance de Treeguard</color>: %s%%",
	},

	-- worldmigrator.lua
	worldmigrator = {
		disabled = "Worldmigrator desabilitado.",
		target_shard = "Fragmento alvo: %s",
		received_portal = "Portal alvo: %s", -- Shard Migrator
		id = "Este Portal: %s",
	},

	-- worldsettingstimer.lua
	worldsettingstimer = {
		label = "WSTimer <color=#8c8c8c>'%s'</color>: %s",
		paused = "Pausado",
	},

	-- wx78.lua [Prefab]
	wx78 = {
		remaining_charge_time = "Carga restante: %s",
		gain_charge_time = "Irá ganhar uma <color=LIGHT>carga</color> em: <color=LIGHT>%s</color>",
		full_charge = "Completamente carregado!",
	},

	-- wx78_scanner.lua [Prefab]
	wx78_scanner = {
		scan_progress = "Scan progress: %.1f%%",
	},

	-- yotb_sewer.lua
	yotb_sewer = "Vai terminar de costurar em: %s",
}