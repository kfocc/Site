include("shared.lua")
function ENT:Initialize()
	--self:AddInfoBox(self.PrintName or "Ошибка", function()
	--	return self.Instructions or "Ошибка"
	--end, 0.3)
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end

function ENT:OnRemove()
	--self:RemoveInfoBox()
end
