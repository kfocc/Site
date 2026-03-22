AddCSLuaFile()

SWEP.PrintName = "Аптечка+"
SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Лечить игрока напротив\nПКМ: Лечить себя"
SWEP.Purpose = ""

SWEP.Slot = 5
SWEP.SlotPos = 7
SWEP.Category = "Лечение/Броня"

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.HealAmount = 50 -- Maximum heal amount per use
SWEP.MaxAmmo = 150 -- Maxumum ammo

local HealSound = Sound("HealthKit.Touch")
local DenySound = Sound("WallHealth.Deny")
function SWEP:Initialize()
	self:SetHoldType("slam")
	if CLIENT then return end
	timer.Create("medkit_ammo" .. self:EntIndex(), 1, 0, function() if self:Clip1() < self.MaxAmmo then self:SetClip1(math.min(self:Clip1() + 5, self.MaxAmmo)) end end)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(true) end
	local tr = util.TraceLine({
		start = self:GetOwner():GetShootPos(),
		endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 64,
		filter = self:GetOwner()
	})

	if self:GetOwner():IsPlayer() then self:GetOwner():LagCompensation(false) end
	local ent = tr.Entity
	local need = self.HealAmount
	if IsValid(ent) then need = math.min(ent:GetMaxHealth() - ent:Health(), self.HealAmount) end
	if IsValid(ent) and self:Clip1() >= need and (ent:IsPlayer() or ent:IsNPC()) and ent:Health() < ent:GetMaxHealth() then
		self:TakePrimaryAmmo(need)
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
		ent:EmitSound(HealSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() + 0.3)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		-- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
		timer.Create("weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_IDLE) end end)
		local owner = self:GetOwner()
		if owner:Team() == TEAM_GSR4 or owner:Team() == TEAM_GANG4 then
			local n_heal = self.next_heal
			if not n_heal or n_heal and n_heal <= CurTime() then self.next_heal = CurTime() + 300 end
			local self_now = (self.now or 0) + need
			if n_heal and n_heal < CurTime() or self_now < 1000 then
				owner:addMoney(need * 4, "Лечение жителей")
				self.now = self_now
			end
		end
	else
		self:GetOwner():EmitSound(DenySound)
		self:SetNextPrimaryFire(CurTime() + 1)
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	local ent = self:GetOwner()
	local need = self.HealAmount
	if IsValid(ent) then need = math.min(ent:GetMaxHealth() - ent:Health(), self.HealAmount) end
	if IsValid(ent) and self:Clip1() >= need and ent:Health() < ent:GetMaxHealth() then
		self:TakePrimaryAmmo(need)
		ent:SetHealth(math.min(ent:GetMaxHealth(), ent:Health() + need))
		ent:EmitSound(HealSound)
		self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		self:SetNextSecondaryFire(CurTime() + self:SequenceDuration() + 0.3)
		self:GetOwner():SetAnimation(PLAYER_ATTACK1)
		timer.Create("weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if IsValid(self) then self:SendWeaponAnim(ACT_VM_IDLE) end end)
	else
		ent:EmitSound(DenySound)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

function SWEP:OnRemove()
	timer.Stop("medkit_ammo" .. self:EntIndex())
	timer.Stop("weapon_idle" .. self:EntIndex())
end

function SWEP:Holster()
	timer.Stop("weapon_idle" .. self:EntIndex())
	return true
end

function SWEP:CustomAmmoDisplay()
	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()
	return self.AmmoDisplay
end
