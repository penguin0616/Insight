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

local module = {}
local PatchClass, CreateInstancePatcher, GetPatcher

local function xprint(...)
	if module.debugging then
		return mprint(...)
	end
end

local function pretty(fn)
	if type(fn) ~= "function" then
		return "[" .. tostring(fn) .. "]"
	end

	return "[" .. tostring(fn) .. " - " .. debug.getinfo(fn, "S").source:match("(scripts/.+[%w_]+.lua)$") .. "]"
end

_G.pritty = pretty

--- Yes.
-- @tparam class_to_patch Class This is the original class that requested a global patching.
-- @tparam klass Class This is the current subclass or whatever that is receiving the patches.
-- @tparam patches table These are the patches.
local function ApplyClassPatches(class_to_patch, klass, patches, idx, class_chain)
	local inherited = ClassRegistry[klass]

	for key, value in pairs(patches) do
		-- Check type of class_to_patch[key] for cases where __index becomes a table VS the original being a function.
		-- Aka, SetupClassForProps.
		if klass[key] and type(klass[key]) == type(value) and type(value) == "function" then
			-- Now we want to check if the edited class's method is different.
			local klass_src = debug.getinfo(klass[key], "S").source
			local edited_src = debug.getinfo(value, "S").source

			if klass_src ~= edited_src then
				-- Different sources.
				local klass_filename = klass_src:match("([%w_]+).lua$")
				local edited_filename = edited_src:match("([%w_]+).lua$")

				if klass_filename == edited_filename then
					-- We only want a replacement if the filenames match, but the edit comes from ds_patches.
					if edited_src:find("ds_patches") then
						-- We know the edit comes from a patchfile.
						-- Let's use the edit.
						mprint("\tOverwriting", key, pretty(value), pretty(klass[key]), pretty(inherited[key]))
						if klass[key] == value then
							-- This has been already overwritten.
							mprint("\tAlready Overwritten", key, klass[key], inherited[key])
						else
							klass[key] = value
							inherited[key] = value
						end
						--mprint("\tSuccessfully overwritten:", debug.getinfo(klass._ctor, "S").source:match("([%w_]+).lua$"), key)
						
					else
						-- This hasn't happened yet.
						-- MAYBE: This class is probably wrapping the base method used. It would be a bad idea to change it.
						--mprint("\tSAME FILENAME, DIFFERENT LORE:", key, klass_src, edited_src)
						mprint("============= CLASS PATCHER STACK ================")
						mprint("What's being patched:", key)
						mprintf("Class_to_patch: %s | Klass: %s", debug.getinfo(class_to_patch._ctor, "S").source, debug.getinfo(klass._ctor, "S").source)
						mprint("The Class To Patch's version was defined at:", (type(class_to_patch[key]) == "function" and debug.getinfo(class_to_patch[key], "S").source) or tostring(class_to_patch[key]) )
						mprint("The Klass's version was defined at:", (type(klass[key]) == "function" and debug.getinfo(klass[key], "S").source) or tostring(klass[key]) )
						mprint("The patched version was defined at:", (type(value) == "function" and debug.getinfo(value, "S").source) or tostring(value) )
						mprint("============= LIST OF PATCHES ====================")
						dumptable(patches)
						error("Patch function was not defined in a ds_patches directory.")
					end
				else
					-- This came up when patching ImageButton (OnControl) with _to_load set {"widget", "button", "imagebutton", "text"}
					-- Klass (ImageButton) doesn't have an OnControl, but its base class Button does.
					-- So, let's see if the method is inherited or not.
					if klass[key] == inherited[key] then
						-- Okay, we know it's just an inherited function.
						-- We can overwrite it here.
						klass[key] = value
						mprintf("Class method %q is inherited, overwriting.", key)
					elseif false then

					else
						-- This means it's overwritten by something else.
						-- This popped up when both patch files Button and ImageButton were patching OnControl.
						mprint("============= CLASS PATCHER STACK ================")
						mprint("What's being patched:", key)
						mprintf("Class_to_patch: %s | Klass: %s", debug.getinfo(class_to_patch._ctor, "S").source, debug.getinfo(klass._ctor, "S").source)
						mprintf("Klass Method Filename: %s | Edited Method Filename: %s", klass_filename, edited_filename)
						mprint(class_to_patch[key], klass[key], inherited[key], value)
						mprint("The Class To Patch's version was defined at:", (type(class_to_patch[key]) == "function" and debug.getinfo(class_to_patch[key], "S").source) or tostring(class_to_patch[key]) )
						mprint("The Klass's version was defined at:", (type(klass[key]) == "function" and debug.getinfo(klass[key], "S").source) or tostring(klass[key]) )
						mprint("The patched version was defined at:", (type(value) == "function" and debug.getinfo(value, "S").source) or tostring(value) )
						mprint("The Inherited's version was defined at:", ( type(inherited[key]) == "function" and debug.getinfo(inherited[key], "S").source) or tostring(inherited[key]) )
						mprint("============= LIST OF PATCHES ====================")
						dumptable(patches)
						error("Filename mismatch")
					end
				end
			else
				-- The sources are the same.
				-- That means this class has already been patched, likely because multiple classes are inheriting from the same place and got already processed.
				--mprintf("Class %q already patched.", debug.getinfo(klass._ctor, "S").source)
			end

		elseif klass[key] then
			mprint("============= CLASS PATCHER STACK ================")
			mprint("What's being patched:", key)
			mprintf("Class_to_patch: %s | Klass: %s", debug.getinfo(class_to_patch._ctor, "S").source, debug.getinfo(klass._ctor, "S").source)
			mprint("The Class To Patch's version was defined at:", (type(class_to_patch[key]) == "function" and debug.getinfo(class_to_patch[key], "S").source) or tostring(class_to_patch[key]) )
			mprint("The Klass's version was defined at:", (type(klass[key]) == "function" and debug.getinfo(klass[key], "S").source) or tostring(klass[key]) )
			mprint("The patched version was defined at:", (type(value) == "function" and debug.getinfo(value, "S").source) or tostring(value) )
			mprint("============= LIST OF PATCHES ====================")
			dumptable(patches)
			error("Type mismatch for class patcher.")
		else
			-- Our patched function doesn't exist in the class, so just add it in.
			klass[key] = value
		end
	end
