AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Патроны (Пыщи)"
ENT.Category = "Повстанцы"

ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.CanUse = true

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/Items/ammocrate_smg1.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self:DropToFloor()
		self.CanUse = true

		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then phys:EnableMotion(false) end
	end
end

function ENT:Use(ply, caller)
	if not self.CanUse then return end
	local count = GetGlobalInt("Rebel.Ammo") or 1
	local ammo = ply:GetVar("Rebel.Ammo", 0)
	if ammo > 0 then
		SetGlobalInt("Rebel.Ammo", count + ammo)
		ply:SetVar("Rebel.Ammo", 0)
		local money = ammo
		ply:addMoney(money, "Доставка патрон")
		DarkRP.notify(ply, 2, 4, "Вам выдали награду: " .. DarkRP.formatMoney(money) .. " за доставку боезапаса.")
		return
	end

	if count <= 0 then
		DarkRP.notify(ply, 1, 4, "Патроны отсутствуют!")
		return
	end

	local close = self:LookupSequence("close")
	self:ResetSequence(close)
	self.CanUse = false
	timer.Simple(1, function()
		if not IsValid(self) then return end
		local open = self:LookupSequence("open")
		self:ResetSequence(open)
		self:SetBodygroup(1, 0)
		if IsValid(ply) and ply:Alive() and ply:GetPos():Distance(self:GetPos()) < 100 then
			local total = ply:GiveMagazine()
			if total == 0 then
				DarkRP.notify(ply, 1, 4, "У вас уже максимум патронов!")
			else
				SetGlobalInt("Rebel.Ammo", count - total)
			end
		end
	end)

	timer.Simple(2, function()
		if not IsValid(self) then return end
		self.CanUse = true
		self:SetBodygroup(1, 1)
	end)
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end
