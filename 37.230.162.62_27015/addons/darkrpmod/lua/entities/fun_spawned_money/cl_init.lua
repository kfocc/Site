local surface_SetFont = surface.SetFont
local surface_GetTextSize = surface.GetTextSize
local cam_Start3D2D = cam.Start3D2D
local draw_WordBox = draw.WordBox
local cam_End3D2D = cam.End3D2D
local DarkRP_formatMoney = DarkRP.formatMoney
include("shared.lua")
local color_semired = Color(140, 0, 0, 100)
local color_white = Color(255, 255, 255)
function ENT:Draw(flags)
	self:DrawModel(flags)

	if self:GetModel() ~= "models/props/cs_assault/money.mdl" then return end
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	surface_SetFont("ChatFont")
	local text = DarkRP_formatMoney(self:GetAmount())
	local TextWidth = surface_GetTextSize(text)
	cam_Start3D2D(Pos + Ang:Up() * 0.82, Ang, 0.1)
		draw_WordBox(2, -TextWidth * 0.5, -10, text, "ChatFont", color_semired, color_white)
	cam_End3D2D()
	Ang:RotateAroundAxis(Ang:Right(), 180)
	cam_Start3D2D(Pos, Ang, 0.1)
		draw_WordBox(2, -TextWidth * 0.5, -10, text, "ChatFont", color_semired, color_white)
	cam_End3D2D()
end

function ENT:Think()
end
