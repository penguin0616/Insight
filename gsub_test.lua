local str = "hey there jimbo,\nhow you doing? sometimes reality is kind of\n funky, no?"
local function get_line_count(str)
    local lines = 1
    for i = 1, #str do
        local c = str:sub(i, i)
        if c == '\n' then lines = lines + 1 end
    end

    return lines
end

local function cl(txt)
	local i = 1
	txt:gsub("\n", function() i = i + 1 end)
end

local start1 = os.clock()
for i = 1, 999999 do
	local count  = select(2, str:gsub('\n', '\n'))
end
local end1 = os.clock()


local start2 = os.clock()
for i = 1, 999999 do
	get_line_count(str)
end
local end2 = os.clock()

local start3 = os.clock()
for i = 1, 999999 do
	cl(str)
end
local end3 = os.clock()

print(end1-start1)
print(end2-start2)
print(end3-start3)
