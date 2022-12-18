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

---------------------------------------
-- Time.
-- @classmod Time
-- @author penguin0616

--[[
	search: TimeToText\(time\.new\(([^,]+),\s*context\)\)
	replace: context.time:SimpleProcess($1)
]]
--------------------------------------------------------------------------
--[[ Declarations ]]
--------------------------------------------------------------------------
local Time = {}
Time.__index = Time

local WorkableTime = {}
WorkableTime.__index = WorkableTime

local TUNING = TUNING
local SEGMENTS_PER_DAY = (TUNING.TOTAL_DAY_TIME / TUNING.SEG_TIME)


--------------------------------------------------------------------------
--[[ Functions ]]
--------------------------------------------------------------------------
local function round(num, places) 
	places = places or 1
	return tonumber(string.format("%." .. places .. "f", num))
end

local function doubleDigit(num)
	-- good job me!
	return string.format("%02.0f", num)
end

--------------------------------------------------------------------------
--[[ Time Static Methods ]]
--------------------------------------------------------------------------
function Time.SecondsToSegments(seconds)
	return seconds / TUNING.SEG_TIME
end

function Time.MinutesToSegments(minutes)
	return Time.SecondsToSegments(minutes * 60)
end

function Time.SecondsToDays(seconds)
	return Time.SecondsToSegments(seconds) / SEGMENTS_PER_DAY
end

function Time.MinutesToDays(minutes)
	return Time.SecondsToDays(minutes * 60)
end

function Time.DaysToSegments(days)
	return days * SEGMENTS_PER_DAY
end

function Time.DaysToSeconds(days)
	return Time.DaysToSegments(days) * TUNING.SEG_TIME
end

--------------------------------------------------------------------------
--[[ Time Methods ]]
--------------------------------------------------------------------------
function Time:new(data)
	if type(data) ~= "table" then
		error(string.format("bad argument #1 to 'new' (table expected, got %s)", type(data)))
	elseif type(data.context) ~= "table" then
		error(string.format("bad argument #1 to 'new' (expected table for arg.context, got %s)", type(data.context)))
	end

	setmetatable(data, self)

	--[[
	-- old
	local this = { base_seconds=math.floor(base_seconds), context = context}

	setmetatable(self, {__index = Time, __tostring = Time.__tostring})

	return self
	]]

	return data
end

function Time:GetWorkable(base_seconds)
	if not self.context then
		return nil
	end

	if base_seconds < 0 then
		base_seconds = 0
	end

	return WorkableTime:new({ context=self.context, base_seconds=base_seconds })
end


function Time:SimpleProcess(base_seconds, override)
	if not self.context then
		return nil
	end
	
	--local style = (type(override) == "string" and override) or GetModConfigData("time_style", true)
	local style = override or self.context.config["time_style"]

	local wt = self:GetWorkable(base_seconds)
	
	if style == "realtime" then
		--return WorkableTime.GetReasonableRealTime({ context=self.context, base_seconds=base_seconds }, false)
		return wt:GetReasonableRealTime(false)
	elseif style == "realtime_short" then
		--return WorkableTime.GetReasonableRealTime({ context=self.context, base_seconds=base_seconds }, true)
		return wt:GetReasonableRealTime(true)

	elseif style == "gametime" then
		--return WorkableTime.GetReasonableGameTime({ context=self.context, base_seconds=base_seconds }, false)
		return wt:GetReasonableGameTime(false)
	elseif style == "gametime_short" then
		--return WorkableTime.GetReasonableGameTime({ context=self.context, base_seconds=base_seconds }, true)
		return wt:GetReasonableGameTime(true)

	elseif style == "both" then
		return string.format("%s (%s)", 
			--WorkableTime.GetReasonableGameTime({ context=self.context, base_seconds=base_seconds }, false),
			--WorkableTime.GetReasonableRealTime({ context=self.context, base_seconds=base_seconds }, false)
			wt:GetReasonableGameTime(false),
			wt:GetReasonableRealTime(false)
		)
	elseif style == "both_short" then
		return string.format("%s (%s)", 
			--WorkableTime.GetReasonableGameTime({ context=self.context, base_seconds=base_seconds }, true),
			--WorkableTime.GetReasonableRealTime({ context=self.context, base_seconds=base_seconds }, true)
			wt:GetReasonableGameTime(true),
			wt:GetReasonableRealTime(true)
		)
	else
		-- this shouldn't occur
		return nil
	end
end

function Time:TryStatusAnnouncementsTime(seconds)
	if not self.context then
		return
	end

	if localPlayer and localPlayer.HUD._StatusAnnouncer.SecondsToTimeRemainingString then
		return localPlayer.HUD._StatusAnnouncer:SecondsToTimeRemainingString(math.floor(seconds))
	end

	return self:SimpleProcess(seconds)
end

function Time:__tostring()
	return string.format("%s | %s", self:GetReasonableGameTime(), self:GetReasonableRealTime())
end

--[[
	function TimeToText(arg, override)
		if type(arg) == "number" then
			error("TimeToText should be called with a time object.")
		end

		--local style = (type(override) == "string" and override) or GetModConfigData("time_style", true)
		local style = (type(override) == "string" and override) or arg.context.config["time_style"]


		if style == "realtime" then
			return arg:GetReasonableRealTime()
		elseif style == "realtime_short" then
			return arg:GetReasonableRealTime(true)

		elseif style == "gametime" then
			return arg:GetReasonableGameTime()
		elseif style == "gametime_short" then
			return arg:GetReasonableGameTime(true)

		elseif style == "both" then
			return string.format("%s (%s)", arg:GetReasonableGameTime(), arg:GetReasonableRealTime())
		elseif style == "both_short" then
			return string.format("%s (%s)", arg:GetReasonableGameTime(true), arg:GetReasonableRealTime(true))
			
		else
			-- this shouldn't occur
			return nil
		end
	end

]]

--------------------------------------------------------------------------
--[[ WorkableTime Methods ]]
--------------------------------------------------------------------------
function WorkableTime:new(data)
	if type(data) ~= "table" then
		error(string.format("bad argument #1 to 'new' (table expected, got %s)", type(data)))
	elseif type(data.context) ~= "table" then
		error(string.format("bad argument #1 to 'new' (expected table for arg.context, got %s)", type(data.context)))
	elseif type(data.base_seconds) ~= "number" then
		error(string.format("bad argument #1 to 'new' (expected number for arg.base_seconds, got %s)", type(data.base_seconds)))
	end

	setmetatable(data, self)

	--[[
	-- old
	local this = { base_seconds=math.floor(base_seconds), context = context}

	setmetatable(self, {__index = Time, __tostring = Time.__tostring})

	return self
	]]

	return data
end

function WorkableTime:GetReasonableGameTime(short)
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

function WorkableTime:GetReasonableRealTime(short)
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

function WorkableTime:GetDays(raw)
	-- under the assumption we don't need REAL days........
	local days = self.base_seconds / TUNING.SEG_TIME / SEGMENTS_PER_DAY

	if not raw then
		days = math.floor(days)
	end

	return days
end

function WorkableTime:GetSegments()
	return self.base_seconds / TUNING.SEG_TIME % SEGMENTS_PER_DAY
end

function WorkableTime:GetHours()
	return math.floor(self.base_seconds / 60 / 60)
end

function WorkableTime:GetMinutes()
	return math.floor(self.base_seconds / 60) % 60
end

function WorkableTime:GetSeconds()
	return self.base_seconds % 60
end

return Time