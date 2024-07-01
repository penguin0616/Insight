local spawn_task
if TheWorld.components.flotsamgenerator and TheWorld.components.flotsamgenerator.ScheduleGuaranteedSpawn then
	spawn_task = util.getupvalue(TheWorld.components.flotsamgenerator.ScheduleGuaranteedSpawn, "_guaranteed_spawn_tasks")
end

local function Describe(self, context)
	local descriptions = {}
	if spawn_task then
		for p, tasks in pairs(spawn_task) do
			for v, task in pairs(tasks) do
				if v.prefabs[1] == "messagebottle" then
					table.insert(descriptions, {
						priority = 0,
						name = "flotsam-" .. p.userid .. "-messagebottle",
						description = string.format(context.lstr.flotsamgenerator.messagebottle_cooldown, p.name,
							context.time:SimpleProcess(GetTaskRemaining(task))),
						icon = {
							atlas = "images/inventoryimages2.xml",
							tex = "messagebottle.tex"
						},
					})
				end
			end
		end
	end

	return unpack(descriptions)
end

return { Describe = Describe }
