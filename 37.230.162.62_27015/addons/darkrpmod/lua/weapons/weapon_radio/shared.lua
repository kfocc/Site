SWEP.PrintName = "Рация"
SWEP.Slot = 5
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.Author = "UnionRP"
SWEP.Purpose = ""
SWEP.Instructions = "Настроить рацию можно: Q - UnionRP(Справа) - Рация"
SWEP.Category = "UnionRP"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/danradio/c_radio.mdl"
SWEP.WorldModel = "models/danradio/w_radio.mdl"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"


function SWEP:Deploy()
	self:SetHoldType("slam")
end

hook.Add("CanRadioSpeak", "Fixed::Hook", function(listener, speaker)
	if listener:Team() == TEAM_GANG1 or listener:Team() == TEAM_BEGLEC1 or listener:Team() == TEAM_BEGLEC2 or listener:Team() == TEAM_BEGLEC3 then
		return false
	end
end)