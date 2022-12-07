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

-- savedata.lua 
-- After making this, I saw that there already was a SaveData in DST.
-- Oh well!
local SaveData = Class(function(self, path)
	assert(type(path) == "string", "SaveData class expected base path for arg#1")
	self.initialized = false
	self.path = path
	self.compress = false

	self.data = {}
	self.dirty = false
	self.ready = false
end)

function SaveData:IsReady()
	return self.ready
end

function SaveData:IsDirty()
	return self.dirty
end

function SaveData:SetValue(name, value)
	self.data[name] = value
	self.dirty = true
end
SaveData.Set = SaveData.SetValue

function SaveData:GetValue(name)
	return self.data[name]
end
SaveData.Get = SaveData.GetValue

--- Loads save data.
function SaveData:Load()
	--[[
	if client ~= true then
		error("LoadSaveData only supports client side at the moment.")
	end
	--]]

	--[[
	local known_mod = self.savedata.known_mods[modname]
	if known_mod == nil then
		mprint("Error: mod isn't known", modname )
		return nil
	end
	--]]

	--local path = KnownModIndex:GetModConfigurationPath(modname, true) .. "_SECONDARY"
	local path = self.path --.. (client and "_CLIENT" or "")
	
	--local load, parse, save = nil, nil, nil
	TheSim:GetPersistentString(path,
		function(load_success, str)
			if load_success == true then
				local success, savedata = RunInSandboxSafe(str)
				if success and string.len(str) > 0 then
					mprint("[SaveData] Loaded " .. path)
					self.data = savedata
					self.ready = true
				else
					mprint("[SaveData] Could not load " .. path)
				end
				--parse = success
			else
				mprint("[SaveData] Error loading load " .. path)
			end
			--load = load_success
		end
	)

	return self.data
end

function SaveData:Save(callback, force)
	if self.dirty or force then
		TheSim:SetPersistentString(self.path, DataDumper(self.data, nil, true), self.compress, callback)
		mprint("[SaveData] Saved " .. self.path)
		self.dirty = false
	else
		mprint("[SaveData] Save of " .. self.path .. " not needed, is clean.")
		return callback(true)
	end
end

return SaveData