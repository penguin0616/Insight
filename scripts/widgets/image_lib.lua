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

local Image = require("widgets/image")

local lib = {}

lib.Initialize = function()
	-- Image.SetTexture gets replaced, December 5, 2020: ([DST]HD Item Icon - Shang) https://steamcommunity.com/sharedfiles/filedetails/?id=2260439333
	-- then i realized other mods, such as the reskinners, do the same thing.
	-- oh boy.
	-- honestly, if i ever make another mod of this complexity, i'm going to have to package all of my patches and hacks to deal with other mods into a library of its own. how lovely.
	-- plus, it's really irritating i have to skip the syntatic sugar of : 

	-- omg why didn't i think of this sooner
	local DummyImage = loadfile("scripts/widgets/image.lua")()
	lib.SetTexture = DummyImage.SetTexture
	DummyImage = nil

	--[[
	if KnownModIndex:IsModEnabled("workshop-2260439333") then
		print("[DST]HD Item Icon - Shang is active, finding real Image::SetTexture")
		local info = debug.getinfo(Image.SetTexture, "S")

		local real_SetTexture = getfenv(Image.SetTexture).SetTexture_old

		if not real_SetTexture then
			print("\tUnable to find the real SetTexture.")
			print(debug.getinfo(Image.SetTexture, "S").source)
			error("Unknown mod has modified Image::SetTexture")
			return
		end
	end
	--]]

	--[[
	local original_source = debug.getinfo(Image.SetTexture, "S")
	if original_source.source ~= "scripts/widgets/image.lua" then
		print("Insight ImageLib: SetTexture has been replaced. Source:", original_source.source)
		--util.recursive_getupvalue(Image.SetTexture, function(_, v) return debug.getinfo(v.SetTexture, "S").source == "scripts/widgets/image.lua" end) 

		if getfenv(Image.SetTexture).SetTexture_old then
			-- Image.SetTexture gets replaced, December 5, 2020: ([DST]HD Item Icon - Shang) https://steamcommunity.com/sharedfiles/filedetails/?id=2260439333
			lib.SetTexture = getfenv(Image.SetTexture).SetTexture_old
		else
			for i,v in pairs(util.recursive_getupvalues(Image.SetTexture)) do
				if type(v.value) == "function" and debug.getinfo(v.value, "S").source == "scripts/widgets/image.lua" then
					print("\tImageLib: Found real SetTexture")
					lib.SetTexture = v.value
					break
				end
			end
		end

		if not lib.SetTexture then
			error("[Insight]: Image::SetTexture has been tampered with.")
		end
	else
		lib.SetTexture = Image.SetTexture
	end
	--]]
end


lib.Initialize()
return lib