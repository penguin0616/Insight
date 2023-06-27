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

local Widget = require "widgets/widget"
local Text = require("widgets/text") --FIXED_TEXT
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local InsightPage = import("widgets/insightpage")
local InsightConfigurationScreen = import("screens/insightconfigurationscreen")

local tabs = {"world", "player"}

--
util.classTweaker.TrackClassInstances(InsightConfigurationScreen)
REGISTER_HOT_RELOAD({"screens/insightconfigurationscreen"}, function(imports)
	InsightConfigurationScreen = imports.insightconfigurationscreen
	util.classTweaker.TrackClassInstances(InsightConfigurationScreen)
end)
--

-- Before 3 line per detail update

local BACKGROUND_SIZE = {540, 460}
local MAIN_MENU_SIZE = {540 - 80, 460 - 100}

local PAGE_WIDTH = MAIN_MENU_SIZE[1] - 30
local PAGE_HEIGHT = 64
local PAGE_ITEM_SPACE = 16


-- Class InsightMenu
local InsightMenu = Class(Widget,function(self)
	Widget._ctor(self, "InsightMenu")
	--[[
	self.bg = self:AddChild(Image("images/options_bg.xml", "options_panel_bg_frame.tex")) -- data/images
	self.bg:SetSize(460, 380)
	--]]

	local strs = language.AssumeLanguageTable()

	self.pages = {}
	self.current_page = nil
	self.page_num = 0

	self.bg = self:AddChild(Image("images/dst/scoreboard.xml", "scoreboard_frame.tex")) -- data/images
	self.bg:SetSize(unpack(BACKGROUND_SIZE)) -- Original size before config: 480, 460

	self.main = self:AddChild(Image(DEBUG_IMAGE(false)))
	--self.main:SetTint(1, 1, 1, .1)
	self.main:SetSize(unpack(MAIN_MENU_SIZE))

	local mainw, mainh = self.main:GetSize()

	self:SetPosition(0, MAIN_MENU_SIZE[2]/2 - 75)
	
	self.header = self.main:AddChild(Image(DEBUG_IMAGE(false)))
	self.header:SetTint(1, 1, 1, .1)
	self.header:SetSize(mainw, 60)
	self.header:SetPosition(0, BACKGROUND_SIZE[2]/2 - 75)

	local headerw, headerh = self.header:GetSize()
	local available_tab_space = headerw - 64

	self.tabs = {}
	for i,v in pairs(tabs) do
		local tab_width = available_tab_space / (#tabs)
		local tab_height = headerh
		
		local tab = self.header:AddChild(ImageButton("images/dst/frontend_redux.xml",
			"listitem_thick_normal.tex", -- normal
			nil, -- focus
			nil,
			nil,
			"listitem_thick_selected.tex" -- selected
		))
		
		--[[
		local prefix = GetReduxButtonPrefix({tab_width, tab_height})
		local tab = self.header:AddChild(ImageButton("images/dst/global_redux.xml", prefix.."_normal.tex", prefix.."_hover.tex", prefix.."_disabled.tex", prefix.."_down.tex"))
		--]]
		-- Appearance stuff
		tab.scale_on_focus = false -- Prevents the break-size-on-focus thing.
		tab:UseFocusOverlay("listitem_thick_hover.tex")
		tab:ForceImageSize(tab_width, tab_height)
		tab:SetPosition(-headerw/2 + tab_width/2 + (tab_width * (i-1)), 0)
		tab:SetTextColour(unpack(WHITE))
		tab:SetTextFocusColour(unpack(WHITE))
		tab:SetTextSelectedColour(unpack(WHITE))
		tab:SetFont(UIFONT)
		tab:SetTextSize(30)
		tab:SetText(strs.insightmenu.tabs[v] or v)
		tab.name = v

		-- Functional stuff
		tab.menu = self
		tab.page_number = i
		tab:SetOnClick(function()
			self:SetPage(tab.page_number)
		end)

		table.insert(self.tabs, tab)

		-- Create the page
		local page = self.main:AddChild(InsightPage(v, 
			PAGE_WIDTH, 
			PAGE_HEIGHT, 
			PAGE_ITEM_SPACE
		))
		page.list.custom_focus_check = function() -- TODO: Temporary Workaround
			-- Make sure that the scroller can accept scroll actions even when focus is on our tab buttons.
			return self.current_page == page
		end
		table.insert(self.pages, page)
	end

	
	-- Logic derived from redux/templates -> IconButton and base classes
	local button_size = headerw - available_tab_space
	local prefix = GetReduxButtonPrefix({button_size, button_size}) --"button_carny_square"
	self.config_button = self.header:AddChild(ImageButton("images/dst/global_redux.xml", prefix.."_normal.tex", prefix.."_hover.tex", prefix.."_disabled.tex", prefix.."_down.tex"))
	self.config_button:ForceImageSize(button_size, button_size)
	self.config_button:SetTextSize(math.ceil(button_size*.45))
	self.config_button.icon = self.config_button:AddChild(Image("images/dst/button_icons2.xml", "workshop_filter.tex"))
	self.config_button.icon:ScaleToSize(self.config_button.text.size, self.config_button.text.size)
	self.config_button.icon:SetPosition(1, 0)

	self.config_button:SetHoverText(STRINGS.UI.MODSSCREEN.CONFIGUREMOD, {
		font = NEWFONT_OUTLINE,
		offset_x = 2,
		offset_y = 45,
		colour = Color.new(1, 1, 1, 1),
		bg = nil
	})

	local px, py = self.tabs[#self.tabs]:GetPosition():Get()
	local sx, sy = self.tabs[#self.tabs]:GetSize()
	self.config_button:SetPosition(px + sx/2 - self.config_button.size_x/2, 0) -- px + sx/2 + self.config_button.size_x/2
	self.config_button:SetOnClick(function()
		--self:SetPage(3)
		--TheFrontEnd.screenstack[#TheFrontEnd.screenstack]:ClearFocus()
		if localPlayer then
			local sc = InsightConfigurationScreen()
			TheFrontEnd:PushScreen(sc)
		else
			mprint("Missing localPlayer to be able to spawn configuration menu")
		end
	end)
	self.pages[3] = false
	self.tabs[3] = self.config_button

	self:DoFocusHookups()

	--[[
	self.tabs[1]:SetFocusChangeDir(MOVE_RIGHT, self.tabs[2])
	self.tabs[2]:SetFocusChangeDir(MOVE_RIGHT, self.config_button)
	self.config_button:SetFocusChangeDir(MOVE_RIGHT, self.tabs[1])

	self.tabs[1]:SetFocusChangeDir(MOVE_LEFT, self.config_button)
	self.tabs[2]:SetFocusChangeDir(MOVE_LEFT, self.tabs[1])
	self.config_button:SetFocusChangeDir(MOVE_LEFT, self.tabs[2])
	--]]
	
	self.from_screen = false
	self:Hide() -- SetPage needs to be done in the Activate call so we know it has a parent for focus purposes.

	self.exit_listener = TheInput:AddControlHandler(CONTROL_CANCEL, function(digital, analog)
		if self.from_screen then
			return
		end

		-- digital is down boolean, analog is down but as a number 
		if not digital and TheFrontEnd:GetActiveScreen().name == "HUD" then
			self:Hide()
		end
	end)

	if localPlayer then
		GetLocalInsight(localPlayer):MaintainMenu(self)
	end
end)

function InsightMenu:DoFocusHookups()
	local available = {}
	for i,v in pairs(self.tabs) do
		if v.enabled then
			table.insert(available, v)
		end
		v:ClearFocusDirs()
	end

	for i,v in pairs(available) do
		if available[i+1] then
			v:SetFocusChangeDir(MOVE_RIGHT, available[i+1])
		end
		if available[i-1] then
			v:SetFocusChangeDir(MOVE_LEFT, available[i-1])
		end
	end
end

function InsightMenu:Activate()
	self:SetPage(1)
	--self.tabs[1]:SetFocus()

	self.force_exit_listener = ClientCoreEventer:ListenForEventOnce("force_insightui_exit", function()
		self:Hide()
	end)
end

function InsightMenu:ActivateFromScreen()
	self.from_screen = true
	--self.tabs[1]:SetFocus()
	--self:SetPage(tabs[1])
	self:SetPage(1)
	self:Show()
end

function InsightMenu:Show()
	self._base.Show(self)
	if not self.focus then
		self:NextPage(0)
	end
end

function InsightMenu:Hide()
	self._base.Hide(self)
	self:ClearFocus()
end

function InsightMenu:Kill(...)
	if self.exit_listener then
		self.exit_listener:Remove()
	end

	return self._base.Kill(self, ...)
end

-- Class Functions
function InsightMenu:GetCurrentPage()
	return self.current_page
end

function InsightMenu:NextPage(inc)
	inc = inc or 1
	
	local next = math.clamp(self.page_num + inc, 1, #self.pages)
	self:SetPage(next)
end

function InsightMenu:GetTabByName(name)
	for i,v in pairs(self.tabs) do
		if v.name:lower() == name:lower() then
			return v
		end
	end
end

function InsightMenu:GetPageByName(name)
	for i,v in pairs(self.pages) do
		if v:GetName():lower() == name:lower() then
			return v
		end
	end
end

function InsightMenu:SetPage(num)
	if self.tabs[self.page_num] then
		self.tabs[self.page_num]:Unselect()
	end

	self.page_num = num
	local page = self.pages[num]
	self.tabs[self.page_num]:Select()
	if self:IsVisible() then
		self.tabs[self.page_num]:SetFocus()
	end

	-- Clean up old page
	if type(self.current_page) == "table" then
		--self.current_page:SetFocusChangeDir(MOVE_UP, nil)
		self.current_page:Hide()
	end
	self.current_page = nil

	-- Setup new page
	self.current_page = page
	if type(page) == "table" then
		--self.current_page:SetFocusChangeDir(MOVE_UP, self.tabs[1])
		self.current_page:Show()
		if self.from_screen then 
			--self.current_page:SetFocus()
		end
	elseif type(page) == "function" then
		--page(self)
	end
	

	for i,v in pairs(self.tabs) do
		--v:SetFocusChangeDir(MOVE_DOWN, self.current_page)
	end

	--[[
	--mprint("Switching page ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

	if self.current_page then
		--self.current_page.tab.bg:SetTexture("images/frontend_redux.xml", "listitem_thick_normal.tex")
		self.current_page.tab:SetCurrent(false)
		self.current_page:Hide()
		--self.current_page:ClearFocus()
	end

	self.current_page = page
	self.current_page.tab:SetCurrent(true)
	self.current_page:Show()
	--mprint("1", self.current_page.focus, self.current_page.list.focus)
	if self.from_screen then 
		self.current_page:SetFocus()
	end
	--mprint("2", self.current_page.focus, self.current_page.list.focus)
	--mprint("End Switch ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
	--]]
end

function InsightMenu:OnControl(control, down)
	--dprint("\tInsightMenu OnControl", controlHelper.Prettify(control), down)
	--dprint("\t\t", self.tabs[1].focus, self.tabs[2].focus, self.config_button.focus, "|", self.current_page)
	
	local scheme = controlHelper.GetCurrentScheme()

	if self.current_page then
		local a = self.current_page.list:OnControl(control, down) -- TODO: Temporary Workaround
		if a then
			return a
		end
	end

	-- back == up == 31
	-- fwd == down == 32
	
	return self._base.OnControl(self, control, down)
end

function InsightMenu:GetHelpText()
	local controller_id = TheInput:GetControllerID()

	local tips = {}
	table.insert(tips, TheInput:GetLocalizedControl(controller_id, controlHelper.controller_scheme.previous_value:GetPrimaryControl()) .. "/" .. TheInput:GetLocalizedControl(controller_id, controlHelper.controller_scheme.next_value:GetPrimaryControl()) .. " " .. "Switch Tabs")

	return table.concat(tips, "  ")
end

local function PurgeFn(t, i, j, corresponding_tbl_with_keys)
	local key = t[i].key
	return corresponding_tbl_with_keys[key] ~= nil
end

function InsightMenu:ApplyInformation(world_data, player_data)
	local world_tab = self:GetTabByName("world")
	local world_page = self:GetPageByName("world")
	local player_page = self:GetPageByName("player")

	if world_page and world_data then
		if world_data.disabled then
			--[[
			world_tab:Disable()
			if self:GetCurrentPage() == world_page then
				self:DoFocusHookups()
			end	
			--]]
		else
			--world_tab:Enable()
			for component, desc in pairs(world_data.raw_information) do
				if world_data.special_data[component].worldly == true then
					--mprint(component, desc)
					desc = (false and string.format("<color=#DDA305>[(%s) %s]</color> ", world_data.special_data[component].from or "cmp", component) .. desc) or desc
					if world_page:GetItem(component) == nil then
						--mprint("adding insightmenu segment for:", component)
						world_page:AddItem(component, { text=desc, icon=world_data.special_data[component].icon, component=component, real_component=world_data.special_data[component].real_component })
					else
						world_page:EditItem(component, { text=desc, icon=world_data.special_data[component].icon, component=component, real_component=world_data.special_data[component].real_component })
					end
				end
			end
		end

		--mprint'--------------------------------------------'
	end

	if world_page then
		ArrayPurge(world_page:GetItems(), PurgeFn, (world_data and world_data.raw_information) or {})
		world_page:Refresh()
	end

	-- player page
	local did = {}
	if player_page and player_data then
		local info = player_data
		
		if info.special_data.debuffable then
			if info.special_data.debuffable.debuffs then
				for i,v in pairs(info.special_data.debuffable.debuffs) do
					local name, text, icon = v.name, v.text, v.icon
					name = name .. "debuffable_"
					did[name] = true
					
					if player_page:GetItem(name) == nil then
						player_page:AddItem(name, { text=text, icon=icon })
					else
						player_page:EditItem(name, { text=text, icon=icon })
					end
				end
			elseif info.special_data.debuffable._error then -- info.special_data.debuffable._error
				did["debuffable_error"] = true
				if player_page:GetItem("debuffable_error") == nil then
					player_page:AddItem("debuffable_error", { text=info.raw_information.debuffable })
				end
			end
		end
		
		if info.raw_information then
			for component, desc in pairs(info.raw_information) do
				if info.special_data[component].playerly == true then
					did[component] = true
					
					if player_page:GetItem(component) == nil then
						player_page:AddItem(component, { text=desc, icon=info.special_data[component].icon })
					else
						player_page:EditItem(component, { text=desc, icon=info.special_data[component].icon })
					end
				end
			end
		else
			mprint("PLAYER INFO RAW MISSING")
			table.foreach(info, mprint)
		end

		--[[
		if info.special_data.locomotor then
			for i,v in pairs(info.special_data.locomotor.modifiers) do
				local name, text, icon = v.name, v.text, v.icon
				name = name .. "locomotor_"
				did[name] = true
				
				if player_page:GetItem(name) == nil then
					player_page:AddItem(name, { text=text, icon=icon })
				else
					player_page:EditItem(name, { text=text, icon=icon })
				end
			end
		end
		--]]
	end

	if player_page then
		ArrayPurge(player_page:GetItems(), PurgeFn, did)
		player_page:Refresh()
	end
end

--[[
function InsightMenu:OnRawKey(...)
	print(...)

end
--]]


--rawset(_G, "fff", false)
--[[


local PlayerController = util.LoadComponent("playercontroller")
local oldIsEnabled = PlayerController.IsEnabled
PlayerController.IsEnabled = function(self, ...)
	if self.inst == localPlayer then
		if _G.fff then
			return false, TheFrontEnd.textProcessorWidget == nil
		end
	end

	return oldIsEnabled(self, ...)
end
--]]

return InsightMenu