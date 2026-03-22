CPPI = CPPI or {}
CPPI.CPPI_DEFER = 042015
CPPI.CPPI_NOTIMPLEMENTED = 8084 -- PT ( Patcher and Ted )
local PLAYER = FindMetaTable("Player")
local ENTITY = FindMetaTable("Entity")
-- Get name
function CPPI:GetName()
	return "PatchProtect"
end

-- Get version of CPPI
function CPPI:GetVersion()
	return "1.3"
end

-- Get interface version of CPPI
function CPPI:GetInterfaceVersion()
	return 1.3
end

-- Get name from UID
function CPPI:GetNameFromUID(uid)
	local ply = player.GetByUniqueID(tostring(uid))
	if not IsValid(ply) or not ply:IsPlayer() then return end
	return ply:Nick()
end

-- Get friends from a player
function PLAYER:CPPIGetFriends()
	return CPPI_NOTIMPLEMENTED
end

-- Get the owner of an entity
function ENTITY:CPPIGetOwner()
	if not IsValid(self) then return end
	local ply = self:GetNW2Entity("pprotect_owner")
	if IsValid(ply) and ply:IsPlayer() then return ply, ply:UniqueID() end
end

if CLIENT then return end
-- Set owner of an entity
function ENTITY:CPPISetOwner(ply)
	if not self or not IsValid(ply) or not ply:IsPlayer() then return false end
	local sid = ply:SteamID()
	self:SetNW2Entity("pprotect_owner", ply)
	sv_PProtect.CollectEntities[sid]:Push(self)
	for _, cent in pairs(constraint.GetAllConstrainedEntities(self)) do
		if cent:CPPIGetOwner() then continue end
		cent:SetNW2Entity("pprotect_owner", ply)
		sv_PProtect.CollectEntities[sid]:Push(self)
	end
	return true
end

-- Set owner of an entity by UID
function ENTITY:CPPISetOwnerUID(uid)
	if not uid then return false end
	local ply = player.GetByUniqueID(tostring(uid))
	return self:CPPISetOwner(ply)
end

-- Can physgun
function ENTITY:CPPICanPhysgun(ply)
	if sv_PProtect.CanTouch(ply, self) == false then
		return false
	else
		return true
	end
end

-- Can tool
function ENTITY:CPPICanTool(ply, tool)
	if sv_PProtect.CanToolProtection(ply, ply:GetEyeTrace(), tool) == false then
		return false
	else
		return true
	end
end

-- Can pickup
function ENTITY:CPPICanPickup(ply)
	if sv_PProtect.CanPickup(ply, self) == false then
		return false
	else
		return true
	end
end

-- Can punt
function ENTITY:CPPICanPunt(ply)
	if sv_PProtect.CanGravPunt(ply, self) == false then
		return false
	else
		return true
	end
end
