if CLIENT then
	SWEP.PrintName = "Лазер"
	SWEP.Slot = 0
	SWEP.SlotPos = 3
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = true
end

SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Выстрелить лазером\nПКМ: Крикнуть"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Category = "UnionRP"

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false

SWEP.ViewModel = "models/weapons/c_grenade.mdl"
SWEP.WorldModel = ""

SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

local stalker_sounds = {
	laser = "npc/stalker/laser_burn.wav",
	laser_start = "weapons/gauss/fire1.wav",
	cry1 = "npc/stalker/go_alert2.wav",
	cry2 = "npc/stalker/go_alert2a.wav"
}

function SWEP:Initialize()
	self:SetHoldType("normal")
end

function SWEP:Deploy()
	if not self.ModelDraw then
		self:GetOwner():DrawViewModel(false)
		if SERVER then self:GetOwner():DrawWorldModel(false) end
	end
end

function SWEP:PrimaryAttack()
	if not SERVER then return end
	local owner = self:GetOwner()
	if not owner:IsOnGround() then return end
	local pos = owner:GetBonePosition(owner:LookupBone("ValveBiped.Bip01_Head1"))
	local laser = ents.Create("info_target")
	laser:SetPos(owner:GetEyeTrace().HitPos + owner:EyeAngles():Forward())
	laser:SetName("laser_target_" .. owner:EntIndex() .. "_" .. CurTime())
	laser:Spawn()

	local laser_beam = ents.Create("env_laser")
	laser_beam:SetPos(pos + owner:EyeAngles():Forward() * 35)
	laser_beam:SetKeyValue("texture", "materials/cable/redlaser.vmt")
	laser_beam:SetKeyValue("width", 4.5)
	laser_beam:SetKeyValue("dissolvetype", 0)
	laser_beam:SetKeyValue("damage", 300)
	laser_beam:SetKeyValue("LaserTarget", laser:GetName())
	laser_beam:Spawn()
	laser_beam:Fire("turnon", "", 0)

	owner:Freeze(true)

	local beam_sound = CreateSound(owner, stalker_sounds.laser)
	beam_sound:ChangeVolume(0.5)
	beam_sound:Play()

	owner:EmitSound(stalker_sounds.laser_start, 45)

	timer.Simple(1, function()
		local laser = laser
		local laser_beam = laser_beam
		local beam_sound = beam_sound
		local owner = owner
		if IsValid(laser) then laser:Remove() end
		if IsValid(laser_beam) then laser_beam:Remove() end
		if beam_sound then beam_sound:Stop() end
		if IsValid(owner) then owner:Freeze(false) end
	end)

	self:SetNextPrimaryFire(CurTime() + 0.1)
end

function SWEP:SecondaryAttack()
	if not SERVER then return end
	local owner = self:GetOwner()
	owner:EmitSound(math.random(1, 2) == 2 and stalker_sounds.cry1 or stalker_sounds.cry2, 90)
	self:SetNextSecondaryFire(CurTime() + 5)
end

function SWEP:Reload()
	return
end

function SWEP:Think()
end
