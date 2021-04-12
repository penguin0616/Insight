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

local highlightColorKey = "__insight:MultColor"
local fuel_highlighting = nil
local highlighting_enabled = nil
local activated = false
local Is_DST = IsDST()
local world_type = GetWorldType()

local texturePrefabCache = {}

local colors = {
	fuel = {1, 0, 0, 0.3}, -- red
	match = {0, 1, 0, 0.3}, -- green
	unknown = {1, 1, 1, 0.3}, -- gray
	error = {0.0, 0.0, 0.0, 0.3}
}

local activeIngredientFocus = nil
local activeItem = nil
local isSearchingForFoodTag = false

local highlighting = {}

local managed = setmetatable({}, { __mode="k" })

--[[
local base = Color.new(1, 1, 1, 1)
local target = Color.new(1, 0, 0, 1)

local stats = {}

AddLocalPlayerPostInit(function()
TheGlobalInstance:DoPeriodicTask(1 / 15, function()
	for inst, changeable in pairs(managed) do
		stats[inst] = stats[inst] or {0, false}

		local info = GetInsight(localPlayer):GetInformation(inst)
		if info and info.special_data.diseaseable then
			local time_left = info.special_data.diseaseable.disease_in
			mprint(info, time_left, changeable)
			if time_left == -1 then
				if changeable == true then
					managed[inst] = false
					RemoveHighlight(inst)
				end
			elseif time_left <= 9e9 or TUNING.TOTAL_DAY_TIME * 3 then
				if changeable == false then
					managed[inst] = true
				end
				
				stats[inst][1] = stats[inst][1] + (stats[inst][2] and 1 or -1) * 0.05
				if stats[inst][1] >= 1 then
					stats[inst][1] = 1
					stats[inst][2] = false
				elseif stats[inst][1] <= 0 then
					stats[inst][1] = 0
					stats[inst][2] = true
				end

				local clr
				if stats[inst][2] then
					-- up
					clr = base:Lerp(target, stats[inst][1])
				else
					-- down
					clr = base:Lerp(target, stats[inst][1])
				end

				ApplyHighlight(inst, clr)
			end
		end
	end
end)
end)
--]]

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
			RemoveHighlight(inst.item) -- show the love further down too because why not
		elseif IsPrefab(inst) then
			inst.AnimState:SetAddColour(unpack(inst[highlightColorKey]))
		else
			error('big problem highlight')
		end
		inst[highlightColorKey] = nil
	end
end

local function ApplyHighlight(inst, color)
	RemoveHighlight(inst) -- preemptive strike

	if IsWidget(inst) then -- ItemTile
		inst[highlightColorKey] = "#compatability?"
		inst.image:SetTint(unpack(color))

		ApplyHighlight(inst.item, color) -- show the love further down too because why not

	elseif IsPrefab(inst) then
		-- apparently, AnimState doesn't exist for everything. I should have forseen that.
		if inst.AnimState then
			inst[highlightColorKey] = {inst.AnimState:GetAddColour()}
			inst.AnimState:SetAddColour(unpack(color))
		end
	end
end

local function GetItemSlots()
	if not localPlayer then return {} end

	-- performance-ing
	local slots = {}
	local len_slots = 0

	
	if not localPlayer.HUD then
		mprint("Missing localPlayer HUD in highlight...?", localPlayer:IsValid())
		return slots
	end
	

	local inventoryBar = localPlayer.HUD.controls.inv

	-- main inventory
	for i = 1, #inventoryBar.inv do
		local v = inventoryBar.inv[i]
		if v then
			len_slots = len_slots + 1
			slots[len_slots] = v
		end
	end

	-- equipped items
	for equipname, slot in pairs(inventoryBar.equip) do
		if slot then
			len_slots = len_slots + 1
			slots[len_slots] = slot
		end
	end

	-- open containers
	--k, v = next(self.controls.containers) return v -- PlayerHud:GetFirstOpenContainerWidget
	for _, c in pairs(localPlayer.HUD.controls.containers) do
		if c and c.inv then
			for i = 1, #c.inv do
				local v = c.inv[i]
				if v then
					len_slots = len_slots + 1
					slots[len_slots] = v
				end
			end
		end
	end

	-- backpack inventory
	local backpackInventory = inventoryBar.backpackinv -- DST: Profile:GetIntegratedBackpack() -> true/false : is a thing

	for i = 1, #backpackInventory do
		local v = backpackInventory[i]
		if v then
			len_slots = len_slots + 1
			slots[len_slots] = v
		end
	end

	return slots
end

