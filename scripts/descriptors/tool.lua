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

-- tool.lua
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

local Is_DST = IsDST()

local function SortActions(a, b)
	return a[1].id:lower() < b[1].id:lower()
end

local function Describe(self, context)
	local description = nil

	-- https://dontstarve.fandom.com/wiki/Pick/Axe
	local tbl = (Is_DST and self.actions) or (not Is_DST and self.action)
	if not tbl then
		return
	end

	local actions = {}

	local effs = {}

	local workmultiplier = context.player.components.workmultiplier
	for action, effectiveness in pairs(tbl) do
		effs[#effs+1] = {action, effectiveness * (workmultiplier ~= nil and workmultiplier:GetMultiplier(action) or 1)}
	end

	table.sort(effs, SortActions)

	--[[
	for action, effectiveness in pairs(tbl) do
		local name = action.id

		-- #aaaaee
		table.insert(actions, string.format("<color=#DED15E>%s</color>: %s%%", STRINGS.ACTIONS[name] or name .. "*", tostring(effectiveness * 100)))
		--description = description .. name .. "=" .. tostring(effectiveness) .. ","
	end
	--]]

	for i = 1, #effs do
		local v = effs[i]
		local action, effectiveness = v[1], v[2]
		local name = action.id

		-- #aaaaee
		if effectiveness ~= 1 then
			actions[#actions+1] = string.format(context.lstr.action_efficiency, STRINGS.ACTIONS[name] or name .. "*", tostring(effectiveness * 100))
		end
	end

	if #actions > 0 then
		description = string.format(context.lstr.tool_efficiency, table.concat(actions, "<color=#aaaaee>,</color> "))
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}