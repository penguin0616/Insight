--- Called by the server to check scan information.
local function DoWx78ScannerNetworking(inst)
	if inst._donescanning or inst._scantime == nil then
		inst.insight_scan_progress:set(-1)
		return
	end
	
	local target = inst.components.entitytracker:GetEntity("scantarget")
	if target ~= nil and inst._scantime then
		local target_time = (target:HasTag("epic") and TUNING.WX78_SCANNER_MODULETARGETSCANTIME_EPIC) or TUNING.WX78_SCANNER_MODULETARGETSCANTIME
		inst.insight_scan_progress:set(inst._scantime / target_time)
	end
end

local function SERVER_OnWX78ScannerSpawned(inst)
	inst.insight_scan_progress = net_float(inst.GUID, "insight_scan_progress", "insight_scan_progress_dirty")
	inst.components.updatelooper:AddOnUpdateFn(DoWx78ScannerNetworking)
end

local function CLIENT_OnWX78ScannerSpawned(inst)
	if not inst.insight_scan_progress then -- Don't duplicate netvar if client host or context update happens
		inst.insight_scan_progress = net_float(inst.GUID, "insight_scan_progress", "insight_scan_progress_dirty")
	end

	OnLocalPlayerPostInit:AddWeakListener(function()
		if localPlayer:HasTag("upgrademoduleowner") and inst._insight_scan_label == nil then
			local label = inst.entity:AddLabel()
			if not label then
				-- TODO: Ask a dev to see what cases this would return nil in.
				return
			end
			label:SetWorldOffset(0, 1, 0)
			label:SetFont(CHATFONT_OUTLINE)
			label:SetFontSize(18)
			label:Enable(false)
			label:SetText("")
			
			inst._insight_scan_label = label

			inst:ListenForEvent("insight_scan_progress_dirty", function(inst)
				local context = GetPlayerContext(localPlayer)
				local val = inst.insight_scan_progress:value()

				if not context.config["wx78_scanner_info"] or val < 0 then
					label:SetText("")
					label:Enable(false);
				elseif val > 0 then
					label:Enable(true)
					label:SetText(string.format(context.lstr.wx78_scanner.scan_progress, val * 100))
				end
			end)
		end
	end)
end

local function OnServerInit()
	if not IS_DST then return end

	AddPrefabPostInit("wx78_scanner", SERVER_OnWX78ScannerSpawned)
end

local function OnClientInit()
	if not IS_DST then return end

	entity_tracker:TrackPrefab("wx78_scanner")
	AddPrefabPostInit("wx78_scanner", CLIENT_OnWX78ScannerSpawned)

	OnContextUpdate:AddListener("wx78_scanner", function(context)
		for i,v in pairs(entity_tracker:GetInstancesOf("wx78_scanner")) do
			CLIENT_OnWX78ScannerSpawned(v)
		end
	end)
end

return {
	OnServerInit = OnServerInit,
	OnClientInit = OnClientInit,
}
