SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA Melee pack 1"
SWEP.PrintName = "Арматура"
SWEP.Author = "UnionRP"
SWEP.ViewModel = "models/weapons/tfa_kf2/c_zweihander.mdl"
SWEP.ViewModelFOV = 100
SWEP.VMPos = Vector(0, -2, -1)
SWEP.UseHands = true
SWEP.CameraOffset = Angle(0, 0, 0)
--SWEP.InspectPos = Vector(17.184, -4.891, -11.902) - SWEP.VMPos
--SWEP.InspectAng = Vector(70, 46.431, 70)
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.HoldType = "melee2"
SWEP.Primary.Directional = true
SWEP.Primary.MaxCombo = -1 --Max amount of times you'll attack by simply holding down the mouse; -1 to unlimit
SWEP.Secondary.MaxCombo = 1 --Max amount of times you'll attack by simply holding down the mouse; -1 to unlimit
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.DisableIdleAnimations = false

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		["dmg"] = 100, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.55, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.45,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 1, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "NPC_Stalker.Hit",
		["hitworld"] = "Concrete.BulletImpact"
	},
	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		["dmg"] = 100, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.4, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.3,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.75, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "NPC_Stalker.Hit",
		["hitworld"] = "Concrete.BulletImpact"
	},
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 100, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.35,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.75, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "", --Swing dir,
		["hitflesh"] = "NPC_Stalker.Hit",
		["hitworld"] = "Concrete.BulletImpact"
	},
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(0, 30, 10), -- Trace arc cast
		["dmg"] = 100, --Damage
		["dmgtype"] = DMG_SLASH, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.2, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.1,
		["viewpunch"] = Angle(-5, 0, 2), --viewpunch angle
		["end"] = 0.75, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "Weapon_Crossbow.BoltHitBody",
		["hitworld"] = "Weapon_Crossbow.BoltHitWorld"
	},
	{
		["act"] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(0, 20, 70), -- Trace arc cast
		["dmg"] = 100, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.35, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.25,
		["viewpunch"] = Angle(-5, 0, 0), --viewpunch angle
		["end"] = 0.75, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "B", --Swing dir,
		["hitflesh"] = "NPC_Stalker.Hit",
		["hitworld"] = "Concrete.BulletImpact"
	}
}

SWEP.Secondary.Attacks = {
	{
		["act"] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		["dmg"] = 200, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.63, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.53,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 1.5, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "Flesh.ImpactHard",
		["hitworld"] = "Bounce.Concrete"
	},
	{
		["act"] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		["dmg"] = 200, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.63, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.53,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 1.5, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "Breakable.Flesh",
		["hitworld"] = "Bounce.Concrete"
	},
	{
		["act"] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 200, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.72, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.62,
		["viewpunch"] = Angle(10, 0, 0), --viewpunch angle
		["end"] = 1.5, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "Flesh.ImpactHard",
		["hitworld"] = "Bounce.Concrete"
	},
	{
		["act"] = ACT_VM_PULLBACK_HIGH, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 75 * 0.5 + 30, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 200, --Damage
		["dmgtype"] = DMG_CLUB, --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.65, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_Crowbar.Single", -- Sound ID
		["snd_delay"] = 0.55,
		["viewpunch"] = Angle(7.5, 0, 0), --viewpunch angle
		["end"] = 1.5, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "B", --Swing dir,
		["hitflesh"] = "Flesh.ImpactHard",
		["hitworld"] = "Bounce.Concrete"
	}
}

SWEP.AllowSprintAttack = false

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_HYBRID-- ANI = mdl, Hybrid = ani + lua, Lua = lua only
SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_out", --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(-5, 2.5, -2.5)


SWEP.CanBlock = true
SWEP.BlockAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_DEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	}, --Inward transition
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_IDLE_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--looping animation
	["hit"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_RELOAD_DEPLOYED, --Number for act, String/Number for sequence
		["is_idle"] = true
	},--when you get hit and block it
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_UNDEPLOY, --Number for act, String/Number for sequence
		["transition"] = true
	} --Outward transition
}
SWEP.BlockCone = 60 --Think of the player's view direction as being the middle of a sector, with the sector's angle being this
SWEP.BlockDamageMaximum = 0 --Multiply damage by this for a maximumly effective block
SWEP.BlockDamageMinimum = 0 --Multiply damage by this for a minimumly effective block
SWEP.BlockTimeWindow = 1 --Time to absorb maximum damage
SWEP.BlockTimeFade = 1 --Time for blocking to do minimum damage.  Does not include block window
SWEP.BlockSound = "Missile.ShotDown"
SWEP.BlockDamageCap = 999999999
SWEP.BlockDamageTypes = {
	DMG_SLASH,DMG_CLUB,
}

SWEP.Secondary.CanBash = true
SWEP.Secondary.BashDamage = 130
SWEP.Secondary.BashDelay = 0.25
SWEP.Secondary.BashLength = 16 * 5.5

SWEP.SequenceLengthOverride = {
	[ACT_VM_HITCENTER] = 0.8,
	[ACT_VM_DRAW] = 0.75,
	[ACT_VM_UNDEPLOY] = 0.5
}

SWEP.ViewModelBoneMods = {
}

SWEP.InspectionActions = {ACT_VM_RECOIL1, ACT_VM_RECOIL2, ACT_VM_RECOIL3}

SWEP.Offset = {
	Pos = {
		Up = 0,
		Right = 1,
		Forward = 4
	},
	Ang = {
		Up = 80,
		Right = -10,
		Forward = 180
	},
	Scale = 1
}

SWEP.EventTable = {
	[ACT_VM_RECOIL3] = {
		{ ["time"] = 0.0, ["type"] = "sound", ["value"] = "TFA_KF2_ZWEIHANDER.Twirl" }
	}
}



SWEP.ShowWorldModel = false
SWEP.ViewModelBoneMods = {
	["RW_Weapon"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["rebar"] = { type = "Model", model = "models/props_debris/rebar004b_48.mdl", bone = "RW_Weapon", rel = "", pos = Vector(0, 0.5, 12), angle = Angle(180, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["rebar"] = { type = "Model", model = "models/props_debris/rebar004b_48.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.5, 2, -12), angle = Angle(0, 0, 0), size = Vector(0.75, 0.75, 0.75), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
