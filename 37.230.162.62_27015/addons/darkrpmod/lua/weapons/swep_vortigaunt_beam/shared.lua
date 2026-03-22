if SERVER then
	AddCSLuaFile("shared.lua")
	SWEP.AutoSwitchTo = true
	SWEP.AutoSwitchFrom = true
end

if CLIENT then
	SWEP.DrawAmmo = true
	SWEP.PrintName = "Заряд Вортигонта"
	SWEP.Author = "UnionRP"
	SWEP.DrawCrosshair = true
	SWEP.ViewModelFOV = 54

	SWEP.Contact = ""
	SWEP.Purpose = ""
	SWEP.Instructions = "ЛКМ: Атаковать\nПКМ: Лечить себя\nR: Лечить игрока напротив"

	SWEP.Category = "UnionRP"

	killicon.Add("swep_vortigaunt_beam", "VGUI/killicons/swep_vortigaunt_beam", Color(255, 255, 255))
end

SWEP.Slot = 3
SWEP.SlotPos = 1
SWEP.Weight = 5
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = Model("models/weapons/v_vortbeamvm.mdl")
SWEP.WorldModel = ""

SWEP.Range = 4 * GetConVarNumber("sk_vortigaunt_zap_range", 100) -- because it's in feet,we convert it.
SWEP.DamageForce = 100000 -- 12000 is the force done by two vortigaunts claws zap attack
SWEP.HealAmount = 10 -- 12000 is the force done by two vortigaunts claws zap attack

SWEP.AmmoPerUse = 0 -- we use ar2 altfire ammo,don't exagerate here
SWEP.HealSound = Sound("NPC_Vortigaunt.SuitOn")
SWEP.HealLoop = Sound("NPC_Vortigaunt.StartHealLoop")
SWEP.AttackLoop = Sound("NPC_Vortigaunt.ZapPowerup")
SWEP.AttackSound = Sound("NPC_Vortigaunt.ClawBeam")
SWEP.HealDelay = 1 -- we heal again CurTime() + self.HealDelay
SWEP.MaxArmor = 40 -- used for the math.random
SWEP.MinArmor = 10
SWEP.ArmorLimit = 100 -- 100 is the default hl2 armor limit
SWEP.BeamDamage = 320 -- 25 is done by one zap attack,since vortigaunt has two claws,50 dmg,
-- 100 is the real damage,try to make a vortigaunt hate you,and if you have 100 hp,you will be oneshotted
SWEP.BeamChargeTime = 1.25 -- the delay used to charge the beam and zap!
SWEP.Deny = Sound("Buttons.snd19")
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0 -- give the poor user 25 combine balls to have fun with this wepon
SWEP.Primary.Ammo = "AR2AltFire"
SWEP.Primary.Automatic = true
SWEP.NextUse = 0

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = false
SWEP.Secondary.Automatic = true

PrecacheParticleSystem("vortigaunt_beam") -- the zap beam
--PrecacheParticleSystem("vortigaunt_beam_charge") -- the glow particles
PrecacheParticleSystem("vortigaunt_charge_token")
PrecacheParticleSystem("vortigaunt_charge_token_b")
PrecacheParticleSystem("vortigaunt_charge_token_c")

function SWEP:Initialize()
	self.Charging = false -- we are not charging!
	self.Healing = false -- we are not healing!
	self.HealTime = CurTime() -- we can heal
	self.ChargeTime = CurTime() -- we can zap
	self:SetHoldType("slam") -- this is the better holdtype i could find,well,it fits its job
	if CLIENT then return end
	self:CreateSounds() -- create the looping sounds
end

function SWEP:CreateSounds()
	if not self.ChargeSound then self.ChargeSound = CreateSound(self, self.AttackLoop) end
	if not self.HealingSound then self.HealingSound = CreateSound(self, self.HealLoop) end
end

function SWEP:DispatchEffect(EFFECTSTR)
	local pPlayer = self:GetOwner()
	if not pPlayer then return end
	local view
	if CLIENT then
		view = GetViewEntity()
	else
		view = pPlayer:GetViewEntity()
	end

	if not pPlayer:IsNPC() and view:IsPlayer() then
		ParticleEffectAttach(EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer:GetViewModel(), pPlayer:GetViewModel():LookupAttachment("muzzle"))
	else
		ParticleEffectAttach(EFFECTSTR, PATTACH_POINT_FOLLOW, pPlayer, pPlayer:LookupAttachment("anim_attachment_rh"))
	end
end

