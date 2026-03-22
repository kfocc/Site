include("shared.lua")
surface.CreateFont("BDispenserZavod", {
	font = "Inter",
	size = 35,
	weight = 400,
	extended = true,
})

local drawDist = 570 * 570
local interfaceMaterial = Material("unionrp/ui/arrest/interface.jpg", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)

	if LocalPlayer():GetPos():DistToSqr(Pos) >= drawDist then return end

	cam.Start3D2D(Pos + Ang:Up() * 24, Ang, 0.11)

	surface.SetDrawColor(220, 220, 220, 255)
	surface.SetMaterial(interfaceMaterial)
	surface.DrawTexturedRect(-180, -150, 370, 100)
	surface.SetDrawColor(col.ba)
	surface.DrawOutlinedRect(-180, -150, 370, 100, 2)

	local text = self.DisplayName or "Выдача рационников"
	surface.SetFont("BDispenserZavod")
	local w, h = surface.GetTextSize(text)
	local x, y = 5 - w * 0.5, -100 - h * 0.5
	surface.drawGradientBox(-173, y - 15, 356, h + 30, 1, self.PrimaryColor, self.SecondaryColor)
	surface.SetDrawColor(col.ba)
	surface.DrawOutlinedRect(-173, y - 15, 356, h + 30, 3)

	surface.SetTextPos(x, y)
	surface.SetTextColor(255, 255, 255, 255)
	surface.DrawText(text)

	surface.SetDrawColor(col.ba)
	surface.DrawRect(-173, y + h + 15 + 3, 356, 8)

	if self:GetNextUse() > CurTime() then
		surface.SetDrawColor(col.o)
		surface.DrawRect(-172, y + h + 15 + 3 + 1, 354 * (1 - (self:GetNextUse() - CurTime()) / self.Delay), 6)
	end

	cam.End3D2D()
end
