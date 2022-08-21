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

-- This file is responsible for Year of the Beefalo stuff.
if not IsDST() then
	return {}
end

--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim


local LoadComponent = util.LoadComponent
local yotb_stager = assert(LoadComponent("yotb_stager"), "Failed to load yotb_stager")
local set_data = assert(require("yotb_costumes"), "Failed to load yotb_costumes")
local target_thresholds = assert(util.getupvalue(yotb_stager.GetParameterLine, "target_thresholds"), "Failed to load target_thresholds")
local categories = assert(util.getupvalue(yotb_stager.DeclareWinner, "categories"), "Failed to retrieve yotb_stager -> categories")

local SHOW_YOTB_INFO = false

-- known categories as of February 9, 2021
-- local CATEGORIES = { "WAR", "DOLL", "FESTIVE", "NATURE", "ROBOT", "ICE", "FORMAL", "VICTORIAN", "BEAST" }




--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------

local function GetThreshold(doll_value_for_category, category)
	for i, v in ipairs(target_thresholds) do -- ISSUE:PERFORMANCE
	    if doll_value_for_category > v.threshold then
	    	return v, i
	    end
	end

	return target_thresholds[#target_thresholds], #target_thresholds
end

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

local function DetermineBeefaloRankings(beefs, target_values, categories, target_values)
	local scores = {}

	for i = 1, #beefs do
		local beefalo = beefs[i]
		local candidate_values = GetBeefScore(beefalo)
		
		if beefalo then
			local score = 0
			for _, cat in pairs(categories) do
				score = score + math.abs(candidate_values[cat] - target_values[cat])
			end

			table.insert(scores, { beefalo=beefalo, score=score })
		end
	end

	table.sort(scores, function(a,b) 
		return a.score < b.score
	end)

	return scores
end

local function GetShowYOTBInfo()
	return SHOW_YOTB_INFO
end

local function SetShowYOTBInfo(bool)
	SHOW_YOTB_INFO = bool
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------
return {
	set_data = set_data,
	categories = categories,

	GetThreshold = GetThreshold,
	GetBeefScore = GetBeefScore,
	GetShowYOTBInfo = GetShowYOTBInfo,
	SetShowYOTBInfo = SetShowYOTBInfo,
}

