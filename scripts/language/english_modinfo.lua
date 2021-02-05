return {
	language = {
		LABEL = "Language",
		HOVER = "The language you want information to display in.",
		OPTIONS = {
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
		LABEL = "Info Style",
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
				HOVER = "No chest/ite4m highlighting."
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
				HOVER = "Boss indicators shown."
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
				HOVER = "Notable indicators shown."
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
				HOVER = "Hunt indicators shown."
			},
		},
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
	perishable_format = {
		LABEL = "Perish formatting",
		HOVER = "How perishable information should be displayed.",
		OPTIONS = {
			["0"] = {
				DESCRIPTION = "Don't display at all.",
				HOVER = "Will not display perish information."
			},
			["1"] = {
				DESCRIPTION = "Only until rot",
				HOVER = "Will display the time until the food rots."
			},
			["2"] = {
				DESCRIPTION = "In stages",
				HOVER = "Will display the time until food reaches the next stage."
			},
		},
	},
	display_world_events = {
		LABEL = "Show World Events",
		HOVER = "Determines whether world events are shown.\nWorld Events: Hounds/Worms, Bosses, Earthquakes, etc.",
		OPTIONS = {
			["false"] = {
				DESCRIPTION = "No",
				HOVER = "World events are not shown."
			},
			["true"] = {
				DESCRIPTION = "Yes",
				HOVER = "World events are shown."
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
	display_hunger = {
		LABEL = "Entity Hunger",
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
			["0.25"] = {
				DESCRIPTION = "0.25s",
				HOVER = "Information updates every 0.25 seconds."
			},
			["0.5"] = {
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