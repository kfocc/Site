local vector_origin = Vector()
local math = math

EFFECT.Life = 0.1
EFFECT.XFlashSize = 1
EFFECT.FlashSize = 1
EFFECT.SmokeSize = 1
EFFECT.SparkSize = 1
EFFECT.HeatSize = 1
EFFECT.Color = Color(255, 192, 64)
EFFECT.ColorSprites = false

local AddVel = Vector()
local ang

function EFFECT:Init(data)
	local ent = data:GetEntity()
	local tbl = self:GetTable()
	tbl.WeaponEnt = ent
	if not IsValid(ent) then return end
	local att = data:GetAttachment()
	tbl.Attachment = att
	local pos = self:GetTracerShootPos(data:GetOrigin(), ent, att)
	tbl.Position = pos

	local ownerent = ent:GetOwner()
	if IsValid(ownerent) then
		if ownerent == LocalPlayer() then
			if ownerent:ShouldDrawLocalPlayer() then
				ang = ownerent:EyeAngles()
				ang:Normalize()
				--ang.p = math.max(math.min(ang.p,55),-55)
				tbl.Forward = ang:Forward()
			else
				ent = ownerent:GetViewModel()
			end
			--ang.p = math.max(math.min(ang.p,55),-55)
		else
			ang = ownerent:EyeAngles()
			ang:Normalize()
			tbl.Forward = ang:Forward()
		end
	else
		ownerent = LocalPlayer()
	end

	tbl.Forward = tbl.Forward or data:GetNormal()
	tbl.Angle = tbl.Forward:Angle()
	tbl.Right = tbl.Angle:Right()
	tbl.vOffset = tbl.Position
	local dir = tbl.Forward

	AddVel = ownerent:GetVelocity()
	tbl.vOffset = tbl.Position
	AddVel = AddVel * 0.05
	local dot = dir:GetNormalized():Dot(GetViewEntity():EyeAngles():Forward())
	local halofac = math.abs(dot)
	local epos = ownerent:EyePos()
	local dlight = DynamicLight(ownerent:EntIndex())

	if (dlight) then
		dlight.pos = epos + ownerent:EyeAngles():Forward() * tbl.vOffset:Distance(epos) --tbl.vOffset - ownerent:EyeAngles():Right() * 5 + 1.05 * ownerent:GetVelocity() * FrameTime()
		dlight.r = tbl.Color.r
		dlight.g = tbl.Color.g
		dlight.b = tbl.Color.b
		dlight.brightness = 4.5
		dlight.decay = 200 / tbl.Life
		dlight.size = tbl.FlashSize * 96
		dlight.dietime = CurTime() + tbl.Life
	end

	tbl.Dist = tbl.vOffset:Distance(epos)
	tbl.DLight = dlight
	tbl.DieTime = CurTime() + tbl.Life
	tbl.OwnerEnt = ownerent
	local emitter = ParticleEmitter(tbl.vOffset)
	local sval = 1 - math.random(0, 1) * 2

	if ent.XTick == nil then
		ent.XTick = 0
	end

	ent.XTick = 1 - ent.XTick

	if ent.XTick == 1 and tbl.XFlashSize > 0 then
		local particle = emitter:Add(tbl.ColorSprites and "effects/muzzleflashx_nemole_w" or "effects/muzzleflashx_nemole", tbl.vOffset + FrameTime() * AddVel)

		if (particle) then
			particle:SetVelocity(dir * 4 * tbl.XFlashSize)
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life / 2)
			particle:SetStartAlpha(math.Rand(200, 255))
			particle:SetEndAlpha(0)
			--particle:SetStartSize( 8 * (halofac*0.8+0.2), 0, 1)
			--particle:SetEndSize( 0 )
			particle:SetStartSize(3 * (halofac * 0.8 + 0.2) * tbl.XFlashSize)
			particle:SetEndSize(15 * (halofac * 0.8 + 0.2) * tbl.XFlashSize)
			local r = math.Rand(-10, 10) * 3.14 / 180
			particle:SetRoll(r)
			particle:SetRollDelta(r / 5)

			if tbl.ColorSprites then
				particle:SetColor(tbl.Color.r, tbl.Color.g, tbl.Color.b)
			else
				particle:SetColor(255, 255, 255)
			end

			particle:SetLighting(false)
			particle.FollowEnt = ent
			particle.Att = att
			TFA.Particles.RegisterParticleThink(particle, TFA.Particles.FollowMuzzle)
			particle:SetPos(vector_origin)
		end
		--particle:SetStartSize( 8 * (halofac*0.8+0.2), 0, 1)
		--particle:SetEndSize( 0 )
	elseif tbl.XFlashSize > 0 then
		local particle = emitter:Add(tbl.ColorSprites and "effects/muzzleflashx_nemole_w" or "effects/muzzleflashx_nemole", tbl.vOffset + FrameTime() * AddVel)

		if (particle) then
			particle:SetVelocity(dir * 4 * tbl.FlashSize)
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life / 2)
			particle:SetStartAlpha(math.Rand(200, 255))
			particle:SetEndAlpha(0)
			particle:SetStartSize(2 * (halofac * 0.8 + 0.2) * 0.3 * tbl.FlashSize)
			particle:SetEndSize(6 * (halofac * 0.8 + 0.2) * 0.3 * tbl.FlashSize)
			local r = math.Rand(-10, 10) * 3.14 / 180
			particle:SetRoll(r)
			particle:SetRollDelta(r / 5)

			if tbl.ColorSprites then
				particle:SetColor(tbl.Color.r, tbl.Color.g, tbl.Color.b)
			else
				particle:SetColor(255, 255, 255)
			end

			particle:SetLighting(false)
			particle.FollowEnt = ent
			particle.Att = att
			TFA.Particles.RegisterParticleThink(particle, TFA.Particles.FollowMuzzle)
			particle:SetPos(vector_origin)
		end
	end

	local flashCount = math.Round(tbl.FlashSize * 8)

	for i = 1, flashCount do
		local particle = emitter:Add(tbl.ColorSprites and "effects/scotchmuzzleflashw" or "effects/scotchmuzzleflash4", tbl.vOffset + FrameTime() * AddVel)

		if (particle) then
			particle:SetVelocity(dir * 300 * (0.2 + (i / flashCount) * 0.8) * tbl.FlashSize)
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life * 0.75)
			particle:SetStartAlpha(math.Rand(128, 255))
			particle:SetEndAlpha(0)
			--particle:SetStartSize( 7.5 * (halofac*0.8+0.2), 0, 1)
			--particle:SetEndSize( 0 )
			local szsc = 1 + (flashCount - i) * math.pow(1 / flashCount * 0.9,0.8)
			particle:SetStartSize(1.25 * math.Rand(1, 1.5) * szsc * tbl.FlashSize)
			particle:SetEndSize(6 * math.Rand(0.75, 1) * szsc * tbl.FlashSize)
			particle:SetRoll(math.rad(math.Rand(0, 360)))
			particle:SetRollDelta(math.rad(math.Rand(15, 30)) * sval)

			if tbl.ColorSprites then
				particle:SetColor(tbl.Color.r, tbl.Color.g, tbl.Color.b)
			else
				particle:SetColor(255, 255, 255)
			end

			particle:SetLighting(false)
			particle.FollowEnt = ent
			particle.Att = att
			TFA.Particles.RegisterParticleThink(particle, TFA.Particles.FollowMuzzle)
		end
	end

	for _ = 1, flashCount do
		local particle = emitter:Add("effects/scotchmuzzleflash1", tbl.vOffset + FrameTime() * AddVel)

		if (particle) then
			particle:SetVelocity(dir * 6 * tbl.FlashSize + 1.05 * AddVel)
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life * 1)
			particle:SetStartAlpha(math.Rand(40, 140))
			particle:SetEndAlpha(0)
			--particle:SetStartSize( 7.5 * (halofac*0.8+0.2), 0, 1)
			--particle:SetEndSize( 0 )
			particle:SetStartSize(2 * math.Rand(1, 1.5) * tbl.FlashSize)
			particle:SetEndSize(20 * math.Rand(0.5, 1) * tbl.FlashSize)
			particle:SetRoll(math.rad(math.Rand(0, 360)))
			particle:SetRollDelta(math.rad(math.Rand(30, 60)) * sval)

			if tbl.ColorSprites then
				particle:SetColor(tbl.Color.r, tbl.Color.g, tbl.Color.b)
			else
				particle:SetColor(255, 255, 255)
			end

			particle:SetLighting(false)
			particle.FollowEnt = ent
			particle.Att = att
			--TFA.Particles.RegisterParticleThink(particle, TFA.Particles.FollowMuzzle)
		end
	end

	local glowCount = math.ceil(tbl.FlashSize * 3)

	for i = 1, glowCount do
		local particle = emitter:Add("effects/scotchmuzzleflash1", tbl.vOffset + dir * 0.9 * i)

		if (particle) then
			--particle:SetVelocity(dir * 32 )
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life * 0.75)
			particle:SetStartAlpha(255 * (1 - halofac))
			particle:SetEndAlpha(0)
			--particle:SetStartSize( 7.5 * (halofac*0.8+0.2), 0, 1)
			--particle:SetEndSize( 0 )
			particle:SetStartSize(math.max(12 - 12 / glowCount * i * 0.5, 1) * 0.2 * tbl.FlashSize)
			particle:SetEndSize(math.max(12 - 12 / glowCount * i * 0.5, 1) * 0.6 * tbl.FlashSize)
			particle:SetRoll(math.rad(math.Rand(0, 360)))
			particle:SetRollDelta(math.rad(math.Rand(15, 30)) * sval)

			if tbl.ColorSprites then
				particle:SetColor(tbl.Color.r, tbl.Color.g, tbl.Color.b)
			else
				particle:SetColor(255, 255, 255)
			end

			particle:SetLighting(false)
			particle.FollowEnt = ent
			particle.Att = att
			TFA.Particles.RegisterParticleThink(particle, TFA.Particles.FollowMuzzle)
		end
	end

	if TFA.GetMZFSmokeEnabled() then
		local smokeCount = math.ceil(tbl.SmokeSize * 6)

		for _ = 0, smokeCount do
			local particle = emitter:Add("particles/smokey", tbl.vOffset + dir * math.Rand(3, 14))

			if (particle) then
				particle:SetVelocity(VectorRand() * 10 * tbl.SmokeSize + dir * math.Rand(35, 50) * tbl.SmokeSize + 1.05 * AddVel)
				particle:SetDieTime(math.Rand(0.6, 1) * tbl.Life * 6)
				particle:SetStartAlpha(math.Rand(12, 24))
				particle:SetEndAlpha(0)
				particle:SetStartSize(math.Rand(5, 7) * tbl.SmokeSize)
				particle:SetEndSize(math.Rand(15, 20) * tbl.SmokeSize)
				particle:SetRoll(math.rad(math.Rand(0, 360)))
				particle:SetRollDelta(math.Rand(-0.8, 0.8))
				particle:SetLighting(true)
				particle:SetAirResistance(20)
				particle:SetGravity(Vector(0, 0, 60))
				particle:SetColor(255, 255, 255)
			end
		end
	end

	local sparkcount = math.Round(math.random(8, 12) * tbl.SparkSize)

	for _ = 0, sparkcount do
		local particle = emitter:Add("effects/yellowflare", tbl.Position)

		if (particle) then
			particle:SetVelocity( VectorRand() * 30 * tbl.SparkSize)
			particle:SetVelocity(particle:GetVelocity() + 1.15 * AddVel )
			particle:SetVelocity( particle:GetVelocity() + dir * math.Rand(80, 100) * (1-math.abs(math.max(particle:GetVelocity():GetNormalized():Dot(-dir),0))) * tbl.SparkSize )
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life * math.Rand(0.9,1.1))
			particle:SetStartAlpha(255)
			particle:SetEndAlpha(0)
			particle:SetStartSize(0.6)
			particle:SetEndSize(1)
			particle:SetRoll(math.rad(math.Rand(0, 360)))
			particle:SetGravity(vector_origin)
			particle:SetAirResistance(1)
			particle:SetStartLength(0.1)
			particle:SetEndLength(0.05)

			if tbl.ColorSprites then
				particle:SetColor(tbl.Color.r, tbl.Color.g, tbl.Color.b)
			else
				particle:SetColor(255, math.random(192, 225), math.random(140, 192))
			end

			particle:SetVelocityScale(true)
			local sl = tbl.SparkSize

			particle:SetThinkFunction(function(pa)
				math.randomseed(SysTime())
				local spd = pa:GetVelocity():Length()*12
				pa.ranvel = pa.ranvel or VectorRand() * spd
				pa.ranvel:Add(VectorRand() * spd * math.sqrt(FrameTime()))
				pa:SetVelocity(pa:GetVelocity() + pa.ranvel * sl * FrameTime() )
				pa:SetNextThink(CurTime())
			end)

			particle:SetNextThink(CurTime() + 0.01)
		end
	end

	if TFA.GetGasEnabled() then
		local particle = emitter:Add("sprites/heatwave", tbl.vOffset + dir*2)

		if (particle) then
			particle:SetVelocity(dir * 25 * tbl.HeatSize + 1.05 * AddVel)
			particle:SetLifeTime(0)
			particle:SetDieTime(tbl.Life)
			particle:SetStartAlpha(math.Rand(200, 225))
			particle:SetEndAlpha(0)
			particle:SetStartSize(math.Rand(3, 5) * tbl.HeatSize)
			particle:SetEndSize(math.Rand(8, 12) * tbl.HeatSize)
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-2, 2))
			particle:SetAirResistance(5)
			particle:SetGravity(Vector(0, 0, 40))
			particle:SetColor(255, 255, 255)
		end
	end

	emitter:Finish()
end

function EFFECT:Think()
	if CurTime() > self.DieTime then
		return false
	elseif self.DLight and IsValid(self.OwnerEnt) then
		self.DLight.pos = self.OwnerEnt:EyePos() + self.OwnerEnt:EyeAngles():Forward() * self.Dist
	end

	return true
end

function EFFECT:Render()
end