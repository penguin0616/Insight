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

-- ghostlyelixirable.lua
-- purple from spectral cure-all
local function GetBuffDescription(self, context)
	local target = self:GetApplyToTarget(context.player, nil) -- game doesn't care about elixir argument, let's hope a mod doesn't.
	
	if not target or not target.components.debuffable then
		return
	end

	local elixir_buff = target.components.debuffable:GetDebuff("elixir_buff")
	if not elixir_buff or not elixir_buff.components.timer then
		return
	end

	local potion_prefab = string.match(elixir_buff.prefab, "(ghostlyelixir_%w+)")
	local time_left = elixir_buff.components.timer:GetTimeLeft("decay")
	if time_left then
		time_left = context.time:SimpleProcess(time_left)
	end

	return string.format(context.lstr.ghostlyelixirable.remaining_buff_time, potion_prefab or "?", time_left or "?")
end

local function Describe(self, context)
	local description = GetBuffDescription(self, context)
	local bond_info

	if context.player.components.ghostlybond and Insight.descriptors.ghostlybond then
		if self.inst.prefab == "abigail" and Insight.descriptors.ghostlybond.AbigailDescribe then
			bond_info = Insight.descriptors.ghostlybond.AbigailDescribe(context.player.components.ghostlybond, context)
		elseif self.inst:HasTag("abigail_flower") and Insight.descriptors.ghostlybond.FlowerDescribe then
			bond_info = Insight.descriptors.ghostlybond.FlowerDescribe(context.player.components.ghostlybond, context)
		end
	end

	return {
		name = "ghostlyelixirable",
		priority = 2,
		description = description
	}, bond_info
end



return {
	Describe = Describe
}