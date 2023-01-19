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


-- debuffable.lua
--[[
	-- foodbuffs.lua
	buff_electricattack
	buff_moistureimmunity
	buff_playerabsorption
	buff_workeffectiveness
	buff_attack

	-- healthregenbuff.lua
	healthregenbuff
	
	-- etc
	wintersfeastbuff
	squid_ink_player_fx
	forcefield
	abigail_vex_debuff
	elixir_buff
	*halloweenpotion_buffs.lua -> inst.buff_id
	*halloweenpotion_embers.lua -> inst.buff_prefab
	mindcontroller
	sporebomb
]]

local debuffHelper = import("helpers/debuff")

local debuff_to_prefab = {
	buff_electricattack = "voltgoatjelly",
	buff_moistureimmunity = "frogfishbowl",
	buff_playerabsorption = "spice_garlic",
	buff_workeffectiveness = "spice_sugar",
	buff_attack = "spice_chili",

	
	tillweedsalve_buff = "tillweedsalve",
	healthregenbuff = "jellybean",
	sweettea_buff = "sweettea",

	wintersfeastbuff = "table_winters_feast",

	halloweenpotion_health_buff = "halloweenpotion_health_small",
	halloweenpotion_sanity_buff = "halloweenpotion_sanity_small",
	halloweenpotion_bravery_buff = "halloweenpotion_bravery_small",
}

-- September 9 2020, Feast and Famine (https://steamcommunity.com/sharedfiles/filedetails/?id=1908933602) had its own debuff
--[[
setmetatable(definitions, {
	__index = function(self, index)
		rawset(self, index, fake)
		
		return fake
	end;
})
--]]

local function Describe(self, context)
	local description = nil

	local list = nil

	if self.inst ~= context.player then
		return
	end

	for debuffName, v in pairs(self.debuffs) do
		local debuff = v.inst
		if debuff then -- this is checked for in debuffable, inst is the actual debuff entity
			-- This blob of whatever is responsible for getting the remaining time of the debuff.
			-- taking a gamble that each buff has a single timer
			local remaining_time
			if debuff.components.timer then -- ink timer missing
				local name, value = next(debuff.components.timer.timers)
				if next(debuff.components.timer.timers, name) == nil then
					local t = debuff.components.timer:GetTimeLeft(name)
					remaining_time = t and context.time:SimpleProcess(t) or "Missing time?"
				else
					-- doesnt have a single timer
					remaining_time = "Buff has multiple timers?"
				end
			else
				remaining_time = "No timer specified"
			end

			local known_debuff = context.lstr.debuffs[debuffName] ~= nil

			-- Make sure name exists, modded prefabs don't have one registered with us.
			local name = ("\"" .. debuffName .. "\"")
			if known_debuff and context.lstr.debuffs[debuffName].name and context.lstr.debuffs[debuffName].name ~= "" then
				name = context.lstr.debuffs[debuffName].name
			end

			local primary_info = string.format(context.lstr.buff_text, name, remaining_time)
			local desc = nil
			if known_debuff and context.lstr.debuffs[debuffName].description then
				desc = debuffHelper.GetDebuffEffects(debuffName, context)
			end
			local text = CombineLines(primary_info, desc)

			local icon = debuff_to_prefab[debuffName] and ResolvePrefabToImageTable(debuff_to_prefab[debuffName]) or nil

			if not list then list = {} end
			list[#list+1] = {name = debuffName, text=text, icon=icon}
		end
	end

	return {
		priority = 0,
		description = description,
		debuffs = list
	}
end



return {
	Describe = Describe,
}