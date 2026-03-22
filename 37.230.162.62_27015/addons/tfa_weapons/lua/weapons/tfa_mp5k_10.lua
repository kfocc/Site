SWEP.Category				= "TFA HL2 ПП"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "1" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "MP5K CMB"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 23			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "smg"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 50
SWEP.ViewModelFlip			= false
SWEP.ViewModel			= "models/weapons/smg2/v_5mg2.mdl"
SWEP.WorldModel			= "models/weapons/smg2/w_smg2.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/1smg2/npc_smg2_fire1.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 815			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 25		-- Size of a clip
SWEP.Primary.DefaultClip		= 100		-- Bullets you start with
SWEP.Primary.KickUp				= 0.259		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.259		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.129		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("weapons/smg1/smg1_reload.wav") }
	}
}

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 18	-- Base damage per bullet
SWEP.Primary.Spread		= 0.02	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.059
SWEP.IronRecoilMultiplier = 0.559
SWEP.CrouchAccuracyMultiplier = 0.559

SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9 --Multiply the player's movespeed by this when sighting.

SWEP.SelectiveFire		= false

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector (-6.46, -2.0031, 1.1)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.RunSightsPos = Vector(5.748, -9.686, 0)
SWEP.RunSightsAng = Vector(-6.974, 49.881, -5.237)

SWEP.JumpRecoilMultiplier = 10
SWEP.JumpAccuracyMultiplier = 20