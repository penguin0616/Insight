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

---------------------------------------
-- Mod information for the game to process.
-- @script modinfo
-- @author penguin0616

-- DS 2081254154
-- DST 2189004162
-- loadstring is present
local IsDST = folder_name == "workshop-2189004162" -- https://forums.kleientertainment.com/forums/topic/150829-game-update-571392/      manifest: 506706240727140821
local IsDS = folder_name == "workshop-2081254154"

if IsDST == false and IsDS == false then
	-- Probable reasons:
	-- #1: Pre2023 update branch in DS.
	-- #2: Using one of those mods that nukes the modinfo.
	-- #3: Using an unofficial/stolen version of Insight.
	if folder_name == nil then
		-- Hopefully #1 or #2.
		IsDST = false
		IsDS = true
	else
		-- Unofficial/stolen version of Insight.
	end
end


name = "Insight"
-- Major.Minor.Patch
version = "4.8.2" -- dst is 4.6.2, ds is 4.5.0
author = "penguin0616"
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"
id = "Insight"
priority = -10000 --[[ rezecib's Geometric Placement has -10, chinese++, has -9999. assuming the rest of the chinese translation mods use a similar enough priority.
ideally, we come last in the mod loading order to make life easier. 
that way, I can try to be compatible with other mods without them having to worry about compatibility with Insight. after all, probably better if I handle it.
--]]

-- DS
api_version = 6
dont_starve_compatible = true
reign_of_giants_compatible = true -- DLC0001
shipwrecked_compatible = true -- DLC0002
hamlet_compatible = true -- DLC0003 

-- DST
api_version_dst = 10
dst_compatible = true
server_only_mod = true
client_only_mod = false
all_clients_require_mod = true
forge_compatible = true
server_filter_tags = {"insight_" .. version}
forcemanifest = false -- TODO: REMOVE THIS

-- Clear some environment stuff out.
local a = ChooseTranslationTable
ChooseTranslationTable = nil
local ChooseTranslationTable, a = a, nil

local STRINGS

-- Documentation
--[==[
	
]==]

--[==[
	Tags: 
		"dynamic_option_strings": 
			If a configuration has this tag, that means the options table for the configuration in STRINGS is a function.
			The function gets called in AddConfigurationOptionStrings, which ***isn't*** called on complex configuration here in modinfo.
			It's called by clientmodmain after the options and default functions are run.

			In other words, STRINGS for complex configuration functions with this tag don't get calculated.
]==]

--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================
--[[ Some Functions ]]
--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================
local HasTag

-- from stringutil.lua
local function subfmt(s, tab)
	return (s:gsub('(%b{})', function(w) return tab[w:sub(2, -2)] or w end))
end

local string_format = name.format
local string_match = name.match
local string_gmatch = name.gmatch
local string_sub = name.sub

local function ipairs(tbl)
	return function(tbl, index)
		index = index + 1
		local next = tbl[index]
		if next then
			return index, next
		end
	end, tbl, 0
end

local function IsString(arg)
	return arg.sub == string_sub
end

local function tostring(arg)
	if arg == true then
		return "true"
	elseif arg == false then
		return "false"
	elseif arg == nil then
		return "nil"
	end

	return arg .. ""
end

local function T(tbl, key)
	if locale and ChooseTranslationTable then
		return ChooseTranslationTable(tbl, key)
	else
		return tbl["en"] or tbl[1]
	end
	--return GetTranslation
end

function AddConfigurationOptionStrings(entry)
	local name = entry.name

	--entry.label = T(entry.name .. ".LABEL")
	entry.label = T(STRINGS[name].label)
	--entry.hover = T(entry.name .. ".HOVER")
	entry.hover = T(STRINGS[name].hover)

	if HasTag(entry, "dynamic_option_strings") then
		STRINGS[name].options = STRINGS[name].options(entry)
	end

	for j = 1, #entry.options do
		local option = entry.options[j]
		--option.description = T(string_format("%s.OPTIONS.%s.DESCRIPTION", entry.name, tostring(option.data)))
		local dsc = STRINGS[name].options[option.data].description
		option.description = dsc and T(dsc) or nil
		
		--option.hover = T(string_format("%s.OPTIONS.%s.HOVER", entry.name, tostring(option.data)))
		local hvr = STRINGS[name].options[option.data].hover
		option.hover = hvr and T(hvr) or nil
	end
end

local function AddSectionTitle(title) -- 100% stole this idea from ReForged. Didn't know this was possible!
	if IsDST then
		return {
			name = title:upper(), -- avoid conflicts
			label = title, 
			options = {{description = "", data = 0}},
			default = 0,
			tags = {"ignore"},
		}
	else
		return {
			-- the _ is processed by the insightconfigurationscreen for DS sectionheaders.
			_ = {
				name = title:upper(),
				label = title, 
				options = {{description = "", data = 0}},
				default = 0,
			},
			tags = {"ignore"}
		}
	end
end

local function GetDefaultSetting(entry)
	-- the "error messages" are to prevent hypothetical crashing on startup if I make grevious errors

	if not entry then
		local msg = "MAJOR ERROR. ENTRY IS NIL. PLEASE REPORT TO MOD CREATOR."
		return { description = msg, data = false, hover = msg}
	end

	for i = 1, #entry.options do
		if entry.options[i].data == entry.default then
			return entry.options[i]
		end
	end

	local msg = "[DEFAULT???]: \n" .. entry.name .. "|" .. tostring(entry.default)
	return { description = msg, data = false, hover = msg}
end

local function GetConfigurationOptionByName(name)
	for i = 1, #configuration_options do
		local v = configuration_options[i]
		if v.name == name then
			return v
		end
	end
end

function HasTag(entry, tag) -- Localized above
	if entry.tags then
		for i = 1, #entry.tags do
			if entry.tags[i] == tag then
				return true
			end
		end
	end
end

