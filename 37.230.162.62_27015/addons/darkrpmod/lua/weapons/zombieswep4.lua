AddCSLuaFile()

SWEP.PrintName = "Ядовитые когти"
SWEP.Category = "Зомби"
SWEP.Author = "UnionRP"
SWEP.Instructions = "ЛКМ: Нанести удар\nПерезарядка: Злобно порычать"
SWEP.Purpose = ""

SWEP.Slot = 0
SWEP.SlotPos = 5

SWEP.Spawnable = true

SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo = false

SWEP.HitDistance = 78

SWEP.punchMin = 80
SWEP.punchMax = 100
SWEP.critMin = 120
SWEP.critMax = 140

SWEP.SwingSound = {Sound("npc/zombie_poison/pz_throw3.wav"), Sound("npc/zombie_poison/pz_throw2.wav")}
SWEP.HitSound = {Sound("npc/zombie/claw_strike1.wav"), Sound("npc/zombie/claw_strike2.wav"), Sound("npc/zombie/claw_strike3.wav")}
SWEP.RoarSound = {Sound("npc/zombie_poison/pz_warn2.wav"), Sound("npc/zombie_poison/pz_warn1.wav"), Sound("npc/zombie_poison/pz_pain3.wav"), Sound("npc/zombie_poison/pz_pain2.wav"), Sound("npc/zombie_poison/pz_pain1.wav"), Sound("npc/zombie_poison/pz_idle2.wav"), Sound("npc/zombie_poison/pz_call1.wav"), Sound("npc/zombie_poison/pz_alert2.wav"), Sound("npc/zombie_poison/pz_alert1.wav")}
local anim_zombie = {
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01,
	[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_02,
	[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE,
	[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
	[ACT_MP_RELOAD_STAND] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE
}

function SWEP:TranslateActivity(act)
	return anim_zombie[act] or act
end

function SWEP:Initialize()
	self:SetHoldType("fist")
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "NextMeleeAttack")
	self:NetworkVar("Float", 1, "NextIdle")
	self:NetworkVar("Int", 2, "Combo")
end

function SWEP:UpdateNextIdle()
	local vm = self:GetOwner():GetViewModel()
	self:SetNextIdle(CurTime() + vm:SequenceDuration())
end

function SWEP:PrimaryAttack(right)
	local owner = self:GetOwner()
	owner:SetAnimation(PLAYER_ATTACK1)
	local isCombo = self:GetCombo() >= 2
	local anim = isCombo and "fists_uppercut" or right and "fists_right" or "fists_left"
	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
	local swingSound = self.SwingSound
	self:EmitSound(swingSound[math.random(#swingSound)], 75)
	self:UpdateNextIdle()
	self:SetNextMeleeAttack(CurTime() + 0.1)
	self:SetNextPrimaryFire(CurTime() + 1.5)
	self:SetNextSecondaryFire(CurTime() + 1.5)
end

function SWEP:Reload()
	if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() then return end
	self:GetOwner():SetAnimation(PLAYER_RELOAD)
	self:SetNextPrimaryFire(CurTime() + 2)
	self:SetNextSecondaryFire(CurTime() + 2)
	local roarSound = self.RoarSound
	self:EmitSound(roarSound[math.random(#roarSound)], 75)
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack(true)
end

if SERVER then
	local calcDmgForce = {
		fists_left = function(owner) return owner:GetRight() * 4912 + owner:GetForward() * 9998 end,
		fists_right = function(owner) return owner:GetRight() * -4912 + owner:GetForward() * 9989 end,
		fists_uppercut = function(owner) return owner:GetUp() * 5158 + owner:GetForward() * 10012 end
	}

	local trLineOut = {}
	local cacheTraceLine = {
		mask = MASK_SHOT_HULL,
		output = trLineOut
	}

	local trHullOut = {}
	local cacheTraceHull = {
		mins = Vector(-10, -10, -8),
		maxs = Vector(10, 10, 8),
		mask = MASK_SHOT_HULL,
		output = trHullOut
	}

	local doorClass = {
		-- func_door = true,
		prop_door_rotating = true,
		func_door_rotating = true,
		combinedoor = true
	}

	function SWEP:DealDamage()
		local owner = self:GetOwner()
		local anim = self:GetSequenceName(owner:GetViewModel():GetSequence())
		owner:LagCompensation(true)
		local shootPos = owner:GetShootPos()
		local hitDist = owner:GetAimVector() * self.HitDistance
		cacheTraceLine.start = shootPos
		cacheTraceLine.endpos = shootPos + hitDist
		cacheTraceLine.filter = owner
		util.TraceLine(cacheTraceLine)
		local tr = trLineOut
		if not IsValid(tr.Entity) then
			cacheTraceHull.start = shootPos
			cacheTraceHull.endpos = shootPos + hitDist
			cacheTraceHull.filter = owner
			util.TraceHull(cacheTraceHull)
			tr = trHullOut
		end

		owner:LagCompensation(false)
		if tr.Hit then
			local hitSound = self.HitSound
			owner:EmitSound(hitSound[math.random(#hitSound)], 75)
			local customHitSound = self.CustomHitSound
			if customHitSound then owner:EmitSound(customHitSound[math.random(#customHitSound)], 75) end
		end

		local trEnt = tr.Entity
		if not IsValid(trEnt) then return end
		if trEnt:IsVehicle() then
			local driver = trEnt:GetDriver()
			if IsValid(driver) then trEnt = driver end
		end

		if trEnt:IsPlayer() or trEnt:IsNPC() or trEnt:Health() > 0 then
			local isCombo = anim == "fists_uppercut"
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(owner)
			dmginfo:SetInflictor(self)
			local randDamage = isCombo and math.random(self.critMin, self.critMax) or math.random(self.punchMin, self.punchMax)
			dmginfo:SetDamage(randDamage)
			dmginfo:SetDamageForce(calcDmgForce[anim](owner))
			trEnt:TakeDamageInfo(dmginfo)
			if not isCombo then
				self:SetCombo(self:GetCombo() + 1)
			else
				self:SetCombo(0)
			end
		end

		local phys = trEnt:GetPhysicsObject()
		if IsValid(phys) then phys:ApplyForceOffset(owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos) end
		local class = trEnt:GetClass()
		if doorClass[class] then
			if trEnt.lasthit and trEnt.lasthit >= CurTime() + 30 then trEnt.hits = 0 end
			trEnt.hits = (trEnt.hits or 0) + 1
			local rand = math.random(10, 15)
			if trEnt.hits >= rand then
				if class == "combinedoor" then
					timer.Simple(.1, function()
						trEnt:GrantAccess(owner)
						trEnt:EmitSound("buttons/combine_button1.wav")
						trEnt.fuckuse = CurTime() + 5
					end)

					local explodeeffect = EffectData()
					explodeeffect:SetOrigin(trEnt:GetPos())
					explodeeffect:SetStart(trEnt:GetPos())
					util.Effect("Explosion", explodeeffect, true, true)
				elseif class == "forcefields" then
					timer.Simple(.1, function() trEnt:Hack(owner) end)
				else
					trEnt:Fire("Unlock")
					trEnt:Fire("Open")
				end

				trEnt.hits = 0
			end

			trEnt.lasthit = CurTime()
		end
	end
end

function SWEP:Deploy()
	local owner = self:GetOwner()
	local vm = owner:GetViewModel()
	vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
	self:UpdateNextIdle()
	if SERVER then self:SetCombo(0) end
	local t = RPExtraTeams[owner:Team()]
	self.punchMin = t.punchMin or self.punchMin
	self.punchMax = t.punchMax or self.punchMax
	self.critMin = t.critMin or self.critMin
	self.critMax = t.critMax or self.critMax
	return true
end

function SWEP:Think()
	local vm = self:GetOwner():GetViewModel()
	local curtime = CurTime()
	local idletime = self:GetNextIdle()
	if idletime > 0 and curtime > idletime then
		vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))
		self:UpdateNextIdle()
	end

	local meleetime = self:GetNextMeleeAttack()
	if meleetime > 0 and curtime > meleetime then
		if SERVER then self:DealDamage() end
		self:SetNextMeleeAttack(0)
	end

	if SERVER and curtime > self:GetNextPrimaryFire() + 0.1 then self:SetCombo(0) end
end
