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

-- stewer.lua
local cooking = require("cooking")

local function GetRecipe(cooker, product)
	-- DST
	if cooking.GetRecipe then
		return cooking.GetRecipe(cooker, product)
	end

	-- DS
	local recipes = cooking.recipes[cooker] or {}
	return recipes[product]
end

local function GetChef(self)
	if self.chef_id then -- dst check implicit
		local client = TheNet:GetClientTableForUser(self.chef_id)
		
		if client then
			client.colour = Color.ToHex(client.colour)
			return client
		end

		client = {
			name = "??",
			colour = "#555555",
		}

		return client
	end

	return nil
end

local function Describe(self, context)
	local description, food, chef_string

	local cooktime = self:GetTimeToCook()

	--[[
		https://github.com/penguin0616/Insight/issues/13 bug report for mod https://steamcommunity.com/sharedfiles/filedetails/?id=907007729
		they set cooktime fixed to 1 for whatever reason and replace components.stewer in their prefab to their deluxe thing 
	]]
	local is_authentic = self.GetTimeToCook == require("components/stewer").GetTimeToCook

	if not (is_authentic) then
		return
	end

	local chef = context.config["stewer_chef"] and GetChef(self)
	if chef and (self:IsDone() or cooktime > 0) then
		chef_string = string.format(context.lstr.cooker, chef.colour, chef.name)
	end

	if not (cooktime > 0) then -- not using :IsCooking() because its not in DS
		return { priority=0, description=chef_string }
	end

	cooktime = math.ceil(cooktime)

	local recipe = GetRecipe(self.inst.prefab, self.product)
	local stacksize = recipe and recipe.stacksize or 1
		
	if context.usingIcons and PrefabHasIcon(self.product) then
		food = string.format(context.lstr.cooktime_remaining, self.product, stacksize, cooktime)
	else
		local name = STRINGS.NAMES[string.upper(self.product)] or ("\"" .. self.product .. "\"")
		food = string.format(context.lstr.lang.cooktime_remaining, name, stacksize, cooktime)
	end

	description = CombineLines(food, chef_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}