include("shared.lua")
function ENT:Initialize()
	self.csModel = ClientsideModel("models/items/hevsuit.mdl")
	local presentAngle = (CurTime() * 90) % 360
	self.csModel:SetPos(self:GetPos() + Vector(0, 0, 10))
	self.csModel:SetAngles(Angle(0, presentAngle, 0))
	self.csModel:AddEffects(EF_ITEM_BLINK)
end

function ENT:Draw(flags)
	self:DrawModel(flags)
	local ent = self.csModel
	if IsValid(ent) then
		local presentAngle = (CurTime() * 90) % 360
		ent:SetAngles(Angle(0, presentAngle, 0))
	end
end

function ENT:OnRemove()
	if IsValid(self.csModel) then self.csModel:Remove() end
end
