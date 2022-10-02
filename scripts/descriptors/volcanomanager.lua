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

--[[
	my old code i just ran in console before insight was a thing

	-- look ok, i needed gears as wx78
	w = GetWorld()
	function w.components.chessnavy:CalcEscalationLevel() 
		self.attack_frequency_fn = self.frequency.frequent 
		self.attack_difficulty = self.difficulty.crazy 
		return 
	end 
	print(w.components.chessnavy:GetDebugString())

	
	-- 1 day = 16 segments = 8 minutes
	-- 1 segment = 30 seconds
	function TimeBeforeBoom() 
		local vm = GetVolcanoManager();
		local segs = vm:GetNumSegmentsUntilEruption();
		local days = math.floor(segs / 16);
		local seconds = segs * 30;
		local minutes = math.floor(seconds / 60);
		print(string.format("Eruption in %s day(s) and %s segments. (%s:%s)", days, segs % 16, minutes, seconds % 60));
	end;
]]

-- volcanomanager.lua [Worldly]
local world_type = GetWorldType()
local clock = import("helpers/clock")
local function Describe(self, context)
	if not (world_type == -1 or world_type >= 3) then
		return
	end 
	
	-- SW only
	local description = nil

	if not self:GetNumSegmentsUntilEruption() then
		return
	end

	--local time_left_in_segment = GetClock().timeLeftInEra % 30 -- timeLeftInEra = time left during a phase.
	local time_left_in_segment = clock:GetTimeLeftInSegment()
	if not time_left_in_segment then
		return
	end

	local seconds = (self:GetNumSegmentsUntilEruption() - 1) * TUNING.SEG_TIME + time_left_in_segment
	description = context.time:SimpleProcess(seconds)

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Volcano.xml",
			tex = "Volcano.tex"
		},
		worldly = true
	}
end



return {
	Describe = Describe
}