-- Only appends to end of table
local function table_append(tbl, val)
	tbl[#tbl+1] = val
end

local function table_remove(tbl, index) -- it worked first try wow nice job me.
	tbl[index] = nil
	for i = index, #tbl do
		tbl[i] = tbl[i + 1]
	end
end

--==========================================================================================
--[[ Config Primers ]]
--==========================================================================================

local HOVERER_TRUNCATION_AMOUNTS = { "None", 1, 2, 3, 4, 5 }

--[[ Font Sizes ]]
local FONT_SIZE = {
	INSIGHT = {
		HOVERER = {20, 30},
		INVENTORYBAR = {20, 25},
		FOLLOWTEXT = {20, 28}
	}
}

-- Just plucked some ones in common in DS/T
local FONTS = {"UIFONT", "TITLEFONT", "DIALOGFONT", "NUMBERFONT", "BODYTEXTFONT", "TALKINGFONT"}

--- Generates options from a list.
---@param for_config boolean If false, will generate results suitable for the translation table. true generates the option for the configuration option.
---@param list table The list of stuff to be generating from.
---@param hoverfn function|nil The hover table.
local function GenerateOptionsFromList(for_config, list, hoverfn)
	local t = {}
	for i = 1, #list do
		local opt = list[i]

		if for_config == false then
			local hover = hoverfn and hoverfn(i, opt)
			t[opt] = { 
				description = {
					tostring(opt) -- English
				}, 
				hover = hover
			}
		elseif for_config == true then
			t[#t+1] = { 
				data = opt
			}
		else
			-- Just to get us to trigger an error.
			unknown_arg_detected()
		end
	end

	return t
end

local function GenerateFontSizeTexts(which)
	local t = {}
	for i = which[1], which[2] do
		t[i] = { description={tostring(i)} } -- This doesn't need localization.
	end
	return t
end

local function GenerateFontSizeOptions(which)
	local t = {}
	for i = which[1], which[2] do
		t[#t+1] = { data=i }
	end
	return t
end

--[[ Indicator stuff ]]
local BOSSES = {"minotaur", "bearger", "deerclops", "dragonfly"}
local BOSSES_DST = {"antlion", "beequeen", "crabking",  "klaus", "malbatross", "moose", "stalker_atrium", "toadstool", "eyeofterror", "twinofterror1", "twinofterror2", "daywalker"}
local BOSSES_DS = {"ancient_herald", "ancient_hulk", "pugalisk", "twister", "twister_seal", "tigershark", "kraken", "antqueen"}
local BOSSES_ALL = {}

do
	-- Go through every miniboss table and add the val to ALL
	for i,v in ipairs(BOSSES) do
		table_append(BOSSES_ALL, v)
	end

	for i,v in ipairs(BOSSES_DST) do
		table_append(BOSSES_ALL, v)
	end

	for i,v in ipairs(BOSSES_DS) do
		table_append(BOSSES_ALL, v)
	end

	-- Setup Minibosses to have only the vanilla prefabs for the current game.
	local t = IsDST and BOSSES_DST or BOSSES_DS
	for i,v in ipairs(t) do
		table_append(BOSSES, v)
	end
end


local MINIBOSSES = {"leif", "warg", "spat", "spiderqueen"} -- Common across both; used further ("leif_sparse" has handling elsewhere)
local MINIBOSSES_DST = {"claywarg", "gingerbreadwarg", "lordfruitfly", "stalker"}
local MINIBOSSES_DS = {"ancient_robot_ribs", "ancient_robot_claw", "ancient_robot_leg", "ancient_robot_head", "treeguard"}
local MINIBOSSES_ALL = {}

do
	-- Go through every miniboss table and add the val to ALL
	for i,v in ipairs(MINIBOSSES) do
		table_append(MINIBOSSES_ALL, v)
	end

	for i,v in ipairs(MINIBOSSES_DST) do
		table_append(MINIBOSSES_ALL, v)
	end

	for i,v in ipairs(MINIBOSSES_DS) do
		table_append(MINIBOSSES_ALL, v)
	end

	-- Setup Minibosses to have only the vanilla prefabs for the current game.
	local t = IsDST and MINIBOSSES_DST or MINIBOSSES_DS
	for i,v in ipairs(t) do
		table_append(MINIBOSSES, v)
	end
end

local NOTABLE_INDICATORS = {"chester_eyebone", "hutch_fishbowl"}
local NOTABLE_INDICATORS_DST = {"atrium_key", "klaus_sack", "gingerbreadpig"}
local NOTABLE_INDICATORS_DS = {} -- TODO: The carrier things in SW and Hamlet
local NOTABLE_INDICATORS_ALL = {}

do
	for i,v in ipairs(NOTABLE_INDICATORS) do
		table_append(NOTABLE_INDICATORS_ALL, v)
	end

	for i,v in ipairs(NOTABLE_INDICATORS_DST) do
		table_append(NOTABLE_INDICATORS_ALL, v)
	end

	for i,v in ipairs(NOTABLE_INDICATORS_DS) do
		table_append(NOTABLE_INDICATORS_ALL, v)
	end
	
	-- Yep
	if IsDST then
		for i,v in ipairs(NOTABLE_INDICATORS_DST) do
			table_append(NOTABLE_INDICATORS, v)
		end
	end
end

-- Unique Prefabs
local UNIQUE_INFO_PREFABS = {
	"alterguardianhat", "batbat", "eyeplant", "ancient_statue", "armordreadstone", "voidcloth_scythe", "lunarthrall_plant",
	"shadow_battleaxe",
}

--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================
--[[ Strings ]] 
--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================
local COMMON_STRINGS = { 
	NO = {
		DESCRIPTION = {
			"No",
			["zh"] = "否",
			["br"] = "Não",
			["es"] = "Desactivado",
			["ru"] = "Нет",
			["ko"] = "아니요",
		},
	},
	YES = {
		DESCRIPTION = {
			"Yes",
			["zh"] = "是",
			["br"] = "Sim",
			["es"] = "Activado",
			["ru"] = "Да",
			["ko"] = "예",
		},
	}
}

--[[
example = {
	label = {
		"Example", 
		["zh"] = nil, 
		["br"] = nil, 
		["es"] = nil,
		["ru"] = nil,
		["ko"] = nil,
	},
	hover = {
		"Description", 
		["zh"] = nil, 
		["br"] = nil, 
		["es"] = nil,
		["ru"] = nil,
		["ko"] = nil,
	},
	options = {
		[false] = {
			description = COMMON_STRINGS.NO.DESCRIPTION,
			hover = {
				"Hover",
				["zh"] = nil,
				["br"] = nil,
				["es"] = nil,
				["ru"] = nil,
				["ko"] = nil,
			},
		},
		[true] = {
			description = COMMON_STRINGS.YES.DESCRIPTION,
			hover = {
				"Hover",
				["zh"] = nil,
				["br"] = nil,
				["es"] = nil,
				["ru"] = nil,
				["ko"] = nil,
			},
		},
	},
},
]]


STRINGS = {
	--==========================================================================================
	--[[ Misc Strings ]]
	--==========================================================================================
	ds_not_enabled = {
		"Mod must be enabled for functioning modinfo",
		["zh"] = nil,
		["br"] = "O mod deve estar ativado para o funcionamento do modinfo",
		["es"] = "El mod debe estar habilitado para que funcione el modinfo.",
		["ru"] = "Для работы modinfo мод должен быть включен",
		["ko"] = "modinfo가 작동하려면 모드를 활성화해야합니다.",
	},
	update_info = {
		"See Steam changelog for more info.",
		["zh"] = nil,
		["br"] = "Uma *tonelada* de coisas. Você deve **realmente** verificar as Notas de Alterações do Steam.",
		["es"] = nil,
		["ru"] = "Добавлена информация об обновлениях From Beyond и других вещах. Смотрите список изменений Steam для получения дополнительной информации.",
		["ko"] = "자세한 내용은 Steam 변경 로그를 참조하세요.",
	},
	update_info_ds = {
		"A *ton* of stuff. You should **really** check the Steam Change Notes.",
		["zh"] = nil,
		["br"] = "Uma *tonelada* de coisas. Você deve **realmente** verificar as Notas de Alterações do Steam.",
		["es"] = nil,
		["ru"] = "*Куча* всего. Вам **действительно** стоит ознакомиться с Steam Change Notes.",
		["ko"] = "*엄청* 많은 것들이 있습니다. **반드시** Steam 변경 사항을 확인하세요.",
	},
	crashreporter_info = {
		"Insight has a crash reporter you can enable in the client & server config",
		["zh"] = "添加了崩溃报告器, 你可以在客户端或服务器设置界面来开启它。",
		["br"] = "O Insight tem um relatório de falhas que você pode ativar na configuração do cliente e do servidor",
		["es"] = "Insight tiene un informe de fallos que puedes activar en la configuración del cliente y del servidor.",
		["ru"] = "В Insight есть функция отслеживания сбоев, которую вы можете включить в конфигурации клиента и сервера",
		["ko"] = "Insight에는 충돌 보고 기능이 있습니다. 클라이언트 & 서버 모드 설정에서 활성화할 수 있습니다",
	},
	mod_explanation = {
		"Basically Show Me but with more features.",
		["zh"] = "以 Show Me 为基础，但功能更全面",
		["br"] = "Basicamente o Show Me, mas com mais recursos.",
		["es"] = "Básicamente Show Me pero con más funciones.",
		["ru"] = "В основном Show Me, но с большим количеством функций.",
		["ko"] = "기본적으로 Show Me 모드의 기능을 제공하지만 더 많은 기능이 포함되어 있습니다.",
	},
	config_paths = {
		"Server Configuration: Main Menu -> Host Game -> Mods -> Server Mods -> Insight -> Configure Mod\n-------------------------\nClient Configuration: Main Menu -> Mods -> Server Mods -> Insight -> Configure Mod",
		["zh"] = "服务器设置方法: 主界面 -> 创建世界-> 模组 -> 服务器模组 -> Insight -> 模组设置\n-------------------------\n客户端设置方法: 主界面 -> 模组 -> 服务器模组 -> Insight -> 模组设置",
		["br"] = "Configuração do Servidor: Main Menu -> Host Game -> Mods -> Server Mods -> Insight -> Configure Mod\n-------------------------\nConfiguração do Client: Main Menu -> Mods -> Server Mods -> Insight -> Configure Mod",
		["es"] = "Configuración de servidor: Menú principal -> Crear partida -> Mods -> Mods servidor -> Insight -> Configurar mod\n-------------------------\nConfiguración del cliente: Menú principal -> Mods -> Mods servidor -> Insight -> Configurar mod",
		["ru"] = "Конфигурация сервера: Главное меню -> Создать игру -> Моды -> Моды сервера -> Insight -> Настроить мод\n-------------------------\nКонфигурация клиента: Главное меню -> Моды -> Моды сервера -> Insight -> Настроить мод",
		["ko"] = "서버 모드 설정: 메인 메뉴 -> 게임 열기 -> 모드 -> 서버 모드 -> Insight -> 모드 설정\n-------------------------\n클라이언트 모드 설정: 메인 메뉴 -> 모드 -> 서버 모드 -> Insight -> 모드 설정",
	},
	config_disclaimer = {
		"Make sure to check out the configuration options.",
		["zh"] = "请确认你设置的各个选项, 尤其是设置好显示的和设置不再显示的信息，需要格外注意。",
		["br"] = "Certifique-se de verificar as opções de configuração.",
		["es"] = "Asegúrese de comprobar las opciones de configuración.",
		["ru"] = "Убедитесь, что проверили параметры конфигурации.",
		["ko"] = "설정 옵션을 확인하세요.",
	},
	version = {
		"Version",
		["zh"] = "版本",
		["br"] = "Versão",
		["es"] = "Versión",
		["ru"] = "Версия",
		["ko"] = "버전",
	},
	latest_update = {
		"Latest update",
		["zh"] = "最新更新",
		["br"] = "Última atualização",
		["es"] = "Última actualización",
		["ru"] = "Последнее обновление",
		["ko"] = "최근 업데이트",
	},
	undefined = {
		"Undefined",
		["zh"] = "默认",
		["br"] = "Indefinido",
		["es"] = "Indefinido",
		["ru"] = "Неопределено",
		["ko"] = "미정",
	},
	undefined_description = {
		"Defaults to: ",
		["zh"] = "默认为：",
		["br"] = "Padrões para: ",
		["es"] = "Por defecto es: ",
		["ru"] = "По умолчанию: ",
		["ko"] = "기본값",
	},
	--==========================================================================================
	--[[ Section Titles ]]
	--==========================================================================================
	sectiontitle_formatting = {
		"Formatting",
		["zh"] = "格式",
		["br"] = "Formações",
		["es"] = "Formato",
		["ru"] = "Форматирование",
		["ko"] = "형식",
	},
	sectiontitle_indicators = {
		"Indicators",
		["zh"] = "指示器",
		["br"] = "Indicadores",
		["es"] = "Indicadores",
		["ru"] = "Форматирование",
		["ko"] = "표시",
	},
	sectiontitle_foodrelated = {
		"Food Related",
		["zh"] = "食物相关",
		["br"] = "Relacionado a comidas",
		["es"] = "Alimentos",
		["ru"] = "Связанные с едой",
		["ko"] = "식품 관련",
	},
	sectiontitle_informationcontrol = {
		"Information Control",
		["zh"] = "信息控制",
		["br"] = "Informações de controle",
		["es"] = "Información",
		["ru"] = "Управление информацией",
		["ko"] = "정보 관리",
	},
	sectiontitle_miscellaneous = {
		"Miscellaneous",
		["zh"] = "杂项",
		["br"] = "Diversos",
		["es"] = "Varios",
		["ru"] = "Разное",
		["ko"] = "기타 옵션",
	},
	sectiontitle_debugging = {
		"Debugging",
		["zh"] = "调试",
		["br"] = "Debugging",
		["es"] = "Depuración",
		["ru"] = "Отладка",
		["ko"] = "디버깅",
	},
	sectiontitle_complexconfiguration = {
		"Special Configuration",
		["zh"] = "特殊配置",
		["br"] = "Configuração Especial",
		["es"] = nil,
		["ru"] = "Особая конфигурация",
		["ko"] = "특수 설정",
	},
	--==========================================================================================
	--[[ Complex Configuration Options ]]
	--==========================================================================================
	boss_indicator_prefabs = {
		label = {
			"Boss Indicator Prefabs", 
			["zh"] = "Boss 指示器预设", 
			["br"] = "Prefabs de Indicadores de Chefões", 
			["es"] = nil,
			["ru"] = "Префабы индикаторов боссов",
			["ko"] = "Boss Indicator Prefabs",
		},
		hover = {
			"Enabled boss indicator prefabs.", 
			["zh"] = "启用 Boss 指示器的生物。", 
			["br"] = "Prefabs de Indicadores de Chefões ativados", 
			["es"] = nil,
			["ru"] = "Включены префабы индикаторов боссов.",
			["ko"] = "Boss Indicator Prefabs 활성화",
		},
		options = function(config)
			local t = {} 
			for i,v in ipairs(config.options) do
				t[v.data] = {
					description = {"<prefab=" .. v.data .. ">"},
					hover = nil,
				}
			end
			return t
		end,
	},
	miniboss_indicator_prefabs = {
		label = {
			"Miniboss Indicator Prefabs", 
			["zh"] = "小 Boss 指示器预设", 
			["br"] = "Prefabs de Indicadores de Mini-Chefões", 
			["es"] = nil,
			["ru"] = "Префабы индикаторов мини-боссов",
			["ko"] = "Miniboss Indicator Prefabs",
		},
		hover = {
			"Enabled miniboss indicator prefabs.", 
			["zh"] = "启用小 Boss 指示器的生物。", 
			["br"] = "Prefabs de Indicadores de Mini-Chefões ativados", 
			["es"] = nil,
			["ru"] = "Включены префабы индикаторов мини-боссов.",
			["ko"] = "Miniboss Indicator Prefabs 활성화",
		},
		options = function(config)
			local t = {} 
			for i,v in ipairs(config.options) do
				t[v.data] = {
					description = {"<prefab=" .. v.data .. ">"},
					hover = nil,
				}
			end
			return t
		end,
	},
	notable_indicator_prefabs = {
		label = {
			"Notable Indicator Prefabs", 
			["zh"] = "其他物品指示器预设", 
			["br"] = "Prefabs de Indicadores Notáveis", 
			["es"] = nil,
			["ru"] = "Префабы примечательных индикаторов",
			["ko"] = "기타 항목 Indicator Prefabs",
		},
		hover = {
			"Enabled notable indicator prefabs.", 
			["zh"] = "启用指示器的其他物品。", 
			["br"] = "Prefabs de Indicadores Notáveis ativados", 
			["es"] = nil,
			["ru"] = "Включены префабы примечательных индикаторов.",
			["ko"] = "기타 항목 Indicator Prefabs 활성화",
		},
		options = function(config)
			local t = {} 
			for i,v in ipairs(config.options) do
				t[v.data] = {
					description = {"<prefab=" .. v.data .. ">"},
					hover = nil,
				}
			end
			return t
		end,
	},
	unique_info_prefabs = {
		label = {
			"Unique Information", 
			["zh"] = "特定信息", 
			["br"] = "Informações Únicas", 
			["es"] = "Información única",
			["ru"] = "Уникальная информация",
			["ko"] = "고유 정보",
		},
		hover = {
			"Whether to display unique information for certain entities.", 
			["zh"] = "是否显示特定实体的特定信息。", 
			["br"] = "Se vai exibir informações exclusivas para determinadas entidades.", 
			["es"] = "Configura si se muestra información única de ciertas entidades.",
			["ru"] = "Отображать ли уникальную информацию для определенных сущностей.",
			["ko"] = "특정 개체에 대한 고유 정보를 표시할지 여부",
		},
		options = function(config)
			local t = {} 
			for i,v in ipairs(config.options) do
				t[v.data] = {
					description = {"<prefab=" .. v.data .. ">"},
					hover = nil,
				}
			end
			return t
		end,
	},
	--==========================================================================================
	--[[ Configuration Options ]]
	--==========================================================================================
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Formatting ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	language = {
		label = {
			"Language", 
			["zh"] = "语言", 
			["br"] = "Idioma", 
			["es"] = "Idioma",
			["ru"] = "Язык",
			["ko"] = "언어",
		},
		hover = {
			"The language you want information to display in.", 
			["zh"] = "你希望以哪种语言显示信息", 
			["br"] = "O idioma em que você deseja que as informações sejam exibidas.", 
			["es"] = "El idioma en el que se muestra la información.",
			["ru"] = "Язык, на котором вы хотите отображать информацию.",
			["ko"] = "원하는 언어로 정보를 표시합니다.",
		},
		options = {
			["automatic"] = {
				description = {
					"Automatic",
					["zh"] = "自动",
					["br"] = "Automático",
					["es"] = "Automático",
					["ru"] = "Автоматически",
					["ko"] = "자동",
				},
				hover = {
					"Uses your current language settings.",
					["zh"] = "使用游戏当前的语言设定",
					["br"] = "Usa suas configurações de idioma atuais.",
					["es"] = "Utiliza tu configuración de idioma actual.",
					["ru"] = "Использует текущие настройки языка.",
					["ko"] = "현재 언어 설정을 사용합니다.",
				},
			},
			["en"] = {
				description = {
					"English",
					["zh"] = "英语",
					["br"] = "English",
					["es"] = "Inglés",
					["ru"] = "Английский",
					["ko"] = "영어",
				},
				hover = {
					"English",
					["zh"] = "英语",
					["br"] = "Inglês",
					["es"] = "Inglés",
					["ru"] = "Английский",
					["ko"] = "영어",
				},
			},
			["zh"] = {
				description = {
					"Chinese",
					["zh"] = "中文",
					["br"] = "Chinese",
					["es"] = "Chino",
					["ru"] = "Китайский",
					["ko"] = "중국어",
				},
				hover = {
					"Chinese",
					["zh"] = "中文",
					["br"] = "Chinês",
					["es"] = "Chino",
					["ru"] = "Китайский",
					["ko"] = "중국어",
				},
			},
			["br"] = {
				description = {
					"Portuguese",
					["zh"] = "Portuguese",
					["br"] = "Português",
					["es"] = "Portugués",
					["ru"] = "Португальский",
					["ko"] = "포르투갈어",
				},
				hover = {
					"Portuguese",
					["zh"] = "Portuguese",
					["br"] = "Português",
					["es"] = "Portugués",
					["ru"] = "Португальский",
					["ko"] = "포르투갈어",
				},
			},
			["es"] = {
				description = {
					"Spanish",
					["zh"] = "Spanish",
					["br"] = "Spanish",
					["es"] = "Español",
					["ru"] = "Испанский",
					["ko"] = "스페인어",
				},
				hover = {
					"Spanish",
					["zh"] = "Spanish",
					["br"] = "Spanish",
					["es"] = "Español",
					["ru"] = "Испанский",
					["ko"] = "스페인어",	
				},
			},			
			["ru"] = {
				description = {
					"Русский",
					["zh"] = "Russian",
					["br"] = "Russian",
					["es"] = "Ruso",
					["ru"] = "Русский",
					["ko"] = "러시아어",
				},
				hover = {
					"Русский",
					["zh"] = "Russian",
					["br"] = "Russian",
					["es"] = "Ruso",
					["ru"] = "Русский",
					["ko"] = "러시아어",
				},
			},
			["ko"] = {
				description = {
					"Korean",
					["zh"] = "韩国语",
					["br"] = "Korean",
					["es"] = "Coreano",
					["ru"] = "Корейский язык",
					["ko"] = "한국어",
				},
				hover = {
					"Korean",
					["zh"] = "韩国语",
					["br"] = "Korean",
					["es"] = "Coreano",
					["ru"] = "Корейский язык",
					["ko"] = "한국어",	
				},
			},
		},
	},
	info_style = {
		label = {
			"Display style", 
			["zh"] = "信息类型", 
			["br"] = "Estilo de exibição", 
			["es"] = "Estilo de información",
			["ru"] = "Стиль отображения",
			["ko"] = "표시 스타일",
		},
		hover = {
			"Whether you want to use icons or text.", 
			["zh"] = "选择图标模式还是文字模式。", 
			["br"] = "Se você deseja usar ícones ou texto.", 
			["es"] = "Configura el uso de texto o iconos en la información.",
			["ru"] = "Хотите использовать иконки или текст.",
			["ko"] = "아이콘을 사용할지 텍스트를 사용할지 선택하세요.",
		},
		options = {
			["text"] = {
				description = {
					"Text",
					["zh"] = "文字",
					["br"] = "Texto",
					["es"] = "Texto",
					["ru"] = "Текст",
					["ko"] = "텍스트",
				},
				hover = {
					"Text will be used",
					["zh"] = "显示纯文字",
					["br"] = "Texto será usado",
					["es"] = "Solo se utiliza texto.",
					["ru"] = "Будет использоваться текст.",
					["ko"] = "텍스트가 사용됩니다.",
				},
			},
			["icon"] = {
				description = {
					"Icon",
					["zh"] = "图标",
					["br"] = "Ícone",
					["es"] = "Iconos",
					["ru"] = "Иконка",
					["ko"] = "아이콘",
				},
				hover = {
					"Icons will be used over text where possible.",
					["zh"] = "显示图标替代文字",
					["br"] = "Os ícones são usados sobre o texto sempre que possível.",
					["es"] = "Se usan iconos cuando sea posible.",
					["ru"] = "Иконки будут использоваться вместо текста, где это возможно.",
					["ko"] = "아이콘이 텍스트를 대체할 수 있는 경우 아이콘이 사용됩니다.",
				},
			},
		},
	},
	text_coloring = {
		label = {
			"Text Coloring", 
			["zh"] = "文字着色", 
			["br"] = "Colorir Texto", 
			["es"] = "Coloreado de textos",
			["ru"] = "Окраска текста",
			["ko"] = "텍스트 색상",
		},
		hover = {
			"Whether text coloring is enabled.", 
			["zh"] = "是否启用文字着色。", 
			["br"] = "Se a coloração do texto está habilitada.", 
			["es"] = "Configura el uso de coloreado de texto.",
			["ru"] = "Включение окраски текста.",
			["ko"] = "텍스트 색상을 사용할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "사용 안함",
				},
				hover = {
					"Text coloring will not be used. :(",
					["zh"] = "禁用文字着色 :(",
					["br"] = "A coloração do texto não será usada.",
					["es"] = "No se utiliza el coloreado de texto. :(",
					["ru"] = "Окраска текста не будет использоваться. :(",
					["ko"] = "텍스트 색상이 사용되지 않습니다. :(",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "사용",
				},
				hover = {
					"Text coloring will be used.",
					["zh"] = "启用文字着色",
					["br"] = "A coloração do texto será usada.",
					["es"] = "Se utiliza el coloreado de texto.",
					["ru"] = "Окраска текста будет использоваться.",
					["ko"] = "텍스트 색상이 사용됩니다.",
				},
			},
		},
	},
	insight_font = {
		label = {
			"Font",
			["zh"] = "字体",
			["br"] = nil,
			["es"] = nil,
			["ru"] = "Шрифт",
			["ko"] = "글꼴",
		},
		hover = {
			"Which font Insight uses for its text",
			["zh"] = "使用哪种字体来显示 Insight 的文本",
			["br"] = nil,
			["es"] = nil,
			["ru"] = "Какой шрифт используется Insight для своего текста",
			["ko"] = "Insight가 텍스트에 사용할 글꼴을 선택합니다.",
		},
		options = GenerateOptionsFromList(false, FONTS, function(i,v) return {["en"]=("Insight will use the game font '%s'"):format(v)} end),
	},
	hoverer_insight_font_size = {
		label = {
			"Mouse Hover Text Size",
			["zh"] = "鼠标悬停文本大小", 
			["br"] = "Tamanho do Texto ao Passar o Mouse", 
			["es"] = nil,
			["ru"] = "Размер текста при наведении мыши",
			["ko"] = "마우스 텍스트 크기",
		},
		hover = {
			"The font size of Insight's hover text when using a mouse.",
			["zh"] = "使用鼠标悬停时 Insight 的文本字体大小。", 
			["br"] = "O tamanho da fonte do texto flutuante do Insight ao usar um mouse.", 
			["es"] = nil,
			["ru"] = "Размер шрифта текста при наведении мыши в Insight.",
			["ko"] = "마우스를 사용할 때 Insight의 텍스트 글꼴 크기를 설정합니다.",
		},
		options = GenerateFontSizeTexts(FONT_SIZE.INSIGHT.HOVERER),
	},
	inventorybar_insight_font_size = {
		label = {
			"Controller Inv. Text Size",
			["zh"] = "控制器物品栏文本大小", 
			["br"] = "Tamanho do Texto do Controlador do Inv. ", 
			["es"] = nil,
			["ru"] = "Размер текста инвентаря при использовании контроллера",
			["ko"] = "컨트롤러 인벤토리 텍스트 크기",
		},
		hover = {
			"The font size of Insight's inventory text when using a controller.",
			["zh"] = "使用控制器时 Insight 的物品栏文本字体大小。", 
			["br"] = "O tamanho da fonte do texto do inventário do Insight ao usar um controlador.", 
			["es"] = nil,
			["ru"] = "Размер шрифта текста инвентаря в Insight при использовании контроллера.",
			["ko"] = "컨트롤러를 사용할 때 Insight의 인벤토리 텍스트 글꼴 크기를 설정합니다.",
		},
		options = GenerateFontSizeTexts(FONT_SIZE.INSIGHT.INVENTORYBAR),
	},
	followtext_insight_font_size = {
		label = {
			"Controller Follow Text Size",
			["zh"] = "控制器跟随文本大小", 
			["br"] = "Tamanho do Texto do Controlador Seguidor", 
			["es"] = nil,
			["ru"] = "Размер текста при использовании контроллера для следования",
			["ko"] = "컨트롤러 Follow 텍스트 크기",		
		},
		hover = {
			"The font size of Insight's Follow text when using a controller.",
			["zh"] = "使用控制器时 Insight 的跟随文本字体大小。", 
			["br"] = "O tamanho da fonte do texto Seguir do Insight ao usar um controlador.", 
			["es"] = nil,
			["ru"] = "Размер шрифта текста следования в Insight при использовании контроллера.",
			["ko"] = "컨트롤러를 사용할 때 Insight의 Follow 텍스트 글꼴 크기를 설정합니다.",
		},
		options = GenerateFontSizeTexts(FONT_SIZE.INSIGHT.FOLLOWTEXT),
	},
	hoverer_line_truncation = {
		label = {
			"Hover Text Truncation",
			["zh"] = nil,
			["br"] = nil,
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		hover = {
			"Whether to truncate the information shown by Insight on hover. Hold Inspect to disable truncation.",
			["zh"] = nil,
			["br"] = nil,
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		options = GenerateOptionsFromList(false, HOVERER_TRUNCATION_AMOUNTS, function(i,v) 
			if v == HOVERER_TRUNCATION_AMOUNTS[1] then
				return {["en"]=("Text will not be truncated.")}
			else
				return {["en"]=("Text will be truncated at '%s' line(s)"):format(v)} 
			end
		end),
	},
	alt_only_information = {
		label = {
			"Inspect Only", 
			["zh"] = "仅在检查时显示", 
			["br"] = "Somente Inspecionar", 
			["es"] = "Solo inspeccionar",
			["ru"] = "Только при осмотре",
			["ko"] = "검사 중에만 정보 표시",
		},
		hover = {
			"Whether Insight will only show information when you hold Left Alt.", 
			["zh"] = "是否仅当按住 Alt 键时显示信息", 
			["br"] = "Se o Insight só mostrará informações quando você segurar Alt esquerdo.", 
			["es"] = "Insight sólo muestra información cuando mantengas pulsado Alt izq.",
			["ru"] = "Будет ли Insight показывать информацию только при удерживании левого Alt.",
			["ko"] = "왼쪽 Alt 키를 누르고 있을 때만 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Information is displayed normally.",
					["zh"] = "信息正常显示",
					["br"] = "As informações são exibidas normalmente.",
					["es"] = "La información se muestra normalmente.",
					["ru"] = "Информация отображается как обычно.",
					["ko"] = "정보가 평소대로 표시됩니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Information only displays on inspection.",
					["zh"] = "仅当按住 Alt 键时显示信息",
					["br"] = "As informações são exibidas apenas na inspeção.",
					["es"] = "Sólo se muestra en la inspección.",
					["ru"] = "Информация отображается только при осмотре.",
					["ko"] = "Alt 키를 누르고 있을 때만 정보가 표시됩니다.",
				},
			},
		},
	},
	itemtile_display = {
		label = {
			"Inv Slot Info", 
			["zh"] = "库存物品栏信息", 
			["br"] = "Informações do inventário", 
			["es"] = "Información de ranuras",
			["ru"] = "Информация в слоте инвентаря",
			["ko"] = "인벤토리 슬롯 정보",
		},
		hover = {
			"What kind of information shows instead of percentages on item slots.", 
			["zh"] = "物品栏信息显示的类型", 
			["br"] = "Que tipo de informação é exibida em vez de porcentagens nos slots de itens.", 
			["es"] = "Configura qué tipo de información se muestra en lugar de porcentajes en las ranuras de tu inventario.",
			["ru"] = "Какая информация отображается вместо процентов на слотах предметов.",
			["ko"] = "백분율을 대체하는 인벤토리 정보 유형을 선택하세요.",
		},
		options = {
			["none"] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Ninguno",
					["ru"] = "Нет",
					["ko"] = "없음",
				},
				hover = {
					"Will not provide ANY information on item slots.",
					["zh"] = "不显示任何信息",
					["br"] = "Não fornecerá NENHUMA informação sobre slots de itens.",
					["es"] = "No muestra ninguna información sobre las ranuras de inventario.",
					["ru"] = "Не будет отображать НИКАКУЮ информацию о слотах предметов.",
					["ko"] = "인벤토리 슬롯에 대한 정보를 표시하지 않습니다.",
				},
			},
			["numbers"] = {
				description = {
					"Numbers",
					["zh"] = "数字",
					["br"] = "Números",
					["es"] = "Números",
					["ru"] = "Цифры",
					["ko"] = "숫자",
				},
				hover = {
					"Will provide durability numbers on item slots.",
					["zh"] = "显示具体次数",
					["br"] = "Fornecerá números de durabilidade nos slots de itens.",
					["es"] = "Utiliza números de durabilidad en las ranuras de inventario.",
					["ru"] = "Будет отображать числа прочности на слотах предметов.",
					["ko"] = "인벤토리 슬롯에 내구도 수치가 표시됩니다.",
				},
			},
			["percentages"] = {
				description = {
					"Percentages",
					["zh"] = "百分比",
					["br"] = "Porcentagens",
					["es"] = "Porcentajes",
					["ru"] = "Проценты",
					["ko"] = "백분율",
				},
				hover = {
					"Will provide use default percentages on item slots.",
					["zh"] = "显示默认百分比",
					["br"] = "Fornecerá porcentagens padrão de uso em slots de itens.",
					["es"] = "Utiliza porcentajes por defecto en las ranuras de inventario.",
					["ru"] = "Будет использовать стандартные проценты на слотах предметов.",
					["ko"] = "인벤토리 슬롯에 표준 백분율을 사용합니다.",
				},
			},
			["mixed"] = {
				description = {
					"Mixed",
					["zh"] = "兼用",
					["br"] = "Misto",
					["es"] = "Mixto",
					["ru"] = "Смешанный",
					["ko"] = "혼합",
				},
				hover = {
					"Will provide use default percentages on refuelables, numbers for everything else.",
					["zh"] = "可恢复耐久的物品显示默认百分比, 其他显示具体次数",
					["br"] = "Fornecerá porcentagens padrão de uso em reabastecimentos, números para todo o resto.",
					["es"] = "Utiliza porcentajes por defecto en items recargables, números para todo lo demás.",
					["ru"] = "Будет использовать стандартные проценты на подкачиваемых предметах, числа для всего остального.",
					["ko"] = "연료/수리 아이템은 표준 백분율을 사용하고 그 밖의 모든 항목은 숫자를 사용합니다.",
				},
			},
		},
	},
	time_style = {
		label = {
			"Time style", 
			["zh"] = "时间样式", 
			["br"] = "Estilo de tempo", 
			["es"] = "Estilo del tiempo",
			["ru"] = "Стиль времени",
			["ko"] = "시간 스타일",
		},
		hover = {
			"How to display time information.", 
			["zh"] = "如何显示时间信息", 
			["br"] = "Como exibir informações de tempo.", 
			["es"] = "Configura como mostrar información de la hora.",
			["ru"] = "Как отображать информацию о времени.",
			["ko"] = "시간 정보를 어떻게 표시할지 선택합니다.",
		},
		options = {
			["gametime"] = {
				description = {
					"Game time",
					["zh"] = "游戏时间",
					["br"] = "Tempo do jogo",
					["es"] = "Tiempo de juego",
					["ru"] = "Внутриигровое время",
					["ko"] = "게임 시간",
				},
				hover = {
					"Displays time information based on game time: days, segments.",
					["zh"] = "以游戏内时间为基础显示时间信息：天数，时间小段",
					["br"] = "Exibe informações de tempo com base no tempo do jogo: dias, segmentos.",
					["es"] = "Muestra información del tiempo basada en el tiempo de juego: días, segmentos",
					["ru"] = "Отображает информацию о времени на основе внутриигрового времени: дни, сегменты.",
					["ko"] = "게임 내 시간을 기준으로 시간 정보 표시: 일, 세그먼트.",
				},
			},
			["realtime"] = {
				description = {
					"Real time",
					["zh"] = "现实时间",
					["br"] = "Tempo real",
					["es"] = "Tiempo real",
					["ru"] = "Реальное время",
					["ko"] = "실제 시간",
				},
				hover = {
					"Displays time information based on real time: hours, minutes, seconds.",
					["zh"] = "以现实时间为基础显示时间信息：时，分，秒",
					["br"] = "Exibe informações de tempo com base no tempo real: horas, minutos, segundos.",
					["es"] = "Muestra información del tiempo basada en el tiempo real: horas, minutos, segundos.",
					["ru"] = "Отображает информацию о времени на основе реального времени: часы, минуты, секунды.",
					["ko"] = "현실의 시간을 기준으로 시간 정보 표시: 시, 분, 초.",
				},
			},
			["both"] = {
				description = {
					"Both",
					["zh"] = "兼用两种模式",
					["br"] = "Ambos",
					["es"] = "Ambos",
					["ru"] = "Оба",
					["ko"] = "모두 사용",
				},
				hover = {
					"Use both time styles: days, segments (hours, minutes, seconds)",
					["zh"] = "使用两种显示形式：天，时间小段（时，分，秒）",
					["br"] = "Use ambos os estilos de tempo: dias, segmentos (horas, minutos, segundos)",
					["es"] = "Utiliza ambos estilos de tiempo: días, segmentos (horas, minutos, segundos)",
					["ru"] = "Использует оба стиля времени: дни, сегменты (часы, минуты, секунды).",
					["ko"] = "두 가지 시간 스타일을 모두 사용: 일, 세그먼트 (시, 분, 초).",
				},
			},
			["gametime_short"] = {
				description = {
					"Game time (Short)",
					["zh"] = "游戏时间（精简）",
					["br"] = "Tempo do jogo (Curto)",
					["es"] = "Tiempo de juego (corto)",
					["ru"] = "Внутриигровое время (Сокращенное)",
					["ko"] = "게임 시간 (축약)",
				},
				hover = {
					"Displays shortened time information based on game time.",
					["zh"] = "简化版的以游戏内时间为基础显示时间信息",
					["br"] = "Exibe informações de tempo reduzido com base no tempo do jogo.",
					["es"] = "Muestra información de tiempo reducido basado en el tiempo de juego",
					["ru"] = "Отображает сокращенную информацию о времени на основе внутриигрового времени.",
					["ko"] = "게임 내 시간을 기준으로 축약된 시간 정보 표시: x.y일.",
				},
			},
			["realtime_short"] = {
				description = {
					"Real time (Short)",
					["zh"] = "现实时间（精简）",
					["br"] = "Tempo real (Curto)",
					["es"] = "Tiempo real (corto)",
					["ru"] = "Реальное время (Сокращенное)",
					["ko"] = "실제 시간 (축약)",
				},
				hover = {
					"Displays shortened time information based on real time: hours:minutes:seconds.",
					["zh"] = "简化版的以现实时间为基础显示时间信息",
					["br"] = "Exibe informações de tempo reduzido com base no tempo real: horas:minutos:segundos.",
					["es"] = "Muestra información de tiempo reducido basada en el tiempo real: horas:minutos:segundos.",
					["ru"] = "Отображает сокращенную информацию о времени на основе реального времени: часы:минуты:секунды.",
					["ko"] = "현실의 시간을 기준으로 축약된 시간 정보 표시: 시:분:초.",
				},
			},
			["both_short"] = {
				description = {
					"Both (Short)",
					["zh"] = "兼用两种模式（精简）",
					["br"] = "Ambos (Curto)",
					["es"] = "Both (Short)",
					["ru"] = "Оба (Сокращенное)",
					["ko"] = "모두 사용 (축약)",
				},
				hover = {
					"Use both time styles and shorten: x.y days (hours:minutes:seconds).",
					["zh"] = "简化版的双模式显示",
					["br"] = "Use ambos os estilos de tempo e abrevie: x.y dias (horas:minutos:segundos).",
					["es"] = "Utiliza ambos estilos reducidos: x.y días (horas:minutos:segundos).",
					["ru"] = "Использует оба стиля времени и сокращает: x.y дней (часы:минуты:секунды).",
					["ko"] = "두 가지 시간 스타일을 모두 사용: x.y일 (시:분:초).",
				},
			},
		},
	},
	temperature_units = {
		label = {
			"Temperature units", 
			["zh"] = "温度单位", 
			["br"] = "Unidades de temperatura", 
			["es"] = nil,
			["ru"] = "Единицы температуры",
			["ko"] = "온도 단위",
		},
		hover = {
			"How to display temperature", 
			["zh"] = "如何显示温度", 
			["br"] = "Como exibir a temperatura", 
			["es"] = nil,
			["ru"] = "Как отображать температуру",
			["ko"] = "온도를 표시하는 방법을 선택합니다.",
		},
		options = {
			["game"] = {
				description = {
					"Game",
					["zh"] = "游戏温度",
					["br"] = "Jogo",
					["es"] = nil,
					["ru"] = "Игровая",
					["ko"] = "게임 온도",
				},
				hover = {
					"Freeze: 0, Overheat: 70",
					["zh"] = "结冰: 0, 过热: 70",
					["br"] = "Congelar: 0º, Superaquecer: 70º",
					["es"] = nil,
					["ru"] = "Замерзание: 0, Перегрев: 70",
					["ko"] = "동결: 0, 과열: 70",
				},
			},
			["celsius"] = {
				description = {
					"Celsius",
					["zh"] = "摄氏度",
					["br"] = "Celsius",
					["es"] = nil,
					["ru"] = "Цельсий",
					["ko"] = "섭씨",
				},
				hover = {
					"Freeze: 0, Overheat: 35",
					["zh"] = "结冰: 0, 过热: 35",
					["br"] = "Congelar: 0º, Superaquecer: 35º",
					["es"] = nil,
					["ru"] = "Замерзание: 0, Перегрев: 35",
					["ko"] = "동결: 0, 과열: 35",
				},
			},
			["fahrenheit"] = {
				description = {
					"Fahrenheit",
					["zh"] = "华氏度",
					["br"] = "Fahrenheit",
					["es"] = nil,
					["ru"] = "Фаренгейт",
					["ko"] = "화씨",
				},
				hover = {
					"Freeze: 32, Overheat: 158",
					["zh"] = "结冰: 32, 过热: 158",
					["br"] = "Congelar: 32 F, Superaquecer: 158 F",
					["es"] = nil,
					["ru"] = "Замерзание: 32, Перегрев: 158",
					["ko"] = "동결: 32, 과열: 158",
				},
			},
		},
	},
	highlighting = {
		label = {
			"Highlighting", 
			["zh"] = "高亮显示", 
			["br"] = "Destacar item", 
			["es"] = "Resaltado",
			["ru"] = "Выделение",
			["ko"] = "강조 표시",
		},
		hover = {
			"Whether item highlighting is enabled. (\"Finder\")", 
			["zh"] = "是否启用箱子/物品的高亮显示 (\"物品查找器\")", 
			["br"] = "Se o destaque do item está ativado. (\"Finder\")", 
			["es"] = "Configura si se activa el resaltado de objetos. (\"Buscador\")",
			["ru"] = "Включено ли выделение предметов. (\"Поиск\")",
			["ko"] = "아이템 강조 표시를 사용할지 선택합니다. (Finder 모드 기능)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"No chest/item highlighting.",
					["zh"] = "箱子/物品不会高亮显示",
					["br"] = "Nenhum báu/item será destacado.",
					["es"] = "No se resaltarán objetos.",
					["ru"] = "Выделение предметов отключено.",
					["ko"] = "상자/아이템이 강조 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Chests/items will be highlighted.",
					["zh"] = "箱子/物品会高亮显示",
					["br"] = "Baús/itens são destacados.",
					["es"] = "Los cofres y objetos se resaltarán.",
					["ru"] = "Выделение предметов включено.",
					["ko"] = "상자/아이템이 강조 표시됩니다.",
				},
			},
		},
	},
	experimental_highlighting = {
		label = {
			"Experimental Highlighting", 
			["zh"] = "实验性高亮显示",
			["br"] = "Realce Experimental",
			["es"] = nil,
			["ru"] = "Экспериментальное выделение",
			["ko"] = "실험적 강조 표시",
		},
		hover = {
			"When enabled, highlighting will perform better in very dense areas at the cost of being potentially unstable. Please let me know if you get issues with this.", 
			["zh"] = "如果启用，高亮显示将在非常密集的区域表现更好，但可能存在不稳定性。如果有任何问题请告知。",
			["br"] = "Quando ativado, o realce terá um desempenho melhor em áreas muito densas, ao custo de ser potencialmente instável. Por favor, deixe-me saber se você tiver problemas com isso.",
			["es"] = nil,
			["ru"] = "При включении экспериментального выделения выделение будет работать лучше в очень плотных областях за счет возможной нестабильности. Пожалуйста, сообщите мне, если у вас возникнут проблемы с этим.",
			["ko"] = "활성화되면 매우 조밀한 영역에서 강조 표시가 더 잘 작동되지만 불안정할 수 있습니다. 이와 관련하여 문제가 발생하면 알려주세요.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Normal highlighting will be used.",
					["zh"] = "使用正常高亮显示。",
					["br"] = "O realce normal será usado.",
					["es"] = nil,
					["ru"] = "Будет использоваться обычное выделение.",
					["ko"] = "일반 강조 표시 기능이 사용됩니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Experimental highlighting will be used.",
					["zh"] = "使用实验性高亮显示。",
					["br"] = "Destaque experimental será usado.",
					["es"] = nil,
					["ru"] = "Будет использоваться экспериментальное выделение.",
					["ko"] = "실험적 강조 표시 기능이 사용됩니다.",
				},
			},
		},
	},
	highlighting_darkness = {
		label = {
			"Highlighting in Darkness", 
			["zh"] = "高亮黑暗中的物品",
			["br"] = nil,
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		hover = {
			"When disabled, items in darkness will not receive a highlighting glow.", 
			["zh"] = "如果关闭，黑暗中的物品不会被高亮标出",
			["br"] = nil,
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Items in darkness do not get highlighting.",
					["zh"] = "黑暗中不使用高亮显示。",
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Items in darkness do get highlighting.",
					["zh"] = "黑暗中使用高亮显示。",
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
		},
	},
	highlighting_color = {
		label = {
			"Highlighting Color", 
			["zh"] = "高亮颜色", 
			["br"] = "Cor de realce", 
			["es"] = "Color de resaltado",
			["ru"] = "Цвет выделения",
			["ko"] = "강조 색상",
		},
		hover = {
			"The color to use for highlighting.", 
			["zh"] = "高亮显示时的颜色。", 
			["br"] = "A cor a ser usada para destacar.", 
			["es"] = "Configura el color a utilizar para resaltar.",
			["ru"] = "Цвет, используемый для выделения.",
			["ko"] = "강조 표시에 사용될 색상입니다.",
		},
		options = {
			["RED"] = {
				description = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
					["ru"] = "Красный",
					["ko"] = "빨강",
				},
				hover = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
					["ru"] = "Красный",
					["ko"] = "빨강",
				},
			},
			["GREEN"] = {
				description = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
					["ru"] = "Зеленый",
					["ko"] = "초록",
				},
				hover = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
					["ru"] = "Зеленый",
					["ko"] = "초록",
				},
			},
			["BLUE"] = {
				description = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
					["ru"] = "Синий",
					["ko"] = "파랑",
				},
				hover = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
					["ru"] = "Синий",
					["ko"] = "파랑",
				},
			},
			["LIGHT_BLUE"] = {
				description = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
					["ru"] = "Голубой",
					["ko"] = "하늘",
				},
				hover = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
					["ru"] = "Голубой",
					["ko"] = "하늘",
				},
			},
			["PURPLE"] = {
				description = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
					["ru"] = "Фиолетовый",
					["ko"] = "보라",
				},
				hover = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
					["ru"] = "Фиолетовый",
					["ko"] = "보라",
				},
			},
			["YELLOW"] = {
				description = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelo",
					["es"] = "Amarillo",
					["ru"] = "Желтый",
					["ko"] = "노랑",
				},
				hover = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelp",
					["es"] = "Amarillo",
					["ru"] = "Желтый",
					["ko"] = "노랑",
				},
			},
			["WHITE"] = {
				description = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
					["ru"] = "Белый",
					["ko"] = "하양",
				},
				hover = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
					["ru"] = "Белый",
					["ko"] = "하양",
				},
			},
			["ORANGE"] = {
				description = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
					["ru"] = "Оранжевый",
					["ko"] = "주황",
				},
				hover = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
					["ru"] = "Оранжевый",
					["ko"] = "주황",
				},
			},
			["PINK"] = {
				description = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
					["ru"] = "Розовый",
					["ko"] = "분홍",
				},
				hover = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
					["ru"] = "Розовый",
					["ko"] = "분홍",
				},
			},
		},
	},
	fuel_highlighting = {
		label = {
			"Fuel Highlighting", 
			["zh"] = "燃料高亮显示", 
			["br"] = "Realce de Combustível", 
			["es"] = "Resaltado del combustible",
			["ru"] = "Выделение топлива",
			["ko"] = "연료 강조 표시",
		},
		hover = {
			"Whether fuel highlighting is enabled.", 
			["zh"] = "是否开启燃料高亮显示", 
			["br"] = "Se o realce de combustível está ativado.", 
			["es"] = "Configura el resaltado del combustible.",
			["ru"] = "Включено ли выделение топлива.",
			["ko"] = "연료 강조 표시를 사용할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Fuel entities will not be highlighted.",
					["zh"] = "禁用燃料高亮显示",
					["br"] = "Entidades de combustível não são destacadas.",
					["es"] = "No se resaltan objetos de combustible.",
					["ru"] = "Объекты топлива не будут выделены.",
					["ko"] = "연료 강조 표시를 사용하지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Fuel entities will be highlighted.",
					["zh"] = "启用燃料高亮显示",
					["br"] = "Entidades de combustível são destacadas.",
					["es"] = "Los objetos de combustible serán resaltadas.",
					["ru"] = "Объекты топлива будут выделены.",
					["ko"] = "연료 강조 표시가 사용됩니다.",
				},
			},
		},
	},
	fuel_highlighting_color = {
		label = {
			"Fuel Highlighting Color", 
			["zh"] = "燃料高亮颜色", 
			["br"] = "Cor de Destaque de Combustível", 
			["es"] = "Color de resaltado del combustible",
			["ru"] = "Цвет выделения топлива",
			["ko"] = "연료 강조 표시 색상",
		},
		hover = {
			"The color to use for fuel highlighting.", 
			["zh"] = "燃料高亮显示时的颜色", 
			["br"] = "A cor a ser usada para realce de combustível.", 
			["es"] = "Configura el color a utilizar para resaltar el combustible.",
			["ru"] = "Цвет, используемый для выделения топлива.",
			["ko"] = "연료 강조 표시에 사용될 색상입니다.",
		},
		options = {
			["RED"] = {
				description = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
					["ru"] = "Красный",
					["ko"] = "빨강",
				},
				hover = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
					["ru"] = "Красный",
					["ko"] = "빨강",
				},
			},
			["GREEN"] = {
				description = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
					["ru"] = "Зеленый",
					["ko"] = "초록",
				},
				hover = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
					["ru"] = "Зеленый",
					["ko"] = "초록",
				},
			},
			["BLUE"] = {
				description = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
					["ru"] = "Синий",
					["ko"] = "파랑",
				},
				hover = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
					["ru"] = "Синий",
					["ko"] = "파랑",
				},
			},
			["LIGHT_BLUE"] = {
				description = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
					["ru"] = "Голубой",
					["ko"] = "하늘",
				},
				hover = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
					["ru"] = "Голубой",
					["ko"] = "하늘",
				},
			},
			["PURPLE"] = {
				description = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
					["ru"] = "Фиолетовый",
					["ko"] = "보라",
				},
				hover = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
					["ru"] = "Фиолетовый",
					["ko"] = "보라",
				},
			},
			["YELLOW"] = {
				description = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelo",
					["es"] = "Amarillo",
					["ru"] = "Желтый",
					["ko"] = "노랑",
				},
				hover = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelo",
					["es"] = "Amarillo",
					["ru"] = "Желтый",
					["ko"] = "노랑",
				},
			},
			["WHITE"] = {
				description = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
					["ru"] = "Белый",
					["ko"] = "하양",
				},
				hover = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
					["ru"] = "Белый",
					["ko"] = "하양",
				},
			},
			["ORANGE"] = {
				description = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
					["ru"] = "Оранжевый",
					["ko"] = "주황",
				},
				hover = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
					["ru"] = "Оранжевый",
					["ko"] = "주황",
				},
			},
			["PINK"] = {
				description = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
					["ru"] = "Розовый",
					["ko"] = "분홍",
				},
				hover = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
					["ru"] = "Розовый",
					["ko"] = "분홍",
				},
			},
		},
	},
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Indicators ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	display_attack_range = {
		label = {
			"Attack Ranges", 
			["zh"] = "攻击范围", 
			["br"] = "Alcance de Ataque", 
			["es"] = "Rango de ataque",
			["ru"] = "Диапазоны атаки",
			["ko"] = "공격 범위",
		},
		hover = {
			"Whether attack ranges are shown.", 
			["zh"] = "是否显示攻击范围", 
			["br"] = "Se os alcances de ataque são mostrados.", 
			["es"] = "Configura si se muestra los rangos de ataque.",
			["ru"] = "Показывать ли диапазоны атаки",
			["ko"] = "공격 범위를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Attack ranges are not shown.",
					["zh"] = "不显示攻击范围",
					["br"] = "Os alcances de ataque não são mostrados.",
					["es"] = "No se muestra los rangos de ataque.",
					["ru"] = "Диапазоны атаки не показываются",
					["ko"] = "공격 범위가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Attack ranges are shown.",
					["zh"] = "显示攻击范围",
					["br"] = "Os alcances de ataque são mostrados.",
					["es"] = "Se muestra los rangos de ataque.",
					["ru"] = "Диапазоны атаки показываются",
					["ko"] = "공격 범위가 표시됩니다.",
				},
			},
		},
	},
	attack_range_type = {
		label = {
			"Attack Range Type", 
			["zh"] = "攻击范围类型", 
			["br"] = "Tipo de Alcance de Ataque", 
			["es"] = "Tipo de rango de ataque",
			["ru"] = "Тип диапазона атаки",
			["ko"] = "공격 범위 유형",
		},
		hover = {
			"Type of attack range to be displayed.", 
			["zh"] = "显示攻击范围的类型", 
			["br"] = "Tipo de alcance de ataque a ser exibido.", 
			["es"] = "Tipo de rango de ataque a mostrar.",
			["ru"] = "Тип отображаемого диапазона атаки",
			["ko"] = "표시할 공격 범위 유형을 선택합니다.",
		},
		options = {
			["hit"] = {
				description = {
					"Hit",
					["zh"] = "敲击",
					["br"] = "Acerto",
					["es"] = "Golpe",
					["ru"] = "Попадание",
					["ko"] = "타격",
				},
				hover = {
					"Hit range is shown.",
					["zh"] = "显示敲击范围",
					["br"] = "Alcance de acertos é mostrado.",
					["es"] = "Se muestra el rango de golpe.",
					["ru"] = "Показывается диапазон попадания",
					["ko"] = "개체가 대상을 공격하기 위한 인식 범위를 표시합니다.",
				},
			},
			["attack"] = {
				description = {
					"Attack",
					["zh"] = "攻击",
					["br"] = "Ataque",
					["es"] = "Ataque",
					["ru"] = "Атака",
					["ko"] = "공격",
				},
				hover = {
					"Attack range is shown.",
					["zh"] = "显示攻击范围",
					["br"] = "Alcance de ataque é mostrado.",
					["es"] = "Se muestra el rango de ataque.",
					["ru"] = "Показывается диапазон атаки",
					["ko"] = "개체가 대상을 공격했을 때 공격의 피해 범위를 표시합니다.",
				},
			},
			["both"] = {
				description = {
					"Both",
					["zh"] = "兼用",
					["br"] = "Ambos",
					["es"] = "Ambos",
					["ru"] = "Оба",
					["ko"] = "모두 표시",
				},
				hover = {
					"Both hit and attack range are shown.",
					["zh"] = "同时显示敲击和攻击范围",
					["br"] = "Tanto o alcance de acerto quanto o de ataque são mostrados.",
					["es"] = "Se muestra tanto el rango de golpe como el de ataque.",
					["ru"] = "Показываются диапазоны попадания и атаки",
					["ko"] = "타격 범위와 공격 범위 모두 표시합니다.",
				},
			},
		},
	},
	hover_range_indicator = {
		label = {
			"Item Range Hover", 
			["zh"] = "物品范围", 
			["br"] = "Passar o mouse para mostrar alcance", 
			["es"] = "Rango de objeto",
			["ru"] = "Диапазон предмета при наведении",
			["ko"] = "아이템 유효 범위 표시",
		},
		hover = {
			"Whether an item's range is shown upon hovering.", 
			["zh"] = "是否显示鼠标悬停物品的生效范围。", 
			["br"] = "Se o alcance de um item é mostrado ao passar o mouse sobre ele.", 
			["es"] = "Configura si el rango de un objeto se muestra al pasar el ratón por encima.",
			["ru"] = "Показывать ли диапазон предмета при наведении.",
			["ko"] = "마우스를 개체 위에 올렸을 때 개체의 유효 범위를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Range is not shown.",
					["zh"] = "不显示物品范围。",
					["br"] = "Alcance não é mostrado.",
					["es"] = "No se muestra el rango.",
					["ru"] = "Диапазон не показывается.",
					["ko"] = "범위를 표시하지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Range is shown.",
					["zh"] = "显示物品范围。",
					["br"] = "Alcance é mostrado.",
					["es"] = "Se muestra el rango.",
					["ru"] = "Диапазон показывается.",
					["ko"] = "범위를 표시합니다.",
				},
			},
		},
	},
	boss_indicator = {
		label = {
			"Boss Indicators", 
			["zh"] = "Boss 指示器", 
			["br"] = "Indicador de Chefões", 
			["es"] = "Indicador de jefes",
			["ru"] = "Индикаторы боссов",
			["ko"] = "보스 인디케이터",
		},
		hover = {
			"Whether boss indicators are shown.", 
			["zh"] = "是否显示 Boss 指示器。", 
			["br"] = "Se os indicadores do chefe são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de jefes.",
			["ru"] = "Показывать ли индикаторы боссов.",
			["ko"] = "보스의 위치/방향을 알려주는 인디케이터를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Boss indicators not shown.",
					["zh"] = "不显示 Boss 指示器。",
					["br"] = "Indicadores de chefões não são mostrados.",
					["es"] = "No se muestra los indicadores de jefes.",
					["ru"] = "Индикаторы боссов не показываются.",
					["ko"] = "보스 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Boss indicators are shown.",
					["zh"] = "显示 Boss 指示器。",
					["br"] = "Indicadores de chefões são mostrados.",
					["es"] = "Se muestra los indicadores del jefes.",
					["ru"] = "Индикаторы боссов показываются.",
					["ko"] = "보스 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	miniboss_indicator = {
		label = {
			"Miniboss Indicators", 
			["zh"] = "小 Boss 指示器", 
			["br"] = "Indicadores de Mini-Chefões", 
			["es"] = nil,
			["ru"] = "Индикаторы минибоссов",
			["ko"] = "미니 보스 인디케이터",
		},
		hover = {
			"Whether miniboss indicators are shown.", 
			["zh"] = "是否显示小 Boss 指示器。", 
			["br"] = "Se os indicadores de Mini-Chefões são mostrados.", 
			["es"] = nil,
			["ru"] = "Показывать ли индикаторы минибоссов боссов.",
			["ko"] = "미니 보스의 위치/방향을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Miniboss indicators not shown.",
					["zh"] = "不显示小 Boss 指示器。", 
					["br"] = "Indicadores de Mini-Chefões não aparecem.", 
					["es"] = nil,
					["ru"] = "Индикаторы минибоссов не показываются.",
					["ko"] = "미니 보스 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Miniboss indicators are shown.",
					["zh"] = "显示小 Boss 指示器。", 
					["br"] = "Indicadores de Mini-Chefões são mostrados.", 
					["es"] = nil,
					["ru"] = "Индикаторы минибоссов показываются.",
					["ko"] = "미니 보스 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	notable_indicator = {
		label = {
			"Notable Indicators", 
			["zh"] = "其他物品指示器", 
			["br"] = "Indicador Notável", 
			["es"] = "Indicador notable",
			["ru"] = "Выдающиеся индикаторы",
			["ko"] = "중요 개체 인디케이터",
		},
		hover = {
			"Whether the notable (chester, hutch, etc) indicators are shown.", 
			["zh"] = "是否显示其他物品（切斯特，哈奇等等）的指示器", 
			["br"] = "Se os indicadores notáveis (chester, hutch, etc) são mostrados.", 
			["es"] = "Configura si se muestra los indicadores notables (Chester, Hutch, etc.)",
			["ru"] = "Показывать ли выдающиеся индикаторы (честер, хатч и т. д.)",
			["ko"] = "중요 개체 인디케이터를 표시할지 선택합니다. (체스터, 허치, etc)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Notable indicators not shown.",
					["zh"] = "不显示指示器。",
					["br"] = "Indicadores notáveis não são mostrados.",
					["es"] = "No se muestra los indicadores notables.",
					["ru"] = "Выдающиеся индикаторы не показываются.",
					["ko"] = "중요 개체 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Notable indicators are shown.",
					["zh"] = "显示指示器。",
					["br"] = "Indicadores notáveis são mostrados.",
					["es"] = "Se muestra los indicadores notables.",
					["ru"] = "Выдающиеся индикаторы показываются.",
					["ko"] = "중요 개체 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	pipspook_indicator = {
		label = {
			"Pipspook toy indicators", 
			["zh"] = "小惊吓玩具指示器", 
			["br"] = "Indicadores de brinquedos Pipspook", 
			["es"] = "Indicadores de juguetes Pipspook",
			["ru"] = "Индикаторы игрушек пищащего призрака",
			["ko"] = "핍스푹 장난감 인디케이터",
		},
		hover = {
			"Whether pipspook toy indicators are shown.", 
			["zh"] = "是否显示小惊吓玩具的指示器。", 
			["br"] = "Se os indicadores de brinquedo pipspook são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de juguetes Pipspook.",
			["ru"] = "Показывать ли индикаторы игрушек пищащего призрака.",
			["ko"] = "핍스푹 장난감 인디케이터를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Pipspook toy indicators not shown.",
					["zh"] = "不显示小惊吓玩具指示器。",
					["br"] = "Indicadores de brinquedos Pipspook não são mostrados.",
					["es"] = "No se muestra los indicadores de juguetes Pipspook.",
					["ru"] = "Индикаторы игрушек пищащего призрака не показываются.",
					["ko"] = "핍스푹 장난감 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Pipspook toy indicators are shown.",
					["zh"] = "显示小惊吓玩具指示器。",
					["br"] = "Indicadores de brinquedos Pipspook são mostrados.",
					["es"] = "Se muestra los indicadores de juguetes Pipspook.",
					["ru"] = "Индикаторы игрушек пищащего призрака показываются.",
					["ko"] = "핍스푹 장난감 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	bottle_indicator = {
		label = {
			"Bottle Indicator", 
			["zh"] = "漂流瓶指示器", 
			["br"] = "Indicadores de Garrafa", 
			["es"] = "Indicador de botella",
			["ru"] = "Индикаторы бутылок",
			["ko"] = "유리병 인디케이터 ",
		},
		hover = {
			"Whether message bottle indicators are shown.", 
			["zh"] = "是否显示漂流瓶指示器。", 
			["br"] = "Se os indicadores de garrafa de mensagem são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de botellas de mensajes.",
			["ru"] = "Показывать ли индикаторы бутылок.",
			["ko"] = "메세지가 담긴 유리병의 인디케이터를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Message bottle indicators not shown.",
					["zh"] = "不显示漂流瓶指示器。",
					["br"] = "Indicadores de garrafas não são mostrados.",
					["es"] = "No se muestra los indicadores de mensajes.",
					["ru"] = "Индикаторы бутылок не показываются.",
					["ko"] = "메세지가 담긴 유리병의 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Message bottle indicators are shown.",
					["zh"] = "显示漂流瓶指示器。",
					["br"] = "Indicadores de garrafas são mostrados.",
					["es"] = "Se muestra los indicadores de mensajes.",
					["ru"] = "Индикаторы бутылок показываются.",
					["ko"] = "메세지가 담긴 유리병의 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	suspicious_marble_indicator = {
		label = {
			"Suspicious Marble Indicator", 
			["zh"] = "可疑的大理石指示器", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Индикаторы подозрительного мрамора",
			["ko"] = "수상한 대리석 인디케이터",
		},
		hover = {
			"Whether indicators to pieces of suspicious marble are shown.", 
			["zh"] = "是否显示可疑的大理石指示器", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Показывать ли индикаторы кусков подозрительного мрамора",
			["ko"] = "수상한 대리석 인디케이터를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Marble indicators are not shown.",
					["zh"] = "不显示可疑的大理石指示器",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Индикаторы мрамора не показываются",
					["ko"] = "수상한 대리석 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Marble indicators are shown.",
					["zh"] = "显示可疑的大理石指示器",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Индикаторы мрамора показываются",
					["ko"] = "수상한 대리석 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	death_indicator = {
		label = {
			"Death Indicators", 
			["zh"] = "死亡指示器", 
			["br"] = "Indicadores de Morte", 
			["es"] = nil,
			["ru"] = "Индикаторы смерти",
			["ko"] = "사망 인디케이터",
		},
		hover = {
			"Whether to show an indicator to your death locations.", 
			["zh"] = "是否显示指示你死亡地点的指示器。", 
			["br"] = "Se deve mostrar um indicador para seus locais de morte.", 
			["es"] = nil,
			["ru"] = "Показывать ли индикаторы мест смерти.",
			["ko"] = "죽은 위치에 대한 인디케이터를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Indicator will not be shown.",
					["zh"] = "不显示指示器。",
					["br"] = "Indicadores não são exibidos.",
					["es"] = nil,
					["ru"] = "Индикаторы не показываются.",
					["ko"] = "사망 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Indicator will be shown.",
					["zh"] = "显示指示器。",
					["br"] = "Indicadores são exibidos.",
					["es"] = nil,
					["ru"] = "Индикаторы показываются.",
					["ko"] = "사망 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	hunt_indicator = {
		label = {
			"Hunt Indicator", 
			["zh"] = "动物脚印指示器", 
			["br"] = "Indicadores de Caça", 
			["es"] = "Indicador de caza",
			["ru"] = "Индикаторы охоты",
			["ko"] = "사냥 인디케이터",
		},
		hover = {
			"Whether hunt indicators are shown.", 
			["zh"] = "是否显示脚印指示器。", 
			["br"] = "Se os indicadores de caça (rastros, pegadas) são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de caza.",
			["ru"] = "Показывать ли индикаторы охоты.",
			["ko"] = "수상한 흙더미(발자국)에 대한 인디케이터를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Hunt indicators not shown.",
					["zh"] = "不显示脚印指示器。",
					["br"] = "Indicadores de caça não são mostrados.",
					["es"] = "No se muestra los indicadores de caza.",
					["ru"] = "Индикаторы охоты не показываются.",
					["ko"] = "사냥 인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Hunt indicators are shown.",
					["zh"] = "显示脚印指示器。",
					["br"] = "Indicadores de caça são mostrados.",
					["es"] = "Se muestra los indicadores de caza.",
					["ru"] = "Индикаторы охоты показываются.",
					["ko"] = "사냥 인디케이터가 표시됩니다.",
				},
			},
		},
	},
	orchestrina_indicator = {
		label = {
			"Archive Puzzle Helper", 
			["zh"] = "远古迷宫", 
			["br"] = "Ajudante de Quebra-Cabeça dos Arquivos", 
			["es"] = "Ayuda en puzle de Archivos",
			["ru"] = "Помощник в головоломке Архива",
			["ko"] = "고대 기록 보관소 퍼즐 도우미",
		},
		hover = {
			"Whether the solution to the puzzle is displayed or not.", 
			["zh"] = "是否显示远古迷宫的答案。", 
			["br"] = "Se a solução do quebra-cabeça (Archive Puzzle) é exibida ou não.", 
			["es"] = "Configura si la solución del puzle se muestra.",
			["ru"] = "Показывать ли решение головоломки или нет.",
			["ko"] = "퍼즐의 답을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The solution is not displayed.",
					["zh"] = "不显示答案。",
					["br"] = "A solução não é exibida.",
					["es"] = "No se muestra la solución.",
					["ru"] = "Решение не показывается.",
					["ko"] = "퍼즐의 답이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The solution is displayed.",
					["zh"] = "显示答案。",
					["br"] = "A solução é exibida..",
					["es"] = "Se muestra la solución.",
					["ru"] = "Решение показывается.",
					["ko"] = "퍼즐의 답이 표시됩니다.",
				},
			},
		},
	},
	tumbleweed_info = {
		label = {
			"Tumbleweed indicator", 
			["zh"] = "风滚草指示器", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Индикатор перекати-поле",
			["ko"] = "특별한 회전초 강조 표시",
		},
		hover = {
			"Whether tumbleweeds are color-coded to indicate their contents.", 
			["zh"] = "是否高亮着色拥有特殊物品的风滚草", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Цветовая кодировка перекати-поле для обозначения их содержимого",
			["ko"] = "특별한 아이템을 가진 회전초에 색상을 입혀 강조 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Tumbleweed information is not shown.",
					["zh"] = "不显示风滚草指示器",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о перекати-поле не показывается",
					["ko"] = "특별한 회전초를 강조 표시하지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Tumbleweed information is shown.",
					["zh"] = "显示风滚草指示器",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о перекати-поле показывается",
					["ko"] = "특별한 회전초를 강조 표시합니다.",
				},
			},
		},
	},
	lightningrod_range = {
		label = {
			"Lightningrod range", 
			["zh"] = "避雷针范围", 
			["br"] = "Alcance do para-raios", 
			["es"] = "Rango del pararrayos",
			["ru"] = "Диапазон молниеотвода",
			["ko"] = "피뢰침 범위 표시",
		},
		hover = {
			"How lightningrod range is displayed.", 
			["zh"] = "避雷针生效范围的显示方式。", 
			["br"] = "Como o alcance do para-raios é exibido.", 
			["es"] = "Configura como se muestra el alcance del pararrayos.",
			["ru"] = "Как отображается диапазон молниеотвода.",
			["ko"] = "피뢰침 범위를 언제 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Do not show lightning rod range.",
					["zh"] = "不显示避雷针的生效范围。",
					["br"] = "Não mostra o alcance do para-raios.",
					["es"] = "No mostrar el alcance del pararrayos.",
					["ru"] = "Не показывать диапазон молниеотвода.",
					["ko"] = "피뢰침 범위가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Strategic",
					["zh"] = "策略性地显示",
					["br"] = "Estratégico",
					["es"] = "Estratégico",
					["ru"] = "Стратегически",
					["ko"] = "전략적",
				},
				hover = {
					"Only show during placements / pitchforking (just like a flingo).",
					["zh"] = "只在放置避雷针时、使用草叉时、种植时显示生效范围。",
					["br"] = "Mostrar apenas durante as colocações / pitchforking (como uma flingo).",
					["es"] = "Mostrar sólo al construir estructuras.",
					["ru"] = "Показывать только во время размещения / использования вилы (как флинго).",
					["ko"] = "갈퀴를 사용하거나 구조물 배치 시에만 범위가 표시됩니다.(얼음 분사기와 마찬가지)",
				},
			},
			[2] = {
				description = {
					"Always",
					["zh"] = "总是",
					["br"] = "Sempre",
					["es"] = "Siempre",
					["ru"] = "Всегда",
					["ko"] = "항상",
				},
				hover = {
					"Always show lightning rod range.",
					["zh"] = "总是显示避雷针的生效范围。",
					["br"] = "Sempre mostrar o alcance do para-raios.",
					["es"] = "Mostrar siempre el alcance del pararrayos.",
					["ru"] = "Всегда показывать диапазон молниеотвода.",
					["ko"] = "항상 피뢰침 범위가 표시됩니다.",
				},
			},
		},
	},
	blink_range = {
		label = {
			"Blink range", 
			["zh"] = "瞬移范围", 
			["br"] = "Intervalo de piscar", 
			["es"] = "Rango de teletransporte",
			["ru"] = "Диапазон телепортации",
			["ko"] = "순간 도약 범위 표시",
		},
		hover = {
			"Whether you can see your blink range.", 
			["zh"] = "是否显示你的瞬移的范围，如灵魂跳跃，橙色法杖等。", 
			["br"] = "Se você pode ver seu intervalo de piscar.", 
			["es"] = "Configura si se muestra el rango de teletransporte (Explorador Perezoso, almas de Wortox).",
			["ru"] = "Показывать ли диапазон телепортации.",
			["ko"] = "순간 도약 범위를 표시할지 선택합니다.(게으른 탐험가, 워톡스의 영혼 도약, etc)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Blink range not shown.",
					["zh"] = "不显示瞬移范围。",
					["br"] = "Intervalo de piscar não é mostrado.",
					["es"] = "No se muestra el rango de teletransporte.",
					["ru"] = "Диапазон телепортации не показывается.",
					["ko"] = "순간 도약 범위가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Blink range shown.",
					["zh"] = "显示瞬移范围。",
					["br"] = "Intervalo de piscar é mostrado.",
					["es"] = "Se muestra el rango de teletransporte.",
					["ru"] = "Диапазон телепортации показывается.",
					["ko"] = "순간 도약 범위가 표시됩니다.",
				},
			},
		},
	},
	wortox_soul_range = {
		label = {
			"Wortox Soul range", 
			["zh"] = "沃拓克斯灵魂范围", 
			["br"] = "Alcance de almas do Wortox", 
			["es"] = "Rango de almas de Wortox",
			["ru"] = "Диапазон душ Вортокса",
			["ko"] = "워톡스 영혼 수집 범위 표시",
		},
		hover = {
			"Whether you can see the pickup range Wortox has for his souls.", 
			["zh"] = "是否显示沃拓克斯拾取灵魂的范围和灵魂治疗范围。", 
			["br"] = "Se você pode ver o alcance de captação que Wortox tem para suas almas.", 
			["es"] = "Configura si se muestra el rango de recogida de Wortox para sus almas.",
			["ru"] = "Показывать ли диапазон подбора Вортоксом его душ.",
			["ko"] = "워톡스가 영혼을 수집하는 범위를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Soul pickup ranges not shown.",
					["zh"] = "不显示灵魂范围功能。",
					["br"] = "Faixas de coleta de almas não são mostradas.",
					["es"] = "No se muestra los rangos de recogida de almas.",
					["ru"] = "Диапазоны подбора душ не показываются.",
					["ko"] = "영혼 수집 범위가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Soul pickup ranges shown.",
					["zh"] = "显示灵魂范围功能。",
					["br"] = "Faixas de coleta de almas são mostradas.",
					["es"] = "Se muestra los rangos de recogida de almas.",
					["ru"] = "Диапазоны подбора душ показываются.",
					["ko"] = "영혼 수집 범위가 표시됩니다.",
				},
			},
		},
	},
	battlesong_range = {
		label = {
			"Battle song range", 
			["zh"] = "战歌生效范围", 
			["br"] = "Alcance de Músicas de Batalha", 
			["es"] = "Rango de canciones de batalla",
			["ru"] = "Диапазон боевой песни",
			["ko"] = "악보 범위 표시",
		},
		hover = {
			"How battle song ranges are displayed.", 
			["zh"] = "如何显示战歌的生效范围。", 
			["br"] = "Como os alcances das músicas de batalha (Wigfrid) são exibidos.", 
			["es"] = "Configura como se muestra los rangos de canciones de batalla.",
			["ru"] = "Как отображаются диапазоны боевой песни.",
			["ko"] = "위그프리드의 악보가 적용되는 범위를 표시할지 선택합니다.",
		},
		options = {
			["none"] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhum",
					["es"] = "Ninguno",
					["ru"] = "Нет",
					["ko"] = "표시 안함",
				},
				hover = {
					"Do not show battle song ranges.",
					["zh"] = "不显示战歌生效范围。",
					["br"] = "Não mostrar alcances de músicas de batalha.",
					["es"] = "No se muestra rangos de canciones de batalla.",
					["ru"] = "Не показывать диапазоны боевой песни.",
					["ko"] = "악보 범위가 표시되지 않습니다.",
				},
			},
			["detach"] = {
				description = {
					"Detach",
					["zh"] = "脱离",
					["br"] = "Desanexar",
					["es"] = "Desprendimiento",
					["ru"] = "Отсоединить",
					["ko"] = "해제 범위 표시",
				},
				hover = {
					"Song detachment range shown.",
					["zh"] = "显示你脱离战歌生效的范围。",
					["br"] = "Alcance de separação de música é mostrado.",
					["es"] = "Se muestra el rango de desprendimiento de la canción.",
					["ru"] = "Показывается диапазон отсоединения песни.",
					["ko"] = "악보 효과가 해제되는 범위가 표시됩니다.",
				},
			},
			["attach"] = {
				description = {
					"Attach",
					["zh"] = "生效",
					["br"] = "Anexar",
					["es"] = "Fijación",
					["ru"] = "Присоединить",
					["ko"] = "적용 범위 표시",
				},
				hover = {
					"Song attachment range shown.",
					["zh"] = "显示你被战歌鼓舞的生效范围。",
					["br"] = "Alcance de anexo de música é mostrado.",
					["es"] = "Se muestra el rango de fijación de la canción.",
					["ru"] = "Показывается диапазон присоединения песни.",
					["ko"] = "악보 효과가 적용되는 범위가 표시됩니다.",
				},
			},
			["both"] = {
				description = {
					"Both",
					["zh"] = "兼用",
					["br"] = "Ambos",
					["es"] = "Ambos",
					["ru"] = "Оба",
					["ko"] = "모두 표시",
				},
				hover = {
					"Both ranges are shown.",
					["zh"] = "同时显示脱离战歌和被战歌鼓舞的生效范围",
					["br"] = "Ambas os alcances são mostradas.",
					["es"] = "Se muestra ambos rangos.",
					["ru"] = "Показываются оба диапазона.",
					["ko"] = "모든 악보 범위가 표시됩니다.",
				},
			},
		},
	},
	klaus_sack_markers = {
		label = {
			"Loot Stash Markers", 
			["zh"] = "克劳斯袋子标记", 
			["br"] = "Marcadores do Klaus", 
			["es"] = "Indicador de Saco de Klaus",
			["ru"] = "Маркеры мешков Клауса",
			["ko"] = "전리품 보따리 표시",
		},
		hover = {
			"Whether Loot Stash spawning locations are marked.", 
			["zh"] = "是否标记克劳斯袋子的位置 *该选项仅服务器有效*", 
			["br"] = "Se os locais onde o Klaus (Loot Stash) aparece estão marcados.", 
			["es"] = "Configura si se marcan las ubicaciones de aparición del Saco de Klaus.",
			["ru"] = "Показывать ли места появления мешков Клауса.",
			["ko"] = "전리품 보따리의 스폰 위치를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Loot Stash markers are not shown.",
					["zh"] = "不显示标记",
					["br"] = "Sacos do Klaus não são marcados.",
					["es"] = "Se muestra los marcadores del Saco de Klaus.",
					["ru"] = "Маркеры мешков Клауса не показываются.",
					["ko"] = "전리품 보따리 스폰 위치가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Loot Stash markers are shown.",
					["zh"] = "显示标记",
					["br"] = "Sacos do Klaus são marcados.",
					["es"] = "No se muestra los marcadores del Saco de Klaus.",
					["ru"] = "Маркеры мешков Клауса показываются.",
					["ko"] = "전리품 보따리 스폰 위치가 표시됩니다.",
				},
			},
		},
	},
	sinkhole_marks = {
		label = {
			"Sinkhole Marks", 
			["zh"] = "洞穴标记", 
			["br"] = "Marcações de Buraco", 
			["es"] = "Indicador de sumidero",
			["ru"] = "Метки карстовая воронка",
			["ko"] = "싱크홀 색상 구별",
		},
		hover = {
			"How sinkhole marking is applied.", 
			["zh"] = "如何显示洞穴的着色标记。", 
			["br"] = "Como a marcação de buracos (entrada para as cavernas) é aplicada.", 
			["es"] = "Configura como se muestra los indicadores de sumideros",
			["ru"] = "Как применяется маркировка карстовых воронок.",
			["ko"] = "싱크홀을 색상으로 구별할지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Ninguno",
					["ru"] = "Нет",
					["ko"] = "표시 안함",
				},
				hover = {
					"Do not do any sinkhole coloring.",
					["zh"] = "不着色标记任何洞穴洞口。",
					["br"] = "Não faça nenhum buraco colorido.",
					["es"] = "No se muestra ningún indicador.",
					["ru"] = "Не применять никакого цвета карстовым воронкам.",
					["ko"] = "어느 싱크홀에도 색칠하지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Map Only",
					["zh"] = "仅地图模式",
					["br"] = "Apenas Mapa",
					["es"] = "Sólo mapa",
					["ru"] = "Только на карте",
					["ko"] = "지도에만",
				},
				hover = {
					"Only apply to map icons.",
					["zh"] = "仅着色标记地图图标。",
					["br"] = "Aplica-se apenas a ícones do mapa.",
					["es"] = "Sólo se colorea iconos del mapa.",
					["ru"] = "Применять только к иконкам на карте.",
					["ko"] = "지도 아이콘(싱크홀 입구 화살표)에만 색상이 적용됩니다.",
				},
			},
			[2] = {
				description = {
					"Sinkholes & Map",
					["zh"] = "兼用",
					["br"] = "Buracos & Mapa",
					["es"] = "Sumidero/mapa",
					["ru"] = "Карстовые воронки и карта",
					["ko"] = "싱크홀 & 지도",
				},
				hover = {
					"Apply to both map icons & sinkholes.",
					["zh"] = "同时着色标记地图图标和洞穴洞口。",
					["br"] = "Aplicar a ícones de mapa e buracos.",
					["es"] = "Colorear tanto a iconos del mapa como a los sumideros",
					["ru"] = "Применять к иконкам на карте и карстовым воронкам.",
					["ko"] = "지도 아이콘 & 싱크홀 모두에 색상이 적용됩니다.",
				},
			},
		},
	},
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Food Related ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	display_food = {
		label = {
			"Food Information", 
			["zh"] = "食物信息", 
			["br"] = "Informações da Comida", 
			["es"] = "Información de alimentos",
			["ru"] = "Информация о еде",
			["ko"] = "음식 정보",
		},
		hover = {
			"Whether food information is shown.", 
			["zh"] = "是否显示食物信息。", 
			["br"] = "Se as informações de alimentos são mostradas.", 
			["es"] = "Configura si se muestra la información de los alimentos.",
			["ru"] = "Показывать ли информацию о еде.",
			["ko"] = "음식 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Food information is not shown.",
					["zh"] = "不显示食物信息。",
					["br"] = "Informações de alimentos não são mostradas.",
					["es"] = "No se muestra la información de alimentos.",
					["ru"] = "Информация о еде не показывается.",
					["ko"] = "음식 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Food information is shown.",
					["zh"] = "显示食物信息。",
					["br"] = "As informações sobre os alimentos são mostradas.",
					["es"] = "Se muestra la información de alimentos.",
					["ru"] = "Информация о еде показывается.",
					["ko"] = "음식 정보가 표시됩니다.",
				},
			},
		},
	},
	food_style = {
		label = {
			"Food style", 
			["zh"] = "食物属性格式", 
			["br"] = "Estilos de Comida", 
			["es"] = "Estilo de comida",
			["ru"] = "Стиль еды",
			["ko"] = "음식 스타일",
		},
		hover = {
			"How food information is displayed.", 
			["zh"] = "如何显示食物属性信息。", 
			["br"] = "Como as informações de alimentos são exibidas.", 
			["es"] = "Configura como se muestra la información de los alimentos.",
			["ru"] = "Как отображается информация о еде.",
			["ko"] = "음식 정보가 어떻게 표시될지 선택합니다.",
		},
		options = {
			["short"] = {
				description = {
					"Short",
					["zh"] = "精简",
					["br"] = "Curta",
					["es"] = "Reducida",
					["ru"] = "Кратко",
					["ko"] = "짧음",
				},
				hover = { -- No Translation Needed   
					"+X / -X / +X",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			["long"] = {
				description = {
					"Long",
					["zh"] = "详细",
					["br"] = "Longa",
					["es"] = "Larga",
					["ru"] = "Подробно",
					["ko"] = "긺",
				},
				hover = {
					"Hunger: +X / Sanity: -X / Health: +X",
					["zh"] = "饥饿：+X / 理智：-X / 生命：+X",
					["br"] = "Fome: +X / Sanidade: -X / Vida: +X",
					["es"] = "Hambre: +X / Cordura: -X / Salud: +X",
					["ru"] = "Голод: +X / Рассудок: -X / Здоровье: +X",
					["ko"] = "허기: +X / 정신력: -X / 체력: +X",
				},
			},
		},
	},
	food_order = {
		label = {
			"Food order", 
			["zh"] = "食物属性显示顺序", 
			["br"] = "Ordem da Comida", 
			["es"] = "Orden de comida",
			["ru"] = "Порядок еды",
			["ko"] = "음식 정보 순서",
		},
		hover = {
			"What order food stats are displayed in (if you choose Wiki you're dead to me)", 
			["zh"] = "食物属性以何种顺序显示。", 
			["br"] = "Em que ordem as estatísticas de comida são exibidas (se você escolher Wiki, você está morto para mim)", 
			["es"] = "Configura en qué orden se muestra las estadísticas de los alimentos (si eliges Wiki estás muerto para mí).",
			["ru"] = "В каком порядке отображаются характеристики еды (если вы выберете Вики, вы мертвы для меня)",
			["ko"] = "음식 스탯 정보를 어떤 순서대로 보여줄지 선택합니다.",
		},
		options = {
			["interface"] = {
				description = {
					"Interface",
					["zh"] = "界面",
					["br"] = "Interface",
					["es"] = "Interfaz",
					["ru"] = "Интерфейс",
					["ko"] = "인터페이스",
				},
				hover = {
					"Hunger / Sanity / Health",
					["zh"] = "饥饿 / 理智 / 生命",
					["br"] = "Fome / Sanidade / Vida",
					["es"] = "Hambre / Cordura / Salud",
					["ru"] = "Голод / Рассудок / Здоровье",
					["ko"] = "허기 / 정신력 / 체력",
				},
			},
			["wiki"] = {
				description = {
					"Wiki",
					["zh"] = "维基",
					["br"] = "Wiki",
					["es"] = "Wiki",
					["ru"] = "Вики",
					["ko"] = "위키(Wiki)",
				},
				hover = {
					"Health / Hunger / Sanity",
					["zh"] = "生命 / 饥饿 / 理智",
					["br"] = "Vida/ Fome / Sanidade",
					["es"] = "Salud / Hambre / Cordura",
					["ru"] = "Здоровье / Голод / Рассудок",
					["ko"] = "체력 / 허기 / 정신력",
				},
			},
		},
	},
	food_units = {
		label = {
			"Display food units", 
			["zh"] = "食物系数", 
			["br"] = "Exibir unidades de alimentos", 
			["es"] = "Expositor de comida",
			["ru"] = "Показывать единицы еды",
			["ko"] = "음식 단위 표시",
		},
		hover = {
			"Whether food units are displayed.", 
			["zh"] = "是否显示食物的系数（果、菜、蛋度等等）。", 
			["br"] = "Se as unidades de alimentos são exibidas.", 
			["es"] = "Configura si se muestra las unidades de la comida.",
			["ru"] = "Показывать ли единицы еды (фрукты, овощи, яйца и т. д.)",
			["ko"] = "음식 단위를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Food units will not be displayed.",
					["zh"] = "不显示食物度。",
					["br"] = "Unidades de alimentos não são exibidas.",
					["es"] = "No se muestra unidades de comida.",
					["ru"] = "Единицы еды не показываются.",
					["ko"] = "음식 단위가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Food units WILL be displayed.",
					["zh"] = "显示食物度。",
					["br"] = "Unidades de alimentos SÃO exibidas.",
					["es"] = "Se muestra unidades de comida.",
					["ru"] = "Единицы еды показываются.",
					["ko"] = "음식 단위가 표시됩니다.",
				},
			},
		},
	},
	food_effects = {
		label = {
			"Food Effects", 
			["zh"] = "食物加成属性", 
			["br"] = "Efeitos dos Alimentos", 
			["es"] = "Efectos de comida",
			["ru"] = "Эффекты еды",
			["ko"] = "음식 효과 표시",
		},
		hover = {
			"Whether special food effects show or not.", 
			["zh"] = "是否显示食物的特殊加成属性。", 
			["br"] = "Se os efeitos especiais de comida aparecem ou não.", 
			["es"] = "Configura si se muestra los efectos especiales de la comida.",
			["ru"] = "Показывать ли специальные эффекты еды.",
			["ko"] = "특별한 음식 효과를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Special food effects will not show.",
					["zh"] = "不显示特殊的食物属性。",
					["br"] = "Efeitos de alimentos especiais não são exibidos.",
					["es"] = "No se muestra los efectos especiales de la comida.",
					["ru"] = "Специальные эффекты еды не показываются.",
					["ko"] = "특별한 음식 효과가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Special food effects will show.",
					["zh"] = "显示特殊的食物属性。",
					["br"] = "Efeitos de alimentos especiais são exibidos.",
					["es"] = "Se muestra los efectos especiales de la comida.",
					["ru"] = "Специальные эффекты еды показываются.",
					["ko"] = "특별한 음식 효과가 표시됩니다.",
				},
			},
		},
	},
	stewer_chef = {
		label = {
			"Chef Identifiers", 
			["zh"] = "烹饪厨师显示", 
			["br"] = "Identificadores de Chef", 
			["es"] = "Identificador de chef",
			["ru"] = "Идентификатор повара",
			["ko"] = "요리사 정보 표시",
		},
		hover = {
			"Whether the chef of a recipe is shown.", 
			["zh"] = "是否显示料理的制作人。", 
			["br"] = "Se quem fez uma receita na panela é mostrado na mesma.", 
			["es"] = "Configura si se muestra el chef de una receta.",
			["ru"] = "Показывать ли повара рецепта.",
			["ko"] = "요리 제작자를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The chef will not be shown.",
					["zh"] = "不显示料理的制作人。",
					["br"] = "Quem preparou não será mostrado.",
					["es"] = "El chef no se muestra.",
					["ru"] = "Повар не показывается.",
					["ko"] = "요리사 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The chef will be shown.",
					["zh"] = "显示料理的制作人。",
					["br"] = "Quem preparou será mostrado.",
					["es"] = "Se muestra al chef.",
					["ru"] = "Повар показывается.",
					["ko"] = "요리사 정보가 표시됩니다.",
				},
			},
		},
	},
	food_memory = {
		label = {
			"Food Memory", 
			["zh"] = "瓦力大厨的食物计时", 
			["br"] = "Memória Alimentar", 
			["es"] = "Memoria de comida",
			["ru"] = "Память о еде",
			["ko"] = "음식 기억 표시",
		},
		hover = {
			"Whether your food memory is shown.", 
			["zh"] = "是否显示瓦力大厨的食物计时。", 
			["br"] = "Se sua memória alimentar é mostrada.", 
			["es"] = "Configura si se muestra la memoria de comida (Warly).",
			["ru"] = "Показывать ли вашу память о еде.",
			["ko"] = "최근 섭취했던 음식에 대한 기억을 표시할지 선택합니다.(왈리)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Your food memory will not be shown.",
					["zh"] = "不显示食物计时。",
					["br"] = "Sua memória alimentar não será exibida.",
					["es"] = "La memoria de alimentos no se muestra.",
					["ru"] = "Ваша память о еде не показывается.",
					["ko"] = "음식 기억이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Your food memory will be shown.",
					["zh"] = "显示食物计时。",
					["br"] = "Sua memória alimentar será exibida.",
					["es"] = "Se muestra su memoria de alimentos.",
					["ru"] = "Ваша память о еде показывается.",
					["ko"] = "음식 기억이 표시됩니다.",
				},
			},
		},
	},
	display_perishable = {
		label = {
			"Perishing", 
			["zh"] = "腐烂信息", 
			["br"] = "Perecíveis", 
			["es"] = "Putrefacción",
			["ru"] = "Информация о порче",
			["ko"] = "부패 표시",
		},
		hover = {
			"Whether perishable information is displayed.", 
			["zh"] = "是否显示腐烂信息", 
			["br"] = "Se informações de perecíveis são exibidas.", 
			["es"] = "Configura si se muestra información de la putrefacción.",
			["ru"] = "Показывать ли информацию о порче",
			["ko"] = "부패 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Perishable information is not shown.",
					["zh"] = "不显示腐烂信息",
					["br"] = "Informações de perecíveis não são mostradas.",
					["es"] = "No se muestra la información de putrefacción.",
					["ru"] = "Информация о порче не показывается.",
					["ko"] = "부패 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Perishable information is shown.",
					["zh"] = "显示腐烂信息",
					["br"] = "Informações de perecíveis são mostradas.",
					["es"] = "Se muestra la información de putrefacción.",
					["ru"] = "Информация о порче показывается.",
					["ko"] = "부패 정보가 표시됩니다.",
				},
			},
		},
	},
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Information Control ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	display_cawnival = {
		label = {
			"Cawnival Information", 
			["zh"] = "鸦年华信息", 
			["br"] = "Informações do Carnaval", 
			["es"] = "Información de Cawnvival",
			["ru"] = "Информация о карнавале",
			["ko"] = "까악제 정보",
		},
		hover = {
			"Whether Midsummer Cawnvival information is shown.", 
			["zh"] = "是否显示盛夏鸦年华信息", 
			["br"] = "Se as informações do Midsummer Cawnvival são mostradas.", 
			["es"] = "Configura si se muestra la información de Midsummer Cawnvival.",
			["ru"] = "Показывать ли информацию о карнавале",
			["ko"] = "한여름 까악제 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Cawnival information is not shown.",
					["zh"] = "不显示鸦年华信息",
					["br"] = "Informações do Cawnival não são mostradas.",
					["es"] = "No se muestra la información de cawnvival.",
					["ru"] = "Информация о карнавале не показывается.",
					["ko"] = "까악제 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Cawnival information is shown.",
					["zh"] = "显示鸦年华信息",
					["br"] = "Informações do Cawnival são mostradas.",
					["es"] = "Se muestra la información de cawnival.",
					["ru"] = "Информация о карнавале показывается.",
					["ko"] = "까악제 정보가 표시됩니다.",
				},
			},
		},
	},
	display_yotb_winners = {
		label = {
			"Pageant Winners [YOTB]", 
			["zh"] = "选美大赛冠军 [\"皮弗娄牛之年\" 更新]", 
			["br"] = "Vencedores do Concurso [YOTB]", 
			["es"] = "Ganadores de concurso [YOTB]",
			["ru"] = "Победители конкурса [YOTB]",
			["ko"] = "비팔로 경연 [비팔로의 해]",
		},
		hover = {
			"Whether Pageant winners are shown.", 
			["zh"] = "是否显示选美大赛冠军", 
			["br"] = "Se os vencedores do concurso são mostrados.", 
			["es"] = "Configura si se muestran los ganadores del concurso.",
			["ru"] = "Показывать ли победителей конкурса",
			["ko"] = "경연 대회 우승자를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The pageant winners are not shown.",
					["zh"] = "不显示选美大赛冠军",
					["br"] = "Os vencedores do concurso não são mostrados.",
					["es"] = "Los ganadores del concurso no se muestra.",
					["ru"] = "Победители конкурса не показываются.",
					["ko"] = "경연 대회 우승자가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The pageant winners are shown.",
					["zh"] = "显示选美大赛冠军",
					["br"] = "Os vencedores do concurso são mostrados.",
					["es"] = "Se muestra los ganadores del concurso.",
					["ru"] = "Победители конкурса показываются.",
					["ko"] = "경연 대회 우승자가 표시됩니다.",
				},
			},
		},
	},
	display_yotb_appraisal = {
		label = {
			"Appraisal Values [YOTB]", 
			["zh"] = "评价值 [\"皮弗娄牛之年\" 更新]", 
			["br"] = "Valores de avaliação [YOTB]", 
			["es"] = "Valores de tasación [YOTB]",
			["ru"] = "Оценочные значения [YOTB]",
			["ko"] = "평가 점수",
		},
		hover = {
			"Whether appraisal values are shown.", 
			["zh"] = "是否显示评价值", 
			["br"] = "Se os valores de avaliação são mostrados.", 
			["es"] = "Configura si se muestran los valores de tasación.",
			["ru"] = "Показывать ли оценочные значения",
			["ko"] = "평가 점수를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The appraisal values are not shown.",
					["zh"] = "不显示评价值",
					["br"] = "Os valores de avaliação não são mostrados.",
					["es"] = "Los valores de tasación no se muestran.",
					["ru"] = "Оценочные значения не показываются.",
					["ko"] = "평가 점수가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The appraisal values are shown.",
					["zh"] = "显示评价值",
					["br"] = "Os valores de avaliação são mostrados.",
					["es"] = "Se muestran los valores de tasación.",
					["ru"] = "Оценочные значения показываются.",
					["ko"] = "평가 점수가 표시됩니다.",
				},
			},
		},
	},
	display_shared_stats = {
		label = {
			"Playerlist Stats", 
			["zh"] = "玩家列表中的数据", 
			["br"] = "Estatísticas dos jogadores", 
			["es"] = "Estadísticas de jugadores",
			["ru"] = "Статистика игроков",
			["ko"] = "플레이어 목록 스탯",
		},
		hover = {
			"Whether the stats of other players in the server are shown in the playerlist.", 
			["zh"] = "是否在玩家列表中显示服务器中其他玩家的数据", 
			["br"] = "Se as estatísticas de outros jogadores no servidor são mostradas na lista de jogadores (tecla TAB).", 
			["es"] = "Configura si se muestran en la lista las estadísticas de jugadores en el servidor.",
			["ru"] = "Показывать ли статистику других игроков на сервере в списке игроков.",
			["ko"] = "서버의 다른 플레이어의 스탯을 플레이어 목록에 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The stats are not shown.",
					["zh"] = "不显示数据",
					["br"] = "As estatísticas não são mostradas.",
					["es"] = "Las estadísticas no se muestran.",
					["ru"] = "Статистика не показывается.",
					["ko"] = "스탯이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The stats are shown.",
					["zh"] = "显示数据",
					["br"] = "As estatísticas são mostradas.",
					["es"] = "Se muestran las estadísticas.",
					["ru"] = "Статистика показывается.",
					["ko"] = "스탯이 표시됩니다.",
				},
			},
		},
	},
	display_worldmigrator = {
		label = {
			"Portal information", 
			["zh"] = "传送信息", 
			["br"] = "Informações do Portal", 
			["es"] = "Información de portal",
			["ru"] = "Информация о портале",
			["ko"] = "포탈 정보",
		},
		hover = {
			"Whether portal (sinkhole) information is shown.", 
			["zh"] = "是否显示传送信息 (洞穴)", 
			["br"] = "Se as informações do portal (sinkhole) são mostradas.", 
			["es"] = "Configura si se muestra la información del portal (sumidero).",
			["ru"] = "Показывать ли информацию о портале (карстовая воронка)",
			["ko"] = "포탈 (싱크홀) 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Portal information is not shown.",
					["zh"] = "不显示传送信息",
					["br"] = "As informações do portal não são mostradas.",
					["es"] = "La información de portal no se muestra.",
					["ru"] = "Информация о портале не показывается.",
					["ko"] = "포탈 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Portal information is shown.",
					["zh"] = "显示传送信息",
					["br"] = "As informações do portal são mostradas.",
					["es"] = "Se muestra la información de portal.",
					["ru"] = "Информация о портале показывается.",
					["ko"] = "포탈 정보가 표시됩니다.",
				},
			},
		},
	},
	display_unwrappable = {
		label = {
			"Bundle information", 
			["zh"] = "打包信息", 
			["br"] = "Informações do Pacote", 
			["es"] = "Información de paquete",
			["ru"] = "Информация о пакете",
			["ko"] = "포장된 물건 정보",
		},
		hover = {
			"Whether bundle information is shown.", 
			["zh"] = "是否显示打包信息", 
			["br"] = "Se as informações de pacotes, embrulhos ou presentes são mostradas.", 
			["es"] = "Configura si se muestra la información de paquete.",
			["ru"] = "Показывать ли информацию о пакете",
			["ko"] = "포장된 물건의 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Bundle information is not shown.",
					["zh"] = "不显示打包信息",
					["br"] = "As informações do pacote não são mostradas.",
					["es"] = "La información de paquete no se muestra.",
					["ru"] = "Информация о пакете не показывается.",
					["ko"] = "포장된 물건의 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Bundle information is shown.",
					["zh"] = "显示打包信息",
					["br"] = "As informações do pacote são mostradas.",
					["es"] = "Se muestra la información de paquete.",
					["ru"] = "Информация о пакете показывается.",
					["ko"] = "포장된 물건의 정보가 표시됩니다.",
				},
			},
		},
	},
	display_simplefishing = {
		label = {
			"Freshwater fishing information", 
			["zh"] = "淡水垂钓信息", 
			--["br"] = "Informações de pesca", 
			--["es"] = "Información de pesca",
			["ru"] = "Информация о пресноводной рыбалке",
			["ko"] = "민물 낚시 정보",
		},
		hover = {
			"Whether freshwater fishing information is shown.", 
			["zh"] = "是否显示淡水垂钓信息", 
			--["br"] = "Se as informações de pesca são mostradas.", 
			--["es"] = "Configura si se muestra la información de pesca.",
			["ru"] = "Показывать ли информацию о пресноводной рыбалке",
			["ko"] = "민물 낚시 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Freshwater fishing information is not shown.",
					["zh"] = "不显示淡水垂钓信息",
					--["br"] = "Informações de pesca não são mostradas.",
					--["es"] = "La información de pesca no se muestra.",
					["ru"] = "Информация о пресноводной рыбалке не показывается.",
					["ko"] = "민물 낚시 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Freshwater fishing information is shown.",
					["zh"] = "显示淡水垂钓信息",
					--["br"] = "Informações de pesca são mostradas.",
					--["es"] = "Se muestra la información de pesca.",
					["ru"] = "Информация о пресноводной рыбалке показывается.",
					["ko"] = "민물 낚시 정보가 표시됩니다.",
				},
			},
		},
	},
	display_oceanfishing = {
		label = {
			"Ocean fishing information", 
			["zh"] = "海洋垂钓信息", 
			--["br"] = "Informações de pesca", 
			--["es"] = "Información de pesca"
			["ru"] = "Информация о глубоководной рыбалке",
			["ko"] = "바다 낚시 정보",
		},
		hover = {
			"Whether ocean fishing information is shown.", 
			["zh"] = "是否显示海洋垂钓信息", 
			--["br"] = "Se as informações de pesca são mostradas.", 
			--["es"] = "Configura si se muestra la información de pesca.",
			["ru"] = "Показывать ли информацию о глубоководной рыбалке",
			["ko"] = "바다 낚시 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Ocean fishing information is not shown.",
					["zh"] = "不显示海洋垂钓信息",
					--["br"] = "Informações de pesca não são mostradas.",
					--["es"] = "La información de pesca no se muestra.",
					["ru"] = "Информация о глубоководной рыбалке не показывается.",
					["ko"] = "바다 낚시 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Ocean fishing information is shown.",
					["zh"] = "显示海洋垂钓信息",
					--["br"] = "Informações de pesca são mostradas.",
					--["es"] = "Se muestra la información de pesca.",
					["ru"] = "Информация о глубоководной рыбалке показывается.",
					["ko"] = "바다 낚시 정보가 표시되지 않습니다.",
				},
			},
		},
	},
	display_tackle_information = {
		label = {
			"Tackle information", 
			["zh"] = "渔具信息", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Информация о снастях",
			["ko"] = "낚시 장비 정보",
		},
		hover = {
			"Whether to show information about floats and lures.", 
			["zh"] = "是否显示关于浮标和鱼饵的信息", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Показывать ли информацию о поплавках и приманках",
			["ko"] = "낚시 찌와 미끼의 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Tackle information is not shown.",
					["zh"] = "不显示渔具信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о снастях не показывается",
					["ko"] = "낚시 장비 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Tackle information is shown.",
					["zh"] = "显示渔具信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о снастях показывается",
					["ko"] = "낚시 장비 정보가 표시됩니다.",
				},
			},
		},
	},
	display_spawner_information = {
		label = {
			"Spawner information", 
			["zh"] = "生物生成计时器", 
			["br"] = "Informações de geração", 
			["es"] = "Información de spawner",
			["ru"] = "Информация о спаунерах",
			["ko"] = "스포너 정보",
		},
		hover = {
			"Whether creature spawners have information shown.", 
			["zh"] = "是否显示生物生成计时信息（猪人、兔人等）。", 
			["br"] = "Se os geradores (spawner) de criaturas têm informações mostradas.", 
			["es"] = "Configura si se muestra la información de spawners",
			["ru"] = "Показывать ли информацию о спаунерах (свиней, кроликов и т. д.)",
			["ko"] = "생물 스포너 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION, -- Originally the "No" here translated to "disabled" for Chinese ("禁用")
				hover = {
					"The spawner information is not shown.",
					["zh"] = "不显示生物生成计时信息。",
					["br"] = "A informação do spawner não é mostrada.",
					["es"] = "La información de spawners no se muestra.",
					["ru"] = "Информация о спаунерах не показывается.",
					["ko"] = "스포너 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION, -- Originally the "Yes" here translated to "enable" for Chinese ("启用")
				hover = {
					"The spawner information is shown.",
					["zh"] = "显示生物生成计时信息。",
					["br"] = "A informação do spawner é mostrada.",
					["es"] = "Se muestra la información de spawners.",
					["ru"] = "Информация о спаунерах показывается.",
					["ko"] = "스포너 정보가 표시됩니다.",
				},
			},
		},
	},
	weapon_damage = {
		label = {
			"Weapon Damage", 
			["zh"] = "武器伤害值", 
			["br"] = "Dano da Arma", 
			["es"] = "Daño de arma",
			["ru"] = "Урон оружия",
			["ko"] = "무기 데미지",
		},
		hover = {
			"Whether weapon damage is shown.", 
			["zh"] = "是否显示武器的伤害值。", 
			["br"] = "Se o dano da arma é mostrado.", 
			["es"] = "Configura si se muestra el daño del arma.",
			["ru"] = "Показывать ли урон оружия",
			["ko"] = "무기 데미지를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Weapon damage is not shown.",
					["zh"] = "不显示武器的伤害值。",
					["br"] = "Dano da arma não é mostrado.",
					["es"] = "El daño de arma no se muestra.",
					["ru"] = "Урон оружия не показывается.",
					["ko"] = "무기 데미지가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Weapon damage is shown.",
					["zh"] = "显示武器的伤害值。",
					["br"] = "Dano da arma é mostrado.",
					["es"] = "Se muestra el daño de arma.",
					["ru"] = "Урон оружия показывается.",
					["ko"] = "무기 데미지가 표시됩니다.",
				},
			},
		},
	},
	armor = {
		label = {
			"Armor", 
			["zh"] = "护甲", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Броня",
			["ko"] = "갑옷",
		},
		hover = {
			"Whether defensive information from armor is shown.", 
			["zh"] = "是否显示护甲的防御信息", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Показывать ли информацию о защите брони",
			["ko"] = "갑옷의 방어력 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Defensive information is not shown.",
					["zh"] = "不显示防御信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о защите брони не показывается",
					["ko"] = "방어력 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Defensive information is shown.",
					["zh"] = "显示防御信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о защите брони показывается",
					["ko"] = "방어력 정보가 표시됩니다.",
				},
			},
		},
	},
	repair_values = {
		label = {
			"Repair Values", 
			["zh"] = "修补数值", 
			["br"] = "Valores de Reparo", 
			["es"] = "Valor de reparación",
			["ru"] = "Значения ремонта",
			["ko"] = "수리",
		},
		hover = {
			"Whether repair information is displayed (on inspection).", 
			["zh"] = "是否显示物品的修复信息（需要检查）。", 
			["br"] = "Se as informações de reparo são exibidas (na inspeção).", 
			["es"] = "Configura si se muestra la información de reparación (en inspección).",
			["ru"] = "Показывать ли информацию о ремонте (при осмотре).",
			["ko"] = "수리 정보를 표시할지 선택합니다. (조사 시)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Repair information is not shown.",
					["zh"] = "不显示物品的修复信息",
					["br"] = "Informações de reparo não são mostradas.",
					["es"] = "El valor de reparación se muestra.",
					["ru"] = "Информация о ремонте не показывается",
					["ko"] = "수리 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Repair information is shown.",
					["zh"] = "显示物品的修复信息。",
					["br"] = "Informações de reparo são mostradas.",
					["es"] = "No se muestra el valor de reparación.",
					["ru"] = "Информация о ремонте показывается",
					["ko"] = "수리 정보가 표시됩니다.",
				},
			},
		},
	},
	klaus_sack_info = {
		label = {
			"Loot Stash Info", 
			["zh"] = "赃物袋信息", 
			["br"] = "Informações do Saco do Klaus", 
			["es"] = nil,
			["ru"] = "Информация о мешке Клауса",
			["ko"] = "전리품 보따리 정보",
		},
		hover = {
			"Whether the contents of the Loot Stash are visible.", 
			["zh"] = "是否显示赃物袋内容信息。", 
			["br"] = "Se os conteúdos do Saco do Klaus estarão visíveis.", 
			["es"] = nil,
			["ru"] = "Показывать ли содержимое мешка Клауса",
			["ko"] = "전리품 보따리의 내용물을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Loot stash contents are NOT visible.",
					["zh"] = "不显示赃物袋内容。",
					["br"] = "Conteúdos do Saco do Klaus NÃO estarão visíveis.",
					["es"] = nil,
					["ru"] = "Содержимое мешка Клауса не показывается.",
					["ko"] = "전리품 보따리의 내용물이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Loot stash contents are visible.",
					["zh"] = "显示赃物袋内容。",
					["br"] = "Conteúdos do Saco do Klaus estarão visíveis.",
					["es"] = nil,
					["ru"] = "Содержимое мешка Клауса показывается.",
					["ko"] = "전리품 보따리의 내용물이 표시됩니다.",
				},
			},
		},
	},
	soil_moisture = {
		label = {
			"Soil Moisture", 
			["zh"] = "土壤潮湿度", 
			["br"] = "Umidade do solo", 
			["es"] = "Humedad del suelo",
			["ru"] = "Влажность почвы",
			["ko"] = "토양 수분량",
		},
		hover = {
			"How soil/plant moisture is displayed.", 
			["zh"] = "如何显示土壤/植物的潮湿度。", 
			["br"] = "Como a umidade do solo/planta é exibida.", 
			["es"] = "Configura como se muestra la humedad del suelo/de las plantas.",
			["ru"] = "Как показывается влажность почвы/растений",
			["ko"] = "토양/식물의 수분량이 어떻게 표시될지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Soil moisture is not shown.",
					["zh"] = "不显示土壤潮湿度。",
					["br"] = "A umidade do solo não é mostrada.",
					["es"] = "No se muestra la humedad del suelo.",
					["ru"] = "Влажность почвы не показывается",
					["ko"] = "토양의 수분량이 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Soil",
					["zh"] = "仅土壤",
					["br"] = "Solo",
					["es"] = "Suelo",
					["ru"] = "Только почва",
					["ko"] = "토양",
				},
				hover = {
					"Only soil moisture is shown.",
					["zh"] = "仅显示土壤的潮湿度。",
					["br"] = "Apenas a umidade do solo é mostrada.",
					["es"] = "Solo se muestra la humedad del suelo.",
					["ru"] = "Показывается только влажность почвы",
					["ko"] = "토양의 수분량만 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"Soil / Plant",
					["zh"] = "土壤/植株",
					["br"] = "Solo / Planta",
					["es"] = "Suelo / Planta",
					["ru"] = "Почва / Растение",
					["ko"] = "토양 / 식물",
				},
				hover = {
					"Soil moisture and the plant consumption rate is shown.",
					["zh"] = "显示土壤潮湿度和植株耗水率。",
					["br"] = "A umidade do solo e a taxa de consumo da planta são mostradas.",
					["es"] = "Se muestra la humedad del suelo y la tasa de consumo de la planta.",
					["ru"] = "Показывается влажность почвы и скорость потребления растения",
					["ko"] = "토양의 수분량과 식물의 수분 소비량이 표시됩니다.",
				},
			},
			[3] = {
				description = {
					"Soil, Plant, Tile",
					["zh"] = "土壤，植株，耕地",
					["br"] = "Solo, Planta, Ladrilho",
					["es"] = "Suelo, planta y baldosa",
					["ru"] = "Почва, Растение, Плитка",
					["ko"] = "토양, 식물, 타일",
				},
				hover = {
					"Soil moisture, plant consumption, and the tile moisture rate is shown.",
					["zh"] = "显示土壤潮湿度，植株耗水率，耕地潮湿度。",
					["br"] = "A umidade do solo, o consumo da planta e a taxa de umidade do ladrilho são mostrados.",
					["es"] = "Se muestra la humedad del suelo, el consumo de las plantas y la tasa de humedad de las baldosas.",
					["ru"] = "Показывается влажность почвы, скорость потребления растения и скорость влажности тайла",
					["ko"] = "토양의 수분량, 식물의 수분 소비량, 타일의 수분량이 표시됩니다.",
				},
			},
			[4] = {
				description = {
					"All",
					["zh"] = "全部",
					["br"] = "Tudo",
					["es"] = "Todo",
					["ru"] = "Все",
					["ko"] = "모두",
				},
				hover = {
					"Soil moisture, plant consumption, and the **NET** tile moisture rate is shown.",
					["zh"] = "显示土壤潮湿度，植株耗水率，总耕地潮湿度。",
					["br"] = "A umidade do solo, o consumo da planta e a taxa de umidade do ladrilho **NET** são mostrados.",
					["es"] = "Humedad del suelo, consumo de las plantas, y se muestra la tasa de humedad de la baldosa **RED**.",
					["ru"] = "Показывается влажность почвы, скорость потребления растения и **NET** скорость влажности тайла",
					["ko"] = "토양의 수분량, 식물의 수분 소비량, **순수한** 타일 수분량이 표시됩니다.",
				},
			},
		},
	},
	soil_nutrients = {
		label = {
			"Soil Nutrients", 
			["zh"] = "土壤养分值", 
			["br"] = "Nutrientes do solo", 
			["es"] = "Nutrientes del suelo",
			["ru"] = "Питательные вещества почвы",
			["ko"] = "토양 영양분",
		},
		hover = {
			"How soil/plant nutrients are displayed.", 
			["zh"] = "如何显示土壤/植株的养分值。", 
			["br"] = "Como os nutrientes do solo/planta são exibidos.", 
			["es"] = "Configura como se muestran los nutrientes del suelo/de las plantas.",
			["ru"] = "Как показываются питательные вещества почвы/растений",
			["ko"] = "토양/식물 영양분이 어떻게 표시될지 선택합니다.",
		},
		options = {
			--[[
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
					["ru"] = nil,
					["ko"] = "표시 안함",
				},
				hover = {
					"Soil nutrients are not shown.",
					["zh"] = "不显示土壤养分值。",
					["br"] = "Os nutrientes do solo não são mostrados.",
					["es"] = "No se muestra los nutrientes.",
					["ru"] = nil,
					["ko"] = "토양 영양분이 표시되지 않습니다.",
				},
			},
			--]]
			[1] = {
				description = {
					"Soil",
					["zh"] = "仅土壤",
					["br"] = "Solo",
					["es"] = "Suelo",
					["ru"] = "Только почва",
					["ko"] = "토양",
				},
				hover = {
					"Only soil nutrients are shown.",
					["zh"] = "仅显示土壤养分值。",
					["br"] = "Apenas os nutrientes do solo são mostrados.",
					["es"] = "Solo se muestra los nutrientes del suelo.",
					["ru"] = "Показывается только питательные вещества почвы",
					["ko"] = "토양 영양분만 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"Soil / Plant",
					["zh"] = "土壤/植株",
					["br"] = "Solo / Planta",
					["es"] = "Suelo / Planta",
					["ru"] = "Почва / Растение",
					["ko"] = "토양 / 식물",
				},
				hover = {
					"Soil nutrients and the plant consumption rate are shown.",
					["zh"] = "显示土壤养分值和植株耗肥率。",
					["br"] = "Os nutrientes do solo e a taxa de consumo da planta são mostrados.",
					["es"] = "Se muestra los nutrientes del suelo y la tasa de consumo de las plantas.",
					["ru"] = "Показывается питательные вещества почвы и скорость потребления растения",
					["ko"] = "토양 영양분과 식물 영양 소비량이 표시됩니다.",
				},
			},
			[3] = {
				description = {
					"Soil, Plant, Tile",
					["zh"] = "土壤，植株，耕地",
					["br"] = "Solo, Planta, Ladrilho",
					["es"] = "Suelo, planta y baldosa",
					["ru"] = "Почва, Растение, Тайл",
					["ko"] = "토양, 식물, 타일",
				},
				hover = {
					"Soil nutrients, plant consumption, and the tile nutrients rate are all shown.",
					["zh"] = "显示土壤养分值，植株耗肥率，耕地养分值。",
					["br"] = "Os nutrientes do solo, o consumo de plantas e a taxa de nutrientes do ladrilho são mostrados.",
					["es"] = "Se muestra los nutrientes del suelo, el consumo de las plantas y la tasa de nutrientes de las baldosas.",
					["ru"] = "Показывается питательные вещества почвы, скорость потребления растения и скорость питательных веществ тайла",
					["ko"] = "토양 영양분, 식물 영양 소비량, 타일 영양분 비율이 모두 표시됩니다.",
				},
			},
		},
	},
	soil_nutrients_needs_hat = {
		label = {
			"Display soil nutrients", 
			["zh"] = "土壤养分值显示", 
			["br"] = "Exibir nutrientes do solo", 
			["es"] = nil,
			["ru"] = "Показывать питательные вещества почвы",
			["ko"] = "토양 영양분 표시",
		},
		hover = {
			"When to display soil/plant nutrients.", 
			["zh"] = "何时显示土壤/植株的养分值。", 
			["br"] = "Quando exibir nutrientes do solo/plantas.", 
			["es"] = nil,
			["ru"] = "Когда показывать питательные вещества почвы/растений",
			["ko"] = "언제 토양/식물 영양분을 표시할지 선택합니다.",
		},
		options = {
			["off"] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Soil nutrients are only shown with the hat.",
					["zh"] = "仅当佩戴高级耕作先驱帽时显示土壤养分值。",
					["br"] = "Nutrientes do solo são mostrados apenas com o chapéu.",
					["es"] = nil,
					["ru"] = "Питательные вещества почвы показываются только с шляпой",
					["ko"] = "토양 영양분이 모자로만 표시됩니다.",
				},
			},
			["hatonly"] = {
				description = {
					"Premier Gardeneer Hat",
					["zh"] = "高级耕作先驱帽",
					["br"] = "Chapéu Premier do Jardineiro",
					["es"] = nil,
					["ru"] = "Шляпа Профессионального Садовника",
					["ko"] = "고급 원예사의 모자",
				},
				hover = {
					"Soil nutrients are only shown with the hat.",
					["zh"] = "仅当佩戴此帽时显示土壤养分值。",
					["br"] = "Nutrientes do solo são mostrados apenas com o chapéu.",
					["es"] = nil,
					["ru"] = "Питательные вещества почвы показываются только с шляпой",
					["ko"] = "토양 영양분이 모자로만 표시됩니다.",
				},
			},
			["always"] = {
				description = {
					"Always",
					["zh"] = "总是",
					["br"] = "Sempre",
					["es"] = "Siempre",
					["ru"] = "Всегда",
					["ko"] = "항상",
				},
				hover = {
					"Soil nutrients are always shown.",
					["zh"] = "总是显示土壤养分值。",
					["br"] = "Nutrientes do solo sempre são mostrados.",
					["es"] = nil,
					["ru"] = "Питательные вещества почвы всегда показываются",
					["ko"] = "토양 영양분이 항상 표시됩니다.",
				},
			},
		},
	},
	display_plant_stressors = {
		label = {
			"Plant stress", 
			["zh"] = "植物压力", 
			["br"] = "Estresse da planta", 
			["es"] = "Estrés de planta",
			["ru"] = "Стресс растений",
			["ko"] = "식물 스트레스",
		},
		hover = {
			"Determines whether plant stress is shown.", 
			["zh"] = "是否显示植物的压力。", 
			["br"] = "Determina se o estresse da planta é mostrado.", 
			["es"] = "Configura si se muestra el estrés de las plantas.",
			["ru"] = "Показывать ли стресс растений",
			["ko"] = "식물 스트레스를 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Plant stress is not shown.",
					["zh"] = "不显示植物的压力。",
					["br"] = "O estresse da planta não é mostrado.",
					["es"] = "No se muestra el estrés.",
					["ru"] = "Стресс растений не показывается",
					["ko"] = "식물 스트레스가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"With Hat",
					["zh"] = "佩戴高级耕作先驱帽",
					["br"] = "Com chapéu",
					["es"] = "Con sombrero",
					["ru"] = "С шляпой",
					["ko"] = "모자 착용",
				},
				hover = {
					"Plant stress will be shown if you have the Premier Gardeneer Hat.",
					["zh"] = "如果你身上有，或戴上高级耕作先驱帽时，显示植物的压力",
					["br"] = "O estresse da planta será mostrado se você tiver o Chapéu Premier Gardeneer.",
					["es"] = "El estrés se mostrará si se tiene un Gardeneer Hat.",
					["ru"] = "Стресс растений будет показан, если у вас есть Шляпа Профессионального Садовника",
					["ko"] = "고급 원예사의 모자가 있다면 식물 스트레스가 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"Always",
					["zh"] = "总是",
					["br"] = "Sempre",
					["es"] = "Siempre",
					["ru"] = "Всегда",
					["ko"] = "항상",
				},
				hover = {
					"Plant stress is always shown.",
					["zh"] = "总是显示植物的压力。",
					["br"] = "O estresse da planta é sempre mostrado.",
					["es"] = "Se muestra siempre el estrés de la planta.",
					["ru"] = "Стресс растений всегда показывается",
					["ko"] = "식물 스트레스가 항상 표시됩니다.",
				},
			},
		},
	},
	display_fertilizer = {
		label = {
			"Fertilizer", 
			["zh"] = "肥料", 
			["br"] = "Fertilizante", 
			["es"] = nil,
			["ru"] = "Удобрения",
			["ko"] = "비료",
		},
		hover = {
			"Determines whether fertilizer nutrients are shown.", 
			["zh"] = "决定是否显示肥料养分值", 
			["br"] = "Determina se os nutrientes fertilizantes são mostrados.", 
			["es"] = nil,
			["ru"] = "Показывать ли удобрения",
			["ko"] = "비료 영양분을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Fertilizer nutrients are not shown.",
					["zh"] = "不显示肥料养分值",
					["br"] = "Nutrientes fertilizantes não são mostrados.",
					["es"] = nil,
					["ru"] = "Удобрения не показываются",
					["ko"] = "비료 영양분이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Fertilizer nutrients are shown.",
					["zh"] = "显示肥料养分值",
					["br"] = "Nutrientes fertilizantes são mostrados.",
					["es"] = nil,
					["ru"] = "Удобрения показываются",
					["ko"] = "비료 영양분이 표시됩니다.",
				},
			},
		},
	},
	display_compostvalue = {
		label = {
			"Compost Value", 
			["zh"] = "堆肥值", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Значение компоста",
			["ko"] = "퇴비 값",
		},
		hover = {
			"Whether compost values are shown.", 
			["zh"] = "是否显示堆肥值", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Показывать ли значения компоста",
			["ko"] = "퇴비 값을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Compost values are not shown.",
					["zh"] = "不显示堆肥值",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Значения компоста не показываются",
					["ko"] = "퇴비 값이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Compost values are shown.",
					["zh"] = "显示堆肥值",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Значения компоста показываются",
					["ko"] = "퇴비 값이 표시됩니다.",
				},
			},
		},
	},
	display_weighable = {
		label = {
			"Item Weight", 
			["zh"] = "物品重量", 
			["br"] = "Peso do item", 
			["es"] = "Peso de artículo",
			["ru"] = "Вес предмета",
			["ko"] = "아이템 무게",
		},
		hover = {
			"Determines whether item weight is shown.", 
			["zh"] = "是否显示物品的重量", 
			["br"] = "Determina se o peso do item é mostrado.", 
			["es"] = "Configura si se muestra el peso de artículos.",
			["ru"] = "Показывать ли вес предмета",
			["ko"] = "아이템의 무게를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Item weight is not shown.",
					["zh"] = "不显示物品的重量值",
					["br"] = "O peso do item não é mostrado.",
					["es"] = "No se muestra el peso.",
					["ru"] = "Вес предмета не показывается",
					["ko"] = "아이템 무게가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Item weight is shown.",
					["zh"] = "显示物品的重量值",
					["br"] = "O peso do item é mostrado.",
					["es"] = "Se muestra el peso.",
					["ru"] = "Вес предмета показывается",
					["ko"] = "아이템 무게가 표시됩니다.",
				},
			},
		},
	},
	display_gyminfo = {
		label = {
			"Gym Info", 
			["zh"] = "健身房信息", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Информация о спортзале",
			["ko"] = "체육관 정보",
		},
		hover = {
			"Whether information about gym-related stuff is shown.", 
			["zh"] = "是否显示与健身房有关的物品信息", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Показывать ли информацию о спортзале",
			["ko"] = "체육관 관련 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Gym-related information is not shown.",
					["zh"] = "不显示与健身房有关的信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о спортзале не показывается",
					["ko"] = "체육관 관련 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Gym-related information is shown.",
					["zh"] = "显示与健身房有关的信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация о спортзале показывается",
					["ko"] = "체육관 관련 정보가 표시됩니다.",
				},
			},
		},
	},
	display_world_events = {
		label = {
			"Show World Data", 
			["zh"] = "世界事件", 
			["br"] = "Mostrar dados do Mundo", 
			["es"] = "Eventos del mundo",
			["ru"] = "Показывать данные мира",
			["ko"] = "세계 데이터 표시",
		},
		hover = {
			"Determines whether world data is shown.\nExamples: Hounds/Worms, Bosses, Earthquakes, etc.", 
			["zh"] = "是否显示世界事件。世界事件有：猎犬/蠕虫，Boss，地震和其他事件。", -- Nonstandard commas
			["br"] = "Determina se os dados do mundo são mostrados.\nExemplos: Hounds/Worms, Bosses, Earthquakes, etc.", 
			["es"] = "Configura si se muestra los eventos del mundo (sabuesos/gusanos, jefes, terremotos, etc.)",
			["ru"] = "Показывать ли данные мира.\nПримеры: Охотники/Черви, Боссы, Землетрясения и т.д.",
			["ko"] = "세계 데이터를 표시할지 선택합니다.\n예시: 하운드/동굴지렁이, 보스, 지진 등.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"World data is not shown.",
					["zh"] = "不显示世界事件。",
					["br"] = "Os dados do mundo não são mostrados.",
					["es"] = "No se muestran los eventos.",
					["ru"] = "Данные мира не показываются",
					["ko"] = "세계 데이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"World data is shown.",
					["zh"] = "显示世界事件。",
					["br"] = "Os dados do mundo são mostrados.",
					["es"] = "Se muestran los eventos.",
					["ru"] = "Данные мира показываются",
					["ko"] = "세계 데이터가 표시됩니다.",
				},
			},
		},
	},
	danger_announcements = {
		label = {
			"Danger Announcements", 
			["zh"] = "危险宣告", 
			["br"] = "Anúncios de Perigo", 
			["es"] = nil,
			["ru"] = "Оповещения о опасности",
			["ko"] = "위험 알림",
		},
		hover = {
			"Announcements that show in chat when a dangerous event is happening soon.", 
			["zh"] = "当危险事件将要发生时在聊天栏进行宣告。", 
			["br"] = "Anúncios que aparecem no chat quando um evento perigoso está acontecendo em breve.", 
			["es"] = nil,
			["ru"] = "Оповещения, которые появляются в чате, когда скоро произойдет опасное событие.",
			["ko"] = "곧 위험한 이벤트가 발생할 때 채팅으로 알릴 지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Danger announcements are not enabled.",
					["zh"] = "禁用危险宣告。",
					["br"] = "Os anúncios de perigo não estão ativados.",
					["es"] = nil,
					["ru"] = "Оповещения о опасности не включены",
					["ko"] = "위험 알림을 비활성화합니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Danger announcements are enabled.",
					["zh"] = "启用危险宣告。",
					["br"] = "Os anúncios de perigo estão ativados.",
					["es"] = nil,
					["ru"] = "Оповещения о опасности включены",
					["ko"] = "위험 알림을 활성화합니다.",
				},
			},
		},
	},
	display_shadowthrall_information = {
		label = {
			"Shadow Thrall Information", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		hover = {
			"Whether to display shadow thrall information.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
				hover = {
					"Do not show any shadow thrall information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			[1] = {
				description = {
					"Worldly",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
				hover = {
					"Show only general shadow thrall information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
				hover = {
					"Show all shadow thrall information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
		},
	},
	display_batwave_information = {
		label = {
			"Bat Wave information", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		hover = {
			"Whether to show bat wave information.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Do not show bat wave information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Show bat wave information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
		},
	},
	display_itemmimic_information = {
		label = {
			"Item Mimic Information", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		hover = {
			"Whether to display item mimic information.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
				hover = {
					"Do not show any item mimic information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			[1] = {
				description = {
					"Worldly",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
				hover = {
					"Show only general item mimic information (such as how many are in the world)",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
				hover = {
					"Show all item mimic information (includes what items are mimics).",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
		},
	},
	display_rabbitking_information = {
		label = {
			"Rabbit King information", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		hover = {
			"Whether to show rabbit king information.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = nil,
			["ko"] = nil,
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Do not show rabbit king information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Show rabbit king information.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
					["ru"] = nil,
					["ko"] = nil,
				},
			},
		},
	},
	display_weather = {
		label = {
			"Weather information", 
			["zh"] = "天气信息", 
			["br"] = "Mostrar informações meteorológicas", 
			["es"] = "Información meteorológica",
			["ru"] = "Информация о погоде",
			["ko"] = "날씨 정보",
		},
		hover = {
			"Determines whether weather information is shown.", 
			["zh"] = "是否显示天气信息。", 
			["br"] = "Determina se as informações meteorológicas são mostradas.", 
			["es"] = "Configura si se muestra la información meteorológica.",
			["ru"] = "Показывать ли информацию о погоде",
			["ko"] = "날씨 정보를 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Weather is not shown.",
					["zh"] = "不显示天气信息",
					["br"] = "O clima não é mostrado",
					["es"] = "El clima no se muestra.",
					["ru"] = "Погода не показывается",
					["ko"] = "날씨가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"With Rainometer",
					["zh"] = "存在雨量计",
					["br"] = "Com Pluviômetro",
					["es"] = nil,
					["ru"] = "С дождемером",
					["ko"] = "기상 예측기",
				},
				hover = {
					"Weather is shown if a Rainometer is in the world.",
					["zh"] = "如果世界中存在雨量计时显示天气信息。",
					["br"] = "O tempo é mostrado se um Pluviômetro estiver no mundo.",
					["es"] = nil,
					["ru"] = "Погода показывается, если в мире есть дождемер",
					["ko"] = "세계에 기상 예측기가 있으면 날씨가 표시됩니다.",
				},
			},
			[2] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Weather is shown.",
					["zh"] = "显示天气信息",
					["br"] = "O clima é mostrado.",
					["es"] = "Se muestra el clima.",
					["ru"] = "Погода показывается",
					["ko"] = "날씨가 표시됩니다.",
				},
			},
		},
	},
	weather_detail = {
		label = {
			"Weather Detail", 
			["zh"] = "天气明细", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "Детали погоды",
			["ko"] = "날씨 세부사항",
		},
		hover = {
			"How detailed the weather information is.", 
			["zh"] = "天气信息有多详细", 
			["br"] = nil, 
			["es"] = nil,
			["ru"] = "На сколько подробная информация о погоде",
			["ko"] = "날씨 정보가 얼마나 자세할지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"Standard detail",
					["zh"] = "标准",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Стандартная детализация",
					["ko"] = "기본",
				},
				hover = {
					"The normal level of detail is shown.",
					["zh"] = "显示正常的细节级别",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Показывается обычный уровень детализации",
					["ko"] = "기본적인 수준의 정보를 표시합니다.",
				},
			},
			[1] = {
				description = {
					"Advanced detail",
					["zh"] = "高级",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Расширенная детализация",
					["ko"] = "고급",
				},
				hover = {
					"Specific numbers about weather conditions are visible.",
					["zh"] = "显示有关天气状况的具体数字",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Видны конкретные числа о погодных условиях",
					["ko"] = "날씨에 대한 구체적인 숫자가 표시됩니다.",
				},
			},
		},	
	},
	nightmareclock_display = {
		label = {
			"Nightmare Phases", 
			["zh"] = "洞穴暴动阶段", 
			["br"] = "Fases de Pesadelo", 
			["es"] = "Ciclo pesadilla",
			["ru"] = "Фазы кошмара",
			["ko"] = "악몽 주기",
		},
		hover = {
			"Controls when users receive information about the Nightmare Phases.", 
			["zh"] = "是否显示洞穴暴动的具体阶段。", 
			["br"] = "Controla quando os usuários recebem informações sobre as Fases de Pesadelo (Ruins).", 
			["es"] = "Configura cuando los usuarios reciben información sobre los ciclos pesadilla.",
			["ru"] = "Контролирует, когда пользователи получают информацию о фазах кошмара",
			["ko"] = "언제 악몽 주기에 대한 정보를 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"No nightmare phase information is shown.",
					["zh"] = "不显示洞穴暴动的阶段信息。",
					["br"] = "Nenhuma informação da fase de pesadelo é mostrada.",
					["es"] = "No se muestra información del ciclo pesadilla.",
					["ru"] = "Информация о фазах кошмара не показывается",
					["ko"] = "악몽 주기 정보가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Need Medallion",
					["zh"] = "拥有铥矿勋章",
					["br"] = "Precisa do Medalhão",
					["es"] = "Medallón necesario",
					["ru"] = "Требуется медальон",
					["ko"] = "메달 필요",
				},
				hover = {
					"Nightmare phase information is shown if a Thulecite Medallion is present.",
					["zh"] = "拥有铥矿勋章时显示。",
					["br"] = "Informações da fase de pesadelo são mostradas se um Thulecite Medallion estiver presente.",
					["es"] = "Se muestra información si se tiene un medallón de tulecita.",
					["ru"] = "Информация о фазах кошмара показывается, если есть медальон из тулецита",
					["ko"] = "툴레사이트 메달이 있는 경우 악몽 주기 정보가 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"On",
					["zh"] = "启用",
					["br"] = "Ligado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "항상",
				},
				hover = {
					"Nightmare phase information is always shown.",
					["zh"] = "总是显示暴动阶段的信息。",
					["br"] = "Informações da fase de pesadelo são sempre mostradas.",
					["es"] = "Se muestra siempre la información del ciclo pesadilla.",
					["ru"] = "Информация о фазах кошмара всегда показывается",
					["ko"] = "악몽 주기 정보가 항상 표시됩니다.",
				},
			},
		},
	},
	wx78_scanner_info = {
		label = {
			"WX-78 Scanner Info", 
			["zh"] = "WX-78 扫描信息",
			["br"] = nil,
			["es"] = nil,
			["ru"] = "Информация от сканера WX-78",
			["ko"] = "WX-78 스캐너 정보",
		},
		hover = {
			"Whether scanning information from WX-78's scanner is shown.", 
			["zh"] = "是否显示来自 WX-78 的扫描分析仪的扫描信息", 
			["br"] = nil,
			["es"] = nil,
			["ru"] = "Показывать ли информацию от сканера WX-78",
			["ko"] = "WX-78의 스캐너 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Scanning information is not shown.",
					["zh"] = "不显示扫描信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация от сканера не показывается",
					["ko"] = "스캐닝 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Scanning information is shown.",
					["zh"] = "显示扫描信息",
					["br"] = nil,
					["es"] = nil,
					["ru"] = "Информация от сканера показывается",
					["ko"] = "스캐닝 정보가 표시됩니다.",
				},
			},
		},
	},
	display_health = {
		label = {
			"Health", 
			["zh"] = "生命值", 
			["br"] = "Vida", 
			["es"] = "Salud",
			["ru"] = "Здоровье",
			["ko"] = "체력",
		},
		hover = {
			"Whether health information should be shown.", 
			["zh"] = "是否显示生命值的信息。", 
			["br"] = "Se as informações de saúde devem ser mostradas.", 
			["es"] = "Configura si muestra información de salud.",
			["ru"] = "Показывать ли информацию о здоровье",
			["ko"] = "체력 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Health information is not shown.",
					["zh"] = "不显示生命值信息。",
					["br"] = "Informações de saúde não são mostradas.",
					["es"] = "No se muestra información de salud.",
					["ru"] = "Информация о здоровье не показывается",
					["ko"] = "체력 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Health information is shown.",
					["zh"] = "显示生命值信息。",
					["br"] = "Informações de saúde são mostradas.",
					["es"] = "Se muestra la información de salud.",
					["ru"] = "Информация о здоровье показывается",
					["ko"] = "체력 정보가 표시됩니다.",
				},
			},
		},
	},
	display_hunger = {
		label = {
			"Hunger", 
			["zh"] = "饥饿值", 
			["br"] = "Fome", 
			["es"] = "Hambre",
			["ru"] = "Голод",
			["ko"] = "허기",
		},
		hover = {
			"How much hunger detail is shown.", 
			["zh"] = "如何显示物品的饥饿值。", 
			["br"] = "Quantos detalhes de fome são mostrados.", 
			["es"] = "Configura cuántos detalles de hambre se muestra.",
			["ru"] = "Сколько деталей голода показывается",
			["ko"] = "얼마나 자세하게 허기 정보를 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not display hunger.",
					["zh"] = "不显示饥饿值。",
					["br"] = "Não exibirá fome.",
					["es"] = "No muestra el hambre.",
					["ru"] = "Голод не показывается",
					["ko"] = "허기 정보가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Standard",
					["zh"] = "标准",
					["br"] = "Padrão",
					["es"] = "Standard",
					["ru"] = "Стандарт",
					["ko"] = "기본",
				},
				hover = {
					"Will display standard hunger information.",
					["zh"] = "显示标准的饥饿值。",
					["br"] = "Mostrará informações padrão de fome.",
					["es"] = "Muestra la información estándar del hambre.",
					["ru"] = "Показывается стандартная информация о голоде",
					["ko"] = "기본 허기 정보가 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "完整",
					["br"] = "Tudo",
					["es"] = "All",
					["ru"] = "Все",
					["ko"] = "모두",
				},
				hover = {
					"Will display all hunger information.",
					["zh"] = "显示完整物品的饥饿值。",
					["br"] = "Mostrará todas as informações de fome.",
					["es"] = "Muestra toda la información del hambre.",
					["ru"] = "Показывается вся информация о голоде",
					["ko"] = "모든 허기 정보가 표시됩니다.",
				},
			},
		},
	},
	display_sanity = {
		label = {
			"Sanity", 
			["zh"] = "理智", 
			["br"] = "Sanidade", 
			["es"] = "Cordura",
			["ru"] = "Рассудок",
			["ko"] = "정신력",
		},
		hover = {
			"Whether sanity information is shown.", 
			["zh"] = "是否显示理智信息", 
			["br"] = "Se as informações de sanidade são mostradas.", 
			["es"] = "Configura se muestra la información de cordura.",
			["ru"] = "Показывать ли информацию о рассудке",
			["ko"] = "정신력 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "否",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display sanity information.",
					["zh"] = "不显示理智信息",
					["br"] = "Não exibirá informações de sanidade.",
					["es"] = "No se muestra información de cordura.",
					["ru"] = "Информация о рассудке не показывается",
					["ko"] = "정신력 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "是",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display sanity information.",
					["zh"] = "显示理智信息",
					["br"] = "Exibirá informações de sanidade.",
					["es"] = "Se muestra información de cordura.",
					["ru"] = "Информация о рассудке показывается",
					["ko"] = "정신력 정보가 표시됩니다.",
				},
			},
		},
	},
	display_sanityaura = {
		label = {
			"Sanity Auras", 
			["zh"] = "理智光环", 
			["br"] = "Auras de Sanidade", 
			["es"] = "Auras de cordura",
			["ru"] = "Ауры рассудка",
			["ko"] = "정신력 오라",
		},
		hover = {
			"Whether sanity auras are shown.", 
			["zh"] = "是否显示理智光环。", 
			["br"] = "Se as auras de sanidade são mostradas.", 
			["es"] = "Configura si se muestra las auras de cordura.",
			["ru"] = "Показывать ли ауры рассудка",
			["ko"] = "정신력 오라 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "否",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display sanity auras.",
					["zh"] = "不显示理智光环。",
					["br"] = "Não exibirá auras de sanidade.",
					["es"] = "No se muestra auras de cordura.",
					["ru"] = "Ауры рассудка не показываются",
					["ko"] = "정신력 오라 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "是",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display sanity auras.",
					["zh"] = "显示理智光环。",
					["br"] = "Exibirá auras de sanidade.",
					["es"] = "Se muestra auras de cordura.",
					["ru"] = "Ауры рассудка показываются",
					["ko"] = "정신력 오라 정보가 표시됩니다.",
				},
			},
		},
	},
	display_sanity_interactions = {
		label = {
			"Sanity Interactions", 
			["zh"] = "影响理智交互显示", 
			["br"] = "Interações de Sanidade", 
			["es"] = nil,
			["ru"] = "Взаимодействия с рассудком",
			["ko"] = "정신력 상호 작용",
		},
		hover = {
			"Whether interactions that affect sanity are shown.", 
			["zh"] = "是否显示影响理智的交互行为。", 
			["br"] = "Se as interações que afetam a sanidade são mostradas.", 
			["es"] = nil,
			["ru"] = "Показывать ли взаимодействия, влияющие на рассудок",
			["ko"] = "정신력에 영향을 주는 상호작용 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "否",
					["br"] = "Desabilitado",
					["es"] = nil,
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display sanity interactions.",
					["zh"] = "不显示影响理智的交互。",
					["br"] = "Não exibirá interações de sanidade.",
					["es"] = nil,
					["ru"] = "Взаимодействия с рассудком не показываются",
					["ko"] = "정신력 상호작용이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "是",
					["br"] = "Ativado",
					["es"] = nil,
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display sanity interactions.",
					["zh"] = "显示影响理智的交互。",
					["br"] = "Irá exibir interações de sanidade.",
					["es"] = nil,
					["ru"] = "Взаимодействия с рассудком показываются",
					["ko"] = "정신력 상호작용이 표시됩니다.",
				},
			},
		},
	},
	display_mob_attack_damage = {
		label = {
			"Mob Attack Damage", 
			["zh"] = "怪物攻击范围", 
			["br"] = "Dano de Ataque de Mobs", 
			["es"] = "Daño de ataque de mobs",
			["ru"] = "Урон атаки мобов",
			["ko"] = "적 공격 데미지",
		},
		hover = {
			"Whether mob attack damage is shown.", 
			["zh"] = "是否显示怪物的攻击范围。", 
			["br"] = "Se o dano de ataque de mobs é mostrado.", 
			["es"] = "Configura si se muestra el daño de ataque de mobs.",
			["ru"] = "Показывать ли урон атаки мобов",
			["ko"] = "적의 공격 데미지를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Mob attack damage is not shown.",
					["zh"] = "不显示怪物的攻击范围。",
					["br"] = "Dano de ataque dos mobs não é mostrado.",
					["es"] = "No se muestra el daño de ataque de mobs.",
					["ru"] = "Урон атаки мобов не показывается",
					["ko"] = "적의 공격 데미지가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Mob attack damage is shown.",
					["zh"] = "显示怪物的攻击范围。",
					["br"] = "Dano de ataque dos mobs é mostrado.",
					["es"] = "Se muestra el daño de ataque de mobs.",
					["ru"] = "Урон атаки мобов показывается",
					["ko"] = "적의 공격 데미지가 표시됩니다.",
				},
			},
		},
	},
	growth_verbosity = {
		label = {
			"Growth Verbosity", 
			["zh"] = "植物生长阶段", 
			["br"] = "Verbosidade do Crescimento", 
			["es"] = "Verbosidad de crecimiento",
			["ru"] = "Детализация роста",
			["ko"] = "성장 정보",
		},
		hover = {
			"How detailed growth information should be.", 
			["zh"] = "显示植物生长的具体信息。", 
			["br"] = "Como as informações de crescimento detalhadas devem ser exibidas.", 
			["es"] = "Configura cómo de detallada es la información sobre el crecimiento de entidades.",
			["ru"] = "Как детально должна быть информация о росте",
			["ko"] = "성장 정보를 얼마나 자세히 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Nula",
					["ru"] = "Нет",
					["ko"] = "표시 안함",
				},
				hover = {
					"Displays nothing about growable entities.",
					["zh"] = "不显示会生长的物品的信息。",
					["br"] = "Não exibe nada sobre entidades cultiváveis.",
					["es"] = "No muestra nada sobre las entidades que pueden crecer.",
					["ru"] = "Не показывает ничего о растущих объектах",
					["ko"] = "성장 가능한 개체의 정보가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Minimal",
					["zh"] = "简短",
					["br"] = "Mínima",
					["es"] = "Mínima",
					["ru"] = "Минимальная",
					["ko"] = "최소",
				},
				hover = {
					"Displays time until next stage.",
					["zh"] = "仅显示生长到下一阶段所需的时间。",
					["br"] = "Exibe o tempo até o próximo estágio.",
					["es"] = "Muestra el tiempo hasta la siguiente etapa.",
					["ru"] = "Показывает время до следующей стадии",
					["ko"] = "다음 단계까지 남은 시간이 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "详细",
					["br"] = "Tudo",
					["es"] = "Completa",
					["ru"] = "Полная",
					["ko"] = "모두",
				},
				hover = {
					"Displays current stage name, number of stages, and time until next stage.",
					["zh"] = "显示当前阶段名称，阶段的数字，长到下一阶段所需的时间。",
					["br"] = "Exibe o nome do estágio atual, número de estágios e tempo até o próximo estágio.",
					["es"] = "Muestra el nombre de la etapa actual, el número de etapas y el tiempo hasta la siguiente etapa.",
					["ru"] = "Показывает название текущей стадии, количество стадий и время до следующей стадии",
					["ko"] = "현재 성장 단계, 총 단계의 수, 다음 단계까지 남은 시간이 표시됩니다.",
				},
			},
		},
	},
	display_pickable = {
		label = {
			"Pickable Information", 
			["zh"] = "可采集信息", 
			["br"] = "Informações selecionáveis", 
			["es"] = "Información de recolección",
			["ru"] = "Информация о сборе",
			["ko"] = "채집 정보",
		},
		hover = {
			"Whether pickable information should be shown (ex: Berry Bushes)", 
			["zh"] = "是否显示可采集信息 (如：浆果丛)", 
			["br"] = "Se as informações selecionáveis devem ser mostradas (ex: Berry Bushes).", 
			["es"] = "Configura si se muestra la información seleccionable (por ej., arbustos de bayas)",
			["ru"] = "Показывать ли информацию о сборе (например, кусты ягод)",
			["ko"] = "채집 정보를 표시할지 선택합니다. (ex: 베리 덤불)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Pickable information will not be displayed.",
					["zh"] = "不显示可采集信息。",
					["br"] = "Informações selecionáveis não são exibidas.",
					["es"] = "No se muestra la información de recolección.",
					["ru"] = "Информация о сборе не показывается",
					["ko"] = "채집 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Pickable information will be displayed.",
					["zh"] = "显示可采集信息。",
					["br"] = "Informações selecionáveis são exibidas.",
					["es"] = "Se muestra la información seleccionable.",
					["ru"] = "Информация о сборе показывается",
					["ko"] = "채집 정보가 표시됩니다.",
				},
			},
		},
	},
	display_harvestable = {
		label = {
			"Harvestable Information", 
			["zh"] = "可收获信息", 
			["br"] = "Informações de colheitas", 
			["es"] = "Información de cosecha",
			["ru"] = "Информация о сборе",
			["ko"] = "수확 정보",
		},
		hover = {
			"Whether harvestable information should be shown (ex: Bee Boxes)", 
			["zh"] = "是否显示可收获信息 (如：蜂箱)", 
			["br"] = "Se as informações de colheita devem ser mostradas (ex: Bee Boxes).", 
			["es"] = "Configura si se muestra la información cosechable (por ej., cajas de abejas)",
			["ru"] = "Показывать ли информацию о сборе (например, пчелиные ульи)",
			["ko"] = "수확 정보를 표시할지 선택합니다. (ex: 벌통)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Harvestable information will not be displayed.",
					["zh"] = "不显示可收获信息。",
					["br"] = "Informações de colheitas não são exibidas.",
					["es"] = "No se muestra la información de cosecha.",
					["ru"] = "Информация о сборе не показывается",
					["ko"] = "수확 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Harvestable information will be displayed.",
					["zh"] = "显示可收获信息。",
					["br"] = "Informações de colheitas são exibidas.",
					["es"] = "Se muestra la información de cosecha.",
					["ru"] = "Информация о сборе показывается",
					["ko"] = "수확 정보가 표시됩니다.",
				},
			},
		},
	},
	display_finiteuses = {
		label = {
			"Tool Durability", 
			["zh"] = "工具耐久度", 
			["br"] = "Durabilidade da Ferramenta", 
			["es"] = "Durabilidad de herramientas",
			["ru"] = "Прочность инструментов",
			["ko"] = "도구 내구도",
		},
		hover = {
			"Whether tool durability is displayed.", 
			["zh"] = "是否显示工具的耐久度。", 
			["br"] = "Se a durabilidade da ferramenta é exibida.", 
			["es"] = "Configura si se muestra la durabilidad de herramientas.",
			["ru"] = "Показывать ли прочность инструментов",
			["ko"] = "도구 내구도를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Tool durability will not be displayed.",
					["zh"] = "不显示工具的耐久度。",
					["br"] = "A durabilidade da ferramenta não será exibida.",
					["es"] = "No se muestra la durabilidad de las herramientas.",
					["ru"] = "Прочность инструментов не показывается",
					["ko"] = "도구 내구도가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Tool durability will be displayed.",
					["zh"] = "显示工具的耐久度。",
					["br"] = "A durabilidade da ferramenta será exibida.",
					["es"] = "Se muestra la durabilidad de las herramientas.",
					["ru"] = "Прочность инструментов показывается",
					["ko"] = "도구 내구도가 표시됩니다.",
				},
			},
		},
	},
	display_timers = {
		label = {
			"Timers", 
			["zh"] = "计时器", 
			["br"] = "Temporizadores", 
			["es"] = "Temporizadores",
			["ru"] = "Таймеры",
			["ko"] = "타이머",
		},
		hover = {
			"Whether timer information is displayed.", 
			["zh"] = "是否开启计时器。", 
			["br"] = "Se as informações do temporizador são exibidas.", 
			["es"] = "Configura si se muestra temporizadores de eventos.",
			["ru"] = "Показывать ли информацию о таймерах",
			["ko"] = "타이머 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Timers will not be displayed.",
					["zh"] = "关闭计时器。",
					["br"] = "Temporizadores não são exibidos.",
					["es"] = "No se muestra temporizadores.",
					["ru"] = "Таймеры не показываются",
					["ko"] = "타이머가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Timers will be displayed.",
					["zh"] = "开启计时器。",
					["br"] = "Temporizadores são exibidos.",
					["es"] = "Se muestra temporizadores.",
					["ru"] = "Таймеры показываются",
					["ko"] = "타이머가 표시됩니다.",
				},
			},
		},
	},
	display_upgradeable = {
		label = {
			"Upgradeables", 
			["zh"] = "可升级物品显示", 
			["br"] = "Atualizáveis", 
			["es"] = "Etapas",
			["ru"] = "Обновляемые",
			["ko"] = "업그레이드",
		},
		hover = {
			"Whether upgradeable information is displayed.", 
			["zh"] = "是否显示可升级物品信息。", 
			["br"] = "Se as informações de atualizáveis são exibidas.", 
			["es"] = "Configura si se muestra la información de etapas en estructuras (árboles, nidos de araña, etc.)",
			["ru"] = "Показывать ли информацию об обновляемых объектах",
			["ko"] = "업그레이드 정보를 표시할지 선택합니다. (ex: 거미집)",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not display information for upgradeable structures.",
					["zh"] = "不显示可升级的建筑等物品的信息。",
					["br"] = "Não exibe informações de estruturas atualizáveis",
					["es"] = "No muestra información de etapas.",
					["ru"] = "Информация об обновляемых объектах не показывается",
					["ko"] = "업그레이드 가능한 구조물의 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Displays information for upgradeable structures, such as spider dens.",
					["zh"] = "显示可升级的物品的信息，如蜘蛛巢等。",
					["br"] = "Exibe informações de estruturas atualizáveis, como ninhos de aranhas.",
					["es"] = "Muestra información de etapas.",
					["ru"] = "Показывает информацию об обновляемых объектах, таких как паучьи гнезда",
					["ko"] = "업그레이드 가능한 구조물의 정보가 표시됩니다.",
				},
			},
		},
	},
	naughtiness_verbosity = {
		label = {
			"Naughtiness verbosity", 
			["zh"] = "淘气值", 
			["br"] = "Verbalidade das travessuras", 
			["es"] = "Verbosidad de maldad",
			["ru"] = "Детализация непослушности",
			["ko"] = "악행",
		},
		hover = {
			"How verbose the naughtiness information should be. Combined Status takes precedence for player naughtiness.", 
			["zh"] = "如何显示淘气值。Combined Status 模组的淘气值显示优先于本模组。", 
			["br"] = "Quão verbosa deve ser a informação de travessuras. O Combined Status tem precedência para as travessuras do jogador.", 
			["es"] = "Elige como es de detallada la información de maldad. Combined Status tiene prioridad sobre Insight.",
			["ru"] = "Как подробно должна быть информация о непослушности. Combined Status имеет приоритет для непослушности игрока.",
			["ko"] = "악행 정보를 어떻게 표시할지 선택합니다. Combined Status 모드가 우선 적용됩니다.",
		},
		options = {
			[0] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Most naughtiness values will not display.",
					["zh"] = "不显示淘气值。",
					["br"] = "A maioria dos valores de travessuras não são exibidos.",
					["es"] = "La mayoría de valores de maldad no se mostrarán.",
					["ru"] = "Большинство значений непослушности не показываются",
					["ko"] = "악행 점수가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Creature",
					["zh"] = "生物的淘气值",
					["br"] = "Criatura",
					["es"] = "Criatura",
					["ru"] = "Существо",
					["ko"] = "생물",
				},
				hover = {
					"Creature naughtiness values will display.",
					["zh"] = "显示击杀生物的淘气值。",
					["br"] = "Os valores de travessuras da criatura são exibidos.",
					["es"] = "Se mostrarán los valores de maldad de los mobs.",
					["ru"] = "Показываются значения непослушности существ",
					["ko"] = "생물 악행 값이 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"Plr/Creature",
					["zh"] = "玩家/生物的淘气值",
					["br"] = "Plr/Criatura",
					["es"] = "Jgd/Criatura",
					["ru"] = "Игрок/Существо",
					["ko"] = "플레이어/생물",
				},
				hover = {
					"Player and creature naughtiness values will display.",
					["zh"] = "同时显示玩家已有的淘气值和击杀生物的淘气值。",
					["br"] = "Os valores de travessuras do jogador e da criatura são exibidos.",
					["es"] = "Se mostrarán los valores de maldad de jugadores y mobs.",
					["ru"] = "Показываются значения непослушности игрока и существ",
					["ko"] = "플레이어와 생물 악행 값이 표시됩니다.",
				},
			},
		},
	},
	follower_info = {
		label = {
			"Followers", 
			["zh"] = "随从信息", 
			["br"] = "Seguidores", 
			["es"] = "Seguidores",
			["ru"] = "Следователи",
			["ko"] = "추종자",
		},
		hover = {
			"Whether follower information is displayed.", 
			["zh"] = "是否显示你的跟随者的信息。", 
			["br"] = "Se as informações dos seguidores são exibidas.", 
			["es"] = "Configura si se muestra la información de seguidores (Chester, Gloomer, etc.)",
			["ru"] = "Показывать ли информацию о следователях (Честер, Глумер и т. д.)",
			["ko"] = "추종자 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display follower information.",
					["zh"] = "不显示跟随者的信息。",
					["br"] = "Não exibirá informações de seguidores.",
					["es"] = "No mostrará información de los seguidores.",
					["ru"] = "Информация о следователях не показывается",
					["ko"] = "추종자 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display follower information.",
					["zh"] = "显示跟随者的信息。",
					["br"] = "Mostrará informações de seguidores.",
					["es"] = "Muestra información de los seguidores.",
					["ru"] = "Информация о следователях показывается",
					["ko"] = "추종자 정보가 표시됩니다.",
				},
			},
		},
	},
	herd_information = {
		label = {
			"Herds", 
			["zh"] = "兽群信息", 
			["br"] = "Rebanhos", 
			["es"] = "Manadas",
			["ru"] = "Стада",
			["ko"] = "무리",
		},
		hover = {
			"Whether herd information is displayed.", 
			["zh"] = "是否显示兽群的信息。", 
			["br"] = "Se as informações de rebanhos são exibidas.", 
			["es"] = "Configura si se muestra información de la manada.",
			["ru"] = "Показывать ли информацию о стадах",
			["ko"] = "무리 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display herd information.",
					["zh"] = "不显示兽群的信息。",
					["br"] = "Não exibirá informações dos rebanhos.",
					["es"] = "No muestra información de la manada.",
					["ru"] = "Информация о стадах не показывается",
					["ko"] = "무리 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display herd information.",
					["zh"] = "显示兽群的信息。",
					["br"] = "Mostrará informações de rebanhos.",
					["es"] = "Muestra información de la manada.",
					["ru"] = "Информация о стадах показывается",
					["ko"] = "무리 정보가 표시됩니다.",
				},
			},
		},
	},
	domestication_information = {
		label = {
			"Domestication", 
			["zh"] = "牛驯服度", 
			["br"] = "Domesticação", 
			["es"] = "Domesticación",
			["ru"] = "Одомашнивание",
			["ko"] = "비팔로 길들이기 정보",
		},
		hover = {
			"Whether domestication information is displayed.", 
			["zh"] = "是否显示牛的驯服度。", 
			["br"] = "Se as informações de domesticação são exibidas.", 
			["es"] = "Configura si muestra información de domesticación.",
			["ru"] = "Показывать ли информацию об одомашнивании",
			["ko"] = "길들이기 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display domestication information.",
					["zh"] = "不显示牛的驯服度信息。",
					["br"] = "Não exibirá informações de domesticação.",
					["es"] = "No muestra información de domesticación.",
					["ru"] = "Информация об одомашнивании не показывается",
					["ko"] = "길들이기 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display domestication information.",
					["zh"] = "显示牛的驯服度信息。",
					["br"] = "Mostrará informações de domesticação.",
					["es"] = "Muestra información sobre la domesticación.",
					["ru"] = "Информация об одомашнивании показывается",
					["ko"] = "길들이기 정보가 표시됩니다.",
				},
			},
		},
	},
	display_pollination = {
		label = {
			"Pollination", 
			["zh"] = "授粉信息", 
			["br"] = "Polinização", 
			["es"] = "Polinización",
			["ru"] = "Опыление",
			["ko"] = "꽃 수분(受粉)",
		},
		hover = {
			"Whether pollination information is displayed.", 
			["zh"] = "是否显示蜜蜂、蝴蝶的授粉信息。", 
			["br"] = "Se as informações de polinização são exibidas.", 
			["es"] = "Configura si se muestra información de polinización.",
			["ru"] = "Показывать ли информацию об опылении",
			["ko"] = "벌과 나비의 꽃 수분 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
					["ru"] = "Отключено",
					["ko"] = "표시 안함",
				},
				hover = {
					"Will not display pollination information.",
					["zh"] = "不显示授粉信息。",
					["br"] = "Não exibirá informações de polinização.",
					["es"] = "No muestra información sobre la polinización.",
					["ru"] = "Информация об опылении не показывается",
					["ko"] = "수분 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
					["ru"] = "Включено",
					["ko"] = "표시",
				},
				hover = {
					"Will display pollination information.",
					["zh"] = "显示授粉信息。",
					["br"] = "Mostrará informações de polinização.",
					["es"] = "Muestra información sobre la polinización.",
					["ru"] = "Информация об опылении показывается",
					["ko"] = "수분 정보가 표시됩니다.",
				},
			},
		},
	},
	item_worth = {
		label = {
			"Display item worth", 
			["zh"] = "物品价值", 
			["br"] = "Exibir o valor do item", 
			["es"] = "Valor de objeto",
			["ru"] = "Показывать стоимость предмета",
			["ko"] = "아이템 가치 표시",
		},
		hover = {
			"Whether item worth is displayed.", 
			["zh"] = "是否会显示物品的黄金或金币价值。", 
			["br"] = "Se o valor de itens que valem ouro/dubloon é exibido.", 
			["es"] = "Configura si muestra el valor de un objeto (oro y doblones).",
			["ru"] = "Показывать ли стоимость предмета",
			["ko"] = "아이템 가치를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not display gold or dubloon value.",
					["zh"] = "不显示物品的价值。",
					["br"] = "Não exibirá o valor de ouro ou dubloon.",
					["es"] = "No mostrará ningún valor.",
					["ru"] = "Стоимость предмета не показывается",
					["ko"] = "금덩어리 또는 금화 가치가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Will display gold and dubloon value.",
					["zh"] = "显示物品值的价值。",
					["br"] = "Mostrará o valor do ouro e do dubloon.",
					["es"] = "Mostrará el valor en oro y doblones.",
					["ru"] = "Показывает стоимость в золоте и дублонах",
					["ko"] = "금덩어리 또는 금화 가치가 표시됩니다.",
				},
			},
		},
	},
	appeasement_value = {
		label = {
			"Display Appeasement", 
			["zh"] = "蚁狮", 
			["br"] = "Exibir Apaziguamento", 
			["es"] = "Valor de apaciguamiento",
			["ru"] = "Показывать умиротворение",
			["ko"] = "공물 가치 표시",
		},
		hover = {
			"Whether appeasement worth is displayed.", 
			["zh"] = "是否显示蚁狮献祭时间和作乱的信息。", 
			["br"] = "Se o valor do apaziguamento é exibido.", 
			["es"] = "Configura si se muestra el valor de apaciguamiento.",
			["ru"] = "Показывать ли умиротворение",
			["ko"] = "개미사자 공물 가치를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not display appeasement value.",
					["zh"] = "不显示蚁狮的信息。",
					["br"] = "Não exibirá valor de apaziguamento.",
					["es"] = "No se muestra ningún valor.",
					["ru"] = "Умиротворение не показывается",
					["ko"] = "공물 가치가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Will display appeasement value.",
					["zh"] = "显示蚁狮的信息。",
					["br"] = "Mostrará o valor de apaziguamento.",
					["es"] = "Muestra el valor de apaciguamiento.",
					["ru"] = "Умиротворение показывается",
					["ko"] = "공물 가치가 표시됩니다.",
				},
			},
		},
	},
	fuel_verbosity = {
		label = {
			"Fuel Verbosity", 
			["zh"] = "燃料", 
			["br"] = "Verbosidade do Combustível", 
			["es"] = "Verbosidad del combustible",
			["ru"] = "Детализация топлива",
			["ko"] = "연료 정보",
		},
		hover = {
			"How verbose fuel information is.", 
			["zh"] = "如何显示燃料的信息。", 
			["br"] = "Quão detalhadas são as informações de combustível.", 
			["es"] = "Configura como es de extensa es la información sobre el combustible.",
			["ru"] = "Как подробно должна быть информация о топливе",
			["ko"] = "연료 정보를 얼마나 자세히 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Ninguno",
					["ru"] = "Нет",
					["ko"] = "표시 안함",
				},
				hover = {
					"No fuel information will show.",
					["zh"] = "不显示燃料信息。",
					["br"] = "Nenhuma informação de combustível será exibida.",
					["es"] = "No se muestra ninguna información sobre el combustible.",
					["ru"] = "Информация о топливе не показывается",
					["ko"] = "연료 정보가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Standard",
					["zh"] = "标准",
					["br"] = "Padrão",
					["es"] = "Estándar",
					["ru"] = "Стандарт",
					["ko"] = "기본",
				},
				hover = {
					"Standard fuel information will show.",
					["zh"] = "显示标准的燃料信息。",
					["br"] = "Informações padrão de combustível são exibidas.",
					["es"] = "Se muestra información estándar del combustible.",
					["ru"] = "Показывается стандартная информация о топливе",
					["ko"] = "기본적인 연료 정보가 표시됩니다.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "全面",
					["br"] = "Tudo",
					["es"] = "Todo",
					["ru"] = "Полная",
					["ko"] = "모두",
				},
				hover = {
					"All fuel information will show.",
					["zh"] = "显示全面的燃料信息。",
					["br"] = "Todas as informações de combustível são exibidas.",
					["es"] = "Se muestra toda la información sobre el combustible.",
					["ru"] = "Показывается полная информация о топливе",
					["ko"] = "모든 연료 정보가 표시됩니다.",
				},
			},
		},
	},
	display_shelter_info = {
		label = {
			"Shelter Information", 
			["zh"] = "遮蔽处信息", 
			["br"] = "Informações do Abrigo", 
			["es"] = "Información del refugio",
			["ru"] = "Информация о укрытии",
			["ko"] = "피난처 정보",
		},
		hover = {
			"Whether to display shelter information.", 
			["zh"] = "是否显示遮蔽处信息。", 
			["br"] = "Se exibe informações do abrigo.", 
			["es"] = "Configura si se muestra información del refugio.",
			["ru"] = "Показывать ли информацию о укрытии",
			["ko"] = "피난처 정보를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Shelter information is not shown.",
					["zh"] = "不显示遮蔽处信息。",
					["br"] = "As informações do abrigo não são mostradas.",
					["es"] = "No se muestra información del refugio.",
					["ru"] = "Информация о укрытии не показывается",
					["ko"] = "피난처 정보가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Shelter information is shown.",
					["zh"] = "显示遮蔽处信息。",
					["br"] = "As informações do abrigo são mostradas.",
					["es"] = "Se muestra información del refugio.",
					["ru"] = "Информация о укрытии показывается",
					["ko"] = "피난처 정보가 표시됩니다.",
				},
			},
		},
	},
	--[[
	unique_info = {
		label = {
			"Unique Information", 
			["zh"] = "特定信息", 
			["br"] = "Informações Únicas", 
			["es"] = "Información única",
			["ru"] = "Уникальная информация",
			["ko"] = "유니크 정보",
		},
		hover = {
			"Whether to display unique information for certain entities.", 
			["zh"] = "是否显示特定实体的特定信息。", 
			["br"] = "Se vai exibir informações exclusivas para determinadas entidades.", 
			["es"] = "Configura si se muestra información única de ciertas entidades.",
			["ru"] = "Показывать ли уникальную информацию для определенных объектов",
			["ko"] = "특정 개체에 대한 유니크 정보를 표시할지 선택합니다.",
		},
		options = {
			[0] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"No unique information is shown.",
					["zh"] = "不显示特定信息。",
					["br"] = "Nenhuma informação exclusiva é mostrada",
					["es"] = "No se muestra ninguna información única.",
					["ru"] = "Уникальная информация не показывается",
					["ko"] = "유니크 정보가 표시되지 않습니다.",
				},
			},
			[1] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Unique information is shown.",
					["zh"] = "显示特定信息。",
					["br"] = "Informações exclusivas são mostradas.",
					["es"] = "Se muestra información única.",
					["ru"] = "Уникальная информация показывается",
					["ko"] = "유니크 정보가 표시됩니다.",
				},
			},
		},
	},
	--]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Miscellaneous ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	display_crafting_lookup_button = {
		label = {
			"Crafting Lookup Button", 
			["zh"] = "建造查看按钮", 
			["br"] = "Botão de pesquisa no Crafting", 
			["es"] = "Botón de búsqueda",
			["ru"] = "Кнопка поиска рецептов",
			["ko"] = "제작 찾기 버튼",
		},
		hover = {
			"Whether the crafting lookup button is displayed or not.", 
			["zh"] = "是否显示建造查看按钮", 
			["br"] = "Se o botão de pesquisa na aba de criação é exibido ou não.", 
			["es"] = "Configura si se muestra un botón de búsqueda (de creación).",
			["ru"] = "Показывать ли кнопку поиска рецептов",
			["ko"] = "제작 찾기 버튼을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The button is not shown.",
					["zh"] = "不显示按钮",
					["br"] = "O botão não é exibido.",
					["es"] = "El botón no se muestra.",
					["ru"] = "Кнопка не показывается",
					["ko"] = "버튼이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The button is shown.",
					["zh"] = "显示按钮",
					["br"] = "O botão é exibido.",
					["es"] = "Se muestra el botón.",
					["ru"] = "Кнопка показывается",
					["ko"] = "버튼이 표시됩니다.",
				},
			},
		},
	},
	display_insight_menu_button = {
		label = {
			"Insight Menu Button", 
			["zh"] = "Insight 目录按钮", 
			["br"] = "Botão do Menu Insight", 
			["es"] = "Botón menú de Insight",
			["ru"] = "Кнопка меню Insight",
			["ko"] = "Insight 모드 메뉴 버튼",
		},
		hover = {
			"Whether the insight menu button is displayed or not.", 
			["zh"] = "是否显示 Insight 目录按钮", 
			["br"] = "Se o botão do menu Insight é exibido ou não.", 
			["es"] = "Configura si se muestra el botón del menú de Insight.",
			["ru"] = "Показывать ли кнопку меню Insight",
			["ko"] = "Insight 모드 메뉴 버튼을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The button is not shown.",
					["zh"] = "不显示按钮",
					["br"] = "O botão não é exibido.",
					["es"] = "The button is not shown.",
					["ru"] = "Кнопка не показывается",
					["ko"] = "버튼이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The button is shown.",
					["zh"] = "显示按钮",
					["br"] = "O botão é exibido.",
					["es"] = "The button is shown.",
					["ru"] = "Кнопка показывается",
					["ko"] = "버튼이 표시됩니다.",
				},
			},
		},
	},
	--[[
	extended_info_indicator = {
		label = {
			"More Information Hint", 
			["zh"] = "更多信息提示", 
			["br"] = "Dica de Mais Informações", 
			["es"] = "Indicador de información extra",
			["ru"] = "Подсказка о дополнительной информации",
			["ko"] = "추가 정보 힌트",
		},
		hover = {
			"Whether an asterisk is present for entities with more information.", 
			["zh"] = "是否在有更多信息的实体上显示星号", 
			["br"] = "Se um asterisco está presente para entidades com mais informações.", 
			["es"] = "Muestra un asterisco sobre entidades con más información disponible.",
			["ru"] = "Показывать ли звездочку для объектов с дополнительной информацией",
			["ko"] = "추가 정보가 있는 개체에 대해 별표를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The indicator is not shown.",
					["zh"] = "不显示星号",
					["br"] = "O indicador não é mostrado.",
					["es"] = "El indicador no se muestra.",
					["ru"] = "Звездочка не показывается",
					["ko"] = "인디케이터가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The indicator is shown.",
					["zh"] = "显示星号",
					["br"] = "O indicador é mostrado.",
					["es"] = "Se muestra el indicador.",
					["ru"] = "Звездочка показывается",
					["ko"] = "인디케이터가 표시됩니다.",
				},
			},
		},
	},
	--]]
	info_preload = {
		label = {
			"Information preloading", 
			["zh"] = "信息预载", 
			["br"] = "Pré-carregamento de informações", 
			["es"] = "Precarga de información",
			["ru"] = "Предварительная загрузка информации",
			["ko"] = "정보 사전 로딩",
		},
		hover = {
			"Whether information is preloaded when entities become visible. Trades network usage for faster performance. Recommended to use \"All\".", 
			["zh"] = "是否预先加载可见范围内所有实体的信息。消耗更多网络以获取更好的表现。推荐使用 \"所有\"。", 
			["br"] = "Se as informações são pré-carregadas quando as entidades se tornam visíveis. Troca o uso da rede para um desempenho mais rápido. Recomendado usar \"Todos\".", 
			["es"] = "Precarga información solo cuando las entidades son visibles. Intercambia el uso de la red mejorar el rendimiento.",
			["ru"] = "Предварительная загрузка информации, когда объекты становятся видимыми. Торгует использование сети на более быстрое выполнение. Рекомендуется использовать \"Все\".",
			["ko"] = "가시 범위 내의 모든 개체에 대한 정보를 미리 로드할지 선택합니다. 더 나은 성능을 위해 더 많은 네트워크를 사용합니다. \"모두\"를 사용하는 것이 좋습니다.",
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "否",
					["br"] = "Nenhuma",
					["es"] = "Desactivado",
					["ru"] = "Нет",
					["ko"] = "사용 안함",
				},
				hover = {
					"CAN CAUSE SEVERE FPS DROPS. NOT RECOMMENDED.",
					["zh"] = "严重帧数降低，不推荐",
					["br"] = "PODE CAUSAR QUEDAS DE FPS GRAVES. NÃO RECOMENDADO.",
					["es"] = "PUEDE CAUSAR GRAVES CAÍDAS DE FPS. NO SE RECOMIENDA.",
					["ru"] = "МОЖЕТ ПРИВЕСТИ К СЕРЬЕЗНЫМ ПАДЕНИЯМ FPS. НЕ РЕКОМЕНДУЕТСЯ.",
					["ko"] = "심각한 프레임 드랍이 발생합니다. 권장하지 않습니다.",
				},
			},
			[1] = {
				description = {
					"Containers",
					["zh"] = "容器",
					["br"] = "Contêineres",
					["es"] = "En bloques",
					["ru"] = "Контейнеры",
					["ko"] = "저장소",
				},
				hover = {
					"POSSIBLE FPS DROP. NOT RECOMMENDED. CAN USE FOR SMALL, CLEAN BASES.",
					["zh"] = "小幅帧数降低，不推荐。可用于小型简单的基地。",
					["br"] = "POSSÍVEL QUEDA DE FPS. NÃO RECOMENDADO. PODE SER USADO PARA BASES PEQUENAS E LIMPAS.",
					["es"] = "Posible caída de FPS. No se recomienda. Puede usarse para bases pequeñas y limpias.",
					["ru"] = "ВОЗМОЖНОЕ ПАДЕНИЕ FPS. НЕ РЕКОМЕНДУЕТСЯ. МОЖЕТ БЫТЬ ИСПОЛЬЗОВАНО ДЛЯ МАЛЕНЬКИХ, ЧИСТЫХ БАЗ.",
					["ko"] = "프레임이 드랍될 수 있습니다. 권장하지 않습니다. 작고 깨끗한 베이스에서 사용 가능합니다.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "所有",
					["br"] = "Tudo",
					["es"] = "Activado",
					["ru"] = "Все",
					["ko"] = "모두",
				},
				hover = {
					"FASTEST. RECOMMENDED.",
					["zh"] = "最高帧率，推荐。",
					["br"] = "O MAIS RÁPIDO. RECOMENDADO.",
					["es"] = "Lo más rápido. Recomendado.",
					["ru"] = "САМЫЙ БЫСТРЫЙ. РЕКОМЕНДУЕТСЯ.",
					["ko"] = "가장 빠릅니다. 권장하는 옵션입니다.",
				},
			},
		},
	},
	refresh_delay = {
		label = {
			"Refresh delay", 
			["zh"] = "信息刷新延时", 
			["br"] = "Atraso de atualização", 
			["es"] = "Retardo de actualización",
			["ru"] = "Задержка обновления",
			["ko"] = "새로고침 지연",
		},
		hover = {
			"How often you can re-request information for the same item.", 
			["zh"] = "多久更新物品的信息。", 
			["br"] = "Com que frequência você pode solicitar novamente informações para o mesmo item.", 
			["es"] = "La frecuencia con la que puede volver a solicitar información para el mismo elemento.",
			["ru"] = "Как часто вы можете повторно запросить информацию для одного и того же элемента.",
			["ko"] = "동일한 아이템에 대한 정보를 얼마나 자주 재요청할지 선택합니다.",
		},
		options = {
			[true] = {
				description = {
					"Automatic",
					["zh"] = "自动设定",
					["br"] = "Automático",
					["es"] = "Automático",
					["ru"] = "Автоматический",
					["ko"] = "자동",
				},
				hover = {
					"Dynamicly chosen based on current performance stats.",
					["zh"] = "基于玩家和游戏性能，动态更新。",
					["br"] = "Escolhido dinamicamente com base nas estatísticas de desempenho atuais.",
					["es"] = "Cambia dinámicamente en función de las estadísticas de rendimiento actuales.",
					["ru"] = "Динамически выбирается на основе текущей производительности.",
					["ko"] = "현재 성능을 기준으로 능동적으로 선택됩니다.",
				},
			},
			[0] = {
				description = {
					"None",
					["zh"] = "实时",
					["br"] = "Nenhuma",
					["es"] = "None",
					["ru"] = "Нет",
					["ko"] = "없음(실시간)",
				},
				hover = {
					"Information is live.",
					["zh"] = "信息实时更新。",
					["br"] = "A informação é atualizada ao vivo.",
					["es"] = "La información está en vivo.",
					["ru"] = "Информация в реальном времени.",
					["ko"] = "정보를 실시간으로 업데이트합니다.",
				},
			},
			[0.25] = {
				description = {
					"0.25s",
					["zh"] = "0.25秒",
					["br"] = "0.25s",
					["es"] = "0.25s",
					["ru"] = "0.25с",
					["ko"] = "0.25초",
				},
				hover = {
					"Information updates every 0.25 seconds.",
					["zh"] = "信息每0.25秒更新。",
					["br"] = "As informações são atualizadas a cada 0,25 segundos.",
					["es"] = "La información se actualiza cada 0,25 segundos.",
					["ru"] = "Информация обновляется каждые 0.25 секунды.",
					["ko"] = "정보를 0.25초마다 업데이트합니다.",
				},
			},
			[0.5] = {
				description = {
					"0.5s",
					["zh"] = "0.5秒",
					["br"] = "0.5s",
					["es"] = "0.5s",
					["ru"] = "0.5с",
					["ko"] = "0.5초",
				},
				hover = {
					"Information updates every 0.5 seconds.",
					["zh"] = "信息每0.5秒更新。",
					["br"] = "As informações são atualizadas a cada 0,5 segundos.",
					["es"] = "La información se actualiza cada 0,5 segundos.",
					["ru"] = "Информация обновляется каждые 0.5 секунды.",
					["ko"] = "정보를 0.5초마다 업데이트합니다.",
				},
			},
			[1] = {
				description = {
					"1s",
					["zh"] = "1秒",
					["br"] = "1s",
					["es"] = "1s",
					["ru"] = "1с",
					["ko"] = "1초",
				},
				hover = {
					"Information updates every 1 second.",
					["zh"] = "信息每1秒更新。",
					["br"] = "As informações são atualizadas a cada 1 segundo.",
					["es"] = "La información se actualiza cada 1 segundo.",
					["ru"] = "Информация обновляется каждую секунду.",
					["ko"] = "정보를 1초마다 업데이트합니다.",
				},
			},
			[3] = {
				description = {
					"3s",
					["zh"] = "3秒",
					["br"] = "3s",
					["es"] = "3s",
					["ru"] = "3с",
					["ko"] = "3초",
				},
				hover = {
					"Information updates every 3 seconds.",
					["zh"] = "信息每3秒更新。",
					["br"] = "As informações são atualizadas a cada 3 segundos.",
					["es"] = "La información se actualiza cada 3 segundos.",
					["ru"] = "Информация обновляется каждые 3 секунды.",
					["ko"] = "정보를 3초마다 업데이트합니다.",
				},
			},
		},
	},
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Debugging ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	crash_reporter = {
		label = {
			"Crash Reporter", 
			["zh"] = "崩溃报告器", 
			["br"] = "Crash Reporter", 
			["es"] = "Reporte de fallos",
			["ru"] = "Отчет об ошибках",
			["ko"] = "충돌 보고",
		},
		hover = {
			"**Attempts** to report your crashes (debug, mods, world info) automatically to my server.", 
			["zh"] = "**尝试**自动上报你的崩溃（调试情况，模组，世界信息）至我的服务器。", 
			["br"] = "**Tentativas** de relatar suas falhas (depuração, mods, informações do mundo) automaticamente para meu servidor.", 
			["es"] = "**Intenta** reportar los crasheos (depuración, mods, información del mundo) automáticamente.",
			["ru"] = "**Пытается** автоматически отправить отчеты о ваших ошибках (отладка, моды, информация о мире) на мой сервер.",
			["ko"] = "**시범적** 당신의 충돌(디버그, 모드, 세계 정보)을 자동으로 서버에 보고할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"The crash reporter is disabled.",
					["zh"] = "关闭崩溃报告器。",
					["br"] = "O relator de falhas está desabilitado.",
					["es"] = "Reporte de fallos desactivado.",
					["ru"] = "Отчет об ошибках отключен.",
					["ko"] = "충돌 보고를 사용하지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"The crash reporter is enabled.",
					["zh"] = "开启崩溃报告器。",
					["br"] = "O relator de falhas está ativado.",
					["es"] = "Reporte de fallos activado.",
					["ru"] = "Отчет об ошибках включен.",
					["ko"] = "충돌 보고를 사용합니다.",
				},
			},
		},
	},
	DEBUG_SHOW_NOTIMPLEMENTED = {
		label = {
			"DEBUG_SHOW_NOTIMPLEMENTED", 
			["zh"] = "执行调试显示信息", 
			["br"] = "DEBUG_SHOW_NOTIMPLEMENTED", 
			["es"] = "DEBUG_SHOW_NOTIMPLEMENTED",
			["ru"] = "DEBUG_SHOW_NOTIMPLEMENTED",
			["ko"] = "DEBUG_SHOW_NOTIMPLEMENTED",
		},
		hover = {
			"Displays a warning if a component is not accounted for, and the origin if it is from a mod.", 
			["zh"] = "如果游戏内元件来源未明，错误自于某个模组时，发出警告并显示其来源。", 
			["br"] = "Exibe um aviso se um componente não for contabilizado, e a origem se for de um mod.", 
			["es"] = "Muestra una advertencia si algún componente no fue registrado, y si el origen es de un mod.",
			["ru"] = "Показывает предупреждение, если компонент не учтен, и его происхождение, если он из мода.",
			["ko"] = "게임 내 구성요소의 소스를 알 수 없으면 경고를 표시하거나 오류가 모드에서 발생한 경우 출처를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not warn if there are any components not accounted for.",
					["zh"] = "未找出错误原因时，不发出警告。",
					["br"] = "Não avisará se houver algum componente não contabilizado",
					["es"] = "No muestra una advertencia si hay algún componente no registrado.",
					["ru"] = "Не предупреждает, если есть компоненты, которые не учтены.",
					["ko"] = "알 수 없는 구성요소가 있으면 경고가 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Will warn you if there are any components not accounted for.",
					["zh"] = "未找出错误原因时，发出警告。",
					["br"] = "Irá avisá-lo se houver algum componente não contabilizado.",
					["es"] = "Muestra una advertencia si hay algún componente no registrado.",
					["ru"] = "Предупреждает, если есть компоненты, которые не учтены.",
					["ko"] = "알 수 없는 구성요소가 있으면 경고가 표시됩니다.",
				},
			},
		},
	},
	DEBUG_SHOW_DISABLED = {
		label = {
			"DEBUG_SHOW_DISABLED", 
			["zh"] = "禁用调试显示", 
			["br"] = "DEBUG_SHOW_DISABLED", 
			["es"] = "DEBUG_SHOW_DISABLED",
			["ru"] = "DEBUG_SHOW_DISABLED",
			["ko"] = "DEBUG_SHOW_DISABLED",
		},
		hover = {
			"Shows warnings for components I have manually disabled.", 
			["zh"] = "发出警告，显示我手动禁用的组件。", 
			["br"] = "Mostra avisos para componentes que desativei manualmente.", 
			["es"] = "Muestra una advertencia de los componentes que se desactivaron manualmente.",
			["ru"] = "Показывает предупреждения для компонентов, которые я вручную отключил.",
			["ko"] = "수동으로 비활성화한 구성 요소에 대한 경고를 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not display information for disabled descriptors.",
					["zh"] = "不显示已禁用的描述符的信息。",
					["br"] = "Não exibirá informações para descritores desabilitados.",
					["es"] = "No muestra información de componentes deshabilitados.",
					["ru"] = "Не показывает информацию для отключенных дескрипторов.",
					["ko"] = "비활성화된 구성요소에 대한 정보를 표시하지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Will display information for disabled descriptors.",
					["zh"] = "显示已禁用的描述符的信息。",
					["br"] = "Exibirá informações para descritores desabilitados.",
					["es"] = "Muestra información de componentes deshabilitados.",
					["ru"] = "Показывает информацию для отключенных дескрипторов.",
					["ko"] = "비활성화된 구성요소에 대한 정보를 표시하지 않습니다.",
				},
			},
		},
	},
	DEBUG_SHOW_PREFAB = {
		label = {
			"DEBUG_SHOW_PREFAB", 
			["zh"] = "预设调试显示", 
			["br"] = "DEBUG_SHOW_PREFAB", 
			["es"] = "DEBUG_SHOW_PREFAB",
			["ru"] = "DEBUG_SHOW_PREFAB",
			["ko"] = "DEBUG_SHOW_PREFAB",
		},
		hover = {
			"Displays prefab name on entities.", 
			["zh"] = "在物品上显示实体的预设名称。", 
			["br"] = "Exibe o nome do prefab nas entidades.", 
			["es"] = "Muestra el nombre de prefab en las entidades.",
			["ru"] = "Показывает имя префаба на объектах.",
			["ko"] = "개체의 콘솔명을 표시할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Will not display prefabs on entity.",
					["zh"] = "不显示物品的预设名称。",
					["br"] = "Não exibirá prefabs nas entidades.",
					["es"] = "No muestra el prefab (código) en la entidad.",
					["ru"] = "Не показывает префабы на объектах.",
					["ko"] = "개체의 콘솔명이 표시되지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Will display prefabs on entity.",
					["zh"] = "显示物品的预设名称。",
					["br"] = "Mostrará prefabs nas entidades.",
					["es"] = "Muestra el prefab (código) en la entidad.",
					["ru"] = "Показывает префабы на объектах.",
					["ko"] = "개체의 콘솔명이 표시됩니다.",
				},
			},
		},
	},
	DEBUG_ENABLED = {
		label = {
			"DEBUG_ENABLED", 
			["zh"] = "开启调试功能", 
			["br"] = "DEBUG_ENABLED", 
			["es"] = "DEBUG_ENABLED",
			["ru"] = "DEBUG_ENABLED",
			["ko"] = "DEBUG_ENABLED",
		},
		hover = {
			"Puts you in Insight's Debug Mode.", 
			["zh"] = "打开你的 Insight 调试功能。", 
			["br"] = "Coloca você no modo de depuração do Insight.", 
			["es"] = "Configura el modo de depuración de Insight.",
			["ru"] = "Включает режим отладки Insight.",
			["ko"] = "Insight 디버깅 모드를 활성화할지 선택합니다.",
		},
		options = {
			[false] = {
				description = COMMON_STRINGS.NO.DESCRIPTION,
				hover = {
					"Insight will not show debugging information.",
					["zh"] = "不显示调试信息",
					["br"] = "O Insight não mostrará informações de depuração.",
					["es"] = "Insight no muestra información de depuración.",
					["ru"] = "Insight не покажет отладочную информацию",
					["ko"] = "Insight가 디버깅 정보를 표시하지 않습니다.",
				},
			},
			[true] = {
				description = COMMON_STRINGS.YES.DESCRIPTION,
				hover = {
					"Insight will show debugging information.",
					["zh"] = "显示调试信息",
					["br"] = "O Insight mostrará informações de depuração.",
					["es"] = "Insight muestra información de depuración.",
					["ru"] = "Insight покажет отладочную информацию",
					["ko"] = "Insight가 디버깅 정보를 표시합니다.",
				},
			},
		},
	},
}



