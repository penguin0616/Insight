local function Describe(self, context)
	local count = 0

	for key, value in pairs(self.active_treasure_hunt_markers) do
		count = count + 1
	end

	local description = string.format(context.lstr.messagebottlemanager, count, TUNING.MAX_ACTIVE_TREASURE_HUNTS)
	return {
		priority = 0,
		name = "treasure",
		description = description,
		worldly = true,
		icon = {
			atlas = "minimap/minimap_data.xml",
			tex = "messagebottletreasure_marker.png"
		},
	}
end

return { Describe = Describe }
