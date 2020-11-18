--[[
https://forums.kleientertainment.com/forums/topic/48264-net_variable-types-and-sending-data-from-serverhost-to-clients/

net_float - maps to a 32-bit float
net_byte - maps to an unsigned 8-bit integer
net_shortint - maps to a signed 16-bit integer
net_ushortint - maps to an unsigned 16-bit integer
net_int - maps to a signed 32-bit integer
net_uint - maps to an unsigned 32-bit integer
net_bool - maps to a single bit boolean
net_hash - maps to a unsigned 32-bit integer hash of the string assigned
net_string - maps to a string of variable length
net_entity - maps to an unsigned 64-bit integer containing the network id of the entity instance that is assigned
net_tinybyte - maps to an unsigned 3-bit integer
net_smallbyte - maps to an unsigned 6-bit integer
net_bytearray - maps to an array of unsigned 8-bit integers
net_smallbytearray - maps to an array of unsigned 6-bit integers
--]]

--[[
self.hunt_kills = 0
self.net_hunt_kills = net_ushortint(self.inst.GUID, "hunt_kills", "hunt_killsdirty" )

local function OnHuntKillsDirty(inst)
	inst.components.HuntGameLogic.hunt_kills = inst.components.HuntGameLogic.net_hunt_kills:value()
end

--in the component's constructor
if not TheWorld.ismastersim then
	self.inst:ListenForEvent("hunt_killsdirty", OnHuntKillsDirty)
end

function HuntGameLogic:SetHuntKills( hunt_kills )
	self.hunt_kills = hunt_kills
	self.net_hunt_kills:set(hunt_kills)
end
--]]

--[[ 
-- apparently this was added later
net_event = Class(function(self, guid, event)    
	self._bool = net_bool(guid, event, event)
end)
function net_event:push()    
	self._bool:set_local(true)    
	self._bool:set(true)
end
--Example: 
inst.screenshakeevent = net_event(inst.GUID, "screenshake")
inst:ListenForEvent("screenshake", OnScreenShake)
--Servers can push this and it will trigger on clients
inst.screenshakeevent:push()


]]