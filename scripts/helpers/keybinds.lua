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
local function ResolveKey(key)
	if #key ~= 1 then
		return error("Key length expected to be 1")
	end

	if type(key) == "number" then
		-- They probably passed in a KEY_<SOMETHING>
		key = string.char(key)
	end

	key = key:upper()
	
	return key
end

local Keybinds = Class(function(self, keybinds)
	--assert(type(keybinds) == "table", "Keybinds arg#1 expected table")
	self.keybinds = {}
	self.input_handlers = {}
end)

function Keybinds:Register(name, key, fn)
	assert(self.keybinds[name] == nil, string.format("Cannot overwrite existing keybind '%s'", name))

	self.keybinds[name] = fn

	if key then
		self:SetupKeyHandler(name, key, fn)
	end
end

function Keybinds:SetupKeyHandler(name, key)
	assert(self.keybinds[name] ~= nil, string.format("Cannot SetupKeyHandler for unregistered name '%s'", name))
	key = ResolveKey(key)

	if self.input_handlers[name] then
		-- We already have a key handler in place here. Remove it.
		self.input_handlers[name]:Remove()
		self.input_handlers[name] = nil
	end
	
	-- Here we go.
	self.input_handlers[name] = TheInput:AddKeyHandler(function(_key, down)
		return self.keybinds[name](down)
	end)
end



return Keybinds