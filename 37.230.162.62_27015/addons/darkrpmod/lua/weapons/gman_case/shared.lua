SWEP.Author = "UnionRP"
SWEP.Instructions = "R: Сменить мод"
SWEP.PrintName = "Сумка GMan`а"

SWEP.SlotPos = 1
SWEP.Slot = 5
SWEP.nowarn = true
SWEP.Category = "UnionRP"

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.DrawWeaponInfoBox = true
SWEP.Purpose = ""

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.AnimPrefix = "rpg"
SWEP.HoldType = "none"
SWEP.ViewModel = "models/weapons/c_nsuitcase.mdl"
SWEP.WorldModel = "models/weapons/w_nsuitcase.mdl"
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 1

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.Modes = {
	[1] = {5, "Активировать/деактивировать невидимость"},
	[2] = {60, "Телепорт к игроку"},
	[3] = {10, "Телепортироваться в рандомную точку"},
	[4] = {10, "Телепортироваться в направлении взгляда"},
	[5] = {5, "Сохранить текущую точку"},
	[6] = {10, "Телепорт к сохраненной точке"}
}

SWEP.notAllowedTeam = {
	[TEAM_ADMIN] = true,
}

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:CanSecondaryAttack()
	return false
end
