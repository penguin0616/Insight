--[[
Copyright (C) 2020, 2021 penguin0616

This file is part of Insight.

The source code of this program is shared under the RECEX
SHARED SOURCE LICENSE (version 1.0).
The source code is shared for referrence and academic purposes
with the hope that people can read and learn from it. This is not
Free and Open Source software, and code is not redistributable
without permission of the author. Read the RECEX SHARED
SOURCE LICENSE for details
The source codes does not come with any warranty including
the implied warranty of merchandise.
You should have received a copy of the RECEX SHARED SOURCE
LICENSE in the form of a LICENSE file in the root of the source
directory. If not, please refer to
<https://raw.githubusercontent.com/Recex/Licenses/master/SharedSourceLicense/LICENSE.txt>
]]

local CrashReporter = {
	initialized = false,
	triggered = false,
	sending = false,
	-- Used for cross shard checks.
	server_owner_optin = false,
	STATUS = {
		UNDEFINED = 0,
		INFO = 1,
		SUCCESS = 2,
		ERROR = 3,
	}
}

local status_colors = setmetatable({
	[CrashReporter.STATUS.UNDEFINED] = { 1, 1, 1, 1 },
	[CrashReporter.STATUS.INFO] = { 0.6, 0.6, 1, 1 },
	[CrashReporter.STATUS.SUCCESS] = { 0.6, 1, 0.6, 1 },
	[CrashReporter.STATUS.ERROR] = { 1, 0.6, 0.6, 1 },
}, {
	__index = function(self, index)
		return rawget(self, CrashReporter.STATUS.UNDEFINED)
	end
})

local ScriptErrorWidget = require("widgets/scripterrorwidget")
local Image = require("widgets/image")
local InsightCrashReportStatus = import("widgets/insight_crashreportstatus")
local InsightServerCrashScreen = import("screens/insightservercrash")

--[==[
local function GetPlatform()
	return PLATFORM
	--[[
	return 
		IsPS4() and "ps4"
		or IsXB1() and "xbox1"
		or IsRail() and "win32_rail"
		or IsLinux() and "linux_steam"
		or IsSteam() and PLATFORM:lower()
		or "Unkown Platform"
	--]]
end

local function GetMods()
	local server_mods, client_mods = {}, {}

	-- on server, gets all the server mods
	-- on client, gets all the server mods + client mods
	for _, modname in pairs(ModManager:GetEnabledModNames()) do
		local data = deepcopy(KnownModIndex:GetModInfo(modname))
		data.folder_name = modname
		if data.client_only_mod then
			table.insert(client_mods, data)
		else
			table.insert(server_mods, data)
		end
	end

	return { 
		server = server_mods, 
		client = client_mods 
	}
end
]==]

_G.asd = function() _G.asd = InsightServerCrashScreen("hii") end


--- Triggered when we receive a message from the server that it has crashed.
--- @param data table
local function OnRemoteServerError(data)
	if not CrashReporter.initialized then
		return
	end

	if type(data) == "string" then
		data = json.decode(data)
	end

	-- If the message is missing, we did not get any privileged information 
	-- and should just show the default message.
	if not data.message then
		data.message = language.AssumeLanguageTable().crash_reporter.crashed
	end

	local title = language.AssumeLanguageTable().crash_reporter.title

	if not CrashReporter._error_screen then
		CrashReporter._error_screen = InsightServerCrashScreen(title)
		-- We are intentionally not pushing the screen.
		-- This allows it to render without us needing to be concerned with the disconnect screen greying us out.
		TheFrontEnd:PushScreen(CrashReporter._error_screen)
	end

	CrashReporter._error_screen:SetMessage(data.message)
	CrashReporter._error_screen:SetColor(status_colors[data.status])
	-- ...Turns out that the server can't receive RPCs when it's crashed.
	-- ...I should have expected that.
	--[[
	CrashReporter._error_screen.status:ShowManualReportButton(data.show_report_button)
	CrashReporter._error_screen.status:SetManualReportCallback(function() 
		--CrashReporter.TriggerCrashReportFlow(true)
		mprint("Sending request to trigger flow")
		rpcNetwork.SendModRPCToServer(GetModRPC(modname, "TriggerCrashReportFlow"))
	end)
	--]]
end

--- Triggered when the server receives a request to trigger the crash report flow.
local function OnRequestToTriggerCrashReportFlow(player)
	mprint("Received request to trigger crash report flow")
	if not CrashReporter.IsPrivilegedUser(player.userid) then
		mprintf("Received suspicious request for crash report sending from %s", player)
		return
	end

	CrashReporter.TriggerCrashReportFlow()
