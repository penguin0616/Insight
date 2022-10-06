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

-- yotb_stager.lua
if not IS_DST then
	return { Describe = function() end }
end

local yotbHelper = import("helpers/yotb")


-- tag yotb_stage
local cached_posts = nil
local cached_scores = nil
local beefalo_rankings


local function SortBeefaloScores(a, b) return a.score < b.score end

local function GetBeefaloScores(self)
	local scores = {}
	for i,v in pairs(self.posts) do
		local beefalo = v.components.hitcher:GetHitched()
		if beefalo then
			local candidate_values = yotbHelper.GetBeefScore(beefalo)
			local score = 0
			for i,cat in ipairs(yotbHelper.categories) do
				score = score + math.abs(candidate_values[cat] - self.target_values[cat])
			end
			table.insert(scores, { post=v, beefalo=beefalo, score=score })
		end
	end
	table.sort(scores, SortBeefaloScores)
	return scores
end

local function IsContestReady(self)
	if self.posts and (#self.posts > 3) then
		for i = 1, #self.posts do
			--print(self.posts[i].components.hitcher:GetHitched(), self.posts[i].components.hitcher.locked) -- :GetHitched()
			if not self.posts[i].components.hitcher:GetHitched() or self.posts[i].components.hitcher.locked == false then
				return false
			end
		end
		
		return true
	end

	return false
end

-- finally
local function Describe(self, context)
	if not context.config["display_yotb_winners"] then
		return
	end

	-- double check
	if not self.posts or not self.target_values or not (#self.tasks > 0) then
		return
	end

	--[[
	if cached_posts == self.posts then
		-- no need to update
	else
		if self.posts and (#self.posts > 3) then
			-- update
			cached_posts = self.posts
			cached_scores = cached_posts and GetBeefaloScores(self)
		end
	end
	--]]

	if cached_posts == self.posts then
		-- no need to update
	else
		if IsContestReady(self) then
			cached_posts = self.posts
			cached_scores = cached_posts and GetBeefaloScores(self)
		end
	end

	--cached_scores = GetBeefaloScores(self)

	if not cached_scores then
		return
	end

	local first, second, third = cached_scores[1], cached_scores[2], cached_scores[3]
	local description = table.concat({
		string.format("<color=#DED15E>[1]: %s</color>", first and first.beefalo:GetDisplayName() or "?"), 
		string.format("<color=#C0C0C0>[2]: %s</color>", second and second.beefalo:GetDisplayName() or "?"), 
		string.format("<color=#CD7F32>[3]: %s</color>", third and third.beefalo:GetDisplayName() or "?")
	}, "\n")

	
	--local score = GetBeefScore(self.inst)
	--local description = string.format(context.lstr.skinner_beefalo, score.FEARSOME, score.FESTIVE, score.FORMAL)


	return {
		priority = 0,
		description = description
	}

end



return {
	Describe = Describe
}