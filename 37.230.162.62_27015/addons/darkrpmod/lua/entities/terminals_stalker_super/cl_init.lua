include("shared.lua")
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math_sin = math.sin
local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local vec = Vector(0, 0, 75)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)
function ENT:Draw(flags)
	self:DrawModel(flags)
	if self:GetNW2Int("FuckedUp") > CurTime() then return end
	if LocalPlayer():Team() ~= TEAM_STALKER then return end

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if dist > 350 then return end

	color_white.a = 350 - dist
	color_black.a = 350 - dist

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)

	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.25)
	draw_SimpleTextOutlined("Требуется ремонт", "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()

	ang:RotateAroundAxis(ang:Right(), 180)

	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.25)
	draw_SimpleTextOutlined("Требуется ремонт", "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end
