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

-- Responsible for attack ranges
--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim

local my_context = {config = {["attack_range_type"] = "hit"}}

local NET_STATES = { -- 0-7
	NOTHING = 0,
	TARGETTING = 1,
	ATTACK_BEGIN = 2,
	ATTACK_END = 3
}

local HAS_AUTHORITY = TheSim:GetGameID() == "DS" or TheNet:GetIsMasterSimulation() == true

local combat = HAS_AUTHORITY and require("components/combat")
--[[
local oldSetTarget = combat and combat.SetTarget
--local oldTryRetarget = combat and combat.TryRetarget
--local oldCanHitTarget = combat and combat.CanHitTarget
local oldCanAttack = combat and combat.CanAttack
--local oldStartAttack = combat and combat.StartAttack
local oldDoAttack = combat and combat.DoAttack
local oldTryAttack = combat and combat.TryAttack
--local oldDropTarget = combat and combat.DropTarget
local oldGiveUp = combat and combat.GiveUp
local oldSetRange = combat and combat.SetRange
local oldSetAreaDamage = combat and combat.SetAreaDamage
--]]

--[[
local inventory = HAS_AUTHORITY and require("components/inventory")
local oldEquip = inventory and inventory.Equip
local oldUnequip = inventory and inventory.Unequip
--]]

--------------------------------------------------------------------------
--[[ Insight Combat ]]
--------------------------------------------------------------------------
local InsightCombat = Class(function(self, inst, data)
	self.inst = inst
	self.attack_range = 3
    self.hit_range = 3

	self.damage = data.damage

	if data.attack_range then
		self:SetRange(data.attack_range, data.hit_range)
	end
end)

function InsightCombat:SetRange(attack, hit)
    self.attack_range = attack
    self.hit_range = hit or self.attack_range
end

function InsightCombat:GetAttackRange()
	return self.attack_range
end

function InsightCombat:GetHitRange()
    return self.hit_range
end

function InsightCombat:GetDamage(target)
	return self.damage ~= nil and FunctionOrValue(self.damage, self.inst, target) or 0
end

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local function AccountForPhysics(inst)
	if not localPlayer then
		return 0
	end

	if inst:GetIncludePhysicsRadius() then
		return localPlayer:GetPhysicsRadius(0)
	end

	return 0
end

local function CanUseRangeType(type)
	if my_context.config["attack_range_type"] == "both" then
		return true
	end

	return my_context.config["attack_range_type"] == type
end

local function AdjustIndicator(inst, colour, visible, radius)
	if colour then
		inst:SetColour(colour)
	end

	if visible ~= nil then
		inst:SetVisible(visible)
	end

	if radius then
		inst:SetRadius(radius / WALL_STUDS_PER_TILE)
	end
end

local function AdjustIndicatorState(inst, state)
	--mprint("adjust indicator state", inst, table.invert(NET_STATES)[state])
	if not inst.insight_combat_range_indicator then
		--mprint("\tmissing indicator")
		return
	end

	inst.insight_combat_range_indicator:SetState(state)
end

local function PushNewIndicatorRange(inst)
	if inst.insight_combat_range_indicator then
		--mprint("pushed indicator range", combat.inst, combat:GetAttackRange(), combat:GetHitRange())
		--local offset = self.inst.Physics:GetRadius() - 0

		-- account for the first half of the hit range here
		--local offset = self.inst:GetPhysicsRadius(0)
		--mprint(self.inst, self.attackrange, self.hitrange, offset)

		local combat = inst.insight_combat or inst.components.combat
		inst.insight_combat_range_indicator:SetAttackRange(combat:GetAttackRange())
		inst.insight_combat_range_indicator:SetHitRange(combat:GetHitRange())
	end
end

-- this gets called very repeatedly by players when moving
local function SetTarget(self, target, ...)
	--mprint('settarget', self.inst, target)
	if target == nil then
		--AdjustIndicator(self.inst, nil, false) -- "#00dd00"
		AdjustIndicatorState(self.inst, NET_STATES.NOTHING)
		
	elseif target.components.health and target.components.health.currenthealth > 0 and target:HasTag("player") and not target:HasTag("playerghost") then
		--AdjustIndicator(self.inst, Color.fromHex("#e8ca89"), true)
		AdjustIndicatorState(self.inst, NET_STATES.TARGETTING)
	end

	return self._insightOldSetTarget(self, target, ...)
