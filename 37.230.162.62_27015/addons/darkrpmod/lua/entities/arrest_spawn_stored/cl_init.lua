local include = include
local surface = surface
local Color = Color
local Vector = Vector
local Angle = Angle
local Material = Material
local cam_Start3D2D = cam.Start3D2D
local CurTime = CurTime
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_drawGradientBox = surface.drawGradientBox
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText
local surface_CreateFont = surface.CreateFont
local cam_End3D2D = cam.End3D2D

include("shared.lua")

surface_CreateFont("arrestsystem.Main.Storage", {
	font = "Autodestruct BB",
	size = 35,
	weight = 500,
	extended = true,
})

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
end

local color_blue = Color(130, 145, 153)
local color_blue1 = color_blue:darken(150)
local vecOffset, angOffset = Vector(20.5, -19, 18.8), Angle(0, 90, 90)
local arrowDown = Material("icon16/arrow_down.png")
local maxDist = 500 ^ 2
function ENT:DrawTranslucent()
	local distance, lim = self:GetPos():DistToSqr(EyePos()), maxDist
	if distance > lim then return end

	local vec, ang = self:LocalToWorld(vecOffset), self:LocalToWorldAngles(angOffset)
	cam_Start3D2D(vec, ang, 0.1)
	local x = -250 + CurTime() * 100 % 100
	surface_SetDrawColor(color_white)
	surface_SetMaterial(arrowDown)
	surface_DrawTexturedRect(120, x, 128, 128)

	local w, h = 380, 100
	surface_drawGradientBox(0, 0, w, h, 1, color_blue, color_blue1)
	local bw = 3
	surface_SetDrawColor(col.ba)
	surface_DrawRect(0, 0, w, bw)
	surface_DrawRect(0, 0 + bw, bw, h - bw * 2)
	surface_DrawRect(0, 0 + h - bw, w, bw)
	surface_DrawRect(0 + w - bw + 1, 0, bw, h)

	draw_SimpleText("ГОТОВЫЕ ПРЕДМЕТЫ", "arrestsystem.Main.Storage", 186, 50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam_End3D2D()
end
