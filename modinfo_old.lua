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

-- DS 2081254154
-- DST 2189004162
local IsDST = folder_name ~= nil -- present in DST, not DS. big brain engaged

local DS_description = "Basically Show Me but for Don't Starve."
local DST_description = "Basically Show Me but with more features."
local DST_config_paths = "Server Configuration: Main Menu -> Host Game -> Mods -> Server Mods -> Insight -> Configure Mod\n-------------------------\nClient Configuration: Main Menu -> Mods -> Server Mods -> Insight -> Configure Mod"

local latest_update = "pollination & harvestable information; possible performance increase for more developed worlds; mactusk info, lureplant info, sinkhole coloring;\n**Crash reporter added**, you should enable it in the client & server config"

name = "Insight"
version = "2.6.12" -- ds is 2.4.4_ds
description = (locale or "") .. ("%s\nMake sure to check out the configuration options, especially if something is displaying/no longer displaying.\nVersion: %s\nLatest Update: %s\n-------------------------\n%s"):format(IsDST and DST_description or DS_description, version, latest_update, IsDST and DST_config_paths or "")
author = "penguin0616"
forumthread = ""
icon_atlas = "modicon.xml"
icon = "modicon.tex"
id = "Insight"

--[[
	rezecib's Geometric Placement has -10
	chinese++, has -9999
]]
priority = -10000

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

-- Functions
local function AddSectionTitle(title) -- 100% stole this idea from ReForged. Didn't know this was possible!
	if IsDST then
		return {
			name = title:upper(), -- avoid conflicts
			label = title, 
			hover = "",
			options = {{description = "", data = 0}},
			default = 0,
			tags = {"ignore"},
		}
	else
		return {tags = {"ignore"}}
	end
end


