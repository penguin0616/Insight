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

-- farmplantstress.lua
local function GetPlantStressors(self) -- ISSUE:PERFORMANCE might be worth caching temporarily?
	local stressors = {}
	for stressor, testfn in pairs(self.stressors_testfns) do
		if testfn(self.inst, self.stressors[stressor], false) then
			stressors[#stressors+1] = stressor
		end
	end
	return stressors
end

local function GetPlantStressState(self)
	local stress = self.stress_points
	local final_stress_state = stress <= 1 and FARM_PLANT_STRESS.NONE		-- allow one mistake
							or stress <= 6 and FARM_PLANT_STRESS.LOW		-- one and half categories can fail, take your pick
							or stress <= 11 and FARM_PLANT_STRESS.MODERATE  -- almost 3 categories can fail
							or FARM_PLANT_STRESS.HIGH						-- you aren't even trying now, are you?

	return final_stress_state
end

local GREEN = Color.fromHex("#00cc00")
local RED = Color.fromHex("#dd5555")

local STRESS_COLORS = {
	[FARM_PLANT_STRESS.NONE] = GREEN:Lerp(RED, 0):ToHex(),
	[FARM_PLANT_STRESS.LOW] = GREEN:Lerp(RED, 1/3):ToHex(),
	[FARM_PLANT_STRESS.MODERATE] = GREEN:Lerp(RED, 2/3):ToHex(),
	[FARM_PLANT_STRESS.HIGH] = RED:ToHex()
}

local function Describe(self, context)
	--[[
	if true then
		return {priority=0, description="helloa\n\tbthere\nbthere"}
	end
	--]]

	if context.config["display_plant_stressors"] == 0 then
		return
	end

	if context.config["display_plant_stressors"] == 1 then
		local hat = false
		-- when looking for hat prefab file, remove hat part

		--if context.player.components.inventory:Has("nutrientsgoggleshat", 1) then
		if context.player:HasTag("plantkin") then
			hat = true
		elseif context.player.components.inventory:HasItemWithTag("detailedplanthappiness", 1) then
			hat = true
		elseif context.player.components.inventory:EquipHasTag("detailedplanthappiness") then
			hat = true
		else
			--[[
			local head_item = context.player.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
			if head_item and head_item.prefab == "nutrientsgoggleshat" then
				hat = true
			end
			--]]
		end

		if not hat then
			return
		end
	end

	local stress_state = GetPlantStressState(self)
	local plant_stressors = GetPlantStressors(self)

	local strs = {}

	for i = 1, #plant_stressors do
		local stressor = contedxt.lstr.farmplantstress.categories[plant_stressors[i]] or ("\"" .. plant_stressors[i] .. "\"")
		strs[i] = ApplyColor(stressor, "#dd5555")
	end

	local stress_points = string.format(context.lstr.farmplantstress.stress_points, ApplyColor(self.stress_points, STRESS_COLORS[stress_state]))
	local stress_points_extended = stress_points .. " - " .. string.format(context.lstr.farmplantstress.stress_tier, ApplyColor(context.lstr.farmplantstress.tiers[stress_state], STRESS_COLORS[stress_state]))
	local stressors_string

	if #strs > 0 then
		stressors_string = string.format(context.lstr.farmplantstress.display, table.concat(strs, ", "))
	end

	--description = ApplyColor("hey ", STRESS_COLORS[FARM_PLANT_STRESS.NONE]) .. ApplyColor("hey ", STRESS_COLORS[FARM_PLANT_STRESS.LOW]) .. ApplyColor("hey ", STRESS_COLORS[FARM_PLANT_STRESS.MODERATE]) .. ApplyColor("hey ", STRESS_COLORS[FARM_PLANT_STRESS.HIGH])

	return {
		name = "farmplantstress_stresspoints",
		priority = 0.01,
		description = stress_points,
		alt_description = stress_points_extended
	}, {
		name = "farmplantstress_stressors",
		priority = 0,
		description = stressors_string
	}
end



return {
	Describe = Describe
}