end

--[[
local function TryRetarget(self, ...)
	return self._insightOldTryRetarget(self, ...)
end
--]]

-- alternate to DoAttack
--[[
local function CanHitTarget(self, target, weapon, ...)
	mprint('canhittarget', self.inst, target, weapon)
	-- is it more practical to store the result of the call and return that, or to call myself?
	
	self.inst.combat_range_indicator:SetColour(Color.fromHex("#00FFFF")) -- cyan


	return self._insightOldCanHitTarget(self, target, weapon, ...)
end
--]]


--[[
	attack begins

	called by tryattack, gets called if missing the attack state.
	i can either hook this, "doattack" event, or listen for state change and check tags.

	i'll use CanAttack for now, but i'll need to consider how to deal with mods that use CanAttack for other reasons.
		if such a situation occurs, probably best to just listen for doattack event. doesn't get pushed anywhere else in game, and less likely to get triggered by mods.
]]
local function CanAttack(self, target, ...)
	--mprint('canattack', self.inst, target)

	-- is it more practical to store the result of the call and return that, or to call twice?
	-- i'll go with former, since a case where the order of the returned arguments matters exists. and if it does, still would be screwed.
	-- plus, less function calls.
	local res = pack(self._insightOldCanAttack(self, target, ...))

	if res[1] and target:HasTag("player") then
		--mprint('\tsafe attack')
		--AdjustIndicator(self.inst, Color.fromHex("#ff0000"), true)
		AdjustIndicatorState(self.inst, NET_STATES.ATTACK_BEGIN)
	end

	return vararg(res)
end


-- not used consistently
--[[
local function StartAttack(self, ...)
	

	return self._insightOldStartAttack(self, ...)
end
--]]

-- Attack animation has reached point where damage is attempted to be dealt. Stays red until TryAttack is called.
local function DoAttack(self, target, ...)
	--mprint('doattack', self.inst, target)
	--AdjustIndicator(self.inst, Color.fromHex("#b0593a"), true)
	AdjustIndicatorState(self.inst, NET_STATES.ATTACK_END)

	return self._insightOldDoAttack(self, target, ...)
end


--[[
	Method Call (target)
		if sg has attack, return true
		if self:CanAttack(target), push "doattack" w/ "target" and return true
		return false
]]

-- this gets called rapidly; very rapidly and repeatedly when target is moving
local function TryAttack(self, target, ...)
	--mprint('tryattack', self.inst, target)
	--AdjustIndicator(self.inst, Color.fromHex(Insight.COLORS.VEGGIE), true)

	return self._insightOldTryAttack(self, target, ...)
end

--[[
local function DropTarget(self, ...)
	self.inst.combat_range_indicator:SetColour(Color.fromHex("#ffffff"))
	self.inst.combat_range_indicator:SetVisible(true)
	return oldDropTarget(self, ...)
end
--]]

local function GiveUp(self, ...)
	--mprint('giveup', self.inst)
	--AdjustIndicator(self.inst, Color.fromHex("#ffffff"), false)
	AdjustIndicatorState(self.inst, NET_STATES.NOTHING)

	return self._insightOldGiveUp(self, ...)
end


--[[
	x = c_findnext'spider'
	y = ThePlayer:GetPhysicsRadius(0) + 3
	physics radius is 0.5, hit range is 3.
	real hit range is thus 3.5
	-----------------
	
	a = c_findnext'dragonfly' or c_findnext'bearger' or c_findnext'deerclops' or c_findnext'spider'
	b = ThePlayer:GetPhysicsRadius(0) + a.components.combat:GetHitRange()

	x,y,z=a.Transform:GetWorldPosition();ThePlayer.Physics:Teleport(x+b, y, z)
	mprint(distsq(ThePlayer:GetPosition(), a:GetPosition()), b*b, distsq(ThePlayer:GetPosition(), a:GetPosition())<=b*b)
]]
local function SetRange(self, attack, hit, ...)
	--mprint("setrange", attack, hit, ...)
	self._insightOldSetRange(self, attack, hit, ...)
	PushNewIndicatorRange(self.inst)
