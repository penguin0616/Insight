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

-- deerclopsspawner.lua [Worldly]
local function GetDeerclopsData(self)
	if not self.inst.updatecomponents[self] then
		return {}
	end

	local time_to_attack = self:OnSave().timetoattack
	if not (time_to_attack and time_to_attack > 0) then
		return {}
	end

	local target = util.getupvalue(self.OnUpdate, "_targetplayer")

	if target then
		target = {
			name = target.name,
			userid = target.userid,
			prefab = target.prefab,
		}
	end

	return {
		time_to_attack = time_to_attack,
		target = target
	}
end

local function ProcessInformation(context, time_to_attack, target)
	local time_string = TimeToText(time.new(time_to_attack, context))

	if not target then
		return time_string
	else
		local target_string = string.format("%s - %s", target.name, target.prefab)
		local ctable = TheNet:GetClientTableForUser(target.userid)
		local clr = Color.ToHex(ctable.colour)
		return string.format(context.lstr.incoming_deerclops_targeted, clr, target_string, time_string)
	end
end

local function Describe(self, context)
	local description = nil
	local data = {}

	if self == nil and context.deerclops_data then
		data = context.deerclops_data
	elseif self and context.deerclops_data == nil then
		data = GetDeerclopsData(self)
	else
		error(string.format("deerclopsspawner.Describe improperly called with self=%s & deerclops_data=%s", tostring(self), tostring(context.deerclops_data)))
	end

	if data.time_to_attack then
		description = ProcessInformation(context, data.time_to_attack, data.target)
	end

	return {
		priority = 0,
		description = description,
		icon = {
			atlas = "images/Deerclops.xml",
			tex = "Deerclops.tex",
		},
		worldly = true
	}
end



return {
	Describe = Describe,
	GetDeerclopsData = GetDeerclopsData
}