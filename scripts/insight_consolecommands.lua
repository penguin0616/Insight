DST_CONSOLE_COMMANDS = {}
DST_CONSOLE_COMMANDS.c_pwdgt = function()
	TheGlobalInstance:DoTaskInTime(2, function()
		local target = TheInput:GetHUDEntityUnderMouse()
		mprint(target, target and target.widget or nil)
	end)
end

DST_CONSOLE_COMMANDS.c_nohounds = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	c_removeall "firehound"
	c_removeall "icehound"
	c_removeall "hound"
end
DST_CONSOLE_COMMANDS.c_nowagbirds = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	c_removeall "bird_mutant"
	c_removeall "bird_mutant_spitter"
end
DST_CONSOLE_COMMANDS.c_noshadows = function(x)
	assert(TheWorld.ismastersim, "need to be mastersim")
	c_removeall "terrorbeak"
	c_removeall "crawlinghorror"
	if x then
		c_removeall "nightmarebeak"
		c_removeall "crawlingnightmare"
	end
end
DST_CONSOLE_COMMANDS.c_rain = function(bool)
	assert(TheWorld.ismastersim, "need to be mastersim")
	TheWorld:PushEvent("ms_forceprecipitation", bool)
end
DST_CONSOLE_COMMANDS.c_lightning = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	TheWorld:PushEvent("ms_sendlightningstrike", ConsoleWorldPosition())
end
DST_CONSOLE_COMMANDS.c_nextnightmarephase = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	TheWorld:PushEvent("ms_nextnightmarephase")
end
DST_CONSOLE_COMMANDS.c_nextphase = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	TheWorld:PushEvent("ms_nextphase")
end
DST_CONSOLE_COMMANDS.c_nextday = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	TheWorld:PushEvent("ms_nextcycle")
end
DST_CONSOLE_COMMANDS.c_setdamagemultiplier = function(n)
	assert(TheWorld.ismastersim, "need to be mastersim")
	ConsoleCommandPlayer().components.combat.damagemultiplier = n
end
DST_CONSOLE_COMMANDS.c_setabsorption = function(n)
	assert(TheWorld.ismastersim, "need to be mastersim")
	ConsoleCommandPlayer().components.health:SetAbsorptionAmount(n)
end
DST_CONSOLE_COMMANDS.c_kill = function(inst)
	assert(TheWorld.ismastersim, "need to be mastersim")
	if inst and inst.components.health then
		inst.components.health:Kill()
		print "killed"
	else
		print("Failed to kill:", inst)
	end
end
DST_CONSOLE_COMMANDS.c_makevisible = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	ConsoleCommandPlayer():RemoveTag("debugnoattack")
end
DST_CONSOLE_COMMANDS.c_invremove = function(arg)
	assert(TheWorld.ismastersim, "need to be mastersim")
	local items = ConsoleCommandPlayer().components.inventory:GetItemByName(arg, 1)
	local item = next(items)
	if item then
		item:Remove()
	else
		mrint("item", arg, "does not exist in inventory")
	end
end
DST_CONSOLE_COMMANDS.c_chester = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	c_gonext "chester_eyebone"
end
DST_CONSOLE_COMMANDS.c_hutch = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	c_gonext "hutch_fishbowl"
end
DST_CONSOLE_COMMANDS.c_makeglommer = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	local f = c_spawn "glommerflower"
	local g = c_spawn "glommer"
	g.components.follower:SetLeader(f)
	return g
end
DST_CONSOLE_COMMANDS.c_say = function(...)
	TheNet:Say(tostring(...))
end
DST_CONSOLE_COMMANDS.c_setseason = function(season)
	assert(TheWorld.ismastersim, "need to be mastersim")
	TheWorld:PushEvent("ms_setseason", season)
