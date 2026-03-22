include("shared.lua")
function ENT:Initialize()
	self.Emitter = ParticleEmitter(self:GetPos(), false)
	self.t1 = 0
	self.t2 = 0
	self.t3 = 0
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end

local fireParticle = "particles/fire1"
local fireEmbers = {"effects/fire_embers1", "effects/fire_embers2", "effects/fire_embers3"}
local smokeParticles = {}
for i = 1, 9 do
	smokeParticles[i] = "particle/smokesprites_000" .. i
end

smokeParticles[10] = "particle/smokesprites_0015"
local math_random, math_Rand = math.random, math.Rand
function ENT:Think()
	if not self:GetActive() or self:IsDormant() then return end
	local oldPos = self.particlesPos or 10
	local curTime = CurTime()
	if self.t2 <= curTime then
		self.t2 = curTime + 0.5
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.pos = self:LocalToWorld(Vector(math_random(-5, 5), math_random(-5, 5), 10))
			dlight.r = 255
			dlight.g = math_random(50, 100)
			dlight.b = 0
			dlight.brightness = 0.5
			dlight.Decay = 0
			dlight.Size = 256
			dlight.DieTime = self.t2
		end
	end

	if self.t1 <= curTime then
		self.t1 = curTime + math_Rand(0.1, 0.2)
		if not self.Emitter or not IsValid(self.Emitter) then self.Emitter = ParticleEmitter(self:GetPos(), false) end
		if self.t3 <= curTime then
			self.t3 = curTime + 1
			local pos = self:GetPos()
			local _, max = self:WorldSpaceAABB()
			local pX, pY = pos:Unpack()
			pos:SetUnpacked(pX, pY, max.z)
			self.particlesPos = self:WorldToLocal(pos).z
		end

		for i = 1, 10 do
			local p = self.Emitter:Add(fireParticle, self:LocalToWorld(Vector(math_random(-5, 5), math_random(-5, 5), oldPos + 10 + i * -2)))
			p:SetDieTime(math_Rand(0.5, 0.9))
			p:SetStartSize(math_random(10, 15))
			p:SetGravity(Vector(0, 0, 30))
			p:SetEndAlpha(0)
			p:SetVelocity(Vector(math_random(-4, 4), math_random(-4, 4), 60))
			p:SetRoll(math_random(360))
		end

		for i = 1, 4 do
			local smokeParticle = smokeParticles[math_random(1, 10)]
			local s = math_random(20, 30)
			local p = self.Emitter:Add(smokeParticle, self:LocalToWorld(Vector(math_random(-5, 5), math_random(-5, 5), oldPos + 30 + i * 2)))
			p:SetDieTime(math_Rand(0.5, 0.9) + s / 10)
			p:SetStartSize(math_random(5))
			p:SetEndSize(math_random(20, 35))
			p:SetGravity(Vector(0, 0, 0))
			p:SetStartAlpha(30)
			p:SetEndAlpha(0)
			p:SetColor(155, 155, 155)
			p:SetVelocity(Vector(math_random(-4, 4), math_random(-4, 4), 60))
			p:SetRoll(math_random(360))
		end

		local fireEmber = fireEmbers[math_random(1, 3)]
		local p = self.Emitter:Add(fireEmber, self:LocalToWorld(Vector(math_random(-15, 15), math_random(-15, 15), oldPos + 10)))
		p:SetDieTime(1)
		p:SetStartSize(math_random(1, 2))
		p:SetVelocity(Vector(math_random(-20, 20), math_random(-20, 20), math_random(50, 100)))
		p:SetAirResistance(20)
		p:SetEndAlpha(0)
		p:SetRoll(math_random(360))
	end
end
