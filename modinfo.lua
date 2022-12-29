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
local IsDST = folder_name ~= nil -- present in DST, not DS. big brain engaged
name = "Insight"
-- Major.Minor.Patch
version = "3.4.5" -- dst is 3.4.3, ds is 3.4.0
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
		return tbl[1]
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
--[[ Font Sizes ]]
local FONT_SIZE = {
	INSIGHT = {
		HOVERER = {20, 30},
		INVENTORYBAR = {20, 25},
		FOLLOWTEXT = {20, 28}
	}
}

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
local BOSSES_DST = {"antlion", "beequeen", "crabking",  "klaus", "malbatross", "moose", "stalker_atrium", "toadstool", "eyeofterror", "twinofterror1", "twinofterror2"}
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

--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================
--[[ Strings ]] 
--====================================================================================================================================================
--====================================================================================================================================================
--====================================================================================================================================================

STRINGS = {
	--==========================================================================================
	--[[ Misc Strings ]]
	--==========================================================================================
	ds_not_enabled = {
		"Mod must be enabled for functioning modinfo",
		["zh"] = nil,
		["br"] = "O mod deve estar ativado para o funcionamento do modinfo",
		["es"] = "El mod debe estar habilitado para que funcione el modinfo.",
	},
	update_info = {
		"Moon Quay update, Bug fixes. Check changelog for more details.",
		["zh"] = nil,
		["br"] = nil,
		["es"] = nil,
	},
	update_info_ds = {
		"Bug fixes, check change notes.",
		["zh"] = nil,
		["br"] = nil,
		["es"] = nil,
	},
	crashreporter_info = {
		"Insight has a crash reporter you can enable in the client & server config",
		["zh"] = "**添加了崩溃报告器**, 你可以在客户端或服务器设置界面来开启它。",
		["br"] = "O Insight tem um relatório de falhas que você pode ativar na configuração do cliente e do servidor",
		["es"] = "Insight tiene un informe de fallos que puedes activar en la configuración del cliente y del servidor.",
	},
	mod_explanation = {
		"Basically Show Me but with more features.",
		["zh"] = "以 Show Me 为基础，但功能更全面",
		["br"] = "Basicamente o Show Me, mas com mais recursos.",
		["es"] = "Básicamente Show Me pero con más funciones.",
	},
	config_paths = {
		"Server Configuration: Main Menu -> Host Game -> Mods -> Server Mods -> Insight -> Configure Mod\n-------------------------\nClient Configuration: Main Menu -> Mods -> Server Mods -> Insight -> Configure Mod",
		["zh"] = "服务器设置方法: 主界面 -> 创建世界-> 模组 -> 服务器模组 -> Insight -> 模组设置\n-------------------------\n客户端设置方法: 主界面 -> 模组 -> 服务器模组 -> Insight -> 模组设置",
		["br"] = "Configuração do Servidor: Main Menu -> Host Game -> Mods -> Server Mods -> Insight -> Configure Mod\n-------------------------\nConfiguração do Client: Main Menu -> Mods -> Server Mods -> Insight -> Configure Mod",
		["es"] = "Configuración de servidor: Menú principal -> Crear partida -> Mods -> Mods servidor -> Insight -> Configurar mod\n-------------------------\nConfiguración del cliente: Menú principal -> Mods -> Mods servidor -> Insight -> Configurar mod",
	},
	config_disclaimer = {
		"Make sure to check out the configuration options.",
		["zh"] = "请确认你设置的各个选项, 尤其是设置好显示的和设置不再显示的信息，需要格外注意。",
		["br"] = "Certifique-se de verificar as opções de configuração.",
		["es"] = "Asegúrese de comprobar las opciones de configuración.",
	},
	version = {
		"Version",
		["zh"] = "版本",
		["br"] = "Versão",
		["es"] = "Versión",
	},
	latest_update = {
		"Latest update",
		["zh"] = "最新更新",
		["br"] = "Última atualização",
		["es"] = "Última actualización",
	},
	undefined = {
		"Undefined",
		["zh"] = "默认",
		["br"] = "Indefinido",
		["es"] = "Indefinido",
	},
	undefined_description = {
		"Defaults to: ",
		["zh"] = "默认为：",
		["br"] = "Padrões para: ",
		["es"] = "Por defecto es: ",
	},
	--==========================================================================================
	--[[ Section Titles ]]
	--==========================================================================================
	sectiontitle_formatting = {
		"Formatting",
		["zh"] = "格式",
		["br"] = "Formações",
		["es"] = "Formato",
	},
	sectiontitle_indicators = {
		"Indicators",
		["zh"] = "指示器",
		["br"] = "Indicadores",
		["es"] = "Indicadores",
	},
	sectiontitle_foodrelated = {
		"Food Related",
		["zh"] = "食物相关",
		["br"] = "Relacionado a comidas",
		["es"] = "Alimentos",
	},
	sectiontitle_informationcontrol = {
		"Information Control",
		["zh"] = "信息控制",
		["br"] = "Informações de controle",
		["es"] = "Información",
	},
	sectiontitle_miscellaneous = {
		"Miscellaneous",
		["zh"] = "杂项",
		["br"] = "Diversos",
		["es"] = "Varios",
	},
	sectiontitle_debugging = {
		"Debugging",
		["zh"] = "调试",
		["br"] = "Debugging",
		["es"] = "Depuración",
	},
	sectiontitle_complexconfiguration = {
		"Special Configuration",
		["zh"] = nil,
		["br"] = nil,
		["es"] = nil
	},
	--==========================================================================================
	--[[ Complex Configuration Options ]]
	--==========================================================================================
	boss_indicator_prefabs = {
		label = {
			"Boss Indicator Prefabs", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
		},
		hover = {
			"Enabled boss indicator prefabs.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
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
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
		},
		hover = {
			"Enabled miniboss indicator prefabs.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
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
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
		},
		hover = {
			"Enabled notable indicator prefabs.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
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
			["zh"] = "图标模式", 
			["br"] = "Idioma", 
			["es"] = "Idioma"
		},
		hover = {
			"The language you want information to display in.", 
			["zh"] = "是否显示图标或文字", 
			["br"] = "O idioma em que você deseja que as informações sejam exibidas.", 
			["es"] = "El idioma en el que se muestra la información."
		},
		options = {
			["automatic"] = {
				description = {
					"Automatic",
					["zh"] = "自动",
					["br"] = "Automático",
					["es"] = "Automático",
				},
				hover = {
					"Uses your current language settings.",
					["zh"] = "使用游戏当前的语言设定",
					["br"] = "Usa suas configurações de idioma atuais.",
					["es"] = "Utiliza tu configuración de idioma actual.",
				},
			},
			["en"] = {
				description = {
					"English",
					["zh"] = "英语",
					["br"] = "English",
					["es"] = "Inglés",
				},
				hover = {
					"English",
					["zh"] = "英语",
					["br"] = "Inglês",
					["es"] = "Inglés",
				},
			},
			["zh"] = {
				description = {
					"Chinese",
					["zh"] = "中文",
					["br"] = "Chinese",
					["es"] = "Chino",
				},
				hover = {
					"Chinese",
					["zh"] = "中文",
					["br"] = "Chinês",
					["es"] = "Chino",
				},
			},
			["br"] = {
				description = {
					"Portuguese",
					["zh"] = "Portuguese",
					["br"] = "Português",
					["es"] = "Portugués",
				},
				hover = {
					"Portuguese",
					["zh"] = "Portuguese",
					["br"] = "Português",
					["es"] = "Portugués",
				},
			},
			["es"] = {
				description = {
					"Spanish",
					["zh"] = "Spanish",
					["br"] = "Spanish",
					["es"] = "Español",
				},
				hover = {
					"Spanish",
					["zh"] = "Spanish",
					["br"] = "Spanish",
					["es"] = "Español",
				},
			},
		},
	},
	info_style = {
		label = {
			"Display style", 
			["zh"] = "信息类型", 
			["br"] = "Estilo de exibição", 
			["es"] = "Estilo de información"
		},
		hover = {
			"Whether you want to use icons or text.", 
			["zh"] = "选择图标模式还是文字模式。", 
			["br"] = "Se você deseja usar ícones ou texto.", 
			["es"] = "Configura el uso de texto o iconos en la información."
		},
		options = {
			["text"] = {
				description = {
					"Text",
					["zh"] = "文字",
					["br"] = "Texto",
					["es"] = "Texto",
				},
				hover = {
					"Text will be used",
					["zh"] = "显示纯文字",
					["br"] = "Texto será usado",
					["es"] = "Solo se utiliza texto.",
				},
			},
			["icon"] = {
				description = {
					"Icon",
					["zh"] = "图标",
					["br"] = "Ícone",
					["es"] = "Iconos",
				},
				hover = {
					"Icons will be used over text where possible.",
					["zh"] = "显示图标替代文字",
					["br"] = "Os ícones serão usados sobre o texto sempre que possível.",
					["es"] = "Se usan iconos cuando sea posible.",
				},
			},
		},
	},
	text_coloring = {
		label = {
			"Text Coloring", 
			["zh"] = "文字着色", 
			["br"] = "Colorir Texto", 
			["es"] = "Coloreado de textos"
		},
		hover = {
			"Whether text coloring is enabled.", 
			["zh"] = "是否启用文字着色。", 
			["br"] = "Se a coloração do texto está habilitada.", 
			["es"] = "Configura el uso de coloreado de texto."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Text coloring will not be used. :(",
					["zh"] = "禁用文字着色 :(",
					["br"] = "A coloração do texto não será usada.",
					["es"] = "No se utiliza el coloreado de texto. :(",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Text coloring will be used.",
					["zh"] = "启用文字着色",
					["br"] = "A coloração do texto será usada.",
					["es"] = "Se utiliza el coloreado de texto.",
				},
			},
		},
	},
	hoverer_insight_font_size = {
		label = {
			"Mouse Hover Text Size",
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"The font size of Insight's hover text when using a mouse.",
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = GenerateFontSizeTexts(FONT_SIZE.INSIGHT.HOVERER),
	},
	inventorybar_insight_font_size = {
		label = {
			"Controller Inv. Text Size",
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"The font size of Insight's inventory text when using a controller.",
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = GenerateFontSizeTexts(FONT_SIZE.INSIGHT.INVENTORYBAR),
	},
	followtext_insight_font_size = {
		label = {
			"Controller Follow Text Size",
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"The font size of Insight's Follow text when using a controller.",
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = GenerateFontSizeTexts(FONT_SIZE.INSIGHT.FOLLOWTEXT),
	},
	alt_only_information = {
		label = {
			"Inspect Only", 
			["zh"] = "仅在检查时显示", 
			["br"] = "Somente Inspecionar", 
			["es"] = "Solo inspeccionar"
		},
		hover = {
			"Whether Insight will only show information when you hold Left Alt.", 
			["zh"] = "是否仅当按住 Alt 键时显示信息", 
			["br"] = "Se o Insight só mostrará informações quando você segurar Alt esquerdo.", 
			["es"] = "Insight sólo muestra información cuando mantengas pulsado Alt izq."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Information is displayed normally.",
					["zh"] = "信息正常显示",
					["br"] = "As informações são exibidas normalmente.",
					["es"] = "La información se muestra normalmente.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Information only displays on inspection.",
					["zh"] = "仅当按住 Alt 键时显示信息",
					["br"] = "As informações são exibidas apenas na inspeção.",
					["es"] = "Sólo se muestra en la inspección.",
				},
			},
		},
	},
	itemtile_display = {
		label = {
			"Inv Slot Info", 
			["zh"] = "库存物品栏信息", 
			["br"] = "Informações do inventário", 
			["es"] = "Información de ranuras"
		},
		hover = {
			"What kind of information shows instead of percentages on item slots.", 
			["zh"] = "物品栏信息显示的类型", 
			["br"] = "Que tipo de informação é exibida em vez de porcentagens nos slots de itens.", 
			["es"] = "Configura qué tipo de información se muestra en lugar de porcentajes en las ranuras de tu inventario."
		},
		options = {
			["none"] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Ninguno",
				},
				hover = {
					"Will not provide ANY information on item slots.",
					["zh"] = "不显示任何信息",
					["br"] = "Não fornecerá NENHUMA informação sobre slots de itens.",
					["es"] = "No muestra ninguna información sobre las ranuras de inventario.",
				},
			},
			["numbers"] = {
				description = {
					"Numbers",
					["zh"] = "数字",
					["br"] = "Números",
					["es"] = "Números",
				},
				hover = {
					"Will provide durability numbers on item slots.",
					["zh"] = "显示具体次数",
					["br"] = "Fornecerá números de durabilidade nos slots de itens.",
					["es"] = "Utiliza números de durabilidad en las ranuras de inventario.",
				},
			},
			["percentages"] = {
				description = {
					"Percentages",
					["zh"] = "百分比",
					["br"] = "Porcentagens",
					["es"] = "Porcentajes",
				},
				hover = {
					"Will provide use default percentages on item slots.",
					["zh"] = "显示默认百分比",
					["br"] = "Fornecerá porcentagens padrão de uso em slots de itens.",
					["es"] = "Utiliza porcentajes por defecto en las ranuras de inventario.",
				},
			},
			["mixed"] = {
				description = {
					"Mixed",
					["zh"] = "兼用",
					["br"] = "Misto",
					["es"] = "Mixto",
				},
				hover = {
					"Will provide use default percentages on refuelables, numbers for everything else.",
					["zh"] = "可恢复耐久的物品显示默认百分比, 其他显示具体次数",
					["br"] = "Fornecerá porcentagens padrão de uso em reabastecimentos, números para todo o resto.",
					["es"] = "Utiliza porcentajes por defecto en items recargables, números para todo lo demás.",
				},
			},
		},
	},
	time_style = {
		label = {
			"Time style", 
			["zh"] = "时间样式", 
			["br"] = "Estilo de tempo", 
			["es"] = "Estilo del tiempo"
		},
		hover = {
			"How to display time information.", 
			["zh"] = "如何显示时间信息", 
			["br"] = "Como exibir informações de tempo.", 
			["es"] = "Configura como mostrar información de la hora."
		},
		options = {
			["gametime"] = {
				description = {
					"Game time",
					["zh"] = "游戏时间",
					["br"] = "Tempo do jogo",
					["es"] = "Tiempo de juego",
				},
				hover = {
					"Displays time information based on game time: days, segments.",
					["zh"] = "以游戏内时间为基础显示时间信息：天数，时间小段",
					["br"] = "Exibe informações de tempo com base no tempo do jogo: dias, segmentos.",
					["es"] = "Muestra información del tiempo basada en el tiempo de juego: días, segmentos",
				},
			},
			["realtime"] = {
				description = {
					"Real time",
					["zh"] = "现实时间",
					["br"] = "Tempo real",
					["es"] = "Tiempo real",
				},
				hover = {
					"Displays time information based on real time: hours, minutes, seconds.",
					["zh"] = "以现实时间为基础现实时间信息：时，分，秒",
					["br"] = "Exibe informações de tempo com base no tempo real: horas, minutos, segundos.",
					["es"] = "Muestra información del tiempo basada en el tiempo real: horas, minutos, segundos.",
				},
			},
			["both"] = {
				description = {
					"Both",
					["zh"] = "兼用两种模式",
					["br"] = "Ambos",
					["es"] = "Ambos",
				},
				hover = {
					"Use both time styles: days, segments (hours, minutes, seconds)",
					["zh"] = "使用两种显示形式：天，时间小段（时，分，秒）",
					["br"] = "Use ambos os estilos de tempo: dias, segmentos (horas, minutos, segundos)",
					["es"] = "Utiliza ambos estilos de tiempo: días, segmentos (horas, minutos, segundos)",
				},
			},
			["gametime_short"] = {
				description = {
					"Game time (Short)",
					["zh"] = "游戏时间（精简）",
					["br"] = "Tempo do jogo (Curto)",
					["es"] = "Tiempo de juego (corto)",
				},
				hover = {
					"Displays shortened time information based on game time.",
					["zh"] = "简化版的以游戏内时间为基础显示时间信息",
					["br"] = "Exibe informações de tempo reduzido com base no tempo do jogo.",
					["es"] = "Muestra información de tiempo reducido basado en el tiempo de juego",
				},
			},
			["realtime_short"] = {
				description = {
					"Real time (Short)",
					["zh"] = "现实时间（精简）",
					["br"] = "Tempo real (Curto)",
					["es"] = "Tiempo real (corto)",
				},
				hover = {
					"Displays shortened time information based on real time: hours:minutes:seconds.",
					["zh"] = "简化版的以现实时间为基础显示时间信息",
					["br"] = "Exibe informações de tempo reduzido com base no tempo real: horas:minutos:segundos.",
					["es"] = "Muestra información de tiempo reducido basada en el tiempo real: horas:minutos:segundos.",
				},
			},
			["both_short"] = {
				description = {
					"Both (Short)",
					["zh"] = "兼用两种模式（精简）",
					["br"] = "Ambos (Curto)",
					["es"] = "Both (Short)",
				},
				hover = {
					"Use both time styles and shorten: x.y days (hours:minutes:seconds).",
					["zh"] = "简化版的双模式显示",
					["br"] = "Use ambos os estilos de tempo e abrevie: x.y dias (horas:minutos:segundos).",
					["es"] = "Utiliza ambos estilos reducidos: x.y días (horas:minutos:segundos).",
				},
			},
		},
	},
	temperature_units = {
		label = {
			"Temperature units", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"How to display temperature", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = {
			["game"] = {
				description = {
					"Game",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Freeze: 0, Overheat: 70",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			["celsius"] = {
				description = {
					"Celsius",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Freeze: 0, Overheat: 35",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			["fahrenheit"] = {
				description = {
					"Fahrenheit",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Freeze: 32, Overheat: 158",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
		},
	},
	highlighting = {
		label = {
			"Highlighting", 
			["zh"] = "高亮显示", 
			["br"] = "Destacar item", 
			["es"] = "Resaltado"
		},
		hover = {
			"Whether item highlighting is enabled. (\"Finder\")", 
			["zh"] = "是否启用箱子/物品的高亮显示 (\"物品查找器\")", 
			["br"] = "Se o destaque do item está ativado. (\"Finder\")", 
			["es"] = "Configura si se activa el resaltado de objetos. (\"Buscador\")"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"No chest/item highlighting.",
					["zh"] = "箱子/物品不会高亮显示",
					["br"] = "Nenhum báu/item será destacado.",
					["es"] = "No se resaltarán objetos.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Chests/items will be highlighted.",
					["zh"] = "箱子/物品会高亮显示",
					["br"] = "Baús/itens serão destacados.",
					["es"] = "Los cofres y objetos se resaltarán.",
				},
			},
		},
	},
	highlighting_color = {
		label = {
			"Highlighting Color", 
			["zh"] = "高亮颜色", 
			["br"] = "Cor de realce", 
			["es"] = "Color de resaltado"
		},
		hover = {
			"The color to use for highlighting.", 
			["zh"] = "高亮显示时的颜色", 
			["br"] = "A cor a ser usada para destacar.", 
			["es"] = "Configura el color a utilizar para resaltar."
		},
		options = {
			["RED"] = {
				description = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
				},
				hover = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
				},
			},
			["GREEN"] = {
				description = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
				},
				hover = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
				},
			},
			["BLUE"] = {
				description = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
				},
				hover = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
				},
			},
			["LIGHT_BLUE"] = {
				description = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
				},
				hover = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
				},
			},
			["PURPLE"] = {
				description = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
				},
				hover = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
				},
			},
			["YELLOW"] = {
				description = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelo",
					["es"] = "Amarillo",
				},
				hover = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelp",
					["es"] = "Amarillo",
				},
			},
			["WHITE"] = {
				description = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
				},
				hover = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
				},
			},
			["ORANGE"] = {
				description = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
				},
				hover = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
				},
			},
			["PINK"] = {
				description = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
				},
				hover = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
				},
			},
		},
	},
	fuel_highlighting = {
		label = {
			"Fuel Highlighting", 
			["zh"] = "燃料高亮显示", 
			["br"] = "Realce de Combustível", 
			["es"] = "Resaltado del combustible"
		},
		hover = {
			"Whether fuel highlighting is enabled.", 
			["zh"] = "是否开启燃料高亮显示", 
			["br"] = "Se o realce de combustível está ativado.", 
			["es"] = "Configura el resaltado del combustible."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Fuel entities will not be highlighted.",
					["zh"] = "禁用燃料高亮显示",
					["br"] = "Entidades de combustível não serão destacadas.",
					["es"] = "No se resaltan objetos de combustible.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Fuel entities will be highlighted.",
					["zh"] = "启用燃料高亮显示",
					["br"] = "Entidades de combustível serão destacadas.",
					["es"] = "Los objetos de combustible serán resaltadas.",
				},
			},
		},
	},
	fuel_highlighting_color = {
		label = {
			"Fuel Highlighting Color", 
			["zh"] = "燃料高亮颜色", 
			["br"] = "Cor de Destaque de Combustível", 
			["es"] = "Color de resaltado del combustible"
		},
		hover = {
			"The color to use for fuel highlighting.", 
			["zh"] = "燃料高亮显示时的颜色", 
			["br"] = "A cor a ser usada para realce de combustível.", 
			["es"] = "Configura el color a utilizar para resaltar el combustible."
		},
		options = {
			["RED"] = {
				description = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
				},
				hover = {
					"Red",
					["zh"] = "红色",
					["br"] = "Vermelho",
					["es"] = "Rojo",
				},
			},
			["GREEN"] = {
				description = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
				},
				hover = {
					"Green",
					["zh"] = "绿色",
					["br"] = "Verde",
					["es"] = "Verde",
				},
			},
			["BLUE"] = {
				description = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
				},
				hover = {
					"Blue",
					["zh"] = "蓝色",
					["br"] = "Azul",
					["es"] = "Azul",
				},
			},
			["LIGHT_BLUE"] = {
				description = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
				},
				hover = {
					"Light Blue",
					["zh"] = "亮蓝色",
					["br"] = "Azul Claro",
					["es"] = "Azul claro",
				},
			},
			["PURPLE"] = {
				description = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
				},
				hover = {
					"Purple",
					["zh"] = "紫色",
					["br"] = "Roxo",
					["es"] = "Púrpura",
				},
			},
			["YELLOW"] = {
				description = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelo",
					["es"] = "Amarillo",
				},
				hover = {
					"Yellow",
					["zh"] = "黄色",
					["br"] = "Amarelo",
					["es"] = "Amarillo",
				},
			},
			["WHITE"] = {
				description = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
				},
				hover = {
					"White",
					["zh"] = "白色",
					["br"] = "Branco",
					["es"] = "Blanco",
				},
			},
			["ORANGE"] = {
				description = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
				},
				hover = {
					"Orange",
					["zh"] = "橙色",
					["br"] = "Laranja",
					["es"] = "Naranja",
				},
			},
			["PINK"] = {
				description = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
				},
				hover = {
					"Pink",
					["zh"] = "粉色",
					["br"] = "Rosa",
					["es"] = "Rosa",
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
			["es"] = "Rango de ataque"
		},
		hover = {
			"Whether attack ranges are shown.", 
			["zh"] = "是否显示攻击范围", 
			["br"] = "Se os alcances de ataque são mostrados.", 
			["es"] = "Configura si se muestra los rangos de ataque."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Attack ranges are not shown.",
					["zh"] = "不显示攻击范围",
					["br"] = "Os alcances de ataque não serão mostrados.",
					["es"] = "No se muestra los rangos de ataque.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Attack ranges are shown.",
					["zh"] = "显示攻击范围",
					["br"] = "Os alcances de ataque serão mostrados.",
					["es"] = "Se muestra los rangos de ataque.",
				},
			},
		},
	},
	attack_range_type = {
		label = {
			"Attack Range Type", 
			["zh"] = "攻击范围类型", 
			["br"] = "Tipo de Alcance de Ataque", 
			["es"] = "Tipo de rango de ataque"
		},
		hover = {
			"Type of attack range to be displayed.", 
			["zh"] = "显示攻击范围的类型", 
			["br"] = "Tipo de alcance de ataque a ser exibido.", 
			["es"] = "Tipo de rango de ataque a mostrar."
		},
		options = {
			["hit"] = {
				description = {
					"Hit",
					["zh"] = "敲击",
					["br"] = "Acerto",
					["es"] = "Golpe",
				},
				hover = {
					"Hit range is shown.",
					["zh"] = "显示敲击范围",
					["br"] = "Alcance de acertos é mostrado.",
					["es"] = "Se muestra el rango de golpe.",
				},
			},
			["attack"] = {
				description = {
					"Attack",
					["zh"] = "攻击",
					["br"] = "Ataque",
					["es"] = "Ataque",
				},
				hover = {
					"Attack range is shown.",
					["zh"] = "显示攻击范围",
					["br"] = "Alcance de ataque é mostrado.",
					["es"] = "Se muestra el rango de ataque.",
				},
			},
			["both"] = {
				description = {
					"Both",
					["zh"] = "兼用",
					["br"] = "Ambos",
					["es"] = "Ambos",
				},
				hover = {
					"Both hit and attack range are shown.",
					["zh"] = "同时显示敲击和攻击范围",
					["br"] = "Tanto o alcance de acerto quanto o de ataque são mostrados.",
					["es"] = "Se muestra tanto el rango de golpe como el de ataque.",
				},
			},
		},
	},
	hover_range_indicator = {
		label = {
			"Item Range Hover", 
			["zh"] = "物品范围", 
			["br"] = "Passar o mouse para mostrar alcance", 
			["es"] = "Rango de objeto"
		},
		hover = {
			"Whether an item's range is shown upon hovering.", 
			["zh"] = "是否显示鼠标悬停物品的生效范围。", 
			["br"] = "Se o alcance de um item é mostrado ao passar o mouse sobre ele.", 
			["es"] = "Configura si el rango de un objeto se muestra al pasar el ratón por encima."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Range is not shown.",
					["zh"] = "不显示物品范围",
					["br"] = "Alcance não é mostrado.",
					["es"] = "No se muestra el rango.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Range is shown.",
					["zh"] = "显示物品范围。",
					["br"] = "Alcance é mostrado.",
					["es"] = "Se muestra el rango.",
				},
			},
		},
	},
	boss_indicator = {
		label = {
			"Boss Indicators", 
			["zh"] = "Boss 指示器", 
			["br"] = "Indicador de Chefões", 
			["es"] = "Indicador de jefes"
		},
		hover = {
			"Whether boss indicators are shown.", 
			["zh"] = "是否显示 Boss 指示器功能。", 
			["br"] = "Se os indicadores do chefe são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de jefes."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Boss indicators not shown.",
					["zh"] = "不显示 Boss 指示器。",
					["br"] = "Indicadores de chefões não são mostrados.",
					["es"] = "No se muestra los indicadores de jefes.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Boss indicators are shown.",
					["zh"] = "显示 Boss 指示器。",
					["br"] = "Indicadores de chefões são mostrados.",
					["es"] = "Se muestra los indicadores del jefes.",
				},
			},
		},
	},
	miniboss_indicator = {
		label = {
			"Miniboss Indicators", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
		},
		hover = {
			"Whether miniboss indicators are shown.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil,
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Miniboss indicators not shown.",
					["zh"] = nil, 
					["br"] = nil, 
					["es"] = nil,
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Miniboss indicators are shown.",
					["zh"] = nil, 
					["br"] = nil, 
					["es"] = nil,
				},
			},
		},
	},
	notable_indicator = {
		label = {
			"Notable Indicators", 
			["zh"] = "其他物品的指示器", 
			["br"] = "Indicador Notável", 
			["es"] = "Indicador notable"
		},
		hover = {
			"Whether the notable (chester, hutch, etc) indicators are shown.", 
			["zh"] = "是否显示其他物品（切斯特，哈奇等等）的指示器", 
			["br"] = "Se os indicadores notáveis (chester, hutch, etc) são mostrados.", 
			["es"] = "Configura si se muestra los indicadores notables (Chester, Hutch, etc.)"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Notable indicators not shown.",
					["zh"] = "不显示指示器。",
					["br"] = "Indicadores notáveis não são mostrados.",
					["es"] = "No se muestra los indicadores notables.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Notable indicators are shown.",
					["zh"] = "显示指示器。",
					["br"] = "Indicadores notáveis são mostrados.",
					["es"] = "Se muestra los indicadores notables.",
				},
			},
		},
	},
	pipspook_indicator = {
		label = {
			"Pipspook toy indicators", 
			["zh"] = "小惊吓玩具指示器", 
			["br"] = "Indicadores de brinquedos Pipspook", 
			["es"] = "Indicadores de juguetes Pipspook"
		},
		hover = {
			"Whether pipspook toy indicators are shown.", 
			["zh"] = "是否显示小惊吓玩具的指示器。", 
			["br"] = "Se os indicadores de brinquedo pipspook são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de juguetes Pipspook."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Pipspook toy indicators not shown.",
					["zh"] = "不显示小惊吓玩具指示器。",
					["br"] = "Indicadores de brinquedos Pipspook não são mostrados.",
					["es"] = "No se muestra los indicadores de juguetes Pipspook.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Pipspook toy indicators are shown.",
					["zh"] = "显示小惊吓玩具指示器。",
					["br"] = "Indicadores de brinquedos Pipspook são mostrados.",
					["es"] = "Se muestra los indicadores de juguetes Pipspook.",
				},
			},
		},
	},
	bottle_indicator = {
		label = {
			"Bottle Indicator", 
			["zh"] = "漂流瓶指示器", 
			["br"] = "Indicadores de Garrafa", 
			["es"] = "Indicador de botella"
		},
		hover = {
			"Whether message bottle indicators are shown.", 
			["zh"] = "是否显示漂流瓶指示器。", 
			["br"] = "Se os indicadores de garrafa de mensagem são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de botellas de mensajes."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Message indicators not shown.",
					["zh"] = "不显示漂流瓶指示器。",
					["br"] = "Indicadores de garrafas não são mostrados.",
					["es"] = "No se muestra los indicadores de mensajes.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Message indicators are shown.",
					["zh"] = "显示漂流瓶指示器。",
					["br"] = "Indicadores de garrafas são mostrados.",
					["es"] = "Se muestra los indicadores de mensajes.",
				},
			},
		},
	},
	hunt_indicator = {
		label = {
			"Hunt Indicator", 
			["zh"] = "动物脚印指示器", 
			["br"] = "Indicadores de Caça", 
			["es"] = "Indicador de caza"
		},
		hover = {
			"Whether hunt indicators are shown.", 
			["zh"] = "是否显示脚印指示器。", 
			["br"] = "Se os indicadores de caça (rastros, pegadas) são mostrados.", 
			["es"] = "Configura si se muestra los indicadores de caza."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Hunt indicators not shown.",
					["zh"] = "不显示脚印指示器。",
					["br"] = "Indicadores de caça não são mostrados.",
					["es"] = "No se muestra los indicadores de caza.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Hunt indicators are shown.",
					["zh"] = "显示脚印指示器。",
					["br"] = "Indicadores de caça são mostrados.",
					["es"] = "Se muestra los indicadores de caza.",
				},
			},
		},
	},
	orchestrina_indicator = {
		label = {
			"Archive Puzzle Helper", 
			["zh"] = "远古迷宫", 
			["br"] = "Ajudante de Quebra-Cabeça dos Arquivos", 
			["es"] = "Ayuda en puzle de Archivos"
		},
		hover = {
			"Whether the solution to the puzzle is displayed or not.", 
			["zh"] = "是否显示远古迷宫的答案。", 
			["br"] = "Se a solução do quebra-cabeça (Archive Puzzle) é exibida ou não.", 
			["es"] = "Configura si la solución del puzle se muestra."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The solution is not displayed.",
					["zh"] = "不显示答案。",
					["br"] = "A solução não é exibida.",
					["es"] = "No se muestra la solución.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The solution is displayed.",
					["zh"] = "显示答案。",
					["br"] = "A solução é exibida..",
					["es"] = "Se muestra la solución.",
				},
			},
		},
	},
	lightningrod_range = {
		label = {
			"Lightningrod range", 
			["zh"] = "避雷针范围", 
			["br"] = "Alcance do para-raios", 
			["es"] = "Rango del pararrayos"
		},
		hover = {
			"How lightningrod range is displayed.", 
			["zh"] = "避雷针生效范围的显示方式。", 
			["br"] = "Como o alcance do para-raios é exibido.", 
			["es"] = "Configura como se muestra el alcance del pararrayos."
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
				},
				hover = {
					"Do not show lightning rod range.",
					["zh"] = "不显示避雷针的生效范围。",
					["br"] = "Não mostra o alcance do para-raios.",
					["es"] = "No mostrar el alcance del pararrayos.",
				},
			},
			[1] = {
				description = {
					"Strategic",
					["zh"] = "策略性地显示",
					["br"] = "Estratégico",
					["es"] = "Estratégico",
				},
				hover = {
					"Only show during placements / pitchforking (just like a flingo).",
					["zh"] = "只在放置避雷针时、使用草叉时、种植时显示生效范围。",
					["br"] = "Mostrar apenas durante as colocações / pitchforking (como uma flingo).",
					["es"] = "Mostrar sólo al construir estructuras.",
				},
			},
			[2] = {
				description = {
					"Always",
					["zh"] = "总是",
					["br"] = "Sempre",
					["es"] = "Siempre",
				},
				hover = {
					"Always show lightning rod range.",
					["zh"] = "总是显示避雷针的生效范围。",
					["br"] = "Sempre mostrar o alcance do para-raios.",
					["es"] = "Mostrar siempre el alcance del pararrayos.",
				},
			},
		},
	},
	blink_range = {
		label = {
			"Blink range", 
			["zh"] = "瞬移范围", 
			["br"] = "Intervalo de piscar", 
			["es"] = "Rango de teletransporte"
		},
		hover = {
			"Whether you can see your blink range.", 
			["zh"] = "是否显示你的瞬移的范围，如灵魂跳跃，橙色法杖等。", 
			["br"] = "Se você pode ver seu intervalo de piscar.", 
			["es"] = "Configura si se muestra el rango de teletransporte (Explorador Perezoso, almas de Wortox)."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Blink range not shown.",
					["zh"] = "不显示瞬移范围。",
					["br"] = "Intervalo de piscar não é mostrado.",
					["es"] = "No se muestra el rango de teletransporte.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Blink range shown.",
					["zh"] = "显示瞬移范围。",
					["br"] = "Intervalo de piscar é mostrado.",
					["es"] = "Se muestra el rango de teletransporte.",
				},
			},
		},
	},
	wortox_soul_range = {
		label = {
			"Wortox Soul range", 
			["zh"] = "沃拓克斯灵魂范围", 
			["br"] = "Alcance de almas do Wortox", 
			["es"] = "Rango de almas de Wortox"
		},
		hover = {
			"Whether you can see the pickup range Wortox has for his souls.", 
			["zh"] = "是否显示沃拓克斯拾取灵魂的范围和灵魂治疗范围。", 
			["br"] = "Se você pode ver o alcance de captação que Wortox tem para suas almas.", 
			["es"] = "Configura si se muestra el rango de recogida de Wortox para sus almas."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Soul pickup ranges not shown.",
					["zh"] = "不显示灵魂范围功能。",
					["br"] = "Faixas de coleta de almas não são mostradas.",
					["es"] = "No se muestra los rangos de recogida de almas.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Soul pickup ranges shown.",
					["zh"] = "显示灵魂范围功能。",
					["br"] = "Faixas de coleta de almas são mostradas.",
					["es"] = "Se muestra los rangos de recogida de almas.",
				},
			},
		},
	},
	battlesong_range = {
		label = {
			"Battle song range", 
			["zh"] = "战歌生效范围", 
			["br"] = "Alcance de Músicas de Batalha", 
			["es"] = "Rango de canciones de batalla"
		},
		hover = {
			"How battle song ranges are displayed.", 
			["zh"] = "如何显示战歌的生效范围。", 
			["br"] = "Como os alcances das músicas de batalha (Wigfrid) são exibidos.", 
			["es"] = "Configura como se muestra los rangos de canciones de batalla."
		},
		options = {
			["none"] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhum",
					["es"] = "Ninguno",
				},
				hover = {
					"Do not show battle song ranges.",
					["zh"] = "不显示战歌生效范围。",
					["br"] = "Não mostrar alcances de músicas de batalha.",
					["es"] = "No se muestra rangos de canciones de batalla.",
				},
			},
			["detach"] = {
				description = {
					"Detach",
					["zh"] = "脱离",
					["br"] = "Desanexar",
					["es"] = "Desprendimiento",
				},
				hover = {
					"Song detachment range shown.",
					["zh"] = "显示你脱离战歌生效的范围。",
					["br"] = "Alcance de separação de música é mostrado.",
					["es"] = "Se muestra el rango de desprendimiento de la canción.",
				},
			},
			["attach"] = {
				description = {
					"Attach",
					["zh"] = "生效",
					["br"] = "Anexar",
					["es"] = "Fijación",
				},
				hover = {
					"Song attachment range shown.",
					["zh"] = "显示你被战歌鼓舞的生效范围。",
					["br"] = "Alcance de anexo de música é mostrado.",
					["es"] = "Se muestra el rango de fijación de la canción.",
				},
			},
			["both"] = {
				description = {
					"Both",
					["zh"] = "兼用",
					["br"] = "Ambos",
					["es"] = "Ambos",
				},
				hover = {
					"Both ranges are shown.",
					["zh"] = "同时显示脱离战歌和被战歌鼓舞的生效范围",
					["br"] = "Ambas os alcances são mostradas.",
					["es"] = "Se muestra ambos rangos.",
				},
			},
		},
	},
	klaus_sack_markers = {
		label = {
			"Loot Stash Markers", 
			["zh"] = "克劳斯袋子标记 (服务器选项)", 
			["br"] = "Marcadores do Klaus", 
			["es"] = "Indicador de Saco de Klaus"
		},
		hover = {
			"Whether Loot Stash spawning locations are marked.", 
			["zh"] = "是否标记克劳斯袋子的位置 *该选项仅服务器有效*", 
			["br"] = "Se os locais onde o Klaus (Loot Stash) aparece estão marcados.", 
			["es"] = "Configura si se marcan las ubicaciones de aparición del Saco de Klaus."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Loot Stash markers are not shown.",
					["zh"] = "不显示标记",
					["br"] = "Sacos do Klaus não são marcados.",
					["es"] = "Se muestra los marcadores del Saco de Klaus.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Loot Stash markers are shown.",
					["zh"] = "显示标记",
					["br"] = "Sacos do Klaus são marcados.",
					["es"] = "No se muestra los marcadores del Saco de Klaus.",
				},
			},
		},
	},
	sinkhole_marks = {
		label = {
			"Sinkhole Marks", 
			["zh"] = "落水洞标记", 
			["br"] = "Marcações de Buraco", 
			["es"] = "Indicador de sumidero"
		},
		hover = {
			"How sinkhole marking is applied.", 
			["zh"] = "如何显示落水洞的着色标记。", 
			["br"] = "Como a marcação de buracos (entrada para as cavernas) é aplicada.", 
			["es"] = "Configura como se muestra los indicadores de sumideros"
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Ninguno",
				},
				hover = {
					"Do not do any sinkhole coloring.",
					["zh"] = "不着色标记任何落水洞洞口。",
					["br"] = "Não faça nenhum buraco colorido.",
					["es"] = "No se muestra ningún indicador.",
				},
			},
			[1] = {
				description = {
					"Map Only",
					["zh"] = "仅地图模式",
					["br"] = "Apenas Mapa",
					["es"] = "Sólo mapa",
				},
				hover = {
					"Only apply to map icons.",
					["zh"] = "仅着色标记地图图标。",
					["br"] = "Aplica-se apenas a ícones do mapa.",
					["es"] = "Sólo se colorea iconos del mapa.",
				},
			},
			[2] = {
				description = {
					"Sinkholes & Map",
					["zh"] = "兼用",
					["br"] = "Buracos & Mapa",
					["es"] = "Sumidero/mapa",
				},
				hover = {
					"Apply to both map icons & sinkholes.",
					["zh"] = "同时着色标记地图图标和落水洞洞口。",
					["br"] = "Aplicar a ícones de mapa e buracos.",
					["es"] = "Colorear tanto a iconos del mapa como a los sumideros",
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
			["es"] = "Información de alimentos"
		},
		hover = {
			"Whether food information is shown.", 
			["zh"] = "是否显示食物信息。", 
			["br"] = "Se as informações de alimentos são mostradas.", 
			["es"] = "Configura si se muestra la información de los alimentos."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Food information is not shown.",
					["zh"] = "不显示食物信息。",
					["br"] = "Informações de alimentos não são mostradas.",
					["es"] = "No se muestra la información de alimentos.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Food information is shown.",
					["zh"] = "显示食物信息。",
					["br"] = "As informações sobre os alimentos são mostradas.",
					["es"] = "Se muestra la información de alimentos.",
				},
			},
		},
	},
	food_style = {
		label = {
			"Food style", 
			["zh"] = "食物属性格式", 
			["br"] = "Estilos de Comida", 
			["es"] = "Estilo de comida"
		},
		hover = {
			"How food information is displayed.", 
			["zh"] = "如何显示食物属性信息。", 
			["br"] = "Como as informações de alimentos são exibidas.", 
			["es"] = "Configura como se muestra la información de los alimentos."
		},
		options = {
			["short"] = {
				description = {
					"Short",
					["zh"] = "精简",
					["br"] = "Curta",
					["es"] = "Reducida",
				},
				hover = { -- No Translation Needed   
					"+X / -X / +X",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			["long"] = {
				description = {
					"Long",
					["zh"] = "详细",
					["br"] = "Longa",
					["es"] = "Larga",
				},
				hover = {
					"Hunger: +X / Sanity: -X / Health: +X",
					["zh"] = "饥饿：+X / 理智：-X / 生命：+X",
					["br"] = "Fome: +X / Sanidade: -X / Vida: +X",
					["es"] = "Hambre: +X / Cordura: -X / Salud: +X",
				},
			},
		},
	},
	food_order = {
		label = {
			"Food order", 
			["zh"] = "食物属性显示顺序", 
			["br"] = "Ordem da Comida", 
			["es"] = "Orden de comida"
		},
		hover = {
			"What order food stats are displayed in (if you choose Wiki you're dead to me)", 
			["zh"] = "食物属性以何种顺序显示。", 
			["br"] = "Em que ordem as estatísticas de comida são exibidas (se você escolher Wiki, você está morto para mim)", 
			["es"] = "Configura en qué orden se muestra las estadísticas de los alimentos (si eliges Wiki estás muerto para mí)."
		},
		options = {
			["interface"] = {
				description = {
					"Interface",
					["zh"] = "界面",
					["br"] = "Interface",
					["es"] = "Interfaz",
				},
				hover = {
					"Hunger / Sanity / Health",
					["zh"] = "饥饿 / 理智 / 生命",
					["br"] = "Fome / Sanidade / Vida",
					["es"] = "Hambre / Cordura / Salud",
				},
			},
			["wiki"] = {
				description = {
					"Wiki",
					["zh"] = "维基",
					["br"] = "Wiki",
					["es"] = "Wiki",
				},
				hover = {
					"Health / Hunger / Sanity",
					["zh"] = "生命 / 饥饿 / 理智",
					["br"] = "Vida/ Fome / Sanidade",
					["es"] = "Salud / Hambre / Cordura",
				},
			},
		},
	},
	food_units = {
		label = {
			"Display food units", 
			["zh"] = "食物系数", 
			["br"] = "Exibir unidades de alimentos", 
			["es"] = "Expositor de comida"
		},
		hover = {
			"Whether food units are displayed.", 
			["zh"] = "是否显示食物的系数（果、菜、蛋度等等）。", 
			["br"] = "Se as unidades de alimentos são exibidas.", 
			["es"] = "Configura si se muestra las unidades de la comida."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Food units will not be displayed.",
					["zh"] = "不显示食物度。",
					["br"] = "Unidades de alimentos não serão exibidas.",
					["es"] = "No se muestra unidades de comida.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Food units WILL be displayed.",
					["zh"] = "显示食物度。",
					["br"] = "Unidades de alimentos SERÃO exibidas.",
					["es"] = "Se muestra unidades de comida.",
				},
			},
		},
	},
	food_effects = {
		label = {
			"Food Effects", 
			["zh"] = "食物加成属性", 
			["br"] = "Efeitos dos Alimentos", 
			["es"] = "Efectos de comida"
		},
		hover = {
			"Whether special food effects show or not.", 
			["zh"] = "是否显示食物的特殊加成属性。", 
			["br"] = "Se os efeitos especiais de comida aparecem ou não.", 
			["es"] = "Configura si se muestra los efectos especiales de la comida."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Special food effects will not show.",
					["zh"] = "不显示特殊的食物属性。",
					["br"] = "Efeitos de alimentos especiais não serão exibidos.",
					["es"] = "No se muestra los efectos especiales de la comida.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Special food effects will show.",
					["zh"] = "显示特殊的食物属性。",
					["br"] = "Efeitos de alimentos especiais serão exibidos.",
					["es"] = "Se muestra los efectos especiales de la comida.",
				},
			},
		},
	},
	stewer_chef = {
		label = {
			"Chef Identifiers", 
			["zh"] = "烹饪厨师显示", 
			["br"] = "Identificadores de Chef", 
			["es"] = "Identificador de chef"
		},
		hover = {
			"Whether the chef of a recipe is shown.", 
			["zh"] = "是否显示料理的制作人。", 
			["br"] = "Se quem fez uma receita na panela é mostrado na mesma.", 
			["es"] = "Configura si se muestra el chef de una receta."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The chef will not be shown.",
					["zh"] = "不显示料理的制作人。",
					["br"] = "Quem preparou não será mostrado.",
					["es"] = "El chef no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The chef will be shown.",
					["zh"] = "显示料理的制作人。",
					["br"] = "Quem preparou será mostrado.",
					["es"] = "Se muestra al chef.",
				},
			},
		},
	},
	food_memory = {
		label = {
			"Food Memory", 
			["zh"] = "瓦力大厨的食物计时", 
			["br"] = "Memória Alimentar", 
			["es"] = "Memoria de comida"
		},
		hover = {
			"Whether your food memory is shown.", 
			["zh"] = "是否显示瓦力大厨的食物计时。", 
			["br"] = "Se sua memória alimentar é mostrada.", 
			["es"] = "Configura si se muestra la memoria de comida (Warly)."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Your food memory will not be shown.",
					["zh"] = "不显示食物计时。",
					["br"] = "Sua memória alimentar não será exibida.",
					["es"] = "La memoria de alimentos no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Your food memory will be shown.",
					["zh"] = "显示食物计时。",
					["br"] = "Sua memória alimentar será exibida.",
					["es"] = "Se muestra su memoria de alimentos.",
				},
			},
		},
	},
	display_perishable = {
		label = {
			"Perishing", 
			["zh"] = "腐烂信息", 
			["br"] = "Perecíveis", 
			["es"] = "Putrefacción"
		},
		hover = {
			"Whether perishable information is displayed.", 
			["zh"] = "是否显示腐烂信息", 
			["br"] = "Se informações de perecíveis são exibidas.", 
			["es"] = "Configura si se muestra información de la putrefacción."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Perishable information is not shown.",
					["zh"] = "不显示腐烂信息",
					["br"] = "Informações de perecíveis não são mostradas.",
					["es"] = "No se muestra la información de putrefacción.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Perishable information is shown.",
					["zh"] = "显示腐烂信息",
					["br"] = "Informações de perecíveis são mostradas.",
					["es"] = "Se muestra la información de putrefacción.",
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
			["es"] = "Información de Cawnvival"
		},
		hover = {
			"Whether Midsummer Cawnvival information is shown.", 
			["zh"] = "是否显示盛夏鸦年华信息", 
			["br"] = "Se as informações do Midsummer Cawnvival são mostradas.", 
			["es"] = "Configura si se muestra la información de Midsummer Cawnvival."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Cawnival information is not shown.",
					["zh"] = "不显示鸦年华信息",
					["br"] = "Informações do Cawnival não são mostradas.",
					["es"] = "No se muestra la información de cawnvival.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Cawnival information is shown.",
					["zh"] = "显示鸦年华信息",
					["br"] = "Informações do Cawnival são mostradas.",
					["es"] = "Se muestra la información de cawnival.",
				},
			},
		},
	},
	display_yotb_winners = {
		label = {
			"Pageant Winners [YOTB]", 
			["zh"] = "选美大赛冠军 [\"皮弗娄牛之年\" 更新]", 
			["br"] = "Vencedores do Concurso [YOTB]", 
			["es"] = "Ganadores de concurso [YOTB]"
		},
		hover = {
			"Whether Pageant winners are shown.", 
			["zh"] = "是否显示选美大赛冠军", 
			["br"] = "Se os vencedores do concurso são mostrados.", 
			["es"] = "Configura si se muestran los ganadores del concurso."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The pageant winners are not shown.",
					["zh"] = "不显示选美大赛冠军",
					["br"] = "Os vencedores do concurso não são mostrados.",
					["es"] = "Los ganadores del concurso no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The pageant winners are shown.",
					["zh"] = "显示选美大赛冠军",
					["br"] = "Os vencedores do concurso são mostrados.",
					["es"] = "Se muestra los ganadores del concurso.",
				},
			},
		},
	},
	display_yotb_appraisal = {
		label = {
			"Appraisal Values [YOTB]", 
			["zh"] = "评价值 [\"皮弗娄牛之年\" 更新]", 
			["br"] = "Valores de avaliação [YOTB]", 
			["es"] = "Valores de tasación [YOTB]"
		},
		hover = {
			"Whether appraisal values are shown.", 
			["zh"] = "是否显示评价值", 
			["br"] = "Se os valores de avaliação são mostrados.", 
			["es"] = "Configura si se muestran los valores de tasación."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The appraisal values are not shown.",
					["zh"] = "不显示评价值",
					["br"] = "Os valores de avaliação não são mostrados.",
					["es"] = "Los valores de tasación no se muestran.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The appraisal values are shown.",
					["zh"] = "显示评价值",
					["br"] = "Os valores de avaliação são mostrados.",
					["es"] = "Se muestran los valores de tasación.",
				},
			},
		},
	},
	display_shared_stats = {
		label = {
			"Playerlist Stats", 
			["zh"] = "玩家列表中的数据", 
			["br"] = "Estatísticas dos jogadores", 
			["es"] = "Estadísticas de jugadores"
		},
		hover = {
			"Whether the stats of other players in the server are shown in the playerlist.", 
			["zh"] = "是否在玩家列表中显示服务器中其他玩家的数据", 
			["br"] = "Se as estatísticas de outros jogadores no servidor são mostradas na lista de jogadores (tecla TAB).", 
			["es"] = "Configura si se muestran en la lista las estadísticas de jugadores en el servidor."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The stats are not shown.",
					["zh"] = "不显示数据",
					["br"] = "As estatísticas não são mostradas.",
					["es"] = "Las estadísticas no se muestran.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The stats are shown.",
					["zh"] = "显示数据",
					["br"] = "As estatísticas são mostradas.",
					["es"] = "Se muestran las estadísticas.",
				},
			},
		},
	},
	display_worldmigrator = {
		label = {
			"Portal information", 
			["zh"] = "传送信息", 
			["br"] = "Informações do Portal", 
			["es"] = "Información de portal"
		},
		hover = {
			"Whether portal (sinkhole) information is shown.", 
			["zh"] = "是否显示传送信息 (洞穴)", 
			["br"] = "Se as informações do portal (sinkhole) são mostradas.", 
			["es"] = "Configura si se muestra la información del portal (sumidero)."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Portal information is not shown.",
					["zh"] = "不显示传送信息",
					["br"] = "As informações do portal não são mostradas.",
					["es"] = "La información de portal no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Portal information is shown.",
					["zh"] = "显示传送信息",
					["br"] = "As informações do portal são mostradas.",
					["es"] = "Se muestra la información de portal.",
				},
			},
		},
	},
	display_unwrappable = {
		label = {
			"Bundle information", 
			["zh"] = "打包信息", 
			["br"] = "Informações do Pacote", 
			["es"] = "Información de paquete"
		},
		hover = {
			"Whether bundle information is shown.", 
			["zh"] = "是否显示打包信息", 
			["br"] = "Se as informações de pacotes, embrulhos ou presentes são mostradas.", 
			["es"] = "Configura si se muestra la información de paquete."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Bundle information is not shown.",
					["zh"] = "不显示打包信息",
					["br"] = "As informações do pacote não são mostradas.",
					["es"] = "La información de paquete no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Bundle information is shown.",
					["zh"] = "显示打包信息",
					["br"] = "As informações do pacote são mostradas.",
					["es"] = "Se muestra la información de paquete.",
				},
			},
		},
	},
	display_fishing_information = {
		label = {
			"Fishing information", 
			["zh"] = "垂钓信息", 
			["br"] = "Informações de pesca", 
			["es"] = "Información de pesca"
		},
		hover = {
			"Whether fishing information is shown.", 
			["zh"] = "是否显示垂钓信息", 
			["br"] = "Se as informações de pesca são mostradas.", 
			["es"] = "Configura si se muestra la información de pesca."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Fishing information is not shown.",
					["zh"] = "不显示垂钓信息",
					["br"] = "Informações de pesca não são mostradas.",
					["es"] = "La información de pesca no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Fishing information is shown.",
					["zh"] = "显示垂钓信息",
					["br"] = "Informações de pesca são mostradas.",
					["es"] = "Se muestra la información de pesca.",
				},
			},
		},
	},
	display_spawner_information = {
		label = {
			"Spawner information", 
			["zh"] = "生物生成计时器", 
			["br"] = "Informações de geração", 
			["es"] = "Información de spawner"
		},
		hover = {
			"Whether creature spawners have information shown.", 
			["zh"] = "是否显示生物生成计时信息（猪人、兔人等）。", 
			["br"] = "Se os geradores (spawner) de criaturas têm informações mostradas.", 
			["es"] = "Configura si se muestra la información de spawners"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "禁用",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The spawner information is not shown.",
					["zh"] = "不显示生物生成计时信息。",
					["br"] = "A informação do spawner não é mostrada.",
					["es"] = "La información de spawners no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "启用",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The spawner information is shown.",
					["zh"] = "显示生物生成计时信息。",
					["br"] = "A informação do spawner é mostrada.",
					["es"] = "Se muestra la información de spawners.",
				},
			},
		},
	},
	weapon_damage = {
		label = {
			"Weapon Damage", 
			["zh"] = "武器伤害值", 
			["br"] = "Dano da Arma", 
			["es"] = "Daño de arma"
		},
		hover = {
			"Whether weapon damage is shown.", 
			["zh"] = "是否显示武器的伤害值。", 
			["br"] = "Se o dano da arma é mostrado.", 
			["es"] = "Configura si se muestra el daño del arma."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Weapon damage is not shown.",
					["zh"] = "不显示武器的伤害值。",
					["br"] = "Dano da arma não é mostrado.",
					["es"] = "El daño de arma no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Weapon damage is shown.",
					["zh"] = "显示武器的伤害值。",
					["br"] = "Dano da arma é mostrado.",
					["es"] = "Se muestra el daño de arma.",
				},
			},
		},
	},
	repair_values = {
		label = {
			"Repair Values", 
			["zh"] = "修补数值", 
			["br"] = "Valores de Reparo", 
			["es"] = "Valor de reparación"
		},
		hover = {
			"Whether repair information is displayed (on inspection).", 
			["zh"] = "是否显示物品的修复信息（需要检查）。", 
			["br"] = "Se as informações de reparo são exibidas (na inspeção).", 
			["es"] = "Configura si se muestra la información de reparación (en inspección)."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Repair information is not shown.",
					["zh"] = "不显示物品的修复信息",
					["br"] = "Informações de reparo não são mostradas.",
					["es"] = "El valor de reparación se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Repair information is shown.",
					["zh"] = "显示物品的修复信息。",
					["br"] = "Informações de reparo são mostradas.",
					["es"] = "No se muestra el valor de reparación.",
				},
			},
		},
	},
	klaus_sack_info = {
		label = {
			"Loot Stash Info", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"Whether the contents of the Loot Stash are visible.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Loot stash contents are NOT visible.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Loot stash contents are visible.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
		},
	},
	soil_moisture = {
		label = {
			"Soil Moisture", 
			["zh"] = "土壤潮湿度", 
			["br"] = "Umidade do solo", 
			["es"] = "Humedad del suelo"
		},
		hover = {
			"How soil/plant moisture is displayed.", 
			["zh"] = "如何显示土壤/植物的潮湿度。", 
			["br"] = "Como a umidade do solo/planta é exibida.", 
			["es"] = "Configura como se muestra la humedad del suelo/de las plantas."
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
				},
				hover = {
					"Soil moisture is not shown.",
					["zh"] = "不显示土壤潮湿度。",
					["br"] = "A umidade do solo não é mostrada.",
					["es"] = "No se muestra la humedad del suelo.",
				},
			},
			[1] = {
				description = {
					"Soil",
					["zh"] = "仅土壤",
					["br"] = "Solo",
					["es"] = "Suelo",
				},
				hover = {
					"Only soil moisture is shown.",
					["zh"] = "仅显示土壤的潮湿度。",
					["br"] = "Apenas a umidade do solo é mostrada.",
					["es"] = "Solo se muestra la humedad del suelo.",
				},
			},
			[2] = {
				description = {
					"Soil / Plant",
					["zh"] = "土壤/植株",
					["br"] = "Solo / Planta",
					["es"] = "Suelo / Planta",
				},
				hover = {
					"Soil moisture and the plant consumption rate is shown.",
					["zh"] = "显示土壤潮湿度和植株耗水率。",
					["br"] = "A umidade do solo e a taxa de consumo da planta são mostradas.",
					["es"] = "Se muestra la humedad del suelo y la tasa de consumo de la planta.",
				},
			},
			[3] = {
				description = {
					"Soil, Plant, Tile",
					["zh"] = "土壤，植株，耕地",
					["br"] = "Solo, Planta, Ladrilho",
					["es"] = "Suelo, planta y baldosa",
				},
				hover = {
					"Soil moisture, plant consumption, and the tile moisture rate is shown.",
					["zh"] = "显示土壤潮湿度，植株耗水率，耕地潮湿度。",
					["br"] = "A umidade do solo, o consumo da planta e a taxa de umidade do ladrilho são mostrados.",
					["es"] = "Se muestra la humedad del suelo, el consumo de las plantas y la tasa de humedad de las baldosas.",
				},
			},
			[4] = {
				description = {
					"All",
					["zh"] = "全部",
					["br"] = "Tudo",
					["es"] = "Todo",
				},
				hover = {
					"Soil moisture, plant consumption, and the **NET** tile moisture rate is shown.",
					["zh"] = "显示土壤潮湿度，植株耗水率，总耕地潮湿度。",
					["br"] = "A umidade do solo, o consumo da planta e a taxa de umidade do ladrilho **NET** são mostrados.",
					["es"] = "Humedad del suelo, consumo de las plantas, y se muestra la tasa de humedad de la baldosa **RED**.",
				},
			},
		},
	},
	soil_nutrients = {
		label = {
			"Soil Nutrients", 
			["zh"] = "土壤养分值", 
			["br"] = "Nutrientes do solo", 
			["es"] = "Nutrientes del suelo"
		},
		hover = {
			"How soil/plant nutrients are displayed.", 
			["zh"] = "如何显示土壤/植株的养分值。", 
			["br"] = "Como os nutrientes do solo/planta são exibidos.", 
			["es"] = "Configura como se muestran los nutrientes del suelo/de las plantas."
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
				},
				hover = {
					"Soil nutrients are not shown.",
					["zh"] = "不显示土壤养分值。",
					["br"] = "Os nutrientes do solo não são mostrados.",
					["es"] = "No se muestra los nutrientes.",
				},
			},
			[1] = {
				description = {
					"Soil",
					["zh"] = "仅土壤",
					["br"] = "Solo",
					["es"] = "Suelo",
				},
				hover = {
					"Only soil nutrients are shown.",
					["zh"] = "仅显示土壤养分值。",
					["br"] = "Apenas os nutrientes do solo são mostrados.",
					["es"] = "Solo se muestra los nutrientes del suelo.",
				},
			},
			[2] = {
				description = {
					"Soil / Plant",
					["zh"] = "土壤/植株",
					["br"] = "Solo / Planta",
					["es"] = "Suelo / Planta",
				},
				hover = {
					"Soil nutrients and the plant consumption rate are shown.",
					["zh"] = "显示土壤养分值和植株耗肥率。",
					["br"] = "Os nutrientes do solo e a taxa de consumo da planta são mostrados.",
					["es"] = "Se muestra los nutrientes del suelo y la tasa de consumo de las plantas.",
				},
			},
			[3] = {
				description = {
					"Soil, Plant, Tile",
					["zh"] = "土壤，植株，耕地",
					["br"] = "Solo, Planta, Ladrilho",
					["es"] = "Suelo, planta y baldosa",
				},
				hover = {
					"Soil nutrients, plant consumption, and the tile nutrients rate are all shown.",
					["zh"] = "显示土壤养分值，植株耗肥率，耕地养分值。",
					["br"] = "Os nutrientes do solo, o consumo de plantas e a taxa de nutrientes do ladrilho são mostrados.",
					["es"] = "Se muestra los nutrientes del suelo, el consumo de las plantas y la tasa de nutrientes de las baldosas.",
				},
			},
		},
	},
	soil_nutrients_needs_hat = {
		label = {
			"Display soil nutrients", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"When to display soil/plant nutrients.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = {
			["off"] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
				},
				hover = {
					"Soil nutrients are only shown with the hat.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			["hatonly"] = {
				description = {
					"Premier Gardeneer Hat",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Soil nutrients are only shown with the hat.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			["always"] = {
				description = {
					"Always",
					["zh"] = "总是",
					["br"] = "Sempre",
					["es"] = "Siempre",
				},
				hover = {
					"Soil nutrients are always shown.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
		},
	},
	display_plant_stressors = {
		label = {
			"Plant stress", 
			["zh"] = "植物压力", 
			["br"] = "Estresse da planta", 
			["es"] = "Estrés de planta"
		},
		hover = {
			"Determines whether plant stress is shown.", 
			["zh"] = "决定是否显示植物的压力", 
			["br"] = "Determina se o estresse da planta é mostrado.", 
			["es"] = "Configura si se muestra el estrés de las plantas."
		},
		options = {
			[0] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Plant stress is not shown.",
					["zh"] = "植物的压力将不会显示",
					["br"] = "O estresse da planta não é mostrado.",
					["es"] = "No se muestra el estrés.",
				},
			},
			[1] = {
				description = {
					"With Hat",
					["zh"] = "佩戴园艺帽时",
					["br"] = "Com chapéu",
					["es"] = "Con sombrero",
				},
				hover = {
					"Plant stress will be shown if you have the Premier Gardeneer Hat.",
					["zh"] = "如果你身上有，或戴上远古园艺帽时，显示植物的压力",
					["br"] = "O estresse da planta será mostrado se você tiver o Chapéu Premier Gardeneer.",
					["es"] = "El estrés se mostrará si se tiene un Gardeneer Hat.",
				},
			},
			[2] = {
				description = {
					"Always",
					["zh"] = "总是",
					["br"] = "Sempre",
					["es"] = "Siempre",
				},
				hover = {
					"Plant stress is always shown.",
					["zh"] = "总是显示植物的压力",
					["br"] = "O estresse da planta é sempre mostrado.",
					["es"] = "Se muestra siempre el estrés de la planta.",
				},
			},
		},
	},
	display_fertilizer = {
		label = {
			"Fertilizer", 
			["zh"] = "肥料", 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"Determines whether fertilizer nutrients are shown.", 
			["zh"] = "决定是否显示肥料养分值", 
			["br"] = nil, 
			["es"] = nil
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Fertilizer nutrients are not shown.",
					["zh"] = "不显示肥料养分值",
					["br"] = nil,
					["es"] = nil,
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Fertilizer nutrients are shown.",
					["zh"] = "显示肥料养分值",
					["br"] = nil,
					["es"] = nil,
				},
			},
		},
	},
	display_weighable = {
		label = {
			"Item Weight", 
			["zh"] = "物品重量", 
			["br"] = "Peso do item", 
			["es"] = "Peso de artículo"
		},
		hover = {
			"Determines whether item weight is shown.", 
			["zh"] = "是否显示物品的重量", 
			["br"] = "Determina se o peso do item é mostrado.", 
			["es"] = "Configura si se muestra el peso de artículos."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Item weight is not shown.",
					["zh"] = "不显示物品的重量值",
					["br"] = "O peso do item não é mostrado.",
					["es"] = "No se muestra el peso.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Item weight is shown.",
					["zh"] = "显示物品的重量值",
					["br"] = "O peso do item é mostrado.",
					["es"] = "Se muestra el peso.",
				},
			},
		},
	},
	display_world_events = {
		label = {
			"Show World Data", 
			["zh"] = "世界事件", 
			["br"] = "Mostrar dados do Mundo", 
			["es"] = "Eventos del mundo"
		},
		hover = {
			"Determines whether world data is shown.\nExamples: Hounds/Worms, Bosses, Earthquakes, etc.", 
			["zh"] = "是否显示世界事件。世界事件有：猎犬/蠕虫，Boss，地震和其他事件。", 
			["br"] = "Determina se os dados do mundo são mostrados.\nExemplos: Hounds/Worms, Bosses, Earthquakes, etc.", 
			["es"] = "Configura si se muestra los eventos del mundo (sabuesos/gusanos, jefes, terremotos, etc.)"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"World data is not shown.",
					["zh"] = "不展示世界事件。",
					["br"] = "Os dados do mundo não são mostrados.",
					["es"] = "No se muestran los eventos.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"World data is shown.",
					["zh"] = "显示世界事件。",
					["br"] = "Os dados do mundo são mostrados.",
					["es"] = "Se muestran los eventos.",
				},
			},
		},
	},
	display_weather = {
		label = {
			"Weather information", 
			["zh"] = "天气信息", 
			["br"] = "Mostrar informações meteorológicas", 
			["es"] = "Información meteorológica"
		},
		hover = {
			"Determines whether weather information is shown.", 
			["zh"] = "是否显示天气信息。", 
			["br"] = "Determina se as informações meteorológicas são mostradas.", 
			["es"] = "Configura si se muestra la información meteorológica."
		},
		options = {
			[0] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Weather is not shown.",
					["zh"] = "不显示天气信息",
					["br"] = "O clima não é mostrado",
					["es"] = "El clima no se muestra.",
				},
			},
			[1] = {
				description = {
					"With Rainometer",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Weather is shown if a Rainometer is in the world.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			[2] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Weather is shown.",
					["zh"] = "显示天气信息",
					["br"] = "O clima é mostrado.",
					["es"] = "Se muestra el clima.",
				},
			},
		},
	},
	nightmareclock_display = {
		label = {
			"Nightmare Phases", 
			["zh"] = "洞穴暴动阶段", 
			["br"] = "Fases de Pesadelo", 
			["es"] = "Ciclo pesadilla"
		},
		hover = {
			"Controls when users receive information about the Nightmare Phases.", 
			["zh"] = "是否显示洞穴暴动的具体阶段。", 
			["br"] = "Controla quando os usuários recebem informações sobre as Fases de Pesadelo (Ruins).", 
			["es"] = "Configura cuando los usuarios reciben información sobre los ciclos pesadilla."
		},
		options = {
			[0] = {
				description = {
					"Off",
					["zh"] = "禁用",
					["br"] = "Desligado",
					["es"] = "Desactivado",
				},
				hover = {
					"No nightmare phase information is shown.",
					["zh"] = "不显示洞穴暴动的阶段信息。",
					["br"] = "Nenhuma informação da fase de pesadelo é mostrada.",
					["es"] = "No se muestra información del ciclo pesadilla.",
				},
			},
			[1] = {
				description = {
					"Need Medallion",
					["zh"] = "拥有铥矿勋章",
					["br"] = "Precisa do Medalhão",
					["es"] = "Medallón necesario",
				},
				hover = {
					"Nightmare phase information is shown if a Thulecite Medallion is present.",
					["zh"] = "拥有铥矿勋章时显示。",
					["br"] = "Informações da fase de pesadelo são mostradas se um Thulecite Medallion estiver presente.",
					["es"] = "Se muestra información si se tiene un medallón de tulecita.",
				},
			},
			[2] = {
				description = {
					"On",
					["zh"] = "启用",
					["br"] = "Ligado",
					["es"] = "Activado",
				},
				hover = {
					"Nightmare phase information is always shown.",
					["zh"] = "总是显示暴动阶段的信息。",
					["br"] = "Informações da fase de pesadelo são sempre mostradas.",
					["es"] = "Se muestra siempre la información del ciclo pesadilla.",
				},
			},
		},
	},
	display_health = {
		label = {
			"Health", 
			["zh"] = "生命值", 
			["br"] = "Vida", 
			["es"] = "Salud"
		},
		hover = {
			"Whether health information should be shown.", 
			["zh"] = "是否显示生命值的信息。", 
			["br"] = "Se as informações de saúde devem ser mostradas.", 
			["es"] = "Configura si muestra información de salud."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Health information is not shown.",
					["zh"] = "不显示生命值信息。",
					["br"] = "Informações de saúde não são mostradas.",
					["es"] = "No se muestra información de salud.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Health information is shown.",
					["zh"] = "显示生命值信息。",
					["br"] = "Informações de saúde são mostradas.",
					["es"] = "Se muestra la información de salud.",
				},
			},
		},
	},
	display_hunger = {
		label = {
			"Hunger", 
			["zh"] = "物品饥饿值", 
			["br"] = "Fome", 
			["es"] = "Hambre"
		},
		hover = {
			"How much hunger detail is shown.", 
			["zh"] = "如何显示物品的饥饿值。", 
			["br"] = "Quantos detalhes de fome são mostrados.", 
			["es"] = "Configura cuántos detalles de hambre se muestra."
		},
		options = {
			[0] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display hunger.",
					["zh"] = "不显示饥饿值。",
					["br"] = "Não exibirá fome.",
					["es"] = "No muestra el hambre.",
				},
			},
			[1] = {
				description = {
					"Standard",
					["zh"] = "标准",
					["br"] = "Padrão",
					["es"] = "Standard",
				},
				hover = {
					"Will display standard hunger information.",
					["zh"] = "显示标准的饥饿值。",
					["br"] = "Mostrará informações padrão de fome.",
					["es"] = "Muestra la información estándar del hambre.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "完整",
					["br"] = "Tudo",
					["es"] = "All",
				},
				hover = {
					"Will display all hunger information.",
					["zh"] = "显示完整物品的饥饿值。",
					["br"] = "Mostrará todas as informações de fome.",
					["es"] = "Muestra toda la información del hambre.",
				},
			},
		},
	},
	display_sanity = {
		label = {
			"Sanity", 
			["zh"] = "理智", 
			["br"] = "Sanidade", 
			["es"] = "Cordura"
		},
		hover = {
			"Whether sanity information is shown.", 
			["zh"] = "是否显示理智信息", 
			["br"] = "Se as informações de sanidade são mostradas.", 
			["es"] = "Configura se muestra la información de cordura."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "否",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display sanity information.",
					["zh"] = "不显示理智信息",
					["br"] = "Não exibirá informações de sanidade.",
					["es"] = "No se muestra información de cordura.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "是",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Will display sanity information.",
					["zh"] = "显示理智信息",
					["br"] = "Exibirá informações de sanidade.",
					["es"] = "Se muestra información de cordura.",
				},
			},
		},
	},
	display_sanityaura = {
		label = {
			"Sanity Auras", 
			["zh"] = "理智光环", 
			["br"] = "Auras de Sanidade", 
			["es"] = "Auras de cordura"
		},
		hover = {
			"Whether sanity auras are shown.", 
			["zh"] = "是否显示理智光环。", 
			["br"] = "Se as auras de sanidade são mostradas.", 
			["es"] = "Configura si se muestra las auras de cordura."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "否",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display sanity auras.",
					["zh"] = "不显示理智光环。",
					["br"] = "Não exibirá auras de sanidade.",
					["es"] = "No se muestra auras de cordura.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "是",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Will display sanity auras.",
					["zh"] = "显示理智光环。",
					["br"] = "Exibirá auras de sanidade.",
					["es"] = "Se muestra auras de cordura.",
				},
			},
		},
	},
	display_sanity_interactions = {
		label = {
			"Sanity Interactions", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		hover = {
			"Whether interactions that affect sanity are shown.", 
			["zh"] = nil, 
			["br"] = nil, 
			["es"] = nil
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "否",
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Will not display sanity interactions.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "是",
					["br"] = nil,
					["es"] = nil,
				},
				hover = {
					"Will display sanity interactions.",
					["zh"] = nil,
					["br"] = nil,
					["es"] = nil,
				},
			},
		},
	},
	display_mob_attack_damage = {
		label = {
			"Mob Attack Damage", 
			["zh"] = "怪物攻击范围", 
			["br"] = "Dano de Ataque de Mobs", 
			["es"] = "Daño de ataque de mobs"
		},
		hover = {
			"Whether mob attack damage is shown.", 
			["zh"] = "是否显示怪物的攻击范围", 
			["br"] = "Se o dano de ataque de mobs é mostrado.", 
			["es"] = "Configura si se muestra el daño de ataque de mobs."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Mob attack damage is not shown.",
					["zh"] = "不显示怪物的攻击范围",
					["br"] = "Dano de ataque dos mobs não é mostrado.",
					["es"] = "No se muestra el daño de ataque de mobs.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Mob attack damage is shown.",
					["zh"] = "显示怪物的攻击范围",
					["br"] = "Dano de ataque dos mobs é mostrado.",
					["es"] = "Se muestra el daño de ataque de mobs.",
				},
			},
		},
	},
	growth_verbosity = {
		label = {
			"Growth Verbosity", 
			["zh"] = "植物生长阶段", 
			["br"] = "Verbosidade do Crescimento", 
			["es"] = "Verbosidad de crecimiento"
		},
		hover = {
			"How detailed growth information should be.", 
			["zh"] = "显示植物生长的具体信息。", 
			["br"] = "Como as informações de crescimento detalhadas devem ser exibidas.", 
			["es"] = "Configura cómo de detallada es la información sobre el crecimiento de entidades."
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Nula",
				},
				hover = {
					"Displays nothing about growable entities.",
					["zh"] = "不显示会生长的物品的信息。",
					["br"] = "Não exibe nada sobre entidades cultiváveis.",
					["es"] = "No muestra nada sobre las entidades que pueden crecer.",
				},
			},
			[1] = {
				description = {
					"Minimal",
					["zh"] = "简短",
					["br"] = "Mínima",
					["es"] = "Mínima",
				},
				hover = {
					"Displays time until next stage.",
					["zh"] = "仅显示生长到下一阶段所需的时间。",
					["br"] = "Exibe o tempo até o próximo estágio.",
					["es"] = "Muestra el tiempo hasta la siguiente etapa.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "详细",
					["br"] = "Tudo",
					["es"] = "Completa",
				},
				hover = {
					"Displays current stage name, number of stages, and time until next stage.",
					["zh"] = "显示当前阶段名称，阶段的数字，长到下一阶段所需的时间。",
					["br"] = "Exibe o nome do estágio atual, número de estágios e tempo até o próximo estágio.",
					["es"] = "Muestra el nombre de la etapa actual, el número de etapas y el tiempo hasta la siguiente etapa.",
				},
			},
		},
	},
	display_pickable = {
		label = {
			"Pickable Information", 
			["zh"] = "可采集信息", 
			["br"] = "Informações selecionáveis", 
			["es"] = "Información de recolección"
		},
		hover = {
			"Whether pickable information should be shown (ex: Berry Bushes)", 
			["zh"] = "Whether pickable information should be shown (ex: Berry Bushes)", 
			["br"] = "Se as informações selecionáveis devem ser mostradas (ex: Berry Bushes).", 
			["es"] = "Configura si se muestra la información seleccionable (por ej., arbustos de bayas)"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Pickable information will not be displayed.",
					["zh"] = "不显示可采集信息",
					["br"] = "Informações selecionáveis não serão exibidas.",
					["es"] = "No se muestra la información de recolección.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Pickable information will be displayed.",
					["zh"] = "显示可采集信息",
					["br"] = "Informações selecionáveis serão exibidas.",
					["es"] = "Se muestra la información seleccionable.",
				},
			},
		},
	},
	display_harvestable = {
		label = {
			"Harvestable Information", 
			["zh"] = "可收获信息", 
			["br"] = "Informações de colheitas", 
			["es"] = "Información de cosecha"
		},
		hover = {
			"Whether harvestable information should be shown (ex: Bee Boxes)", 
			["zh"] = "Whether harvestable information should be shown (ex: Bee Boxes)", 
			["br"] = "Se as informações de colheita devem ser mostradas (ex: Bee Boxes).", 
			["es"] = "Configura si se muestra la información cosechable (por ej., cajas de abejas)"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Harvestable information will not be displayed.",
					["zh"] = "不显示可收获信息",
					["br"] = "Informações de colheitas não serão exibidas.",
					["es"] = "No se muestra la información de cosecha.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Harvestable information will be displayed.",
					["zh"] = "显示可收获信息",
					["br"] = "Informações de colheitas serão exibidas.",
					["es"] = "Se muestra la información de cosecha.",
				},
			},
		},
	},
	display_finiteuses = {
		label = {
			"Tool Durability", 
			["zh"] = "工具耐久度", 
			["br"] = "Durabilidade da Ferramenta", 
			["es"] = "Durabilidad de herramientas"
		},
		hover = {
			"Whether tool durability is displayed.", 
			["zh"] = "是否显示工具的耐久度", 
			["br"] = "Se a durabilidade da ferramenta é exibida.", 
			["es"] = "Configura si se muestra la durabilidad de herramientas."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Tool durability will not be displayed.",
					["zh"] = "不显示工具的耐久度",
					["br"] = "A durabilidade da ferramenta não será exibida.",
					["es"] = "No se muestra la durabilidad de las herramientas.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Tool durability will be displayed.",
					["zh"] = "显示工具的耐久度",
					["br"] = "A durabilidade da ferramenta será exibida.",
					["es"] = "Se muestra la durabilidad de las herramientas.",
				},
			},
		},
	},
	display_timers = {
		label = {
			"Timers", 
			["zh"] = "计时器", 
			["br"] = "Temporizadores", 
			["es"] = "Temporizadores"
		},
		hover = {
			"Whether timer information is displayed.", 
			["zh"] = "是否开启计时器。", 
			["br"] = "Se as informações do temporizador são exibidas.", 
			["es"] = "Configura si se muestra temporizadores de eventos."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Timers will not be displayed.",
					["zh"] = "关闭计时器。",
					["br"] = "Temporizadores não serão exibidos.",
					["es"] = "No se muestra temporizadores.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Timers will be displayed.",
					["zh"] = "开启计时器。",
					["br"] = "Temporizadores serão exibidos.",
					["es"] = "Se muestra temporizadores.",
				},
			},
		},
	},
	display_upgradeable = {
		label = {
			"Upgradeables", 
			["zh"] = "可升级物品显示", 
			["br"] = "Atualizáveis", 
			["es"] = "Etapas"
		},
		hover = {
			"Whether upgradeable information is displayed.", 
			["zh"] = "可升级物品", 
			["br"] = "Se as informações de atualizáveis são exibidas.", 
			["es"] = "Configura si se muestra la información de etapas en estructuras (árboles, nidos de araña, etc.)"
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "No",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display information for upgradeable structures.",
					["zh"] = "不显示可升级的建筑等物品的信息。",
					["br"] = "Não exibe informações de estruturas atualizáveis",
					["es"] = "No muestra información de etapas.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Yes",
					["es"] = "Activado",
				},
				hover = {
					"Displays information for upgradeable structures, such as spider dens.",
					["zh"] = "显示可升级的物品的信息，如蜘蛛巢等。",
					["br"] = "Exibe informações de estruturas atualizáveis, como ninhos de aranhas.",
					["es"] = "Muestra información de etapas.",
				},
			},
		},
	},
	naughtiness_verbosity = {
		label = {
			"Naughtiness verbosity", 
			["zh"] = "淘气值", 
			["br"] = "Verbalidade das travessuras", 
			["es"] = "Verbosidad de maldad"
		},
		hover = {
			"How verbose the naughtiness information should be. Combined Status takes precedence for player naughtiness.", 
			["zh"] = "如何显示淘气值。Combined Status 模组的淘气值显示优先于本模组。", 
			["br"] = "Quão verbosa deve ser a informação de travessuras. O Combined Status tem precedência para as travessuras do jogador.", 
			["es"] = "Elige como es de detallada la información de maldad. Combined Status tiene prioridad sobre Insight."
		},
		options = {
			[0] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Most naughtiness values will not display.",
					["zh"] = "不显示淘气值。",
					["br"] = "A maioria dos valores de travessuras não serão exibidos.",
					["es"] = "La mayoría de valores de maldad no se mostrarán.",
				},
			},
			[1] = {
				description = {
					"Creature",
					["zh"] = "生物的淘气值",
					["br"] = "Criatura",
					["es"] = "Criatura",
				},
				hover = {
					"Creature naughtiness values will display.",
					["zh"] = "显示击杀生物的淘气值。",
					["br"] = "Os valores de travessuras da criatura serão exibidos.",
					["es"] = "Se mostrarán los valores de maldad de los mobs.",
				},
			},
			[2] = {
				description = {
					"Plr/Creature",
					["zh"] = "玩家/生物的淘气值",
					["br"] = "Plr/Criatura",
					["es"] = "Jgd/Criatura",
				},
				hover = {
					"Player and creature naughtiness values will display.",
					["zh"] = "同时显示玩家已有的淘气值和击杀生物的淘气值。",
					["br"] = "Os valores de travessuras do jogador e da criatura serão exibidos.",
					["es"] = "Se mostrarán los valores de maldad de jugadores y mobs.",
				},
			},
		},
	},
	follower_info = {
		label = {
			"Followers", 
			["zh"] = "随从信息", 
			["br"] = "Seguidores", 
			["es"] = "Seguidores"
		},
		hover = {
			"Whether follower information is displayed.", 
			["zh"] = "是否显示你的跟随者的信息。", 
			["br"] = "Se as informações dos seguidores são exibidas.", 
			["es"] = "Configura si se muestra la información de seguidores (Chester, Gloomer, etc.)"
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display follower information.",
					["zh"] = "不显示跟随者的信息。",
					["br"] = "Não exibirá informações de seguidores.",
					["es"] = "No mostrará información de los seguidores.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Will display follower information.",
					["zh"] = "显示跟随者的信息。",
					["br"] = "Mostrará informações de seguidores.",
					["es"] = "Muestra información de los seguidores.",
				},
			},
		},
	},
	herd_information = {
		label = {
			"Herds", 
			["zh"] = "兽群信息", 
			["br"] = "Rebanhos", 
			["es"] = "Manadas"
		},
		hover = {
			"Whether herd information is displayed.", 
			["zh"] = "兽群的信息是否会显示。", 
			["br"] = "Se as informações de rebanhos são exibidas.", 
			["es"] = "Configura si se muestra información de la manada."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display herd information.",
					["zh"] = "不显示兽群的信息。",
					["br"] = "Não exibirá informações dos rebanhos.",
					["es"] = "No muestra información de la manada.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Will display herd information.",
					["zh"] = "显示兽群的信息。",
					["br"] = "Mostrará informações de rebanhos.",
					["es"] = "Muestra información de la manada.",
				},
			},
		},
	},
	domestication_information = {
		label = {
			"Domestication", 
			["zh"] = "牛驯服度", 
			["br"] = "Domesticação", 
			["es"] = "Domesticación"
		},
		hover = {
			"Whether domestication information is displayed.", 
			["zh"] = "是否显示牛的驯服度。", 
			["br"] = "Se as informações de domesticação são exibidas.", 
			["es"] = "Configura si muestra información de domesticación."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display domestication information.",
					["zh"] = "不显示牛的驯服度信息。",
					["br"] = "Não exibirá informações de domesticação.",
					["es"] = "No muestra información de domesticación.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Will display domestication information.",
					["zh"] = "显示牛的驯服度信息。",
					["br"] = "Mostrará informações de domesticação.",
					["es"] = "Muestra información sobre la domesticación.",
				},
			},
		},
	},
	display_pollination = {
		label = {
			"Pollination", 
			["zh"] = "授粉信息", 
			["br"] = "Polinização", 
			["es"] = "Polinización"
		},
		hover = {
			"Whether pollination information is displayed.", 
			["zh"] = "是否显示蜜蜂、蝴蝶的授粉信息。", 
			["br"] = "Se as informações de polinização são exibidas.", 
			["es"] = "Configura si se muestra información de polinización."
		},
		options = {
			[false] = {
				description = {
					"Disabled",
					["zh"] = "禁用",
					["br"] = "Desabilitado",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display pollination information.",
					["zh"] = "不显示授粉信息。",
					["br"] = "Não exibirá informações de polinização.",
					["es"] = "No muestra información sobre la polinización.",
				},
			},
			[true] = {
				description = {
					"Enabled",
					["zh"] = "启用",
					["br"] = "Habilitado",
					["es"] = "Activado",
				},
				hover = {
					"Will display pollination information.",
					["zh"] = "显示授粉信息。",
					["br"] = "Mostrará informações de polinização.",
					["es"] = "Muestra información sobre la polinización.",
				},
			},
		},
	},
	item_worth = {
		label = {
			"Display item worth", 
			["zh"] = "物品价值", 
			["br"] = "Exibir o valor do item", 
			["es"] = "Valor de objeto"
		},
		hover = {
			"Whether item worth is displayed.", 
			["zh"] = "是否会显示物品的黄金或金币价值。", 
			["br"] = "Se o valor de itens que valem ouro/dubloon é exibido.", 
			["es"] = "Configura si muestra el valor de un objeto (oro y doblones)."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display gold or dubloon value.",
					["zh"] = "不显示物品的价值。",
					["br"] = "Não exibirá o valor de ouro ou dubloon.",
					["es"] = "No mostrará ningún valor.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Will display gold and dubloon value.",
					["zh"] = "显示物品值的价值。",
					["br"] = "Mostrará o valor do ouro e do dubloon.",
					["es"] = "Mostrará el valor en oro y doblones.",
				},
			},
		},
	},
	appeasement_value = {
		label = {
			"Display Appeasement", 
			["zh"] = "蚁狮", 
			["br"] = "Exibir Apaziguamento", 
			["es"] = "Valor de apaciguamiento"
		},
		hover = {
			"Whether appeasement worth is displayed.", 
			["zh"] = "是否显示蚁狮献祭时间和作乱的信息。", 
			["br"] = "Se o valor do apaziguamento é exibido.", 
			["es"] = "Configura si se muestra el valor de apaciguamiento."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display appeasement value.",
					["zh"] = "不显示蚁狮的信息。",
					["br"] = "Não exibirá valor de apaziguamento.",
					["es"] = "No se muestra ningún valor.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Will display appeasement value.",
					["zh"] = "显示蚁狮的信息。",
					["br"] = "Mostrará o valor de apaziguamento.",
					["es"] = "Muestra el valor de apaciguamiento.",
				},
			},
		},
	},
	fuel_verbosity = {
		label = {
			"Fuel Verbosity", 
			["zh"] = "燃料", 
			["br"] = "Verbosidade do Combustível", 
			["es"] = "Verbosidad del combustible"
		},
		hover = {
			"How verbose fuel information is.", 
			["zh"] = "如何显示燃料的信息。", 
			["br"] = "Quão detalhadas são as informações de combustível.", 
			["es"] = "Configura como es de extensa es la información sobre el combustible."
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "无",
					["br"] = "Nenhuma",
					["es"] = "Ninguno",
				},
				hover = {
					"No fuel information will show.",
					["zh"] = "不显示燃料信息",
					["br"] = "Nenhuma informação de combustível será exibida.",
					["es"] = "No se muestra ninguna información sobre el combustible.",
				},
			},
			[1] = {
				description = {
					"Standard",
					["zh"] = "标准",
					["br"] = "Padrão",
					["es"] = "Estándar",
				},
				hover = {
					"Standard fuel information will show.",
					["zh"] = "显示标准的燃料信息",
					["br"] = "Informações padrão de combustível serão exibidas.",
					["es"] = "Se muestra información estándar del combustible.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "全面",
					["br"] = "Tudo",
					["es"] = "Todo",
				},
				hover = {
					"All fuel information will show.",
					["zh"] = "显示全面的燃料信息",
					["br"] = "Todas as informações de combustível serão exibidas.",
					["es"] = "Se muestra toda la información sobre el combustible.",
				},
			},
		},
	},
	display_shelter_info = {
		label = {
			"Shelter Information", 
			["zh"] = "遮蔽处信息", 
			["br"] = "Informações do Abrigo", 
			["es"] = "Información del refugio"
		},
		hover = {
			"Whether to display shelter information.", 
			["zh"] = "是否显示遮蔽处信息", 
			["br"] = "Se exibe informações do abrigo.", 
			["es"] = "Configura si se muestra información del refugio."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Shelter information is not shown.",
					["zh"] = "不显示遮蔽处信息",
					["br"] = "As informações do abrigo não são mostradas.",
					["es"] = "No se muestra información del refugio.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Shelter information is shown.",
					["zh"] = "显示遮蔽处信息",
					["br"] = "As informações do abrigo são mostradas.",
					["es"] = "Se muestra información del refugio.",
				},
			},
		},
	},
	unique_info = {
		label = {
			"Unique Information", 
			["zh"] = "特定信息", 
			["br"] = "Informações Únicas", 
			["es"] = "Información única"
		},
		hover = {
			"Whether to display unique information for certain entities.", 
			["zh"] = "是否显示特定实体的特定信息", 
			["br"] = "Se vai exibir informações exclusivas para determinadas entidades.", 
			["es"] = "Configura si se muestra información única de ciertas entidades."
		},
		options = {
			[0] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"No unique information is shown.",
					["zh"] = "不显示特定信息",
					["br"] = "Nenhuma informação exclusiva é mostrada",
					["es"] = "No se muestra ninguna información única.",
				},
			},
			[1] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Unique information is shown.",
					["zh"] = "显示特定信息",
					["br"] = "Informações exclusivas são mostradas.",
					["es"] = "Se muestra información única.",
				},
			},
		},
	},
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	--[[ Miscellaneous ]]
	--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	display_crafting_lookup_button = {
		label = {
			"Crafting Lookup Button", 
			["zh"] = "建造查看按钮", 
			["br"] = "Botão de pesquisa no Crafting", 
			["es"] = "Botón de búsqueda"
		},
		hover = {
			"Whether the crafting lookup button is displayed or not.", 
			["zh"] = "是否显示建造查看按钮", 
			["br"] = "Se o botão de pesquisa na aba de criação é exibido ou não.", 
			["es"] = "Configura si se muestra un botón de búsqueda (de creación)."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The button is not shown.",
					["zh"] = "不显示按钮",
					["br"] = "O botão não é exibido.",
					["es"] = "El botón no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The button is shown.",
					["zh"] = "显示按钮",
					["br"] = "O botão é exibido.",
					["es"] = "Se muestra el botón.",
				},
			},
		},
	},
	display_insight_menu_button = {
		label = {
			"Insight Menu Button", 
			["zh"] = "Insight 目录按钮", 
			["br"] = "Botão do Menu Insight", 
			["es"] = "Botón menú de Insight"
		},
		hover = {
			"Whether the insight menu button is displayed or not.", 
			["zh"] = "是否显示 Insight 目录按钮", 
			["br"] = "Se o botão do menu Insight é exibido ou não.", 
			["es"] = "Configura si se muestra el botón del menú de Insight."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The button is not shown.",
					["zh"] = "不显示按钮",
					["br"] = "O botão não é exibido.",
					["es"] = "The button is not shown.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The button is shown.",
					["zh"] = "显示按钮",
					["br"] = "O botão é exibido.",
					["es"] = "The button is shown.",
				},
			},
		},
	},
	extended_info_indicator = {
		label = {
			"More Information Hint", 
			["zh"] = "更多信息提示", 
			["br"] = "Dica de Mais Informações", 
			["es"] = "Indicador de información extra"
		},
		hover = {
			"Whether an asterisk is present for entities with more information.", 
			["zh"] = "是否在有更多信息的实体上显示星号", 
			["br"] = "Se um asterisco está presente para entidades com mais informações.", 
			["es"] = "Muestra un asterisco sobre entidades con más información disponible."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The indicator is not shown.",
					["zh"] = "不显示星号",
					["br"] = "O indicador não é mostrado.",
					["es"] = "El indicador no se muestra.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The indicator is shown.",
					["zh"] = "显示星号",
					["br"] = "O indicador é mostrado.",
					["es"] = "Se muestra el indicador.",
				},
			},
		},
	},
	info_preload = {
		label = {
			"Information preloading", 
			["zh"] = "信息预载", 
			["br"] = "Pré-carregamento de informações", 
			["es"] = "Precarga de información"
		},
		hover = {
			"Whether information is preloaded when entities become visible. Trades network usage for faster performance. Recommended to use \"All\".", 
			["zh"] = "是否预先加载可见范围内所有实体的信息。消耗更多网络以获取更好的表现。推荐使用 \"所有\"。", 
			["br"] = "Se as informações são pré-carregadas quando as entidades se tornam visíveis. Troca o uso da rede para um desempenho mais rápido. Recomendado usar \"Todos\".", 
			["es"] = "Precarga información solo cuando las entidades son visibles. Intercambia el uso de la red mejorar el rendimiento."
		},
		options = {
			[0] = {
				description = {
					"None",
					["zh"] = "否",
					["br"] = "Nenhuma",
					["es"] = "Desactivado",
				},
				hover = {
					"CAN CAUSE SEVERE FPS DROPS. NOT RECOMMENDED.",
					["zh"] = "严重帧数降低，不推荐",
					["br"] = "PODE CAUSAR QUEDAS DE FPS GRAVES. NÃO RECOMENDADO.",
					["es"] = "PUEDE CAUSAR GRAVES CAÍDAS DE FPS. NO SE RECOMIENDA.",
				},
			},
			[1] = {
				description = {
					"Containers",
					["zh"] = "容器",
					["br"] = "Contêineres",
					["es"] = "En bloques",
				},
				hover = {
					"POSSIBLE FPS DROP. NOT RECOMMENDED. CAN USE FOR SMALL, CLEAN BASES.",
					["zh"] = "小幅帧数降低，不推荐。可用于小型简单的基地。",
					["br"] = "POSSÍVEL QUEDA DE FPS. NÃO RECOMENDADO. PODE SER USADO PARA BASES PEQUENAS E LIMPAS.",
					["es"] = "Posible caída de FPS. No se recomienda. Puede usarse para bases pequeñas y limpias.",
				},
			},
			[2] = {
				description = {
					"All",
					["zh"] = "所有",
					["br"] = "Tudo",
					["es"] = "Activado",
				},
				hover = {
					"FASTEST. RECOMMENDED.",
					["zh"] = "最高帧率，推荐。",
					["br"] = "O MAIS RÁPIDO. RECOMENDADO.",
					["es"] = "Lo más rápido. Recomendado.",
				},
			},
		},
	},
	refresh_delay = {
		label = {
			"Refresh delay", 
			["zh"] = "信息刷新延时", 
			["br"] = "Atraso de atualização", 
			["es"] = "Retardo de actualización"
		},
		hover = {
			"How often you can re-request information for the same item.", 
			["zh"] = "多久更新物品的信息。", 
			["br"] = "Com que frequência você pode solicitar novamente informações para o mesmo item.", 
			["es"] = "La frecuencia con la que puede volver a solicitar información para el mismo elemento."
		},
		options = {
			[true] = {
				description = {
					"Automatic",
					["zh"] = "自动设定",
					["br"] = "Automático",
					["es"] = "Automático",
				},
				hover = {
					"Dynamicly chosen based on current performance stats.",
					["zh"] = "基于玩家和游戏性能，动态更新。",
					["br"] = "Escolhido dinamicamente com base nas estatísticas de desempenho atuais.",
					["es"] = "Cambia dinámicamente en función de las estadísticas de rendimiento actuales.",
				},
			},
			[0] = {
				description = {
					"None",
					["zh"] = "实时",
					["br"] = "Nenhuma",
					["es"] = "None",
				},
				hover = {
					"Information is live.",
					["zh"] = "信息实时更新。",
					["br"] = "A informação é atualizada ao vivo.",
					["es"] = "La información está en vivo.",
				},
			},
			[0.25] = {
				description = {
					"0.25s",
					["zh"] = "0.25秒",
					["br"] = "0.25s",
					["es"] = "0.25s",
				},
				hover = {
					"Information updates every 0.25 seconds.",
					["zh"] = "信息每0.25秒更新。",
					["br"] = "As informações são atualizadas a cada 0,25 segundos.",
					["es"] = "La información se actualiza cada 0,25 segundos.",
				},
			},
			[0.5] = {
				description = {
					"0.5s",
					["zh"] = "0.5秒",
					["br"] = "0.5s",
					["es"] = "0.5s",
				},
				hover = {
					"Information updates every 0.5 seconds.",
					["zh"] = "信息每0.5秒更新。",
					["br"] = "As informações são atualizadas a cada 0,5 segundos.",
					["es"] = "La información se actualiza cada 0,5 segundos.",
				},
			},
			[1] = {
				description = {
					"1s",
					["zh"] = "1秒",
					["br"] = "1s",
					["es"] = "1s",
				},
				hover = {
					"Information updates every 1 second.",
					["zh"] = "信息每1秒更新。",
					["br"] = "As informações são atualizadas a cada 1 segundo.",
					["es"] = "La información se actualiza cada 1 segundo.",
				},
			},
			[3] = {
				description = {
					"3s",
					["zh"] = "3秒",
					["br"] = "3s",
					["es"] = "3s",
				},
				hover = {
					"Information updates every 3 seconds.",
					["zh"] = "信息每3秒更新。",
					["br"] = "As informações são atualizadas a cada 3 segundos.",
					["es"] = "La información se actualiza cada 3 segundos.",
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
			["es"] = "Reporte de fallos"
		},
		hover = {
			"**Attempts** to report your crashes (debug, mods, world info) automatically to my server.", 
			["zh"] = "**尝试**自动上报你的崩溃（调试情况，模组，世界信息）至我的服务器。", 
			["br"] = "**Tentativas** de relatar suas falhas (depuração, mods, informações do mundo) automaticamente para meu servidor.", 
			["es"] = "**Intenta** reportar los crasheos (depuración, mods, información del mundo) automáticamente."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"The crash reporter is disabled.",
					["zh"] = "关闭崩溃报告器。",
					["br"] = "O relator de falhas está desabilitado.",
					["es"] = "Reporte de fallos desactivado.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"The crash reporter is enabled.",
					["zh"] = "开启崩溃报告器。",
					["br"] = "O relator de falhas está ativado.",
					["es"] = "Reporte de fallos activado.",
				},
			},
		},
	},
	DEBUG_SHOW_NOTIMPLEMENTED = {
		label = {
			"DEBUG_SHOW_NOTIMPLEMENTED", 
			["zh"] = "执行调试显示信息", 
			["br"] = "DEBUG_SHOW_NOTIMPLEMENTED", 
			["es"] = "DEBUG_SHOW_NOTIMPLEMENTED"
		},
		hover = {
			"Displays a warning if a component is not accounted for, and the origin if it is from a mod.", 
			["zh"] = "如果游戏内元件来源未明，错误自于某个模组时，发出警告并显示其来源。", 
			["br"] = "Exibe um aviso se um componente não for contabilizado, e a origem se for de um mod.", 
			["es"] = "Muestra una advertencia si algún componente no fue registrado, y si el origen es de un mod."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not warn if there are any components not accounted for.",
					["zh"] = "未找出错误原因时，不发出警告。",
					["br"] = "Não avisará se houver algum componente não contabilizado",
					["es"] = "No muestra una advertencia si hay algún componente no registrado.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Will warn you if there are any components not accounted for.",
					["zh"] = "未找出错误原因时，发出警告。",
					["br"] = "Irá avisá-lo se houver algum componente não contabilizado.",
					["es"] = "Muestra una advertencia si hay algún componente no registrado.",
				},
			},
		},
	},
	DEBUG_SHOW_DISABLED = {
		label = {
			"DEBUG_SHOW_DISABLED", 
			["zh"] = "禁用调试显示", 
			["br"] = "DEBUG_SHOW_DISABLED", 
			["es"] = "DEBUG_SHOW_DISABLED"
		},
		hover = {
			"Shows warnings for components I have manually disabled.", 
			["zh"] = "发出警告，显示我手动禁用的组件。", 
			["br"] = "Mostra avisos para componentes que desativei manualmente.", 
			["es"] = "Muestra una advertencia de los componentes que se desactivaron manualmente."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display information for disabled descriptors.",
					["zh"] = "不显示已禁用的描述符的信息。",
					["br"] = "Não exibirá informações para descritores desabilitados.",
					["es"] = "No muestra información de componentes deshabilitados.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Will display information for disabled descriptors.",
					["zh"] = "显示已禁用的描述符的信息。",
					["br"] = "Exibirá informações para descritores desabilitados.",
					["es"] = "Muestra información de componentes deshabilitados.",
				},
			},
		},
	},
	DEBUG_SHOW_PREFAB = {
		label = {
			"DEBUG_SHOW_PREFAB", 
			["zh"] = "预设调试显示", 
			["br"] = "DEBUG_SHOW_PREFAB", 
			["es"] = "DEBUG_SHOW_PREFAB"
		},
		hover = {
			"Displays prefab name on entities.", 
			["zh"] = "在物品上显示实体的预设名称。", 
			["br"] = "Exibe o nome do prefab nas entidades.", 
			["es"] = "Muestra el nombre de prefab en las entidades."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Will not display prefabs on entity.",
					["zh"] = "不显示物品的预设名称。",
					["br"] = "Não exibirá prefabs nas entidades.",
					["es"] = "No muestra el prefab (código) en la entidad.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "否",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Will display prefabs on entity.",
					["zh"] = "显示物品的预设名称。",
					["br"] = "Mostrará prefabs nas entidades.",
					["es"] = "Muestra el prefab (código) en la entidad.",
				},
			},
		},
	},
	DEBUG_ENABLED = {
		label = {
			"DEBUG_ENABLED", 
			["zh"] = "开启调试功能", 
			["br"] = "DEBUG_ENABLED", 
			["es"] = "DEBUG_ENABLED"
		},
		hover = {
			"Puts you in Insight's Debug Mode.", 
			["zh"] = "打开你的 Insight 调试功能。", 
			["br"] = "Coloca você no modo de depuração do Insight.", 
			["es"] = "Configura el modo de depuración de Insight."
		},
		options = {
			[false] = {
				description = {
					"No",
					["zh"] = "否",
					["br"] = "Não",
					["es"] = "Desactivado",
				},
				hover = {
					"Insight will not show debugging information.",
					["zh"] = "不显示调试信息",
					["br"] = "O Insight não mostrará informações de depuração.",
					["es"] = "Insight no muestra información de depuración.",
				},
			},
			[true] = {
				description = {
					"Yes",
					["zh"] = "是",
					["br"] = "Sim",
					["es"] = "Activado",
				},
				hover = {
					"Insight will show debugging information.",
					["zh"] = "显示调试信息",
					["br"] = "O Insight mostrará informações de depuração.",
					["es"] = "Insight muestra información de depuración.",
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
		name = "display_fishing_information",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
		tags = {"undefined"},
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
			{data = 0},
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
		name = "display_weighable",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
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
	{
		name = "unique_info",
		options = {
			{data = 0},
			{data = 1},
		}, 
		default = 1,
		tags = {"undefined"},
	},
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
		tags = {},
	},
	{
		name = "DEBUG_SHOW_DISABLED",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "DEBUG_SHOW_PREFAB",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "DEBUG_ENABLED",
		options = {
			{data = false},
			{data = true},
		},
		default = false,
		tags = {},
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
		
		local default = GetDefaultSetting(entry)

		--[[
		if HasTag(entry, "client_only") then
			entry.label = entry.label .. " (Client)" -- Only client can choose
		end
		--]]

		if HasTag(entry, "undefined") then -- Server doesn't have to specify
			entry.original_default = entry.default
			entry.default = "undefined"
			entry.options[#entry.options+1] = { description = T(STRINGS["undefined"]), data = "undefined", hover = T(STRINGS["undefined_description"]) .. default.description}
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