end

--[[
	cases where aoe range > attack range?
		i'll just cross that bridge when it comes to that
]]
local function SetAreaDamage(self, range, percent, areahitcheck, ...)
	self._insightOldSetAreaDamage(self, range, percent, areahitcheck, ...)

	if self.inst.insight_combat_range_indicator then
		--self.inst.insight_combat_range_indicator:SetHitRange(self.areahitrange or (self.hitrange + self.inst:GetPhysicsRadius(0)))
	end
end

local function OnEquip(inst, data)
	-- data = { item = item, eslot = eslot }
	--mprint("equip", inst, data.item)
	if inst.components.combat then
		PushNewIndicatorRange(inst)
	end
end

local function OnUnequip(inst, data)
	-- data = {item=item, eslot=equipslot, slip=slip}
	--mprint("unequip", inst, data.item)
	if inst.components.combat then
		PushNewIndicatorRange(inst)
	end
end

local function HookCombat(self)
	if not HAS_AUTHORITY then
		return
	end

	if self.inst:HasTag("player") or self.inst:HasTag("wall") then
		--[[
		self.SetTarget = oldSetTarget or self.SetTarget
		self.TryRetarget = oldTryRetarget or self.TryRetarget
		self.CanHitTarget = oldCanHitTarget or self.CanHitTarget
		self.CanAttack = oldCanAttack or self.CanAttack
		self.StartAttack = oldStartAttack or self.StartAttack
		self.DoAttack = oldDoAttack or self.DoAttack
		self.TryAttack = oldTryAttack or self.TryAttack
		self.DropTarget = oldDropTarget or self.DropTarget
		self.GiveUp = oldGiveUp or self.GiveUp
		self.SetRange = oldSetRange or self.SetRange
		self.SetAreaDamage = oldSetAreaDamage or self.SetAreaDamage
		--]]
		return
	end

	--mprint("hooked combat for:", self.inst, self.inst.prefab)
	--self.inst:DoTaskInTime(0, function() mprint(self.inst, self.inst.prefab) end)

	self._insightOldSetTarget = self.SetTarget
	--self._insightOldTryRetarget = self.TryRetarget
	--self._insightOldCanHitTarget = self.CanHitTarget
	self._insightOldCanAttack = self.CanAttack
	--self._insightOldStartAttack = self.StartAttack
	self._insightOldDoAttack = self.DoAttack
	self._insightOldTryAttack = self.TryAttack
	--self._insightOldDropTarget = self.DropTarget
	self._insightOldGiveUp = self.GiveUp
	self._insightOldSetRange = self.SetRange
	self._insightOldSetAreaDamage = self.SetAreaDamage

	self.SetTarget = SetTarget
	--self.TryRetarget = TryRetarget
	--self.CanHitTarget = CanHitTarget
	self.CanAttack = CanAttack
	--self.StartAttack = StartAttack
	self.DoAttack = DoAttack
	self.TryAttack = TryAttack
	--self.DropTarget = DropTarget
	self.GiveUp = GiveUp
	self.SetRange = SetRange
	self.SetAreaDamage = SetAreaDamage

	-- inventory can be added after the component does, so no use checking if it exists.
	--mprint("equipped:", self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS))
	self.inst:ListenForEvent("equip", OnEquip)
	self.inst:ListenForEvent("unequip", OnUnequip)
	
	-- meh
	local indicator = SpawnPrefab("insight_combat_range_indicator")
	if not indicator then
		mprint("wtf", Prefabs.insight_range_indicator, Prefabs.insight_combat_range_indicator, _G.Prefabs.insight_range_indicator, _G.Prefabs.insight_combat_range_indicator)
		--return
		error("missing insight indicator???")
	end
	indicator.client_ready = false
	indicator:Attach(self.inst)
	self.inst.insight_combat_range_indicator = indicator
	PushNewIndicatorRange(self.inst)
	
	

	--self.inst:DoTaskInTime(1, function() indicator.net_state:set(5) end)
	--indicator:SetVisible(false)
	--indicator:SetRadius(self.attackrange / WALL_STUDS_PER_TILE)

	--self.inst.combat_range_indicator = indicator
