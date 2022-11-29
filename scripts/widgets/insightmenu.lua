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

local tabs = {"World", "Player"}

util.classTweaker.TrackClassInstances(InsightConfigurationScreen)
REGISTER_HOT_RELOAD({"screens/insightconfigurationscreen"}, function(imports)
	InsightConfigurationScreen = imports.insightconfigurationscreen
	util.classTweaker.TrackClassInstances(InsightConfigurationScreen)
end)

-- Functions
local Tab = Class(Widget, function(self, data)
	Widget._ctor(self, "Tab")
	self.width = data.width
	self.height = data.height
	self.selected = nil
	self.onclick = nil

	self.background = self:AddChild(ImageButton())
	self:SetCurrent(false)

	self.background.onclick = function(...)
		if self.onclick then
			self.onclick(...)
		end
	end

	if IS_DST then
		self.background.scale_on_focus = false
		self.background:UseFocusOverlay("listitem_thick_hover.tex")
	else
		-- for the hover effect
		self.background:UseFocusOverlay("listitem_thick_hover.tex")
		self.background:InsightOverrideFocuses()
	end

	self.text = self:AddChild(Text(UIFONT, 30, data.name))
end)

function Tab:SetOnClick(fn)
	self.onclick = fn
end

function Tab:GetSize()
	return self.width, self.height
end

function Tab:SetCurrent(bool)
	assert(type(bool) == "boolean", "expected boolean in tab:setcurrent")

	self.selected = bool

	-- made for Image, adapted for ImageButton
	if self.selected then
		self.background:SetTextures("images/dst/frontend_redux.xml", "listitem_thick_selected.tex")
	else
		self.background:SetTextures("images/dst/frontend_redux.xml", "listitem_thick_normal.tex")
	end

	if IS_DST then
		self.background:ForceImageSize(self.width - 4, self.height - 4)
	else
		self.background:ForceImageSize(self.width - 4, self.height - 4)
	end
end