function SWEP:ShootEffect(EFFECTSTR, startpos, endpos)
	local pPlayer = self:GetOwner()
	if not pPlayer then return end
	local view
	if CLIENT then
		view = GetViewEntity()
	else
		view = pPlayer:GetViewEntity()
	end

	if (not pPlayer:IsNPC() and view:IsPlayer()) and self:GetAttachment(self:LookupAttachment("muzzle")) then
		util.ParticleTracerEx(EFFECTSTR, self:GetAttachment(self:LookupAttachment("muzzle")).Pos, endpos, true, pPlayer:GetViewModel():EntIndex(), pPlayer:GetViewModel():LookupAttachment("muzzle"))
	else
		util.ParticleTracerEx(EFFECTSTR, pPlayer:GetAttachment(pPlayer:LookupAttachment("anim_attachment_rh")).Pos, endpos, true, pPlayer:EntIndex(), pPlayer:LookupAttachment("anim_attachment_rh"))
	end
end

function SWEP:ImpactEffect(traceHit)
	local data = EffectData()
	data:SetOrigin(traceHit.HitPos)
	data:SetNormal(traceHit.HitNormal)
	data:SetScale(20)
	util.Effect("StunstickImpact", data)
	local rand = math.random(1, 1.5)
	self:CreateBlast(rand, traceHit.HitPos)
	self:CreateBlast(rand, traceHit.HitPos)
	if SERVER and traceHit.Entity and IsValid(traceHit.Entity) and string.find(traceHit.Entity:GetClass(), "ragdoll") then
		traceHit.Entity:Fire("StartRagdollBoogie")
		--[[
		local boog=ents.Create("env_ragdoll_boogie")
		boog:SetPos(traceHit.Entity:GetPos())
		boog:SetParent(traceHit.Entity)
		boog:Spawn()
		boog:SetParent(traceHit.Entity)
		]]
	end
end

function SWEP:CreateBlast(scale, pos)
	if CLIENT then return end
	local blastspr = ents.Create("env_sprite")
	blastspr:SetPos(pos)
	blastspr:SetKeyValue("model", "sprites/vortring1.vmt")
	blastspr:SetKeyValue("scale", tostring(scale))
	blastspr:SetKeyValue("framerate", 60)
	blastspr:SetKeyValue("spawnflags", "1")
	blastspr:SetKeyValue("brightness", "255")
	blastspr:SetKeyValue("angles", "0 0 0")
	blastspr:SetKeyValue("rendermode", "9")
	blastspr:SetKeyValue("renderamt", "255")
	blastspr:Spawn()
	blastspr:Fire("kill", "", 0.45)
end

local traceres = {}
local trace = {
	start = Vector(),
	endpos = Vector(),
	maxs = Vector(4, 4, 4),
	mins = Vector(-4, -4, -4),
	mask = MASK_SHOT_PORTAL,
	filter = {NULL, "forcefields"},
	output = traceres
}

function SWEP:Shoot(dmg, effect)
	local pPlayer = self:GetOwner()
	if not pPlayer then return end
	if self.OldRunSpeed then
		pPlayer:SetRunSpeed(self.OldRunSpeed)
		self.OldRunSpeed = nil
	end

	if self.OldWalkSpeed then
		pPlayer:SetWalkSpeed(self.OldWalkSpeed)
		self.OldWalkSpeed = nil
	end

	trace.start = pPlayer:EyePos()
	trace.endpos = trace.start + pPlayer:EyeAngles():Forward() * self.Range
	trace.filter[1] = pPlayer
	-- so you can't just snipe with the long range of 16384 game units
	util.TraceHull(trace)
	self:ShootEffect(effect or "vortigaunt_beam", trace.start, traceres.HitPos)
	if SERVER and IsValid(traceres.Entity) then
		if traceres.Entity:IsPlayer() and (traceres.Entity:isOTA() or traceres.Entity:Team() == TEAM_GORDON) then
			traceres.Entity.oldarm = math.Clamp(traceres.Entity:Armor() + math.random(1, 25), 0, traceres.Entity:GetMaxArmor())
			traceres.Entity:SetLocalVar("PowerLevel", 10)
		end

		local DMG = DamageInfo()
		DMG:SetDamageType(DMG_SHOCK)
		DMG:SetDamage(dmg or self.BeamDamage)
		DMG:SetAttacker(pPlayer)
		DMG:SetInflictor(self)
		DMG:SetDamagePosition(traceres.HitPos)
		DMG:SetDamageForce(traceres.Normal * self.DamageForce)
		traceres.Entity:TakeDamageInfo(DMG)
		if traceres.Entity.oldarm then
			traceres.Entity:SetArmor(traceres.Entity.oldarm)
			traceres.Entity.oldarm = nil
		end
	end

	pPlayer:GetViewModel():EmitSound(self.AttackSound)
	self:ImpactEffect(traceres)
end

function SWEP:Holster(wep)
	self:StopEveryThing()
	return true
end

function SWEP:OnRemove()
	self:StopEveryThing()
end

