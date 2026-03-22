DEFINE_BASECLASS("tfa_gun_base")
SWEP.Gun = "tfa_fas2_ifak" --Make sure this is unique.  Specically, your folder name.  

SWEP.Base = "tfa_gun_base"
SWEP.Category = "Лечение/Броня" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep.
SWEP.Author = "UnionRP" --Author Tooltip
SWEP.Contact = "" --Contact Info Tooltip
SWEP.Purpose = "" --Purpose Tooltip
SWEP.Instructions = "" --Instructions Tooltip
SWEP.Spawnable = true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable = true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair = false -- Draw the crosshair?
SWEP.PrintName = "НПМП+" -- Weapon name (Shown on HUD)	
SWEP.Slot = 4 -- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos = 73 -- Position in the slot
SWEP.DrawAmmo = true -- Should draw the default HL2 ammo counter if enabled in the GUI.
SWEP.DrawWeaponInfoBox = false -- Should draw the weapon info box
SWEP.BounceWeaponIcon = false -- Should the weapon icon bounce?
SWEP.AutoSwitchTo = true -- Auto switch to if we pick it up
SWEP.AutoSwitchFrom = true -- Auto switch from if you pick up a better weapon
SWEP.Weight = 30 -- This controls how "good" the weapon is for autopickup.
SWEP.AllowSprintAttack = true
SWEP.NoStattrak = true
SWEP.NoNametag = true
--[[WEAPON HANDLING]]
--
--[[EVENT TABLE]]
--
SWEP.EventTable = {}

--Firing related
SWEP.Primary.SuccessSound = Sound("TFA_FAS2.IFAK.Success") -- This is the sound of the weapon, when you shoot.
SWEP.Primary.DenySound = Sound("WallHealth.Deny")
SWEP.FiresUnderwater = true
--Ammo Related
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "fas2_hemostat" -- fas2_hemostat

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.FireModes = {"Обычный"}

SWEP.DisableChambering = true
--Range Related
SWEP.Primary.Range = 0 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = -1 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.
--[[VIEWMODEL]]
--
SWEP.ViewModel = "models/weapons/tfa_fas2/c_ifak.mdl" --Viewmodel path
SWEP.ViewModelFOV = 56 -- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip = false -- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.)
SWEP.UseHands = true --Use gmod c_arms system.

SWEP.WorldModel = "models/weapons/tfa_fas2/w_ifak.mdl" -- Weapon world model path
SWEP.HoldType = "slam"

SWEP.Offset = {
	Pos = {
		Up = -2,
		Right = 0.8,
		Forward = 4.5,
	},
	Ang = {
		Up = 3,
		Right = 0,
		Forward = 178
	},
	Scale = 0.9
}

SWEP.Anim = ACT_VM_PRIMARYATTACK
SWEP.Bodygroups_V = {
	[2] = 2 -- Убирает правую часть
}


SWEP.data = {}
SWEP.data.ironsights = 0

function SWEP:InitBodygroups()
	local ammo = self:Ammo1()
	self.Bodygroups_V[1] = ammo == 0 and 2 or ammo < 5 and 1 or 0
end

function SWEP:Initialize(...)
	BaseClass.Initialize(self, ...)
	self:InitBodygroups()
end

function SWEP:Ammo1()
	return self:GetOwner():GetAmmoCount(self:GetPrimaryAmmoType())
end

function SWEP:ApplyViewModelModifications()
	self:InitBodygroups()
end

function SWEP:IsGoodDistance(target)
	return self:GetOwner():GetPos():Distance(target:GetPos()) < 100
end

function SWEP:CanUse()
	if self:GetNextPrimaryFire() > CurTime() then
		return false
	end
	if not self:HasAmmo() then
		return
	end
	return true
end

function SWEP:HasHeal()
	return self:Ammo1() > 0
end

function SWEP:PrimaryAttack()
	if not self:HasHeal() then
		return
	end
	local owner = self:GetOwner()
	local target = owner:GetEyeTrace().Entity
	if not IsValid(target) or not target:IsPlayer() then
		self:SetNextPrimaryFire(CurTime() + 0.5)

		return false
	end
	if target:Health() >= target:GetMaxHealth() then
		self:SetNextPrimaryFire(CurTime() + 0.5)

		return false
	end
	if not self:IsGoodDistance(target) then
		self:SetNextPrimaryFire(CurTime() + 0.5)

		return false
	end
	self.target = target

	owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(self.Anim)
	self:SetStatus(TFA.Enum.STATUS_SHOOTING)
	self:SetStatusEnd(CurTime() + 3)
	self:SetNextPrimaryFire(self:GetStatusEnd())
end

function SWEP:SecondaryAttack()
	if not self:CanUse() then
		return
	end
	local owner = self:GetOwner()
	if owner:Health() >= owner:GetMaxHealth() then
		self:SetNextPrimaryFire(CurTime() + 0.5)

		return false
	end
	self.target = owner

	owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(self.Anim)
	self:SetStatus(TFA.Enum.STATUS_SHOOTING)
	self:SetStatusEnd(CurTime() + 3)
	self:SetNextPrimaryFire(self:GetStatusEnd())
end

function SWEP:Reload()
	return
end

function SWEP:Think2()
	if self:GetStatus() ~= TFA.Enum.STATUS_SHOOTING or self:GetStatusEnd() > CurTime() then
		return BaseClass.Think2(self)
	end
	local owner, target = self:GetOwner(), self.target
	self.target = nil
	if not IsValid(target) or not target:Alive() or not self:IsGoodDistance(target) or (owner ~= target and owner:GetEyeTrace().Entity ~= target) then
		self:EmitSound(self.Primary.DenySound)
		self:SetNextPrimaryFire(CurTime() + 0.5)
		self:Deploy()

		return BaseClass.Think2(self)
	end

	self:SetNextPrimaryFire(CurTime() + 0.5)

	owner:RemoveAmmo(1, self:GetPrimaryAmmoType())
	self:EmitSound(self.Primary.SuccessSound)
	target:SetHealth(math.min(target:Health() + 20, target:GetMaxHealth()))

	timer.Simple(0, function()
		if not IsValid(self) then return end
		self:Deploy()
	end)

	return BaseClass.Think2(self)
end

function SWEP:DrawHUDAmmo()
	return
end

function SWEP:CycleSafety()
	return
end

function SWEP:CycleFireMode()
	return
end

SWEP.ViewModelBoneMods = {
	["ValveBiped.Bip01_L_Forearm"] = {
		scale = Vector(1, 1, 1),
		pos = Vector(2, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["ValveBiped.Bip01_R_Forearm"] = {
		scale = Vector(1, 1, 1),
		pos = Vector(-1, 0, 0),
		angle = Angle(0, 0, 0)
	},
	["Left Lower Arm 2"] = {
		scale = Vector(1, 1, 1),
		pos = Vector(0, 0, 0),
		angle = Angle(0, 34.444, 0)
	}
}