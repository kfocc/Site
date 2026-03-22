include("shared.lua")
ENT.RenderGroup = RENDERGROUP_BOTH
local icons = {
	kills = Material("icon16/bug_edit.png", "no smooth"),
	place = Material("icon16/page_find.png", "no smooth"),
	time = Material("icon16/clock.png", "no smooth"),
	owner = Material("icon16/user_red.png", "no smooth"),
}

local color_black = Color(15, 15, 15)
local function drawShadowText(text, font, x, y, color, align1, align2)
	draw.SimpleText(text, font, x, y, color_black, align1, align2)
	draw.SimpleText(text, font, x - 1, y - 1, color, align1, align2)
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end

function ENT:DrawTranslucent()
	local distance, lim = self:GetPos():DistToSqr(EyePos()), 500 * 500
	if distance > lim then return end

	local zone = DarkRP.CPoints.points[self:GetPointID()]
	if not zone then return end

  local pos = LocalToWorld(Vector(0, 0, 45 + self:OBBMaxs().z), Angle(0, 90, 90), self:GetPos(), self:GetAngles())
  local ang = Angle(0, LocalPlayer():GetAngles().y - 90, 90)
	cam.Start3D2D(pos, ang, 0.25)
	local owner = zone.owner == "" and "Ничья" or zone.owner == "rebels" and "Повстанцы" or "Альянс"
	local kill1 = zone.kills.cp
	local kill2 = zone.kills.rebel
	local name = zone.name
	local endofcaptures = math.ceil(zone.endofcapture and zone.endofcapture > 0 and zone.endofcapture - CurTime() or 0)

	surface.SetDrawColor(255, 255, 255, 255)

	surface.SetMaterial(icons.place)
	surface.DrawTexturedRect(-125, 22, 16, 16)

	surface.SetMaterial(icons.owner)
	surface.DrawTexturedRect(-125, 52, 16, 16)

	drawShadowText("Точка: " .. name .. ".", "Point_Font", -100, 20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	drawShadowText("Под контролем: " .. owner .. ".", "Point_Font", -100, 50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	if zone.capture == true then
		surface.SetMaterial(icons.kills)
		surface.DrawTexturedRect(-125, 82, 16, 16)

		surface.SetMaterial(icons.time)
		surface.DrawTexturedRect(-125, 112, 16, 16)

		drawShadowText("Убийства (Повстанцы/Альянс): " .. kill2 .. "/" .. kill1 .. ".", "Point_Font", -100, 80,color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		drawShadowText("Времени осталось: " .. endofcaptures .. ".", "Point_Font", -100, 110, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	cam.End3D2D()
end