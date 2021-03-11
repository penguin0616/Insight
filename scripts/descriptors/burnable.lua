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

-- burnable.lua
local FIRE_TAGS = { "fire" }
local function sanityfn(inst, target) -- inst is player
	local delta = 0
	if IsDST() and inst.components.temperature:IsFreezing() then
		delta = -TUNING.SANITYAURA_LARGE
	end

    local x, y, z = inst.Transform:GetWorldPosition() 
    local max_rad = 10
	--local ents = TheSim:FindEntities(x, y, z, max_rad, FIRE_TAGS)
	local ents = {target}
	for i, v in ipairs(ents) do
		local isBurning = false

		if v.components.burnable then
			if IsDST() then
				isBurning = v.components.burnable:IsBurning()
			else
				isBurning = v.components.burnable.burning
			end
		end

        if isBurning then
            local rad = v.components.burnable:GetLargestLightRadius() or 1
			local sz = TUNING.SANITYAURA_TINY
			sz = sz * math.min(max_rad, rad) / max_rad
			local distsq = inst:GetDistanceSqToInst(v)

			if IsDST() then
				-- shift the value so that a distance of 3 is the minimum
				distsq = distsq - 9
			end

            delta = delta + sz / math.max(1, distsq)
        end
    end
    return delta
end

local function Describe(self, context)
	local description, sanityaura = nil, nil

	if self.smoldering and self.smoldertimeremaining and self.smolder_task then
		description = string.format(context.lstr.burnable.smolder_time, Round(self.smoldertimeremaining + 0, 1)) -- task inconsistent meeeh
	elseif self.burning and self.task then
		description = string.format(context.lstr.burnable.burn_time, Round(GetTaskRemaining(self.task), 1))
	end


	if context.player.prefab == "willow" then -- willow only
		--mprint(delta, delta * 60) 
		local delta = sanityfn(context.player, self.inst)
		if delta >= 0.01 or delta <= -0.01 then -- has to be at least 0.01 to get picked up by Sanity
			if self.inst.components.inventoryitem then -- self.inst.prefab == "lighter"
				context.burnable_sanity_aura_round = 1
			else
				delta = Round(delta, 2)
			end

			context.burnable_sanity_aura = delta
			sanityaura = Insight.descriptors.sanityaura.Describe(self, context)
		end
	end

	

	return {
		name = "burnable",
		priority = 0,
		description = description
	}, sanityaura
end



return {
	Describe = Describe
}