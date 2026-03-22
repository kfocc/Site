SWEP.PrintName = "Пугатель 3000"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Author = "UnionRP"
SWEP.Purpose = ""
SWEP.Instructions = ""
SWEP.Category = "Admin Swep"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = false
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""
function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "LastUseL")
	self:NetworkVar("Int", 1, "LastUseR")
end

function SWEP:Deploy()
	self:SetHoldType("normal")
end
