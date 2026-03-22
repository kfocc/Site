SWEP.Category				= "TFA HL2 ПП"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "1" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "MP5K CMB+"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 22			-- Position in the slot
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
SWEP.ViewModel			= "models/weapons/metropolice_smg/mp5k/v_mp5k.mdl"
SWEP.WorldModel			= "models/weapons/metropolice_smg/mp5k/w_mp5k.mdl"
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("weapons/metropolice_smg/mp5k/single.wav")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 850			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 18		-- Size of a clip
SWEP.Primary.DefaultClip		= 100		-- Bullets you start with
SWEP.Primary.KickUp				= 0.271		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.271		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.135		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "smg1"

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("weapons/metropolice_smg/mp5k/reload.wav") }
	}
}

SWEP.Secondary.IronFOV			= 55		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 21	-- Base damage per bullet
SWEP.Primary.Spread		= 0.022	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.002 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.071
SWEP.IronRecoilMultiplier = 0.571
SWEP.CrouchAccuracyMultiplier = 0.571

SWEP.SelectiveFire		= false

--Movespeed
SWEP.MoveSpeed = 1 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9 --Multiply the player's movespeed by this when sighting.

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-6.47, 1, -0.5)
SWEP.IronSightsAng = Vector(3, 0, 0)
SWEP.RunSightsPos = Vector(5.748, -9.686, 0)
SWEP.RunSightsAng = Vector(-6.974, 49.881, -5.237)

SWEP.JumpRecoilMultiplier = 10
SWEP.JumpAccuracyMultiplier = 20