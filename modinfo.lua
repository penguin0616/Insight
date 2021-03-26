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
version = "3.0.8" -- ds is 2.9.7_ds
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
	update_info = "Significant performance increase, Time to king death, Labyrinth Chest Info, Attack Ranges, Child Spawners",
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
		},
	},
	info_style = {
		LABEL = "Icon Mode",
		HOVER = "Whether you want to use icons or text.",
		OPTIONS = {
			["text"] = {
				DESCRIPTION = "No",
				HOVER = "Text will be used"
			},
			["icon"] = {
				DESCRIPTION = "Yes",
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
		LABEL = "Enable Highlighting",
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
	item_range_indicator = {
		LABEL = "Item Range Hover",
		HOVER = "Whether an item's range is shown upon hovering.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Item range is not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Item range is shown."
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
		HOVER = "Whether you can see the ranges wortox has for his souls.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "Soul ranges not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Soul ranges shown."
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
		HOVER = "Food information length.",
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
				HOVER = "Food units will NOT be displayed."
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
				HOVER = "Special food effects will not show."
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
				HOVER = "The pageant winners  are shown."
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
		LABEL = "Follower information",
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
		LABEL = "Herd information",
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
		LABEL = "Domestication info",
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
				DESCRIPTION = "Maximum",
				HOVER = "All fuel information will show."
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Miscellaneous ]]
	--------------------------------------------------------------------------
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
		HOVER = "How often clients can re-request information for the same item.",
		OPTIONS = {
			["true"] = {
				DESCRIPTION = "Automatic",
				HOVER = "Dynamic updates based on players and performance."
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
	log_reporter = {
		LABEL = "Log Reporter",
		HOVER = "Provides button in game for manual logs, attempts to automatically report crashes. Logs have debug, mods, world info.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "The log reporting is disabled."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "The log reporting is enabled."
			},
		},
	},
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
				HOVER = "Will not display information for disabled descriptors."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "Will display information for disabled descriptors."
			},
		},
	},
}
translations["en"] = english

