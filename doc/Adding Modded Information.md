# Adding modded information

So, you've modded something and you want Insight to show information for it. Well, here's what you need to know.

## Basics

Insight has the concept of "descriptors" for components and prefabs, which typically contain all of the relevant logic for providing information for their respective domains.

Descriptors are typically named and located in accordance to what they describe. For example:
- `scripts/descriptors/health.lua` provides information for the health component
- `scripts/prefab_descriptors/batbat.lua` provides information for the Bat Bat prefab.

*Descriptor names need to be unique, and only one can exist for a component at a time. This may change in the future.*

**Important Note: When referencing Insight functions, it is recommended to specify the API version you are after.**

### Example Descriptor

The most basic descriptor will consist of a Describe method that returns some information. The vast majority of your use cases for Insight descriptors will follow this pattern.

```lua
-- mydescriptor.lua

-- self is the component or prefab being described
-- see rest of docs for context
local function Describe(self, context)
	local description = nil -- Shows all the time; is the "basic" description.
	local alt_description = nil -- Only shows when "Inspect" (Left-Alt) is held down. Typically the "advanced/detailed" description.

	if self.my_sample_property then
		description = string.format("<color=#ff00ff>my property</color>: %s", tostring(self.my_sample_property))
	end

	if self.other_property then
		alt_description = description .. string.format(" (%s)", self.other_property)
	end

	return {
		priority = 0, -- The priority of this information. Higher priority means closer to the top.
		description = description,
		alt_description = alt_description
	}
end

-- Can return nil or a table.
return {
	Describe = Describe
}

```

### What's this "context" thing?

Context is the session of the user that is requesting the information. It contains details such as the player entity, the player's configuration, localization, and miscellaneous data. 

Rough Example:
```lua
context = {
	player = wortox,
	config = { -- configuration from insight
		["display_upgradeable"] = true,
		...
	},
	external_config = { -- external mod related config
		...
	},
	usingIcons = false, -- whether the user is using icon formatting
	lstr = {...}, -- see scripts/language.lua
	is_server_owner = true/false,
	etc = {...}
}
```


## Registering descriptors

I typically recommend waiting until `AddSimPostInit` to add your descriptor to Insight, especially if you're trying to load later than Insight. It is not strictly necessary though.

This is an example:

```lua
-- modmain.lua
local _G = GLOBAL

local function AddDescriptors()
	if not _G.rawget(_G, "Insight") then 
		-- Only run if Insight is enabled.
		return 
	end

	local InsightApi = _G.Insight.API.V1

	local descriptor = require("descriptors/mydescriptor")

	InsightApi.AddComponentDescriptor("mycomponent", descriptor, {
		modname = "yourmodname"
	})
end

AddSimPostInit(AddDescriptors)
```

Prefab descriptors work similarly:

```lua
-- modmain.lua
local _G = GLOBAL

local function AddDescriptors()
	if not _G.rawget(_G, "Insight") then 
		-- Only run if Insight is enabled.
		return 
	end

	local InsightApi = _G.Insight.API.V1

	local descriptor = require("prefab_descriptors/myprefabdescriptor")

	InsightApi.AddPrefabDescriptor("myprefab", descriptor, {
		modname = "yourmodname"
	})
end

AddSimPostInit(AddDescriptors)
```

## Rich Text

Insight has a rich text system used for stylizing text. As the game's text rendering is lacking in some helpful features, the rich text is less than perfect but does a good job of getting things done.

It works on a tag based system, similar to XML or HTML. All of the descriptions returned by Insight descriptors get processed through this system.

RichText currently supports 4 stylings:
- Color
- Icon insertion
- Superscript
- Subscript

The spacing is extremely important in tags, and they must obey the format outlined in the example.

### Coloring

Color can equal a hexadecimal color code, or they can be a specific color stored in _G.Insight.COLORS, like this: `<color=HEALTH>healthy :)</color>`
- I sometimes store frequently used colors, such as MOB_SPAWN (which is #ee6666) in the COLORS table so I don't have to change multiple strings.


### Icon Insertion

Probably the trickiest to work with out of all of the features. The gist of it is that an icon must exist in the icon_list table for it to work.
- That table can be found in scripts/assets.lua  

```lua
local text_with_icons = "You have a big <icon=health> sir, but your <icon=sanity> is weak."
```
Where `<icon=health>` is the health meter icon, and `<icon=sanity>` is the sanity meter icon.


### Superscript, subscript

```lua
local super_and_sub = "2<sup>10</sup> is 1024. log<sub>b</sub>x = y."
```

That's pretty much it. There's a ton of examples in Insight's descriptors. So if there's a specific information style you want to recreate, just look at the responsible descriptor.