end
DST_CONSOLE_COMMANDS.c_insight_countactives = function()
	local plr = ConsoleCommandPlayer()
	local str =
		string.format("Replica: %s, Manager: %s", GetInsight(plr):CountEntities(), _G.Insight.env.entityManager:Count())
	if TheWorld.ismastersim then
		TheNet:Announce(str)
	else
		print(str)
	end
end
DST_CONSOLE_COMMANDS.c_pickupgems = function()
	for i, v in pairs({"purple", "blue", "red", "orange", "yellow", "green", "opalprecious"}) do
		c_pickupall(v .. "gem")
	end
end
DST_CONSOLE_COMMANDS.c_goportal = function(n)
	for i, v in pairs(Ents) do
		if
			(v.prefab == "cave_entrance" or v.prefab == "cave_entrance_open" or v.prefab == "cave_exit") and
				v.components.worldmigrator.id == n
		 then
			c_goto(v)
			break
		end
	end
end

DST_CONSOLE_COMMANDS.c_setgiftday = function(n)
	assert(TheWorld.ismastersim, "need to be mastersim")
	ThePlayer.components.wintertreegiftable.previousgiftday = n
end

DST_CONSOLE_COMMANDS.c_killall = function(prefab)
	assert(TheWorld.ismastersim, "need to be mastersim")
	for k, ent in pairs(Ents) do
		if ent.prefab == prefab and ent.components.health then
			c_kill(ent)
		end
	end
end

DST_CONSOLE_COMMANDS.c_bring = function(inst)
	assert(TheWorld.ismastersim, "need to be mastersim")
	if
		(inst.components.inventoryitem and not inst.components.inventoryitem:GetGrandOwner()) or
			not inst.components.inventoryitem
	 then
		c_move(inst)
	end
end
DST_CONSOLE_COMMANDS.c_bringall = function(prefab)
	assert(TheWorld.ismastersim, "need to be mastersim")
	for k, ent in pairs(Ents) do
		if ent.prefab == prefab then
			c_bring(ent)
		end
	end
end

DST_CONSOLE_COMMANDS.c_pickup = function(inst)
	assert(TheWorld.ismastersim, "need to be mastersim")
	if inst.components.inventoryitem and not inst.components.inventoryitem:GetGrandOwner() then
		ConsoleCommandPlayer().components.inventory:GiveItem(inst)
	else
		print(inst, "is not able to be held")
	end
end

DST_CONSOLE_COMMANDS.c_pickupall = function(prefab)
	assert(TheWorld.ismastersim, "need to be mastersim")
	for k, ent in pairs(Ents) do
		if ent.prefab == prefab and ent.components.inventoryitem and not ent.components.inventoryitem:GetGrandOwner() then
			c_pickup(ent)
		end
	end
end

DST_CONSOLE_COMMANDS.c_prefabring = function(prefab)
	assert(TheWorld.ismastersim, "need to be mastersim")
	local items = {prefab} --Which items spawn.
	local player = ConsoleCommandPlayer() --DebugKeyPlayer()
	if player == nil then
		return true
	end
	local pt = Vector3(player.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	local numrings = 10 --How many rings of stuff you spawn
	local radius = 2 --Initial distance from player
	local radius_step_distance = 1 --How much the radius increases per ring.
	local itemdensity = 1 --(X items per unit)
	local map = TheWorld.Map

	local finalRad = (radius + (radius_step_distance * numrings))
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, finalRad + 2)

	local numspawned = 0
	-- Walk the circle trying to find a valid spawn point
	for i = 1, numrings do
		local circ = 2 * PI * radius
		local numitems = circ * itemdensity

		for i = 1, numitems do
			numspawned = numspawned + 1
			local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
			local wander_point = pt + offset

			if map:IsPassableAtPoint(wander_point:Get()) then
				local spawn = SpawnPrefab(GetRandomItem(items))
				spawn.Transform:SetPosition(wander_point:Get())
			end
			theta = theta - (2 * PI / numitems)
		end
		radius = radius + radius_step_distance
	end
	print("Made: " .. numspawned .. " items")
	return true
end

