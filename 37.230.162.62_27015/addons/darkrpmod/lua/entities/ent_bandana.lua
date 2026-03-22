AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Маска"
ENT.Category = "UnionRP"

ENT.Spawnable = true
ENT.AdminOnly = false

ENT.nonfreeze = true
ENT.nofreeze = true
ENT.pickup = true

if SERVER then
	function ENT:Initialize()
		if SERVER then
			self:SetModel("models/tnb/items/facewrap.mdl")
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
		if not ply:getJobTable().canusebandmask then
			DarkRP.notify(ply, 1, 4, "Кажется, эта вещь бесполезна для Вас.")
			return
		end

		if ply:GetNetVar("bandana.CanUse") then
			DarkRP.notify(ply, 1, 4, "У Вас уже есть это.")
			return
		end

		self:Remove()
		ply:SetLocalVar("bandana.CanUse", true)
		DarkRP.notify(ply, 0, 4, "Теперь Вы можете надевать и снимать маску.")
	end
else
	function ENT:Draw(flags)
		self:DrawModel(flags)
	end
end
