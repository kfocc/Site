SWEP.UseHands				= true

SWEP.Type 					= "Sniper Rifle"

SWEP.Category				= "TFA Снайперки"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Dragunov"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.HoldType 				= "ar2"		-- how others view you carrying the weapon
SWEP.XHair                              = false 
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive 
-- you're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles

SWEP.SelectiveFire		= false
SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_cod4_drag.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_cod4_drag.mdl"	-- Weapon world model
SWEP.Base                               = "tfa_gun_base"
SWEP.Scoped = true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("cod4_dragunov_new.Single")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 150			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip		= 30		-- Bullets you start with
SWEP.Primary.KickUp				= 0.547		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.547		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.547		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets

SWEP.ShellTime                  = 1

SWEP.Secondary.MinZoom				= 3
SWEP.Secondary.MaxZoom				= 6
SWEP.Secondary.ScopeZoom			= 6
SWEP.Secondary.UseParabolic             = false -- Choose your scope type, 
SWEP.Secondary.UseACOG                  = false
SWEP.Secondary.UseMilDot                = false          
SWEP.Secondary.UseSVD                   = true 
SWEP.Secondary.UseElcan                 = false
SWEP.Secondary.UseGreenDuplex   = false 

SWEP.ShellTime                  = 1

SWEP.data                               = {}                            --The starting firemode
SWEP.data.ironsights                    = 1
SWEP.ScopeScale                         = 0.7

SWEP.Primary.NumShots   = 1             --how many bullets to shoot per trigger pull
SWEP.Primary.Damage             = 85   --base damage per bullet
SWEP.Primary.Spread             = 0.04 --define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.0001 -- ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.347

SWEP.IronRecoilMultiplier = 0.847
SWEP.CrouchAccuracyMultiplier = 0.847

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-3.881, -2, 1.679)
SWEP.SightsAng = Vector(-0.401, 0.2, 0)
SWEP.RunSightsPos = Vector (-0.32, 0, -3)
SWEP.RunSightsAng = Vector (-9.2, 50.299, -31.101)
SWEP.InspectPos = Vector(2.799, 0, 2)
SWEP.InspectAng = Vector(3.2, 11.699, 17.299)


SWEP.Offset = {
        Pos = {
        Up = 1,
        Right = 0,
        Forward = 2,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 0.9
}
/*
	SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/rtcircle.mdl", bone = "tag_weapon", rel = "", pos = Vector(-2.842, 0, 4.469), angle = Angle(0, -180, 0), size = Vector(0.275, 0.275, 0.275), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}


local ceedee = {}

SWEP.RTMaterialOverride = -1 --the number of the texture, which you subtract from GetAttachment

SWEP.RTOpaque = true

local g36
if surface then
	g36 = surface.GetTextureID("scope/gdcw_svdsight") --the texture you vant to use
end
SWEP.Secondary.ScopeZoom = 8 --IMPORTANT BIT
SWEP.RTScopeAttachment = 0
SWEP.ScopeAngleTransforms = {}
SWEP.ScopeOverlayTransformMultiplier = 1
SWEP.ScopeOverlayTransforms = {0, 0}

SWEP.ScopeReticule = ("custom/pso1")
*/