end


--- Checks whether we are allowed to send a crash report or not.
---@return bool, string @Whether we can send the report & the reason,
CrashReporter.CanWeSendReport = function()
	local report_server = GetModConfigData("crash_reporter", false)
	local report_client = GetModConfigData("crash_reporter", true)
	local is_server_owner = TheNet:GetIsServerOwner()

	mprintf("report_server: %s, report_client: %s", report_server, report_client)

	-- If this is a server crash,
	if TheNet:GetIsMasterSimulation() then
		if report_server then
			-- If the server has opted in, then we can report the crash.
			return true, "server is opted in"

		elseif CrashReporter.server_owner_optin then
			-- If the server OWNER has opted in locally, then we can report the crash.
			return true, "server owner has opted in"

		elseif IsClientHost() and report_client then
			-- If this is the client directly playing on a hosted shard (i.e. caveless)
			-- and they have opted in locally, we can report the crash.
			return true, "client host has opted in"
		end
		
		return false, "server did not find an authoritative opt-in"
	end

	
	if IsClient() then
		if report_client then
			return true, "client has opted in"
		end

		return false, "client has not opted in"
	end

	-- I don't actually need this, but might as well have it for completeness sake.
	-- Main Menu crash (note difference between client (playing a world) vs user (not in a world))
	if not (IsClient() or IsServer()) then
		if report_client then
			return true, "user has opted in"
		end
	end

	return false, "unknown state?"
end

CrashReporter.IsPrivilegedUser = function(userid)
	local client_data = TheNet:GetClientTableForUser(userid)
	if not client_data then
		return false
	end

	if client_data.admin then
		return true
	end

	return false
end

--- Displays the status of the crash reporter.
--- @param data table
CrashReporter.UpdateStatus = function(data)
	if not CrashReporter.initialized then
		return
	end
	
	local admin_data = deepcopy(data)
	local user_data = data
	--user_data.show_report_button = false

	admin_data, user_data = json.encode(admin_data), json.encode(user_data)

	local title = language.AssumeLanguageTable().crash_reporter.title

	-- If we're running on the server, make sure that we notify other clients that the server has crashed.
	if TheNet:GetIsMasterSimulation() then
		--data.status = status
		local ids = {}

		for i,v in pairs(AllPlayers) do
			local client_data = TheNet:GetClientTableForUser(v.userid)

			-- It is possible for client data to be missing when IsClientHost()
			-- if you crash during the player spawning process.
			if client_data and (not IsClientHost() or (IsClientHost() and v ~= ThePlayer)) then
				if CrashReporter.IsPrivilegedUser(v.userid) then
					-- Admins receive more information.
					rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "ServerError"), v.userid, json.encode(data))
				else
					-- Users only get to know that the server crashed.
					-- Actually, no point.
					--[[
					rpcNetwork.SendModRPCToClient(GetClientModRPC(modname, "ServerError"), v.userid, json.encode({
						status = module.STATUS.ERROR
					}))
					--]]
				end
			end
		end
	end

	if IsClient() or IsClientHost() then
		-- Otherwise, we've encountered a client crash.
		--OnRemoteServerError(data)
		local ui = CrashReporter.ScriptErrorWidget.insight_crashreport_status 
			or CrashReporter.ScriptErrorWidget.title:AddChild(InsightCrashReportStatus(title))

		CrashReporter.ScriptErrorWidget.insight_crashreport_status = ui
		ui:SetPosition(0, 0 + 40*4)
		ui:SetMessage(data.message)
		ui:SetColor(status_colors[data.status])
		ui:ShowManualReportButton(data.show_report_button)
		ui:SetManualReportCallback(function() CrashReporter.TriggerCrashReportFlow(true) end)
	end
end

