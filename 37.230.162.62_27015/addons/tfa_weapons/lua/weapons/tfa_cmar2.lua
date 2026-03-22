SWEP.Category				= "TFA HL2 Автоматы"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "CMAR2"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 1			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false --should have left it as original, and let everybody do as little change to the coding as necessary. 
	--But no, you just had to go and screw with the viewmodel.
	--goddammit, you're making me spend a lot of time fixing this mess.
SWEP.ViewModel			= "models/weapons/v_crifle.mdl"
SWEP.WorldModel			= "models/weapons/w_crifle.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/cmar2/fire1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 600			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 60		-- Size of a clip
SWEP.Primary.DefaultClip		= 200		-- Bullets you start with
SWEP.Primary.KickUp				= 0.32		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.32		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.16		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"

SWEP.TracerName = "AirboatGunTracer"
SWEP.TracerCount = 1

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 0

SWEP.VMPos = Vector(4,0,-2) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.
SWEP.VMAng = Vector(0,0,0) --The viewmodel angular offset, constantly.   Subtract this from any other modifications to viewmodel angle.
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0.2, ["type"] = "sound", ["value"] = Sound("weapons/m249/m249_boxout.wav") },
		{ ["time"] = 1.3, ["type"] = "sound", ["value"] = Sound("weapons/m249/m249_boxin.wav") },
		{ ["time"] = 1.6, ["type"] = "sound", ["value"] = Sound("weapons/ar2/ar2_reload_rotate.wav") }
	},
}

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 40	-- Base damage per bullet
--Firing Cone Related
SWEP.Primary.Spread		= 0.03	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.2--How far the spread can expand when you shoot. Example val: 2.5

SWEP.IronRecoilMultiplier = 0 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 0.6 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.data 				= {}
SWEP.data.ironsights			= 0
SWEP.ScopeScale 			= 0.7

SWEP.SelectiveFire		= false

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-3.25, -10, 0.75)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.SightsPos = Vector(-3.25, -10, 0.75)
SWEP.SightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(9.369, -17.244, -3.689)
SWEP.RunSightsAng = Vector(6.446, 62.852, 0)

SWEP.JumpRecoilMultiplier = 10
SWEP.JumpAccuracyMultiplier = 20