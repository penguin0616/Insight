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

local definitions = {
	buff_electricattack = {
		name = "<color=WET>Electric attacks</color>",
		prefab = "voltgoatjelly",
	},
	buff_moistureimmunity = {
		name = "<color=WET>Moisture immunity</color>",
		prefab = "frogfishbowl",
	},
	buff_playerabsorption = {
		name = "<color=MEAT>Damage absorption</color>",
		prefab = "spice_garlic",
	},
	buff_workeffectiveness = {
		name = "<color=SWEETENER>Work efficiency</color>",
		prefab = "spice_sugar",
	},
	buff_attack = {
		name = "<color=HEALTH>Attack boost</color>",
		prefab = "spice_chili",
	},

	healthregenbuff = {
		name = "<color=HEALTH>Health regeneration</color>",
		prefab = "jellybean",
	},

	wintersfeastbuff = {
		name = "<color=FROZEN>Winter's Feast Buff</color>",
		prefab = "table_winters_feast"
	},

	halloweenpotion_health_buff = {
		name = "<color=HEALTH>Health regeneration</color>",
		prefab = "halloweenpotion_health_small",
	},
	halloweenpotion_sanity_buff = {
		name = "<color=SANITY>Sanity regeneration</color>",
		prefab = "halloweenpotion_sanity_small",
	},
	halloweenpotion_bravery_buff = {
		name = "<color=SANITY>Bravery</color> against bats.",
		prefab = "halloweenpotion_bravery_small",
	},
}

-- September 9 2020, Feast and Famine (https://steamcommunity.com/sharedfiles/filedetails/?id=1908933602) had its own debuff
setmetatable(definitions, {
	__index = function(self, index)
		local fake = {
			name = "\"" .. index .. "\""
		}
		rawset(self, index, fake)
		
		return fake
	end;
})

local function Describe(self, context)
	local description = nil

	local list = {}

	if self.inst == context.player then
		for debuffPrefab, v in pairs(self.debuffs) do
			local debuff = v.inst
			if debuff then -- this is checked for in debuffable, inst is the actual buff prefab
				local definition = definitions[debuffPrefab]
				local remaining_time = "?"
				local icon = nil

				-- taking a gamble that each buff has a single timer

				if debuff.components.timer then -- ink timer missing
					local name, value = next(debuff.components.timer.timers)
					if next(debuff.components.timer.timers, name) == nil then
						remaining_time = TimeToText(time.new(debuff.components.timer:GetTimeLeft(name), context))
					else
						-- doesnt have a single timer
						remaining_time = "Buff has multiple timers?"
					end
				else
					remaining_time = "No timer specified"
				end
				
				local text = string.format(context.lstr.buff_text, definition.name or ("\"" .. debuffPrefab .. "\""), remaining_time)

				--dprint("server", debuffPrefab, text)

				if definition.prefab then
					icon = ResolvePrefabToImageTable(definition.prefab)
					--[[
					local exists, tex, atlas = PrefabHasIcon(definition.prefab)

					if exists then
						icon = { atlas=atlas, tex=tex }
					end
					--]]
				end

				table.insert(list, {name = debuffPrefab, text = text, icon=icon})
			end
		end

	end

	return {
		priority = 0,
		description = description,
		debuffs = list
	}
end



return {
	Describe = Describe
}