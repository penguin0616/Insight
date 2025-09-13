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
	return string.format(context.lstr.lang.action_uses, context.lstr.lang.actions.USES_PLAIN, uses or "?ERROR?")
end

local function SortActions(a, b)
	--[[
	mprint(a, b)
	mprint(a[1], b[1])
	mprint(a[1].id, b[1].id)
	--]]
	-- a[1] is the action, a[2] is the amount consumed per action
	if a[1] and a[1].id and b[1] and b[1].id then
		return a[1].id:lower() < b[1].id:lower()
	end

	return false
end

local function Describe(self, context)
	local inst = self.inst
	local description, alt_description = nil, nil --string.format(context.lstr.uses, math.ceil(self:GetUses()), math.ceil(self.total))

	-- This was added for the wortox soul jar specifically,
	-- but this seems reasonable overall?
	if self.inst.components.container then
		return
	end

	-- I shouldn't have to do this, but my hand has been forced.
	if type(self.current) ~= "number" or type(self.total) ~= "number" then
		return
	end

	local uses = self:GetUses()
	local constant_consumption = nil
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

		-- for dumbbells
		if inst:HasTag("dumbbell") and inst.components.mightydumbbell and inst.components.mightydumbbell.consumption then
			consumptions[ACTIONS.LIFT_DUMBBELL] = inst.components.mightydumbbell.consumption
		end

		-- for lazy explorer
		if inst.components.blinkstaff then
			consumptions[ACTIONS.BLINK] = 1
		end

		local consumptions2 = {}
		local num_actions = 0
		for action, amount in pairs(consumptions) do
			-- I keep seeing id as a number whenever (workshop-2839359499) is enabled.
			-- I guess that same mod probably made "action" a number too.
			if type(action) == "table" and type(action.id) == "string" then 
				num_actions = num_actions + 1
				consumptions2[num_actions] = {action, amount}
				
				-- The purpose of this code is to make sure that if we have constant_consumption, it's a good number.
				if constant_consumption == nil then
					constant_consumption = amount
				elseif constant_consumption and constant_consumption ~= amount then
					constant_consumption = false
				end
			end
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
			local action_id = action.id



			-- ∞
			if action_id and amount ~= 0 then
				local uses = math.ceil(self.current / amount)
				local max_uses = math.ceil(self.total / amount)
				--mprint(action_id, context.usingIcons, rawget(context.lstr.actions, action_id), context.lstr.actions[action_id] and PrefabHasIcon(context.lstr.actions[action_id]))
				if context.usingIcons and rawget(context.lstr.actions, action_id) and PrefabHasIcon(context.lstr.actions[action_id]) then
					actions[c] = string.format(context.lstr.action_uses, context.lstr.actions[action_id], uses)
					actions_verbose[c] = string.format(context.lstr.action_uses_verbose, context.lstr.actions[action_id], uses, max_uses)
				else
					-- Some actions have specific types (i.e. PLAY)
					--[[
					local sub_key = nil
					if not context.lstr.lang.actions[action_id] then
						local dummy = {
							doer = context.player,
							target = self.inst,
							action = action,
							invobject = self.inst, 
							--pos, 
							--recipe, 
							--distance, 
							--rotation
						}
						sub_key = type(action.strfn) == "function" and action.strfn(dummy) or nil
						end
					--]]

					local fallback = "<string=ACTIONS." .. action.id .. ">"
					if type(STRINGS.ACTIONS[action.id]) == "table" then
						if STRINGS.ACTIONS[action.id].GENERIC ~= nil then
							fallback = string.format("<string=ACTIONS.%s.GENERIC>", action.id)
						end
					end

					actions[c] = string.format(context.lstr.lang.action_uses, context.lstr.lang.actions[action_id] or fallback, uses)
					actions_verbose[c] = string.format(context.lstr.lang.action_uses_verbose, context.lstr.lang.actions[action_id] or fallback, uses, max_uses)
				end
				
				c = c + 1
			end
		end

		if num_actions == 0 then
			actions[1] = string.format(context.lstr.lang.action_uses, context.lstr.lang.actions.USES_PLAIN, uses)
			actions_verbose[1] = string.format(context.lstr.lang.action_uses_verbose, context.lstr.lang.actions.USES_PLAIN, uses, self.total)
		end

		description = table.concat(actions, ", ")
		alt_description = table.concat(actions_verbose, ", ")
	end


	if constant_consumption then
		uses = uses / constant_consumption
		if isbadnumber(uses) then
			uses = -1
		end
	end
	
	return {
		priority = 10,
		description = description,
		alt_description = alt_description,
		uses = math.ceil(uses)
	}
end



return {
	Describe = Describe,
	FormatUses = FormatUses
}