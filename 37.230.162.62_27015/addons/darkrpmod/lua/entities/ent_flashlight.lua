AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Фонарик"
ENT.Category = "UnionRP"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.nonfreeze = true
ENT.nofreeze = true
ENT.pickup = true

if SERVER then
	function ENT:Initialize()
		if SERVER then
			self:SetModel("models/raviool/flashlight.mdl")
			self:PhysicsInit(SOLID_VPHYSICS)
			self:SetMoveType(MOVETYPE_VPHYSICS)
			self:SetSolid(SOLID_VPHYSICS)
			self:SetCollisionGroup(COLLISION_GROUP_WORLD)
			self:SetUseType(SIMPLE_USE)
			-- self:DropToFloor()
			self:PhysWake()
		end
	end

	function ENT:Use(ply)
		if DarkRP.CanUseFlashLightBase(ply) then return end
		self:Remove()
		ply:SetLocalVar("flashlight", true)
		ply:EmitSound("items/flashlight1.wav")
	end
else
	function ENT:Draw(flags)
		self:DrawModel(flags)
	end
end
