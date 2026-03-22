SWEP.UseHands			= true
SWEP.Category				= "TFA Снайперки"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment                   = "1"   -- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment                       = "2"   -- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Barrett M82"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 21			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- set false if you want no crosshair
SWEP.Weight				= 30			-- rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.XHair                              = false         -- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.HoldType 				= "rpg"		-- how others view you carrying the weapon

SWEP.SelectiveFire		= false
SWEP.CanBeSilenced		= false
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_cod4_barrett50.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_cod4_barrett50cal.mdl"	-- Weapon world model
SWEP.Base				= "tfa_gun_base"
SWEP.Scoped = true
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.Primary.Sound			= Sound("cod4_barrett50.Single")		-- Script that calls the primary fire sound
SWEP.Primary.RPM			= 60			-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 10		-- Size of a clip
SWEP.Primary.DefaultClip		= 30		-- Bullets you start with
SWEP.Primary.KickUp				= 0.491		-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.491	-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal		= 0.491	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic = true; Semi Auto = false
SWEP.Primary.Ammo			= "ar2"			-- pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, AirboatGun
-- Pistol, buckshot, and slam always ricochet. Use AirboatGun for a light metal peircing shotgun pellets


SWEP.IronSightsSensitivity = 1

SWEP.ShellTime                  = 1

SWEP.Secondary.MinZoom				= 4
SWEP.Secondary.MaxZoom				= 8
SWEP.Secondary.ScopeZoom            = 8
SWEP.Secondary.UseParabolic             = true -- Choose your scope type,
SWEP.Secondary.UseACOG                  = false
SWEP.Secondary.UseMilDot                = false
SWEP.Secondary.UseSVD                   = false
SWEP.Secondary.UseElcan                 = false
SWEP.Secondary.UseGreenDuplex   = false

SWEP.ShellTime                  = 1

SWEP.data                               = {}                            --The starting firemode
SWEP.data.ironsights                    = 1
SWEP.ScopeScale                         = 0.7

SWEP.Primary.NumShots   = 1             --how many bullets to shoot per trigger pull
SWEP.Primary.Damage             = 190   --base damage per bullet
SWEP.Primary.Spread             = 0.09 --define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.0001 -- ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.291

SWEP.IronRecoilMultiplier = 0.791
SWEP.CrouchAccuracyMultiplier = 0.791 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

-- Enter iron sight info and bone mod info below
SWEP.SightsPos = Vector(-4.52, -4.281, 1.08)
SWEP.SightsAng = Vector(0.8, 0.4, 0)
SWEP.RunSightsPos = Vector (-1.961, 0, -1.241)
SWEP.RunSightsAng = Vector (-10.801, 34.099, -33.401)
SWEP.InspectPos = Vector(5.639, 0, 2.16)
SWEP.InspectAng = Vector(-2.701, 19.5, 17)


SWEP.Offset = {
        Pos = {
        Up = 0,
        Right = 0,
        Forward = 2,
        },
        Ang = {
        Up = 0,
        Right = -9,
        Forward = 180,
        },
		Scale = 1.0
}
/*SWEP.VElements = {
	["element_name"] = { type = "Model", model = "models/rtcircle.mdl", bone = "tag_weapon", rel = "", pos = Vector(-1.621, 0.009, 6.579), angle = Angle(0, 180, 0), size = Vector(0.465, 0.465, 0.465), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!tfa_rtmaterial", skin = 0, bodygroup = {} }
}*/

/*
local ceedee = {}

SWEP.RTMaterialOverride = -1 --the number of the texture, which you subtract from GetAttachment

SWEP.RTOpaque = true

local g36
if surface then
	g36 = surface.GetTextureID("scope/gdcw_parabolicsight") --the texture you vant to use
end
SWEP.Secondary.ScopeZoom = 8 --IMPORTANT BIT
SWEP.RTScopeAttachment = 0
SWEP.ScopeAngleTransforms = {}
SWEP.ScopeOverlayTransformMultiplier = 1
SWEP.ScopeOverlayTransforms = {0, 0}
*/