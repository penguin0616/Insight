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
local rawget = rawget

local function FormatUses(uses, context)
	return string.format(context.lstr.lang.action_uses, context.lstr.lang.actions.uses_plain, uses)
end

local function SortActions(a, b)
	return a[1].id:lower() < b[1].id:lower()
end

local function Describe(self, context)
	local inst = self.inst
	local description = nil --string.format(context.lstr.uses, math.ceil(self:GetUses()), math.ceil(self.total))

	local uses = self:GetUses()
	if context.finiteuses_forced or context.config["display_finiteuses"] then
		local consumptions = {}
		for i,v in pairs(self.consumption) do
			consumptions[i] = v
		end

		-- for weapons
		if inst.components.weapon then
			local whack_wear = 1
			whack_wear = inst.components.weapon.attackwear or whack_wear
			consumptions[ACTIONS.ATTACK] = whack_wear
		end

		-- for fishingrod
		if inst.components.fishingrod then
			consumptions[ACTIONS.FISH] = 1
		end
		
		-- sleeping stuff
		if inst.components.sleepingbag then
			if not consumptions[ACTIONS.SLEEPIN] then
				consumptions[ACTIONS.SLEEPIN] = 1
			end
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
		for i = 1, num_actions do
			local v = consumptions2[i]
			local action, amount = v[1], v[2]
			local action_id = action.id:lower()

			local uses = math.ceil(self.current / amount)
			if context.usingIcons and rawget(context.lstr.actions, action_id) and PrefabHasIcon(context.lstr.actions[action_id]) then
				actions[#actions+1] = string.format(context.lstr.action_uses, context.lstr.actions[action_id], uses)
			else
				actions[#actions+1] = string.format(context.lstr.lang.action_uses, context.lstr.lang.actions[action_id] or ("\"" .. action_id .. "\""), uses)
			end
		end

		if #actions == 0 then
			actions[#actions+1] = string.format(context.lstr.lang.action_uses, context.lstr.lang.actions.uses_plain, uses)
		end

		description = table.concat(actions, ", ")

	end

	return {
		priority = 1,
		description = description,
		uses = math.ceil(uses)
	}
end



return {
	Describe = Describe,
	FormatUses = FormatUses
}