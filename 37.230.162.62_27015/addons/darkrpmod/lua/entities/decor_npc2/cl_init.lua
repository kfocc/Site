include("shared.lua")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(self:LookupSequence("injured2"))
end
