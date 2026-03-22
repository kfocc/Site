SWEP.Category				= "TFA HL2 Снайперки"
SWEP.Author				= "UnionRP"
SWEP.Contact				= ""
SWEP.Purpose				= ""
SWEP.Instructions				= ""
SWEP.MuzzleAttachment			= "muzzle" 	-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellEjectAttachment			= "2" 	-- Should be "2" for CSS models or "1" for hl2 models
SWEP.PrintName				= "OSR-1"		-- Weapon name (Shown on HUD)
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
SWEP.HoldType 				= "smg"

SWEP.ViewModelFOV			= 65
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/c_shotgun.mdl"	-- Weapon view model
SWEP.WorldModel				= "models/weapons/w_snip_scout.mdl"	-- Weapon world model
SWEP.Base 				= "tfa_gun_base"
SWEP.Scoped = true
SWEP.Spawnable				= true
SWEP.UseHands = true
SWEP.AdminSpawnable			= true
SWEP.FiresUnderwater = false

SWEP.DisableChambering = true

SWEP.Primary.Sound			= Sound("weapons/new_union_plus/osr.wav")		-- script that calls the primary fire sound
SWEP.Primary.RPM				= 60		-- This is in Rounds Per Minute
SWEP.Primary.ClipSize			= 1		-- Size of a clip
SWEP.Primary.DefaultClip			= 15	-- Bullets you start with
SWEP.Primary.KickUp			= 0.339				-- Maximum up recoil (rise)
SWEP.Primary.KickDown		= 0.339	-- Maximum down recoil (skeet)
SWEP.Primary.KickHorizontal	= 0.339	-- Maximum up recoil (stock)
SWEP.Primary.Automatic			= false		-- Automatic/Semi Auto
SWEP.Primary.Ammo			= "XBowBolt"

SWEP.TracerName = "HelicopterTracer"
SWEP.TracerCount = 1

SWEP.MuzzleFlashEffect = "tfa_muzzleflash_sniper_energy"

SWEP.Shotgun = true --Enable shotgun style reloading.
SWEP.ShotgunEmptyAnim = false --Enable emtpy reloads on shotguns?
SWEP.ShotgunEmptyAnim_Shell = false --Enable insertion of a shell directly into the chamber on empty reload?
SWEP.ShellTime = .75 -- For shotguns, how long it takes to insert a shell.


SWEP.EventTable = {
	[ACT_VM_RELOAD] = {
		{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("npc/sniper/reload1.wav") }
	},
	[ACT_VM_PRIMARYATTACK] = {
		{ ["time"] = 0, ["type"] = "lua", ["value"] = function( wep ) wep:GetOwner():EmitSound("npc/sniper/sniper1.wav") end, ["client"] = false, ["server"] = true }
	}
}


SWEP.VElements = {
	["rifle"] = { type = "Model", model = "models/weapons/w_combine_sniper.mdl", bone = "ValveBiped.Gun", rel = "", pos = Vector(0, 0, 0), angle = Angle(-90, 90, 0), size = Vector(0.927, 0.927, 0.927), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.ViewModelBoneMods = {
	["ValveBiped.Gun"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}


SWEP.WElements = {
	["rifle"] = { type = "Model", model = "models/weapons/w_combine_sniper.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(18.284, 0.935, -4.922), angle = Angle(169.908, 0, 0), size = Vector(0.999, 0.999, 0.999), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.Secondary.MinZoom				= 4
SWEP.Secondary.MaxZoom				= 8
SWEP.Secondary.ScopeZoom			= 8
SWEP.Secondary.UseParabolic		= false	-- Choose your scope type,
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot		= true
SWEP.Secondary.UseSVD			= false
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex	= false


SWEP.data 				= {}				--The starting firemode
SWEP.data.ironsights			= 1
SWEP.ScopeScale 			= 0.7

SWEP.Primary.NumShots	= 1		--how many bullets to shoot per trigger pull
SWEP.Primary.Damage		= 270	--base damage per bullet
SWEP.Primary.Spread		= 0.1	--define from-the-hip accuracy 1 is terrible, .0001 is exact)
SWEP.Primary.IronAccuracy = 0.0001 -- ironsight accuracy, should be the same for shotguns

SWEP.Primary.SpreadMultiplierMax = 1.139

SWEP.IronRecoilMultiplier = 0.639
SWEP.CrouchAccuracyMultiplier = 0.639

SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.9

-- enter iron sight info and bone mod info below
SWEP.IronSightsPos = Vector(-5.961, 0, 2.759)
SWEP.IronSightsAng = Vector(-1.601, -4.401, 0)
SWEP.SightsPos = Vector(-5.961, 0, 2.759)
SWEP.SightsAng = Vector(-1.601, -4.401, 0)
SWEP.RunSightsPos = Vector(13.868, -12.744, -2.05)
SWEP.RunSightsAng = Vector(-4.435, 62.558, 0)