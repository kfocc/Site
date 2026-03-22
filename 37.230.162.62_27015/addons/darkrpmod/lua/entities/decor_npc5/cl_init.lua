include("shared.lua")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(self:LookupSequence("sitccouchtv1"))
end
