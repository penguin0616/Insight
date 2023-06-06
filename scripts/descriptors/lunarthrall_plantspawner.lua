-- lunarthrall_plantspawner.lua
local function Describe(inst, context)
	local self = inst
	local count = entity_tracker:CountInstancesOf("lunarthrall_plant")
	if count == 0 and not self.waves_to_release then
		return
	end

	local description = string.format(context.lstr.lunarthrall_plantspawner.infested_count, count)
	if self._nextspawn then
		description = description .. ". " .. string.format(context.lstr.lunarthrall_plantspawner.spawn, context.time:SimpleProcess(GetTaskRemaining(self._nextspawn)))
	elseif self._spawntask then
		description = description .. ". " .. string.format(context.lstr.lunarthrall_plantspawner.next_wave, context.time:SimpleProcess(GetTaskRemaining(self._spawntask)))
	end
	if self.waves_to_release and self.waves_to_release > 0 then
		description = description .. "\n" .. string.format(context.lstr.lunarthrall_plantspawner.remain_waves, self.waves_to_release)
	end

	return {
		priority = 80,
		description = description,
		icon = {
			atlas = "minimap/minimap_data.xml",
			tex = "lunarthrall_plant.png",
		},
		worldly = true,
	}
end

return {
	Describe = Describe
}
