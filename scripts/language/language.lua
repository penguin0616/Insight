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

local languages = {
	icons = "icons",
	en = "english",
	zh = "chinese", ch = "chinese",
	es = "spanish", mex = "spanish",
	br = "portuguese"
}

local __newindex = function(self) error(tostring(self) .. " is readonly") end
local __metatable = "[Insight] The metatable is locked."

--[[
local function set(tbl, target)
	setmetatable(tbl, {__index = target, __newindex=__newindex, __metatable=__metatable})

	for i,v in pairs(tbl) do
		if type(v) == "tbl" then
			set(v, rawget(tbl, i))
		end
	end
end
--]]

local function main(config, locale)
	local usingIcons = config["info_style"] == "icon"

	local selected = nil
	if config["language"] == "automatic" then
		selected = locale
		if languages[selected] == nil then
			selected = "en"
		end
	else
		selected = config["language"]
	end

	local secondaryLanguage = languages[selected] or error("[Insight]: Invalid language selected (report bug please): " .. tostring(config["language"]) .. "|" .. tostring(selected) .. "|" .. TheNet:GetLanguageCode()) 
	local primaryLanguage = (usingIcons and "icons") or secondaryLanguage

	local tertiaryLanguage = deepcopy(import("language/" .. languages.en))
	secondaryLanguage = deepcopy(import("language/" .. secondaryLanguage))

	if secondaryLanguage ~= tertiaryLanguage then
		
		for i,v in pairs(secondaryLanguage) do
			if type(v) == "table" then
				setmetatable(v, { __index = rawget(tertiaryLanguage, i), __newindex = __newindex, __metatable = __metatable })

				for j, k in pairs(v) do
					if type(k) == "table" then
						setmetatable(k, { __index = rawget(rawget(tertiaryLanguage, i), j), __newindex = __newindex, __metatable = __metatable })
					end
				end

			end
		end
		
		setmetatable(secondaryLanguage, { __index = tertiaryLanguage, __newindex = __newindex, __metatable = __metatable }) -- just in case
	end

	primaryLanguage = deepcopy(import("language/" .. primaryLanguage))

	if primaryLanguage ~= secondaryLanguage then
		for i,v in pairs(primaryLanguage) do
			if type(v) == "table" then
				setmetatable(v, { __index = rawget(secondaryLanguage, i), __newindex = __newindex, __metatable = __metatable })

				for j, k in pairs(v) do
					if type(k) == "table" then
						setmetatable(k, { __index = rawget(rawget(secondaryLanguage, i), j), __newindex = __newindex, __metatable = __metatable })
					end
				end

			end
		end

		setmetatable(primaryLanguage, { __index = secondaryLanguage, __newindex = __newindex, __metatable = __metatable })
	end

	--[[
	primaryLanguage.lang = primaryLanguage
	secondaryLanguage.lang = tertiaryLanguage
	--]]

	if usingIcons then
		rawset(primaryLanguage, "lang", secondaryLanguage)
		rawset(secondaryLanguage, "lang", tertiaryLanguage)
	else
		rawset(primaryLanguage, "lang", primaryLanguage)
		rawset(secondaryLanguage, "lang", secondaryLanguage)
	end

	return primaryLanguage
end

return main
--[[
local strs = (false and import("language/chinese")) or eng

setmetatable(icons, {__index = strs})
icons.lang = strs
strs.lang = eng

function sformat(...)
	local res = string.format(...)
	
	res = res:sub(1,1):upper() .. res:sub(2)

	return res
end


if usingIcons then
	return icons
else
	return strs
end
--]]