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

-- oceanfishingrod.lua
-- oceanfishingrod:SetTarget() called by OceanFishable:SetRod() called by 
--[[
	Fishing process:
	1. Place oceanfishingbobber in rod
	2. Place oceanfishinglure in rod
	3. Cast line (rod.target = projectile)
	4. oceanfishinghook is spawned at landed pos (rod.target = "oceanfishingbobber_none_floater") (hook has oceanfishable component)
		-- hook is irrelevant to lure in terms of rod.target
	5. wait until something happens
	6. when fish takes the bait (rod.target = fish)
]]

-- oceanfishinghook's reelmod is 0 until the first reel and then lerps from 1 to 0 over a rather long time

--[[
local function OnClientInit()
	if not IS_DST then return end

	OnLocalPlayerPostInit:AddListener("oceanfishingrod_rodlistener", function()
		
	end)
end
--]]

--[[
local function Describe(self, context)
	local description = tostring(self.target) .. " | "

	local target = self.target
	if target and target.components.oceanfishinghook then
		local hook = target.components.oceanfishinghook
		local str = tostring(hook.reel_mod)
		description = CombineLines(description, str)
	end

	local tackle_data = self.gettackledatafn ~= nil and self.gettackledatafn(self.inst) or nil
	if tackle_data then
		local lure_data = tackle_data.lure and tackle_data.lure.components.oceanfishingtackle and tackle_data.lure.components.oceanfishingtackle.lure_data
		if lure_data then

		end
	end
	

	return {
		priority = 0,
		description = description
	}
end
--]]



return {
	Describe = Describe
}