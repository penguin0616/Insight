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

local function GetCookTimeModifier(self)
	if not self.cooktimemult then
		return 0
	end

	return 1 - self.cooktimemult
end

local function GetRecipeInfo(recipe)
	local data = {
		basename = recipe.basename or recipe.name,
		spice = recipe.spice,
		name = recipe.name,
		stacksize = recipe.stacksize or 1,
	}

	--[[
		cookbook_atlas="images/cookbook_mashedpotatoes.xml",
		cookbook_category="cookpot",
		cooktime=1,
		floater={ [2]=0.1, [3]={ 0.7, 0.6, 0.7 } },
		foodtype="VEGGIE",
		health=20,
		hunger=37.5,
		name="mashedpotatoes",
		perishtime=7200,
		potlevel="low",
		priority=20,
		sanity=33,
		supportedCookers={ archive_cookpot=true, cookpot=true, portablecookpot=true },
	]]

	--[[
		{
		basename="mashedpotatoes",
		cookbook_atlas="images/cookbook_mashedpotatoes_spice_garlic.xml",
		cookbook_category="spiced_cookpot",
		cooktime=0.12,
		floater={ "med", [3]={ 0.85, 0.7, 0.85 } },
		foodtype="VEGGIE",
		health=20,
		hunger=37.5,
		name="mashedpotatoes_spice_garlic",
		official=true,
		oneatenfn=loadstring("LuaQ\000\000\000\000\000scripts/spicedfoods.lua\000\000\000\000\000\000\000\000\000 \000\000\000\000À\000@@W@\000À\000@@À@\000\000\000\000\000\000À\000\000AW@@\000À\000\000A@A\000@\000\000Á\000Á\000@\000\000@\000À\000@@\000BA\000AA\000@\000\000\000\
		\000\000\000\000\000\000components\000\000\000\000debuffable\000\000\
		\000\000\000IsEnabled\000\000\000\000health\000\000\000\000IsDead\000\000\000\000HasTag\000\000\000\000playerghost\000\
		\000\000\000AddDebuff\000\000\000\000buff_playerabsorption\000\000\000\000\000 \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000	\000\000\000	\000\000\000	\000\000\000	\000\000\000	\000\000\000	\000\000\000\000\000\000\000\000\000\000\000\000inst\000\000\000\000\000\000\000\000\000\000\000eater\000\000\000\000\000\000\000\000\000\000\000\000"),
		perishtime=7200,
		potlevel="low",
		prefabs={ "buff_playerabsorption" },
		priority=100,
		sanity=33,
		spice="SPICE_GARLIC",
		supportedCookers={ portablespicer=true },
		test=closure {
			"LuaQ\000\000\000\000\000scripts/spicedfoods.lua\000.\000\000\000.\000\000\000\000\000\000\000Ĝ000\000\000ƀ\000ڜ000\000\000@\000Ĝ000\000ƀ\000ޜ000\000\000\000\000\000\000\000\000\000\000\000\000\000\000.\000\000\000.\000\000\000.\000\000\000.\000\000\000.\000\000\000.\000\000\000.\000\000\000.\000\000\000\000\000\000\000\000\000cooker\000\000\000\000\000\000\000\000\000\000\000names\000\000\000\000\000\000\000\000\000\000\000tags\000\000\000\000\000\000\000\000\000\000\000	\000\000\000foodname\000\
		\000\000\000spicename\000",
			"mashedpotatoes",
			"spice_garlic" 
		},
		weight=1 
		}
	]]

	--print(DataDumper(recipe))

	--[[
	if recipe.spice then
		data.fancyname = subfmt(STRINGS.NAMES[recipe.spice.."_FOOD"], { food = STRINGS.NAMES[string.upper(data.basename)] })
	else
		data.fancyname = STRINGS.NAMES[string.upper(data.name)]
	end
	--]]

	return data
end

local function Describe(self, context)
	local description, food, chef_string, cook_time_string

	local cooktime = self:GetTimeToCook()

	--[[
		https://github.com/penguin0616/Insight/issues/13 bug report for mod https://steamcommunity.com/sharedfiles/filedetails/?id=907007729
		they set cooktime fixed to 1 for whatever reason and replace components.stewer in their prefab to their deluxe thing 
	]]

	local is_authentic = self.GetTimeToCook == require("components/stewer").GetTimeToCook

	if not (is_authentic) then
		return
	end

	-- cook time modifier
	local cook_time_modifier = GetCookTimeModifier(self)
	if cook_time_modifier < 0 then
		-- 1 - 1.25 = -0.25 = you cook slower
		-- slower
		cook_time_string = string.format(context.lstr.stewer.cooktime_modifier_slower, math.abs(cook_time_modifier) * 100)
	elseif cook_time_modifier > 0 then
		-- 1 - 0.8 = 0.2 = you cook faster
		-- faster
		cook_time_string = string.format(context.lstr.stewer.cooktime_modifier_faster, cook_time_modifier * 100)
	end

	-- chef
	if self.done or cooktime > 0 then -- IsDone() missing in DS, exists in DLC
		local chef = context.config["stewer_chef"] and GetChef(self)
		if chef then
			chef_string = string.format(context.lstr.stewer.cooker, chef.colour, EscapeRichText(chef.name))
		end

		cooktime = math.ceil(cooktime)

		local recipe = GetRecipe(self.inst.prefab, self.product)

		if not recipe then
			--if self.product == self.spoiledproduct then
			-- we'll show the product and see what happens
			local base_food_string = context.usingIcons and PrefabHasIcon(self.product) and context.lstr.stewer.product or context.lstr.lang.stewer.product
			food = string.format(base_food_string, self.product, "?") -- dont know if spoiling sets stack amount to 1
		else
			local data = GetRecipeInfo(recipe)
			if context.usingIcons and PrefabHasIcon(data.name) then -- self.product
				local base_food_string = cooktime > 0 and context.lstr.stewer.cooktime_remaining or context.lstr.stewer.product
				food = string.format(base_food_string, data.name, data.stacksize, cooktime)
			else
				local base_food_string = cooktime > 0 and context.lstr.lang.stewer.cooktime_remaining or context.lstr.lang.stewer.product
				food = string.format(base_food_string, data.name, data.stacksize, cooktime)
			end
		end
	end

	description = CombineLines(food, chef_string, cook_time_string)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe
}