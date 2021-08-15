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

--------------------------------------------------------------------------
--[[ Private Variables ]]
--------------------------------------------------------------------------
local _string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile = string, xpcall, package, tostring, print, os, unpack, require, getfenv, setmetatable, next, assert, tonumber, io, rawequal, collectgarbage, getmetatable, module, rawset, math, debug, pcall, table, newproxy, type, coroutine, _G, select, gcinfo, pairs, rawget, loadstring, ipairs, _VERSION, dofile, setfenv, load, error, loadfile
local TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim = TheInput, TheInputProxy, TheGameService, TheShard, TheNet, FontManager, PostProcessor, TheItems, EnvelopeManager, TheRawImgui, ShadowManager, TheSystemService, TheInventory, MapLayerManager, RoadManager, TheLeaderboards, TheSim

local TEXT_COLORING_ENABLED = nil
local Image = require("widgets/image")
local Text = require("widgets/text") --FIXED_TEXT
local Widget = require("widgets/widget")
local imageLib = import("widgets/image_lib")
local Reader, Chunk = import("reader")

local CalculateSize = CalculateSize
local Is_DST = IsDST()

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local function _LookupIcon(icon) -- took me a minute but i remember that this is here for the prefabhasicon call 
	if true then
		PrefabHasIcon(icon)
	end
	
	return LookupIcon(icon)
end

local function InterpretReaderChunk(chunk, richtext) -- text, color
	local color = chunk:GetTag("color") or richtext.default_colour

	if TEXT_COLORING_ENABLED == nil then
		TEXT_COLORING_ENABLED = GetModConfigData("text_coloring", true)
	end
	
	if not TEXT_COLORING_ENABLED then
		color = "#FFFFFF"
	end

	color = Color.fromHex(color)

	local obj = nil
	local is_object = chunk:IsObject()

	if is_object and chunk.object.class ~= "prefab" then
		-- object
		if chunk.object.class == "icon" then
			local tex, atlas = _LookupIcon(chunk.object.value)
			if not atlas then
				--error("[insight]: attempt to lookup invalid icon: " .. tostring(chunk.object.value))
				--tex = "White_Square.tex"
				--atlas = "images/White_Square.xml"
				tex, atlas = _LookupIcon("blank")
			end
			obj = Image()
			imageLib.SetTexture(obj, atlas, tex)
			obj:SetSize(richtext.font_size - 2, richtext.font_size - 2) -- 30, 30 a bit too large
			obj:SetTint(unpack(color))
			--obj:SetTint(unpack(Color.fromHex("#")))
		else
			error("[Insight]: unrecognized object class: " .. tostring(chunk.object.class))
		end
	else
		-- text
		local size = richtext.font_size
		local modifiers = {}
		if chunk:HasTag("sub") then -- this takes priority.
			-- subscript
			-- in microsoft word, subscript and superscript seem to be 2/3 of the size of normal text at the same font size. guess i'm using that. (12pt subscript = 8pt normal, 8 / 12 = 0.666)
			size = size * 2/3
			modifiers.sub = true
		elseif chunk:HasTag("sup") then
			-- superscript
			size = size * 2/3
			modifiers.sup = true
		end

		local text = nil
		if is_object then
			-- prefab class
			local prefab = chunk.object.value
			text = GetPrefabNameOrElse(prefab, "[prefab \"%s\"]")
		else
			text = chunk.text
		end
		obj = Text(richtext.font, size, text)
		obj:SetColour(color)
		obj.modifiers = modifiers

		--[[
		-- note: if this is brought back, cannot apply when either sub or sup is active. stick it last in the elseif.
		if chunk:HasTag("u") then
			local w, h = obj:GetRegionSize()
			local underline = obj:AddChild(Image("images/White_Square.xml", "White_Square.tex"))
			underline:SetTint(color.r, color.g, color.b, color.a)
			underline:SetSize(w - 2, 2)
			underline:SetPosition(-4, -15 + 3)
			underline:MoveToBack()
		end
		--]]
	end

	return obj
end

--------------------------------------------------------------------------
--[[ RichText ]]
--------------------------------------------------------------------------
local RichText = Class(Widget, function(self, font, size, text, colour)
	Widget._ctor(self, "RichText")

	self.lines = {}

	self.font = UIFONT
	self.font_size = 30
	self.raw_text = nil
	self.default_colour = "#ffffff"
	self._colour = Color.fromHex(self.default_colour)

	if font then
		self:SetFont(font)
	end

	if size then
		self:SetSize(size)
	end

	if colour then
		self:SetColour(colour)
	end
	
	if text then
		self:SetString(text)
	end
end)

function RichText:GetColour()
	return self._colour
end

