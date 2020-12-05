--[[
Copyright (C) 2020 penguin0616

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
local action_icons = {
	sleepin = "bedroll_straw",
	fan = "featherfan",
	play = "horn", -- beefalo horn
	hammer = "hammer",
	chop = "axe",
	mine = "pickaxe",
	net = "bugnet",
	hack = "machete", -- sw
	terraform = "pitchfork",
	dig = "shovel",
	brush = "brush",
	gas = "bugrepellant", -- hamlet
	disarm = "disarmingkit", -- hamlet
	pan = "goldpan", -- hamlet
	dislodge = "littlehammer", -- hamlet
	spy = "magnifying_glass", -- hamlet
	throw = "monkeyball", -- sw
	unsaddle = "saddlehorn",
	shear = "shears",

	row = "oar",

	attack = "spear",

	fish = "fishingrod",
}

local function Describe(self, context)
	local inst = self.inst
	local description = nil --string.format(context.lstr.uses, math.ceil(self:GetUses()), math.ceil(self.total))

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

		local actions = {}

		local consumptions2 = {}
		for action, amount in pairs(consumptions) do
			table.insert(consumptions2, {action, amount})
		end

		table.sort(consumptions2, function(a, b) return a[1].id:lower() < b[1].id:lower() end)

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

		for i, v in pairs(consumptions2) do
			local action, amount = v[1], v[2]
			local action_id = action.id:lower()

			local uses = math.ceil(self.current / amount)
			if context.usingIcons and action_icons[action_id] and PrefabHasIcon(action_icons[action_id]) then
				table.insert(actions, string.format(context.lstr.action_uses, action_icons[action_id], uses))
			else
				table.insert(actions, string.format(context.lstr.lang.action_uses, context.lstr["action_" .. action_id] or ("\"" .. action_id .. "\""), uses))
			end
		end

		if #actions == 0 then
			table.insert(actions, string.format(context.lstr.lang.action_uses, "Uses", self:GetUses()))
		end

		description = table.concat(actions, ", ")

	end

	return {
		priority = 1,
		description = description,
		uses = math.ceil(self:GetUses())
	}
end



return {
	Describe = Describe
}