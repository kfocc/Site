include("shared.lua")
function ENT:Draw(flags)
	self:DrawModel(flags)
end

function ENT:OnRemove()
	local ed = EffectData()
	ed:SetEntity(self)
	util.Effect("entity_remove", ed, true, true)
end
