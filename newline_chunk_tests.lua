local Reader = require"scripts/reader"
local Chunk = Reader._Chunk

--str1 = "hey chief,\nwhat's happening?"
str2 = "<color=#fff333>hey jimbo, whats\nup?</color>"
str3 = "\n\nwhat?\nso true matey"
str4 = "\n \n what?\n so true matey"

local function DoGoodThing(str)
	local chunks = Reader:new(str):Read()
	local origin = Reader.Stringify(chunks, true)
	local lines = setmetatable({}, { __index=function(self, index) local x = {} rawset(self, index, x) return x end })
	local i = 1;
	local lineCount = 1

	--[[
	print("new string:")
	print("|"..str.."|\n")
	print("------------------")
	print("cleaned:")
	print("|"..origin.."|\n")
	--]]

	while chunks[i] do
		local line = lines[lineCount]
		local llen = #line
		local chunk = chunks[i]

		local is_object = chunk:IsObject()

		if (is_object and TEXT_BASED_OBJECTS[chunk.object.class]) or not is_object then
			-- Process Text-Based-Objects (TBOs) and normal text chunks
			-- TBOs will be transformed into text chunks here
			local text = is_object == false and chunk.text 
			if is_object then
				-- Rebuild the chunk. This is a destructive transformation, the original chunk will not be preserved.
				text = TEXT_BASED_OBJECTS[chunk.object.class](chunk)
				local new_chunk = Chunk:new{
					text = text,
					tags = chunk.tags
				}
				chunks[i] = new_chunk
				chunk = new_chunk
			end
			
			-- Now we need to deal with cases where our chunks have newlines in them.
			-- When we hit a newline, we need to break off the current one and continue onto a new one.
			-- The issue is, we need to maintain the tag state when we do so.
			--[[
			print("GMATCH START")
			for segment in string.gmatch(text, "([^\n]+)") do
				print("|"..segment.."|")
			end
			print("GMATCH END")
			--]]

			while true do
				local x, y = string.find(text, "\n")
				--print(s, e)
				if not x then
					-- No newlines, this chunk is all good.
					--print("Adding chunk:|"..text.."|")
					llen = llen + 1
					chunk.text = text
					line[llen] = chunk
					break
				else
					-- This has a newline.
					--print("Chunk has newline:|"..text.."|")
					llen = llen + 1
					line[llen] = Chunk:new{
						text = string.sub(text, 1, y-1), -- y-1 to not include the newline
						tags = chunk.tags
					}
					--print("Added chunk with text:|"..line[llen].text.."|")
					lineCount = lineCount + 1; line = lines[lineCount]; llen = #line;
					start = y + 1
					text = text:sub(start)
					--print("Leftover text:|"..text.."|")
				end
			end
		else
			-- Everything else is a normal object (ie an icon)
			--print("@@@@@@@@@@@@@@@@@@@ Added object", chunk)
			llen = llen + 1
			line[llen] = chunk
		end

		i = i + 1
	end

	local new_str = ""
	for i,v in pairs(lines) do
		new_str = new_str .. Reader.Stringify(v, true)
		if i < #lines then
			new_str = new_str .. "\n"
		end
	end
	--print("\nNEW MATCHES ORIGINAL:", new_str == origin)
	--print("|"..new_str.."|\n")

	return new_str
end

local function DoThing(str)
	local chunks = Reader:new(str):Read()
	local origin = Reader.Stringify(chunks, true)
	local lines = setmetatable({}, { __index=function(self, index) local x = {} rawset(self, index, x) return x end })
	local i = 1;
	local lineCount = 1

	
	print("new string:")
	print("|"..str.."|\n")
	print("------------------")
	print("cleaned:")
	print("|"..origin.."|\n")
	

	while chunks[i] do
		local line = lines[lineCount]
		local llen = #line
		local chunk = chunks[i]

		local is_object = chunk:IsObject()

		if (is_object and TEXT_BASED_OBJECTS[chunk.object.class]) or not is_object then
			-- Process Text-Based-Objects (TBOs) and normal text chunks
			-- TBOs will be transformed into text chunks here
			local text = is_object == false and chunk.text 
			if is_object then
				-- Rebuild the chunk. This is a destructive transformation, the original chunk will not be preserved.
				text = TEXT_BASED_OBJECTS[chunk.object.class](chunk)
				local new_chunk = Chunk:new{
					text = text,
					tags = chunk.tags
				}
				chunks[i] = new_chunk
				chunk = new_chunk
			end
			
			-- Now we need to deal with cases where our chunks have newlines in them.
			-- When we hit a newline, we need to break off the current one and continue onto a new one.
			-- The issue is, we need to maintain the tag state when we do so.
			print("GMATCH START\n")
			for segment, newlines in string.gmatch(text, "([^\n]*)(\n*)") do
				print("GMATCH ITER|"..segment.."|" .. #newlines)
				if #segment > 0 then
					--print("Processing text:|" .. segment .."|")
					-- We've got text, add it to the line.
					llen = llen + 1
					line[llen] = Chunk:new{
						text = segment,
						tags = chunk.tags
					}
				end

				print(string.format("Adding '%d' newlines.", #newlines))
				-- For every newline, we need to increase the lineCount.
				for i = 1, #newlines do
					lineCount = lineCount + 1; line = lines[lineCount]; llen = #line;
				end

				
			end
			print("GMATCH END\n")
		else
			-- Everything else is a normal object (ie an icon)
			--print("@@@@@@@@@@@@@@@@@@@ Added object", chunk)
			llen = llen + 1
			line[llen] = chunk
		end

		i = i + 1
	end

	local new_str = ""
	for i,v in pairs(lines) do
		new_str = new_str .. Reader.Stringify(v, true)
		if i < #lines then
			new_str = new_str .. "\n"
		end
	end

	print(#lines)
	
	print("\nNEW MATCHES ORIGINAL:", new_str == origin)
	print("|"..new_str.."|\n")

	return new_str
end

--DoGoodThing(str1)
print("=======================================================================================")
x = DoThing(str2)
y = DoGoodThing(str2)
print(x == y)
print(x)
print(y)
print("=======================================================================================")
x = DoThing(str3)
y = DoGoodThing(str3)
print(x == y)
print(x)
print(y)
print("=======================================================================================")
--DoGoodThing(str4)


