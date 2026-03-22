include("shared.lua")
local colB = Color(15, 15, 15)
local pillMat = Material("icon16/pill_delete.png")
local unkMat = Material("icon16/zoom.png")
local vecOffset, angOffset = Vector(0, 0, 6), Angle(0, 90, 90)
local maxDist = 500 ^ 2
function ENT:Draw(flags)
	self:DrawModel(flags)

	local distance, lim = self:GetPos():DistToSqr(EyePos()), maxDist
	if distance > lim then return end

	local ply = LocalPlayer()
	local isRebel = ply:isRebel() and not ply:isOTA() and not ply:isVort()
	local name = isRebel and "Капсула с ядом" or "Неизвестные таблетки"
	local icon = isRebel and pillMat or unkMat
	local pos, ang = LocalToWorld(vecOffset, angOffset, self:GetPos(), self:GetAngles())
	ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	cam.Start3D2D(pos, ang, 0.25)
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(-5, -30, 16, 16)

	draw.SimpleText(name, "Items_Font", 0, -4, colB, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(name, "Items_Font", 0, -5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
