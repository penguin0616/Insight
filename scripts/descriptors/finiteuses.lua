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

-- finiteuses.lua
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile

local function FormatUses(uses, context)
	return string.format(context.lstr.lang.action_uses, context.lstr.lang.actions.uses_plain, uses)
end

local function SortActions(a, b)
	--[[
	print(a, b)
	print(a[1], b[1])
	print(a[1].id, b[1].id)
	--]]
	if a[1] and a[1].id and b[1] and b[1].id then
		return a[1].id:lower() < b[1].id:lower()
	end

	return false
end

local function Describe(self, context)
	local inst = self.inst
	local description, alt_description = nil, nil --string.format(context.lstr.uses, math.ceil(self:GetUses()), math.ceil(self.total))

	local uses = self:GetUses()
	if context.finiteuses_forced or context.config["display_finiteuses"] then
		local efficientuser = context.player.components.efficientuser

		local consumptions = {}
		for action, uses_consumed in pairs(self.consumption) do
			consumptions[action] = uses_consumed * (efficientuser and efficientuser:GetMultiplier(action) or 1)
		end

		-- for weapons
		if inst.components.weapon then
			local whack_wear = 1
			whack_wear = inst.components.weapon.attackwear or whack_wear

			local attack_wear_multiplier = inst.components.weapon.attackwearmultipliers and inst.components.weapon.attackwearmultipliers:Get() or 1

			consumptions[ACTIONS.ATTACK] = whack_wear * (efficientuser and efficientuser:GetMultiplier(ACTIONS.ATTACK) or 1) * attack_wear_multiplier
		end

		-- for fishingrod
		if inst.components.fishingrod then
			consumptions[ACTIONS.FISH] = 1 * (efficientuser and efficientuser:GetMultiplier(ACTIONS.FISH) or 1)
		end
		
		-- sleeping stuff
		if inst.components.sleepingbag then
			if not consumptions[ACTIONS.SLEEPIN] then
				consumptions[ACTIONS.SLEEPIN] = 1 * (efficientuser and efficientuser:GetMultiplier(ACTIONS.SLEEPIN) or 1)
			end
		end

		-- for wateringcan
		if (inst.prefab == "wateringcan" or inst.prefab == "premiumwateringcan") and inst:HasTag("wateringcan") then
			consumptions[ACTIONS.POUR_WATER] = 1
			-- POUR_WATER
			-- POUR_WATER_GROUNDTILE
		end

		local consumptions2 = {}
		local num_actions = 0
		for action, amount in pairs(consumptions) do
			num_actions = num_actions + 1
			consumptions2[num_actions] = {action, amount}
		end

		table.sort(consumptions2, SortActions)

		--[[
		for action, amount in pairs(consumptions) do
			local uses = math.ceil(self.current / amount)
			if context.usingIcons and action_icons[action.id:lower()] and PrefabHasIcon(action_icons[action.id:lower()]) then
				table.insert(actions, string.format(context.lstr.action_uses, action_icons[action.id:lower()], uses))
			else
				table.insert(actions, string.format(context.lstr.lang.action_uses, context.lstr["action_" .. action.id:lower()] or ("\"" .. action.id:lower() .. "\""), uses))
			end
		end
		--]]

		local actions = createTable(num_actions)
		local actions_verbose = createTable(num_actions)

		local c = 1
		for i = 1, num_actions do
			local v = consumptions2[i]
			local action, amount = v[1], v[2]
			local action_id = action.id:lower()

			-- ∞
			if amount ~= 0 then
				local uses = math.ceil(self.current / amount)
				local max_uses = math.ceil(self.total / amount)
				if context.usingIcons and rawget(context.lstr.actions, action_id) and PrefabHasIcon(context.lstr.actions[action_id]) then
					actions[c] = string.format(context.lstr.action_uses, context.lstr.actions[action_id], uses)
					actions_verbose[c] = string.format(context.lstr.action_uses_verbose, context.lstr.actions[action_id], uses, max_uses)
				else
					actions[c] = string.format(context.lstr.lang.action_uses, context.lstr.lang.actions[action_id] or ("\"" .. action_id .. "\""), uses)
					actions_verbose[c] = string.format(context.lstr.lang.action_uses_verbose, context.lstr.lang.actions[action_id] or ("\"" .. action_id .. "\""), uses, max_uses)
				end
				
				c = c + 1
			end
		end

		if num_actions == 0 then
			actions[1] = string.format(context.lstr.lang.action_uses, context.lstr.lang.actions.uses_plain, uses)
			actions_verbose[1] = string.format(context.lstr.lang.action_uses_verbose, context.lstr.lang.actions.uses_plain, uses, self.total)
		end

		description = table.concat(actions, ", ")
		alt_description = table.concat(actions_verbose, ", ")

	end

	return {
		priority = 1,
		description = description,
		alt_description = alt_description,
		uses = math.ceil(uses)
	}
end



return {
	Describe = Describe,
	FormatUses = FormatUses
}