SWEP.Category				= "TFA HL2 Пистолеты"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "USP Match"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 45			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "pistol"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/c_pistol.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_pistol.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("^weapons/pistol/pistol_fire2.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 500			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 18		-- Size of a clip
SWEP.Primary.DefaultClip		= 60		-- Bullets you start with
SWEP.Primary.KickUp				= 0.355		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.355		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.355		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "pistol"

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("weapons/pistol/pistol_reload1.wav") }
	}
}

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 34	-- Base damage per bullet
SWEP.Primary.Spread		= 0.029	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.009 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.355
SWEP.IronRecoilMultiplier = 0.555
SWEP.CrouchAccuracyMultiplier = 0.555

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 1

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-6.04, 0, 2.839)
SWEP.IronSightsAng = Vector(0.6, -1.3, 2.4)
SWEP.RunSightsPos = Vector(5, -15, -12)
SWEP.RunSightsAng = Vector(50, -12, 8.572)

SWEP.DisableIdleAnimations = false
