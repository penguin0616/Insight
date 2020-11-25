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

---------------------------------------
-- Handles importing of resources for the mod.
-- This is here because modimport doesn't RETURN the import......
-- @module import
-- @author penguin0616

setfenv(1, _G.Insight.env)

local select, unpack = select, unpack
local function pack(...) return { n=select("#", ...), ...} end
local function vararg(packed) return unpack(packed, 1, packed.n) end

local import_cache = {}

--local import_cache = package.loaded -- require's cache

--- Importer function.
-- @string path Path to the lua file to load (do not append .lua)
-- @treturn function
local function import(path)
	--path = "../mods/" .. modname .. "/" ..  path
	path = MODROOT .. "scripts/" .. path .. ".lua"

	-- as to behave like require
	if (import_cache[path]) then
		return vararg(import_cache[path])
	end

	
	local fn = kleiloadlua(path)

	if fn == nil then
		error("[ERR] File does not exist: " .. path)
	elseif type(fn) == "string" then
		error(string.format("[ERR] Error loading file \"%s\".\nError: %s", path, fn))
	else
		--[[
		setfenv(fn, _G.setmetatable({}, {
			__index = _G.Insight.env,
			__metatable = "yep"
		}))
		--]]
		setfenv(fn, _G.Insight.env)

		import_cache[path] = pack(fn())
		return vararg(import_cache[path])
	end
end

return import