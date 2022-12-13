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

-- keybinds.lua
local function GetKeyAsNum(key)
	local t = type(key)
	if t == "number" then
		-- They probably passed in a KEY_<SOMETHING>
		--key = string.char(key):lower():byte()
	elseif t == "string" then
		if #key ~= 1 then
			return error("Key length expected to be 1")
		end
		key = key:lower():byte()
	end
	
	return key
end

local Keybinds = Class(function(self)
	--assert(type(keybinds) == "table", "Keybinds arg#1 expected table")
	self.ready = false
	self.keybinds = {}
	self.input_handlers = {}
end)

--- Gets the key associated with a keybind.
function Keybinds:GetKey(name)
	local k = self.keybinds[name] and self.input_handlers[name].key or nil
	if k then
		return k--, string.char(k):upper()
	end
end

function Keybinds:GetDefaultKey(name)
	local k = self.keybinds[name] and self.keybinds[name].default_key
	if k then
		return k--, string.char(k):upper()
	end
end

function Keybinds:LoadSavedKeybindings(saved)
	for name in pairs(self.keybinds) do
		self:ChangeKey(name, saved[name])
	end
end
--[[
function Keybinds:BulkRegister(keybind_list, register_list)
	error("I refuse!")
	for keybind_name, fn in pairs(register_list) do
		self:Register(keybind_name, keybind_list[keybind_name], fn)
	end
end
--]]

function Keybinds:Register(name, pretty_name, description, key, fn)
	assert(self.keybinds[name] == nil, string.format("Cannot overwrite existing keybind '%s'", name))
	key = GetKeyAsNum(key)

	self.keybinds[name] = { pretty_name=pretty_name, description=description, default_key=key, fn=fn }
	self:ChangeKey(name, key, fn)
end

function Keybinds:ChangeKey(name, key)
	assert(self.keybinds[name] ~= nil, string.format("Cannot ChangeKey for unregistered name '%s'", name))
	key = GetKeyAsNum(key)

	-- Purge old key handlers
	local old_key
	local old_handler = self.input_handlers[name]
	if old_handler then
		old_key = old_handler.key
		if old_key == key then
			dprint("ChangeKey's new key is the same as the old one!")
			return
		end

		-- We already have a key handler in place here. Remove it.
		if old_handler.down then old_handler.down:Remove() end
		if old_handler.up then old_handler.up:Remove() end
		self.input_handlers[name] = nil
	end
	
	-- Check if this is a new key
	--local new = false
	if self.input_handlers[name] == nil then
		self.input_handlers[name] = {}
		--new = true
	end

	if key then
		-- Setup the down & up handler.
		self.input_handlers[name].down = TheInput:AddKeyDownHandler(key, function() 
			if not self.ready then
				dprint("Got key down while unready.")
				return
			end
			return self.keybinds[name].fn(true) 
		end)
		self.input_handlers[name].up = TheInput:AddKeyUpHandler(key, function() 
			if not self.ready then
				dprint("Got key up while unready.")
				return
			end
			return self.keybinds[name].fn(false) 
		end)
		self.input_handlers[name].key = key
	end
	
	-- Initial registers shouldn't trigger change.
	if self.ready then
		self:OnKeybindChanged(name, key, old_key)
	end
end

function Keybinds:OnKeybindChanged(keybind_name, new_key, old_key)
	dprint("OnKeybindChanged", keybind_name, new_key, old_key)
	if self.onkeybindchanged then
		self.onkeybindchanged(self, keybind_name, new_key, old_key)
	end
end

function Keybinds:SetReady()
	self.ready = true
end

return Keybinds