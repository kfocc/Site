SWEP.Category				= "TFA HL2 Автоматы"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "AR2 RUSTY"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 6			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "shotgun"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false --should have left it as original, and let everybody do as little change to the coding as necessary. 
	--But no, you just had to go and screw with the viewmodel.
	--goddammit, you're making me spend a lot of time fixing this mess.
SWEP.ViewModel				= "models/weapons/c_ar2rusty.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_ar2rusty.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/ar2/fire1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 550			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 30		-- Size of a clip
SWEP.Primary.DefaultClip		= 300		-- Bullets you start with
SWEP.Primary.KickUp				= 0.3		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.3		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.3		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"

SWEP.TracerName = "AR2Tracer"
SWEP.TracerCount = 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 31	-- Base damage per bullet
SWEP.Primary.Spread		= 0.05	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 1 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1

SWEP.IronRecoilMultiplier = 0 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 3 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

SWEP.data 				= {}
SWEP.data.ironsights			= 0
SWEP.ScopeScale 			= 1

SWEP.SelectiveFire		= false

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-6.441, 0, 2.88)
SWEP.IronSightsAng = Vector(-1.8, -2.401, 0)
SWEP.SightsPos = Vector(-6.441, 0, 2.88)
SWEP.SightsAng = Vector(-1.8, -2.401, 0)
SWEP.RunSightsPos = Vector(9.369, -17.244, -3.689)
SWEP.RunSightsAng = Vector(6.446, 62.852, 0)

function SWEP:SecondaryAttack()
	return
end

SWEP.JumpRecoilMultiplier = 10
SWEP.JumpAccuracyMultiplier = 20