SWEP.PrintName = "Взломщик Барьеров"
SWEP.Slot = 5
SWEP.SlotPos = 6
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Author = "UnionRP"
SWEP.Category = "UnionRP"
SWEP.Instructions = "ЛКМ: Начать взлом силового поля"
SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.ViewModel = Model("models/weapons/v_emptool.mdl")
SWEP.WorldModel = Model("models/weapons/w_emptool.mdl")

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.AnimPrefix = "python"

SWEP.Sound = Sound("weapons/deagle/deagle-1.wav")

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.KeyCrackSound = Sound("")

SWEP.IdleStance = "slam"

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Cracking")
end