function RichText:SetColour(clr, ...) -- Text::SetColour
	local old = self.default_colour

	if type(clr) == "string" then
		assert(Color.IsValidHex(clr), "RichText:SetColour with invalid hex")

		self._colour = Color.fromHex(clr)
		self.default_colour = clr

	elseif type(clr) == "number" then
		self._colour = Color.new(clr, ...)
		self.default_colour = self._colour:ToHex()

	else
		self._colour = clr
		self.default_colour = clr:ToHex()
	end

	if self.default_colour ~= old then
		self:SetString(self:GetString(), true)
	end
end

function RichText:GetFont()
	return self.font
end

function RichText:SetFont(font)
	if self.font == font then
		return
	end

	self.font = font
	self:SetString(self:GetString(), true)
end

function RichText:SetSize(num)
	assert(type(num) == "number", "RichText:SetSize expected arg #1 to be number")
	
	if self.font_size == num then
		return
	end

	self.font_size = num
	self:SetString(self:GetString(), true)
end

function RichText:GetString()
	return self.raw_text
end

function RichText:SetString(str, forced)
	if not forced and self.raw_text == str then
		-- why change?
		return
	end
	
	self.raw_text = str
	self:KillAllChildren()
	self.lines = {}

	--[[
	local m = self:AddChild(Image("images/White_Square.xml", "White_Square.tex"))
	local t = self:AddChild(Text(UIFONT, 30, "please work good"))
	m:SetSize(t:GetRegionSize())
	t:SetPosition(4, -1)
	--]]

	--[[
	local m = self:AddChild(Image("images/White_Square.xml", "White_Square.tex"))
	local t = self:AddChild(Text(UIFONT, 30, "饥饿速度降低: yep"))
	m:SetSize(t:GetRegionSize())
	t:SetPosition(4, -1)
	--]]

	if str == nil then
		self._width = 0
		self._height = 0
		return
	end

	self._width = nil
	self._height = nil

	local lines = {}

	local chunks = Reader:new(str):Read()
	local i = 1;
	local lineCount = 1
	--print(str)
	while chunks[i] do
		-- create line if missing
		lines[lineCount] = lines[lineCount] or {}
		local line = lines[lineCount]

		-- figure out chunk data
		local chunk = chunks[i]
		local is_object = chunk:IsObject()

		--local r = (is_object and GetPrefabNameOrElse(chunk.object.value, "[prefab \"%s\"]")) or chunk.text
		--print(i, (is_object and GetPrefabNameOrElse(chunk.object.value, "[prefab \"%s\"]")) or chunk.text, type(r)=="string" and #r or nil)

		if (is_object and chunk.object.class == "prefab") or (not is_object) then
			-- text based chunk
			local text = (is_object and GetPrefabNameOrElse(chunk.object.value, "[prefab \"%s\"]")) or chunk.text

			-- It seems the first line has some logic different to the rest of the processed text, but the comments in the for loop still hold.
			for a, x, b in string.gmatch(text, "(\n*)([^\n]*)(\n*)") do
				--print("\t", x, ("(%s, %s, %s)"):format(#a, #x, #b))

				-- I'm not 100% sure why I needed a AND b, but I guess "a" works for situations where there is a previous separator to be parsed.
				-- Without it, information separated in multiple descriptors largely doesn't work properly. So,
				-- This is responsible for separating descriptor returns with newlines.
				for j = 1, #a do -- so we don't skip any empty lines if we have a \n\n (untested)
					lineCount = lineCount + j
					lines[lineCount] = lines[lineCount] or {}
					line = lines[lineCount]
				end
				
				-- This check and the * specifier in the not-newline match is dealing with chunks where it's just an empty newline character.
				if #x > 0 then
					-- Redo the chunk
					line[#line+1] = Chunk:new{
						text = x,
						tags = chunk.tags
					}
				end

				-- This is responsible for allowing descriptors that have descriptions with multiple lines to be separated.
				for j = 1, #b do -- so we don't skip any empty lines if we have a \n\n (untested)
					lineCount = lineCount + j
					lines[lineCount] = lines[lineCount] or {}
					line = lines[lineCount]
				end
			end
		else
			-- miscellaneous chunk, add it to the line
			line[#line+1] = chunk
		end

		i = i + 1
	end

	for i = 1, #lines do
		-- Only render lines that aren't empty. Added because there's sometimes a newline left over at the end with no text after. 
		if lines[i] and #lines[i] > 0 then
			self:NewLine(lines[i])
		end
	end
end

function RichText:GetRegionSize()
	if self._width and self._height then
		return self._width, self._height
	end

	local width, height = 0, 0

	for i = 1, #self.lines do
		local v = self.lines[i]
		height = height + v.height
		if v.width > width then
			width = v.width
		end
	end

	self._width = width
	self._height = height
	return width, height
end

function RichText:SetRegionSize()
	error("RichText does not support SetRegionSize.")
end

function RichText:ResetRegionSize()
	error("RichText does not support ResetRegionSize.")
end

-- ok time for the good stuf
function RichText:NewLine(pieces)
	local container = self:AddChild(Widget("container" .. #self.lines + 1))
	self.lines[#self.lines+1] = container

	-- create text objects
	local len_pieces = #pieces
	local texts = createTable(len_pieces)
	for i = 1, len_pieces do
		texts[#texts+1] = container:AddChild(InterpretReaderChunk(pieces[i], self))
	end

	local padding = 0

	-- position them
	for i = 1, len_pieces do -- same as texts
		local obj = texts[i]
		local prev = texts[i-1]
		local lp = 0
		local x = 0
		local y = (obj.name == "Image" and 2) or 0 -- -1

		-- REGION SIZES AREN'T EXACT AND SPACES VARY IN WIDTH DEPENDING ON POSITION IN SetString
		-- I SPENT HOURS WONDERING WHAT WAS GOING ON
		-- MY FURY KNOWS NO BOUNDS
		-- THEN I SPENT MORE HOURS FIXING MY WRONG MATH
		-- I really don't get the inconsistency. It's so incredibly frustrating.
		-- And to rub salt in a wound, text objects aren't even aligned within their own damn object.

		--[[ [dst]
			1.6 width if space comes at end
			space by itself is 4.2
		 	two spaces is 9.6
		 	three spaces is 15.0
		]]

		--[[ [ds]
			variable width if space comes at end
			space by itself is 7.8
			two spaces is 13.2
			three spaces is 18.6
		]]


		if prev then
			lp = prev:GetPosition().x

			local end_spaces = 0
			if prev.name == "Image" then
				lp = lp + prev:GetSize() / 2
				
			else
				lp = lp + prev:GetRegionSize() / 2

				if Is_DST then
					lp = lp - 2
					padding = padding + 2
				end

				end_spaces = #string.match(prev:GetString(), "(%s*)$")
			end
			

			if obj.name == "Image" then
				lp = lp + obj:GetSize() / 2
			else
				lp = lp + obj:GetRegionSize() / 2

				if not Is_DST and prev.name ~= "Image" then
					lp = lp - 3.9
					padding = padding + 3.9
				end
			end

			if end_spaces > 0 then
				--lp = lp - 1.6
				--padding = padding + 1.6

				if Is_DST then
					-- commented when was fiddling with icon mode
					--lp = lp - 1.6 -- space width at end
					--padding = padding + 1.6

					--lp = lp + CalculateSize(string.rep(" ", end_spaces)) - 0.8
					--padding = padding - CalculateSize(string.rep(" ", end_spaces)) + 0.8

					-- this solution works for both text and icons, sweet
					lp = lp + CalculateSize(string.rep(" ", end_spaces)) / 2
					padding = padding - CalculateSize(string.rep(" ", end_spaces)) / 2
				end
			end
		end

		-- subscript/superscript
		if obj.name == "Text" then
			if obj.modifiers.sub then -- subscript
				y = y - (obj:InsightGetSize() * 1/3) -- 1/3 made sense, and it seems to match up perfectly with my test document. this was so.. nice? to add, after the hell this file has put me through.
			elseif obj.modifiers.sup then
				y = y + (obj:InsightGetSize() * 1/3)
			end
		end
		
		obj:SetPosition(lp + x, y)
	end

	local width = 0

	for i = 1, len_pieces do
		local v = texts[i]
		if i > 1 then
			
			local w = (v.name == "Image" and v:GetSize()) or v:GetRegionSize()
			width = width - w / 2
			

			--width = width - v:GetRegionSize() / 2 - 2
		end
	end

	width = width + padding / 2

	--[[
		str = "Sanity: +4.4/min"
		two orange pieces: "Sanity" and "+4.4/min"
		1. width of "+4.4/min" is 80.4
		2. the first piece is always irrelevant, its pos is set to 0
		3. -80.4 overshoots left
		4. -40.2 (aka half of that) is nearly a perfect even besides irritable spacing at ends
		5. so we can assume the relevant offsets come from every width/2 after the first one
		6. doing that has a "perfect" middle balance, ignoring end spacing
		7. we know that spacing is accounted for above
		8. and since we had to halve the width because of position logic, we need to halve that spacing as well
		9. it. is. done. I have spent over 8 hours on this spacing.
		10. never been good at uis.
	]]

	container:SetPosition(
		--cc:GetPosition().x / 2, 
		width, 
		-self.font_size * (#self.lines - 1)
	)
	
	local wax = 0
	for i = 1, len_pieces do
		local v = texts[i]
		local w = (v.name == "Image" and v:GetSize()) or v:GetRegionSize()
		wax = wax + w
	end

	--[[
	local a, b = CalculateSize(self:GetString())
	print("COMPARISON", self:GetString(), "-> width: ", width, "|wax:", wax, "| diff:", wax-padding/2, "Watson:", a, "| fat:", fat)
	--]]



	--print(fat, width, math.abs(width) * 2)
	
	-- size me up
	--container:SetSize(width, 30)
	container.width = wax --math.abs(width) * 2
	container.height = self.font_size 

	return container
end

function RichText:__tostring()
	return string.format("%s - %s", self.name, self.raw_text or "<null>")
end


return RichText