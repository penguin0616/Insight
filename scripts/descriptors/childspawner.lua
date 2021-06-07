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

-- childspawner.lua
local NO_NAME_PREFAB = "\"%s\""
local wsth = import("helpers/worldsettingstimer")

local function Describe(self, context)
	if not context.config["display_spawner_information"] then
		return
	end

	local description = nil

	local kids
	local emergency_kids
	local regen


	if self.childname and self.childname ~= "" then
		--[[
		kids = string.format("<color=MOB_SPAWN>%s</color>: %s / %s", -- %s<sub>inside</sub> + %s<sub>outside</sub> 
			GetPrefabNameOrElse(self.childname, NO_NAME_PREFAB), 
			self.childreninside + self.numchildrenoutside, 
			self.maxchildren
		)
		--]]
		
		kids = string.format(context.lstr.childspawner.children, -- %s<sub>inside</sub> + %s<sub>outside</sub> 
			self.childname, --GetPrefabNameOrElse(self.childname, NO_NAME_PREFAB), 
			self.childreninside, self.numchildrenoutside, 
			self.maxchildren
		)
		
	end

	if self.emergencychildname and self.emergencychildname ~= "" and self.maxemergencychildren > 0 then
		emergency_kids = string.format(context.lstr.childspawner.emergency_children, 
			self.emergencychildname, --GetPrefabNameOrElse(self.emergencychildname, NO_NAME_PREFAB),
			self.emergencychildreninside, self.numemergencychildrenoutside, 
			self.maxemergencychildren
		)
	end

	-- regenerating children
	if self.regening then
		local missingchildren = self.numchildrenoutside + self.childreninside < self.maxchildren
        local missingemergencychildren = self.numemergencychildrenoutside + self.emergencychildreninside < self.maxemergencychildren
        
		if (self.childname and self.childname ~= "" and missingchildren) or (self.emergencychildname and self.emergencychildname ~= "" and missingemergencychildren) then
			local to_regen = ""

			if missingchildren and missingemergencychildren then
				to_regen = string.format(context.lstr.childspawner.both_regen, 
					self.childname or "<color=#FF0000>ERROR</color>", --GetPrefabNameOrElse(self.childname, NO_NAME_PREFAB), 
					self.emergencychildname or "<color=#FF0000>ERROR</color>" --GetPrefabNameOrElse(self.emergencychildname, NO_NAME_PREFAB),
				)
			elseif missingchildren then
				to_regen = string.format(context.lstr.childspawner.entity, self.childname)
			elseif missingemergencychildren then
				to_regen = string.format(context.lstr.childspawner.entity, self.emergencychildname)
			end

			
			local regen_time
			
			if self.useexternaltimer then
				regen_time = self.inst.components.worldsettingstimer and self.inst.components.worldsettingstimer:GetTimeLeft(wsth.CHILDSPAWNER_REGENPERIOD_TIMERNAME)
			else
				regen_time = self.timetonextregen
				if self.task then -- lightflower_flower had the task running, but regen_time was 0 already. oh well.
					regen_time = regen_time + GetTaskRemaining(self.task)
				end
			end

			regen_time = regen_time and context.time:SimpleProcess(regen_time) or "?"
			--regen = string.format(context.lstr.childspawner.regenerating, to_regen, regen_time)
			regen = subfmt(context.lstr.childspawner.regenerating, { to_regen=to_regen, regen_time=regen_time })
		end
	end

	description = CombineLines(kids, emergency_kids, regen)

	return {
		priority = 1,
		description = description
	}
end



return {
	Describe = Describe
}