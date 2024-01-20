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

-- winter_ornaments.lua [Prefab]

-- This is a funny one in that there's no prefab with this actual name, but it's a helper for the winter_ornaments prefab file.
-- Which does one of those Prefab wrappers for defining a bunch of ornaments.

local ORNAMENT_DATA = {}
local ornaments_loaded = false

local SIGNIFICANT_DATA = {"ornamentid", "overridename", "lightdata", "build", "float_scale"}

local function LoadOrnaments()
	if not IS_DST then
		return
	end

	if ornaments_loaded then
		return
	end

	ornaments_loaded = true

	local exec = loadfile("scripts/prefabs/winter_ornaments.lua")
	if type(exec) ~= "function" then
		mprint("Failed to loadfile on ornament data")
		return
	end

	local env = setmetatable({
		Prefab = function(prefab, constructor, assets, ...)
			-- ornamentid, overridename, lightdata, build, float_scale
			
			-- I guess I could also just set it equal to util.getupvalues(constructor)
			ORNAMENT_DATA[prefab] = {}
			for i,v in pairs(SIGNIFICANT_DATA) do
				ORNAMENT_DATA[prefab][v] = util.getupvalue(constructor, v)
			end

			return {...}
		end,
		Asset = function(...)
			return {}
		end
	}, {__index=Insight.env})

	setfenv(exec, env)
	exec()
end

return {
	OnServerInit = LoadOrnaments,
	OnClientInit = LoadOrnaments,

	ORNAMENT_DATA = ORNAMENT_DATA
}