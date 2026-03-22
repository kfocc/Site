ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Container"
ENT.Author = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Category = "UnionRP"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Container = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Bool", 0, "closed")
	self:NetworkVar("Int", 0, "storageSlots")
	self:NetworkVar("Bool", 1, "craft") -- верстак
	if SERVER then self:NetworkVarNotify("owning_ent", self.OnVarChanged) end
end

--function ENT:isKeysOwnable()
--  return true
--end
function ENT:getKeysNonOwnable()
	return false
end

function ENT:getPocketSize()
	return self:GetstorageSlots() or 10
end

function ENT:setPocketSize(size)
	self:SetstorageSlots(size)
end

hook.Add("canKeysUnlock", "ContainerKeys", function(ply, ent)
	if ent.Container then
		local owner = ent:Getowning_ent()
		return ply == owner
	end
end)

hook.Add("canKeysLock", "ContainerKeys", function(ply, ent)
	if ent.Container then
		local owner = ent:Getowning_ent()
		return ply == owner
	end
end)

hook.Add("canLockpick", "ContainerLockpick", function(ply, ent)
	if ent.Container then
		return true
	end
end)