local function Comparator(held, inst)
	if not localPlayer then return end
	local insight = (Is_DST and localPlayer.replica.insight) or localPlayer.components.insight
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
			return colors.fuel
		end
	end

	-- ignore dual bundle highlighting, not interested in doing a full match
	if isSearchingForFoodTag == false and IsBundleWrap(held) and IsBundleWrap(inst) then
		return nil
	end

	if isSearchingForFoodTag == true and cooking.ingredients and cooking.ingredients[inst_prefab] and cooking.ingredients[inst_prefab].tags then
		if cooking.ingredients[inst_prefab].tags[held] then
			return colors.match
		end
	end

	-- same prefabs easy peasy
	if isSearchingForFoodTag == false and held_prefab == inst_prefab then
		if held_name == inst_name then
			return colors.match
		end
	end
	
	if IsBundleWrap(held) then -- holding a bundle of berries
		local matchy = insight:BundleHasPrefab(held, inst_prefab, isSearchingForFoodTag)
		if matchy == nil then
			-- my bundle hasn't loaded for some reason

			return nil -- colors.unknown wouldn't make sense, since it would grey out the inst which could be anything
		elseif matchy == false then
			-- compared item is not berries
			return nil
		elseif matchy == true then
			-- compared item is berries
			return colors.match
		end

	elseif IsBundleWrap(inst) then -- holding berries and searching bundles for some
		local matchy = insight:BundleHasPrefab(inst, held_prefab, isSearchingForFoodTag)

		if matchy == nil then
			-- bundle hasn't loaded for some reason
			return colors.unknown -- makes sense to grey out here, since its only bundles
		elseif matchy == false then
			-- compared item is not berries
			return nil
		elseif matchy == true then
			-- compared item is berries
			return colors.match
		end
	end

	return nil
end

local function GetContainerRelevance(ctr)
	local insight = (Is_DST and localPlayer.replica.insight) or localPlayer.components.insight
	--mprint(ctr, ctr.classified, ctr.inst, activeItem, activeItem and ctr:Has(activeItem.prefab, 1))

	--[[
	if activeIngredientFocus and ContainerHas(ctr, activeIngredientFocus) then
		return true

	elseif activeItem and ContainerHas(ctr, activeItem.prefab) then
		return true
	end
	--]]
	
	if activeIngredientFocus then
		local res = insight:ContainerHas(ctr.inst, activeIngredientFocus, isSearchingForFoodTag)
		
		if res == nil then
			return 1
		elseif res == true then
			return 2
		end

		
	elseif activeItem then
		local res = insight:ContainerHas(ctr.inst, activeItem, isSearchingForFoodTag)
		--dprint("activeItem_check", activeItem, res)
		
		if res == nil then
			return 1
		elseif res == true then
			return 2
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

	assert(isApplication ~= nil, "[Insight Error]: isApplication nil")

	local prefab, widget = IsPrefab(inst), IsWidget(inst)
	if not prefab and not widget and not type(inst) == 'string' then
		return
	end

	local container = prefab and ((Is_DST and inst.replica.container) or inst.components.container)

	if prefab and container then
		local relevance = GetContainerRelevance(container)

		if isApplication and relevance > 0 then
			ApplyHighlight(inst, (relevance == 2 and colors.match) or (relevance == 1 and colors.unknown) or colors.error) 
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
end

local function DoRelevanceChecks(force_apply)
	local a = os.clock()
	--print('relevance_check_start')

	local apply = ((activeItem or activeIngredientFocus) and true) or false
	if force_apply ~= nil then
		apply = force_apply
	end

	if not highlighting_enabled then
		return
	end

	for v in pairs(entityManager.active_entities) do -- ISSUE:PERFORMANCE
		EvaluateRelevance(v, apply)
	end

	local b = os.clock()
	

	-- {index, ItemSlot}
	-- ItemSlot.tile.item
	-- ItemSlot always there
	-- tile and tile.item exist at same time
	local slots = GetItemSlots()
	for i = 1, #slots do
		local slot = slots[i]
		if slot.tile then
			EvaluateRelevance(slot.tile, apply)
		end
	end

	local c = os.clock()

	--dprint('active_entities:', b - a)
	--dprint('item slots:', c - b)
	--dprint('total:', c - a)
	--dprint'--------------------------------'
end

function highlighting.SetActiveItem(player, data)
	if not activated then
		return
	end

	isSearchingForFoodTag = false
	activeItem = data.item

	DoRelevanceChecks()
end

function highlighting.SetActiveIngredientUI(ui)
	if not activated then
		return
	end

	if activeIngredientFocus == ui then
		return
	end

	isSearchingForFoodTag = false

	if IsWidget(ui) then
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
	elseif ui == nil then
		activeIngredientFocus = nil
		DoRelevanceChecks()
	end
end

function highlighting.SetEntitySleep(inst)
	if not activated then
		return
	end
	
	RemoveHighlight(inst)
end

function highlighting.SetEntityAwake(inst)
	if not activated then
		return
	end

	if inst:HasTag("INLIMBO") then -- most likely an inventory item
		--mprint("@ LIMBO", inst)
		for _, slot in pairs(GetItemSlots()) do
			if slot.tile and slot.tile.item == inst then
				EvaluateRelevance(slot.tile, true)
				break
			end
		end
	else
		--mprint("set awake", inst)
		EvaluateRelevance(inst, true)
	end
end

highlighting.Activate = function(insight, context)
	dprint("Highlighting activated")
	fuel_highlighting = context.config["fuel_highlighting"]
	highlighting_enabled = context.config["highlighting"]
	activated = true
end

highlighting.Deactivate = function()
	dprint("Highlighting deactivated")
	activated = false
	DoRelevanceChecks(false)
end

return highlighting
