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

local module = {
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
	[module.STATUS.UNDEFINED] = { 1, 1, 1, 1 },
	[module.STATUS.INFO] = { 0.6, 0.6, 1, 1 },
	[module.STATUS.SUCCESS] = { 0.6, 1, 0.6, 1 },
	[module.STATUS.ERROR] = { 1, 0.6, 0.6, 1 },
}, {
	__index = function(self, index)
		return rawget(self, module.STATUS.UNDEFINED)
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

--- Checks whether we are allowed to send a crash report or not.
---@return bool, string @Whether we can send the report & the reason,
local function CanWeSendReport()
	local report_server = GetModConfigData("crash_reporter", false)
	local report_client = GetModConfigData("crash_reporter", true)
	local is_server_owner = TheNet:GetIsServerOwner()

	-- If this is a server crash,
	if TheNet:GetIsMasterSimulation() then
		if report_server then
			-- If the server has opted in, then we can report the crash.
			return true, "server is opted in"

		elseif module.server_owner_optin then
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

--- Displays the status of the crash reporter.
--- @param widget scripterrorwidget The script error widget.
--- @param data table
local function UpdateStatus(widget, data)
	if not module.initialized then
		return
	end
	
	local title = language.AssumeLanguageTable().crash_reporter.title

	local ui = widget.insight_crashreport_status 
		or widget.title:AddChild(InsightCrashReportStatus(title))

	widget.insight_crashreport_status = ui
	ui:SetPosition(0, 0 + 40*3)
	ui:SetMessage(data.message)
	ui:SetColor(status_colors[data.status])

	-- If we're running on the server, make sure that we notify other clients that the server has crashed.
	if TheNet:GetIsMasterSimulation() then
		--data.status = status
		local ids = {}

		for i,v in pairs(AllPlayers) do
			local client_data = TheNet:GetClientTableForUser(v.userid)

			-- It is possible for client data to be missing when IsClientHost()
			-- if you crash during the player spawning process.
			if client_data and (not IsClientHost() or (IsClientHost() and v ~= ThePlayer)) then
				if client_data.admin then
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
end

--- Triggered when we receive a message from the server that it has crashed.
--- @param data table
local function OnRemoteServerError(data)
	if not module.initialized then
		return
	end

	data = json.decode(data)

	-- If the message is missing, we did not get any privileged information 
	-- and should just show the default message.
	if not data.message then
		data.message = language.AssumeLanguageTable().crash_reporter.crashed
	end

	local title = language.AssumeLanguageTable().crash_reporter.title

	if not module._error_screen then
		module._error_screen = InsightServerCrashScreen(title)
		-- We are intentionally not pushing the screen.
		-- This allows it to render without us needing to be concerned with the disconnect screen taking focus away.
		--TheFrontEnd:PushScreen(module._error_screen)
	end

	module._error_screen:SetMessage(data.message)
	module._error_screen:SetColor(status_colors[data.status])
end

--- Sends the crash report.
--- @param widget scripterrorwidget
local function SendReport(widget)
	module.sending = true

	TheSim:SendCrashReportTo(
		"https://dst.penguin0616.dev/crashreporter/reportcrash",
		function(body, is_successful, status_code)
			mprintf("Report: Success = %s, Status = %s, \n%s", is_successful, status_code, body)
			module.sending = false

			local status = module.STATUS.ERROR
			local message = language.AssumeLanguageTable().crash_reporter.report_status.unknown

			if is_successful then
				if status_code >= 200 and status_code < 300 then
					-- We got a successful status code. Yay!
					status = module.STATUS.SUCCESS
					message = language.AssumeLanguageTable().crash_reporter.report_status.success
				else
					local safe, response = pcall(json.decode, body)
					
					if safe then 
						status = module.STATUS.ERROR
						message = string.format(
							language.AssumeLanguageTable().crash_reporter.report_status.failure, 
							status_code, 
							tostring(body.message)
						)
					else
						mprintf("Failed to parse body: %s", response)
						status = module.STATUS.ERROR
						message = string.format(
							language.AssumeLanguageTable().crash_reporter.report_status.failure, 
							status_code, 
							string.format("Parsing failure \n[%s]", response)
						)
					end
				end
			else
				status = module.STATUS.ERROR
				message = string.format(
					language.AssumeLanguageTable().crash_reporter.report_status.failure, 
					status_code, 
					"Complete failure"
				)
			end

			if widget.spinner then
				widget.spinner:Kill()
				widget.spinner = nil
			end
			
			return UpdateStatus(widget, { 
				status = status, 
				message = message
			})
		end
	)
end

local function ScriptErrorWidget_OnUpdate(self, ...)
	if module.sending then
		UpdateStatus(self, {
			status = module.STATUS.INFO,
			message = string.format("%s\n%s", 
				language.AssumeLanguageTable().crash_reporter.crashed, 
				language.AssumeLanguageTable().crash_reporter.report_status.sending .. string.rep(".", GetTimeRealSeconds() % 3 + 1)
			)
		})
	end

	return module.ScriptErrorWidget_oldOnUpdate(self, ...)
end

local function OnScriptErrorWidgetPostInit(self)
	if not module.initialized then
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

	if module.triggered then
		mprint("ScriptErrorWidget created more than once, ignoring.")
		return
	end
	
	module.triggered = true

	--self:StartUpdating()

	mprint("Checking if we can send a crash report.")
	local can_report, reason = CanWeSendReport()
	mprint("CanWeSendReport:", can_report, reason)

	if can_report then
		UpdateStatus(self, {
			status = module.STATUS.INFO,
			message = string.format("%s\n%s", 
				language.AssumeLanguageTable().crash_reporter.crashed, 
				language.AssumeLanguageTable().crash_reporter.report_status.sending
			)
		})

		--self.spinner = self.title:AddChild(Image("images/White_Square.xml", "White_Square.tex"))
		--self.spinner:SetPosition(0, 0 + 40*3)

		SendReport(self)
	else
		UpdateStatus(self, {
			status = module.STATUS.INFO,
			message = string.format("%s\n%s", 
				language.AssumeLanguageTable().crash_reporter.crashed, 
				string.format(language.AssumeLanguageTable().crash_reporter.report_status.disabled, reason)
			)
		})
	end
end


module.Initialize = function()
	if module.initialized then
		errorf("Cannot initialize %s more than once.", debug.getinfo(1, "S").source:match("([%w_]+)%.lua$"))
		return
	end

	if TheSim:GetGameID() ~= "DST" then
		return
	end

	module.initialized = true

	AddClassPostConstruct("widgets/scripterrorwidget", OnScriptErrorWidgetPostInit)
	module.ScriptErrorWidget_oldOnUpdate = ScriptErrorWidget.OnUpdate
	ScriptErrorWidget.OnUpdate = ScriptErrorWidget_OnUpdate

	rpcNetwork.AddClientModRPCHandler(modname, "ServerError", OnRemoteServerError)
end

return module