end

function PatchClass(class_to_patch, patches)
	--mprint('anunu', debug.getinfo(class_to_patch._ctor, "S").source, patches)
	patches = shallowcopy(patches)
	patches._base = nil -- TODO: Same as TODO in CreateInstancePatcher

	-- We need to patch every class that has inherited from "class_to_patch". Painful.
	for class, inherited in pairs(ClassRegistry) do
		--xprint('\tEval', "!"..debug.getinfo(class._ctor, "S").source:match("([%w_]+)%.lua$"))
		local class_chain = {}
		local current = class
		while current do
			class_chain[#class_chain+1] = current
			if current == class_to_patch then
				--xprint('\tFOUND!')
				break
			end
			current = current._base
		end

		-- Not necessarily the deepest root. This is meant to be the deepest root OR the class_to_patch we're looking for.
		local root = class_chain[#class_chain]
		--local root_dbg = debug.getinfo(root._ctor, "S")
		--local class_dbg = debug.getinfo(class._ctor, "S")

		--local adjusted_root = root_dbg.source:match("(scripts/.+[%w_]+.lua)$")
		--local adjusted_class = class_dbg.source --class_dbg.source:match("(scripts/.+[%w_]+.lua)$")

		--xprint('\t', root, class_to_patch, root == class_to_patch)
		--xprint('\t\t', debug.getinfo(root._ctor, "S").source, debug.getinfo(class_to_patch._ctor, "S").source)
		if root == class_to_patch then
			-- We've found a class that inherits from "class_to_patch".
			-- Now we need to work our way through that class chain, applying the patches.
			--mprint("HUNGO", debug.getinfo(class._ctor, "S").source)
			for idx = 1, #class_chain do
				local klass = class_chain[idx]
				ApplyClassPatches(class_to_patch, klass, patches, idx, class_chain)
			end
		end
		
		--print(string.format("Root Origin of '%s' is '%s'", adjusted_class, adjusted_root))
	end
end

--- Returns a function that can be used to patch instances of classes based on the provided patches.
function CreateInstancePatcher(patches)
	return function(class_inst)
		patches = shallowcopy(patches) -- TODO: Come up with a better approach that doesn't require this but also doesn't affect the loop below.
		local _base = patches._base
		patches._base = nil

		if _base and _base.Patch then
			_base.Patch(class_inst)
		end

		local class = getmetatable(class_inst)
		local inherited = ClassRegistry[class]
		for i,v in pairs(patches) do
			-- Check if the class instance is still using the original function from the class. 
			if (class_inst[i] == class[i]) then
				-- It is! Let's patch it.
				class_inst[i] = v
				class[i] = v

			else
				mprint("============= INSTANCE PATCHER STACK =============")
				mprint("What's being patched:", i)
				mprint("The Class Instance's version was defined at:", (type(class_inst[i]) == "function" and debug.getinfo(class_inst[i], "S").source) or tostring(class_inst[i]) )
				mprint("The Class' version was defined at:", (type(class[i]) == "function" and debug.getinfo(class[i], "S").source) or tostring(class[i]) )
				mprint("The Inherited's version was defined at:", (type(inherited[i]) == "function" and debug.getinfo(inherited[i], "S").source) or tostring(inherited[i]) )
				mprint("============= LIST OF PATCHES ====================")
				dumptable(patches)
				error("CreateInstancePatcher not setup to handle function overwrites.")
			end
		end
	end
end

local function NOP() end
local function ERR() error("Attempted to use a nonexistant Patch function.", 0) end
function GetPatcher(which)
	if IS_DS then
		local p = import("ds_patches/" .. which)
		--p.Patch = p.Patch or ERR
		return p
	end

	return { Patch = NOP }
end


module.PatchClass = PatchClass
module.CreateInstancePatcher = CreateInstancePatcher
module.GetPatcher = GetPatcher
return module