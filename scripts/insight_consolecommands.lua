DST_CONSOLE_COMMANDS = {}

DST_CONSOLE_COMMANDS.i_gearup = function()
	c_give("orangestaff", 1)
	c_give("multitool_axe_pickaxe", 1)
	c_give("minerhat", 1)
end

-- TheSkillTree.skillxp.wathgrithr = 0; TheSkillTree:UpdateSaveState("wathgrithr")
DST_CONSOLE_COMMANDS.i_revealmap = function()
	-- Thanks to CarlZalph for his permission to include this very useful and mathematically superior map-reveal code!
	local r=25;local p=math.sqrt(3);local q=.5*p*r;local w,h=TheWorld.Map:GetSize();w=4*w;h=4*h;for _,v in pairs(AllPlayers) do for x=-w,w,3*r do for y=-h,h,2*q do v.player_classified.MapExplorer:RevealArea(x,0,y) end end for x=-w+q*p,w,2*q*p do for y=-h+q,h,2*q do v.player_classified.MapExplorer:RevealArea(x,0,y) end end end
end
DST_CONSOLE_COMMANDS.i_accelerate_rift = function(crystals)
	assert(TheWorld.ismastersim, "need to be mastersim")
	
	if TheWorld.worldprefab == "forest" then
		local portal = TheSim:FindFirstEntityWithTag("lunarrift_portal")
		if not portal then
			TheWorld.components.worldsettingstimer:SetTimeLeft("rift_spawn_timer", 10)
		else
			local timer = portal.components.timer
			if crystals then
				if timer:TimerExists("try_crystals") then
					timer:SetTimeLeft("try_crystals", 10)
				end
			else
				if timer:TimerExists("trynextstage") then
					timer:SetTimeLeft("trynextstage", 10)
				end
			end
		end
	elseif TheWorld.worldprefab == "cave" then
		local portal = TheSim:FindFirstEntityWithTag("shadowrift_portal")
		if not portal then
			TheWorld.components.worldsettingstimer:SetTimeLeft("rift_spawn_timer", 10)
		else
			local timer = portal.components.timer
			if crystals then
				
			else
				if timer:TimerExists("trynextstage") then
					timer:SetTimeLeft("trynextstage", 10)
				end
			end
		end
	end
end
DST_CONSOLE_COMMANDS.i_complete_plantregistry = function()
	assert(not TheWorld.ismastersim, "need to be client")
	reg = ThePlayer.components.plantregistryupdater.plantregistry;

	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS;
	for plant, data in pairs(PLANT_DEFS) do 
		if not data.is_randomseed and not data.modded then 
			for i in pairs(data.plantregistryinfo) do 
				reg:LearnPlantStage(plant, i);
			end;
		end;
	end;
	print("learned plants");

	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS;
	for weed, data in pairs(WEED_DEFS) do 
		if not data.modded then 
			for i in pairs(data.plantregistryinfo) do 
				reg:LearnPlantStage(weed, i);
			end;
		end;
	end;
	print("learned weeds");

	local FERTILIZER_DEFS = require("prefabs/fertilizer_nutrient_defs").FERTILIZER_DEFS;
	for fertilizer, data in pairs(FERTILIZER_DEFS) do 
		if not data.modded then
			reg:LearnFertilizer(fertilizer)
		end;
	end;
	print("learned fertilizers");
end

-- 0xa7, 0xa7
-- 0x4a, 0x4a
DST_CONSOLE_COMMANDS.i_doroll = function(rolls, max)
	assert(TheWorld.ismastersim, "need to be mastersim")
	local plr = InsightCommandPlayer()
	local tbl = TheNet:GetClientTableForUser(plr.userid)

	if type(rolls) == "number" then
		rolls = {rolls}
	end

	max = max or 100

	--Networking_RollAnnouncement(plr.userid, plr.name, plr.prefab, tbl.colour, rolls, max)
	--Networking_RollAnnouncement(ThePlayer.userid, "bob", "wilson", {.8, .31, .22, 1}, {1000}, 100)
	TheNet:Announce(
		string.format(STRINGS.UI.NOTIFICATION.DICEROLLED, ChatHistory:GetDisplayName(plr.name, plr.prefab), table.concat(rolls, ", "), max),
		nil,
		nil,
		"dice_roll"
	)
end

DST_CONSOLE_COMMANDS.i_moon_postern_stuff = function()
	assert(TheWorld.ismastersim, "need to be mastersim")
	local plr = InsightCommandPlayer()

	plr.components.inventory:GiveItem(SpawnPrefab("multiplayer_portal_moonrock_constr_plans"))
	plr.components.inventory:GiveItem(SpawnPrefab("moonrockcrater"))
	plr.components.inventory:GiveItem(SpawnPrefab("purplegem"))
	for i = 1, 20 do plr.components.inventory:GiveItem(SpawnPrefab("moonrocknugget")) end
	
