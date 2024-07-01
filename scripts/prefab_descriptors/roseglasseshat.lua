local function Describe(self, context)
	local player = context.player
	if not player or
		player.prefab ~= "winona" or
		not player.components.skilltreeupdater or
		not player.components.skilltreeupdater:IsActivated("winona_charlie_1") or
		not player.components.roseinspectableuser
	then
		return nil
	end

	if not player.components.roseinspectableuser.cooldowntask then
		return {
			priority = 0,
			name = "roseglasseshat",
			description = context.lstr.roseglasseshat.ready_to_use,
		}
	else
		return {
			priority = 0,
			name = "roseglasseshat",
			description = string.format(context.lstr.roseglasseshat.cooldown, context.time:SimpleProcess(GetTaskRemaining(player.components.roseinspectableuser.cooldowntask))),
		}
	end
end

return { Describe = Describe }
