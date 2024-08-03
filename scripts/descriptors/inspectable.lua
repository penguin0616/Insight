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

-- inspectable.lua
-- only using this for stuff i want information on but doesn't have any distinguishable components

local CUSTOM_RANGES = {
	horn = {
		range = TUNING.HORN_RANGE,
		color = Insight.COLORS.EGG
	},
	onemanband = {
		range = TUNING.ONEMANBAND_RANGE,
		color = Insight.COLORS.MONSTER
	},
	panflute = {
		range = TUNING.PANFLUTE_SLEEPRANGE,
		color = Insight.COLORS.SHALLOWS
	},
	gnarwail_horn = {
		range = TUNING.GNARWAIL_HORN_FARM_PLANT_INTERACT_RANGE,
		color = Insight.COLORS.WET
	},
	trident = {
		range = TUNING.TRIDENT_FARM_PLANT_INTERACT_RANGE,
		color = Insight.COLORS.WET
	},
	featherfan = {
		range = TUNING.FEATHERFAN_RADIUS,
		color = Insight.COLORS.FROZEN
	},

	fruitflyfruit = {
		range = 20, --upvalue in behaviours/findfarmplant
		color = "#C46A99",
		attach_player = false
	},
}

local function GetPlayerServerDeaths(context, amount)
	return {
		priority = 1,
		description = string.format("<color=#ffdddd>This person has died </color><color=#ff9999>%s</color><color=#ffeeee> time(s).</color>", amount),
		playerly = true
	}
end

