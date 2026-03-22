AddCSLuaFile()

DEFINE_BASECLASS( "base_anim" )

ENT.PrintName = "Патроны (Альянс)"
ENT.Category = "Альянс"
ENT.Editable = true
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.CanUse = true

function ENT:Initialize()
	self:SetModel("models/Items/ammocrate_smg1.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_VPHYSICS)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:DropToFloor()
		self.CanUse = true

		local phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then phys:EnableMotion(false) end
	end
end

local meta = FindMetaTable("Player")
function meta:HasGun()
	local wep = self:GetActiveWeapon()
	return IsValid(wep) and (wep.IsTFAWeapon or wep.SWBWeapon)
end

function ENT:OpenAnim(closeDelay, callback)
	self:ResetSequence(self:LookupSequence("close"))
	self.CanUse = false
	self:SetBodygroup(1, 0)
	timer.Create("openAmmoAnim_" .. self:EntIndex(), closeDelay, 1, function()
		if not IsValid(self) then return end
		self:ResetSequence(self:LookupSequence("open"))
		if callback then callback() end
		timer.Simple(1, function()
			if not IsValid(self) then return end
			self.CanUse = true
			self:SetBodygroup(1, 1)
		end)
	end)
end

function ENT:DeclineAnim()
	local timerId = "openAmmoAnim_" .. self:EntIndex()
	if timer.Exists(timerId) then timer.Adjust(timerId, 0, 1) end
end

function ENT:Use(ply, caller)
	if not self.CanUse then return end
	if ply:isRebel() then
		if self:GetNW2Int("NextSteal") > CurTime() then return end
		self:OpenAnim(11)
		local data = {
			delaytime = 10,
			check = function() return IsValid(self) and caller:Alive() and caller:GetEyeTrace().Entity == self and self:GetNW2Int("NextSteal") <= CurTime() and caller:GetPos():DistToSqr(self:GetPos()) <= 10000 end,
			onaction = function()
				if not IsValid(self) or not IsValid(caller) then return end
				caller:EmitSound("items/ammo_pickup.wav", 60)
			end,
			onfail = function() if IsValid(self) then self:DeclineAnim() end end,
			onfinish = function()
				if not IsValid(self) or not IsValid(caller) then return end
				local rnd = math.random(200, 1000)
				caller:SetVar("Rebel.Ammo", ply:GetVar("Rebel.Ammo", 0) + rnd)
				DarkRP.notify(caller, 4, 4, "Теперь принесите боеприпасы на базу")
				self:SetNW2Int("NextSteal", CurTime() + 300)
			end
		}

		caller:AddAction("Воруем патроны", data)
	elseif ply:isCP() then
		self:OpenAnim(1, function()
			if IsValid(ply) and ply:Alive() and ply:GetPos():Distance(self:GetPos()) < 100 then
				local total = ply:GiveMagazine(false, true)
				if total == 0 then DarkRP.notify(ply, 1, 4, "У вас уже максимум патронов!") end
			end
		end)
	end
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end

if SERVER then hook.Add("PostPlayerDeath", "u_ammo_create_rebel_reset", function(pLocal) if pLocal:GetVar("Rebel.Ammo", 0) > 0 then pLocal:SetVar("Rebel.Ammo", 0) end end) end
