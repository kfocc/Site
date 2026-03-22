include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Icon = Material("icon16/clock.png", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)
	self:SetSequence(6)
	local origin = self:GetPos()
	if LocalPlayer():GetPos():Distance(origin) >= 768 then return end
	if not nameplates then return end
	local name = self:GetUName()
	nameplates.DrawNPC(self, origin + Vector(0, 0, 75), LocalPlayer():GetAngles(), name, 256, col.w, "Стоит и ждёт чего-то", self.Icon)
end
