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

-- appraisable.lua
if not IsDST() then
	return { Describe = function() end }
end

-- todo: this could use improvement
-- Fetch LoadComponent
local LoadComponent = util.getupvalue(EntityScript.AddComponent, "LoadComponent")
if not LoadComponent then
	return { Describe = function() return {priority=0, description="<color=#FF0000>WHERE IS LOADCOMPONENT?</color"} end }
end

-- Fetch yotb_stager
local safe, yotb_stager = pcall(LoadComponent, "yotb_stager")
if not safe then
	return { Describe = function() return {priority=0, description="<color=#FF0000>WHERE IS yotb_stager?</color"} end }
end

-- get set data
local set_data = require("yotb_costumes")

-- get target thresholds
local target_thresholds = util.getupvalue(yotb_stager.GetParameterLine, "target_thresholds")
if not target_thresholds then
	return { Describe = function() return {priority=0, description="<color=#FF0000>WHERE ARE target_thresholds?</color"} end }
end

local function GetThreshold(doll_value_for_category, category)
	for i, v in ipairs(target_thresholds) do -- ISSUE:PERFORMANCE
	    if doll_value_for_category > v.threshold then
	    	return v, i
	    end
	end

	return target_thresholds[#target_thresholds], #target_thresholds
end

-- finally
local function Describe(self, context)
	if not context.config["display_yotb_appraisal"] then
		return
	end

	local description = nil
	local inst = self.inst

	-- component doesn't actually do anything helpful, actual stuff comes from components/yotb_stager.lua and yotb_costumes.lua

	if not inst.category then
		description = "This doll does not have a category?"
	elseif not set_data.costumes[inst.category] then
		description = "This doll has an unknown costume for its category."
	else -- good to go
		--local qualities = {
		local FEARSOME = set_data.categories[inst.category].FEARSOME * 5 or "?"
		local FESTIVE = set_data.categories[inst.category].FESTIVE * 5 or "?"
		local FORMAL = set_data.categories[inst.category].FORMAL * 5 or "?"
		--}

		-- fear threshold, fear threshold index
		local tfear, tifear = GetThreshold(FEARSOME, "FEARSOME")

		-- festive threshold, festive threshold index
		local tfest, tifest = GetThreshold(FESTIVE, "FESTIVE")

		-- formal threshold, formal threshold index
		local tform, tiform = GetThreshold(FORMAL, "FORMAL")

		-- Fearsome: 6/6 (15/14)
		-- Festive: 1/6, (5/14)
		--description = string.format("%s: %s/%s (%s/%s)", "Fearsome", 8 - tifear, 
		-- todo: figure out how to handle different thresholds

		description = string.format(context.lstr.appraisable, FEARSOME, FESTIVE, FORMAL)

	end

	return {
		priority = 0,
		description = description
	}

end



return {
	Describe = Describe
}