local function PlayerDescribe(self, context)
	local stuff = {}
	if self.inst.wormlight then
		local spell = self.inst.wormlight.components.spell
		if spell and spell.spellname == "wormlight" and Insight.descriptors.debuffable then
			local time_left = spell.duration - spell.lifetime
			local d = Insight.descriptors.debuffable.DescribeDebuff(
				spell.inst.prefab, 
				spell.inst.prefab, 
				context.time:SimpleProcess(time_left, "realtime_short"), 
				context
			)

			local tex = (spell.inst.prefab == "wormlight_light_greater" and "glowberrymousse") or spell.inst.prefab:gsub("_light", "")
			tex = tex .. ".tex"
			local atlas = GetAtlasForTex(tex)
			if atlas then
				d.icon = { atlas=atlas, tex=tex }
			end
			stuff[#stuff+1] = d
		end
	end

	--[[
	local inst = self.inst

	if false and (DEBUG_ENABLED or inst ~= context.player) and inst.userid ~= "" then
		local their_context = GetPlayerContext(inst)
		if their_context and their_context.etc.server_deaths then
			table.insert(stuff, GetPlayerServerDeaths(context, #their_context.etc.server_deaths))
		end
	end
	--]]

	return unpack(stuff)
	
end

local function HasRange(inst)
	if CUSTOM_RANGES[inst.prefab] then
		return true
	end
end

local function RangedDescribe(self, context)
	local inst = self.inst

	local tool_range = CUSTOM_RANGES[inst.prefab].range
	local tool_range_color = CUSTOM_RANGES[inst.prefab].color
	local attach_player = CUSTOM_RANGES[inst.prefab].attach_player

	return {
		name = "insight_ranged",
		priority = 0,
		description = nil,
		range = tool_range,
		color = tool_range_color,
		attach_player = attach_player
	}
end

local function InsightFalseCombatDescribe(self, context)
	if not Insight.descriptors.combat then
		return
	end

	local description = Insight.descriptors.combat.DescribeDamageForPlayer(self:GetDamage(context.player), context.player, context)

	return {
		name = "insight_false_combat",
		priority = 49,
		description = description
	}
end

local function DescribeSheltered(inst, context)
	if not context.config["display_shelter_info"] then
		return
	end

	local description
	--local ranged_data
	if inst:HasTag("shelter") then
		description = string.format(context.lstr.sheltered.range, 2)
	elseif inst:HasTag("shadecanopy") then
		description = string.format(context.lstr.sheltered.range, TUNING.SHADE_CANOPY_RANGE)
		--ranged_data = TUNING.SHADE_CANOPY_RANGE
	elseif inst:HasTag("shadecanopysmall") then
		description = string.format(context.lstr.sheltered.range, TUNING.SHADE_CANOPY_RANGE_SMALL)
		--ranged_data = TUNING.SHADE_CANOPY_RANGE_SMALL
	end

	if description then
		local waterproofness_amount = context.player.components.sheltered and context.player.components.sheltered.waterproofness
		local waterproofness = waterproofness_amount and (context.lstr.sheltered.shelter .. string.format(context.lstr.waterproofness, waterproofness_amount * 100)) or nil
		
		local insulation_amount = context.player.components.temperature and context.player.components.temperature.shelterinsulation
		local insulation = insulation_amount and (context.lstr.sheltered.shelter .. string.format(context.lstr.insulation_summer, insulation_amount)) or nil
		
		--[[
		if ranged_data then
			ranged_data = {
				name = "insight_ranged",
				priority = 0,
				description = nil,
				range = ranged_data / WALL_STUDS_PER_TILE,
				attach_player = false
			}
		end
		--]]

		return {
			name = "insight_shelter",
			priority = 0.1,
			description = description,
			alt_description = CombineLines(description, insulation, waterproofness)
		}--, ranged_data
	end
end


-- just grabbed from inventory icons
local gem_colors = setmetatable({
	redgem = "#8C2B31",
	bluegem = "#37579C",
	purplegem = "#67317B",
	orangegem = "#C7873F",
	yellowgem = "#E4CD41",
	greengem = "#4C9D34",
	opalpreciousgem = "#A9DDF4", -- not that accurate and not used, but why not?
}, {
	__index = function(self, index)
		rawset(self, index, "#ffffff")
		return rawget(self, index)
	end,
})

-- prefabs/statueruins
local function DescribeRuinsStatue(inst, context)
	if not inst.gemmed then
		return
	end

	-- ANCIENT_STATUE
	-- ancient_statue isn't a real prefab, it's a nameoverride.
	if not context.complex_config["unique_info_prefabs"]["ancient_statue"] then
		return
	end

	return string.format(context.lstr.ruins_statue_gem, gem_colors[inst.gemmed], inst.gemmed)
end


local function Describe(self, context)
	local to_return = {}

	local inst = self.inst
	local description = nil

	--[[
	if inst:HasTag("player") then
		return PlayerDescribe(self, context)
	end
	--]]

	if self.inst == context.player then
		return PlayerDescribe(self, context)
	end
	

	--mprint("checking range", HasRange(inst))
	if not inst.components.spellcaster and HasRange(inst) then
		return RangedDescribe(self, context)
	end

	if inst.insight_combat then
		return InsightFalseCombatDescribe(inst.insight_combat, context)
	end

	-- wtf is the name of the thing you repair
	--if inst.prefab == 

	--[[
	if DEBUG_ENABLED and inst.prefab == "spider" then
		return {
			priority = 0,
			description = nil,
			alt_description = "a\nb\nc\nd\ne\nf"
		}
	end
	--]]

	if context.player.prefab ~= "winona" and inst.prefab:sub(1, 14) == "wagstaff_tool_" then
		description = string.format(context.lstr.wagstaff_tool, inst.prefab)
	end

	if inst.nameoverride and inst.nameoverride == "ancient_statue" then
		description = DescribeRuinsStatue(inst, context)
	end

	if inst:HasTag("lamp") then
		if inst.components.container then
			local things = Insight.descriptors.container.DescribeItemAndPerishable(self.inst.components.container, context)
			if things then
				for i = 1, #things do
					things[i].name = "oceantrawler_" .. i
				end
				return unpack(things)
			end
		end
	end

	if inst:HasTag("singingshell") then
		return {
			name = "insight_ranged",
			priority = 0,
			description = nil,
			range = TUNING.SINGINGSHELL_FARM_PLANT_INTERACT_RANGE,
			color = "#40aeb8",
			attach_player = false
		}
	end

	if context.config["display_gyminfo"] and inst:HasTag("heavy") then
		description = string.format(context.lstr.gym_weight_value, inst.gymweight or 2)
	end

	if inst:HasTag("winter_tree") then
		if context.player.components.wintertreegiftable then
			local days_remaining = Insight.descriptors.wintertreegiftable.GetDaysRemainingForRareGift(context.player.components.wintertreegiftable)

			if days_remaining > 0 then
				description = string.format(context.lstr.wintertreegiftable.not_ready, days_remaining)
			--elseif not inst.components.container:IsFull() then
				--description = context.lstr.winter_tree_needsstuff
			else
				description = context.lstr.wintertreegiftable.ready
			end
		end
	end

	--[[
	if IS_DST and inst.components.inventoryitem then
		if context.player.components.itemaffinity then
			for i,v in pairs(context.player.components.itemaffinity.affinities) do
				if v.prefab and context.player.components.inventory:Has(v.prefab, 1) or v.tag and self.inst.components.inventory:HasItemWithTag(v.tag, 1) then

				end
			end
		--local em = context.player.components.sanity.externalmodifiers
		--print(inst, em._base, em:CalculateModifierFromSource(inst))
		--if context.player.components.sanity.externalmodifiers:RemoveModifier
	end
	--]]

	to_return[1] = {
		name = "inspectable",
		priority = 0,
		description = description
	}

	local sheltered = DescribeSheltered(inst, context)
	if sheltered then to_return[#to_return+1] = sheltered end  
	
	return unpack(to_return)
end



return {
	Describe = Describe,
}