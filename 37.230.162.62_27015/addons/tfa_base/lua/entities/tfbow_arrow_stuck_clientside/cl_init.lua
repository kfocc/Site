include("shared.lua")

function ENT:Draw(flags)
	if IsValid( self:GetParent() ) then
		self:GetParent():SetupBones()
	end
	self:SetupBones()
	self:DrawModel(flags)
end