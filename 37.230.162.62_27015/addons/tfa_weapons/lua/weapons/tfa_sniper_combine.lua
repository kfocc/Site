SWEP.Category				= "TFA HL2 Снайперки"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "1" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "1" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "Sniper Rifle CMB"		-- Weapon name (Shown on HUD)	
SWEP.Slot				= 4				-- Slot in the weapon selection menu
SWEP.SlotPos				= 52			-- Position in the slot
SWEP.DrawAmmo				= true		-- Should draw the default HL2 ammo counter
SWEP.DrawWeaponInfoBox			= false		-- Should draw the weapon info box
SWEP.BounceWeaponIcon   		= 	false	-- Should the weapon icon bounce?
SWEP.DrawCrosshair			= false		-- Set false if you want no crosshair from hip
SWEP.Weight				= 50			-- Rank relative ot other weapons. bigger is better
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.XHair					= false		-- Used for returning crosshair after scope. Must be the same as DrawCrosshair
SWEP.HoldType 				= "ar2"

SWEP.ViewModelFOV			= 55
SWEP.ViewModelFlip			= false
SWEP.ViewModel		= "models/rtb_weapons/v_sniper.mdl"
SWEP.WorldModel		= "models/rtb_weapons/w_sniper.mdl"
SWEP.Base 				= "tfa_gun_base"
SWEP.Scoped = true
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.DisableChambering = true

SWEP.Primary.Sound			= Sound("^npc/sniper/echo1.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 125		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 8		-- Size of a clip
SWEP.Primary.DefaultClip			= 30	-- Bullets you start with
SWEP.Primary.KickUp			= 0.534				-- Maximum up recoil (rise)
SWEP.Primary.KickDown			= 0.534		-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.534		-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"

SWEP.TracerName = "AR2Tracer"
SWEP.TracerCount = 1

SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("npc/sniper/reload1.wav") }
	},
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function( wep ) wep:GetOwner():EmitSound("npc/sniper/sniper1.wav") end, ["client"] = false, ["server"] = true }
	}
}

SWEP.Secondary.MinZoom				= 4
SWEP.Secondary.MaxZoom				= 8
SWEP.Secondary.ScopeZoom			= 8
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
SWEP.Primary.Damage		= 100	--base damage per bullet
SWEP.Primary.Spread		= 0.05	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.0001 -- ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.334

SWEP.IronRecoilMultiplier = 0.834
SWEP.CrouchAccuracyMultiplier = 0.834

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

-- enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-5.961, 0, 2.759)
SWEP.IronSightsAng = Vector(-1.601, -4.401, 0)
SWEP.SightsPos = Vector(-5.961, 0, 2.759)
SWEP.SightsAng = Vector(-1.601, -4.401, 0)
SWEP.RunSightsPos = Vector(13.868, -12.744, -2.05)
SWEP.RunSightsAng = Vector(-4.435, 62.558, 0)