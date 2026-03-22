include("shared.lua")

local ang = Angle(0, 0, 15)
local colb = Color(0, 0, 0, 200)
local dist = 150 * 150
function ENT:Draw(flags)
	self:DrawModel(flags)

	local lp = LocalPlayer()
	if lp:Team() ~= TEAM_GSR1 then return end
	if lp:GetEyeTrace().Entity ~= self then return end

	local entGetPos = self:GetPos()
	if entGetPos:DistToSqr(lp:GetPos()) > dist then return end

	ang.y = lp:EyeAngles().yaw - 90
	cam.Start3D2D(entGetPos + self:GetAngles():Up() * 10, ang, 0.1)
	surface.SetDrawColor(161, 161, 161, 200)
	surface.DrawRect(-150, -30, 300, 45)
	draw.SimpleTextOutlined("Мусор", "DermaLarge", 0, -10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	surface.SetDrawColor(colb)
	surface.DrawRect(-135, 25, 270, 120)
	draw.SimpleTextOutlined("Нажмите [" .. input.LookupBinding("+use") .. "]", "DermaLarge", 0, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	draw.SimpleTextOutlined("для", "DermaLarge", 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	draw.SimpleTextOutlined("сбора мусора", "DermaLarge", 0, 110, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	cam.End3D2D()
end
