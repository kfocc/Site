include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)
end

-- function ENT:DrawTranslucent()
-- 	self:Draw()
-- end

function ENT:Initialize()
	ParticleEffectAttach("zck_snowball_trail", PATTACH_POINT_FOLLOW, self, 0)
end

function ENT:OnRemove()
	self:EmitSound("zck_snowball_impact")
end