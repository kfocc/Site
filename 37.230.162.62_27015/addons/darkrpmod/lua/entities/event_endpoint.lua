AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Телепорт - Выход"
ENT.Category = "UnionRP - Ивенты"

ENT.Spawnable = true
ENT.AdminOnly = false

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_phx/construct/plastic/plastic_panel1x1.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetUseType(SIMPLE_USE)
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then phys:EnableMotion(false) end

		self.spawntime = CurTime()

		timer.Simple(0, function()
			if not IsValid(self) then return end
			local owner = self:CPPIGetOwner()
			local id = self:EntIndex()
			DarkRP.notify(owner, 0, 4, "Точка выхода для телепорта создана! ID: " .. id)
			self:SetNetVar("PrintName", "[Ивент] Точка телепорта ID: " .. id)
		end)
	end
end

function ENT:Use(ply)
	return
end

function ENT:IsAnyoneStanding()
	local min, max = self:WorldSpaceAABB()
	max.z = max.z + 8
	for k, v in ipairs(ents.FindInBox(min, max)) do
		if v:IsPlayer() and v:Alive() then return true end
	end
	return false
end

function ENT:PickPosition()
	local origin = self:GetPos()
	local _, max = self:WorldSpaceAABB()
	origin.z = max.z + 8
	return origin
end

if CLIENT then
	local add = 32
	function ENT:Draw(flags)
		self:DrawModel(flags)
		local origin = self:GetPos()
		if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
		origin.z = origin.z + add
		if not nameplates then return end
		nameplates.DrawEnt(self, origin)
	end
end

if SERVER then
	function ENT:OnRemove()
		if IsValid(self.occupied) then self.occupied:Remove() end
	end
end