end


local function OnIndicatorStateDirty(inst, forced)
	local state = inst:GetState()
	inst.state_forced = forced

	if inst.hide_task then
		inst.hide_task:Cancel()
		inst.hide_task = nil
	end

	if state == NET_STATES.NOTHING then
		--mprint("LOCAL STATE - NOTHING")
		AdjustIndicator(inst, nil, false)
	
	elseif state == NET_STATES.TARGETTING then
		local range

		if my_context.config["attack_range_type"] == "attack" or my_context.config["attack_range_type"] == "both" then
			range = inst:GetAttackRange()
		elseif my_context.config["attack_range_type"] == "hit" then
			range = inst:GetHitRange()
		end

		

		inst.hide_task = (not forced and inst:GetIndicatorCanDecay()) and inst:DoTaskInTime(8, function()
			AdjustIndicator(inst, nil, false)
		end)

		--mprint("LOCAL STATE - TARGETTING")
		AdjustIndicator(inst, Color.fromHex("#60ffff"), true, range + AccountForPhysics(inst))
	else -- attacking
		inst.hide_task = (not forced and inst:GetIndicatorCanDecay()) and inst:DoTaskInTime(8, function()
			AdjustIndicator(inst, nil, false)
		end)
		
		local range 

		-- BEARGER_ATTACK_RANGE = 6
		-- BEARGER_MELEE_RANGE = 6

		--mprint(my_context.config["attack_range_type"])
		
		if my_context.config["attack_range_type"] == "attack" then
			range = inst:GetAttackRange()
		elseif my_context.config["attack_range_type"] == "hit" then
			range = inst:GetHitRange()
		end

		if state == NET_STATES.ATTACK_BEGIN then
			--mprint("LOCAL STATE - ATTACK_BEGIN")
			range = range or inst:GetHitRange()
			--mprint("hit range:", range)

			AdjustIndicator(inst, Color.fromHex("#ff0000"), true, range + AccountForPhysics(inst))
			inst.AnimState:SetAddColour(0.15, 0, 0, 1)

		elseif state == NET_STATES.ATTACK_END then
			--mprint("LOCAL STATE - ATTACK_END")
			range = range or inst:GetAttackRange()
			--mprint("attack range:", range)
			
			AdjustIndicator(inst, Color.fromHex("#60ffff"), true, range + AccountForPhysics(inst)) -- #b0593a
			inst.AnimState:SetAddColour(0, 0, 0, 1)
		end
	end
end

local function OnCanDecayDirty(inst)
	local can_decay = inst:GetIndicatorCanDecay()
	if can_decay == false then
		if inst.hide_task then
			inst.hide_task:Cancel()
			inst.hide_task = nil
		end
	elseif can_decay == true and inst.is_visible and not inst.hide_task then
		inst.hide_task = inst:DoTaskInTime(8, function()
			AdjustIndicator(inst, nil, false)
		end)
	end
end

local function OnAttackRangeDirty(inst)
	local state = inst:GetState()
	local range = inst:GetAttackRange()

	if state == NET_STATES.ATTACK_END and CanUseRangeType("attack") then
		AdjustIndicator(inst, nil, nil, range + AccountForPhysics(inst))
	end
end

local function OnHitRangeDirty(inst)
	local state = inst:GetState()
	local range = inst:GetHitRange()

	if state == NET_STATES.ATTACK_BEGIN and CanUseRangeType("hit") then
		AdjustIndicator(inst, nil, nil, range + AccountForPhysics(inst))
	end
end

local function OnIncludePhysicsRadiusDirty(inst)
	local range = CanUseRangeType("attack") and inst:GetAttackRange() or inst:GetHitRange()
	AdjustIndicator(inst, nil, nil, range + AccountForPhysics(inst))
end

local function ForceStateChange(inst, state)
	inst._state = state -- this was a set_local
	OnIndicatorStateDirty(inst, true)
end

