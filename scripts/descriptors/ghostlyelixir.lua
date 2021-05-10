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

-- ghostlyelixir.lua
local potion_tunings = nil do
	local exec = loadfile("scripts/prefabs/ghostly_elixirs.lua")
	if type(exec) == "function" then
		local env = setmetatable({
			Prefab = function(...)
				potion_tunings = potion_tunings or util.getupvalue(debug.getinfo(2).func, "potion_tunings")
				return {...}
			end,
			Asset = function(...)
				return {}
			end
		}, {__index=Insight.env})
		setfenv(exec, env)
		exec()
	end
end


local function Describe(self, context)
	if not potion_tunings then
		return
	end

	local inst = self.inst
	local description = nil

	if inst.prefab == "ghostlyelixir_slowregen" then
		local ticks = math.floor(TUNING.GHOSTLYELIXIR_SLOWREGEN_DURATION / TUNING.GHOSTLYELIXIR_SLOWREGEN_TICK_TIME)
		local total_heal = ticks * TUNING.GHOSTLYELIXIR_SLOWREGEN_HEALING
		description = string.format(context.lstr.ghostlyelixir.ghostlyelixir_slowregen, 
			total_heal, 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_SLOWREGEN_DURATION, "realtime_short"), 
			TUNING.GHOSTLYELIXIR_SLOWREGEN_HEALING, 
			TUNING.GHOSTLYELIXIR_SLOWREGEN_TICK_TIME
		)

	elseif inst.prefab == "ghostlyelixir_fastregen" then
		local ticks = math.floor(TUNING.GHOSTLYELIXIR_FASTREGEN_DURATION / TUNING.GHOSTLYELIXIR_FASTREGEN_TICK_TIME)
		local total_heal = ticks * TUNING.GHOSTLYELIXIR_FASTREGEN_HEALING
		description = string.format(context.lstr.ghostlyelixir.ghostlyelixir_slowregen, 
			total_heal, 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_FASTREGEN_DURATION, "realtime_short"), 
			TUNING.GHOSTLYELIXIR_FASTREGEN_HEALING, 
			TUNING.GHOSTLYELIXIR_FASTREGEN_TICK_TIME
		)
	elseif inst.prefab == "ghostlyelixir_attack" then
		description = string.format(context.lstr.ghostlyelixir.ghostlyelixir_attack, 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_DAMAGE_DURATION, "realtime_short")
		)

	elseif inst.prefab == "ghostlyelixir_speed" then
		description = string.format(context.lstr.ghostlyelixir.ghostlyelixir_speed, 
			Round((TUNING.GHOSTLYELIXIR_SPEED_LOCO_MULT - 1) * 100, 0), 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_SPEED_DURATION, "realtime_short")
		)

	elseif inst.prefab == "ghostlyelixir_shield" then -- length handled by animation
		description = string.format(context.lstr.ghostlyelixir.ghostlyelixir_shield, 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_SHIELD_DURATION, "realtime_short")
		)

	elseif inst.prefab == "ghostlyelixir_retaliation" then
		description = string.format(context.lstr.ghostlyelixir.ghostlyelixir_shield, 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_SHIELD_DURATION, "realtime_short")
		) .. "\n" .. string.format(context.lstr.ghostlyelixir.ghostlyelixir_retaliation, 
			TUNING.GHOSTLYELIXIR_RETALIATION_DAMAGE, 
			context.time:SimpleProcess(TUNING.GHOSTLYELIXIR_RETALIATION_DURATION, "realtime_short")
		)

	end

	return {
		priority = 2,
		description = description
	}
end



return {
	Describe = Describe
}