--- Sends the crash report.
CrashReporter.SendReport = function()
	CrashReporter.sending = true

	TheSim:SendCrashReportTo(
		"https://dst.penguin0616.dev/crashreporter/reportcrash",
		function(body, is_successful, status_code)
			mprintf("Report: Success = %s, Status = %s, \n%s", is_successful, status_code, body)
			CrashReporter.sending = false

			local status = CrashReporter.STATUS.ERROR
			local message = language.AssumeLanguageTable().crash_reporter.report_status.unknown

			if is_successful then
				if status_code >= 200 and status_code < 300 then
					-- We got a successful status code. Yay!
					status = CrashReporter.STATUS.SUCCESS
					message = language.AssumeLanguageTable().crash_reporter.report_status.success
				else
					local safe, response = pcall(json.decode, body)
					
					if safe then 
						status = CrashReporter.STATUS.ERROR
						message = string.format(
							language.AssumeLanguageTable().crash_reporter.report_status.failure, 
							status_code, 
							tostring(body.message)
						)
					else
						mprintf("Failed to parse body: %s", response)
						status = CrashReporter.STATUS.ERROR
						message = string.format(
							language.AssumeLanguageTable().crash_reporter.report_status.failure, 
							status_code, 
							string.format("Parsing failure \n[%s]", response)
						)
					end
				end
			else
				status = CrashReporter.STATUS.ERROR
				message = string.format(
					language.AssumeLanguageTable().crash_reporter.report_status.failure, 
					status_code, 
					"Complete failure"
				)
			end

			if CrashReporter.ScriptErrorWidget.spinner then
				CrashReporter.ScriptErrorWidget.spinner:Kill()
				CrashReporter.ScriptErrorWidget.spinner = nil
			end
			
			return CrashReporter.UpdateStatus({ 
				status = status, 
				message = message,
				show_report_button = false
			})
		end
	)
end

local function ScriptErrorWidget_OnUpdate(self, ...)
	if CrashReporter.sending then
		CrashReporter.UpdateStatus({
			status = CrashReporter.STATUS.INFO,
			message = string.format("%s\n%s", 
				language.AssumeLanguageTable().crash_reporter.crashed, 
				language.AssumeLanguageTable().crash_reporter.report_status.sending .. string.rep(".", GetTimeRealSeconds() % 3 + 1)
			)
		})
	end

	return CrashReporter.ScriptErrorWidget_oldOnUpdate(self, ...)
end


CrashReporter.TriggerCrashReportFlow = function(override)
	mprint("Checking if we can send a crash report.")
	local can_report, reason
	if override then
		can_report, reason = override, "user manually approved"
	else
		can_report, reason = CrashReporter.CanWeSendReport()
	end

	mprint("CanWeSendReport:", can_report, reason)

	if can_report then
		CrashReporter.UpdateStatus({
			status = CrashReporter.STATUS.INFO,
			message = string.format("%s\n%s", 
				language.AssumeLanguageTable().crash_reporter.crashed, 
				language.AssumeLanguageTable().crash_reporter.report_status.sending
			),
			show_report_button = false
		})

		CrashReporter.SendReport()
	else
		CrashReporter.UpdateStatus({
			status = CrashReporter.STATUS.INFO,
			message = string.format("%s\n%s", 
				language.AssumeLanguageTable().crash_reporter.crashed, 
				string.format(language.AssumeLanguageTable().crash_reporter.report_status.disabled, reason)
			),
			show_report_button = true
		})
	end
end


local function OnScriptErrorWidgetPostInit(self)
	if not CrashReporter.initialized then
		mprint("Crash reporter module not initialized, exiting.")
		return
	end

	mprint("A crash has occured (THIS DOES NOT MEAN IT WAS INSIGHT, THIS IS JUST HERE FOR DEBUGGING PURPOSES)")

	if self.title then
		mprint("\tTitle:", self.title:GetString())
	end

	if self.text then
		mprint("\tText:", self.text:GetString())
	end

	if self.additionaltext then
		mprint("\tAdditionaltext:", self.additionaltext:GetString())
	end

	if CrashReporter.triggered then
		mprint("ScriptErrorWidget created more than once, ignoring.")
		return
	end
	
	CrashReporter.triggered = true
	CrashReporter.ScriptErrorWidget = self

	--self:StartUpdating()

	CrashReporter.TriggerCrashReportFlow()
end

CrashReporter.Initialize = function()
	if CrashReporter.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	if TheSim:GetGameID() ~= "DST" then
		return
	end

	CrashReporter.initialized = true

	AddClassPostConstruct("widgets/scripterrorwidget", OnScriptErrorWidgetPostInit)
	CrashReporter.ScriptErrorWidget_oldOnUpdate = ScriptErrorWidget.OnUpdate
	ScriptErrorWidget.OnUpdate = ScriptErrorWidget_OnUpdate

	rpcNetwork.AddModRPCHandler(modname, "TriggerCrashReportFlow", OnRequestToTriggerCrashReportFlow)
	rpcNetwork.AddClientModRPCHandler(modname, "ServerError", OnRemoteServerError)
end

return CrashReporter