DST_CONSOLE_COMMANDS.c_flowerring = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	local items = {"flower"} --Which items spawn.
	local player = ConsoleCommandPlayer() --DebugKeyPlayer()
	if player == nil then
		return true
	end
	local pt = Vector3(player.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	local numrings = 10 --How many rings of stuff you spawn
	local radius = 2 --Initial distance from player
	local radius_step_distance = 1 --How much the radius increases per ring.
	local itemdensity = 1 --(X items per unit)
	local map = TheWorld.Map

	local finalRad = (radius + (radius_step_distance * numrings))
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, finalRad + 2)

	local numspawned = 0
	-- Walk the circle trying to find a valid spawn point
	for i = 1, numrings do
		local circ = 2 * PI * radius
		local numitems = circ * itemdensity

		for i = 1, numitems do
			numspawned = numspawned + 1
			local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
			local wander_point = pt + offset

			if map:IsPassableAtPoint(wander_point:Get()) then
				local spawn = SpawnPrefab(GetRandomItem(items))
				spawn.Transform:SetPosition(wander_point:Get())
			end
			theta = theta - (2 * PI / numitems)
		end
		radius = radius + radius_step_distance
	end
	print("Made: " .. numspawned .. " items")
	return true
end

DST_CONSOLE_COMMANDS.c_chestring = function(prefabs)
	assert(TheWorld.ismastersim, "need to be mastersim")
	local items = {"treasurechest"} --Which items spawn.
	local player = ConsoleCommandPlayer() --DebugKeyPlayer()
	if player == nil then
		return true
	end
	local pt = Vector3(player.Transform:GetWorldPosition())
	local theta = math.random() * 2 * PI
	local numrings = 10 --How many rings of stuff you spawn
	local radius = 2 --Initial distance from player
	local radius_step_distance = 1.5 --How much the radius increases per ring.
	local itemdensity = 1 --(X items per unit)
	local map = TheWorld.Map

	local finalRad = (radius + (radius_step_distance * numrings))
	local ents = TheSim:FindEntities(pt.x, pt.y, pt.z, finalRad + 2)

	local numspawned = 0
	-- Walk the circle trying to find a valid spawn point
	for i = 1, numrings do
		local circ = 2 * PI * radius
		local numitems = circ * itemdensity

		for i = 1, numitems do
			numspawned = numspawned + 1
			local offset = Vector3(radius * math.cos(theta), 0, -radius * math.sin(theta))
			local wander_point = pt + offset

			if map:IsPassableAtPoint(wander_point:Get()) then
				local spawn = SpawnPrefab(GetRandomItem(items))
				spawn.Transform:SetPosition(wander_point:Get())
				if prefabs then
					for _, b in pairs(prefabs) do
						spawn.components.container:GiveItem(SpawnPrefab(b))
					end
				end
			end
			theta = theta - (2 * PI / numitems)
		end
		radius = radius + radius_step_distance
	end
	print("Made: " .. numspawned .. " items")
	return true
end

DST_CONSOLE_COMMANDS.c_bringmarbles = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	local player = ConsoleCommandPlayer() --DebugKeyPlayer()
	if player == nil then
		return true
	end

	local pieces = {"chesspiece_rook", "chesspiece_knight", "chesspiece_bishop"}
	local center = Vector3(player.Transform:GetWorldPosition())
	local radius = 5

	local max = PI * 2
	local increment = max / 3

	-- starting at 0 = bad since pi*2 and 0 have the same pos
	-- my trig is coming back to me, slowly
	for i = increment, max, increment do
		local item = c_findnext(table.remove(pieces, 1))

		local new_pos = center + Vector3(radius * math.cos(i), 0, -radius * math.sin(i))

		item.Transform:SetPosition(new_pos:Get())
	end

	return true
end

DST_CONSOLE_COMMANDS.c_selectall = function(...)
	local prefabs = table.invert({...})

	local entities = {}
	for i, v in pairs(Ents) do
		--if v.prefab == prefab then
		if prefabs[v.prefab] then
			table.insert(entities, v)
		end
	end

	return entities
