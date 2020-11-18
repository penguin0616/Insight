--[[
Copyright (C) 2020 penguin0616

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

local Color = { __metatable = "Color" }
setmetatable(Color, Color)

-- Functions
local function isint(num)
	return type(num) == "number" and num == math.floor(num)
end

--- Converts a hexadecimal number or string to it's RGBA components.
-- @tparam string hex A hexadecimal string.
-- @treturn int,int,int,int
local function HexToRGBA(hex)
	local typ = type(hex)
	if typ == "string" then
		if hex:sub(1,1) == "#" then
			hex = hex:sub(2)
		end

		--hex = tonumber(hex, 16)
	--elseif typ == "number" then
		--typ = tostring(hex)
	else
		error("bad argument #1 to HexToRGB (number or string expected, got " .. typ .. ")")
		return
	end

	local r, g, b, a = tonumber(hex:sub(1,2), 16), tonumber(hex:sub(3,4), 16), tonumber(hex:sub(5,6), 16), 255

	-- check if there are 8 characters
	if #hex == 8 then
		a = tonumber(hex:sub(7, 8), 16)
	end

	return r, g, b, a
end

function Color.ToHex(self)
	-- https://github.com/Perkovec/colorise-lua
	local hexadecimal = '#'

	local r = assert(self.r or self[1], "missing r in arg #1")
	local g = assert(self.g or self[2], "missing g in arg #1")
	local b = assert(self.b or self[3], "missing b in arg #1")

	local rgb = {math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)}

	for key = 1, #rgb do
		local value = rgb[key] 
		local hex = ''

		while (value > 0) do
			local index = math.fmod(value, 16) + 1
			value = math.floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end
		
		if (string.len(hex) == 0) then
			hex = '00'
		elseif (string.len(hex) == 1) then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end

	return hexadecimal
end

--- Creates a new Color 'object' from a hexadecimal string.
-- @tparam string hex
-- @treturn Color
function Color.fromHex(hex)
	local r, g, b, a = HexToRGBA(hex)
	return Color.fromRGBA(r, g, b, a)
end

--- Creates a new Color 'object' from RGBA.
--- Uses values between 0 and 255.
-- @int r Red (defaults to 0).
-- @int g Green (defaults to 0).
-- @int b Blue (defaults to 0).
-- @int a Alpha (defaults to 255).
-- @treturn Color
function Color.fromRGBA(r, g, b, a)
	r, g, b, a = r or 0, g or 0, b or 0, a or 255

	local rs, gs, bs, as = isint(r), isint(g), isint(b), isint(a)
	
	assert(rs, "bad argument #1 to Color (red must be an integer)")
	assert(gs, "bad argument #2 to Color (green must be an integer)")
	assert(bs, "bad argument #3 to Color (blue must be an integer)")
	assert(as, "bad argument #4 to Color (alpha must be an integer)")

	assert(r <= 255 and r >= 0, "bad argument #1 to Color (red must be between 0 and 255)")
	assert(g <= 255 and g >= 0, "bad argument #2 to Color (green must be between 0 and 255)")
	assert(b <= 255 and b >= 0, "bad argument #3 to Color (blue must be between 0 and 255)")
	assert(a <= 255 and r >= 0, "bad argument #4 to Color (alpha must be between 0 and 255)")

	r = r / 255
	g = g / 255
	b = b / 255
	a = a / 255

	return Color.new(r, g, b, a)
end

--- Creates a new Color 'object' from RGB.
--- Uses values between 0 and 255.
-- @int r Red (defaults to 0).
-- @int g Green (defaults to 0).
-- @int b Blue (defaults to 0).
-- @treturn Color
function Color.fromRGB(r, g, b)
	return Color.fromRGBA(r, g, b)
end

function Color:Lerp(target, percent)
	-- lerp(a, b, x) == a + (b - a) * x;

	return Color.new(
		self.r + (target.r - self.r) * percent, 
		self.g + (target.g - self.g) * percent, 
		self.b + (target.b - self.b) * percent
	) 
end

local __tostring = function(self) return string.format("Color (%s, %s, %s, %s)", self.r * 255, self.g * 255, self.b * 255, self.a * 255) end
--- Creates a new Color 'object'.
--- Uses values between 0 and 1.
-- @number r Red (defaults to 0).
-- @number g Green (defaults to 0).
-- @number b Blue (defaults to 0).
-- @number a Alpha (defaults to 1).
-- @treturn Color
function Color.new(r, g, b, a)
	local self = {}
	setmetatable(self, {
		__index = Color, 
		__tostring = __tostring,
		-- based on order executed
		__mul = function(self, multiplier)
			return Color.new(self.r * multiplier, self.g * multiplier, self.b * multiplier, self.a)
		end,
		__div = function(self, divisor)
			return Color.new(self.r / divisor, self.g / divisor, self.b / divisor, a)
		end,
		__add = function(self, add)
			local ar, ag, ab
			
			if type(add) == "number" then
				ar, ag, ab = add, add, add
			elseif type(add) == "table" and getmetatable(add).__tostring == __tostring then
				ar, ag, ab = add.r, add.g, add.b
			end

			return Color.new(self.r + ar, self.g + ag, self.b + ab, self.a)
		end,
		__sub = function(self, sub)
			local ar, ag, ab
			
			if type(sub) == "number" then
				ar, ag, ab = sub, sub, sub
			elseif type(sub) == "table" and getmetatable(sub).__tostring == __tostring then
				ar, ag, ab = sub.r, sub.g, sub.b
			end

			return Color.new(self.r - ar, self.g - ag, self.b - ab, self.a)
		end,
	})
	-- this works because only metamethods are triggered and there's no __index to reference Color


	r, g, b, a = r or 0, g or 0, b or 0, a or 1

	local rt, gt, bt, at = type(r), type(g), type(b), type(a)
	
	assert(rt, "bad argument #1 to Color (red must be a number)")
	assert(gt, "bad argument #2 to Color (green must be a number)")
	assert(bt, "bad argument #3 to Color (blue must be a number)")
	assert(at, "bad argument #4 to Color (alpha must be a number)")

	assert(r <= 1 and r >= 0, "bad argument #1 to Color (red must be between 0 and 1)")
	assert(g <= 1 and g >= 0, "bad argument #2 to Color (green must be between 0 and 1)")
	assert(b <= 1 and b >= 0, "bad argument #3 to Color (blue must be between 0 and 1)")
	assert(a <= 1 and r >= 0, "bad argument #4 to Color (alpha must be between 0 and 1)")

	-- numerical
	self[1] = r
	self[2] = g
	self[3] = b
	self[4] = a

	-- key
	self.r = r
	self.g = g
	self.b = b
	self.a = a

	return self
end

return Color

--[[
local good = Color.fromHex("#A5CEAD") --Color.fromHex(Insight.COLORS.NATURE)
local bad = Color.fromHex(Insight.COLORS.DECORATION) * .75

-- GetTime() / 3
local function rgb(hue)  
	local section = hue % 1 * 3;
	local secondary = 0.5 * math.pi * (section % 1);
	if section < 1 then 
		return Color.new(1, 1 - math.cos(secondary), 1 - math.sin(secondary));
	elseif section < 2 then 
		return Color.new(1 - math.sin(secondary), 1, 1 - math.cos(secondary));
	else 
		return Color.new(1 - math.cos(secondary), 1 - math.sin(secondary), 1);
	end;
end;
--]]