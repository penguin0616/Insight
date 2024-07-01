local function Describe(self, context)
	local player = context.player
	if not player or
		player.prefab ~= "winona" or
		not player.components.skilltreeupdater or
		not player.components.skilltreeupdater:IsActivated("winona_wagstaff_1") or
		not player.components.inspectaclesparticipant
	then
		return nil
	end

	if not player.components.inspectaclesparticipant.cooldowntask then
		return {
			priority = 0,
			name = "inspectacleshat",
			description = context.lstr.inspectacleshat.ready_to_use,
		}
	else
		return {
			priority = 0,
			name = "inspectacleshat",
			description = string.format(context.lstr.inspectacleshat.cooldown, context.time:SimpleProcess(GetTaskRemaining(player.components.inspectaclesparticipant.cooldowntask))),
		}
	end
end

return { Describe = Describe }
