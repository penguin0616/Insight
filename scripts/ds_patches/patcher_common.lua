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

-- Testing Cases
--[[
tbl={
	require("widgets/widget");
	require("widgets/button");
	require("widgets/imagebutton");
	require("widgets/text");
	require("widgets/image");
};
fn={"SetHoverText","KillAllChildren","OnControl","ResetPreClickPosition","SetSize"};
s="\n\t";
for _,name in pairs(fn) do 
	str=""
	for _,k in pairs(tbl) do
		str=str..s..strclass(k).." = "..pritty(k[name])
	end
	print(name,str)
end;
--]]
	
--[[
Old
w=require("widgets/widget");
b=require("widgets/button");
ib=require("widgets/imagebutton");
print("SetHoverText", "\n"..pritty(w.SetHoverText).."\n"..pritty(b.SetHoverText).."\n"..pritty(ib.SetHoverText));
print("KillAllChildren", "\n"..pritty(w.KillAllChildren).."\n"..pritty(b.KillAllChildren).."\n"..pritty(ib.KillAllChildren));
print("OnControl", "\n"..pritty(w.OnControl).."\n"..pritty(b.OnControl).."\n"..pritty(ib.OnControl));
]]

local module = {}
local PatchClass, CreateInstancePatcher, GetPatcher
local debugging = false

local function xprint(...)
	if debugging or module.debugging then
		return mprint(...)
	end
end

local function xprintf(...)
	if debugging or module.debugging then
		return mprintf(...)
	end
end


local function pretty(fn)
	if type(fn) ~= "function" then
		return "[" .. tostring(fn) .. "]"
	end

	return "[" .. tostring(fn) .. " - " .. debug.getinfo(fn, "S").source:match("data/(.+[%w_]+.lua)$") .. "]"
end

local function strclass(class)
	return "<" .. debug.getinfo(class._ctor, "S").source:match("data/(.+[%w_]+.lua)$") .. ">"
end

_G.pritty=pretty
_G.strclass=strclass

