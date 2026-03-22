local include = include
local Color = Color
local Vector = Vector
local Angle = Angle
local cam_Start3D2D = cam.Start3D2D
local surface_SetDrawColor = surface.SetDrawColor
local surface = surface
local surface_DrawRect = surface.DrawRect
local draw_SimpleText = draw.SimpleText
local cam_End3D2D = cam.End3D2D
local util_Effect = util.Effect
local EffectData = EffectData

include("shared.lua")

function ENT:OnRemove()
	local ed = EffectData()
	ed:SetEntity(self)
	util_Effect("entity_remove", ed, true, true)
end

ENT.RenderGroup = RENDERGROUP_BOTH

local color_blue = Color(130, 145, 153)
local color_blue1 = color_blue:darken(150)
local vecOffset, angOffset = Vector(8.9, -11, 7), Angle(0, 90, 90)
local maxDist = 500 ^ 2
function ENT:DrawTranslucent()
	local distance, lim = self:GetPos():DistToSqr(EyePos()), maxDist
	if distance > lim then return end

	local vec, ang = self:LocalToWorld(vecOffset), self:LocalToWorldAngles(angOffset)

	cam_Start3D2D(vec, ang, 0.1)
	local w, h = 220, 60
	surface.drawGradientBox(0, 0, w, h, 1, color_blue, color_blue1)

	local bw = 3
	surface_SetDrawColor(col.ba)
	surface_DrawRect(0, 0, w, bw)
	surface_DrawRect(0, 0 + bw, bw, h - bw * 2)
	surface_DrawRect(0, 0 + h - bw, w, bw)
	surface_DrawRect(0 + w - bw + 1, 0, bw, h)

	local countItems, maxItems = self:GetItemCount(), 3
	draw_SimpleText(countItems .. " / " .. maxItems, "arrestsystem.Main.Storage", 110, 28, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam_End3D2D()
end
