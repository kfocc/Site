SWEP.Category				= "TFA HL2 Дробовики"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.PrintName				= "SPAS-14"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 3				-- Slot in the weapon selection menu
SWEP.SlotPos				= 60		-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative to other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false
SWEP.ViewModel = "models/weapons/metropolice_smg/spas12/v_spas12.mdl"
SWEP.WorldModel = "models/weapons/metropolice_smg/spas12/w_spas12.mdl"
SWEP.Base 				= "tfa_shotty_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire6.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 83		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6			-- Size of a clip
SWEP.Primary.DefaultClip		= 30	-- Default number of bullets in a clip
SWEP.Primary.KickUp			    = 1.278				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 1.278		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 1.278	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "buckshot"

SWEP.Secondary.IronFOV			= 60		-- How much you 'zoom' in. Less is more! 

SWEP.ShellTime			= .5

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("weapons/metropolice_smg/spas12/spas12_load.wav") }
	},
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 0.25, ["type"] = "lua", ["value"] = function( wep ) wep:SendWeaponAnim(ACT_SHOTGUN_PUMP) end, ["client"] = true, ["server"] = true },
		{ ["time"] = 0.25, ["type"] = "lua", ["value"] = function( wep ) wep:GetOwner():EmitSound("weapons/shotgun/shotgun_cock.wav") end, ["client"] = false, ["server"] = true }
	}
}

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 0

SWEP.Primary.NumShots	= 7		-- How many bullets to shoot per trigger pull, AKA pellets
SWEP.Primary.Damage		= 26	-- Base damage per bullet
SWEP.Primary.Spread		= 0.08	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0	-- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 3.778

SWEP.IronRecoilMultiplier = 0
SWEP.CrouchAccuracyMultiplier = 1

SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9 --Multiply the player's movespeed by this when sighting.

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-8.9203, -4.7091, 1.7697)
SWEP.IronSightsAng = Vector(3.0659, 0.0913, 0)
SWEP.SightsPos = Vector(-7.64, -3.225, 3.48)
SWEP.SightsAng = Vector(0.13, 0.089, 0)
SWEP.RunSightsPos = Vector(9.843, -16.458, 0)
SWEP.RunSightsAng = Vector(-5.371, 70, 0)

SWEP.IronSightTime = 0.325

SWEP.StatCache_Blacklist = {
    ["Primary.NumShots"] = true,
    ["Primary.Damage"] = true,
	["Primary.Sound"] = true,
	["Primary.AmmoConsumption"] = true
}

DEFINE_BASECLASS(SWEP.Base)
--[[
function SWEP:PrimaryAttack()

	self.Primary.NumShots	= 7		-- How many bullets to shoot per trigger pull, AKA pellets
	self.Primary.Damage		= 26
	self.Primary.AmmoConsumption = 1
	self.Primary.Sound			= Sound("weapons/shotgun/shotgun_fire7.wav")
	BaseClass.PrimaryAttack(self)

end


function SWEP:SecondaryAttack()
	if !self:GetOwner():isOTA() then return end
	self.Primary.NumShots	= 9		-- How many bullets to shoot per trigger pull, AKA pellets
	self.Primary.AmmoConsumption = 2
	self.Primary.Sound			= Sound("weapons/shotgun/shotgun_dbl_fire7.wav")
	BaseClass.PrimaryAttack(self)
end
--]]