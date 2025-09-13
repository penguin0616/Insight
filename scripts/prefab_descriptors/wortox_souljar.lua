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

-- wortox_souljar.lua [Prefab]
local function Describe(inst, context)
	local description = nil

	if not inst.components.container then
		return
	end

	--local _, soul_count = inst.components.container:HasItemWithTag("soul", 0)
	local count, maxcount = 0, 0
	inst.components.container:ForEachItem(function(item)
		if item.components.stackable then
			count = count + item.components.stackable:StackSize()
			maxcount = maxcount + (item.components.stackable:IsOverStacked() and item.components.stackable.originalmaxsize or item.components.stackable.maxsize)
		else
			count = count + 1
			maxcount = maxcount + 1
		end
	end)

	if count > 0 then
		-- Maxcount is 0 when empty.
		description = string.format("<color=HEALTH><prefab=wortox_soul></color>: <color=HEALTH>%d</color> / <color=HEALTH>%d</color>", count, maxcount)
	end

	
	return {
		priority = 0,
		description = description,
		prefably = true
	}
end



return {
	Describe = Describe
}