local function TerminateIndicator(inst)
	inst.OnStateDirty = nil
	inst.OnCanDecayDirty = nil
	inst.OnAttackRangeDirty = nil
	inst.OnHitRangeDirty = nil
	inst.OnIncludePhysicsRadiusDirty = nil
	inst.ForceStateChange = nil
	inst.client_ready = nil
end

local function OnIndicatorParentRemoved(inst)
	--mprint('onindicatorparentremoved', inst)
	if not inst.insight_combat_range_indicator then
		return
	end

	TerminateIndicator(inst.insight_combat_range_indicator)

	inst.insight_combat_range_indicator = nil
end

local function OnIndicatorRemoved(inst)
	TerminateIndicator(inst)

	local parent = inst.entity:GetParent()

	if parent then
		parent.insight_combat_range_indicator = nil
	end
end

local function HookClientIndicator(inst, delay)
	inst:DoTaskInTime(delay or 0, function()
		local parent = inst.entity:GetParent()

		if localPlayer == nil or not parent then
			if inst:IsValid() then
				return HookClientIndicator(inst, 0.1)
			end
			return
		end

		if not my_context.config["display_attack_range"] then
			--mprint("Insight attack ranges disabled.")
			return
		end

		inst.client_ready = true
		inst.OnStateDirty = OnIndicatorStateDirty
		inst.OnCanDecayDirty = OnCanDecayDirty
		inst.OnAttackRangeDirty = OnAttackRangeDirty
		inst.OnHitRangeDirty = OnHitRangeDirty
		inst.OnIncludePhysicsRadiusDirty = OnIncludePhysicsRadiusDirty
		inst.ForceStateChange = ForceStateChange

		parent:ListenForEvent("onremove", OnIndicatorParentRemoved)
		-- in hamlet, this gets removed by interiorspawner.lua:1376 (SetPropToInteriorLimbo)
		--mprint("----------------------- indicator removed", inst, inst.entity:GetParent(), ...)
		--print(debugstack())
		inst:ListenForEvent("onremove", OnIndicatorRemoved)
		parent.insight_combat_range_indicator = inst

		local range = (CanUseRangeType("attack") and inst:GetAttackRange()) or inst:GetHitRange()
		AdjustIndicator(inst, nil, nil, range + AccountForPhysics(inst))

		OnIndicatorStateDirty(inst)
	end)
end

local function RegisterFalseCombat(inst, data)
	-- use for instances that don't have combat but still are worth nothing
	local indicator = SpawnPrefab("insight_combat_range_indicator")
	indicator:Attach(inst)
	inst.insight_combat_range_indicator = indicator
	inst.insight_combat = InsightCombat(inst, data)
	inst.insight_combat_range_indicator:SetIndicatorCanDecay(false)
	inst.insight_combat_range_indicator:SetIncludePhysicsRadius(false)
	PushNewIndicatorRange(inst)

	AdjustIndicatorState(inst, NET_STATES.ATTACK_BEGIN)
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

if false and KnownModIndex:IsModEnabled("workshop-2420839895") then
	return {
		enabled = false,
		HookCombat = function() end,
		HookClientIndicator = HookClientIndicator,
		RegisterFalseCombat = RegisterFalseCombat,
		NET_STATES = NET_STATES,

		Activate = function(_, context)
			my_context = context
		end,
		Deactivate = function()
			my_context = nil
		end,
	}
end

--[[
if HAS_AUTHORITY then
	combat.SetTarget = SetTarget
	--combat.TryRetarget = TryRetarget
	--combat.CanHitTarget = CanHitTarget
	combat.CanAttack = CanAttack
	--combat.StartAttack = StartAttack
	combat.DoAttack = DoAttack
	combat.TryAttack = TryAttack
	--combat.DropTarget = DropTarget
	combat.GiveUp = GiveUp
	combat.SetRange = SetRange
	combat.SetAreaDamage = SetAreaDamage
end
--]]

return {
	enabled = true,
	HookCombat = HookCombat,
	HookClientIndicator = HookClientIndicator,
	RegisterFalseCombat = RegisterFalseCombat,
	NET_STATES = NET_STATES,

	Activate = function(_, context)
		my_context = context
	end,
	Deactivate = function()
		my_context = nil
	end,
}