--=============================================================================================================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=============================================================================================================================================================================================================================================

description = string_format("[%s] %s\n%s\n%s: %s\n%s: %s\n%s\n%s", 
	--locale or "?", tostring(folder_name), tostring(IsDST),
	(locale) or T(STRINGS["ds_not_enabled"]), 
	T(STRINGS["mod_explanation"]), 
	T(STRINGS["config_disclaimer"]), 

	T(STRINGS["version"]), version, 
	T(STRINGS["latest_update"]), ( IsDST and T(STRINGS["update_info"]) or T(STRINGS["update_info_ds"]) ), 

	T(STRINGS["crashreporter_info"]),

	(IsDST and T(STRINGS["config_paths"]) or "")
)


configuration_options = {
	AddSectionTitle(T(STRINGS["sectiontitle_formatting"])),
	{
		name = "language", -- name of option -- header for option in dst
		options = {
			{data = "automatic"},
			{data = "en"},
			{data = "zh"},
			{data = "br"},
			{data = "es"},
			{data = "ru"},
			{data = "ko"},
		}, 
		default = "automatic",
		client = true,
		tags = {},
	},
	{
		name = "info_style",
		options = {
			{data = "text"},
			{data = "icon"},
		}, 
		default = "text",
		client = true,
		tags = {},
	},
	{
		name = "text_coloring",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "insight_font",
		options = GenerateOptionsFromList(true, FONTS),
		default = FONTS[1],
		client = true,
		tags = {},
	},
	{
		name = "hoverer_insight_font_size",
		options = GenerateFontSizeOptions(FONT_SIZE.INSIGHT.HOVERER),
		default = FONT_SIZE.INSIGHT.HOVERER[2],
		client = true,
		tags = {},
	},
	{
		name = "inventorybar_insight_font_size",
		options = GenerateFontSizeOptions(FONT_SIZE.INSIGHT.INVENTORYBAR),
		default = FONT_SIZE.INSIGHT.INVENTORYBAR[2],
		client = true,
		tags = {},
	},
	{
		name = "followtext_insight_font_size",
		options = GenerateFontSizeOptions(FONT_SIZE.INSIGHT.FOLLOWTEXT),
		default = FONT_SIZE.INSIGHT.FOLLOWTEXT[2],
		client = true,
		tags = {},
	},
	{
		name = "hoverer_line_truncation",
		options = GenerateOptionsFromList(true, HOVERER_TRUNCATION_AMOUNTS), 
		default = HOVERER_TRUNCATION_AMOUNTS[1],
		client = true,
		tags = {},
	},
	{
		name = "alt_only_information",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	--[[
	{
		name = "alt_only_is_verbose",
		options = {
			{data = false},
			{data = true}
		},
		default = false,
		client = true,
		tags = {},
	},
	--]]
	{
		name = "itemtile_display",
		options = {
			{data = "none"},
			{data = "numbers"},
			{data = "percentages"},
			{data = "mixed"}
		}, 
		default = "percentages",
		client = true,
		tags = {},
	},
	{
		name = "time_style",
		options = {
			{data = "gametime"},
			{data = "realtime"},
			{data = "both"},
			{data = "gametime_short"},
			{data = "realtime_short"},
			{data = "both_short"},
			--{data = "none"},
		}, 
		default = "realtime_short",
		client = true,
		tags = {},
	},
	{
		name = "temperature_units",
		options = {
			{data = "game"},
			{data = "celsius"},
			{data = "fahrenheit"},
		}, 
		default = "game",
		client = true,
		tags = {},
	},
	{
		name = "highlighting",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "experimental_highlighting",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "highlighting_darkness",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "highlighting_color",
		options = {
			{data = "RED"},
			{data = "GREEN"},
			{data = "BLUE"},
			{data = "LIGHT_BLUE"},
			{data = "PURPLE"},
			{data = "YELLOW"},
			{data = "WHITE"},
			{data = "ORANGE"},
			{data = "PINK"},
		}, 
		default = "GREEN",
		client = true,
		tags = {},
	},
	{
		name = "fuel_highlighting",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "fuel_highlighting_color",
		options = {
			{data = "RED"},
			{data = "GREEN"},
			{data = "BLUE"},
			{data = "LIGHT_BLUE"},
			{data = "PURPLE"},
			{data = "YELLOW"},
			{data = "WHITE"},
			{data = "ORANGE"},
			{data = "PINK"},
		}, 
		default = "RED",
		client = true,
		tags = {},
	},
	AddSectionTitle(T(STRINGS["sectiontitle_indicators"])),
	{
		name = "display_attack_range",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "attack_range_type",
		options = {
			{data = "hit"},
			{data = "attack"},
			{data = "both"},
		},
		default = "hit",
		client = true,
		tags = {"undefined"},
	},
	{
		name = "hover_range_indicator",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "boss_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "miniboss_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "notable_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "pipspook_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"dst_only"},
	},
	{
		name = "bottle_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "suspicious_marble_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "death_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"dst_only"},
	},
	{
		name = "hunt_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	}, 
	{
		name = "orchestrina_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "tumbleweed_info",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "lightningrod_range",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 1,
		client = true,
		tags = {},
	},
	{
		name = "blink_range",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "wortox_soul_range",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {"dst_only"},
	},
	{
		name = "battlesong_range",
		options = {
			{data = "none"},
			{data = "detach"},
			{data = "attach"},
			{data = "both"},
		}, 
		default = "both",
		client = true,
		tags = {"dst_only"},
	},
	{
		name = "klaus_sack_markers",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "sinkhole_marks",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 2,
		client = true,
		tags = {"dst_only"},
	},
	AddSectionTitle(T(STRINGS["sectiontitle_foodrelated"])),
	{
		name = "display_food",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "food_style",
		options = {
			{data = "short"},
			{data = "long"},	
		}, 
		default = "long",
		client = true,
		tags = {},
	},
	{
		name = "food_order",
		options = {
			{data = "interface"},
			{data = "wiki"},
		}, 
		default = "interface",
		client = true,
		tags = {},
	},
	{
		name = "food_units",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "food_effects",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "stewer_chef",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined", "dst_only"},
	},
	{
		name = "food_memory",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {"undefined", "dst_only"},
	},
	{
		name = "display_perishable",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	AddSectionTitle(T(STRINGS["sectiontitle_informationcontrol"])),
	{
		name = "display_cawnival",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_yotb_winners",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_yotb_appraisal",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_shared_stats",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_worldmigrator",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"undefined"},
	},
	{
		name = "display_unwrappable",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_simplefishing",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_oceanfishing",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_tackle_information",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_spawner_information",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "weapon_damage",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "armor",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "repair_values",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"undefined"},
	},
	{
		name = "klaus_sack_info",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "soil_moisture",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
			{data = 3},
			{data = 4},
		},
		default = 2,
		client = true,
		tags = {"dst_only"},
	},
	{
		name = "soil_nutrients",
		options = {
			--{data = 0},
			{data = 1},
			{data = 2},
			{data = 3},
			--{data = 4},
		},
		default = 2,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "soil_nutrients_needs_hat",
		options = {
			{ data = "off" },
			{ data = "hatonly" },
			{ data = "always" },
		},
		default = "always",
		tags = { "dst_only", "undefined" },
	},
	{
		name = "display_plant_stressors",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		},
		default = 2,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_fertilizer",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_compostvalue",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_weighable",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_gyminfo",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_world_events",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "danger_announcements",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_shadowthrall_information",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		},
		default = 1,
		tags = {"undefined"},
	},
	{
		name = "display_batwave_information",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_itemmimic_information",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		},
		default = 0,
		tags = {"undefined"},
	},
	{
		name = "display_rabbitking_information",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_weather",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 2,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "weather_detail",
		options = {
			{data = 0},
			{data = 1},
		}, 
		default = 0,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "nightmareclock_display",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 2,
		tags = {"undefined"},
	},
	{
		name = "wx78_scanner_info",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "display_health",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_hunger",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 1,
		tags = {"undefined"},
	},
	{
		name = "display_sanity",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_sanityaura",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_sanity_interactions",
		options = {
			{ data = false },
			{ data = true },
		},
		default = false,
		tags = { "undefined" },
	},
	{
		name = "display_mob_attack_damage",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "growth_verbosity",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 1,
		tags = {"undefined"},
	},
	{
		name = "display_pickable",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {},
	},
	{
		name = "display_harvestable",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {},
	},
	{
		name = "display_finiteuses",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "display_timers",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_upgradeable",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "naughtiness_verbosity",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 2,
		tags = {"undefined"},
	},
	{
		name = "follower_info",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "herd_information",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "domestication_information",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_pollination",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
	},
	{
		name = "item_worth",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "appeasement_value",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "fuel_verbosity",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 2,
		tags = {"undefined"},
	},
	{
		name = "display_shelter_info",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"undefined"},
	},
	--[[
	{
		name = "unique_info",
		options = {
			{data = 0},
			{data = 1},
		}, 
		default = 1,
		tags = {"undefined"},
	},
	--]]
	AddSectionTitle(T(STRINGS["sectiontitle_miscellaneous"])),
	{
		name = "display_crafting_lookup_button",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "display_insight_menu_button",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	--[[
	{
		name = "extended_info_indicator",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	--]]
	--[[
	{
		name = "unrandomizer",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		tags = {"server_only"},
	},
	--]]
	--[[
	{
		name = "account_combat_modifiers",
		options = {
			{data = false},
			{data = true},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	--]]
	{
		name = "info_preload",
		options = {
			{data = 0},
			{data = 1},
			{data = 2},
		},
		default = 2,
		tags = {"undefined"},
	},
	{
		name = "refresh_delay",
		options = {
			{data = true},
			{data = 0},
			--{data = 0.1},
			{data = 0.25},
			{data = 0.5},
			{data = 1},
			{data = 3},
		},
		default = true,
		tags = {"undefined"},
	},
	AddSectionTitle(T(STRINGS["sectiontitle_debugging"])),
	{
		name = "crash_reporter",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"independent", "dst_only"},
	},
	{
		name = "DEBUG_SHOW_NOTIMPLEMENTED",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {"independent"},
	},
	{
		name = "DEBUG_SHOW_DISABLED",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {"independent"},
	},
	{
		name = "DEBUG_SHOW_PREFAB",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		client = true,
		tags = {"independent"},
	},
	{
		name = "DEBUG_ENABLED",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {"independent"},
	}
}


-- Any functions within this table are processed by clientmodmain and use the environment there.
complex_configuration_options = {
	AddSectionTitle(T(STRINGS["sectiontitle_complexconfiguration"])),
	{
		name = "boss_indicator_prefabs", -- name of option -- header for option in dst
		options = (function()
			local t = {}
			-- I want to give the option for any bosses that exist as a prefab.
			for i,v in ipairs(BOSSES_ALL) do
				if _G.Prefabs[v] ~= nil then
					t[#t+1] = { data=v }
				end
			end
			return t
		end),
		default = (function()
			local t = {}
			for i,v in ipairs(BOSSES) do
				t[#t+1] = v
			end
			return t
		end),
		config_type = "listbox",
		client = true,
		tags = {"dynamic_option_strings", "richtext"},
	},
	{
		name = "miniboss_indicator_prefabs",
		options = (function()
			local t = {}
			-- I want to give the option for any minibosses that exist as a prefab.
			for i,v in ipairs(MINIBOSSES_ALL) do
				if _G.Prefabs[v] ~= nil then
					t[#t+1] = { data=v }
				end
			end
			return t
		end),
		default = (function()
			local t = {}
			for i,v in ipairs(MINIBOSSES) do
				t[#t+1] = v
			end
			return t
		end),
		config_type = "listbox",
		client = true,
		tags = {"dynamic_option_strings", "richtext"},
	},
	{
		name = "notable_indicator_prefabs", -- name of option -- header for option in dst
		options = (function()
			local t = {}
			-- I want to give the option for any notable indicator prefabs that exist as a prefab.
			for i,v in ipairs(NOTABLE_INDICATORS_ALL) do
				if _G.Prefabs[v] ~= nil then
					t[#t+1] = { data=v }
				end
			end
			return t
		end),
		default = (function()
			local t = {}
			-- The default should be whatever exists in vanilla for either game.
			for i,v in ipairs(NOTABLE_INDICATORS) do
				t[#t+1] = v
			end
			return t
		end),
		config_type = "listbox",
		client = true,
		tags = {"dynamic_option_strings", "richtext"},
	},
	{
		name = "unique_info_prefabs",
		options = (function()
			local t = {}
			for i,v in ipairs(UNIQUE_INFO_PREFABS) do
				if _G.STRINGS.NAMES[v:upper()] ~= nil or _G.Prefabs[v] ~= nil then
					t[#t+1] = { data=v }
				end
			end
			return t
		end),
		default = (function()
			local t = {}
			-- The default should be whatever exists in vanilla for either game.
			for i,v in ipairs(UNIQUE_INFO_PREFABS) do
				t[#t+1] = v
			end
			return t
		end),
		config_type = "listbox",
		client = false, -- Hmm. This is the first complex configuration option that isn't client sided.
		tags = {"dynamic_option_strings", "richtext"},
	},
}

--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================
--[[ Finalize Options ]] 
--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================

for i = 1, #configuration_options do
	local entry = configuration_options[i]
	
	if not HasTag(entry, "ignore") then 
		AddConfigurationOptionStrings(entry)
	end
end

-- Complex configuration option strings processed in clientmodmain

if IsDST then 
	for i = 1, #configuration_options do
		local entry = configuration_options[i]
		
		local default = (not HasTag(entry, "ignore")) and GetDefaultSetting(entry) or nil

		--[[
		if HasTag(entry, "client_only") then
			entry.label = entry.label .. " (Client)" -- Only client can choose
		end
		--]]

		if HasTag(entry, "undefined") then -- Server doesn't have to specify
			--print'--------------------------------------------------------------------------------'
			--table.foreach(entry, print)
			--print("Desc", default.description)
			entry.original_default = entry.default
			entry.default = "undefined"
			entry.options[#entry.options+1] = { 
				description = T(STRINGS["undefined"]), 
				data = "undefined", 
				hover = T(STRINGS["undefined_description"]) .. default.description
			}
		end
	end
else
	local i = 1
	while i <= #configuration_options do
		local entry = configuration_options[i]

		if HasTag(entry, "dst_only") then
			table_remove(configuration_options, i)
			i = 0
		end

		i = i + 1
	end

	for i = 1, #configuration_options do
		local entry = configuration_options[i]
		
		--v.options[#v.options+1] = { description = "DS", data = "hehe", hover = i}
	end
	
end
