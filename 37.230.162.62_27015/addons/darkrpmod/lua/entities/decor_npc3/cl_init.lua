include("shared.lua")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(89)
end
