-- riftspawner.lua
local RIFTSPAWN_TIMERNAME = "rift_spawn_timer"

local function GetCrystalCount(_crystals)
	local count = 0
	if _crystals ~= nil then
		for k, v in pairs(_crystals) do
			if not k:IsInLimbo() then
				count = count + 1
			end
		end
	end
	return count
end
local function Describe(inst, context)
	local descriptions = {}

	if inst.rifts then
		for key, value in pairs(inst.rifts) do
			if value == "lunarrift_portal" then
				local description = string.format(context.lstr.riftspawner.stage, key._stage, TUNING.RIFT_LUNAR1_MAXSTAGE)

				if key._stage < TUNING.RIFT_LUNAR1_MAXSTAGE and key.components.timer:TimerExists("trynextstage") then
					description = description .. ". " .. string.format(context.lstr.riftspawner.next_stage, context.time:SimpleProcess(key.components.timer:GetTimeLeft("trynextstage")))
				end
				if key._stage >= TUNING.RIFT_LUNAR1_MAXSTAGE then
					description = description .. ". " .. string.format(context.lstr.riftspawner.lunarrift.max_stage)
				end
				local count = GetCrystalCount(key._crystals)
				if count > 0 then
					description = description .. "\n" .. string.format(context.lstr.riftspawner.lunarrift.crystals, count)
				end
				descriptions[#descriptions + 1] = {
					name = string.format("%d", key.GUID),
					priority = 100,
					description = description,
					icon = {
						atlas = "minimap/minimap_data.xml",
						tex = "lunarrift_portal.png",
					},
					worldly = true,
				}
			end
			if value == "shadowrift_portal" then
				local description = string.format(context.lstr.riftspawner.stage, key._stage, TUNING.RIFT_SHADOW1_MAXSTAGE)

				if key._stage < TUNING.RIFT_SHADOW1_MAXSTAGE and key.components.timer:TimerExists("trynextstage") then
					description = description .. ". " .. string.format(context.lstr.riftspawner.next_stage, context.time:SimpleProcess(key.components.timer:GetTimeLeft("trynextstage")))
				end
				if key._stage >= TUNING.RIFT_SHADOW1_MAXSTAGE and key.components.timer:TimerExists("close") then
					description = description .. ". " .. string.format(context.lstr.riftspawner.shadowrift.max_stage, context.time:SimpleProcess(key.components.timer:GetTimeLeft("close")))
				end

				if TheWorld.components.shadowthrallmanager then
					local manager = TheWorld.components.shadowthrallmanager
					local t = GetTime()
					local cooldown = util.getupvalue(TheWorld.components.shadowthrallmanager.OnSave, "_internal_cooldown")
					if manager:GetControlledFissure() ~= nil then
						description = description .. "\n" .. string.format(context.lstr.riftspawner.shadowrift.thralls, manager:GetThrallCount())
					elseif type(cooldown) == "number" and cooldown > t then
						description = description .. "\n" .. string.format(context.lstr.riftspawner.shadowrift.next_fissure, context.time:SimpleProcess(cooldown - t))
					end
				end

				descriptions[#descriptions + 1] = {
					name = string.format("%d", key.GUID),
					priority = 100,
					description = description,
					icon = {
						atlas = "minimap/minimap_data.xml",
						tex = "shadowrift_portal.png",
					},
					worldly = true,
				}
			end
		end
	end
	if inst._worldsettingstimer:ActiveTimerExists(RIFTSPAWN_TIMERNAME) then
		if inst.spawnmode ~= 1 and inst.rifts_count < TUNING.MAXIMUM_RIFTS_COUNT then
			local imageTex = (TheWorld.worldprefab == "forest" and "lunarrift_portal.png") or (TheWorld.worldprefab == "cave" and "shadowrift_portal.png") or nil
			if imageTex then
				descriptions[#descriptions + 1] = {
					name = "rift_portal_left",
					priority = 100,
					description = string.format(context.lstr.riftspawner.spawning, context.time:SimpleProcess(inst._worldsettingstimer:GetTimeLeft(RIFTSPAWN_TIMERNAME))),
					icon = {
						atlas = "minimap/minimap_data.xml",
						tex = imageTex,
					},
					worldly = true,
				}
			end
		end
	end
	return unpack(descriptions)
end

return {
	Describe = Describe,
}