-- Class InsightMenu
local InsightMenu = Class(Widget,function(self)
	Widget._ctor(self, "InsightMenu")
	--[[
	self.bg = self:AddChild(Image("images/options_bg.xml", "options_panel_bg_frame.tex")) -- data/images
	self.bg:SetSize(460, 380)
	--]]

	self.bg = self:AddChild(Image("images/dst/scoreboard.xml", "scoreboard_frame.tex")) -- data/images
	self.bg:SetSize(540, 460) -- Original size before config: 480, 460

	self.pages = {}
	self.current_page = nil
 

	self.header = self:AddChild(Image(DEBUG_IMAGE()))
	--self.header:SetTint(.5, 0, 0, .7)
	self.header:SetSize(400, 60)
	self.header:SetPosition(0, 460/2 - 75)

	self.tabs = {}

	for i,v in pairs(tabs) do
		local page = self:AddChild(InsightPage(v))
		table.insert(self.pages, page)

		local width, height = self.header:GetSize()
		local dw = width - 20

		local tab = self.header:AddChild(Tab({ width=dw/#tabs, height=height, name=v}))
		local tab_width, tab_height = tab:GetSize()

		-- start at 0 i suppose
		-- -dw/2 is "zero"
		-- tab_width/2 is the offset from zero so you can start at zero, idk i know how it works in my head
		-- (i-1) * tab_width is the tab's positioning
		-- can't add+5 or -5 for padding, since one side will always be offset, probably some way to calculate but eeeeh

		local pad = 5
		local offset = -dw/2 + tab_width/2 + (i-1) * (tab_width + pad)

		if math.floor(#tabs/2) == #tabs/2 then -- solve problem with spacing here
			offset = offset - (pad / #tabs)
		end

		tab:SetPosition(offset, 0)
		tab.page_number = i

		tab:SetOnClick(function()
			self:SetPage(v)
		end)

		page.tab = tab

		table.insert(self.tabs, tab)
	end

	-- Logic derived from redux/templates -> IconButton and base classes
	local prefix = "button_carny_square"

	local cfg = self.header:AddChild(ImageButton("images/dst/global_redux.xml", prefix.."_normal.tex", prefix.."_hover.tex", prefix.."_disabled.tex", prefix.."_down.tex"))
	cfg:ForceImageSize(60, 60)
	cfg:SetTextSize(math.ceil(60*.45))
	cfg.icon = cfg:AddChild(Image("images/dst/button_icons2.xml", "workshop_filter.tex"))
	cfg.icon:ScaleToSize(cfg.text.size, cfg.text.size)
	cfg.icon:SetPosition(1, 0)

	cfg:SetHoverText("Mod Configuration", {
		font = NEWFONT_OUTLINE,
		offset_x = 2,
		offset_y = 45,
		colour = Color.new(1, 1, 1, 1),
		bg = nil
	})

	local px, py = self.tabs[#self.tabs]:GetPosition():Get()
	local sx, sy = self.tabs[#self.tabs]:GetSize()
	cfg:SetPosition(px + sx/2 + cfg.size_x/2, 0)
	cfg:SetOnClick(function()
		print(InsightConfigurationScreen)
		TheFrontEnd.screenstack[#TheFrontEnd.screenstack]:ClearFocus()
		local sc = InsightConfigurationScreen()
		TheFrontEnd:PushScreen(sc)
	end)

	--[[
	self.main = self:AddChild(Image(DEBUG_IMAGE()))
	--self.main = self:AddChild(Image())
	self.main:SetSize(400, 290)
	self.main:SetPosition(5, -25)

	self.list = self.main:AddChild(MakeGrid())

	self.items = {}
	--]]

	--[[
	self.exit_listener = TheInput:AddControlHandler(CONTROL_PAUSE, function(digital, analog) 
		-- Down is whether the key is down or not.
		if not digital then
			local scr = TheFrontEnd.screenstack[#TheFrontEnd.screenstack]
			if scr.name == "HUD" then
				if self.shown then
					self:Hide()
				end
			end
		end
	end)
	--]]

	self.from_screen = false
	self:Hide() -- SetPage needs to be done in the Activate call so we know it has a parent for focus purposes.
end)

function InsightMenu:Activate()
	self:SetPage(tabs[1])
end

function InsightMenu:ActivateFromScreen()
	self.from_screen = true
	self:SetPage(tabs[1])
	self:Show()
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
	
	for i,v in pairs(self.pages) do
		if v == self.current_page then
			local next = math.clamp(i + inc, 1, #self.pages)
			self:SetPage(tabs[next])
			break
		end
	end
end

function InsightMenu:GetPage(name)
	for i,v in pairs(self.pages) do
		if v:GetName():lower() == name:lower() then
			return v
		end
	end
end

function InsightMenu:SetPage(name)
	local page = self:GetPage(name)
	assert(page, "No page exists with that name.")
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
end

function InsightMenu:OnControl(control, down)
	mprint("\tInsightMenu OnControl", controlHelper.Prettify(control), down)
	
	local scheme = controlHelper.GetCurrentScheme()

	if down then
		if scheme:IsAcceptedControl("previous_value", control) then
			self:NextPage(-1)
			return true
		elseif scheme:IsAcceptedControl("next_value", control)then
			self:NextPage(1)
			return true
		end
	end

	return self._base.OnControl(self, control, down)
end

function InsightMenu:GetHelpText()
	local controller_id = TheInput:GetControllerID()

	local tips = {}
	table.insert(tips, TheInput:GetLocalizedControl(controller_id, controlHelper.controller_scheme.previous_value[1]) .. "/" .. TheInput:GetLocalizedControl(controller_id, controlHelper.controller_scheme.next_value[1]) .. " " .. "Switch Tabs")

	return table.concat(tips, "  ")
end



function InsightMenu:ApplyInformation(world_data, player_data)
	local world_page = self:GetPage("world")
	local player_page = self:GetPage("player")

	if world_page and world_data then
		for component, desc in pairs(world_data.raw_information) do
			if world_data.special_data[component].worldly == true then
				--mprint(component, desc)
				desc = (false and string.format("<color=#DDA305>[(%s) %s]</color> ", world_data.special_data[component].from or "cmp", component) .. desc) or desc
				if world_page:GetItem(component) == nil then
					--mprint("adding insightmenu segment for:", component)
					world_page:AddItem(component, { text=desc, icon=world_data.special_data[component].icon, component=component })
				else
					world_page:EditItem(component, { text=desc, icon=world_data.special_data[component].icon, component=component })
				end
			end
		end
		--mprint'--------------------------------------------'
		local to_remove = {}

		for _, item in pairs(world_page:GetItems()) do
			if world_data.raw_information[item.key] == nil then
				table.insert(to_remove, item.key)
			end
		end

		while #to_remove > 0 do
			world_page:RemoveItem(to_remove[1])
			table.remove(to_remove, 1)
		end
	end

	-- player page
	if player_page and player_data then
		local info = player_data
		local did = {}

		if info.special_data.debuffable then
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

		local to_remove = {}

		for _, item in pairs(player_page:GetItems()) do
			if did[item.key] == nil then
				table.insert(to_remove, item.key)
			end
		end

		while #to_remove > 0 do
			player_page:RemoveItem(to_remove[1])
			table.remove(to_remove, 1)
		end
	end
end
--[==[
function InsightMenu:OnControl(control, down)
	--print(control, down)
	--[[
	if not down and (control == CONTROL_PAUSE or (TheInput:ControllerAttached() and control == CONTROL_CANCEL)) then
		-- Can also check for control == CONTROL_CANCEL, but I'm only checking for pause on keyboard so it'll prevent the pause menu from showing up.
		if self.shown then
			print("hiding")
			self:Hide()
			return true
		end
	end
	--]]
	--print(control, down, "|||||||||||||||", CONTROL_SCROLLBACK, CONTROL_SCROLLFWD)
	--self:GetCurrentPage():OnControl(...)
	--print(debugstack())
	
	-- back == up == 31
	-- fwd == down == 32

	--return old(self, ...)
	
	return InsightMenu._base.OnControl(self, control, down)
end
--]==]

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