AddCSLuaFile()

if CLIENT then
	SWEP.PrintName = "Фейк налог"
	SWEP.Slot = 2
	SWEP.SlotPos = 9
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
end


SWEP.Author = "UnionRP"
SWEP.Instructions = ""
SWEP.Category = "Admin Swep"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.DrawCrosshair = true
SWEP.IsDarkRPWeaponChecker = true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix = "rpg"
SWEP.Delay = 3

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	return true
end

function SWEP:DrawWorldModel()
end

function SWEP:PreDrawViewModel(vm)
	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Delay)
	local trace = self:GetOwner():GetEyeTrace()
	local trent = trace.Entity
	if not IsValid(trent) or not trent:IsPlayer() or trent:GetPos():DistToSqr(self:GetOwner():GetPos()) > 10000 then return end
	self:EmitSound("npc/combine_soldier/gear6.wav", 50, 100)
	if SERVER then
		DarkRP.notify(self:GetOwner(), 3, 3, "Вы собрали налог с " .. trent:Name())
		DarkRP.notify(trent, 3, 3, "С вас собрал налог " .. self:GetOwner():Name() .. " в размере " .. DarkRP.formatMoney(10000000) .. ".")
		hook.Run("TakeFakeMoney", self:GetOwner(), 60, trent)
	end

	self:GetOwner():EmitSound("npc/combine_soldier/gear6.wav", 50, 110)
end

function SWEP:SecondaryAttack()
	return
end

function SWEP:Reload()
	return
end

function SWEP:Holster()
	return true
end

function SWEP:DrawHUD()
	self.Dots = self.Dots or ""
	local w = ScrW()
	local h = ScrH()
	local x, y, width, height = w / 2 - w / 10, h / 2, w / 5, h / 3
	draw.DrawNonParsedSimpleText("Нажмите ЛКМ для сбора фейк налога!", "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
end
