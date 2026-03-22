SWEP.Base					= "tfa_ins2_nade_base"
SWEP.Category               = ( TFA and TFA.Yankys_Custom_Weapon_Pack_Categories ) and "[TFA] [AT] [ Equipment ]" or "TFA Grenades"
SWEP.Author					= "UnionRP"
SWEP.Manufacturer           = "U.S.A"
SWEP.PrintName				= ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "AN-M14 TH4 Grenade" or "Зажигательная граната"  		           
SWEP.Type                   = ( TFA and TFA.Yankys_Custom_Weapon_Pack ) and "Type: Incendiary Grenade" or "Incendiary Grenade"
SWEP.Slot					= 4
SWEP.SlotPos				= 76
SWEP.DrawAmmo				= true
SWEP.DrawCrosshair			= false
SWEP.Weight					= 2
SWEP.AutoSwitchTo		    = true
SWEP.AutoSwitchFrom			= true
SWEP.HoldType 				= "grenade"
SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.Primary.RPM		    = 30
SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 2
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "grenade"
SWEP.Primary.Round 			= ("ent_ins2_anm14")
SWEP.Velocity               = 976
SWEP.Velocity_Underhand     = 455
SWEP.Delay                  = 0.23
SWEP.DelayCooked            = 0.24
SWEP.Delay_Underhand        = 0.245
SWEP.CookStartDelay         = 1
SWEP.UnderhandEnabled       = true
SWEP.CookingEnabled         = true
SWEP.CookTimer              = 3

SWEP.SelectiveFire       = false                        -- Allow selecting your firemode?
SWEP.DisableBurstFire    = false                        -- Only auto/single?
SWEP.OnlyBurstFire       = false                        -- No auto, only burst/single?
SWEP.DefaultFireMode     = "Thrown"                     -- Default to auto or whatev
SWEP.FireModeName        = "Thrown"                     -- Change to a text value to override it
 
SWEP.ViewModelFOV			= 70
SWEP.ViewModelFlip			= false
SWEP.ViewModel				= "models/weapons/v_anm14.mdl"

SWEP.WorldModel				= "models/weapons/w_anm14.mdl"

SWEP.VMPos = Vector(-0.5, 0, 0)
SWEP.VMAng = Vector(0,0,0)

SWEP.CrouchPos    = Vector(-0.5, -1, -0.5) + SWEP.VMPos
SWEP.CrouchAng    = Vector(0, 0, -5) + SWEP.VMAng

SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-5, 2.5, 0)

SWEP.Offset = {
	Pos = {
		Up = -1.1,
		Right = 1.4,
		Forward = 2.595
	},
	
	Ang = {
		Up = -1.043,
		Right = 0,
		Forward = 180,
	},
	
	Scale = 1
}

SWEP.Sprint_Mode     = TFA.Enum.LOCOMOTION_ANI
SWEP.SprintBobMult   = 0.35
SWEP.SprintFOVOffset = 5

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ,
		["value"] = "base_sprint",
		["is_idle"] = true
	},
}

SWEP.InspectPos = Vector(4, -3.619, -0.787)
SWEP.InspectAng = Vector(22.386, 34.417, 5)

SWEP.ViewModelBoneMods = {
	["L Hand"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
    ["R Hand"] = { scale = Vector(0.8, 0.8, 0.8), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
}

SWEP.WElements = {
	["ref"] = { type = "Model", model = SWEP.WorldModel, bone = "oof", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(0.9, 0.9, 0.9), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true, active = false },
}

if Yankys_Custom_Weapon_Pack then
    function SWEP:OnCustomizationOpen()
    	self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Open")
    end

    function SWEP:OnCustomizationClose()
    	self:EmitSound("TFA.Yankys_Custom_Weapon_Pack.Customization_Panel_Close")
    end
end