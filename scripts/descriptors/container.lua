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

-- container.lua
--[[
-- Only exists in DST
function Container:GetAllItems()
    local collected_items = {}
    for k,v in pairs(self.slots) do
        if v ~= nil then
            table.insert(collected_items, v)
        end
    end 

    return collected_items
end

-- in every version of DS
function Container:FindItems(fn)
    local items = {}
    
    for k,v in pairs(self.slots) do
        if fn(v) then
            table.insert(items, v)
        end
    end

    return items
end
]]

local containers = setmetatable({}, {__mode = "k"})

local function GetContainerItems(self)
	if IsDST() then
		-- November 11, 2020; workshop-1467214795 messes with container somehow, don't care to investigate atm
		if self.GetAllItems == nil then
			return {}
		end

		return self:GetAllItems()
	else
		return self:FindItems(function(v) return v end)
	end
end

local function Describe(self, context)
	if containers[self.inst] then
		--mprint("reusing old index")
		return { priority=0, description=nil, contents=containers[self.inst] }
	end

	--mprint("new", self.inst)

	local items = {} -- {prefab, amount}
	context.onlyContents = true

	for i,v in pairs(GetContainerItems(self)) do
		local stacksize = v.components.stackable and v.components.stackable:StackSize() or 1
		local unwrappable_contents = v.components.unwrappable and Insight.descriptors.unwrappable.Describe(v.components.unwrappable, context).contents or nil
		local name = v.components.named and v.name or nil
		
		local data = { prefab=v.prefab, stacksize=stacksize, contents=unwrappable_contents, name=name }

		table.insert(items, data)
	end

	containers[self.inst] = items

	self.inst:ListenForEvent("itemget", function(inst) containers[inst]=nil end)
	self.inst:ListenForEvent("itemlose", function(inst) containers[inst]=nil end)


	--[[
	for i,v in pairs(self:GetAllItems()) do
		if refs[v.prefab] == nil then
			local data = {v.prefab, v.components.stackable and v.components.stackable:StackSize() or 1}
			table.insert(items, data)
			refs[v.prefab] = data
		else
			refs[v.prefab][2] = refs[v.prefab][2] + (v.components.stackable and v.components.stackable:StackSize() or 1)
		end
	end
	--]]

	return {
		priority = 0,
		description = nil,
		contents = items
	}
end



return {
	Describe = Describe
}