include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)
end

function ENT:IsTranslucent()
	return true
end