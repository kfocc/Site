SWEP.PrintName = "Magic Wand"
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

SWEP.Modes = {
	[1] = {"Vac Ban - выдает фейк вак.", "ЛКМ - использовать на ком-то.", "ПКМ - попробовать на себе."},
	[2] = {"Fake permaban - выдает фейк пермабан на сервере.", "ЛКМ - использовать на ком-то.", "ПКМ - попробовать на себе."},
	[3] = {"Fake nalog - собирает фейковый налог, оставляя 0 денег на счету ( временно - 2 минуты ).", "ЛКМ - использовать на ком-то.", "ПКМ - попробовать на себе."},
	[4] = {"Create fake money - создает фейковые деньги на полу", "поднимающий временно ( 2 минуты ) останется без денег на счету.", "ЛКМ - заспавнить."},
	[5] = {"Fake fun ban - Фейк бан за fun", "ЛКМ - использовать на ком-то.", "ПКМ - попробовать на себе."}
}

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "Mode")
	self:NetworkVar("Int", 1, "LastUseL")
	self:NetworkVar("Int", 2, "LastUseR")
end

function SWEP:Deploy()
	self:SetHoldType("normal")
end
