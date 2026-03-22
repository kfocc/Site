include("shared.lua")
surface.CreateFont("SDispenserZavod", {
	font = "Inter", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 20,
	weight = 100,
})

surface.CreateFont("SSDispenserZavod", {
	font = "Inter", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = true,
	size = 22,
	weight = 400,
})

local color_text = Color(125, 125, 200)
function ENT:Draw(flags)
	self:DrawModel(flags)
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	if LocalPlayer():GetPos():Distance(Pos) < 200 then
		Ang:RotateAroundAxis(Ang:Up(), Ang[1] < 0 and 180 or 0)
		Ang:RotateAroundAxis(Ang:Right(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 1.5, Ang, 0.1)
		surface.SetDrawColor(15, 15, 15, 200)
		surface.DrawRect(-67, -44, 132, 88)
		draw.SimpleTextOutlined(" Коробка ", "SDispenserZavod", -1, -39, col.o, TEXT_ALIGN_CENTER, nil, 1, color_black)
		draw.SimpleTextOutlined("Набор", "SSDispenserZavod", -1, -15, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black)
		draw.SimpleTextOutlined(self:GetReadyToSell() .. "/10", "SSDispenserZavod", -1, 9, color_text, TEXT_ALIGN_CENTER, nil, 1, color_black)
		cam.End3D2D()
	end
end
