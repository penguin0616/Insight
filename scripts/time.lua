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

---------------------------------------
-- Time.
-- @classmod Time
-- @author penguin0616

local time = {} -- library
local Time = {} -- object

-- constants
local SEGMENTS_PER_DAY = 16
local SECONDS_PER_SEGMENT = 30

time.SEGMENTS_PER_DAY = SEGMENTS_PER_DAY
time.SECONDS_PER_SEGMENT = SECONDS_PER_SEGMENT
time.SECONDS_PER_DAY = time.SEGMENTS_PER_DAY * time.SECONDS_PER_SEGMENT

local function round(num, places) 
	places = places or 1
	return tonumber(string.format("%." .. places .. "f", num))
end

local function doubleDigit(num)
	-- good job me!
	return string.format("%02.0f", num)
end

-- base conversion functions
function time.SecondsToSegments(seconds)
	return seconds / SECONDS_PER_SEGMENT
end

function time.MinutesToSegments(minutes)
	return Time.SecondsToSegments(minutes * 60)
end

function time.SecondsToDays(seconds)
	return Time.SecondsToSegments(seconds) / SEGMENTS_PER_DAY
end

function time.MinutesToDays(minutes)
	return Time.SecondsToDays(minutes * 60)
end

function time.DaysToSegments(days)
	return days * SEGMENTS_PER_DAY
end

function time.DaysToSeconds(days)
	return Time.DaysToSegments(days) * SECONDS_PER_SEGMENT
end


-- PHEW.
function time.new(base_seconds, context)
	if type(base_seconds) ~= 'number' then
		error("base_seconds doesnt have a number inputted for time.new", 2)
	end
	
	assert(context, "[insight]: i forgot to include context somewhere, please report")
	-- assert(base_seconds >= 0, "[insight]: time.new expected first argument to be positive.") -- experimenting i suppose
	if base_seconds < 0 then
		base_seconds = 0
	end

	local self = {base_seconds = math.floor(base_seconds), context = context}

	setmetatable(self, {__index = Time, __tostring = Time.__tostring})

	return self
end

-- phew
function Time:GetDays(raw)
	-- under the assumption we don't need REAL days........
	local days = self.base_seconds / SECONDS_PER_SEGMENT / SEGMENTS_PER_DAY

	if not raw then
		days = math.floor(days)
	end

	return days
end

function Time:GetSegments()
	return self.base_seconds / SECONDS_PER_SEGMENT % SEGMENTS_PER_DAY
end

function Time:GetHours()
	return math.floor(self.base_seconds / 60 / 60)
end

function Time:GetMinutes()
	return math.floor(self.base_seconds / 60) % 60
end

function Time:GetSeconds()
	return self.base_seconds % 60
end

function Time:GetReasonableGameTime(short)
	local days = round(self:GetDays(), 1)
	local segments = round(self:GetSegments(), 1)
	local str

	if short then
		--str = string.format("%s", days)
		--print(self:GetDays(true), round(self:GetDays(true), 2))
		str = string.format(self.context.lstr.time_days_short, round(self:GetDays(true), 2))
	else
		str = string.format(self.context.lstr.time_segments, segments)

		if days > 0 then
			str = string.format(self.context.lstr.time_days, days) .. str
		end

		--mprint(days, segments, "|", self:GetDays(true), self:GetSegments())
		--mprint(self:GetDays(true), self:GetSegments(), "|", self.base_seconds)
	end

	return str
end

function Time:GetReasonableRealTime(short)
	local hours = round(self:GetHours(), 0)
	local minutes = round(self:GetMinutes(), 0)
	local seconds = round(self:GetSeconds(), 0)

	local str

	if short then
		str = string.format("%s:%s", doubleDigit(minutes), doubleDigit(seconds))
		if hours > 0 then
			str = string.format("%s:%s", hours, str)
		end
	else
		str = string.format(self.context.lstr.time_seconds, seconds)

		if minutes > 0 then
			str = string.format(self.context.lstr.time_minutes, minutes) .. str
		end

		if hours > 0 then
			str = string.format(self.context.lstr.time_hours, hours) .. str
		end
	end

	return str
end

function Time:__tostring()
	--[[
	local days = self:GetDays()
	local segments = self:GetSegments()
	local minutes = self:GetMinutes()
	local seconds = self:GetSeconds()
	return string.format("%s day%s and %s segment%s | %s minute%s and %s second%s.",
		days,
		(days ~= 1 and "s") or "",
		segments,
		(segments ~= 1 and "s") or "",
		minutes,
		(minutes ~= 1 and "s") or "",
		seconds,
		(seconds ~= 1 and "s") or ""
	)
	--]]

	return string.format("%s | %s", self:GetReasonableGameTime(), self:GetReasonableRealTime())
end


return time