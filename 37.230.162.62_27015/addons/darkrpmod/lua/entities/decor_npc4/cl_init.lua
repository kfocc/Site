include("shared.lua")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(self:LookupSequence("Lean_Back"))
end