--- Yes.
-- @tparam class_to_patch Class This is the original class that requested a global patching.
-- @tparam klass Class This is the current subclass or whatever that is receiving the patches.
-- @tparam patches table These are the patches.
local function ApplyClassPatches(class_to_patch, klass, patches)
	-- Note that we cannot do any checks based on class_to_patch.
	-- If we do so, they risk losing integrity because the class contents will change.
	local inherited_table = ClassRegistry[klass]
	local main_src = debug.getinfo(class_to_patch._ctor, "S").source

	local klass_filename = debug.getinfo(klass._ctor, "S").source:match("([%w_]+).lua$")

	for key, replacement in pairs(patches) do
		local current_src = klass[key] and debug.getinfo(klass[key], "S").source or nil
		local replacement_src = debug.getinfo(replacement, "S").source
		local inherited_src = inherited_table[key] and debug.getinfo(inherited_table[key], "S").source or nil

		local current_filename = current_src and current_src:match("([%w_]+).lua$") or nil
		local replacement_filename = replacement_src:match("([%w_]+).lua$") or nil
		local inherited_filename = inherited_src and inherited_src:match("([%w_]+).lua$") or nil

		if klass[key] == replacement then
			-- This was already processed at some point.
			xprintf("\t\tPatching(0 'alreadydone'): %s - %s", key, strclass(klass))
		elseif klass[key] == nil then
			-- Our patched function doesn't exist anywhere in that class.
			xprintf("\t\tPatching(1 'newfn'): %s - %s: %s ===> %s", key, strclass(klass), "nil", pretty(replacement))
			klass[key] = replacement
		elseif true and klass[key] ~= nil and inherited_table[key] == nil then
			--[[
				[00:00:01]: [workshop-2081254154 (Insight)]:	What's being patched:	OnControl
				[00:00:01]: [workshop-2081254154 (Insight)]:	Class_to_patch: <scripts/widgets/widget.lua> | Klass: <scripts/widgets/widget.lua>
				[00:00:01]: [workshop-2081254154 (Insight)]:	The Class To Patch's version was defined at:	[function: 136304B8 - scripts/widgets/widget.lua]
				[00:00:01]: [workshop-2081254154 (Insight)]:	The Klass's version was defined at:	[function: 136304B8 - scripts/widgets/widget.lua]
				[00:00:01]: [workshop-2081254154 (Insight)]:	The replacement was defined at:	[function: 14A1E510 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
				[00:00:01]: [workshop-2081254154 (Insight)]:	The inherited was defined at:	[nil]
			]]
			-- This klass is the first to declare a method.
			-- Let's compare the file names.
			if klass_filename == replacement_filename then
				-- The filenames match.
				xprintf("\t\tPatching(2 'first.same_klass_name'): %s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
				klass[key] = replacement
			else
				xprint("============= CLASS PATCHER STACK ================")
				xprint("What's being patched:", key)
				xprintf("Klass: %s", strclass(klass))
				xprint("The Klass's version was defined at:", pretty(klass[key]))
				xprint("The inherited was defined at:", pretty(inherited_table[key]))
				xprint("The replacement was defined at:", pretty(replacement))
				xprint("============= LIST OF PATCHES ====================")
				dumptable(patches)
				error("Filename difference.")
			end
			--xprintf("\tPatching(2): %s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
			--klass[key] = replacement
			--xprintf("\t\t%s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
		elseif true and klass[key] ~= nil and inherited_table[key] ~= nil then
			-- This klass isn't the first to declare the method.
			--[[
			[00:00:01]: [workshop-2081254154 (Insight)]:	Patching Class: <scripts/widgets/widget.lua>
			[00:00:01]: [workshop-2081254154 (Insight)]:	We found a class <scripts/widgets/image.lua> that inherits from <scripts/widgets/widget.lua>.
			[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/widget.lua> (2/2)
			[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1): ClearHoverText - <scripts/widgets/widget.lua>: nil ===> [function: 14C81EC8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(2): OnControl - <scripts/widgets/widget.lua>: [function: 1381CA28 - scripts/widgets/widget.lua] ===> [function: 14C81F08 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(2): KillAllChildren - <scripts/widgets/widget.lua>: [function: 13A0B4B8 - scripts/widgets/widget.lua] ===> [function: 14C81E48 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1): SetHoverText - <scripts/widgets/widget.lua>: nil ===> [function: 14C81EA8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/image.lua> (1/2)
			[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1): ClearHoverText - <scripts/widgets/image.lua>: nil ===> [function: 14C81EC8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:	============= CLASS PATCHER STACK ================
			[00:00:01]: [workshop-2081254154 (Insight)]:	What's being patched:	OnControl
			[00:00:01]: [workshop-2081254154 (Insight)]:	Klass: <scripts/widgets/image.lua>
			[00:00:01]: [workshop-2081254154 (Insight)]:	The Klass's version was defined at:	[function: 1381CA28 - scripts/widgets/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:	The replacement was defined at:	[function: 14C81F08 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
			[00:00:01]: [workshop-2081254154 (Insight)]:	The inherited was defined at:	[function: 1381CA28 - scripts/widgets/widget.lua]
			]]
			
			-- First, we need to check if the inherited method is the same as the class method.
			-- If it is, we can replace them both.
			if klass[key] == inherited_table[key] then
				-- They're the same.
				-- Filename comparison...
				if klass_filename == replacement_filename then
					xprintf("\t\tPatching(3 'late.same_inherit.same_klass_name'): %s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
					klass[key] = replacement
					inherited_table[key] = replacement
				elseif current_filename == replacement_filename then
					xprintf("\t\tPatching(4 'late.same_inherit.same_current_name'): %s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
					klass[key] = replacement
					inherited_table[key] = replacement
				else
					xprintf("\t\tPatching(X, '???'): %s - %s: CURRENT: %s |||| INHERITED: %s |||| REPLACEMENT: %s", key, strclass(klass), pretty(klass[key]), pretty(inherited_table[key]), pretty(replacement))
					xprint("\t\t\t", klass_filename, current_filename, inherited_filename, replacement_filename)
					--[[
						[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/numericspinner.lua> (1/3)
						[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): ClearHoverText - <scripts/widgets/numericspinner.lua>: nil ===> [function: 14E336E0 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	============= CLASS PATCHER STACK ================
						[00:00:01]: [workshop-2081254154 (Insight)]:	What's being patched:	OnControl
						[00:00:01]: [workshop-2081254154 (Insight)]:	Klass: <scripts/widgets/numericspinner.lua>
						[00:00:01]: [workshop-2081254154 (Insight)]:	Klass Filename: "spinner", Replacement Filename: "widget"
						[00:00:01]: [workshop-2081254154 (Insight)]:	The Klass's version was defined at:	[function: 138B0B00 - scripts/widgets/spinner.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	The inherited was defined at:	[function: 138B0B00 - scripts/widgets/spinner.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	The replacement was defined at:	[function: 14E33640 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					]]
					-- It's failed the filename comparison, which means it's not something we actually want to patch.
					--[[
					xprint("============= CLASS PATCHER STACK ================")
					xprint("What's being patched:", key)
					xprintf("Klass: %s", strclass(klass))
					xprintf("Klass Filename: %q, Replacement Filename: %q", current_filename, replacement_filename)
					xprint("The Klass's version was defined at:", pretty(klass[key]))
					xprint("The inherited was defined at:", pretty(inherited_table[key]))
					xprint("The replacement was defined at:", pretty(replacement))
					xprint("============= LIST OF PATCHES ====================")
					dumptable(patches)
					error("filename error with klass==inherit")
					--]]
				end
			else
				--[[
					[00:00:01]: [workshop-2081254154 (Insight)]:	Patching Class: <scripts/widgets/widget.lua>
					[00:00:01]: [workshop-2081254154 (Insight)]:	We found a class <scripts/widgets/threeslice.lua> that inherits from <scripts/widgets/widget.lua>.
					[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/widget.lua> (2/2)
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): ClearHoverText - <scripts/widgets/widget.lua>: nil ===> [function: 135E8ED8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(2 'first.samename'): OnControl - <scripts/widgets/widget.lua>: [function: 11AB9158 - scripts/widgets/widget.lua] ===> [function: 135E8EF8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(2 'first.samename'): KillAllChildren - <scripts/widgets/widget.lua>: [function: 11AB8FB8 - scripts/widgets/widget.lua] ===> [function: 135E90B8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): SetHoverText - <scripts/widgets/widget.lua>: nil ===> [function: 135E8DD8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/threeslice.lua> (1/2)
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): ClearHoverText - <scripts/widgets/threeslice.lua>: nil ===> [function: 135E8ED8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(3 'late.sameinherit.samename'): OnControl - <scripts/widgets/threeslice.lua>: [function: 11AB9158 - scripts/widgets/widget.lua] ===> [function: 135E8EF8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(3 'late.sameinherit.samename'): KillAllChildren - <scripts/widgets/threeslice.lua>: [function: 11AB8FB8 - scripts/widgets/widget.lua] ===> [function: 135E90B8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): SetHoverText - <scripts/widgets/threeslice.lua>: nil ===> [function: 135E8DD8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:	We found a class <scripts/widgets/numericspinner.lua> that inherits from <scripts/widgets/widget.lua>.
					[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/widget.lua> (3/3)
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(0 'alreadydone'): ClearHoverText - <scripts/widgets/widget.lua>
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(0 'alreadydone'): OnControl - <scripts/widgets/widget.lua>
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(0 'alreadydone'): KillAllChildren - <scripts/widgets/widget.lua>
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(0 'alreadydone'): SetHoverText - <scripts/widgets/widget.lua>
					[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/spinner.lua> (2/3)
					[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): ClearHoverText - <scripts/widgets/spinner.lua>: nil ===> [function: 135E8ED8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:	============= CLASS PATCHER STACK ================
					[00:00:01]: [workshop-2081254154 (Insight)]:	What's being patched:	OnControl
					[00:00:01]: [workshop-2081254154 (Insight)]:	Klass: <scripts/widgets/spinner.lua>
					[00:00:01]: [workshop-2081254154 (Insight)]:	The Klass's version was defined at:	[function: 11ABBA38 - scripts/widgets/spinner.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:	The inherited was defined at:	[function: 11AB9158 - scripts/widgets/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:	The replacement was defined at:	[function: 135E8EF8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
					[00:00:01]: [workshop-2081254154 (Insight)]:	============= LIST OF PATCHES ====================
					[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	ClearHoverText	 V: 	function: 135E8ED8	
					[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	OnControl	 V: 	function: 135E8EF8	
					[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	KillAllChildren	 V: 	function: 135E90B8	
					[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	SetHoverText	 V: 	function: 135E8DD8	
				]]
				-- Looks like the class overrode the inherited function.
				if klass_filename ~= replacement_filename and inherited_filename == replacement_filename then
					-- The class has its own implementation that we need to respect. We'll just replace the inherited here.
					xprintf("\t\tPatching(3.5 'late.diff_inherit.same_inherit_name'): %s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
					inherited_table[key] = replacement
				elseif klass_filename == replacement_filename then
					-- Business as usual, the klass has a function that needs to be replaced the same way as patch#2.
					xprintf("\t\tPatching(2.0 'late.same_klass_name'): %s - %s: %s ===> %s", key, strclass(klass), pretty(klass[key]), pretty(replacement))
					klass[key] = replacement
					--[[
						[00:00:01]: [workshop-2081254154 (Insight)]:	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
						[00:00:01]: [workshop-2081254154 (Insight)]:	Patching Class: <scripts/widgets/button.lua>
						[00:00:01]: [workshop-2081254154 (Insight)]:	We found a class <scripts/widgets/animbutton.lua> that inherits from <scripts/widgets/button.lua>.
						[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/button.lua> (2/2)
						[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): SetWhileDown - <scripts/widgets/button.lua>: nil ===> [function: 14893D90 - ../mods/workshop-2081254154/scripts/ds_patches/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): SetOnDown - <scripts/widgets/button.lua>: nil ===> [function: 14893DD0 - ../mods/workshop-2081254154/scripts/ds_patches/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	============= CLASS PATCHER STACK ================
						[00:00:01]: [workshop-2081254154 (Insight)]:	What's being patched:	OnControl
						[00:00:01]: [workshop-2081254154 (Insight)]:	Klass: <scripts/widgets/button.lua>
						[00:00:01]: [workshop-2081254154 (Insight)]:	Klass Filename: "button", Inherited Filename: "widget", Replacement Filename: "button"
						[00:00:01]: [workshop-2081254154 (Insight)]:	The Klass's version was defined at:	[function: 134870E8 - scripts/widgets/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	The inherited was defined at:	[function: 14891590 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	The replacement was defined at:	[function: 14893F90 - ../mods/workshop-2081254154/scripts/ds_patches/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	============= LIST OF PATCHES ====================
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	SetWhileDown	 V: 	function: 14893D90	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	SetOnDown	 V: 	function: 14893DD0	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	OnControl	 V: 	function: 14893F90	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	OnUpdate	 V: 	function: 14894070	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	ResetPreClickPosition	 V: 	function: 14893E90	
					]]
				else 
					--[[
						[00:00:01]: [workshop-2081254154 (Insight)]:	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
						[00:00:01]: [workshop-2081254154 (Insight)]:	Patching Class: <scripts/widgets/button.lua>
						[00:00:01]: [workshop-2081254154 (Insight)]:	We found a class <scripts/widgets/button.lua> that inherits from <scripts/widgets/button.lua>.
						[00:00:01]: [workshop-2081254154 (Insight)]:		Applying class patches to <scripts/widgets/button.lua> (1/1)
						[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): SetWhileDown - <scripts/widgets/button.lua>: nil ===> [function: 150B63E8 - ../mods/workshop-2081254154/scripts/ds_patches/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:			Patching(1 'newfn'): SetOnDown - <scripts/widgets/button.lua>: nil ===> [function: 150B63C8 - ../mods/workshop-2081254154/scripts/ds_patches/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	============= CLASS PATCHER STACK ================
						[00:00:01]: [workshop-2081254154 (Insight)]:	What's being patched:	OnControl
						[00:00:01]: [workshop-2081254154 (Insight)]:	Klass: <scripts/widgets/button.lua>
						[00:00:01]: [workshop-2081254154 (Insight)]:	The Klass's version was defined at:	[function: 13AD2C20 - scripts/widgets/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	The inherited was defined at:	[function: 150B3CA8 - ../mods/workshop-2081254154/scripts/ds_patches/widget.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	The replacement was defined at:	[function: 150B61C8 - ../mods/workshop-2081254154/scripts/ds_patches/button.lua]
						[00:00:01]: [workshop-2081254154 (Insight)]:	============= LIST OF PATCHES ====================
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	SetWhileDown	 V: 	function: 150B63E8	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	SetOnDown	 V: 	function: 150B63C8	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	OnControl	 V: 	function: 150B61C8	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	OnUpdate	 V: 	function: 150B6488	
						[00:00:01]: scripts/debugtools.lua(84,1) 	K: 	ResetPreClickPosition	 V: 	function: 150B6408	
					]]
					xprint("============= CLASS PATCHER STACK ================")
					xprint("What's being patched:", key)
					xprintf("Klass: %s", strclass(klass))
					xprintf("Klass Filename: %q, Inherited Filename: %q, Replacement Filename: %q", current_filename, inherited_filename, replacement_filename)
					xprint("The Klass's version was defined at:", pretty(klass[key]))
					xprint("The inherited was defined at:", pretty(inherited_table[key]))
					xprint("The replacement was defined at:", pretty(replacement))
					xprint("============= LIST OF PATCHES ====================")
					dumptable(patches)
					error("filename error with different methods")
				end
			end
		else
			xprint("============= CLASS PATCHER STACK ================")
			xprint("What's being patched:", key)
			xprintf("Klass: %s", strclass(klass))
			--xprint("The Class To Patch's version was defined at:", pretty(class_to_patch[key]))
			xprint("The Klass's version was defined at:", pretty(klass[key]))
			xprint("The inherited was defined at:", pretty(inherited_table[key]))
			xprint("The replacement was defined at:", pretty(replacement))
			xprint("============= LIST OF PATCHES ====================")
			dumptable(patches)

			error("Don't know what to do!")
		end
	end
end

function PatchClass(class_to_patch, patches)
	xprint("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@") --  .. "\nPatching Class: " .. strclass(class_to_patch)
	xprint("Patching Class: " .. strclass(class_to_patch))
	patches = shallowcopy(patches)
	patches._base = nil -- TODO: Same as TODO in CreateInstancePatcher

	-- We need to patch every class that has inherited from "class_to_patch". Painful.
	for registered_class, inherited in pairs(ClassRegistry) do
		--xprint('\tEval', "!"..debug.getinfo(class._ctor, "S").source:match("([%w_]+)%.lua$"))
		local class_chain = {}
		local current = registered_class
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
			xprintf("We found a class %s that inherits from %s.", strclass(registered_class), strclass(class_to_patch))
			-- We'll start from the bottom.
			for idx = #class_chain, 1, -1 do
				local klass = class_chain[idx]
				xprintf("\tApplying class patches to %s (%d/%d)", strclass(klass), idx, #class_chain)
				ApplyClassPatches(class_to_patch, klass, patches)
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