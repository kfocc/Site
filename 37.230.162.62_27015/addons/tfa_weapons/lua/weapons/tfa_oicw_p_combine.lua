SWEP.Category				= "TFA HL2 Автоматы"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "XM29 OICW+"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 2				-- Slot in the weapon selection menu
SWEP.SlotPos				= 2			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= true		-- Set false if you want no crosshair from hip
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.HoldType 				= "ar2"

SWEP.ViewModelFOV			= 60
SWEP.ViewModelFlip			= false
SWEP.ViewModel  = "models/weapons/v_oicw+.mdl"
SWEP.WorldModel = "models/weapons/w_oicw+.mdl"
SWEP.Base 				= "tfa_gun_base"
SWEP.Scoped = true
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.DisableChambering = false

SWEP.Primary.Sound			= Sound("weapons/metropolice_smg/usp_match/usp_shoot.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 580		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 35		-- Size of a clip
SWEP.Primary.DefaultClip			= 100	-- Bullets you start with
SWEP.Primary.KickUp			= 0.335				-- Maximum up recoil (rise)
SWEP.Primary.KickDown		= 0.335		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal	= 0.167		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= true		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "ar2"

SWEP.TracerName = "AR2Tracer"
SWEP.TracerCount = 1

SWEP.Secondary.ScopeZoom			= 2
SWEP.Secondary.UseParabolic		= false	-- Choose your scope type, 
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot		= false		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= true	

SWEP.ShellTime			= 1

SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 0.7

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 39	--base damage per bullet

--Firing Cone Related
SWEP.Primary.Spread		= 0.033	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.013 -- ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.235 --How far the spread can expand when you shoot. Example val: 2.5

SWEP.IronRecoilMultiplier = 0.635 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 0.635 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.


SWEP.IronSightsPos = Vector(-8.9203, -4.7091, 1.7697)
SWEP.IronSightsAng = Vector(3.0659, 0.0913, 0)
SWEP.SightsPos = Vector(-5.961, 0, 2.759)
SWEP.SightsAng = Vector(-1.601, -4.401, 0)
SWEP.RunSightsPos = Vector(13.868, -12.744, -2.05)
SWEP.RunSightsAng = Vector(-4.435, 62.558, 0)

SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.JumpRecoilMultiplier = 10
SWEP.JumpAccuracyMultiplier = 20