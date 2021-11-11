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
version = "2.10.5" -- dst is 3.2.2, ds is 2.10.5
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

--[[
	removing label from options
	[\n\t]*label = [T]*"[\w\s]+",

	removing hover from options
	[\n\t]*hover = .+",

	removing description from options
	\{description = "[^"]+",\s+

	removing hover from options
	, \s*hover\s*=\s*"[^"]+"\},

	for i,data in pairs(configuration_options) do
		print(string.format("%s = \"%s\",", data.name, data.label))
		local  "\\\"")
		print(string.format("%s_ data.name, hover))
	end

]]


local translations = {}
local english = {

	-- description
	ds_not_enabled = "Mod must be enabled for functioning modinfo",
	update_info = "Wanda support. Check changelog for more details.",
	update_info_ds = "performance increase, bug fixes",
	crashreporter_info = "**Crash reporter added**, you should enable it in the client & server config",

	mod_explanation = "Basically Show Me but with more features.",
	config_paths = "Server Configuration: Main Menu -> Host Game -> Mods -> Server Mods -> Insight -> Configure Mod\n-------------------------\nClient Configuration: Main Menu -> Mods -> Server Mods -> Insight -> Configure Mod",

	config_disclaimer = "Make sure to check out the configuration options.",
	version = "Version",
	latest_update = "Latest update",

	-- section titles
	sectiontitle_formatting = "Formatting",
	sectiontitle_indicators = "Indicators",
	sectiontitle_foodrelated = "Food Related",
	sectiontitle_informationcontrol = "Information Control",
	sectiontitle_miscellaneous = "Miscellaneous",
	sectiontitle_debugging = "Debugging",

	-- etc
	undefined = "Undefined",
	undefined_description = "Defaults to: ",

	-- Formatting
	language = {
		--------------------------------------------------------------------------
		--[[ Formatting ]]
		--------------------------------------------------------------------------
		LABEL = "Language",
		HOVER = "The language you want information to display in.",
		OPTIONS = {
			["automatic"] = {
				DESCRIPTION = "Automatic",
				HOVER = "Uses your current language settings."
			},
			["en"] = {
				DESCRIPTION = "English",
				HOVER = "English"
			},
			["zh"] = {
				DESCRIPTION = "Chinese",
				HOVER = "Chinese"
			},
			--[[
			["ru"] = {
				DESCRIPTION = "Russian"
				HOVER = "Russian"
			},
			]]
		},
	},
	info_style = {
		LABEL = "Display style",
		HOVER = "Whether you want to use icons or text.",
		OPTIONS = {
			["text"] = {
				DESCRIPTION = "Text",
				HOVER = "Text will be used"
			},
			["icon"] = {
				DESCRIPTION = "Icon",
				HOVER = "Icons will be used over text where possible."
			},
		},
	},
	text_coloring = {
		LABEL = "Text Coloring",
		HOVER = "Whether text coloring is enabled.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Text coloring will not be used. :("
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Text coloring will be used."
			},
		},
	},
	alt_only_information = {
		LABEL = "Inspect Only",
		HOVER = "Whether Insight will only show information when you hold Left Alt.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Information is displayed normally."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Information only displays on inspection."
			},
		},
	},
	--[[
	alt_only_is_verbose = {
		LABEL = "Inspect Only Verbosity",
		HOVER = "*ONLY MATTERS WHEN \"Inspect Only\" IS ENABLED.*\nWhether holding alt shows the standard or extended information.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Standard",
				HOVER = "Standard information is shown."
			},
			["true"] = {
				DESCRIPTION = "Extended",
				HOVER = "Extended information is shown."
			},
		},
	},
	--]]
	itemtile_display = {
		LABEL = "Inv Slot Info",
		HOVER = "What kind of information shows instead of percentages on item slots.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "None",
				HOVER = "Will not provide ANY information on item slots."
			},
			["1"] = {
				DESCRIPTION = "Numbers",
				HOVER = "Will provide durability numbers on item slots."
			},
			["2"] = {
				DESCRIPTION = "Percentages",
				HOVER = "Will provide use default percentages on item slots."
			},
		},
	},
	time_style = {
		LABEL = "Time style",
		HOVER = "How to display time information.",
		OPTIONS = {
			["gametime"] = {
				DESCRIPTION = "Game time",
				HOVER = "Displays time information based on game time: days, segments."
			},
			["realtime"] = {
				DESCRIPTION = "Real time",
				HOVER = "Displays time information based on real time: hours, minutes, seconds."
			},
			["both"] = {
				DESCRIPTION = "Both",
				HOVER = "Use both time styles: days, segments (hours, minutes, seconds)"
			},
			["gametime_short"] = {
				DESCRIPTION = "Game time (Short)",
				HOVER = "Displays shortened time information based on game time."
			},
			["realtime_short"] = {
				DESCRIPTION = "Real time (Short)",
				HOVER = "Displays shortened time information based on real time: hours:minutes:seconds."
			},
			["both_short"] = {
				DESCRIPTION = "Both (Short)",
				HOVER = "Use both time styles and shorten: x.y days (hours:minutes:seconds)."
			},
		},
	},
	highlighting = {
		LABEL = "Highlighting",
		HOVER = "Whether item highlighting is enabled. (\"Finder\")",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "No chest/item highlighting."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Chests/items will be highlighted."
			},
		},
	},
	highlighting_color = {
		LABEL = "Highlighting Color",
		HOVER = "The color to use for highlighting.",
		OPTIONS = {
			["RED"] = {
				DESCRIPTION = "Red",
				HOVER = "Red",
			},
			["GREEN"] = {
				DESCRIPTION = "Green",
				HOVER = "Green",
			},
			["BLUE"] = {
				DESCRIPTION = "Blue",
				HOVER = "Blue",
			},
			["LIGHT_BLUE"] = {
				DESCRIPTION = "Light Blue",
				HOVER = "Light Blue",
			},
			["PURPLE"] = {
				DESCRIPTION = "Purple",
				HOVER = "Purple",
			},
			["YELLOW"] = {
				DESCRIPTION = "Yellow",
				HOVER = "Yellow",
			},
			["WHITE"] = {
				DESCRIPTION = "White",
				HOVER = "White",
			},
			["ORANGE"] = {
				DESCRIPTION = "Orange",
				HOVER = "Orange",
			},
			["PINK"] = {
				DESCRIPTION = "Pink",
				HOVER = "Pink",
			},
		},
	},
	fuel_highlighting = {
		LABEL = "Fuel Highlighting",
		HOVER = "Whether fuel highlighting is enabled.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Fuel entities will not be highlighted."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Fuel entities will be highlighted."
			},
		},
	},
	fuel_highlighting_color = {
		LABEL = "Fuel Highlighting Color",
		HOVER = "The color to use for fuel highlighting.",
		OPTIONS = {
			["RED"] = {
				DESCRIPTION = "Red",
				HOVER = "Red",
			},
			["GREEN"] = {
				DESCRIPTION = "Green",
				HOVER = "Green",
			},
			["BLUE"] = {
				DESCRIPTION = "Blue",
				HOVER = "Blue",
			},
			["LIGHT_BLUE"] = {
				DESCRIPTION = "Light Blue",
				HOVER = "Light Blue",
			},
			["PURPLE"] = {
				DESCRIPTION = "Purple",
				HOVER = "Purple",
			},
			["YELLOW"] = {
				DESCRIPTION = "Yellow",
				HOVER = "Yellow",
			},
			["WHITE"] = {
				DESCRIPTION = "White",
				HOVER = "White",
			},
			["ORANGE"] = {
				DESCRIPTION = "Orange",
				HOVER = "Orange",
			},
			["PINK"] = {
				DESCRIPTION = "Pink",
				HOVER = "Pink",
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Indicators ]]
	--------------------------------------------------------------------------
	display_attack_range = {
		LABEL = "Attack Ranges",
		HOVER = "Whether attack ranges are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Attack ranges are not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Attack ranges are shown."
			},
		},
	},
	attack_range_type = {
		LABEL = "Attack Range Type",
		HOVER = "Type of attack range to be displayed.",
		OPTIONS = {
			["hit"] = {
				DESCRIPTION = "Hit",
				HOVER = "Hit range is shown."
			},
			["attack"] = {
				DESCRIPTION = "Attack",
				HOVER = "Attack range is shown."
			},
			["both"] = {
				DESCRIPTION = "Both",
				HOVER = "Both hit and attack range are shown."
			},
		},
	},
	hover_range_indicator = {
		LABEL = "Item Range Hover",
		HOVER = "Whether an item's range is shown upon hovering.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Range is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Range is shown."
			},
		},
	},
	boss_indicator = {
		LABEL = "Boss Indicator",
		HOVER = "Whether boss indicators are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Boss indicators not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Boss indicators are shown."
			},
		},
	},
	notable_indicator = {
		LABEL = "Notable Indicator",
		HOVER = "Whether the notable (chester, hutch, etc) indicators are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Notable indicators not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Notable indicators are shown."
			},
		},
	},
	pipspook_indicator = {
		LABEL = "Pipspook toy indicators",
		HOVER = "Whether pipspook toy indicators are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Pipspook toy indicators not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Pipspook toy indicators are shown."
			},
		},
	},
	bottle_indicator = {
		LABEL = "Bottle Indicator",
		HOVER = "Whether message bottle indicators are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Message indicators not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Message indicators are shown."
			},
		},
	},
	hunt_indicator = {
		LABEL = "Hunt Indicator",
		HOVER = "Whether hunt indicators are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Hunt indicators not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Hunt indicators are shown."
			},
		},
	},
	orchestrina_indicator = {
		LABEL = "Archive Puzzle Helper",
		HOVER = "Whether the solution to the puzzle is displayed or not.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The solution is not displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The solution is displayed."
			}
		}
	},
	lightningrod_range = {
		LABEL = "Lightningrod range",
		HOVER = "How lightningrod range is displayed.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "Off",
				HOVER = "Do not show lightning rod range."
			},
			["1"] = {
				DESCRIPTION = "Strategic",
				HOVER = "Only show during placements / pitchforking (just like a flingo)."
			},
			["2"] = {
				DESCRIPTION = "Always",
				HOVER = "Always show lightning rod range."
			},
		},
	},
	blink_range = {
		LABEL = "Blink range",
		HOVER = "Whether you can see your blink range.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Blink range not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Blink range shown."
			},
		},
	},
	wortox_soul_range = {
		LABEL = "Wortox Soul range",
		HOVER = "Whether you can see the pickup range Wortox has for his souls.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Soul pickup ranges not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Soul pickup ranges shown."
			},
		},
	},
	battlesong_range = {
		LABEL = "Battle song range",
		HOVER = "How battle song ranges are displayed.",
		OPTIONS = {
			["none"] = {
				DESCRIPTION = "None",
				HOVER = "Do not show battle song ranges."
			},
			["detach"] = {
				DESCRIPTION = "Detach",
				HOVER = "Song detachment range shown."
			},
			["attach"] = {
				DESCRIPTION = "Attach",
				HOVER = "Song attachment range shown."
			},
			["both"] = {
				DESCRIPTION = "Both",
				HOVER = "Both ranges are shown."
			},
		},
	},
	klaus_sack_markers = {
		LABEL = "Loot Stash Markers",
		HOVER = "Whether Loot Stash spawning locations are marked.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Loot Stash markers are shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Loot Stash markers are not shown."
			},
		},
	},
	sinkhole_marks = {
		LABEL = "Sinkhole Marks",
		HOVER = "How sinkhole marking is applied.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "None",
				HOVER = "Do not do any sinkhole coloring."
			},
			["1"] = {
				DESCRIPTION = "Map Only",
				HOVER = "Only apply to map icons."
			},
			["2"] = {
				DESCRIPTION = "Sinkholes & Map",
				HOVER = "Apply to both map icons & sinkholes."
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Food Related ]]
	--------------------------------------------------------------------------
	display_food = {
		LABEL = "Food Information",
		HOVER = "Whether food information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Food information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Food information is shown."
			},
		},
	},
	food_style = {
		LABEL = "Food style",
		HOVER = "How food information is displayed.",
		OPTIONS = {
			["short"] = {
				DESCRIPTION = "Short",
				HOVER = "+X / -X / +X"
			},
			["long"] = {
				DESCRIPTION = "Long",
				HOVER = "Hunger: +X / Sanity: -X / Health: +X"
			},
		},
	},
	food_order = {
		LABEL = "Food order",
		HOVER = "What order food stats are displayed in (if you choose Wiki you're dead to me)",
		OPTIONS = {
			["interface"] = {
				DESCRIPTION = "Interface",
				HOVER = "Hunger / Sanity / Health"
			},
			["wiki"] = {
				DESCRIPTION = "Wiki",
				HOVER = "Health / Hunger / Sanity"
			},
		},
	},
	food_units = {
		LABEL = "Display food units",
		HOVER = "Whether food units are displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Food units will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Food units WILL be displayed."
			},
		},
	},
	food_effects = {
		LABEL = "Food Effects",
		HOVER = "Whether special food effects show or not.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Special food effects will not show."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Special food effects will show."
			},
		},
	},
	stewer_chef = {
		LABEL = "Chef Identifiers",
		HOVER = "Whether the chef of a recipe is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The chef will not be shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The chef will be shown."
			},
		},
	},
	food_memory = {
		LABEL = "Food Memory",
		HOVER = "Whether your food memory is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Your food memory will not be shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Your food memory will be shown."
			},
		},
	},
	display_perishable = {
		LABEL = "Perishing",
		HOVER = "Whether perishable information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Perishable information is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Perishable information is shown."
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Information Control ]]
	--------------------------------------------------------------------------
	display_cawnival = {
		LABEL = "Cawnival Information",
		HOVER = "Whether Midsummer Cawnvival information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Cawnival information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Cawnival information is shown.",
			},
		},
	},
	display_yotb_winners = {
		LABEL = "Pageant Winners [YOTB]",
		HOVER = "Whether Pageant winners are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The pageant winners are not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The pageant winners are shown."
			},
		},
	},
	display_yotb_appraisal = {
		LABEL = "Appraisal Values [YOTB]",
		HOVER = "Whether appraisal values are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The appraisal values are not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The appraisal values are shown."
			},
		},
	},
	display_shared_stats = {
		LABEL = "Playerlist Stats",
		HOVER = "Whether the stats of other players in the server are shown in the playerlist.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The stats are not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The stats are shown."
			},
		},
	},
	display_worldmigrator = {
		LABEL = "Portal information",
		HOVER = "Whether portal (sinkhole) information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Portal information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Portal information is shown."
			},
		},
	},
	display_unwrappable = {
		LABEL = "Bundle information",
		HOVER = "Whether bundle information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Bundle information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Bundle information is shown."
			},
		},
	},
	display_fishing_information = {
		LABEL = "Fishing information",
		HOVER = "Whether fishing information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Fishing information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Fishing information is shown."
			},
		},
	},
	display_spawner_information = {
		LABEL = "Spawner information",
		HOVER = "Whether creature spawners have information shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The spawner information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The spawner information is shown."
			},
		},
	},
	weapon_damage = {
		LABEL = "Weapon Damage",
		HOVER = "Whether weapon damage is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Weapon damage is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Weapon damage is shown."
			},
		},
	},
	repair_values = {
		LABEL = "Repair Values",
		HOVER = "Whether repair information is displayed (on inspection).",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Repair information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Repair information is shown.",
			},
		}
	},
	soil_moisture = {
		LABEL = "Soil Moisture",
		HOVER = "How soil/plant moisture is displayed.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "Off",
				HOVER = "Soil moisture is not shown.",
			},
			["1"] = {
				DESCRIPTION = "Soil",
				HOVER = "Only soil moisture is shown.",
			},
			["2"] = {
				DESCRIPTION = "Soil / Plant",
				HOVER = "Soil moisture and the plant consumption rate is shown.",
			},
			["3"] = {
				DESCRIPTION = "Soil, Plant, Tile",
				HOVER = "Soil moisture, plant consumption, and the tile moisture rate is shown.",
			},
			["4"] = {
				DESCRIPTION = "All",
				HOVER = "Soil moisture, plant consumption, and the **NET** tile moisture rate is shown.",
			}
		}
	},
	soil_nutrients = {
		LABEL = "Soil Nutrients",
		HOVER = "How soil/plant nutrients are displayed.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "Off",
				HOVER = "Soil nutrients are not shown.",
			},
			["1"] = {
				DESCRIPTION = "Soil",
				HOVER = "Only soil nutrients are shown.",
			},
			["2"] = {
				DESCRIPTION = "Soil / Plant",
				HOVER = "Soil nutrients and the plant consumption rate are shown.",
			},
			["3"] = {
				DESCRIPTION = "Soil, Plant, Tile",
				HOVER = "Soil nutrients, plant consumption, and the tile nutrients rate are all shown.",
			},
			--[[
			["4"] = {
				DESCRIPTION = "All",
				HOVER = "Soil nutrients, plant consumption, and the **NET** tile nutrients rate is shown.",
			}
			--]]
		}
	},
	display_plant_stressors = {
		LABEL = "Plant stress",
		HOVER = "Determines whether plant stress is shown.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "No",
				HOVER = "Plant stress is not shown.",
			},
			["1"] = {
				DESCRIPTION = "With Hat",
				HOVER = "Plant stress will be shown if you have the Premier Gardeneer Hat.",
			},
			["2"] = {
				DESCRIPTION = "Always",
				HOVER = "Plant stress is always shown."
			}
		}
	},
	display_weighable = {
		LABEL = "Item Weight",
		HOVER = "Determines whether item weight is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Item weight is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Item weight is shown.",
			},
		}
	},
	display_world_events = {
		LABEL = "Show World Data",
		HOVER = "Determines whether world data is shown.\nExamples: Hounds/Worms, Bosses, Earthquakes, etc.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "World data is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "World data is shown."
			},
		},
	},
	display_weather = {
		LABEL = "Show weather information",
		HOVER = "Determines whether weather information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Weather is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Weather is shown."
			},
		},
	},
	nightmareclock_display = {
		LABEL = "Nightmare Phases",
		HOVER = "Controls when users receive information about the Nightmare Phases.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "Off",
				HOVER = "No nightmare phase information is shown."
			},
			["1"] = {
				DESCRIPTION = "Need Medallion",
				HOVER = "Nightmare phase information is shown if a Thulecite Medallion is present."
			},
			["2"] = {
				DESCRIPTION = "On",
				HOVER = "Nightmare phase information is always shown."
			},
		},
	},
	display_health = {
		LABEL = "Health",
		HOVER = "Whether health information should be shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Health information is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Health information is shown."
			},
		},
	},
	display_hunger = {
		LABEL = "Hunger",
		HOVER = "How much hunger detail is shown.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "No",
				HOVER = "Will not display hunger."
			},
			["1"] = {
				DESCRIPTION = "Standard",
				HOVER = "Will display standard hunger information."
			},
			["2"] = {
				DESCRIPTION = "All",
				HOVER = "Will display all hunger information."
			},
		},
	},
	display_sanity = {
		LABEL = "Sanity",
		HOVER = "Whether sanity information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display sanity information."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display sanity information."
			},
		},
	},
	display_sanityaura = {
		LABEL = "Sanity Auras",
		HOVER = "Whether sanity auras are shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display sanity auras."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display sanity auras."
			},
		},
	},
	display_mob_attack_damage = {
		LABEL = "Mob Attack Damage",
		HOVER = "Whether mob attack damage is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Mob attack damage is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Mob attack damage is shown.",
			},
		},
	},
	growth_verbosity = {
		LABEL = "Growth Verbosity",
		HOVER = "How detailed growth information should be.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "None",
				HOVER = "Displays nothing about growable entities."
			},
			["1"] = {
				DESCRIPTION = "Minimal",
				HOVER = "Displays time until next stage."
			},
			["2"] = {
				DESCRIPTION = "All",
				HOVER = "Displays current stage name, number of stages, and time until next stage."
			},
		},
	},
	display_pickable = {
		LABEL = "Pickable Information",
		HOVER = "Whether pickable information should be shown (ex: Berry Bushes)",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Pickable information will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Pickable information will be displayed."
			},
		},
	},
	display_harvestable = {
		LABEL = "Harvestable Information",
		HOVER = "Whether harvestable information should be shown (ex: Bee Boxes)",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Harvestable information will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Harvestable information will be displayed."
			},
		},
	},
	display_finiteuses = {
		LABEL = "Tool Durability",
		HOVER = "Whether tool durability is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Tool durability will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Tool durability will be displayed."
			},
		},
	},
	display_timers = {
		LABEL = "Timers",
		HOVER = "Whether timer information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Timers will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Timers will be displayed."
			},
		},
	},
	display_upgradeable = {
		LABEL = "Upgradeables",
		HOVER = "Whether upgradeable information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Will not display information for upgradeable structures."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Displays information for upgradeable structures, such as spider dens."
			},
		},
	},
	naughtiness_verbosity = {
		LABEL = "Naughtiness verbosity",
		HOVER = "How verbose the naughtiness information should be. Combined Status takes precedence for player naughtiness.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Most naughtiness values will not display."
			},
			["1"] = {
				DESCRIPTION = "Creature",
				HOVER = "Creature naughtiness values will display."
			},
			["2"] = {
				DESCRIPTION = "Plr/Creature",
				HOVER = "Player and creature naughtiness values will display."
			},
		},
	},
	follower_info = {
		LABEL = "Followers",
		HOVER = "Whether follower information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display follower information."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display follower information."
			},
		},
	},
	herd_information = {
		LABEL = "Herds",
		HOVER = "Whether herd information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display herd information."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display herd information."
			},
		},
	},
	domestication_information = {
		LABEL = "Domestication",
		HOVER = "Whether domestication information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display domestication information."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display domestication information."
			},
		},
	},
	display_pollination = {
		LABEL = "Pollination",
		HOVER = "Whether pollination information is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display pollination information."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display pollination information."
			},
		},
	},
	item_worth = {
		LABEL = "Display item worth",
		HOVER = "Whether item worth is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Will not display gold or dubloon value."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Will display gold and dubloon value."
			},
		},
	},
	appeasement_value = {
		LABEL = "Display Appeasement",
		HOVER = "Whether appeasement worth is displayed.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Will not display appeasement value."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Will display appeasement value."
			},
		},
	},
	fuel_verbosity = {
		LABEL = "Fuel Verbosity",
		HOVER = "How verbose fuel information is.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "None",
				HOVER = "No fuel information will show."
			},
			["1"] = {
				DESCRIPTION = "Standard",
				HOVER = "Standard fuel information will show."
			},
			["2"] = {
				DESCRIPTION = "All",
				HOVER = "All fuel information will show."
			},
		},
	},
	display_shelter_info = {
		LABEL = "Shelter Information",
		HOVER = "Whether to display shelter information.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Shelter information is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Shelter information is shown."
			},
		}
	},
	unique_info = {
		LABEL = "Unique Information",
		HOVER = "Whether to display unique information for certain entities.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "No",
				HOVER = "No unique information is shown."
			},
			["1"] = {
				DESCRIPTION = "Yes",
				HOVER = "Unique information is shown."
			},
		}
	},
	--------------------------------------------------------------------------
	--[[ Miscellaneous ]]
	--------------------------------------------------------------------------
	display_crafting_lookup_button = {
		LABEL = "Crafting Lookup Button",
		HOVER = "Whether the crafting lookup button is displayed or not.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The button is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The button is shown."
			},
		},
	},
	display_insight_menu_button = {
		LABEL = "Insight Menu Button",
		HOVER = "Whether the insight menu button is displayed or not.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The button is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The button is shown."
			},
		},
	},
	extended_info_indicator = {
		LABEL = "More Information Hint",
		HOVER = "Whether an asterisk is present for entities with more information.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The indicator is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The indicator is shown."
			},
		},
	},
	unrandomizer = {
		LABEL = "Unrandomizer",
		HOVER = "[Server Only] \"Solves\" the randomness of some situations.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Off"
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "On"
			}
		}
	},
	account_combat_modifiers = {
		LABEL = "Combat Modifiers",
		HOVER = "Whether damage boosts and resistances are considered.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Combat popups (ie damage) will only use original values."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Combat popups (ie damage) will account for any buffs/nerfs your character has."
			},
		},
	},
	info_preload = {
		LABEL = "Information preloading",
		HOVER = "Whether information is preloaded when entities become visible. Trades network usage for faster performance. Recommended to use \"All\".",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "No",
				HOVER = "SEVERE FPS DROP! NOT RECOMMENDED!" -- most severe fps drop
			},
			["1"] = {
				DESCRIPTION = "Containers",
				HOVER = "POSSIBLE FPS DROP. NOT RECOMMENDED. CAN USE FOR SMALL, CLEAN BASES."
			},
			["2"] = {
				DESCRIPTION = "All",
				HOVER = "FASTEST. RECOMMENDED."
			},
		},
	},
	refresh_delay = {
		LABEL = "Refresh delay",
		HOVER = "How often you can re-request information for the same item.",
		OPTIONS = {
			["true"] = {
				DESCRIPTION = "Automatic",
				HOVER = "Dynamicly chosen based on current performance stats."
			},
			["0"] = {
				DESCRIPTION = "None",
				HOVER = "Information is live."
			},
			["0_25"] = {
				DESCRIPTION = "0.25s",
				HOVER = "Information updates every 0.25 seconds."
			},
			["0_5"] = {
				DESCRIPTION = "0.5s",
				HOVER = "Information updates every 0.5 seconds."
			},
			["1"] = {
				DESCRIPTION = "1s",
				HOVER = "Information updates every 1 second."
			},
			["3"] = {
				DESCRIPTION = "3s",
				HOVER = "Information updates every 3 seconds."
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Debugging ]]
	--------------------------------------------------------------------------
	crash_reporter = {
		LABEL = "Crash Reporter",
		HOVER = "**Attempts** to report your crashes (debug, mods, world info) automatically to my server.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The crash reporter is disabled."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The crash reporter is enabled."
			},
		},
	},
	DEBUG_SHOW_NOTIMPLEMENTED = {
		LABEL = "DEBUG_SHOW_NOTIMPLEMENTED",
		HOVER = "Displays a warning if a component is not accounted for, and the origin if it is from a mod.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Will not warn if there are any components not accounted for."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Will warn you if there are any components not accounted for."
			},
		},
	},
	DEBUG_SHOW_DISABLED = {
		LABEL = "DEBUG_SHOW_DISABLED",
		HOVER = "Shows warnings for components I have manually disabled.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Will not display information for disabled descriptors."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Will display information for disabled descriptors."
			},
		},
	},
	DEBUG_SHOW_PREFAB = {
		LABEL = "DEBUG_SHOW_PREFAB",
		HOVER = "Displays prefab name on entities.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Will not display prefabs on entity."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Will display prefabs on entity."
			},
		},
	},
	DEBUG_ENABLED = {
		LABEL = "DEBUG_ENABLED",
		HOVER = "Puts you in Insight's Debug Mode.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Insight will not show debugging information."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Insight will show debugging information."
			},
		},
	},
}
translations["en"] = english

