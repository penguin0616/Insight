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

-- farmplantable.lua
local farmingHelper = import("helpers/farming")

local function StringifyPlantGoodSeasons(seasons, context)
	local str = ""
	if seasons.autumn then
		str = str .. context.lstr.seasons.autumn .. ", "
	end
	
	if seasons.winter then
		str = str .. context.lstr.seasons.winter .. ", "
	end

	if seasons.spring then
		str = str .. context.lstr.seasons.spring .. ", "
	end

	if seasons.summer then
		str = str .. context.lstr.seasons.summer .. ", "
	end

	if #str > 0 then
		str = string.sub(str, 1, -3)
	end

	return str
end
	

local function Describe(self, context)
	-- self.plant
	-- farm_plant_randomseed
	-- farm_plant_potato

	if type(self.plant) ~= "string" then
		return
	end

	local definition = farmingHelper.GetPlantDefinitionFromSeed(self.plant)

	if not definition then
		return
	end

	local alt_description = nil
	local nutrients = farmingHelper.GetPlantNutrientModifier(definition)

	local product = definition.product or "???"
	if context.usingIcons and PrefabHasIcon(product) then
		--alt_description = string.format(context.lstr.farmplantable.product, product)
	else
		local name = GetPrefabNameOrElse(product, "\"%s\"")
		--alt_description = string.format(context.lstr.lang.farmplantable.product, name)
	end

	local season_string = string.format(context.lstr.farmplantable.good_seasons, StringifyPlantGoodSeasons(definition.good_seasons, context))

	local nutrient_string = string.format(context.lstr.farmplantable.nutrient_consumption, nutrients.formula, nutrients.compost, nutrients.manure)
	alt_description = CombineLines(season_string, nutrient_string)

	return {
		priority = 0,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}