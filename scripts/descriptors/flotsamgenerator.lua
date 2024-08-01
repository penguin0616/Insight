local spawn_task
if TheWorld.components.flotsamgenerator and TheWorld.components.flotsamgenerator.ScheduleGuaranteedSpawn then
	spawn_task = util.getupvalue(TheWorld.components.flotsamgenerator.ScheduleGuaranteedSpawn, "_guaranteed_spawn_tasks")
end

local function DescribeMessageBottle(context, player, task)
	return {
		priority = 0,
		worldly = true,
		playerly = true,
		name = "flotsam-" .. player.userid .. "-messagebottle",
		description = string.format(context.lstr.flotsamgenerator.messagebottle_cooldown,
			context.time:SimpleProcess(GetTaskRemaining(task))),
		icon = {
			atlas = "images/inventoryimages2.xml",
			tex = "messagebottle.tex"
		},
	}
end

local function Describe(self, context)
	if not spawn_task then
		return
	end
	local descriptions = {}
	-- spawn_task: { player -> { preset -> Task } }
	for p, tasks in pairs(spawn_task) do
		-- tasks: { preset -> Task }
		for v, task in pairs(tasks) do
			if v.prefabs[1] == "messagebottle" then
				table.insert(descriptions, DescribeMessageBottle(context, p, task))
			end
		end
	end

	return unpack(descriptions)
end

return { Describe = Describe }