local chinese = {
	-- description
	update_info = "",
	crashreporter_info = "**添加了崩溃报告器**, 你可以在客户端或服务器设置界面来开启它。",

	mod_explanation = "以 Show Me 为基础，但功能更全面",
	config_paths = "服务器设置方法: 主界面 -> 创建世界-> 模组 -> 服务器模组 -> Insight -> 模组设置\n-------------------------\n客户端设置方法: 主界面 -> 模组 -> 服务器模组 -> Insight -> 模组设置",

	config_disclaimer = "请确认你设置的各个选项, 尤其是设置好显示的和设置不再显示的信息，需要格外注意。",
	version = "版本",
	latest_update = "最新更新",

	-- section titles
	sectiontitle_formatting = "格式",
	sectiontitle_indicators = "指示器",
	sectiontitle_foodrelated = "食物相关",
	sectiontitle_informationcontrol = "信息控制",
	sectiontitle_miscellaneous = "杂项",
	sectiontitle_debugging = "调试",

	-- etc
	undefined = "默认",
	undefined_description = "默认为：",

	-- Formatting
	language = {
		--------------------------------------------------------------------------
		--[[ Formatting ]]
		--------------------------------------------------------------------------
		LABEL = "图标模式",
		HOVER = "是否显示图标或文字",
		OPTIONS = {
			["automatic"] = {
				DESCRIPTION = "自动",
				HOVER = "使用游戏当前的语言设定"
			},
			["en"] = {
				DESCRIPTION = "英语",
				HOVER = "英语"
			},
			["zh"] = {
				DESCRIPTION = "中文",
				HOVER = "中文"
			},
			--[[
			["ru"] = {
				DESCRIPTION = "Russian"
				HOVER = "Russian"
			},
			]]
		},
	},
	info_style = {
		LABEL = "信息类型",
		HOVER = "选择图标模式还是文字模式。",
		OPTIONS = {
			["text"] = {
				DESCRIPTION = "文字",
				HOVER = "显示纯文字"
			},
			["icon"] = {
				DESCRIPTION = "图标",
				HOVER = "显示图标替代文字"
			},
		},
	},
	text_coloring = {
		LABEL = "文字着色",
		HOVER = "是否启用文字着色。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "禁用文字着色 :("
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "启用文字着色"
			},
		},
	},
	alt_only_information = {
		LABEL = "仅在检查时显示",
		HOVER = "是否仅当按住 Alt 键时显示信息",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "信息正常显示"
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "仅当按住 Alt 键时显示信息"
			}
		}
	},
	itemtile_display = {
		LABEL = "库存物品栏信息",
		HOVER = "物品栏信息显示的类型",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "不显示任何信息",
			},
			["1"] = {
				DESCRIPTION = "数字",
				HOVER = "显示具体次数",
			},
			["2"] = {
				DESCRIPTION = "百分比",
				HOVER = "显示默认百分比",
			},
		},
	},
	time_style = {
		LABEL = "时间样式",
		HOVER = "如何显示时间信息",
		OPTIONS = {
			["gametime"] = {
				DESCRIPTION = "游戏时间",
				HOVER = "以游戏内时间为基础显示时间信息：天数，时间小段"
			},
			["realtime"] = {
				DESCRIPTION = "现实时间",
				HOVER = "以现实时间为基础现实时间信息：时，分，秒"
			},
			["both"] = {
				DESCRIPTION = "兼用两种模式",
				HOVER = "使用两种显示形式：天，时间小段（时，分，秒）"
			},
			["gametime_short"] = {
				DESCRIPTION = "游戏时间（精简）",
				HOVER = "简化版的以游戏内时间为基础显示时间信息"
			},
			["realtime_short"] = {
				DESCRIPTION = "现实时间（精简）",
				HOVER = "简化版的以现实时间为基础显示时间信息"
			},
			["both_short"] = {
				DESCRIPTION = "兼用两种模式（精简）",
				HOVER = "简化版的双模式显示"
			},
		},
	},
	highlighting = {
		LABEL = "高亮显示",
		HOVER = "是否启用箱子/物品的高亮显示 (\"物品查找器\")",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "箱子/物品不会高亮显示",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "箱子/物品会高亮显示",
			},
		},
	},
	highlighting_color = {
		LABEL = "高亮颜色",
		HOVER = "高亮显示时的颜色",
		OPTIONS = {
			["RED"] = {
				DESCRIPTION = "红色",
				HOVER = "红色",
			},
			["GREEN"] = {
				DESCRIPTION = "绿色",
				HOVER = "绿色",
			},
			["BLUE"] = {
				DESCRIPTION = "蓝色",
				HOVER = "蓝色",
			},
			["LIGHT_BLUE"] = {
				DESCRIPTION = "亮蓝色",
				HOVER = "亮蓝色",
			},
			["PURPLE"] = {
				DESCRIPTION = "紫色",
				HOVER = "紫色",
			},
			["YELLOW"] = {
				DESCRIPTION = "黄色",
				HOVER = "黄色",
			},
			["WHITE"] = {
				DESCRIPTION = "白色",
				HOVER = "白色",
			},
			["ORANGE"] = {
				DESCRIPTION = "橙色",
				HOVER = "橙色",
			},
			["PINK"] = {
				DESCRIPTION = "粉色",
				HOVER = "粉色",
			},
		},
	},
	fuel_highlighting = {
		LABEL = "燃料高亮显示",
		HOVER = "是否开启燃料高亮显示",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "禁用燃料高亮显示"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "启用燃料高亮显示"
			},
		},
	},
	fuel_highlighting_color = {
		LABEL = "燃料高亮颜色",
		HOVER = "燃料高亮显示时的颜色",
		OPTIONS = {
			["RED"] = {
				DESCRIPTION = "红色",
				HOVER = "红色",
			},
			["GREEN"] = {
				DESCRIPTION = "绿色",
				HOVER = "绿色",
			},
			["BLUE"] = {
				DESCRIPTION = "蓝色",
				HOVER = "蓝色",
			},
			["LIGHT_BLUE"] = {
				DESCRIPTION = "亮蓝色",
				HOVER = "亮蓝色",
			},
			["PURPLE"] = {
				DESCRIPTION = "紫色",
				HOVER = "紫色",
			},
			["YELLOW"] = {
				DESCRIPTION = "黄色",
				HOVER = "黄色",
			},
			["WHITE"] = {
				DESCRIPTION = "白色",
				HOVER = "白色",
			},
			["ORANGE"] = {
				DESCRIPTION = "橙色",
				HOVER = "橙色",
			},
			["PINK"] = {
				DESCRIPTION = "粉色",
				HOVER = "粉色",
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Indicators ]]
	--------------------------------------------------------------------------
	display_attack_range = {
		LABEL = "攻击范围",
		HOVER = "是否显示攻击范围",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示攻击范围"
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "显示攻击范围"
			},
		},
	},
	attack_range_type = {
		LABEL = "攻击范围类型",
		HOVER = "显示攻击范围的类型",
		OPTIONS = {
			["hit"] = {
				DESCRIPTION = "敲击",
				HOVER = "显示敲击范围"
			},
			["attack"] = {
				DESCRIPTION = "攻击",
				HOVER = "显示攻击范围"
			},
			["both"] = {
				DESCRIPTION = "兼用",
				HOVER = "同时显示敲击和攻击范围"
			},

		},
	},
	hover_range_indicator = {
		LABEL = "物品范围",
		HOVER = "是否显示鼠标悬停物品的生效范围。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示物品范围"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示物品范围。"
			},
		},
	},
	boss_indicator = {
		LABEL = "Boss 指示器",
		HOVER = "是否显示 Boss 指示器功能。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示 Boss 指示器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示 Boss 指示器。"
			},
		},
	},
	notable_indicator = {
		LABEL = "其他物品的指示器",
		HOVER = "是否显示其他物品（切斯特，哈奇等等）的指示器",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示指示器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示指示器。"
			},
		},
	},
	pipspook_indicator = {
		LABEL = "小惊吓玩具指示器",
		HOVER = "是否显示小惊吓玩具的指示器。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示小惊吓玩具指示器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示小惊吓玩具指示器。"
			},
		},
	},
	bottle_indicator = {
		LABEL = "漂流瓶指示器",
		HOVER = "是否显示漂流瓶指示器。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示漂流瓶指示器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示漂流瓶指示器。"
			},
		},
	},
	hunt_indicator = {
		LABEL = "动物脚印指示器",
		HOVER = "是否显示脚印指示器。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示脚印指示器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示脚印指示器。"
			},
		},
	},
	orchestrina_indicator = {
		LABEL = "远古迷宫",
		HOVER = "是否显示远古迷宫的答案。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示答案。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示答案。"
			}
		}
	},
	lightningrod_range = {
		LABEL = "避雷针范围",
		HOVER = "避雷针生效范围的显示方式。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示避雷针的生效范围。"
			},
			["1"] = {
				DESCRIPTION = "策略性地显示",
				HOVER = "只在放置避雷针时、使用草叉时、种植时显示生效范围。"
			},
			["2"] = {
				DESCRIPTION = "总是",
				HOVER = "总是显示避雷针的生效范围。"
			},
		},
	},
	blink_range = {
		LABEL = "瞬移范围",
		HOVER = "是否显示你的瞬移的范围，如灵魂跳跃，橙色法杖等。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示瞬移范围。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示瞬移范围。"
			},
		},
	},
	wortox_soul_range = {
		LABEL = "沃拓克斯灵魂范围",
		HOVER = "是否显示沃拓克斯拾取灵魂的范围和灵魂治疗范围。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示灵魂范围功能。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示灵魂范围功能。"
			},
		},
	},
	battlesong_range = {
		LABEL = "战歌生效范围",
		HOVER = "如何显示战歌的生效范围。",
		OPTIONS = {
			["none"] = {
				DESCRIPTION = "无",
				HOVER = "不显示战歌生效范围。"
			},
			["detach"] = {
				DESCRIPTION = "脱离",
				HOVER = "显示你脱离战歌生效的范围。"
			},
			["attach"] = {
				DESCRIPTION = "生效",
				HOVER = "显示你被战歌鼓舞的生效范围。"
			},
			["both"] = {
				DESCRIPTION = "兼用",
				HOVER = "同时显示脱离战歌和被战歌鼓舞的生效范围"
			},
		},
	},
	klaus_sack_markers = {
		LABEL = "克劳斯袋子标记 (服务器选项)",
		HOVER = "是否标记克劳斯袋子的位置 *该选项仅服务器有效*",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示标记"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示标记"
			},
		},
	},
	sinkhole_marks = {
		LABEL = "落水洞标记",
		HOVER = "如何显示落水洞的着色标记。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "不着色标记任何落水洞洞口。"
			},
			["1"] = {
				DESCRIPTION = "仅地图模式",
				HOVER = "仅着色标记地图图标。"
			},
			["2"] = {
				DESCRIPTION = "兼用",
				HOVER = "同时着色标记地图图标和落水洞洞口。",
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Food Related ]]
	--------------------------------------------------------------------------
	display_food = {
		LABEL = "食物信息",
		HOVER = "是否显示食物信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示食物信息。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示食物信息。"
			},
		},
	},
	food_style = {
		LABEL = "食物属性格式",
		HOVER = "如何显示食物属性信息。",
		OPTIONS = {
			["short"] = {
				DESCRIPTION = "精简",
				HOVER = "+X / -X / +X"
			},
			["long"] = {
				DESCRIPTION = "详细",
				HOVER = "饥饿：+X / 理智：-X / 生命：+X"
			},
		},
	},
	food_order = {
		LABEL = "食物属性显示顺序",
		HOVER = "食物属性以何种顺序显示。",
		OPTIONS = {
			["interface"] = {
				DESCRIPTION = "界面",
				HOVER = "饥饿 / 理智 / 生命"
			},
			["wiki"] = {
				DESCRIPTION = "维基",
				HOVER = "生命 / 饥饿 / 理智"
			},
		},
	},
	food_units = {
		LABEL = "食物系数",
		HOVER = "是否显示食物的系数（果、菜、蛋度等等）。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示食物度。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示食物度。"
			},
		},
	},
	food_effects = {
		LABEL = "食物加成属性",
		HOVER = "是否显示食物的特殊加成属性。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示特殊的食物属性。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示特殊的食物属性。"
			},
		},
	},
	stewer_chef = {
		LABEL = "烹饪厨师显示",
		HOVER = "是否显示料理的制作人。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示料理的制作人。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示料理的制作人。"
			},
		},
	},
	food_memory = {
		LABEL = "瓦力大厨的食物计时",
		HOVER = "是否显示瓦力大厨的食物计时。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示食物计时。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示食物计时。"
			},
		},
	},
	display_perishable = {
		LABEL = "腐烂信息",
		HOVER = "是否显示腐烂信息",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示腐烂信息"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示腐烂信息"
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Information Control ]]
	--------------------------------------------------------------------------
	display_cawnival = {
		LABEL = "Cawnival Information",
		HOVER = "Whether Midsummer Cawnvival information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Cawnival information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Cawnival information is shown.",
			},
		},
	},
	display_yotb_winners = {
		LABEL = "选美大赛冠军 [\"皮弗娄牛之年\" 更新]",
		HOVER = "是否显示选美大赛冠军",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示选美大赛冠军"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示选美大赛冠军"
			},
		},
	},
	display_yotb_appraisal = {
		LABEL = "评价值 [\"皮弗娄牛之年\" 更新]",
		HOVER = "是否显示评价值",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示评价值"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示评价值"
			},
		},
	},
	display_shared_stats = {
		LABEL = "玩家列表中的数据",
		HOVER = "是否在玩家列表中显示服务器中其他玩家的数据",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示数据"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示数据"
			},
		},
	},
	display_worldmigrator = {
		LABEL = "Portal information",
		HOVER = "Whether portal (sinkhole) information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Portal information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Portal information is shown."
			},
		},
	},
	display_unwrappable = {
		LABEL = "Bundle information",
		HOVER = "Whether bundle information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Bundle information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Bundle information is shown."
			},
		},
	},
	display_fishing_information = {
		LABEL = "垂钓信息",
		HOVER = "是否显示垂钓信息",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Fishing information is not shown.",
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Fishing information is shown."
			},
		},
	},
	display_spawner_information = {
		LABEL = "生物生成计时器",
		HOVER = "是否显示生物生成计时信息（猪人、兔人等）。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示生物生成计时信息。"
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "显示生物生成计时信息。"
			},
		},
	},
	weapon_damage = {
		LABEL = "武器伤害值",
		HOVER = "是否显示武器的伤害值。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示武器的伤害值。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示武器的伤害值。"
			},
		},
	},
	repair_values = {
		LABEL = "修补数值",
		HOVER = "是否显示物品的修复信息（需要检查）。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示物品的修复信息",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示物品的修复信息。",
			},
		}
	},
	soil_moisture = {
		LABEL = "土壤潮湿度",
		HOVER = "如何显示土壤/植物的潮湿度。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示土壤潮湿度。"
			},
			["1"] = {
				DESCRIPTION = "仅土壤",
				HOVER = "仅显示土壤的潮湿度。"
			},
			["2"] = {
				DESCRIPTION = "土壤/植株",
				HOVER = "显示土壤潮湿度和植株耗水率。"
			},
			["3"] = {
				DESCRIPTION = "土壤，植株，耕地",
				HOVER = "显示土壤潮湿度，植株耗水率，耕地潮湿度。"
			},
			["4"] = {
				DESCRIPTION = "全部",
				HOVER = "显示土壤潮湿度，植株耗水率，总耕地潮湿度。"
			}
		}
	},
	soil_nutrients = {
		LABEL = "土壤养分值",
		HOVER = "如何显示土壤/植株的养分值。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示土壤养分值。",
			},
			["1"] = {
				DESCRIPTION = "仅土壤",
				HOVER = "仅显示土壤养分值。",
			},
			["2"] = {
				DESCRIPTION = "土壤/植株",
				HOVER = "显示土壤养分值和植株耗肥率。",
			},
			["3"] = {
				DESCRIPTION = "土壤，植株，耕地",
				HOVER = "显示土壤养分值，植株耗肥率，耕地养分值。",
			},
			--[[
			["4"] = {
				DESCRIPTION = "全部",
				HOVER = "显示土壤养分值，植株耗肥率，总耕地养分值。",
			}
			--]]
		}
	},
	display_plant_stressors = {
		LABEL = "植物压力",
		HOVER = "决定是否显示植物的压力",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "否",
				HOVER = "植物的压力将不会显示",
			},
			["1"] = {
				DESCRIPTION = "佩戴园艺帽时",
				HOVER = "如果你身上有，或戴上远古园艺帽时，显示植物的压力",
			},
			["2"] = {
				DESCRIPTION = "总是",
				HOVER = "总是显示植物的压力",
			}
		}
	},
	display_weighable = {
		LABEL = "物品重量",
		HOVER = "是否显示物品的重量",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示物品的重量值",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示物品的重量值",
			},
		}
	},
	display_world_events = {
		LABEL = "世界事件",
		HOVER = "是否显示世界事件。世界事件有：猎犬/蠕虫，Boss，地震和其他事件。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不展示世界事件。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示世界事件。"
			},
		},
	},
	display_weather = {
		LABEL = "天气信息",
		HOVER = "是否显示天气信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示天气信息"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示天气信息"
			},
		},
	},
	nightmareclock_display = {
		LABEL = "洞穴暴动阶段",
		HOVER = "是否显示洞穴暴动的具体阶段。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示洞穴暴动的阶段信息。"
			},
			["1"] = {
				DESCRIPTION = "拥有铥矿勋章",
				HOVER = "拥有铥矿勋章时显示。",
			},
			["2"] = {
				DESCRIPTION = "启用",
				HOVER = "总是显示暴动阶段的信息。"
			},
		},
	},
	display_health = {
		LABEL = "生命值",
		HOVER = "是否显示生命值的信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示生命值信息。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示生命值信息。",
			},
		},
	},
	display_hunger = {
		LABEL = "物品饥饿值",
		HOVER = "如何显示物品的饥饿值。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "否",
				HOVER = "不显示饥饿值。",
			},
			["1"] = {
				DESCRIPTION = "标准",
				HOVER = "显示标准的饥饿值。",
			},
			["2"] = {
				DESCRIPTION = "完整",
				HOVER = "显示完整物品的饥饿值。",
			},
		},
	},
	display_sanity = {
		LABEL = "Sanity",
		HOVER = "Whether sanity information is shown.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "Disabled",
				HOVER = "Will not display sanity information."
			},
			["true"] = {
				DESCRIPTION = "Enabled",
				HOVER = "Will display sanity information."
			},
		},
	},
	display_sanityaura = {
		LABEL = "理智光环",
		HOVER = "是否显示理智光环。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示理智光环。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示理智光环。",
			},
		},
	},
	display_mob_attack_damage = {
		LABEL = "怪物攻击范围",
		HOVER = "是否显示怪物的攻击范围",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示怪物的攻击范围",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示怪物的攻击范围",
			},
		},
	},
	growth_verbosity = {
		LABEL = "植物生长阶段",
		HOVER = "显示植物生长的具体信息。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "不显示会生长的物品的信息。"
			},
			["1"] = {
				DESCRIPTION = "简短",
				HOVER = "仅显示生长到下一阶段所需的时间。"
			},
			["2"] = {
				DESCRIPTION = "详细",
				HOVER = "显示当前阶段名称，阶段的数字，长到下一阶段所需的时间。"
			},
		},
	},
	display_pickable = {
		LABEL = "Pickable Information",
		HOVER = "Whether pickable information should be shown (ex: Berry Bushes)",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Pickable information will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Pickable information will be displayed."
			},
		},
	},
	display_harvestable = {
		LABEL = "Harvestable Information",
		HOVER = "Whether harvestable information should be shown (ex: Bee Boxes)",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Harvestable information will not be displayed."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Harvestable information will be displayed."
			},
		},
	},
	display_finiteuses = {
		LABEL = "工具耐久度",
		HOVER = "是否显示工具的耐久度",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示跟随者的信息"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示跟随者的信息"
			},
		},
	},
	display_timers = {
		LABEL = "计时器",
		HOVER = "是否开启计时器。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "关闭计时器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "开启计时器。"
			},
		},
	},
	display_upgradeable = {
		LABEL = "可升级物品显示",
		HOVER = "可升级物品",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示可升级的建筑等物品的信息。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示可升级的物品的信息，如蜘蛛巢等。"
			},
		},
	},
	naughtiness_verbosity = {
		LABEL = "淘气值",
		HOVER = "如何显示淘气值。Combined Status 模组的淘气值显示优先于本模组。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示淘气值。",
			},
			["1"] = {
				DESCRIPTION = "生物的淘气值",
				HOVER = "显示击杀生物的淘气值。",
			},
			["2"] = {
				DESCRIPTION = "玩家/生物的淘气值",
				HOVER = "同时显示玩家已有的淘气值和击杀生物的淘气值。",
			},
		},
	},
	follower_info = {
		LABEL = "随从信息",
		HOVER = "是否显示你的跟随者的信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示跟随者的信息。",
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "显示跟随者的信息。",
			},
		},
	},
	herd_information = {
		LABEL = "兽群信息",
		HOVER = "兽群的信息是否会显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示兽群的信息。"
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "显示兽群的信息。"
			},
		},
	},
	domestication_information = {
		LABEL = "牛驯服度",
		HOVER = "是否显示牛的驯服度。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示牛的驯服度信息。",
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "显示牛的驯服度信息。",
			},
		},
	},
	display_pollination = {
		LABEL = "授粉信息",
		HOVER = "是否显示蜜蜂、蝴蝶的授粉信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示授粉信息。"
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "显示授粉信息。",
			},
		},
	},
	item_worth = {
		LABEL = "物品价值",
		HOVER = "是否会显示物品的黄金或金币价值。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示物品的价值。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示物品值的价值。",
			},
		},
	},
	appeasement_value = {
		LABEL = "蚁狮",
		HOVER = "是否显示蚁狮献祭时间和作乱的信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示蚁狮的信息。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示蚁狮的信息。",
			},
		},
	},
	fuel_verbosity = {
		LABEL = "燃料",
		HOVER = "如何显示燃料的信息。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "不显示燃料信息"
			},
			["1"] = {
				DESCRIPTION = "标准",
				HOVER = "显示标准的燃料信息"
			},
			["2"] = {
				DESCRIPTION = "全面",
				HOVER = "显示全面的燃料信息"
			},
		},
	},
	display_shelter_info = {
		LABEL = "Shelter Information",
		HOVER = "Whether to display shelter information.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Shelter information is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Shelter information is shown."
			},
		}
	},
	unique_info = {
		LABEL = "Unique Information",
		HOVER = "Whether to display unique information for certain entities.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "No",
				HOVER = "No unique information is shown."
			},
			["1"] = {
				DESCRIPTION = "Yes",
				HOVER = "Unique information is shown."
			},
		}
	},
	--------------------------------------------------------------------------
	--[[ Miscellaneous ]]
	--------------------------------------------------------------------------
	display_crafting_lookup_button = {
		LABEL = "建造查看按钮",
		HOVER = "是否显示建造查看按钮",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示按钮",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示按钮"
			},
		},
	},
	display_insight_menu_button = {
		LABEL = "Insight 目录按钮",
		HOVER = "是否显示 Insight 目录按钮",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示按钮",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示按钮",
			},
		},
	},
	extended_info_indicator = {
		LABEL = "更多信息提示",
		HOVER = "是否在有更多信息的实体上显示星号",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示星号",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示星号",
			},
		},
	},
	unrandomizer = {
		LABEL = "去随机化",
		HOVER = "[服务器] 是否 \"移除\" 某些情况下的随机性.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "禁用",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "启用",
			}
		}
	},
	account_combat_modifiers = {
		LABEL = "战斗信息",
		HOVER = "显示伤害加成和减免信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "显示伤害的原始数据。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示伤害及其加成和削弱状态后的数据。"
			},
		},
	},
	info_preload = {
		LABEL = "信息预载",
		HOVER = "是否预先加载可见范围内所有实体的信息。消耗更多网络以获取更好的表现。推荐使用 \"所有\"。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "否",
				HOVER = "严重帧数降低，不推荐", -- most severe fps drop
			},
			["1"] = {
				DESCRIPTION = "容器",
				HOVER = "小幅帧数降低，不推荐。可用于小型简单的基地。",
			},
			["2"] = {
				DESCRIPTION = "所有",
				HOVER = "最高帧率，推荐。",
			},
		},
	},
	refresh_delay = {
		LABEL = "信息刷新延时",
		HOVER = "多久更新物品的信息。",
		OPTIONS = {
			["true"] = {
				DESCRIPTION = "自动设定",
				HOVER = "基于玩家和游戏性能，动态更新。"
			},
			["0"] = {
				DESCRIPTION = "实时",
				HOVER = "信息实时更新。"
			},
			["0_25"] = {
				DESCRIPTION = "0.25秒",
				HOVER = "信息每0.25秒更新。"
			},
			["0_5"] = {
				DESCRIPTION = "0.5秒",
				HOVER = "信息每0.5秒更新。"
			},
			["1"] = {
				DESCRIPTION = "1秒",
				HOVER = "信息每1秒更新。"
			},
			["3"] = {
				DESCRIPTION = "3秒",
				HOVER = "信息每3秒更新。"
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Debugging ]]
	--------------------------------------------------------------------------
	crash_reporter = {
		LABEL = "崩溃报告器",
		HOVER = "**尝试**自动上报你的崩溃（调试情况，模组，世界信息）至我的服务器。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "关闭崩溃报告器。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "开启崩溃报告器。"
			},
		},
	},
	DEBUG_SHOW_NOTIMPLEMENTED = {
		LABEL = "执行调试显示信息",
		HOVER = "如果游戏内元件来源未明，错误自于某个模组时，发出警告并显示其来源。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "未找出错误原因时，不发出警告。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "未找出错误原因时，发出警告。"
			},
		},
	},
	DEBUG_SHOW_DISABLED = {
		LABEL = "禁用调试显示",
		HOVER = "发出警告，显示我手动禁用的组件。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示已禁用的描述符的信息。",
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示已禁用的描述符的信息。",
			},
		},
	},
	DEBUG_SHOW_PREFAB = {
		LABEL = "预设调试显示",
		HOVER = "在物品上显示实体的预设名称。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示物品的预设名称。",
			},
			["true"] = {
				DESCRIPTION = "否",
				HOVER = "显示物品的预设名称。",
			},
		},
	},
	DEBUG_ENABLED = { -- this will need revision at some point. dunno why i wrote the original like that.
		LABEL = "开启调试功能",
		HOVER = "打开你的 Insight 调试功能。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示调试信息"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示调试信息"
			},
		},
	},
}
translations["zh"] = chinese
translations["ch"] = chinese

