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

local patcher_common = import("ds_patches/patcher_common")
local Text = require("widgets/text")

local patches = {
	_base = patcher_common.GetPatcher("widget")
}

local function IsWhiteSpace(charcode)
    -- 32: space
    --  9: \t
    return charcode == 32 or charcode == 9
end

local function IsNewLine(charcode)
    -- 10: \n
    -- 11: \v
    -- 12: \f
    -- 13: \r
    return charcode >= 10 and charcode <= 13
end

local old_ctor = Text._ctor
function patches._ctor(self, font, size, text)
	old_ctor(self, font, size, text)
	self:SetSize(size)
end

-- And with the ctor patch, this is mostly no longer needed too!
-- But I'm keeping it here for cases where a Text got initialized before the patch.
-- Unless I decide to add something that'll patch already-instantiated classes, but that seems like an even bigger bucket of worms.
-- Overall, very nice :)
function patches.GetSize(self)
	if not self.size then
		self.size = self.inst.TextWidget:GetSize()
	end

	return self.size
end

function patches:SetTruncatedString(str, maxwidth, maxchars, ellipses)
	local str_fits = true
    str = str ~= nil and str:match("^[^\n\v\f\r]*") or ""
    if #str > 0 then
        if type(ellipses) ~= "string" then
            ellipses = ellipses and "..." or ""
        end
        if maxchars ~= nil and str:len() > maxchars then -- utf8len
            str = str:sub(1, maxchars) -- utf8sub
            self.inst.TextWidget:SetString(str..ellipses)
			str_fits = false
        else
            self.inst.TextWidget:SetString(str)
        end
        if maxwidth ~= nil then
            while self.inst.TextWidget:GetRegionSize() > maxwidth do
                str = str:sub(1, -2) -- utf8sub
                self.inst.TextWidget:SetString(str..ellipses)
				str_fits = false
            end
        end
    else
        self.inst.TextWidget:SetString("")
    end
	return str_fits
end

function patches:SetMultilineTruncatedString_Impl(str, maxlines, maxwidth, maxcharsperline, ellipses)
	local str_fits = true
    if str == nil or #str <= 0 then
        self.inst.TextWidget:SetString("")
        return str_fits
    end
    local tempmaxwidth = type(maxwidth) == "table" and maxwidth[1] or maxwidth
    if maxlines <= 1 then
        str_fits = self:SetTruncatedString(str, tempmaxwidth, maxcharsperline, ellipses) -- returns true if the string was truncated
    else
        self:SetTruncatedString(str, tempmaxwidth, maxcharsperline, false)
        local line = self:GetString()
        if #line < #str then
            if IsNewLine(str:byte(#line + 1)) then
                str = str:sub(#line + 2)
            elseif not IsWhiteSpace(str:byte(#line + 1)) then
                local found_white = false
                for i = #line, 1, -1 do
                    if IsWhiteSpace(line:byte(i)) then
                        line = line:sub(1, i)
                        found_white = true
                        break
                    end
                end
                str = str:sub(#line + 1)

                if not found_white then
                    --Testing for finding areas where we've had to split on
                    --print("Warning: ".. line .. " was split on non-whitespace.")
                end
            else
                str = str:sub(#line + 2)
                while #str > 0 and IsWhiteSpace(str:byte(1)) do
                    str = str:sub(2)
                end
            end
            if #str > 0 then
                if type(maxwidth) == "table" then
                    if #maxwidth > 2 then
                        tempmaxwidth = {}
                        for i = 2, #maxwidth do
                            table.insert(tempmaxwidth, maxwidth[i])
                        end
                    elseif #maxwidth == 2 then
                        tempmaxwidth = maxwidth[2]
                    end
                end
                str_fits = self:SetMultilineTruncatedString_Impl(str, maxlines - 1, tempmaxwidth, maxcharsperline, ellipses)
                self.inst.TextWidget:SetString(line.."\n"..(self.inst.TextWidget:GetString() or ""))
            end
        end
    end

	return str_fits
end

function patches:SetMultilineTruncatedString(str, maxlines, maxwidth, maxcharsperline, ellipses, shrink_to_fit, min_shrink_font_size)
    if str == nil or #str <= 0 then
        self.inst.TextWidget:SetString("")
        return
    end

	if shrink_to_fit then
		--ensure that we reset the size back to the original size when we get new text
		if self.original_size ~= nil then
			self:SetSize( self.original_size )
		else
			self.original_size = self:GetSize()
		end
	end

	local str_fits = self:SetMultilineTruncatedString_Impl(str, maxlines, maxwidth, maxcharsperline, ellipses)
	while not str_fits and shrink_to_fit and LOC.GetShouldTextFit() and self:GetSize() > (min_shrink_font_size or 16) do -- the 16 is a semi reasonable "smallest" size that is okay. This is to stop stackoverflow from infinite recursion due to bad string data.
		local new_size = self:GetSize() - 1 --drop size to fit a whole word
		local shrinked_maxlines = math.floor(maxlines * self.original_size / new_size)  -- num lines that fit in original size

		self:SetSize( new_size )
		str_fits = self:SetMultilineTruncatedString_Impl(str, shrinked_maxlines, maxwidth, maxcharsperline, ellipses)
	end
end

return {
	patches = patches,
	Init = function() patcher_common.PatchClass(Text, patches) end,
}