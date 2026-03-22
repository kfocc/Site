SWEP.PrintName = "Проверка карманов"
SWEP.Slot = 1
SWEP.SlotPos = 9
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Author = "UnionRP"
SWEP.Purpose = ""
SWEP.Instructions = "R: Сменить мод"
SWEP.Category = "UnionRP"

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

SWEP.Modes = {
	[1] = {15, "ЛКМ", "Проверить, имеются ли деньги в карманах у человека", "Деньги в карманах"},
	[2] = {15, "ЛКМ", "Проверить, имеется ли оружие в карманах у человека", "Оружие в карманах"},
	[3] = {60, "ЛКМ", "Забрать устройство запроса у человека на 2 минуты", "Забрать устройство запроса"}
}

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Int", 1, "LastUseL")
end

function SWEP:Deploy()
	self:SetHoldType("normal")
end
