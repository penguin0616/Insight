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

-- farmplantstress.lua
local function Describe(self, context)
	local description = nil

	if context.config["display_plant_stressors"] == 0 then
		return
	end

	if context.config["display_plant_stressors"] == 1 then
		local hat = false
		-- when looking for hat prefab file, remove hat part

		--if context.player.components.inventory:Has("nutrientsgoggleshat", 1) then
		if context.player.components.inventory:HasItemWithTag("detailedplanthappiness", 1) then
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

	local strs = {}

	--[[
	for stressor, stressed in pairs(self.stressors) do
		local x = ApplyColour(tostring(stressed), stressed and "#ff0000" or "#00ff00")
		table.insert(strs, string.format("%s: %s", stressor, x))
	end

	if #strs > 0 then
		description = table.concat(strs, ", ")
	end
	--]]

	for stressor, stressed in pairs(self.stressors) do
		if stressed then
			table.insert(strs, ApplyColour(stressor, "#dd5555"))
		end
	end

	if #strs > 0 then
		description = string.format(context.lstr.farmplantstress.display, table.concat(strs, ", "))
	end

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}