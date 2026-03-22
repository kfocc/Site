SWEP.Category				= "TFA HL2 ПП"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "1" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "MP7 CMB+"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 20			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false
SWEP.ViewModel			= "models/weapons/c_mp7+.mdl"
SWEP.WorldModel			= "models/weapons/w_mp7+.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/new_union_plus/mp7+.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 720			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 35		-- Size of a clip
SWEP.Primary.DefaultClip		= 100		-- Bullets you start with
SWEP.Primary.KickUp				= 0.316		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.316		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.158		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("Weapon_SMG1.Reload") }
	}
}

SWEP.Secondary.IronFOV			= 70		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 25	-- Base damage per bullet

--Firing Cone Related
SWEP.Primary.Spread = 0.026 --This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = 0.006 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.116
SWEP.IronRecoilMultiplier = 0.616
SWEP.CrouchAccuracyMultiplier = 0.616

SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9 --Multiply the player's movespeed by this when sighting.

SWEP.SelectiveFire		= false

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-6.4318, -2.0031, 1)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.748, -9.686, 0)
SWEP.RunSightsAng = Vector(-6.974, 49.881, -5.237)

SWEP.JumpRecoilMultiplier = 10
SWEP.JumpAccuracyMultiplier = 20