end

DST_CONSOLE_COMMANDS.c_formcircle = function(list, params)
	assert(TheWorld.ismastersim, "need to be mastersim")

	assert(type(list) == "table")
	params = (type(params) == "table" and params) or {}

	local player = ConsoleCommandPlayer() --DebugKeyPlayer()
	if player == nil then
		return true
	end

	if params.radius then
		print("Using params.radius =", params.radius)
	end

	if params.center then
		print("Using params.center =", params.center)
	end

	local max = PI * 2
	local increment = max / #list
	local center = params.center or player
	center = Vector3(center.Transform:GetWorldPosition())
	local radius = params.radius or (1 + 1 * #list)

	for i = 1, #list do
		local x = i * increment
		local new_pos = center + Vector3(radius * math.cos(x), 0, -radius * math.sin(x))

		list[i].Transform:SetPosition(new_pos:Get())
	end
end
--[[
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
	======================================================================================================================================================
]]

DS_CONSOLE_COMMANDS = {}
DS_CONSOLE_COMMANDS.c_supergodmode = function()
	c_sethunger(1)
	c_setsanity(1)
	c_sethealth(1)
	c_godmode()
end

DS_CONSOLE_COMMANDS.c_revealmap = function()
	GetWorld().minimap.MiniMap:ShowArea(0, 0, 0, 10000)
end

DS_CONSOLE_COMMANDS.c_save = function()
	SaveGameIndex:SaveCurrent()
end
DS_CONSOLE_COMMANDS.c_reset = function()
	TheSim:Reset()
end

DS_CONSOLE_COMMANDS.c_nextday = function()
	GetClock():MakeNextDay()
end
DS_CONSOLE_COMMANDS.c_tools = function()
	c_give("multitool_axe_pickaxe")
	c_give("nightsword", 2)
	c_give("fireflies", 5)
	c_give("minerhat", 1)
end
DS_CONSOLE_COMMANDS.c_lightning = function()
	GetSeasonManager():DoLightningStrike(TheInput:GetWorldPosition():Get())
end

DS_CONSOLE_COMMANDS.c_spawntest = function()
	-- eehhhhh
	local to_spawn = {
		"deerclops",
		"bearger",
		"beefalo",
		"spiderden_2",
		"meatrack",
		"pond",
		"firepit",
		"fast_farmplot",
		"beebox",
		"beemine",
		"saddle_basic"
	}
	local to_give = {
		"armormarble",
		"brush",
		"walrushat",
		"bonestew",
		"meat",
		"nightsword",
		"cane",
		"poop",
		"multitool_axe_pickaxe",
		"fishingrod"
	}

	local spawned = {}
	for i, v in pairs(to_spawn) do
		table.insert(spawned, SpawnPrefab(v))
	end

	DS_CONSOLE_COMMANDS.c_formcircle(spawned, {radius = 2 * #spawned})

	for i, v in pairs(to_give) do
		c_give(v)
	end
end

DS_CONSOLE_COMMANDS.c_formcircle = function(list, params)
	assert(type(list) == "table")
	params = (type(params) == "table" and params) or {}

	local player = GetPlayer()
	if player == nil then
		return true
	end

	if params.radius then
		print("Using params.radius =", params.radius)
	end

	if params.center then
		print("Using params.center =", params.center)
	end

	local max = PI * 2
	local increment = max / #list
	local center = params.center or player
	center = Vector3(center.Transform:GetWorldPosition())
	local radius = params.radius or (1 + 1 * #list)

	for i = 1, #list do
		local x = i * increment
		local new_pos = center + Vector3(radius * math.cos(x), 0, -radius * math.sin(x))

		list[i].Transform:SetPosition(new_pos:Get())
	end
end

return { DST_CONSOLE_COMMANDS, DS_CONSOLE_COMMANDS }