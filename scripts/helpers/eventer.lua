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

-- events.lua

--------------------------------------------------------------------------
--[[ EventListener ]]
--------------------------------------------------------------------------
local EventListener = Class(function(self, name, event, fn)
	self.valid = true
	self.name = name
	self.event = event
	self.fn = fn
	-- Set externally
	self.eventer = nil
	self.weak = false
end)

function EventListener:OnRemove()
	self.valid = false
	self.fn = nil
end

function EventListener:Remove()
	self.event:RemoveListener(self)
end

function EventListener:Run(...)
	if not self.valid then
		error("Unable to Run invalid event")
	end
	
	self.fn(...)

	if self.weak then
		-- Make sure we haven't been removed already by the fn.
		if self.valid then
			self:Remove()
		end
	end
end

--------------------------------------------------------------------------
--[[ Event ]]
--------------------------------------------------------------------------
local Event = Class(function(self, name)
	self.name = name
	self.listeners = {}
	self.onlisteneradded = nil
end)

function Event:AddListener(name, fn, weak)
	if type(name) ~= "string" then
		if type(name) == "function" and fn == nil then
			-- This was called with no name.
			fn = name
			name = "listener" .. GetTableSize(self.listeners) + 1
		elseif name == nil then
			name = "listener" .. GetTableSize(self.listeners) + 1
		else
			errorf("Adding an event listener requires a name, got '%s'", type(name))
		end
		--errorf("Adding an event listener requires a name, got '%s'", type(name))
	end

	if self.listeners[name] then
		error("Duplicate listener not allowed")
	end

	if type(fn) ~= "function" then
		errorf("Adding an event listener requires a function, got '%s'", type(fn))
	end

	local listener = EventListener(name, self, fn)
	self.listeners[listener.name] = listener

	if weak then
		listener.weak = weak
	end

	if self.onlisteneradded then
		self.onlisteneradded(listener)
	end

	-- Make sure the listener wasn't killed during onlisteneradded.
	if listener.valid then
		return listener
	end
end

function Event:AddWeakListener(name, fn)
	if type(name) == "function" and fn == nil then
		-- No name.
		fn = name
		name = "weak_listener" .. math.random(1, 0xFFFFFF)
	end

	return self:AddListener(name, fn, true)
end


function Event:GetListener(name)
	return self.listeners[name]
end

function Event:HasListener(name)
	return self.listeners[name] ~= nil
end

function Event:RemoveListener(listener)
	local name = type(listener) == "string" and listener or listener.name

	if name and self.listeners[name] then
		self.listeners[name]:OnRemove()
		self.listeners[name] = nil
	end
end

function Event:Push(...)
	for name, listener in pairs(self.listeners) do
		listener:Run(...)
	end
end

--------------------------------------------------------------------------
--[[ Eventer ]]
--------------------------------------------------------------------------
local Eventer = Class(function(self)
	self.events = {}
end)

--- Creates an events.
---@return Event @The created event.
function Eventer:CreateEvent(eventName)
	if self.events[eventName] then
		error("Duplciate Event not allowed")
	end

	self.events[eventName] = Event(eventName)

	return self.events[eventName]
end

function Eventer:GetEvent(eventName)
	if self.events[eventName] then
		return self.events[eventName]
	end
end

-- You can skip putting a name for both of these Listens, they'll be given a normal one.
function Eventer:ListenForEvent(eventName, fn, oldweak)
	if oldweak then
		error("Use ListenForEventOnce", 2)
	end
	
	return self:AddEventListener(nil, eventName, fn, false)
end

function Eventer:ListenForEventOnce(eventName, fn)
	return self:AddEventListener(nil, eventName, fn, true)
end

function Eventer:AddEventListener(name, eventName, fn, weak)
	if not self.events[eventName] then
		self.events[eventName] = Event(eventName)
	end

	local listener = self.events[eventName]:AddListener(name, fn, weak)
	
	if listener.valid then
		return listener
	end
end

--[[ Removing Event Listeners ]]
--[[
function Eventer:RemoveEventListener(listener)
	if not listener then
		return
	end

	listener:Remove()            
end
--]]

function Eventer:RemoveEventCallback(eventName, fn)
	local event = self.events[eventName]
	if not event then
		errorf("Event '%s' does not exist", eventName)
	end

	for name, listener in pairs(event.listeners) do
		if listener.fn == fn then
			listener:Remove()
		end
	end
end

function Eventer:PushEvent(eventName, ...)
	local event = self.events[eventName]
	event:Push(...)
end

return Eventer