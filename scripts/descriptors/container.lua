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

local initialized = false
local containers = setmetatable({}, {__mode = "k"})
local listeners_hooked = setmetatable({}, {__mode = "kv"})

--- Used to invalidate the container cache on the client side whenever the contents change.
--- @param inst EntityScript
local function OnItemChange(inst)
	local players = AllPlayers or {GetPlayer()}

	for i,v in pairs(players) do
		local insight = v.components.insight
		if insight then
			insight:InvalidateCachedEntity(inst)
		end
	end
end

local function ContainerFindFn(v)
	return v
end

local function GetContainerItems(self)
	if IS_DST then
		-- November 11, 2020; workshop-1467214795 messes with container somehow, don't care to investigate atm
		if self.GetAllItems == nil then
			--cprint("GetAllItems is nil?")
			return {}
		end

		return self:GetAllItems()
	else
		return self:FindItems(ContainerFindFn)
	end
end

local function PopContainer(inst)
	containers[inst] = nil
end

local function GetContainerContents(self, context)
	if containers[self.inst] then
		--mprint("reusing old index")
		return containers[self.inst]
	end

	--mprint("new", self.inst)

	local items = {} -- {prefab, amount}
	context.onlyContents = true -- ISSUE: REFACTOR

	-- so this might not process the container slots in order, but that doesn't really matter here
	--local container_items = GetContainerItems(self)

	for i = 1, self.numslots do
		local v = self.slots[i]

		if v ~= nil then
			local stacksize = v.components.stackable and v.components.stackable:StackSize() or 1
			local unwrappable_contents = v.components.unwrappable and Insight.descriptors.unwrappable.Describe(v.components.unwrappable, context).contents or nil
			local name = v.components.named and v.name or nil
			
			local data = { prefab=v.prefab, stacksize=stacksize, contents=unwrappable_contents, name=name }

			items[#items+1] = data -- table.insert(items, data)
		end
	end

	containers[self.inst] = items

	--if not table.contains(self.inst.event_listeners["itemget"][self.inst], PopContainer) then -- this works but eh
	if not listeners_hooked[self.inst] then
		listeners_hooked[self.inst] = true
		self.inst:ListenForEvent("itemget", PopContainer)
		self.inst:ListenForEvent("itemlose", PopContainer)
	end

	return containers[self.inst]
end

--- Describes items in the format <prefab>: <perishable>
local function DescribeItemAndPerishable(self, context)
	local ret = {}

	for i,v in pairs(self:GetAllItems()) do
		local this = {
			name = "container_" .. i, -- Not like the order's accurate anyway.
			priority = 0,
			description = string.format("<color=%s><prefab=%s></color>", "#eeeeee", v.prefab),
		}

		ret[#ret+1] = this

		if v.components.perishable then
			local perish = Insight.descriptors.perishable.Describe(v.components.perishable, context)
			if perish then
				this.alt_description = this.description

				this.description = this.description .. ": " .. (perish.description or "?")
				this.alt_description = this.alt_description .. ": " .. (perish.alt_description or "?")
			end
		end
	end

	return ret
end

local function DescribeItemAndStackable(self, context)
	local ret = {}

	for i,v in pairs(self:GetAllItems()) do
		local this = {
			name = "container_" .. i, -- Not like the order's accurate anyway.
			priority = 0,
			description = string.format("<color=%s><prefab=%s></color>", "#ffffff", v.prefab),
		}

		ret[#ret+1] = this
		
		if v.components.stackable then
			this.description = this.description .. string.format(" (%s)", v.components.stackable:StackSize())
		end
	end

	return ret
end

local function OnContainerPostInit(self)
	self.inst:ListenForEvent("itemget", OnItemChange)
	self.inst:ListenForEvent("itemlose", OnItemChange)
	self.inst:ListenForEvent("onclose", OnItemChange)
end

local function OnServerLoad()
	if initialized then
		return
	end

	initialized = true

	if not IS_DST then
		return
	end
	
	AddComponentPostInit("container", OnContainerPostInit)
end


local function Describe(self, context)
	local description
	local items = GetContainerContents(self, context)

	-- These are created by messagebottletreasures
	if false and self.inst.prefab == "sunkenchest" then
		return unpack(DescribeItemAndStackable(self, context))
	end

	return {
		name = "container",
		priority = 0,
		description = description,
		contents = items
	}
end



return {
	OnServerLoad = OnServerLoad,
	Describe = Describe,
	DescribeItemAndPerishable = DescribeItemAndPerishable,
	DescribeItemAndStackable = DescribeItemAndStackable,
}