local chinese = {
	-- description
	update_info = "添加了温蒂的小惊吓指示器；修复了高亮模式；提高模组运行性能（举例来说：高亮模式可同时运用于1632个木箱，而对游戏本身冲击非常小）；bug修复；优化沃尔特的弹弓使用；为玩家状态实施网络最优化。",
	crashreporter_info = "**添加了崩溃报告器**, 你可以在客户端或服务器设置界面来开启它。",

	mod_explanation = "以show me为基础，但功能更全面。",
	config_paths = "服务器设置方法: 主界面 -> 创建世界-> 模组 -> 服务器模组 -> Insight -> 模组设置\n-------------------------\n客户端设置方法: 主界面 -> 模组 -> 服务器模组 -> Insight -> 模组设置",

	config_disclaimer = "请确认你设置的各个选项, 尤其是设置好显示的和设置不再显示的信息，需要格外注意。",
	version = "版本",
	latest_update = "最近的更新",

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
		LABEL = "语言",
		HOVER = "也就是你想知道的信息以何种语言来显示。",
		OPTIONS = {
			["automatic"] = {
				DESCRIPTION = "自动",
				HOVER = "使用你当前的语言设定"
			},
			["en"] = {
				DESCRIPTION = "英语",
				HOVER = "英语"
			},
			["zh"] = {
				DESCRIPTION = "中文",
				HOVER = "中文"
			},
		},
	},
	info_style = {
		LABEL = "信息类型",
		HOVER = "选择图标模式还是文字模式。",
		OPTIONS = {
			["text"] = {
				DESCRIPTION = "否",
				HOVER = "文字模式"
			},
			["icon"] = {
				DESCRIPTION = "是",
				HOVER = "图标会替代文字来显示。"
			},
		},
	},
	text_coloring = {
		LABEL = "文字的颜色",
		HOVER = "是否启用文字着色。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "文字着色功能将被禁用。 :("
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "文字着色功能将被启用。"
			},
		},
	},
	alt_only_information = {
		LABEL = "仅检查",
		HOVER = "是否仅当按住Alt键时显示信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "关闭",
				HOVER = "信息将正常显示。"
			},
			["true"] = {
				DESCRIPTION = "开启",
				HOVER = "仅当按住Alt键时显示信息。"
			},
		},
	},
	itemtile_display = {
		LABEL = "物品格子信息",
		HOVER = "也就是显示信息的种类而不是以百分比的形式显示。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "物品将不会显示任何信息。"
			},
			["1"] = {
				DESCRIPTION = "数字型",
				HOVER = "在物品格子里显示数字。"
			},
			["2"] = {
				DESCRIPTION = "百分比型",
				HOVER = "在物品格子里显示百分比。"
			},
		},
	},
	time_style = {
		LABEL = "时间风格",
		HOVER = "如何显示时间信息。",
		OPTIONS = {
			["gametime"] = {
				DESCRIPTION = "游戏时间",
				HOVER = "以游戏内时间为基础显示时间信息：天数，时间小段。"
			},
			["realtime"] = {
				DESCRIPTION = "现实时间",
				HOVER = "以现实时间为基础现实时间信息：时，分，秒。"
			},
			["both"] = {
				DESCRIPTION = "兼用两种模式",
				HOVER = "使用两种显示形式：天，时间小段（时，分，秒）"
			},
			["gametime_short"] = {
				DESCRIPTION = "游戏时间（精简模式）",
				HOVER = "简化版的以游戏内时间为基础显示时间信息。"
			},
			["realtime_short"] = {
				DESCRIPTION = "现实时间（精简模式）",
				HOVER = "简化版的以现实时间为基础显示时间信息。"
			},
			["both_short"] = {
				DESCRIPTION = "兼用两种模式（简化版）",
				HOVER = "简化版的双模式显示。"
			},
		},
	},
	highlighting = {
		LABEL = "启用高亮显示模式",
		HOVER = "物品高亮模式是否开启。 (\"物品查找器\")",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "物品不会触发箱子智能查找，不会高亮显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "智能高亮开启，箱子内有物品会高亮显示。"
			},
		},
	},
	fuel_highlighting = {
		LABEL = "燃料高亮显示",
		HOVER = "是否开启燃料高亮显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "燃料高亮显示模式关闭。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "燃料高亮显示模式开启。"
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
	item_range_indicator = {
		LABEL = "鼠标放置显示物品生效范围",
		HOVER = "将鼠标放置于物品上时该物品的生效范围是否显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "物品范围不显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "物品范围将显示。"
			},
		},
	},
	boss_indicator = {
		LABEL = "Boss指示器",
		HOVER = "是否开启Boss指示器功能。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "Boss指示器不会显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示Boss指示器。"
			},
		},
	},
	notable_indicator = {
		LABEL = "其他物品的指示器",
		HOVER = "其他物品（切斯特，哈奇等等）指示器是否显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "指示器将被禁用。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "指示器将被显示。"
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
				HOVER = "脚印指示器将不会显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "脚印指示器会被显示。"
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
		LABEL = "避雷针范围",
		HOVER = "避雷针生效范围的生效方式。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "关闭",
				HOVER = "不显示避雷针的生效范围。"
			},
			["1"] = {
				DESCRIPTION = "策略性地显示",
				HOVER = "只在放置避雷针时、使用草叉时、种植时才会显示生效范围。"
			},
			["2"] = {
				DESCRIPTION = "总是",
				HOVER = "总是显示避雷针的生效范围。"
			},
		},
	},
	blink_range = {
		LABEL = "瞬移范围",
		HOVER = "你是否可以看见你的瞬移的范围，如灵魂跳跃，橙色法杖等。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "瞬移范围将不会被显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "瞬移范围将会被显示。"
			},
		},
	},
	wortox_soul_range = {
		LABEL = "沃拓克斯灵魂范围",
		HOVER = "开启后可以看到沃拓克斯拾取灵魂的范围和灵魂治疗范围。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "灵魂范围功能禁用。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "灵魂范围功能启用。"
			},
		},
	},
	battlesong_range = {
		LABEL = "战歌生效范围",
		HOVER = "战歌生效范围是否会被显示。",
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
				DESCRIPTION = "双模式",
				HOVER = "两种范围都将被显示。"
			},
		},
	},
	sinkhole_marks = {
		LABEL = "落水洞标记",
		HOVER = "如何显示落水洞的标记。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "不做任何落水洞的着色标记。"
			},
			["1"] = {
				DESCRIPTION = "仅地图模式",
				HOVER = "只会显示在地图图标上。"
			},
			["2"] = {
				DESCRIPTION = "落水洞和地图双模式",
				HOVER = "地图图标和落水洞本身都会被显示。"
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
		HOVER = "食物属性信息详细或简短展示。",
		OPTIONS = {
			["short"] = {
				DESCRIPTION = "简短",
				HOVER = "+X / -X / +X"
			},
			["long"] = {
				DESCRIPTION = "详细",
				HOVER = "饥饿度： +X / 理智值： -X / 生命值： +X"
			},
		},
	},
	food_order = {
		LABEL = "食物属性显示顺序",
		HOVER = "食物属性以何种顺序显示。",
		OPTIONS = {
			["interface"] = {
				DESCRIPTION = "界面",
				HOVER = "饥饿值 / 理智值 / 生命值"
			},
			["wiki"] = {
				DESCRIPTION = "维基",
				HOVER = "生命值 / 饥饿值 / 理智值"
			},
		},
	},
	food_units = {
		LABEL = "显示食物的度",
		HOVER = "是否展示食物属于哪个度（果、菜、蛋等等）。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "食物度功能禁用。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "食物度功能启用。"
			},
		},
	},
	food_effects = {
		LABEL = "食物加成属性显示",
		HOVER = "食物的特殊加成属性是否会显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "特殊的食物属性将不会被显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "特殊的食物属性将会被显示。"
			},
		},
	},
	stewer_chef = {
		LABEL = "烹饪厨师显示",
		HOVER = "这个料理的制作人的信息是否会被显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不会被显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "会被显示。"
			},
		},
	},
	food_memory = {
		LABEL = "瓦力大厨的食物计时",
		HOVER = "你的食物计时是否会显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "你的食物计时不会被显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "你的食物计时会被显示。"
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
	display_spawner_information = {
		LABEL = "生物生成计时器",
		HOVER = "是否显示生物生成计时信息（猪人、兔人等）。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "关闭",
				HOVER = "不显示生物生成计时信息。"
			},
			["true"] = {
				DESCRIPTION = "开启",
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
		HOVER = "土壤/植物的潮湿度如何显示。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "关闭",
				HOVER = "土壤潮湿度不显示。",
			},
			["1"] = {
				DESCRIPTION = "仅土壤",
				HOVER = "仅显示土壤的潮湿度。",
			},
			["2"] = {
				DESCRIPTION = "土壤/植株",
				HOVER = "显示土壤潮湿度和植株耗水率。",
			},
			["3"] = {
				DESCRIPTION = "土壤，植株，耕地",
				HOVER = "显示土壤潮湿度，植株耗水率，耕地潮湿度。",
			},
			["4"] = {
				DESCRIPTION = "全部",
				HOVER = "显示土壤潮湿度，植株耗水率，总耕地潮湿度。",
			}
		}
	},
	soil_nutrients = {
		LABEL = "土壤养分值",
		HOVER = "如何显示土壤/植株的养分值。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "关闭",
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
				HOVER = "土壤养分值，植株耗肥率，耕地养分值全部显示。",
			},
			--[[
			["4"] = {
				DESCRIPTION = "全部",
				HOVER = "土壤养分值，植株耗肥率，总耕地养分值将被显示。",
			}
			--]]
		}
	},
	display_plant_stressors = {
		LABEL = "植物压力值",
		HOVER = "决定是否展示植物压力值",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "否",
				HOVER = "植物压力值将不会显示",
			},
			["1"] = {
				DESCRIPTION = "有园艺帽时",
				HOVER = "如果你身上有，或戴上远古园艺帽时，显示植物的压力值。",
			},
			["2"] = {
				DESCRIPTION = "总是",
				HOVER = "总是显示植物的压力值"
			}
		}
	},
	display_weighable = {
		LABEL = "物品的重量数值",
		HOVER = "决定物品的重量值是否会显示",
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
		LABEL = "显示大世界事件",
		HOVER = "此选项决定世界事件是否会被显示。世界事件有：猎犬/蠕虫，世界Boss，地震和其他事件。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不展示世界事件。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示大世界事件。"
			},
		},
	},
	display_weather = {
		LABEL = "显示天气信息",
		HOVER = "此项决定天气信息是否显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "天气信息不显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "天气信息显示。"
			},
		},
	},
	nightmareclock_display = {
		LABEL = "洞穴暴动阶段",
		HOVER = "决定玩家是否可以看到洞穴暴动的具体阶段。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "关闭",
				HOVER = "不显示洞穴暴动的阶段信息。"
			},
			["1"] = {
				DESCRIPTION = "需要铥矿勋章",
				HOVER = "拥有铥矿勋章时，暴动阶段信息才会显示。"
			},
			["2"] = {
				DESCRIPTION = "开启",
				HOVER = "总是显示暴动阶段的信息。"
			},
		},
	},
	display_health = {
		LABEL = "生命值",
		HOVER = "生命值的信息是否会被显示。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "生命值信息不会被显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "生命值信息会被显示。"
			},
		},
	},
	growth_verbosity = {
		LABEL = "植物生长阶段",
		HOVER = "展示植物生长的具体信息。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "完全不展示会生长的物品的信息。"
			},
			["1"] = {
				DESCRIPTION = "简短",
				HOVER = "只显示生长到下一阶段所需的时间。"
			},
			["2"] = {
				DESCRIPTION = "详细",
				HOVER = "显示当前阶段名称，阶段的数字，长到下一阶段所需的时间。"
			},
		},
	},
	display_finiteuses = {
		LABEL = "工具耐久度",
		HOVER = "是否显示工具的耐久度",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不开启工具耐久度显示。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示工具的耐久度。"
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
		HOVER = "是否显示可升级物品的信息。",
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
		LABEL = "淘气值显示",
		HOVER = "决定以何种形式展示淘气值。Combined Status这个模组显示淘气值的优先度优于本模组。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示淘气值信息。"
			},
			["1"] = {
				DESCRIPTION = "生物的淘气值",
				HOVER = "杀死此生物增加多少淘气值会被显示。"
			},
			["2"] = {
				DESCRIPTION = "玩家/生物的淘气值",
				HOVER = "玩家已有的淘气值和生物的淘气值会一同显示。"
			},
		},
	},
	follower_info = {
		LABEL = "随从的信息",
		HOVER = "是否会显示你的跟随者的信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "跟随者的信息不会被显示。"
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "跟随者的信息会被显示。"
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
		LABEL = "牛驯服度显示",
		HOVER = "是否会显示牛的驯服度。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "禁用",
				HOVER = "不显示驯服度信息。"
			},
			["true"] = {
				DESCRIPTION = "启用",
				HOVER = "显示驯服度的信息。"
			},
		},
	},
	display_pollination = {
		LABEL = "授粉信息",
		HOVER = "是否显示蜜蜂、蝴蝶的授粉信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "关闭",
				HOVER = "不显示授粉信息。"
			},
			["true"] = {
				DESCRIPTION = "开启",
				HOVER = "将显示授粉信息。"
			},
		},
	},
	display_hunger = {
		LABEL = "物品的饥饿值",
		HOVER = "物品饥饿值的具体信息将会显示。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "否",
				HOVER = "不会显示饥饿值。"
			},
			["1"] = {
				DESCRIPTION = "标准化",
				HOVER = "标准的饥饿值显示。"
			},
			["2"] = {
				DESCRIPTION = "所有",
				HOVER = "将会显示所有物品的具体饥饿值。"
			},
		},
	},
	display_sanityaura = {
		LABEL = "精神光环",
		HOVER = "是否显示精神光环。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示精神光环。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示精神光环。"
			},
		},
	},
	item_worth = {
		LABEL = "显示物品的价值",
		HOVER = "是否会显示物品的价值。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不会显示物品值多少黄金或金币。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示物品值多少黄金或金币。"
			},
		},
	},
	appeasement_value = {
		LABEL = "显示蚁狮献祭时间的信息",
		HOVER = "是否显示蚁狮献祭时间和作乱的信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不会展示蚁狮相关的信息。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "将会展示蚁狮的信息。"
			},
		},
	},
	fuel_verbosity = {
		LABEL = "燃料信息",
		HOVER = "燃料的信息如何显示。",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "无",
				HOVER = "燃料信息将不会被显示。"
			},
			["1"] = {
				DESCRIPTION = "标准化",
				HOVER = "标准化的燃料信息将会展示。"
			},
			["2"] = {
				DESCRIPTION = "最大化",
				HOVER = "全面的燃料信息将会展示。"
			},
		},
	},
	--------------------------------------------------------------------------
	--[[ Miscellaneous ]]
	--------------------------------------------------------------------------
	account_combat_modifiers = {
		LABEL = "战斗信息",
		HOVER = "显示伤害加成和减免信息。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "伤害按照原始数据计算。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "伤害将按照玩家拥有的加成和削弱状态来计算。"
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
		LABEL = "信息刷新延时",
		HOVER = "设定对同一物品的信息多久一次更新。",
		OPTIONS = {
			["true"] = {
				DESCRIPTION = "自动设定",
				HOVER = "取决于玩家和游戏性能，动态更新。"
			},
			["0"] = {
				DESCRIPTION = "无设定",
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
		LABEL = "崩溃报错器",
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
		LABEL = "执行调试展示信息",
		HOVER = "如果游戏内元件来源未明，错误自于某个模组时，发出警告并显示其来源。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "未找出错误原因时，不会发出警告。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "未找出错误原因时，将会向你发出警告。"
			},
		},
	},
	DEBUG_SHOW_DISABLED = {
		LABEL = "禁用调试展示",
		HOVER = "发出警告，显示我手动禁用的元件。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不会展示已禁用的描述符的信息。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "显示已禁用的描述符的信息。"
			},
		},
	},
	DEBUG_SHOW_PREFAB = {
		LABEL = "预设调试显示",
		HOVER = "在物品上显示预设选项的名称。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "不显示物品的预设项信息。"
			},
			["true"] = {
				DESCRIPTION = "否",
				HOVER = "显示物品的预设项信息。"
			},
		},
	},
	DEBUG_ENABLED = {
		LABEL = "开启调试功能",
		HOVER = "打开你的Insight的调试功能。",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "否",
				HOVER = "禁用的描述选项不会显示任何信息。"
			},
			["true"] = {
				DESCRIPTION = "是",
				HOVER = "禁用的描述选项将会显示信息。"
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
		name = "fuel_highlighting",
		options = {
			{data = false},
			{data = true},
		}, 
		default = false,
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
		name = "item_range_indicator",
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
		default = true,
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
		client = true,
		tags = {"dst_only"},
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
		name = "display_sanityaura",
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
	AddSectionTitle(T"sectiontitle_miscellaneous"),
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
		tags = {"dst_only", "undefined"},
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