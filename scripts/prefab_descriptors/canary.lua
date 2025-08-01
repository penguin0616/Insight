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

-- canary.lua [Prefab]

local base_canary_poison_chance = 10*(100 / 12)/100 --[[
-- gaslevel > 12 and math.random() * 12 < gaslevel - 12

math.random() <= 1
	10% chance seems to be fair
		
math.random() * 12 <= 1
	* 12 means its harder to fall in <= 1 
	

-- math.random() <= 1== 1 / 10 == 10% chance
-- math.random() * 12 < 1, *12 means its harder to be under <1, which means lesser chance...
-- but how much less...?
-- perhaps i could argue that its 12 times less often

	> x=0; for i = 1, 10000 do local r = math.random() if r <= .1 then x = x + 1 end end; mprint(x);
	987

	we'll call this 1.0

	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	824
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	824
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	835
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	827
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	808
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	805
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	857
	> x=0; for i = 1, 10000 do local r = math.random() if r*12 <= 1 then x = x + 1 end end; mprint(x);
	836

	-- we'll call it 0.8333
	-- 0.8333 = 10*(100 / 12)/100
--]]

local function GetCanaryData(inst)
	if inst._gaslevel == nil then
		return {}
	end

	local data = { gas_level=inst._gaslevel }

	if inst._gasuptask then
		data.increasing = true
		data.decreasing = false
		data.time = GetTaskRemaining(inst._gasuptask)
	elseif inst._gasdowntask then
		data.increasing = false
		data.decreasing = true
		data.time = GetTaskRemaining(inst._gasdowntask)
	end

	return data
end

local function GetCanaryDescription(inst, context)
	local description = nil
	local data = GetCanaryData(inst)

	if not data.gas_level then
		return
	end
	
	
	local strs = {}
	local poison_string

	table.insert(strs, string.format(context.lstr.canary.gas_level, data.gas_level, 13))
	if data.increasing then
		table.insert(strs, string.format(context.lstr.canary.gas_level_increase, context.time:SimpleProcess(data.time)))
	elseif data.decreasing then
		table.insert(strs, string.format(context.lstr.canary.gas_level_decrease, context.time:SimpleProcess(data.time)))
	end

	description = table.concat(strs, ", ")

	if data.gas_level > 12 then
		poison_string = string.format(context.lstr.canary.poison_chance, 10 * base_canary_poison_chance * (data.gas_level - 12))
	end

	description = CombineLines(description, poison_string)

	return description
end

local function Describe(inst, context)
	local description = GetCanaryDescription(inst, context)

	return {
		priority = 0,
		description = description
	}
end



return {
	Describe = Describe,
	GetCanaryDescription = GetCanaryDescription
}