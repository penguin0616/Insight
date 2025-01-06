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

-- rabbitkingmanager.lua

local function DescribeCarrotsFed(self, context)
	local description

	-- How many carrots have been fed to a rabbit hole
	if type(self.carrots_fed) == "number" and type(self.carrots_fed_max) == "number" then
		description = string.format(context.lstr.rabbitkingmanager.carrots, self.carrots_fed, self.carrots_fed_max)
	end

	return {
		name = "rabbitkingmanager.carrotsfed",
		priority = 0,
		worldly = true,
		description = description
	}
end

local function Describe(self, context)
	local description = nil --self:GetDebugString():gsub(",","\n")

	-- If there is a rabbit king and he is currently alive, the other information does not matter.
	local rabbit_king = self.rabbitkingdata and self.rabbitkingdata.rabbitking
	local icon
	if rabbit_king then
		description = string.format(context.lstr.rabbitkingmanager.king_status,
			string.format("<prefab=%s>", rabbit_king.prefab)
		)

		local tex = rabbit_king.prefab .. ".tex"
		
		--[[
		rabbitking_aggressive = {name="rabbitking_aggressive", tex="rabbitking_aggressive.tex", type="creature", prefab="rabbitking_aggressive", sanityaura=-0.66666666666667, health=2000, damage=75, build="rabbitking_aggressive_build", bank="rabbit", anim="idle", deps={"beardhair", "monstermeat", "rabbitkingminion_bunnyman", "rabbitkingspear"}},
		rabbitking_lucky = {name="rabbitking_lucky", tex="rabbitking_lucky.tex", type="creature", prefab="rabbitking_lucky", sanityaura=0.41666666666667, health=2000, build="rabbitking_lucky_build", bank="rabbit", anim="idle", deps={"smallmeat"}},
		rabbitking_passive = {name="rabbitking_passive", tex="rabbitking_passive.tex", type="creature", prefab="rabbitking_passive", sanityaura=0.10416666666667, health=2000, build="rabbitking_passive_build", bank="rabbit", anim="idle", deps={"armor_carrotlure", "rabbithat", "rabbitkinghorn", "smallmeat"}},
		]]

		local atlas = GetScrapbookIconAtlas(tex, true)
		--cprint(tex, atlas)
		if tex and atlas then
			icon = { atlas = atlas, tex = tex, scrapbook = true }
		end

	elseif self.cooldown then
		-- If there's a cooldown, we'll show that.
		local cooldown_string = string.format(context.lstr.cooldown, context.time:SimpleProcess(self.cooldown))
		description = cooldown_string

	else
		-- We only care about this information if we don't have a cooldown.
		local carrots_fed_info = DescribeCarrotsFed(self, context)

		-- How much rabbit naughtiness has been accumulated
		local naughtiness_string
		if type(self.naughtiness) == "number" and type(self.naughtiness_max) == "number" then
			naughtiness_string = string.format(context.lstr.rabbitkingmanager.naughtiness, self.naughtiness, self.naughtiness_max)
		end

		description = CombineLines(carrots_fed_info.description, naughtiness_string)
	end

	if not icon then
		icon = {
			atlas = "images/Rabbitking_lucky.xml",
			tex = "Rabbitking_lucky.tex"
		}
	end

	return {
		name = "rabbitkingmanager",
		priority = 0,
		worldly = true,
		icon = icon,
		description = description,
	}
end



return {
	Describe = Describe,
	DescribeCarrotsFed = DescribeCarrotsFed,
}