function SWEP:StopEveryThing()
	self.Charging = false
	if SERVER and self.ChargeSound then self.ChargeSound:Stop() end

	self.Healing = false
	if SERVER and self.HealingSound then self.HealingSound:Stop() end

	local pPlayer = self.LastOwner
	if not IsValid(pPlayer) then return end
	if self.OldRunSpeed then
		pPlayer:SetRunSpeed(self.OldRunSpeed)
		self.OldRunSpeed = nil
	end

	if self.OldWalkSpeed then
		pPlayer:SetWalkSpeed(self.OldWalkSpeed)
		self.OldWalkSpeed = nil
	end

	if not pPlayer:GetViewModel() then return end
	if CLIENT and pPlayer == LocalPlayer() then pPlayer:GetViewModel():StopParticles() end
	pPlayer:StopParticles()
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self:SetDeploySpeed(1)
	return true
end

function SWEP:Think()
	local pPlayer = self:GetOwner()
	if pPlayer and IsValid(pPlayer) then self.LastOwner = pPlayer end
	-- i send the weapon animation before the actual shooting because the gravity gloves attack is delayed...
	if self.Charging and self.ChargeTime - 0.25 < CurTime() and not self.attack then
		if pPlayer:GetAmmoCount(self.Primary.Ammo) >= self.AmmoPerUse then
			self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
			self:DispatchEffect("vortigaunt_charge_token") -- this effect lags a lot,but we see it for 0.75 seconds,who cares
			-- pPlayer:SetAnimation(PLAYER_ATTACK1)	-- todo:sincronize the world model player attack
			-- and,send the idle animation
			timer.Simple(0.75, function()
				if not IsValid(self) then return end
				local owner = self:GetOwner()
				if not IsValid(owner) or not owner:Alive() or owner:GetActiveWeapon() ~= self then
					if self.ChargeSound and IsValid(self.ChargeSound) then self.ChargeSound:Stop() end
					return
				end

				self:SendWeaponAnim(ACT_VM_IDLE)
			end)
		end

		self.attack = true
	end

	if self.Charging and self.ChargeTime < CurTime() then
		if pPlayer:GetAmmoCount(self.Primary.Ammo) < self.AmmoPerUse then
			-- what the hell? something stole my ammo!
			-- self:EmitSound(self.Deny)
			local nx = CurTime() + SoundDuration(self.Deny) + 1
			self:SetNextPrimaryFire(nx)
			self:SetNextSecondaryFire(nx)
			if IsValid(pPlayer:GetViewModel()) then pPlayer:GetViewModel():StopParticles() end
			pPlayer:StopParticles()
			self.Charging = false
			self:SendWeaponAnim(ACT_VM_IDLE)
			if SERVER and self.ChargeSound then self.ChargeSound:Stop() end
			return
		end

		pPlayer:RemoveAmmo(self.AmmoPerUse, self.Primary.Ammo)
		if IsValid(pPlayer:GetViewModel()) then pPlayer:GetViewModel():StopParticles() end
		pPlayer:StopParticles()
		self:Shoot()
		self.Charging = false
		self.attack = false

		if SERVER and self.ChargeSound then self.ChargeSound:Stop() end

		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 1)
	end

	if self.Healing and self.HealTime < CurTime() then
		if pPlayer:GetAmmoCount(self.Primary.Ammo) < self.AmmoPerUse or pPlayer:Armor() >= pPlayer:GetMaxArmor() and pPlayer:Health() >= pPlayer:GetMaxHealth() then
			--self:EmitSound(self.Deny)
			local nx = CurTime() + SoundDuration(self.Deny) + 1
			self:SetNextPrimaryFire(nx)
			self:SetNextSecondaryFire(nx)
			if IsValid(pPlayer:GetViewModel()) then pPlayer:GetViewModel():StopParticles() end
			pPlayer:StopParticles()
			self.Healing = false
			self:SendWeaponAnim(ACT_VM_IDLE)
			if SERVER and self.HealingSound then self.HealingSound:Stop() end
			return
		end

		pPlayer:RemoveAmmo(self.AmmoPerUse, self.Primary.Ammo)

		if IsValid(pPlayer:GetViewModel()) then pPlayer:GetViewModel():StopParticles() end
		pPlayer:StopParticles()
		self:SendWeaponAnim(ACT_VM_IDLE)
		self.Healing = false
		pPlayer:EmitSound(self.HealSound)

		if SERVER and self.HealingSound then self.HealingSound:Stop() end

		self:GiveArmor()
		self:SetNextPrimaryFire(CurTime() + 1)
		self:SetNextSecondaryFire(CurTime() + 1)
	end
end

