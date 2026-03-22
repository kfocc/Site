local sprites = {"particle/smokesprites_0001", "particle/smokesprites_0002", "particle/smokesprites_0003", "particle/smokesprites_0004", "particle/smokesprites_0005", "particle/smokesprites_0006", "particle/smokesprites_0007", "particle/smokesprites_0008", "particle/smokesprites_0009", "particle/smokesprites_0010", "particle/smokesprites_0011", "particle/smokesprites_0012", "particle/smokesprites_0013", "particle/smokesprites_0014", "particle/smokesprites_0015", "particle/smokesprites_0016"}

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local em = ParticleEmitter( pos )

	for i = 1, 50 do
		local particle = em:Add(sprites[math.random(1, #sprites)], pos)

		if (particle) then
			particle:SetVelocity(VectorRand():GetNormalized() * math.Rand(300, 600))
			particle:SetRoll(math.Rand(0, 360))
			particle:SetRollDelta(math.Rand(-1, 1) / 5)
			particle:SetAirResistance(150)
			particle:SetCollide(true)
			particle:SetBounce(1)

			particle:SetDieTime(math.Rand(15, 25))

			particle:SetStartSize(math.Rand(100, 150))
			particle:SetEndSize(math.Rand(200, 250))

			particle:SetColor(150, 150, 150)
			particle:SetStartAlpha(math.Rand(100, 150))
			particle:SetEndAlpha(0)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end