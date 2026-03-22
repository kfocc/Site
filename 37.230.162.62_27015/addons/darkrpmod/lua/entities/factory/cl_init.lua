include("shared.lua")

surface.CreateFont("BCDispenserZavod", {
	font = "Roboto", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 22,
	weight = 500,
})

function ENT:Initialize()
end

local cols = Color(28, 134, 30, 255)
local color_primary = cols --Color(132, 192, 222)
local interfaceMaterial = Material("unionrp/ui/arrest/interface.jpg", "noclamp smooth")
function ENT:Draw(flags)
	self:DrawModel(flags)

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 90)

	if LocalPlayer():GetPos():Distance(Pos) < 200 then
		cam.Start3D2D(Pos + Ang:Up() * 45 - Ang:Right() * 25, Ang, 0.11)
		surface.SetDrawColor(220, 220, 220, 255)
		surface.SetMaterial(interfaceMaterial)
		surface.DrawTexturedRect(-120, -150, 220, 50)
		surface.SetDrawColor(col.ba)
		surface.DrawOutlinedRect(-120, -150, 220, 50, 2)
		surface.SetDrawColor(color_primary)
		surface.DrawRect(-115, -145, 210, 30)

		surface.SetDrawColor(col.ba)
		surface.DrawOutlinedRect(-115, -145, 210, 30, 3)

		surface.SetDrawColor(col.ba)
		surface.DrawRect(-115, -112, 210, 8)

		if self:GetWorking() then
			surface.SetDrawColor(col.o)
			surface.DrawRect(-114, -111, 208 * (1 - math.max(self:GetNextUse() + (self.WorkTime - self.ProcessTime) - CurTime(), 0) / self.WorkTime), 6)
		end

		draw.SimpleText("Проверка рациона", "BCDispenserZavod", -10, -142, colw, 1)
		cam.End3D2D()
	end
end

function ENT:Think()
end
