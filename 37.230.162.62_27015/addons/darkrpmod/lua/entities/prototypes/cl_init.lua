include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/wrench.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(5)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), "Джостар", 256, col.w, "Мастер на все руки", self.Icon)
end