--=============================================================================================================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=================================================== DO NOT TRANSLATE PAST THIS LINE =========================================================================================================================================================
--=============================================================================================================================================================================================================================================

local string_format = name.format
local string_match = name.match
local string_gmatch = name.gmatch
local string_sub = name.sub

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

local function T(x) -- Translate
	local current = (locale and translations[locale]) or translations.en
	local backup = translations.en

	for field in string_gmatch(x, "[^%][^.]+") do
		current = current[field]
		backup = backup[field]
	
		if not current then
			current = backup -- this could also be just "break", but that would cause translation to return a table if it was in the middle of a chain. this allows us to resort to the backup and keep going
			if not backup then
				-- NOW we abort
				break
			end
		end
	end

	if not current and not backup then
		-- unable to find ANY translation
		return ("!ERROR[" .. locale .. "] @ " .. x)
	end

	return current or backup
end

description = string_format("[%s] %s\n%s\n%s: %s\n%s: %s\n%s\n%s", 
	--locale or "?", tostring(folder_name), tostring(IsDST),
	locale or T"ds_not_enabled", 
	T"mod_explanation", 
	T"config_disclaimer", 

	T"version", version, 
	T"latest_update", (IsDST and T"update_info" or T"update_info_ds"), 

	T"crashreporter_info",

	(IsDST and T"config_paths" or "")
)

