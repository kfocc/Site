AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Стяжки"
ENT.Category = "UnionRP"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.nonfreeze = true
ENT.nofreeze = true
ENT.pickup = true

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_junk/cardboard_box004a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WORLD)
		self:SetUseType(SIMPLE_USE)
		-- self:DropToFloor()
		self:PhysWake()
	end

	function ENT:Use(ply)
		local jobTable = ply:getJobTable()
		if jobTable.nocuffs then return end
		if jobTable.nousescreeds then return end
		if ply:isCP() and not ply:isRebel() then return end
		if ply:GetNetVar("useScreeds", false) then return end

		self:Remove()
		ply:SetLocalVar("useScreeds", true)
		ply:SetLocalVar("isUsedScreeds", nil)
		DarkRP.notify(ply, 2, 4, "Теперь Вы можете пользоваться стяжками.")
	end
else
	function ENT:Draw(flags)
		self:DrawModel(flags)
	end
end
