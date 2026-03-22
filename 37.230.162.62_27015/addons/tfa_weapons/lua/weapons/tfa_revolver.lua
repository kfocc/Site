SWEP.Category				= "TFA HL2 Пистолеты"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Python Elite"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 1				-- Slot in the weapon selection menu
SWEP.SlotPos				= 35			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "revolver"		-- how others view you carrying the weapon

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/c_357.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_357.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("Weapon_357.Single")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 230			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 6		-- Size of a clip
SWEP.Primary.DefaultClip		= 21		-- Bullets you start with
SWEP.Primary.KickUp				= 0.33		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.33		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.33		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "357"

SWEP.DisableChambering = true

SWEP.Secondary.IronFOV			= 65		-- How much you 'zoom' in. Less is more! 	

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1

SWEP.Primary.NumShots	= 1		-- How many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 80	-- Base damage per bullet
SWEP.Primary.Spread		= 0.027	-- Define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.007 -- Ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.33
SWEP.IronRecoilMultiplier = 0.53
SWEP.CrouchAccuracyMultiplier = 0.53

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 1

-- Enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-4.72, 0, 0.56)
SWEP.IronSightsAng = Vector(0.3, -0.25, 1.299)
SWEP.RunSightsPos = Vector(2.405, -17.334, -15.011)
SWEP.RunSightsAng = Vector(70, 0, 0)
	