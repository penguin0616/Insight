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

-- rechargeable.lua
local ST = Color.fromHex("#0069A7")
local EN = Color.fromHex("#ffffff") --Color.fromHex("#D1FFFF")

local function Describe(self, context)
	local description, alt_description = nil, nil

	local remaining = self:GetTimeToCharge()
	description = string.format(context.lstr.rechargeable.charged_in, 
		ApplyColour(context.time:SimpleProcess(remaining), ST:Lerp(EN, self.current / self.total))
	)
	alt_description = string.format(context.lstr.rechargeable.charge, Round(self.current, 0), Round(self.total, 0)) .. ", " .. description

	if not (remaining > 0) then
		description = nil
	end

	return {
		priority = 10,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}