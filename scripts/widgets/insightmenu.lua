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

local tabs = {"World", "Player"}

-- Functions
local function DEBUG()
	if false then
		return "images/White_Square.xml", "White_Square.tex"
	end

	return nil, nil
end

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

	if IsDST() then
		self.background.scale_on_focus = false
		self.background:UseFocusOverlay("listitem_thick_hover.tex")
	else
		-- for the hover effect
		widgetLib.imagebutton.UseFocusOverlay(self.background, "listitem_thick_hover.tex")
		widgetLib.imagebutton.OverrideFocuses(self.background)
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

	if IsDST() then
		self.background:ForceImageSize(self.width - 4, self.height - 4)
	else
		widgetLib.imagebutton.ForceImageSize(self.background, self.width - 4, self.height - 4)
	end
end

-- Class InsightMenu
local InsightMenu = Class(Widget,function(self)
	Widget._ctor(self, "Menu")
	--[[
	self.bg = self:AddChild(Image("images/options_bg.xml", "options_panel_bg_frame.tex")) -- data/images
	self.bg:SetSize(460, 380)
	--]]

	self.bg = self:AddChild(Image("images/dst/scoreboard.xml", "scoreboard_frame.tex")) -- data/images
	self.bg:SetSize(480, 460) -- 470, 380

	self.pages = {}
	self.current_page = nil
 

	self.header = self:AddChild(Image(DEBUG()))
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
	
		
		--[[
		local tab = self.header:AddChild(Image(DEBUG()))
		tab:SetTint(i == 3 and 0.5 or 0, i==1 and 0.5 or 0, i==2 and 0.5 or 0, 0.8)
		tab:SetSize(dw / #tabs, height)

		local tab_width, tab_height = tab:GetSize()

		-- start at 0 i suppose
		-- -dw/2 is "zero"
		-- tab_width/2 is the offset from zero so you can start at zero, idk i know how it works in my head
		-- (i-1) * tab_width is the tab's positioning
		-- can't add+5 or -5 for padding, since one side will always be offset, probably some way to calculate but eeeeh

		local pad = 5

		local offset = -dw/2 + tab_width/2 + (i-1) * (tab_width + pad)

		-- if #tabs odd, is fine
		-- if #tabs even, idk


		if math.floor(#tabs/2) == #tabs/2 then
			print("even")
			offset = offset - (pad / #tabs)
		else
			print("odd")
		end

		tab:SetPosition(offset, 0)

		tab.bg = tab:AddChild(Image("images/frontend_redux.xml", "listitem_thick_normal.tex"))
		tab.bg:SetSize(tab_width - 4, tab_height - 4)

		tab.text = tab:AddChild(Text(UIFONT, 30, v))
		--]]

		page.tab = tab
	end

	self:SetPage(tabs[1])

	--[[
	self.main = self:AddChild(Image(DEBUG()))
	--self.main = self:AddChild(Image())
	self.main:SetSize(400, 290)
	self.main:SetPosition(5, -25)

	self.list = self.main:AddChild(MakeGrid())

	self.items = {}
	--]]
end)

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

	if self.current_page then
		--self.current_page.tab.bg:SetTexture("images/frontend_redux.xml", "listitem_thick_normal.tex")
		self.current_page.tab:SetCurrent(false)
		self.current_page:Hide()
	end

	self.current_page = page
	self.current_page.tab:SetCurrent(true)
	self.current_page:Show()
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
					world_page:AddItem(component, { text=desc, icon=world_data.special_data[component].icon })
				else
					world_page:EditItem(component, { text=desc, icon=world_data.special_data[component].icon })
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

return InsightMenu