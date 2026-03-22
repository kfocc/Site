local sndAttackLoop = Sound("fire_large")
local sndSprayLoop = Sound("ambient.steam01")
local sndAttackStop = Sound("ambient/_period.wav")

AddCSLuaFile()

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.ViewModelFOV = 58
SWEP.Category = "UnionRP"
SWEP.PrintName = "Огненный иммолятор"
SWEP.Author = "UnionRP"
SWEP.Slot = 0
SWEP.SlotPos = 3

SWEP.HoldType = "shotgun"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.Instructions = "ЛКМ: Сжечь труп игрока"
SWEP.ViewModel = "models/weapons/v_cremato2.mdl"
SWEP.WorldModel = "models/weapons/w_immolator.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Delay = 0.15
SWEP.Primary.Damage = 20
SWEP.Primary.Spread = math.cos(math.rad(15))
SWEP.Primary.Ammo = ""
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Delay = 0.8
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self.EmittingSound = false
	util.PrecacheModel("models/player/charple.mdl")
end

function SWEP:Think()
	if self:GetOwner():KeyReleased(IN_ATTACK) then self:StopSounds() end
end

local traceRes = {}
local trace = {
	start = Vector(),
	endpos = Vector(),
	maxs = Vector(8, 8, 8),
	mins = Vector(-8, -8, -8),
	mask = MASK_SHOT_PORTAL,
	filter = {NULL, NULL, "forcefields"},
	output = traceRes
}

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	local curtime = CurTime()
	self:SetNextSecondaryFire(curtime + self.Secondary.Delay)
	self:SetNextPrimaryFire(curtime + self.Primary.Delay)
	if self:GetOwner():WaterLevel() > 1 then
		self:StopSounds()
		return
	end

	if not self.EmittingSound then
		self:EmitSound(sndAttackLoop)
		self.EmittingSound = true
	end

	self:GetOwner():MuzzleFlash()
	--self:TakePrimaryAmmo(1)
	--if SERVER then
	local PlayerVel = self:GetOwner():GetVelocity()
	local PlayerPos = self:GetOwner():EyePos()
	local PlayerAng = self:GetOwner():EyeAngles():Forward()
	trace.start = PlayerPos
	trace.endpos = PlayerPos + PlayerAng * 480
	trace.filter[1] = self:GetOwner()
	trace.filter[2] = self
	util.TraceHull(trace)
	local hitpos = traceRes.HitPos
	local jetlength = traceRes.Fraction * 480
	if jetlength < 6 then jetlength = 6 end
	if self:GetOwner():Alive() then
		local effectdata = EffectData()
		effectdata:SetOrigin(hitpos)
		effectdata:SetEntity(self)
		effectdata:SetStart(PlayerPos)
		effectdata:SetNormal(PlayerAng)
		effectdata:SetScale(jetlength)
		effectdata:SetAttachment(1)
		util.Effect("im_flamepuffs", effectdata)
	end

	if self.DoShoot then
		self:FindTarget(PlayerPos, PlayerAng, jetlength)

		self.DoShoot = false
	else
		self.DoShoot = true
	end
end

function SWEP:FindTarget(PlayerPos, PlayerAng, jetlength)
end

function SWEP:SecondaryAttack()
end

function SWEP:StopSounds()
	if self.EmittingSound then
		self:StopSound(sndAttackLoop)
		self:StopSound(sndSprayLoop)
		self:EmitSound(sndAttackStop)
		self.EmittingSound = false
	end
end

function SWEP:Holster()
	self:StopSounds()
	return true
end

function SWEP:OnRemove()
	self:StopSounds()
	return true
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	self:SetNextSecondaryFire(CurTime() + self:SequenceDuration())
	self:Idle()
	return true
end

function SWEP:Holster(weapon)
end

function SWEP:Idle()
end
