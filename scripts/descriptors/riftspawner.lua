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
		end
	end
	if inst._worldsettingstimer:ActiveTimerExists(RIFTSPAWN_TIMERNAME) then
		if inst.spawnmode ~= 1 and inst.rifts_count < TUNING.MAXIMUM_RIFTS_COUNT then
			descriptions[#descriptions + 1] = {
				name = "lunarrift_portal_left",
				priority = 100,
				description = string.format(context.lstr.riftspawner.spawning, context.time:SimpleProcess(inst._worldsettingstimer:GetTimeLeft(RIFTSPAWN_TIMERNAME))),
				icon = {
					atlas = "minimap/minimap_data.xml",
					tex = "lunarrift_portal.png",
				},
				worldly = true,
			}
		end
	end
	return unpack(descriptions)
end

return {
	Describe = Describe,
}
