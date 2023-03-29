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

--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim
local IsPrefab, IsWidget, IsBundleWrap = IsPrefab, IsWidget, IsBundleWrap

local cooking = require("cooking")


local highlightColorKey = "_insight_highlight"
local fuel_highlighting = nil
local highlighting_enabled = nil

local world_type = GetWorldType()
local is_client_host = IsClientHost()

local texturePrefabCache = {}

local highlighting = {
	process_per_update = 300
}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Color Constants ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local COLOR_TYPES = {
	FUEL = "FUEL",
	MATCH = "MATCH",
	UNKNOWN = "UNKNOWN",
	ERROR = "ERROR",
}

local COLORS_ADD = { -- brighter but most color gets siphoned at night
	-- alpha doesn't matter? 
	RED = {0.6, 0, 0, 1}, -- red (by itself, #ff0000, it's red.)
	GREEN = {0, 0.5, 0, 1}, -- green (by itself, #00ff00, it's green.)
	BLUE = {0, 0, 1, 1}, -- blue (by itself, #0000ff, it's blue.)
	--GRAY = {0.4, 0.4, 1}, -- gray (by itself, #666666, is gray)
	--BLACK = {0, 0, 0, 1}, -- black (by itself, #000000, is black)
	NOTHING = {0, 0, 0, 0}, -- default without any changes

	LIGHT_BLUE = {0, 0.4, 0.6, 1}, -- light blue (by itself, #006699, its a nice ocean blue)
	PURPLE = {0.4, 0, 1, 1}, -- purple (by itself, #6600ff, dark blue with red tint) -- rgb(155, 89, 182) {0.6, 0.35, 0.71, 1} sin purple -- rgb(98, 37, 209) {0.38, 0.145, 0.82, 1} royal purple
	YELLOW = {0.4, 0.4, 0, 1}, -- yellow (by itself, #666600, ugly dark yellow)
	WHITE = {0.4, 0.4, 0.4, 1},
	ORANGE = {0.8, 0.35, 0, 1}, -- orange -- {1, 0.5, 0, 1}
	PINK = {1, 0, 1, 1}
}

COLORS_ADD.GRAY = COLORS_ADD.NOTHING
COLORS_ADD.BLACK = COLORS_ADD.NOTHING

local COLORS_MULT = { -- more resistant to night siphoning color, but dimmer
	RED = {1, 0.4, 0.4, 1}, -- red (by itself, #ff6666, lighter version of MOB_COLOR)
	GREEN = {0.3, 1, 1, 1}, -- greenish (by itself, #4dffff, seems to be slightly lighter cyan)
	BLUE = {0.4, 0.4, 1, 1},
	GRAY = {0.4, 0.4, 0.4, 1}, -- gray (by itself, #666666, is gray)
	BLACK = {0, 0, 0, 1}, -- black (by itself, #000000, is black)
	NOTHING = {1, 1, 1, 1}, -- default without any changes

	LIGHT_BLUE = {0, 0.9, 1, 1},  -- 0, 0.5, 1
	PURPLE = {0.4, 0, 1, 1},
	--YELLOW = {0.5, 0.5, 0, 1},
	--WHITE = {1, 1, 1, 1},
	ORANGE = {1, 0.4, 0.4, 1},
	PINK = {1, 0, 1, 1},
}

COLORS_MULT.YELLOW = COLORS_MULT.GREEN
COLORS_MULT.WHITE = COLORS_MULT.GREEN

--[[
local COLORS_ADD = {
	RED = {r=1, g=0, b=0, a=1}, -- red (by itself, #ff0000, it's red.)
	GREEN = {r=0, g=1, b=0, a=1}, -- green (by itself, #00ff00, it's green.)
	BLUE = {r=0, g=0, b=1, a=1}, -- blue (by itself, #0000ff, it's blue.)
	--GRAY = {1, 1, 1, 0.3}, -- gray (by itself, #666666, is gray)
	--BLACK = {0.0, 0.0, 0.0, 1}, -- black (by itself, #000000, is black)
	NOTHING = {r=0, g=0, b=0, a=0}, -- default without any changes

	LIGHT_BLUE = {r=0, g=1, b=1, a=1} -- light blue (by itself, #00ffff, its cyan)
}

local COLORS_MULT = {
	RED = {r=1, g=0.4, b=0.4, a=1}, -- red (by itself, #ff6666, lighter version of MOB_COLOR)
	GREEN = {r=0.3, g=1, b=1, a=1}, -- greenish (by itself, #4dffff, seems to be slightly lighter cyan)
	BLUE = {r=0.4, g=0.4, b=1, a=1},
}
--]]

--[[
local COLORS_MULT = {
	FUEL = {1, 0.4, 0.4, 1}, -- red (by itself, #ff6666, lighter version of MOB_COLOR)
	MATCH = {0.3, 1, 1, 1}, -- greenish (by itself, #4dffff, seems to be cyan)
	UNKNOWN = {0.4, 0.4, 0.4, 1}, -- gray (by itself, #666666, is gray)
	ERROR =  {0.0, 0.0, 0.0, 1}, -- black (by itself, #000000, is black)
	DEFAULT = {1.0, 1.0, 1.0, 1} -- default without any changes
}

local COLORS_ADD = {
	FUEL = {1, 0, 0, 0.3}, -- red
	MATCH = {0, 1, 0, 0.3}, -- greenish
	UNKNOWN = {1, 1, 1, 0.3}, -- gray
	ERROR = {0.0, 0.0, 0.0, 0.3}, -- black
	DEFAULT = {0.0, 0.0, 0.0, 0.0} -- default without any changes
}
--]]


local add_colors_to_use = {
	[COLOR_TYPES.FUEL] = COLORS_ADD.RED,
	[COLOR_TYPES.MATCH] = COLORS_ADD.GREEN,
	[COLOR_TYPES.UNKNOWN] = COLORS_ADD.GRAY, -- doesn't actually get used
	[COLOR_TYPES.ERROR] = COLORS_ADD.BLACK, -- doesn't actually get used
}

local mult_colors_to_use = {
	[COLOR_TYPES.FUEL] = COLORS_MULT.RED,
	[COLOR_TYPES.MATCH] = COLORS_MULT.GREEN,
	[COLOR_TYPES.UNKNOWN] = COLORS_MULT.GRAY,
	[COLOR_TYPES.ERROR] = COLORS_MULT.BLACK,
}

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
local function push(name)
	return TheSim:ProfilerPush("Insight:"..name)
end

local function pop()
	return TheSim:ProfilerPop()
end

local changed = {}

local activated = false
local activeIngredientFocus = nil
local activeItem = nil
local isSearchingForFoodTag = false

local use_shallow_copy = false

OnContextUpdate:AddListener("highlighting", function(context)
	-- Experimental being true would mean DON'T use shallow copy.
	use_shallow_copy = not context.config["experimental_highlighting"]
	highlighting.UpdateSettings(context)
end)


--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
--- Returns prefab name from texture (used for UIs)
-- @tparam string tex
-- @treturn ?string|nil
local function GetPrefabFromTexture(tex)
	if texturePrefabCache[tex] then
		return texturePrefabCache[tex]
	end

	local prefab = string.match(tex, '[^/]+$'):gsub('%.tex$', '')

	if prefab then
		if world_type == 3 then
			for normal, icon in pairs(PORK_ICONS) do
				if icon == prefab then
					texturePrefabCache[tex] = normal
					return normal
				end
			end
		end

		if world_type == 3 or world_type == 2 then -- both Sw  and hamlet have SW_ICONS
			for normal, icon in pairs(SW_ICONS) do
				if icon == prefab then
					texturePrefabCache[tex] = normal
					return normal
				end
			end
		end

		return prefab
	end
end

local function RemoveHighlight(inst)
	if inst[highlightColorKey] then
		if IsWidget(inst) then -- ItemTile
			inst.image:SetTint(1, 1, 1, 1)
			--inst:GetParent():DeHighlight()
			RemoveHighlight(inst.item) -- show the love further down too because why not
		elseif IsPrefab(inst) then
			local previous = inst[highlightColorKey]
			
			if previous[5] then
				if inst.AnimState.OverrideMultColour then
					inst.AnimState:OverrideMultColour(previous[1], previous[2], previous[3], previous[4])
				else
					inst.AnimState:SetMultColour(previous[1], previous[2], previous[3], previous[4])
				end
			else
				inst.AnimState:SetLightOverride(0)
				inst.AnimState:SetAddColour(previous[1], previous[2], previous[3], previous[4])
			end
		else
			-- See comment about IsWidget in EvaluateRelevance.
			--mprint("prefab:", type(inst), type(inst)=="table" and inst.GUID, type(inst)=="table" and inst.prefab)
			--mprint("widget:", inst, inst.inst, inst.inst and inst.inst.widget)
			--error('big problem highlight')
		end
		inst[highlightColorKey] = nil
		changed[inst] = nil
	end
end

local function ApplyHighlight(inst, color_key)
	if changed[inst] then
		-- Previously, I said: "No need to remove old highlight if we're applying a new one on top, just keep the cached highlight info for reverting."
		-- However: That logic falls when use_mult differs for any reason.. say, if we're using UNKNOWN or ERROR.
		RemoveHighlight(inst)
	end

	if IsWidget(inst) then -- ItemTile
		local color = mult_colors_to_use[color_key] or mult_colors_to_use.ERROR
		inst[highlightColorKey] = inst[highlightColorKey] or highlightColorKey -- Tint is just set back to 1,1,1,1
		inst.image:SetTint(color[1], color[2], color[3], color[4])

		--inst:GetParent():Highlight()
		changed[inst] = true

		ApplyHighlight(inst.item, color) -- show the love further down too because why not

	elseif IsPrefab(inst) then
		-- apparently, AnimState doesn't exist for everything. I should have forseen that.
		if inst.AnimState then
			local use_mult = is_client_host or color_key == COLOR_TYPES.ERROR or color_key == COLOR_TYPES.UNKNOWN

			local color_table = (use_mult and mult_colors_to_use) or add_colors_to_use
			local color = color_table[color_key] or color_table.ERROR
			
			if use_mult then
				inst[highlightColorKey] = inst[highlightColorKey] or {inst.AnimState:GetMultColour()}
				inst[highlightColorKey][5] = use_mult -- This is used for determining how to revert the highlighting.

				if inst.AnimState.OverrideMultColour then
					inst.AnimState:OverrideMultColour(color[1], color[2], color[3], color[4])
				else
					inst.AnimState:SetMultColour(color[1], color[2], color[3], color[4])
				end
			else
				inst[highlightColorKey] = inst[highlightColorKey] or {inst.AnimState:GetAddColour()}
				inst[highlightColorKey][5] = use_mult
				inst.AnimState:SetLightOverride(.4)
				inst.AnimState:SetAddColour(color[1], color[2], color[3], color[4])
			end
			changed[inst] = true
		end
	else
		-- Because we don't do RemoveHighlight anymore, we need to clear the cache here instead for invalid widgets.
		inst[highlightColorKey] = nil
		changed[inst] = nil
	end
end

local function Comparator(held, inst)
	if not localPlayer then return end
	local insight = (IS_DST and localPlayer.replica.insight) or localPlayer.components.insight
	if not insight then return end
	-- returned color applies to inst

	local held_prefab = held.prefab or held
	local held_name = (held.components and held.components.named) or (held.replica and held.replica.named)
	held_name = (held_name and held.name) or ""

	local inst_prefab = inst.prefab or inst
	local inst_name = (inst.components and inst.components.named) or (inst.replica and inst.replica.named)
	inst_name = (inst_name and inst.name) or ""

	-- fuel highlighting
	if isSearchingForFoodTag == false and held.prefab and inst.prefab then -- IsPrefab(held) and IsPrefab(inst)
		if fuel_highlighting and insight:DoesFuelMatchFueled(held, inst) then
			return COLOR_TYPES.FUEL
		end
	end

	-- ignore dual bundle highlighting, not interested in doing a full match
	if isSearchingForFoodTag == false and IsBundleWrap(held) and IsBundleWrap(inst) then
		return nil
	end

	if isSearchingForFoodTag == true and cooking.ingredients and cooking.ingredients[inst_prefab] and cooking.ingredients[inst_prefab].tags then
		if cooking.ingredients[inst_prefab].tags[held] then
			return COLOR_TYPES.MATCH
		end
	end

	-- same prefabs easy peasy
	if isSearchingForFoodTag == false and held_prefab == inst_prefab then
		if held_name == inst_name then
			return COLOR_TYPES.MATCH
		end
	end
	
	if IsBundleWrap(held) then -- holding a bundle of berries
		local matchy = insight:BundleHasPrefab(held, inst_prefab, isSearchingForFoodTag)
		if matchy == nil then
			-- my bundle hasn't loaded for some reason

			return nil -- COLOR_TYPES.UNKNOWN wouldn't make sense, since it would grey out the inst which could be anything
		elseif matchy == false then
			-- compared item is not berries
			return nil
		elseif matchy == true then
			-- compared item is berries
			return COLOR_TYPES.MATCH
		end

	elseif IsBundleWrap(inst) then -- holding berries and searching bundles for some
		local matchy = insight:BundleHasPrefab(inst, held_prefab, isSearchingForFoodTag)

		if matchy == nil then
			-- bundle hasn't loaded for some reason
			return COLOR_TYPES.UNKNOWN -- makes sense to grey out here, since its only bundles
		elseif matchy == false then
			-- compared item is not berries
			return nil
		elseif matchy == true then
			-- compared item is berries
			return COLOR_TYPES.MATCH
		end
	end

	return nil
end

local function GetContainerRelevance(container_inst)
	local insight = (IS_DST and localPlayer.replica.insight) or localPlayer.components.insight
	if not insight then 
		return 
	end
	--mprint(ctr, ctr.classified, ctr.inst, activeItem, activeItem and ctr:Has(activeItem.prefab, 1))

	--[[
	if activeIngredientFocus and ContainerHas(ctr, activeIngredientFocus) then
		return true

	elseif activeItem and ContainerHas(ctr, activeItem.prefab) then
		return true
	end
	--]]
	
	if activeIngredientFocus then
		--push("GCR.activeIngredientFocus")
		local res = insight:ContainerHas(container_inst, activeIngredientFocus, isSearchingForFoodTag)
		--pop()

		if res == nil then
			return 1 -- unknown
		elseif res == true then
			return 2 -- has
		end
		
	elseif activeItem then
		--push("GCR.activeItem")
		--dprint(ctr.inst, "searching for:", activeItem)
		local res = insight:ContainerHas(container_inst, activeItem, isSearchingForFoodTag)
		--dprint("resx:", res)
		--pop()

		if res == nil then
			return 1 -- unknown
		elseif res == true then
			return 2 -- has
		end
	end

	return 0
end

local function EvaluateRelevance(inst, isApplication)
	if not localPlayer then
		return
	end

	if not highlighting_enabled then
	return
	end

	--push("EvaluateRelevance")
	if isApplication == nil then
		error("[Insight Error]: isApplication nil")
	end

	local prefab, widget = IsPrefab(inst), IsWidget(inst)
	if not prefab and not widget then
		--pop()
		if type(inst) ~= 'string' then
			-- IsWidget can fail for ItemTiles if the ItemTile is removed during a deferred update,
			-- because Widget:Kill() removes inst.widget, which is checked for.

			--[[
			mprint(string.rep("-", 100))
			mprint(inst, inst.inst:IsValid())
			dumptable(inst)
			mprint("prefab:", type(inst), type(inst)=="table" and inst.GUID, type(inst)=="table" and inst.prefab)
			mprint("widget:", inst.inst, "|", inst.inst and inst.inst.widget, "|")
			error("how is this not a prefab or widget")
			--]]
		end

		return
	end

	local container
	if prefab then
		container = (IS_DST and inst.replica.container) or inst.components.container

		if not container and IS_DST then
			-- Check to see if we have container data still for what is probably a container_proxy
			local insight = (IS_DST and localPlayer.replica.insight) or localPlayer.components.insight
			local ent_data = insight.entity_data[inst]
			-- container_proxy echos the Describe from container and maintains the name
			if ent_data and ent_data.GUID ~= nil and ent_data.special_data.container then
				-- So if we have "container" data, that means we're good to go.
				container = inst
			end
		else
			-- We can assume that we successfuly passed or didn't, but either way we need to resolve to an inst here if possible.
			if container then
				container = container.inst
			end
		end
	end

	

	if prefab and container then
		local relevance = GetContainerRelevance(container)

		if isApplication and relevance > 0 then
			ApplyHighlight(inst, (relevance == 2 and COLOR_TYPES.MATCH) or (relevance == 1 and COLOR_TYPES.UNKNOWN) or COLOR_TYPES.ERROR) 
		else
			RemoveHighlight(inst)
		end
		--print("evaluating container", inst, os.clock() - a)
	elseif isApplication and (activeItem or activeIngredientFocus) then
		--local a = os.clock()
		local item = (widget and inst.item) or inst -- If widget, inst is ItemTile

		local color
		
		if activeIngredientFocus then
			color = Comparator(activeIngredientFocus, item)
		else
			color = Comparator(activeItem, item)
		end

		if color then
			ApplyHighlight(inst, color)
		else
			RemoveHighlight(inst)
		end
		--print("evaluating otherwise", inst, os.clock() - a)
	else
		RemoveHighlight(inst)
	end

	--pop()
end

-- See crafting_sorting.lua for rough concept
local function relevance_iterator_ctor(tbl)
	local index = 0
	return coroutine.wrap(function()
		for ent in pairs(tbl) do
			index = index + 1
			coroutine.yield(index, ent)
		end
		coroutine.yield(-1, index) -- Indicates that we are done.
	end)
end

local function DoRelevanceChecks(force_apply)
	--mprint("DoRelevanceChecks ---------------------------------------------------------------------------------------------------------------")
	if not highlighting_enabled then
		return
	end
	--push("DoRelevanceChecks")

	local a = os.clock()
	--print('relevance_check_start')

	if highlighting.relevance_state then
		highlighting:ClearRelevanceState()
	end

	local apply = ((activeItem or activeIngredientFocus) and true) or false
	if force_apply ~= nil then
		apply = force_apply
	end

	-- There are significantly less item slots than ents, so I just process them here normally. 
	local slots = GetItemSlots()
	for i = 1, #slots do
		local slot = slots[i]
		if slot.tile then
			EvaluateRelevance(slot.tile, apply)
		end
	end

	-- On the other hand, there's a lot of ents so we'll set up a relevance state for iteration in OnUpdate.
	if apply then
		highlighting:SetupRelevanceState(entityManager.active_entities, apply)
	else
		-- This is faster to clean up highlighting, since we know what is highlighted.
		highlighting:SetupRelevanceState(changed, apply)
	end

	--highlighting.OnUpdate(0)
	--pop()
end

local function OnUpdate(dt)
	local state = highlighting.relevance_state
	if not state then return end

	local iter = state.iterator

	local max = highlighting.process_per_update

	--print("OnUpdate", dt)
	--push("RelevanceIter")
	for i, ent in iter do
		if i == -1 then
			highlighting:ClearRelevanceState()
			--print("\tDone iterating at", ent)
			break
		end

		EvaluateRelevance(ent, state.selected)

		if i % max == 0 then
			--print("\tDeferring at", i)
			break
		end
	end
	--pop()
end

function highlighting:ClearRelevanceState()
	self.relevance_state = nil
end

function highlighting:SetupRelevanceState(tbl, selected)
	if self.relevance_state then
		error("Cannot setup multiple relevance states")
	end

	if not highlighting.activated then
		-- We need to do this *now* as it's probably a cleanup and OnUpdate will no longer trigger.
		for v in pairs(tbl) do
			EvaluateRelevance(v, apply)
		end
		return
	end

	--[[
		dorelevance - 394us
			setuprelevance - 344us
				shallowcopy - 343us
	]]
	--push("SetupRelevanceState")
	--push("ShallowCopy")
	local frozen = (use_shallow_copy and shallowcopy(tbl)) or tbl
	--pop()

	self.relevance_state = {
		frozen = frozen,
		iterator = relevance_iterator_ctor(frozen),
		selected = selected
	}
	--pop()
end

function highlighting.SetActiveItem(player, data)
	if not highlighting.activated then
		return
	end

	--push("SetActiveItem")
	isSearchingForFoodTag = false
	activeIngredientFocus = nil -- Clear any active ingredient focuses.
	activeItem = data.item

	DoRelevanceChecks()
	--pop()
end

-- this is buggy
function highlighting.find(prefab)
	return highlighting.SetActiveIngredientUI({prefab=prefab})
end

function highlighting.SetActiveIngredientUI(ui)
	if not highlighting.activated then
		return
	end

	if activeIngredientFocus == ui then
		return
	end

	activeItem = nil -- Clear any active items.

	isSearchingForFoodTag = false

	if ui == nil then
		activeIngredientFocus = nil
		DoRelevanceChecks()
	elseif IsWidget(ui) then
		local prefab = ui.ing and ui.ing.texture and GetPrefabFromTexture(string.match(ui.ing.texture, '[^/]+$'):gsub('%.tex$', ''))
		if prefab then
			activeIngredientFocus = prefab
			DoRelevanceChecks()
		end
	elseif type(ui) == "table" then
		if ui.prefab then
			activeIngredientFocus = ui.prefab
		elseif ui.ingredient_tag then
			activeIngredientFocus = ui.ingredient_tag
			isSearchingForFoodTag = true
		end
		DoRelevanceChecks()
	end
end

function highlighting.SetEntitySleep(inst)
	if not highlighting.activated then
		return
	end

	if highlighting.relevance_state and use_shallow_copy then
		highlighting.relevance_state[inst] = nil
	end
	
	if IS_CLIENT then
		-- Is this what's causing the stale component reference?
		--RemoveHighlight(inst)
		-- Nope, something else is.
	end
end

function highlighting.SetEntityAwake(inst)
	if not highlighting.activated then
		return
	end

	--push("SetEntityAwake")
	if inst.entity:HasTag("INLIMBO") then -- most likely an inventory item
		--mprint("@ LIMBO", inst)
		--push("GetItemSlots")
		for _, slot in pairs(GetItemSlots()) do
			if slot.tile and slot.tile.item == inst then
				EvaluateRelevance(slot.tile, true)
				break
			end
		end
		--pop()
	else
		--mprint("set awake", inst)
		EvaluateRelevance(inst, true)
	end
	--pop()
end

highlighting.SetMatchColor = function(key)
	add_colors_to_use[COLOR_TYPES.MATCH] = COLORS_ADD[key]
	mult_colors_to_use[COLOR_TYPES.MATCH] = COLORS_MULT[key]
end

highlighting.SetFuelMatchColor = function(key)
	add_colors_to_use[COLOR_TYPES.FUEL] = COLORS_ADD[key]
	mult_colors_to_use[COLOR_TYPES.FUEL] = COLORS_MULT[key]
end

highlighting.UpdateSettings = function(context)
	fuel_highlighting = context.config["fuel_highlighting"]
	highlighting_enabled = context.config["highlighting"]

	highlighting.SetMatchColor(context.config["highlighting_color"])
	highlighting.SetFuelMatchColor(context.config["fuel_highlighting_color"])
end

highlighting.Activate = function(insight, context)
	if highlighting.activated then
		return
	end

	dprint("Highlighting activated")
	highlighting.UpdateSettings(context)
	highlighting.activated = true
end

highlighting.Deactivate = function()
	if not highlighting.activated then
		return
	end

	dprint("Highlighting deactivated")
	highlighting.activated = false
	DoRelevanceChecks(false)
end

highlighting.OnUpdate = OnUpdate

return highlighting