end
DST_CONSOLE_COMMANDS.i_moon_altar_stuff = function()

	local offset = 7
	local pos = InsightCommandPlayer():GetPosition()
	local altar

	altar = SpawnPrefab("moon_altar")
	altar.Transform:SetPosition(pos.x, 0, pos.z - offset)
	altar:set_stage_fn(2)

	SpawnPrefab("moon_altar_idol").Transform:SetPosition(pos.x, 0, pos.z - offset - 2)

	altar = SpawnPrefab("moon_altar_astral")
	altar.Transform:SetPosition(pos.x - offset, 0, pos.z + offset / 3)
	altar:set_stage_fn(2)

	altar = SpawnPrefab("moon_altar_cosmic")
	altar.Transform:SetPosition(pos.x + offset, 0, pos.z + offset / 3)

	local bp = SpawnPrefab("moonstorm_goggleshat_blueprint")
	bp.Transform:SetPosition(pos.x, 0, pos.z + offset / 1.5)
	local bp2 = SpawnPrefab("moon_device_construction1_blueprint")
	bp2.Transform:SetPosition(pos.x, 0, pos.z - offset / 1.5)

	
	c_setsanity(0.5)
	c_maintainsanity(nil, 0.5)

	-- Incomplete Experiment (moon_device_construction1)
	c_give("moonstorm_static_item", 1)
	c_give("moonstorm_spark", 5)
	c_give("transistor", 2)

	-- Build 1
	c_give("moonstorm_static_item", 1)
	c_give("moonstorm_spark", 10)
	c_give("moonglass_charged", 10)

	-- Build 2
	c_give("moonstorm_static_item", 1)
	c_give("moonglass_charged", 20)

	local orb = c_findnext'moonrockseed'
	if not orb then
		orb = c_findnext'moon_rock_shell'
		if orb then
			orb:Remove()
		end
		c_give("moonrockseed", 1)
	else
		InsightCommandPlayer().components.inventoryitem:GiveItem(orb)
	end

	c_setabsorption(.99)
	c_setdamagemultiplier(25)
	c_give('nightsword')
	c_give('multitool_axe_pickaxe')
	c_give('minerhat')
end
DST_CONSOLE_COMMANDS.i_longtimer = function(inst, timer, delay)
	inst:LongUpdate(inst.components.timer:GetTimeLeft(timer) - (delay or 5))
end
DST_CONSOLE_COMMANDS.c_pwdgt = function()
	TheGlobalInstance:DoTaskInTime(2, function()
		local target = TheInput:GetHUDEntityUnderMouse()
		mprint(target, target and target.widget or nil)
	end)
end
DST_CONSOLE_COMMANDS.c_nopirates = function(kill)
	assert(TheWorld.ismastersim, "need to be mastersim")
	local fn = kill and c_killall or c_removeall
	fn("prime_mate")
	fn("powder_monkey")
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
	c_removeall "oceanhorror"
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
	InsightCommandPlayer().components.combat.damagemultiplier = n
end
DST_CONSOLE_COMMANDS.c_setabsorption = function(n)
	assert(TheWorld.ismastersim, "need to be mastersim")
	InsightCommandPlayer().components.health:SetAbsorptionAmount(n)
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
	InsightCommandPlayer():RemoveTag("debugnoattack")
end
DST_CONSOLE_COMMANDS.c_invremove = function(arg)
	assert(TheWorld.ismastersim, "need to be mastersim")
	local items = InsightCommandPlayer().components.inventory:GetItemByName(arg, 1)
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
	local plr = InsightCommandPlayer()
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
		InsightCommandPlayer().components.inventory:GiveItem(inst)
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
	local player = InsightCommandPlayer() --DebugKeyPlayer()
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
	local player = InsightCommandPlayer() --DebugKeyPlayer()
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
	local player = InsightCommandPlayer() --DebugKeyPlayer()
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
	local player = InsightCommandPlayer() --DebugKeyPlayer()
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

	local player = InsightCommandPlayer() --DebugKeyPlayer()
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
DS_CONSOLE_COMMANDS.c_nohounds = function()
	c_removeall "firehound"
	c_removeall "icehound"
	c_removeall "hound"
	c_removeall "crocodog"
	c_removeall "watercrocodog"
	c_removeall "poisoncrocodog"
end
DS_CONSOLE_COMMANDS.c_nextphase = function()
	GetClock():NextPhase()
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