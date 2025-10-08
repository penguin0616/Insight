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

local getmetatable, setmetatable, type, tonumber, tostring, assert = getmetatable, setmetatable, type, tonumber, tostring, assert
local math_floor = math.floor
local math_fmod = math.fmod
local math_max = math.max
local math_min = math.min

--------------------------------------------------------------------------
--[[ Private Functions ]]
--------------------------------------------------------------------------
local function isint(num)
	return type(num) == "number" and num%1==0 -- see util -> IsInt
end

local function IsValidHex(str)
	return 
		type(str) == "string"
		and str:sub(1, 1) == "#"
		and (#str == 7 or #str == 9)
end

--- Converts a hexadecimal number or string to it's RGBA components.
---@param hex string A hexadecimal string.
---@return int,int,int,int
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


--------------------------------------------------------------------------
--[[ Color ]]
--------------------------------------------------------------------------
local Color = { IsValidHex=IsValidHex, __metatable="Color" }
setmetatable(Color, Color)

function Color.ToHex(self)
	if self.hex then
		return self.hex
	end

	-- https://github.com/Perkovec/colorise-lua
	local hexadecimal = '#'

	
	local r = self.r or self[1] or error("missing r in arg #1")
	local g = self.g or self[2] or error("missing g in arg #1")
	local b = self.b or self[3] or error("missing b in arg #1")

	local rgb = {math_floor(r * 255), math_floor(g * 255), math_floor(b * 255)}

	for key = 1, #rgb do
		local value = rgb[key] 
		local hex = ''

		while (value > 0) do
			local index = math_fmod(value, 16) + 1
			value = math_floor(value / 16)
			hex = string.sub('0123456789ABCDEF', index, index) .. hex			
		end
		
		if (string.len(hex) == 0) then
			hex = '00'
		elseif (string.len(hex) == 1) then
			hex = '0' .. hex
		end
		hexadecimal = hexadecimal .. hex
	end

	self.hex = hexadecimal

	return hexadecimal
end

--- Creates a new Color 'object' from a hexadecimal string.
---@param hex string
---@return Color
function Color.fromHex(hex)
	local r, g, b, a = HexToRGBA(hex)
	local self = Color.fromRGBA(r, g, b, a)
	self.hex = hex
	return self
end

--- Creates a new Color 'object' from RGBA.
--- Uses values between 0 and 255.
-- @int r Red (defaults to 0).
-- @int g Green (defaults to 0).
-- @int b Blue (defaults to 0).
-- @int a Alpha (defaults to 255).
---@return Color
function Color.fromRGBA(r, g, b, a)
	r, g, b, a = r or 0, g or 0, b or 0, a or 255

	local rs, gs, bs, as = isint(r), isint(g), isint(b), isint(a)
	
	if not rs then 
		error("bad argument #1 to Color (red must be an integer)")
	end
	if not gs then 
		error("bad argument #2 to Color (green must be an integer)")
	end
	if not bs then 
		error("bad argument #3 to Color (blue must be an integer)")
	end
	if not as then 
		error("bad argument #4 to Color (alpha must be an integer)")
	end

	if not (r <= 255 and r >= 0) then
		error("bad argument #1 to Color (red must be between 0 and 255)")
	end
	if not (g <= 255 and g >= 0) then
		error("bad argument #2 to Color (green must be between 0 and 255)")
	end
	if not (b <= 255 and b >= 0) then
		error("bad argument #3 to Color (blue must be between 0 and 255)")
	end
	if not (a <= 255 and r >= 0) then
		error("bad argument #4 to Color (alpha must be between 0 and 255)")
	end

	r = r / 255
	g = g / 255
	b = b / 255
	a = a / 255

	return Color.new(r, g, b, a)
end

function Color.fromScaledRGBA(r, g, b, a)
	return Color.fromRGBA(r * 255, g * 255, b * 255, a * 255)
end

--- Creates a new Color 'object' from RGB.
--- Uses values between 0 and 255.
-- @int r Red (defaults to 0).
-- @int g Green (defaults to 0).
-- @int b Blue (defaults to 0).
---@return Color
function Color.fromRGB(r, g, b)
	return Color.fromRGBA(r, g, b, 255)
end

function Color.fromScaledRGB(r, g, b)
	return Color.fromRGB(r * 255, g * 255, b * 255)
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
---@param r number Red (defaults to 0).
---@param g number Green (defaults to 0).
---@param b number Blue (defaults to 0).
---@param a number Alpha (defaults to 1).
---@return Color
function Color.new(r, g, b, a)
	local self = {}
	setmetatable(self, {
		__index = Color, 
		__tostring = __tostring,
		-- based on order executed
		__mul = function(self, multiplier)
			local nr = self.r * multiplier
			local ng = self.g * multiplier
			local nb = self.b  * multiplier

			return Color.new(nr, ng, nb, self.a)
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

			local nr = math_min(self.r + ar, 1)
			local ng = math_min(self.g + ag, 1)
			local nb = math_min(self.b + ab, 1)

			return Color.new(nr, ng, nb, self.a)
		end,
		__sub = function(self, sub)
			local ar, ag, ab
			
			if type(sub) == "number" then
				ar, ag, ab = sub, sub, sub
			elseif type(sub) == "table" and getmetatable(sub).__tostring == __tostring then
				ar, ag, ab = sub.r, sub.g, sub.b
			end

			local nr = math_max(self.r - ar, 0)
			local ng = math_max(self.g - ag, 0)
			local nb = math_max(self.b - ab, 0)

			return Color.new(nr, ng, nb, self.a)
		end,
	})
	-- this works because only metamethods are triggered and there's no __index to reference Color


	r, g, b, a = r or 0, g or 0, b or 0, a or 1

	local rt, gt, bt, at = type(r), type(g), type(b), type(a)
	
	if not rt then
		error("bad argument #1 to Color (red must be a number)")
	end
	if not gt then
		error("bad argument #2 to Color (green must be a number)")
	end
	if not bt then
		error("bad argument #3 to Color (blue must be a number)")
	end
	if not at then
		error("bad argument #4 to Color (alpha must be a number)")
	end

	-- I'll turn these to logs instead of errors, since I am observing these cases over and over.
	-- Additionally, external mods are beginning to make use of Insight's coloring.
	if not (r <= 1 and r >= 0) then
		mprint("bad argument #1 to Color (red must be between 0 and 1)")
	end
	if not (g <= 1 and g >= 0) then
		mprint("bad argument #2 to Color (green must be between 0 and 1)")
	end
	if not (b <= 1 and b >= 0) then
		mprint("bad argument #3 to Color (blue must be between 0 and 1)")
	end
	if not (a <= 1 and r >= 0) then
		mprint("bad argument #4 to Color (alpha must be between 0 and 1)")
	end

	r = math.max(math.min(1, r), 0)
	g = math.max(math.min(1, g), 0)
	b = math.max(math.min(1, b), 0)
	a = math.max(math.min(1, a), 0)

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