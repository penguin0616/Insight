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
--local start_color = Color.fromHex("#0069A7") -- Interesting choice of start color, I guess.
local start_color = Color.fromHex("#504375") -- Recharge color is #504375, so we'll try that.
local end_color = Color.fromHex("#ffffff") --Color.fromHex("#D1FFFF")

local function Describe(self, context)
	local description, alt_description = nil, nil

	-- myth words theme has a myth_rechargeable component that screws with this.
	-- why insight picks up a component with that name as rechargeable, i don't know.
	-- they probably did something dumb.
	if not self.GetTimeToCharge or type(self.current) ~= "number" or type(self.total) ~= "number" then
		return
	end

	local percent = self.current / self.total
	percent = not isbadnumber(percent) and percent or 0

	local remaining_charge_time = self:GetTimeToCharge()

	if remaining_charge_time >= 0 then
		description = string.format(context.lstr.rechargeable.charged_in, 
			ApplyColor(context.time:SimpleProcess(remaining_charge_time), start_color:Lerp(end_color, percent))
		)
		alt_description = string.format(context.lstr.rechargeable.charge, Round(self.current, 0), Round(self.total, 0)) .. ", " .. description
	end

	--[[
	-- What was going on here?
	if remaining / remaining == remaining then -- widgets/itemtile.lua:411
		description = string.format(context.lstr.rechargeable.charged_in, 
			ApplyColor(context.time:SimpleProcess(remaining), ST:Lerp(EN, percent))
		)
		alt_description = string.format(context.lstr.rechargeable.charge, Round(self.current, 0), Round(self.total, 0)) .. ", " .. description
	end

	if not (remaining > 0) then
		description = nil
	end
	--]]

	return {
		priority = 10,
		description = description,
		alt_description = alt_description
	}
end



return {
	Describe = Describe
}