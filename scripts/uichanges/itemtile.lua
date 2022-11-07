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

local module = {}

-- Handler for ItemTile:SetPercent()
-- created for issue #5

local ItemTile = require("widgets/itemtile")

local ITEMTILE_DISPLAY = "percentages"; 
AddLocalPlayerPostInit(function(_, context) 
	ITEMTILE_DISPLAY = context.config["itemtile_display"]
	if IS_DS then 
		-- thought only refresh was needed, but creating a Hamlet as Willow leads to a crash because components.inventory.itemslots has the lighter,
		-- but controls.inv.inv is missing the slots so...  
		localPlayer.HUD.controls.inv:Rebuild()
		localPlayer.HUD.controls.inv:Refresh()
	end
end);

local function ItemTile_SetPercent(self, percent, ...)
	--dprint("setpercent", ITEMTILE_DISPLAY, percent, ...)
	if not localPlayer then
		return module.oldItemTile_SetPercent(self, percent, ...)
	end
	
	--dprint('yep', GetModConfigData("itemtile_display", true))
	--dprint('yep', self.item, self, ...) 

	local cfg = ITEMTILE_DISPLAY
	
	if (cfg == "percentages") or IsForge() then
		return module.oldItemTile_SetPercent(self, percent, ...)
	end

	--dprint('hello')
	
	if not self.percent then
		-- have klei take care of setting up the percent first.
		module.oldItemTile_SetPercent(self, percent, ...)
		if not self.percent then
			--dprint("Unable to :SetPercent()")
		end

	end

	if cfg == "none" then
		if self.item and self.percent then
			self.percent:SetString(nil)
		end

		return
	end

	if self.item:HasTag("hide_percentage") then
		return
	end

	if self.item and self.percent then
		--dprint('oh')
		local value
		
		local itemInfo = RequestEntityInformation(self.item, localPlayer, { FROM_INSPECTION = true, IGNORE_WORLDLY = true })

		if itemInfo then
			if itemInfo.special_data.temperature then -- thermal stone, coming in STRONG
				value = itemInfo.special_data.temperature.temperatureValue

			elseif itemInfo.special_data.armor_durability then
				value = itemInfo.special_data.armor_durability.durabilityValue

			elseif itemInfo.special_data.fueled then
				if cfg == "numbers" then
					value = itemInfo.special_data.fueled.remaining_time
				else
					local val_to_show = percent*100
					if val_to_show > 0 and val_to_show < 1 then
						val_to_show = 1
					end
					value = string.format("%2.0f%%", val_to_show)
				end
			elseif itemInfo.special_data.finiteuses then
				value = itemInfo.special_data.finiteuses.uses

			end
		end

		--dprint("hey", value)

		if value then
			--dprint('right', value)
			value = tostring(value)
			self.percent:SetString(value)

			if IS_DS then -- this flips over and goes tiny in DST
				if #value > 4 then
					-- today i learned Text:SetSize() does nothing, because they messed up while coding the text widget and made :GetSize() into :SetSize() overriding the working one.
					-- real nice. 
					--self.percent.inst.TextWidget:SetSize((LOC and LOC.GetTextScale() or 1) * (42 - (#value - 4) * 2))
					self.percent:InsightSetSize(42 - (#value - 4) * 3)
				else
					--self.percent:SetSize(42) -- default
					self.percent:InsightSetSize(42) -- default
				end
			else
				if #value > 4 then
					self.percent:SetSize(42 - (#value - 4) * 2)
				else
					self.percent:SetSize(42) -- default
				end
			end

			-- don't want to trigger it again
			return
		end
	end
	

	return module.oldItemTile_SetPercent(self, percent, ...)
end

module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S"):match("([%w_]+)%.lua$"))
		return
	end

	module.initialized = true
	module.oldItemTile_SetPercent = ItemTile.SetPercent
	ItemTile.SetPercent = ItemTile_SetPercent
end

return module