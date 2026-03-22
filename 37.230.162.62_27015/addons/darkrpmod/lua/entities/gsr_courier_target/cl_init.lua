include("shared.lua")
local color_white = color_white
local color_black = color_black
function ENT:Draw(flags)
	self:DrawModel(flags)
	if LocalPlayer():GetEyeTrace().Entity == self and self:GetPos():Distance(LocalPlayer():GetPos()) < 150 then
		local ang = self:GetAngles()
		ang[2] = ang[2] + 90
		cam.Start3D2D(self:GetPos() + self:GetAngles():Up() * 4.3 - self:GetAngles():Right() * 1.4 - self:GetAngles():Forward() * 1.5, ang, 0.1)
		surface.SetDrawColor(col.ba)
		surface.DrawRect(-151, -37, 301, 45)
		draw.SimpleTextOutlined("Рационы", "BoxText", 0, -10, col.o, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		surface.SetDrawColor(0, 0, 0, 200)
		surface.DrawRect(-151, 25, 301, 152)
		draw.SimpleTextOutlined("На складе: " .. GetGlobalInt("Rac.Count.Transported", 0), "BoxText", 0, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Нажмите E для", "BoxText", 0, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("взаимодействия", "BoxText", 0, 120, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		cam.End3D2D()
	end
end

function ENT:Think()
	return
end