function SWEP:GiveArmor()
	if CLIENT then return end
	local pPlayer = self:GetOwner()
	local arm = math.random(self.MinArmor, self.MaxArmor)
	local parm, pmax, php, mhp = pPlayer:Armor(), pPlayer:GetMaxArmor(), pPlayer:Health(), pPlayer:GetMaxHealth()
	if parm >= pmax and php >= mhp then return end
	pPlayer:SetArmor(math.Clamp(parm + arm, 0, pmax))
	pPlayer:SetHealth(math.Clamp(php + arm, 0, mhp))
end

function SWEP:PrimaryAttack()
	if not IsFirstTimePredicted() then return end
	self:SetWeaponHoldType("slam")
	if self.Charging or self.Healing then return end
	local pPlayer = self:GetOwner()
	if pPlayer:GetAmmoCount(self.Primary.Ammo) < self.AmmoPerUse then
		--self:EmitSound(self.Deny)
		local nx = CurTime() + SoundDuration(self.Deny)
		self:SetNextPrimaryFire(nx)
		self:SetNextSecondaryFire(nx)
		return
	end

	self:DispatchEffect("vortigaunt_charge_token_b")
	self:DispatchEffect("vortigaunt_charge_token_c")
	self.ChargeTime = CurTime() + self.BeamChargeTime
	self.attack = false
	self.Charging = true
	self:SendWeaponAnim(ACT_VM_RELOAD)
	self.OldRunSpeed = self.OldRunSpeed or pPlayer:GetRunSpeed()
	self.OldWalkSpeed = self.OldWalkSpeed or pPlayer:GetWalkSpeed()
	pPlayer:SetRunSpeed(120)
	pPlayer:SetWalkSpeed(100)
	--[[
		self:ShootEffect("vortigaunt_beam_charge",pPlayer:EyePos()pPlayer:GetPos()+Vector(0,32,0))
		self:ShootEffect("vortigaunt_beam_charge",pPlayer:EyePos(),pPlayer:GetPos()+Vector(0,-32,0))
		self:ShootEffect("vortigaunt_beam_charge",pPlayer:EyePos(),pPlayer:GetPos()+Vector(32,0,0))
		self:ShootEffect("vortigaunt_beam_charge",pPlayer:EyePos(),pPlayer:GetPos()+Vector(-32,0,0))
	]]
	if SERVER and self.ChargeSound then self.ChargeSound:PlayEx(100, 150) end
	self:SetNextPrimaryFire(CurTime() + 3)
	self:SetNextSecondaryFire(CurTime() + 3)
end

function SWEP:SecondaryAttack()
	if not IsFirstTimePredicted() then return end
	local pPlayer = self:GetOwner()
	if self.Charging or self.Healing or pPlayer:Armor() >= self.ArmorLimit then return end
	if pPlayer:GetAmmoCount(self.Primary.Ammo) < self.AmmoPerUse then
		--self:EmitSound(self.Deny)
		local nx = CurTime() + SoundDuration(self.Deny)
		self:SetNextPrimaryFire(nx)
		self:SetNextSecondaryFire(nx)
		return
	end

	self.HealTime = CurTime() + self.HealDelay
	self.Healing = true
	self:DispatchEffect("vortigaunt_charge_token")
	self:SendWeaponAnim(ACT_VM_RELOAD)
	if SERVER and self.HealingSound then self.HealingSound:PlayEx(100, 150) end
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Reload()
	if not IsFirstTimePredicted() then return end
	if self:GetNextPrimaryFire() > CurTime() then return end
	local pPlayer = self:GetOwner()
	local tr = util.TraceLine({
		start = pPlayer:GetShootPos(),
		endpos = pPlayer:GetShootPos() + pPlayer:GetAimVector() * 64,
		filter = pPlayer
	})


	local ent = tr.Entity
	if not SERVER or not IsValid(ent) then return end
	if not ent:IsPlayer() then return end

	local rnd = math.random(1, 25)
	--self:EmitSound("npc/vort/health_charge.wav")
	self:DispatchEffect("vortigaunt_charge_token")
	if SERVER and self.HealingSound then self.HealingSound:PlayEx(100, 150) end

	self:SetNextPrimaryFire(CurTime() + 3)
	self:SetNextSecondaryFire(CurTime() + 3)
	self:SendWeaponAnim(ACT_VM_RELOAD)
	timer.Create("stop", 1, 1, function()
		if not IsValid(self) then return end
		self:SendWeaponAnim(ACT_VM_DRAW)
		self:StopEveryThing()
		if not IsValid(ent) or not ent:Alive() then return end
		if ent:Health() >= ent:GetMaxHealth() then
			--self:EmitSound(self.Deny)
		else
			self:EmitSound(self.HealSound)
			ent:SetHealth(math.Clamp(ent:Health() + rnd, 0, ent:GetMaxHealth()))
		end
	end)
end
