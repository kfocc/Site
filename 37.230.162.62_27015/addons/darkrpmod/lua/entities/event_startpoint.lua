AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Телепорт - Вход"
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

		timer.Simple(0, function()
			if not IsValid(self) then return end
			local owner = self:CPPIGetOwner()
			local target = self:SelectTarget(owner)
			if not target then
				DarkRP.notify(owner, 1, 4, "Не найдено ни одного выхода для телепорта!")
				self:Remove()
				return
			end

			local id = target:EntIndex()
			self.target = target
			target.occupied = self
			DarkRP.notify(owner, 0, 4, "Точка входа для телепорта создана! ID: " .. id)
			self:SetNetVar("PrintName", "[Ивент] Вход в телепорт ID: " .. id)
		end)
	end
end

function ENT:SelectTarget(owner)
	local target, spawntime = nil, 0
	for k, v in ipairs(ents.FindByClass("event_endpoint")) do
		if v.occupied then continue end
		local owner2 = v:CPPIGetOwner()
		if owner2 ~= owner then continue end
		if v.spawntime > spawntime then target, spawntime = v, v.spawntime end
	end
	return target
end

local vel = Vector()
function ENT:Use(ply)
	local target = self.target
	if not IsValid(target) then
		local owner = self:CPPIGetOwner()
		if IsValid(owner) then DarkRP.notify(owner, 1, 4, "Вход в телепорт удалён! Не найдена цель для телепорта!") end
		return
	end

	if target:IsAnyoneStanding() then
		DarkRP.notify(ply, 1, 4, "Вход в телепорт невозможен! Цель занята!")
		return
	end

	local pos = target:PickPosition()
	ply:SetPos(pos)
	ply:SetVelocity(vel)
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
		if IsValid(self.target) then self.target:Remove() end
	end
end