configuration_options = {
	AddSectionTitle("Formatting"),
	{
		name = "language", -- name of option
		label = "Language", -- displayed name
		hover = "The language you want information to display in.", -- header for option in dst
		options = {
			{description = "English", data = "en", hover = "English"},
			{description = "Chinese", data = "zh", hover = "Chinese"},
		}, 
		default = "en",
		client = true,
		tags = {},
	},
	{
		name = "info_style",
		label = "Icon Mode",
		hover = "Whether you want to use icons or text.",
		options = {
			{description = "No", data = "text", hover = "Text will be used"},
			{description = "Yes", data = "icon", hover = "Icons will be used over text where possible."},
		}, 
		default = "text",
		client = true,
		tags = {},
	},
	{
		name = "text_coloring",
		label = "Text Coloring",
		hover = "Whether text coloring is enabled.",
		options = {
			{description = "Disabled", data = false, hover = "Text coloring will not be used. :("},
			{description = "Enabled", data = true, hover = "Text coloring will be used."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "itemtile_display",
		label = "Inv Slot Info",
		hover = "What kind of information shows instead of percentages on item slots.",
		options = {
			{description = "None", data = 0, hover = "Will not provide ANY information on item slots."},
			{description = "Numbers", data = 1, hover = "Will provide durability numbers on item slots."},
			{description = "Percentages", data = 2, hover = "Will provide use default percentages on item slots."},
		}, 
		default = 2,
		client = true,
		tags = {},
	},
	{
		name = "time_style",
		label = "Time style",
		hover = "How to display time information.",
		options = {
			{description = "Game time", data = "gametime", hover = "Displays time information based on game time: days, segments."},
			{description = "Real time", data = "realtime", hover = "Displays time information based on real time: hours, minutes, seconds."},
			{description = "Both", data = "both", hover = "Use both time styles: days, segments (hours, minutes, seconds)"},
			{description = "Game time (Short)", data = "gametime_short", hover = "Displays shortened time information based on game time."},
			{description = "Real time (Short)", data = "realtime_short", hover = "Displays shortened time information based on real time: hours:minutes:seconds."},
			{description = "Both (Short)", data = "both_short", hover = "Use both time styles and shorten: x.y days (hours:minutes:seconds)."},
			--{description = "None", data = "none", hover = "Do not display time information if possible. (Each setting interprets differently.)"},
		}, 
		default = "gametime",
		client = true,
		tags = {},
	},
	{
		name = "highlighting",
		label = "Enable Highlighting",
		hover = "Whether item highlighting is enabled. (\"Finder\")",
		options = {
			{description = "No", data = false, hover = "No chest/ite4m highlighting."},
			{description = "Yes", data = true, hover = "Chests/items will be highlighted."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "fuel_highlighting",
		label = "Fuel Highlighting",
		hover = "Whether fuel highlighting is enabled.",
		options = {
			{description = "No", data = false, hover = "Fuel entities will not be highlighted."},
			{description = "Yes", data = true, hover = "Fuel entities will be highlighted."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	AddSectionTitle("Indicators"),
	{
		name = "boss_indicator",
		label = "Boss Indicator",
		hover = "Whether boss indicators are shown.",
		options = {
			{description = "No", data = false, hover = "Boss indicators not shown."},
			{description = "Yes", data = true, hover = "Boss indicators shown."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "notable_indicator",
		label = "Notable Indicator",
		hover = "Whether the notable (chester, hutch, etc) indicators are shown.",
		options = {
			{description = "No", data = false, hover = "Notable indicators not shown."},
			{description = "Yes", data = true, hover = "Notable indicators shown."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "hunt_indicator",
		label = "Hunt Indicator",
		hover = "Whether hunt indicators are shown.",
		options = {
			{description = "No", data = false, hover = "Hunt indicators not shown."},
			{description = "Yes", data = true, hover = "Hunt indicators shown."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "lightningrod_range",
		label = "Lightningrod range",
		hover = "How lightningrod range is displayed.",
		options = {
			{description = "Off", data = 0, hover = "Do not show lightning rod range."},
			{description = "Strategic", data = 1, hover = "Only show during placements / pitchforking (just like a flingo)."},
			{description = "Always", data = 2, hover = "Always show lightning rod range."},
		}, 
		default = 1,
		client = true,
		tags = {},
	},
	{
		name = "blink_range",
		label = "Blink range",
		hover = "Whether you can see your blink range.",
		options = {
			{description = "No", data = false, hover = "Blink range not shown."},
			{description = "Yes", data = true, hover = "Blink range shown."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "wortox_soul_range",
		label = "Wortox Soul range",
		hover = "Whether you can see the ranges wortox has for his souls.",
		options = {
			{description = "No", data = false, hover = "Soul ranges not shown."},
			{description = "Yes", data = true, hover = "Soul ranges shown."},
		}, 
		default = true,
		client = true,
		tags = {"dst_only"},
	},
	{
		name = "battlesong_range",
		label = "Battle song range",
		hover = "How battle song ranges are displayed.",
		options = {
			{description = "None", data = "none", hover = "Do not show battle song ranges."},
			{description = "Detach", data = "detach", hover = "Song detachment range shown."},
			{description = "Attach", data = "attach", hover = "Song attachment range shown."},
			{description = "Both", data = "both", hover = "Both ranges are shown."},
		}, 
		default = "both",
		client = true,
		tags = {"dst_only"},
	},
	{
		name = "sinkhole_marks",
		label = "Sinkhole Marks",
		hover = "How sinkhole marking is applied.",
		options = {
			{description = "None", data = 0, hover = "Do not do any sinkhole coloring."},
			{description = "Map Only", data = 1, hover = "Only apply to map icons."},
			{description = "Sinkholes & Map", data = 2, hover = "Apply to both map icons & sinkholes."},
		}, 
		default = 2,
		client = true,
		tags = {"dst_only"},
	},
	AddSectionTitle("Food Related"),
	--[[
	{
		name = "display_food",
		label = "Display food stats",
		hover = "Whether food stats are displayed.",
		options = {
			{description = "No", data = false, hover = "Do not display food information."},
			{description = "Yes", data = true, hover = "Display food information."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	--]]
	{
		name = "food_style",
		label = "Food style",
		hover = "Food information length.",
		options = {
			{description = "Short", data = "short", hover = "+X / -X / +X"},
			{description = "Long", data = "long", hover = "Hunger: +X / Sanity: -X / Health: +X"},	
		}, 
		default = "long",
		client = true,
		tags = {},
	},
	{
		name = "food_order",
		label = "Food order",
		hover = "What order food stats are displayed in (if you choose Wiki you're dead to me)",
		options = {
			{description = "Interface", data = "interface", hover = "Hunger / Sanity / Health"},
			{description = "Wiki", data = "wiki", hover = "Health / Hunger / Sanity"},
		}, 
		default = "interface",
		client = true,
		tags = {},
	},
	{
		name = "food_units",
		label = "Display food units",
		hover = "Whether food units are displayed.",
		options = {
			{description = "No", data = false, hover = "Food units will NOT be displayed."},
			{description = "Yes", data = true, hover = "Food units WILL be displayed."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "food_effects",
		label = "Food Effects",
		hover = "Whether special food effects show or not.",
		options = {
			{description = "No", data = false, hover = "Special food effects will not show."},
			{description = "Yes", data = true, hover = "Special food effects will not show."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "stewer_chef",
		label = "Chef Identifiers",
		hover = "Whether the chef of a recipe is shown.",
		options = {
			{description = "No", data = false, hover = "The chef will not be shown."},
			{description = "Yes", data = true, hover = "The chef will be shown."},
		}, 
		default = true,
		tags = {"undefined", "dst_only"},
	},
	{
		name = "food_memory",
		label = "Food Memory",
		hover = "Whether your food memory is shown.",
		options = {
			{description = "No", data = false, hover = "Your food memory will not be shown."},
			{description = "Yes", data = true, hover = "Your food memory will be shown."},
		}, 
		default = true,
		client = true,
		tags = {"undefined", "dst_only"},
	},
	{
		name = "perishable_format",
		label = "Perish formatting",
		hover = "How perishable information should be displayed.",
		options = {
			{description = "Don't display at all.", data = 0, hover = "Will not display perish information."},
			{description = "Only until rot", data = 1, hover = "Will display the time until the food rots."},
			{description = "In stages", data = 2, hover = "Will display the time until food reaches the next stage."},
		}, 
		default = 2,
		tags = {"undefined"},
	},
	AddSectionTitle("Information Control"),
	{
		name = "show_world_events",
		label = "Show World Events",
		hover = "Determines whether world events are shown.\nWorld Events: Hounds/Worms, Bosses, Earthquakes, etc.",
		options = {
			{description = "No", data = false, hover = "World events are not shown."},
			{description = "Yes", data = true, hover = "World events are shown."},
		}, 
		default = true,
		tags = {"dst_only", "undefined"},
	},
	{
		name = "nightmareclock_display",
		label = "Nightmare Phases",
		hover = "Controls when users receive information about the Nightmare Phases.",
		options = {
			{description = "Off", data = 0, hover = "No nightmare phase information is shown."},
			{description = "Need Medallion", data = 1, hover = "Nightmare phase information is shown if a Thulecite Medallion is present."},
			{description = "On", data = 2, hover = "Nightmare phase information is always shown."},
		}, 
		default = 2,
		tags = {"undefined"},
	},
	{
		name = "display_health",
		label = "Health",
		hover = "Whether health information should be shown.",
		options = {
			{description = "No", data = false, hover = "Health information is not shown."},
			{description = "Yes", data = true, hover = "Health information is shown."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "growth_verbosity",
		label = "Growth Verbosity",
		hover = "How detailed growth information should be.",
		options = {
			{description = "None", data = 0, hover = "Displays nothing about growable entities."},
			{description = "Minimal", data = 1, hover = "Displays time until next stage."},
			{description = "All", data = 2, hover = "Displays current stage name, number of stages, and time until next stage."},
		}, 
		default = 1,
		tags = {"undefined"},
	},
	{
		name = "display_finiteuses",
		label = "Tool Durability",
		hover = "Whether tool durability is displayed.",
		options = {
			{description = "No", data = false, hover = "Tool durability will not be displayed."},
			{description = "Yes", data = true, hover = "Tool durability will be displayed."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "display_timers",
		label = "Timers",
		hover = "Whether timer information is displayed.",
		options = {
			{description = "No", data = false, hover = "Timers will not be displayed."},
			{description = "Yes", data = true, hover = "Timers will be displayed."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_upgradeable",
		label = "Upgradeables",
		hover = "Whether upgradeable information is displayed.",
		options = {
			{description = "No", data = false, hover = "Will not display information for upgradeable structures."},
			{description = "Yes", data = true, hover = "Displays information for upgradeable structures, such as spider dens."},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "naughtiness_verbosity",
		label = "Naughtiness verbosity",
		hover = "How verbose the naughtiness information should be. Combined Status takes precedence for player naughtiness.",
		options = {
			{description = "Disabled", data = 0, hover = "Most naughtiness values will not display."},
			{description = "Creature", data = 1, hover = "Creature naughtiness values will display."},
			{description = "Plr/Creature", data = 2, hover = "Player and creature naughtiness values will display."},
		}, 
		default = 2,
		tags = {"undefined"},
	},
	{
		name = "follower_info",
		label = "Follower information",
		hover = "Whether follower information is displayed.",
		options = {
			{description = "Disabled", data = false, hover = "Will not display follower information."},
			{description = "Enabled", data = true, hover = "Will display follower information."},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "herd_information",
		label = "Herd information",
		hover = "Whether herd information is displayed.",
		options = {
			{description = "Disabled", data = false, hover = "Will not display herd information."},
			{description = "Enabled", data = true, hover = "Will display herd information."},
		}, 
		default = false,
		tags = {"undefined"},
	},
	{
		name = "domestication_information",
		label = "Domestication info",
		hover = "Whether domestication information is displayed.",
		options = {
			{description = "Disabled", data = false, hover = "Will not display domestication information."},
			{description = "Enabled", data = true, hover = "Will display domestication information."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "display_hunger",
		label = "Entity Hunger",
		hover = "How much hunger detail is shown.",
		options = {
			{description = "No", data = 0, hover = "Will not display hunger."},
			{description = "Standard", data = 1, hover = "Will display standard hunger information."},
			{description = "All", data = 2, hover = "Will display all hunger information."},
		}, 
		default = 1,
		tags = {"undefined"},
	},
	{
		name = "item_worth",
		label = "Display item worth",
		hover = "Whether item worth is displayed.",
		options = {
			{description = "No", data = false, hover = "Will not display gold or dubloon value."},
			{description = "Yes", data = true, hover = "Will display gold and dubloon value."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "appeasement_value",
		label = "Display Appeasement",
		hover = "Whether appeasement worth is displayed.",
		options = {
			{description = "No", data = false, hover = "Will not display appeasement value."},
			{description = "Yes", data = true, hover = "Will display appeasement value."},
		}, 
		default = true,
		tags = {"undefined"},
	},
	{
		name = "fuel_verbosity",
		label = "Fuel Verbosity",
		hover = "How verbose fuel information is.",
		options = {
			{description = "None", data = 0, hover = "No fuel information will show."},
			{description = "Standard", data = 1, hover = "Standard fuel information will show."},
			{description = "Maximum", data = 2, hover = "All fuel information will show."},
		}, 
		default = 1,
		tags = {"undefined"},
	},
	AddSectionTitle("Miscellaneous"),
	{
		name = "account_combat_modifiers",
		label = "Combat Modifiers",
		hover = "Whether damage boosts and resistances are considered.",
		options = {
			{description = "No", data = false, hover = "Combat popups (ie damage) will only use original values."},
			{description = "Yes", data = true, hover = "Combat popups (ie damage) will account for any buffs/nerfs your character has."},
		}, 
		default = true,
		client = true,
		tags = {},
	},
	{
		name = "refresh_delay",
		label = "Refresh delay",
		hover = "How often clients can re-request information for the same item.",
		options = {
			{description = "Automatic", data = true, hover = "Dynamic updates based on players and performance."},
			{description = "None", data = 0, hover = "Information is live."},
			--{description = "0.1s", data = 0.1, hover = "Information updates every 0.1 seconds."},
			{description = "0.25s", data = 0.25, hover = "Information updates every 0.25 seconds."},
			{description = "0.5s", data = 0.5, hover = "Information updates every 0.5 seconds."},
			{description = "1s", data = 1, hover = "Information updates every 1 second."},
			{description = "3s", data = 3, hover = "Information updates every 3 seconds."},
		},
		default = true,
		tags = {"dst_only", "undefined"},
	},
	AddSectionTitle("Debugging"),
	{
		name = "crash_reporter",
		label = "Crash Reporter",
		hover = "**Attempts** to report your crashes (debug, mods, world info) automatically to my server.",
		options = {
			{description = "No", data = false, hover = "The crash reporter is disabled."},
			{description = "Yes", data = true, hover = "The crash reporter is enabled."},
		},
		default = false,
		tags = {"independent", "dst_only"},
	},
	{
		name = "DEBUG_SHOW_NOTIMPLEMENTED",
		label = "DEBUG_SHOW_NOTIMPLEMENTED",
		hover = "Displays a warning if a component is not accounted for, and the origin if it is from a mod.",
		options = {
			{description = "No", data = false, hover = "Will not warn if there are any components not accounted for."},
			{description = "Yes", data = true, hover = "Will warn you if there are any components not accounted for."},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "DEBUG_SHOW_DISABLED",
		label = "DEBUG_SHOW_DISABLED",
		hover = "Shows warnings for components I have manually disabled.",
		options = {
			{description = "No", data = false, hover = "Will not display information for disabled descriptors."},
			{description = "Yes", data = true, hover = "Will display information for disabled descriptors."},
		}, 
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "DEBUG_SHOW_PREFAB",
		label = "DEBUG_SHOW_PREFAB",
		hover = "Displays prefab name on entities.",
		options = {
			{description = "No", data = false, hover = "Will not display prefabs on entity."},
			{description = "Yes", data = true, hover = "Will display prefabs on entity."},
		},
		default = false,
		client = true,
		tags = {},
	},
	{
		name = "DEBUG_ENABLED",
		label = "DEBUG_ENABLED",
		hover = "Puts you in Insight's Debug Mode.",
		options = {
			{description = "No", data = false, hover = "Will not display information for disabled descriptors."},
			{description = "Yes", data = true, hover = "Will display information for disabled descriptors."},
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

	local msg = "MAJOR ERROR. UNABLE TO FIND DEFAULT OPTION FOR: " .. entry.name
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
			entry.options[#entry.options+1] = { description = "Undefined", data = "undefined", hover = "Defaults to: " .. default.description}
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