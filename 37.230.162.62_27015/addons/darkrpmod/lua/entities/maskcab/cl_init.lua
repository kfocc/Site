ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Кабинка с одеждой"
ENT.Instructions = "Можно взять снаряжение"
ENT.Category = "UnionRP Маскировка"
ENT.Spawnable = true
ENT.AdminSpawnable = true
function ENT:Initialize()
	self:SetModel("models/props_c17/Lockers001a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		--self:DropToFloor()
		local phys = self:GetPhysicsObject()
		if IsValid(phys) then phys:EnableMotion(false) end
	end
end