-- Functions
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
		return {tags = {"ignore"}}
	end
end


configuration_options = {
	AddSectionTitle(T"sectiontitle_formatting"),
	{
		name = "language", -- name of option -- header for option in dst
		options = {
			{data = "automatic"},
			{data = "en"},
			{data = "zh"},
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
			{data = 0},
			{data = 1},
			{data = 2},
		}, 
		default = 2,
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
		default = "gametime",
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
	AddSectionTitle(T"sectiontitle_indicators"),
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
		default = true,
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
		default = true,
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
	AddSectionTitle(T"sectiontitle_foodrelated"),
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
	AddSectionTitle(T"sectiontitle_informationcontrol"),
	{
		name = "display_cawnival",
		options = {
			{data = false},
			{data = true},
		},
		default = true,
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
		default = true,
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
			{data = false},
			{data = true},
		}, 
		default = true,
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
	AddSectionTitle(T"sectiontitle_miscellaneous"),
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
			--{data = 0}, -- probably not going to let people use this one
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
			{data = "0_25"},
			{data = "0_5"},
			{data = 1},
			{data = 3},
		},
		default = true,
		tags = {"undefined"},
	},
	AddSectionTitle(T"sectiontitle_debugging"),
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

local function GetOption(name)
	for i = 1, #configuration_options do
		local v = configuration_options[i]
		if v.name == name then
			return v
		end
	end
end

local function HasTag(entry, tag)
	if entry.tags then
		for i = 1, #entry.tags do
			if entry.tags[i] == tag then
				return true
			end
		end
	end
end

local function table_remove(tbl, index) -- it worked first try wow nice job me.
	tbl[index] = nil
	for i = index, #tbl do
		tbl[i] = tbl[i + 1]
	end
end

for i = 1, #configuration_options do
	local entry = configuration_options[i]
	
	if not HasTag(entry, "ignore") then 
		entry.label = T(entry.name .. ".LABEL")
		entry.hover = T(entry.name .. ".HOVER")

		for j = 1, #entry.options do
			local option = entry.options[j]
			option.description = T(string_format("%s.OPTIONS.%s.DESCRIPTION", entry.name, tostring(option.data)))
			option.hover = T(string_format("%s.OPTIONS.%s.HOVER", entry.name, tostring(option.data)))
		end
	end
end


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
			entry.options[#entry.options+1] = { description = T"undefined", data = "undefined", hover = T"undefined_description" .. default.description}
		end

		--v.options[#v.options+1] = { description = "Undefined" , data = "undefined", hover = "Default: " .. default.description }
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