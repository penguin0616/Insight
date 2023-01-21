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
local languages = {
	icons = "icons",
	en = "english",
	zh = "chinese", --ch = "chinese",
	es = "spanish", --mex = "spanish",
	br = "portuguese"
}

local languageTables = {} -- Populated in initialize

local __metatable = "[Insight] The metatable is locked."
--------------------------------------------------------------------------
--[[ Functions ]]
--------------------------------------------------------------------------
local function PostImportLanguage(tbl)
	for i,v in pairs(tbl) do
		if type(v) == "table" then
			PostImportLanguage(v)
		elseif type(v) == "function" then
			local ret = v(tbl)
			if type(ret) ~= "string" and type(ret) ~= "table" then
				local info = debug.getinfo(v)
				local src = (info.source or "?") .. ":" .. (info.linedefined or "?") 
				mprint(type(ret))
				mprint(ret)
				errorf("Invalid post load fn for [%s]", src)
			end
			tbl[i] = ret
		end
	end
end

local function LoadLanguage(lang)
	local path = "language/" .. lang
	local new = import.has_loaded(path)
	local tbl = import(path)

	if new then
		PostImportLanguage(tbl)
	end

	-- If for some reason we're hitting a "cannot override protected meta" yadda yadda, 
	-- make sure none of the function returns in the langs directly return a reference to another table.
	-- It's deceiving in that the deepcopy makes it seem like this should be fine, but you're setting a meta
	-- On the same table twice from a single loaded language instance.
	
	local ret = deepcopy(tbl) -- Don't want to taint the import.

	return ret
end

--[[
local function LoadLanguage(lang)
	return deepcopy(import("language/" .. lang))
end
--]]

local function __newindex(self) 
	error(tostring(self) .. " is readonly") 
end

local function LinkTables(tbl, fallback)
	setmetatable(tbl, {
		__index = fallback,
		__newindex = __newindex,
		__metatable = "Metatable locked",
	})

	for key, value in pairs(tbl) do
		if type(value) == "table" then
			LinkTables(value, fallback[key])
		end
	end
end

local function AssumeLanguageTable()
	return languageTables[LOC.GetLocaleCode()] or languageTables.en
end

local function main(config, locale)
	local usingIcons = config["info_style"] == "icon"

	local selected = nil
	if config["language"] == "automatic" then
		selected = locale
	else
		selected = config["language"]
	end

	-- Unknown languages become english
	if languages[selected] == nil then
		selected = "en"
	end

	local primary
	local fallback = LoadLanguage(languages.en)

	if usingIcons then
		primary = LoadLanguage(languages.icons)
		local secondary = LoadLanguage(languages[selected])

		LinkTables(primary, secondary)
		LinkTables(secondary, fallback)

		rawset(primary, "lang", secondary)
		rawset(secondary, "lang", fallback)
	else
		-- If primary is "en", it's basically extra lookup and loading for no reason.
		-- However, I'm keeping this still to maintain load consistency across languages for testing purposes.

		primary = LoadLanguage(languages[selected])
		
		LinkTables(primary, fallback)
		rawset(primary, "lang", primary)
		rawset(fallback, "lang", fallback)
	end

	return primary
end

--------------------------------------------------------------------------
--[[ Initialize ]]
--------------------------------------------------------------------------
-- These are languagetables meant to be accessible externally. They fallback to english.
for code, lang in pairs(languages) do
	languageTables[code] = LoadLanguage(lang)
end

for code, tbl in pairs(languageTables) do
	if code ~= "en" then
		LinkTables(tbl, languageTables.en)
	end
end

-- Thing to return
local LanguageProxy = setmetatable({
	AssumeLanguageTable = AssumeLanguageTable
}, {})
local Language = getmetatable(LanguageProxy)

Language.__index = languageTables

Language.__call = function(self, ...)
	return main(...)
end

return LanguageProxy