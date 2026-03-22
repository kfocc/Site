include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Draw(flags)
	self:DrawModel(flags)
end
