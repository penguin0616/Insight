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

--[[ structs
	reader.tags {
		{ name = "tag_name", value = "tag_value" },
		{ name = "tag_name_2", value = "tag_value_2" },
		...
	}
	ex: <tag_name=tag_value>...</tag_name>
	
	object {
		class = "object_class",
		value = "object_value"
	}
	ex: <object_class=object_value>
--]]


local skip_closing = {icon=true}

local function GenerateErrorString(rdr, desc)
	return "parsing error" .. "\noriginal: " .. rdr.original .. "\nbuffer (#" .. #rdr.buffer .. "): " .. rdr.buffer .. "\nerror: " .. (desc or "not specified")
end

local function SameContents(a, b)
	if #a ~= #b then
		return false
	end
	
	if type(a) ~= type(b) then
		return false
	end
	
	for i,v in pairs(a) do
		if not (v.name == b[i].name and v.value == b[i].value) then
			return false
		end
	end
	
	return true
end

local Chunk = {}

function Chunk:GetTags()
	return self.tags
end

function Chunk:GetTag(name)
	for i = #self.tags, 1, -1 do
		local tag = self.tags[i]
		if tag.name == name then
			return tag.value
		end
	end
	
	--[[
	for _, tag in pairs(self.tags) do
		if tag.name == name then
			return tag.value
		end
	end
	--]]
end

function Chunk:HasTag(name)
	for _, tag in pairs(self.tags) do
		if tag.name == name then
			return true
		end
	end
end

function Chunk:IsObject()
	return self.object ~= nil
end

function Chunk:new(o)
	setmetatable(o, self)
	self.__index = self
	return o
end

local Reader = {}

function Reader:ReadTag()
	--print('buffer:', self.buffer)
	if string.sub(self.buffer, 1, 2) == "</" then -- maybe closing tag
		--print'closing tag check'
		local tag, fin = string.match(self.buffer, "^</(%w+)>()")
		if tag then  -- closing tag
			--print'closing tag'
			local currentTag = self.currentTags[#self.currentTags]
			if currentTag.name == tag then
				table.remove(self.currentTags, #self.currentTags)
			else
				-- time to error, but what do i display
				local err 
				if skip_closing[tag] then
					err = GenerateErrorString(self, "attempt to close tag (" .. tag .. ") that cannot be closed")
					--err = err .. "\nerror: attempt to close tag (" .. tag .. ") that cannot be closed"
				else
					err = GenerateErrorString(self, "closing tag (" .. tag .. ") does not equal last opening tag (" .. currentTag.name .. ")")
					--err = err .. "\nerror: closing tag (" .. tag .. ") does not equal last opening tag (" .. currentTag.name .. ")"
				end
				error(err)
			end
			self.buffer = string.sub(self.buffer, fin)
			return true
			--[[
			for i = #self.currentTags, 1, -1 do
				if self.currentTags[i][1] == tag then
					-- pop the tag
					table.remove(self.currentTags, i)
					
					return true
				end
			end
			--]]
		end
	elseif string.sub(self.buffer, 1, 1) == "<" then -- maybe opening tag
		--print'opening tag check'
		local whole_tag = string.match(self.buffer, "<([^>]+)>")
	
		--print(string.match == self.buffer.match)
		--print(pcall(string.dump, string.match))
		local tag, value, fin = string.match(self.buffer, "^<(%w+)=?([#_%w]*)>()")
		--print(tag, value, fin)
		if value == "" then
			value = nil
		end
		
		if tag then -- opening tag
			--print'opening tag'
			if skip_closing[tag] then -- object tag
				--print'obj tag'
				self:SaveObject(tag, value)
			else -- descriptor tag
				--print('inserting tag', tag, value)
				table.insert(self.currentTags, {name=tag, value=value}) -- ISSUE:PERFORMANCE (TEST#12)
			end
			
			self.buffer = string.sub(self.buffer, fin)
			return true
		end
	end
end

function Reader:Save(str)
	-- minimize chunks if possible
	local tags = {unpack(self.currentTags)}
	local lastChunk = self.chunks[#self.chunks]
	
	if lastChunk and lastChunk.text then -- has to be a text chunk
		if SameContents(lastChunk.tags, tags) then
			lastChunk.text = lastChunk.text .. str; return
		end
	end

	-- ISSUE:PERFORMANCE (TEST#12)
	table.insert(self.chunks, Chunk:new{
		text = str,
		tags = {unpack(self.currentTags)}
	})
end

function Reader:SaveObject(class, value)
	-- ISSUE:PERFORMANCE (TEST#12)
	table.insert(self.chunks, Chunk:new{
		object = {class=class, value=value},
		tags = {unpack(self.currentTags)}
	})
end

function Reader:Seek()
	local start = string.find(self.buffer, "<")
	
	if start then
		if start > 1 then
			self:Save(string.sub(self.buffer, 1, start - 1))
			self.buffer = string.sub(self.buffer, start)
		else
			local tagProcessed = self:ReadTag()
			if not tagProcessed then
				-- not a tag, increment to next character
				self:Save(string.sub(self.buffer, 1, 1))
				self.buffer = string.sub(self.buffer, 2)
			end
		end
	else
		self:Save(self.buffer)
		self.buffer = ""
	end
end

function Reader:Read()
	while #self.buffer > 0 do
		self:Seek()
	end
	
	if #self.currentTags > 0 then
		local err = GenerateErrorString(self, "reader terminated with tags not resolved")
		printtable(self.currentTags)
		error(err, 0)
		return
	end
	
	self.currentTags = nil
	
	return self.chunks
end

function Reader:new(line)
	local o = {
		original = nil,
		buffer = nil,
		chunks = {},
		currentTags = {},
	}
	-- create object if user does not provide one
	setmetatable(o, self)
	self.__index = self
	
	o.original = line
	o.buffer = o.original
	
	return o
end

function Reader.Stringify(chunks)
	local rebuilt = ""

	for i, chunk in pairs(chunks) do
		if chunk:IsObject() then
			rebuilt = rebuilt .. string.format("<%s=%s>", chunk.class, chunk.value)
		else
			local str = chunk.text

			for i,v in pairs(chunk.tags) do
				str = string.format("<%s=%s>%s</%s>", v.name, v.value, str, v.name)
			end

			rebuilt = rebuilt .. str
		end
	end

	return rebuilt
end

-- i could optimize the strings by ignoring spaces between tags and just associate them to previous tags
--local str = "<color=#E4FF01> #E4FF01 </color><color=#01E4FF> #01E4FF </color><color=#FF01E4> #FF01E4 </color"
--local str = "<color=#E4FF01> #E4FF01 </color> <color=#E4FF01> FAT </color>"
--local chks = Reader:new(str):Read()

return Reader