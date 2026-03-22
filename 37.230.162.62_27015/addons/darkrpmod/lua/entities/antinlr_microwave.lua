AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_debloat"

ENT.PrintName = "Микроволновка"
ENT.Author = ""

ENT.Spawnable = true
ENT.Category = "UnionRP"

ENT.nonfreeze = false
ENT.nofreeze = false
ENT.pickup = false

ENT.mdl = "models/props/cs_militia/microwave01.mdl"
function ENT:Initialize()
	self:SetModel(self.mdl)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:EnableMotion(false)
	end
end

if SERVER then
	function ENT:Use(ply)
		if ply:getDarkRPVar("Energy") > 50 then
			DarkRP.notify(ply, 1, 4, "Вы сыты, попробуйте позже.")
			return
		end

		ply:setSelfDarkRPVar("Energy", 50)
		DarkRP.notify(ply, 1, 4, "Поздравляем! Вы поели.")
	end
else
	function ENT:Draw(flags)
		self:DrawModel(flags)

		local origin = self:WorldSpaceCenter()
		local _, max = self:WorldSpaceAABB()
		origin.z = max.z
		if (LocalPlayer():GetPos():Distance(origin) >= 768) then
			return end
		if not nameplates then return end
		nameplates.DrawEnt(self, origin)
	end
end

-- Микроволновки настройка:
-- CONFIG.antinlr_mircowaves
