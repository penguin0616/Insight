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

-- skinner_beefalo.lua
local yotb_helper = import("helpers/yotb")

-- known categories as of February 9, 2021
--local CATEGORIES = { "WAR", "DOLL", "FESTIVE", "NATURE", "ROBOT", "ICE", "FORMAL", "VICTORIAN", "BEAST" }
if not IsDST() then
	return { Describe = function() end }
end

-- get set data
local set_data = require("yotb_costumes")

--[[
	function YOTB_Stager:GetBeefScore(beef)
	local clothing = beef.components.skinner_beefalo and beef.components.skinner_beefalo:GetClothing() or {
		beef_body = "",
		beef_horn = "",
		beef_tail = "",
		beef_head = "",
		beef_feet = "",
	}

	local score = {
		FEARSOME = 0,
		FESTIVE = 0,
		FORMAL = 0,	
	}

	for i,item in pairs(clothing) do
		local data = set_data.parts[item] or set_data.parts["default"]
		score["FEARSOME"] = score["FEARSOME"] + data["FEARSOME"]
		score["FESTIVE"] = score["FESTIVE"] + data["FESTIVE"]
		score["FORMAL"] = score["FORMAL"] + data["FORMAL"]
	end

	return score
end

]]

local function GetBeefScore(beefalo)
	local clothing = beefalo.components.skinner_beefalo and beefalo.components.skinner_beefalo:GetClothing() or {
		beef_body = "",
		beef_horn = "",
		beef_tail = "",
		beef_head = "",
		beef_feet = "",
	}

	local score = {
		FEARSOME = 0,
		FESTIVE = 0,
		FORMAL = 0,	
	}

	for i,item in pairs(clothing) do
		local data = set_data.parts[item] or set_data.parts["default"]
		score["FEARSOME"] = score["FEARSOME"] + data["FEARSOME"]
		score["FESTIVE"] = score["FESTIVE"] + data["FESTIVE"]
		score["FORMAL"] = score["FORMAL"] + data["FORMAL"]
	end

	return score
end


-- finally
local function Describe(self, context)
	if not context.config["display_yotb_appraisal"] then
		return
	end

	local score = GetBeefScore(self.inst)
	local alt_description = string.format(context.lstr.skinner_beefalo, score.FEARSOME, score.FESTIVE, score.FORMAL)


	return {
		priority = 0,
		alt_description = alt_description
	}

end



return {
	Describe = Describe
}