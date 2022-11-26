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

local function PatchClass(edited_class, adjusted_methods)
	for class, inherited in pairs(ClassRegistry) do
		local class_chain = {}
		local current = class
		while current do
			class_chain[#class_chain+1] = current
			current = current._base
		end

		local root = class_chain[#class_chain]
		--local root_dbg = debug.getinfo(root._ctor, "S")
		--local class_dbg = debug.getinfo(class._ctor, "S")

		--local adjusted_root = root_dbg.source:match("(scripts/.+[%w_]+.lua)$")
		--local adjusted_class = class_dbg.source --class_dbg.source:match("(scripts/.+[%w_]+.lua)$")

		if root == edited_class then
			--print(string.format("Root Origin of '%s' is Widget!", adjusted_class or "nil"))
			
			for idx = 1, #class_chain - 1 do
				local klass = class_chain[idx]
				
				-- First, let's go over existing members in the klass that we might have.
				for key, value in pairs(klass) do
					-- Check if this key is in our class.
					-- Check type of edited_class[key] for cases where __index becomes a table VS the original being a function.
					-- Aka, SetupClassForProps.
					if edited_class[key] and type(edited_class[key]) == "function" and (value) == "function" then
						-- This key is in our edited class, and the value is a function.
						-- Now we want to check if the edited class's method is different.
						if edited_class[key] ~= value then
							-- It is. We need to see where the difference is coming from.
							--print(key, edited_class[key], value)
							local edited_src = debug.getinfo(edited_class[key], "S").source
							local value_src = debug.getinfo(value, "S").source

							--print("\t", key, value_src, "|", edited_src)

							--[[
								Root Origin of '@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua' is Widget!	
									__tostring	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/text.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									OnMouseButton	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									OnRawKey	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									KillAllChildren	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	|	@D:/Steam/steamapps/common/dont_starve/data/../mods/workshop-2081254154/scripts/ds_patches/widget.lua	
									OnGainFocus	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									_ctor	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									is_a	@D:/Steam/steamapps/common/dont_starve/data/scripts/class.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/class.lua	
									OnFocusMove	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									OnLoseFocus	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									OnTextInput	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									OnControl	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/textedit.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									__tostring	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/text.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									KillAllChildren	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	|	@D:/Steam/steamapps/common/dont_starve/data/../mods/workshop-2081254154/scripts/ds_patches/widget.lua	
									_ctor	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/text.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/widgets/widget.lua	
									is_a	@D:/Steam/steamapps/common/dont_starve/data/scripts/class.lua	|	@D:/Steam/steamapps/common/dont_starve/data/scripts/class.lua	
							]]

							if value_src ~= edited_src then
								-- Different sources.
								local value_filename = value_src:match("([%w_]+).lua$")
								local edited_filename = value_src:match("([%w_]+).lua$")

								if value_filename == edited_filename then
									-- We only want a replacement if the filenames match, but the edit comes from ds_patches.
									if edited_src:find("ds_patches") then
										-- We know the edit comes from a patchfile.
										-- Let's use the edit.
										klass[key] = edited_class[key]
										print("\tSuccessfully overwritten:", key)
									else
										-- This class is probably wrapping the base method used. It would be a bad idea to change it.
										--print("\tSAME FILENAME, DIFFERENT LORE:", key, value_src, edited_src)
									end
								else
									-- I don't even know if this is possible. I'm too tired.
									--print("\tDIFFERENT FILENAME:", key, value_src, edited_src)
								end
							else
								-- The sources are the same.
								-- I'm only seeing this happen with class's "is_a".
								--print("\tIDK CHIEF", key, value_src, edited_src)
							end

							--klass[key] = edited_class[key]
							--print("\tOverwriting: " .. key)
						end
					end
				end

				-- Now, we'll check to see if we need to add any methods.
				for key, value in pairs(edited_class) do
					if klass[key] == nil and type(value) == "function" then
						-- The klass is missing one of our new functions. Add it in.
						klass[key] = value
						--print("\tAdding new: " .. key)
					end
				end
			end
		end
		
		--print(string.format("Root Origin of '%s' is '%s'", adjusted_class, adjusted_root))
	end
end

--- Returns a function that can be used to patch instances of classes based on the provided patches.
local function CreateInstancePatcher(patches)
	return function(class_inst)
		local inherited = ClassRegistry[class_inst]
		for i,v in pairs(patches) do
			-- Check if the class instance is still using the function it inherited.
			if class_inst[i] == inherited[i] then
				-- It is! Let's patch it.
				inherited[i] = v
				class_inst[i] = v
			else
				mprint("============= INSTANCE PATCHER STACK =============")
				mprint("What's being patched being patched:", i)
				mprint("The Class Instance's version was defined at:", debug.getinfo(class_inst[i], "S").source)
				mprint("The Inherited's version was defined at:", debug.getinfo(inherited[i], "S").source)
				mprint("============= LIST OF PATCHES ====================")
				dumptable(patches)
				error("CreateInstancePatcher not setup to handle function overwrites.")
			end
		end
	end
end

local function NOP() end
local function ERR() error("Attempted to use a nonexistant Patch function.", 0) end
local function GetPatcher(which)
	if IS_DS then
		local p = import("ds_patches/" .. which)
		p.Patch = p.Patch or ERR
		return p
	end

	return { Patch = NOP }
end


return { PatchClass = PatchClass, CreateInstancePatcher = CreateInstancePatcher }