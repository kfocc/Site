DarkRP.Zones = DarkRP.Zones or {}

local font = "Union.ZoneFont"
surface.CreateFont(font, {
	font = "Inter",
	size = 30,
	weight = 500,
	shadow = true,
	extended = true,
})

local function DrawScrollingText(text, xxx, y, texwide, color)
	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)
	local x = math.fmod(CurTime() * 125, w) * -1
	color = color or Color(255, 255, 255, 255)
	while x < texwide do
		surface.SetTextColor(color)
		surface.SetTextPos(x + xxx, y)
		surface.DrawText(text)
		x = x + w
	end
end

local icon = Material("icon16/world.png")
local size = 230
local disabled = true
local text = "Неизвестно"
local zone_change_time = 0 -- Время когда игрок попал в зону
local animation_duration = 5 -- Длительность анимации в секундах
local animation_speed = 250 -- Скорость анимации

netstream.Hook("Zone.New", function(zone)
	if not IsValid(LocalPlayer()) then return end
	if zone == text or zone == "Неизвестно" then return end

	zone_change_time = CurTime()
	text = zone

	hook.Run("PlayerEnterZone", LocalPlayer(), zone)
end)

function DarkRP.Zones.GetStatus()
  return text, zone_change_time
end

local hud_enabled = CreateClientConVar("unionrp_zonehud", 1, true)
hook.Add("HUDPaint", "Zones.Hud", function()
  if not introPressed then return end
	local ret = hook.Call("HUDShouldDraw", GAMEMODE, "UnionHUD.Zones")
	if ret == false then return end

	local dt = CurTime() - zone_change_time
	if dt < 0 or dt > animation_duration then return end
	if not hud_enabled:GetBool() then return end
	local height = draw.GetFontHeight(font)
	local y = height
	local w, h = ScrW() / 2 + 310 - 120 - 12, ScrH()
	local moar_w = size - math.Clamp(dt < animation_duration / 2 and dt * animation_speed or (animation_duration - dt) * animation_speed, 0, size)

	surface.SetDrawColor(col.ba)

	surface.DrawRect(w - 310 + moar_w, y + 22, 265 - moar_w, 46)

	surface.SetDrawColor(col.o)
	surface.DrawRect(w - 310 + moar_w, y + 65, 15, 3)
	surface.DrawRect(w - 310 + moar_w, y + 55, 3, 12)

	surface.DrawRect(w - 310 + moar_w, y + 22, 15, 3)
	surface.DrawRect(w - 310 + moar_w, y + 24, 3, 12)

	surface.DrawRect(w - 60, y + 65, 15, 3)
	surface.DrawRect(w - 48, y + 55, 3, 12)

	surface.DrawRect(w - 60, y + 22, 15, 3)
	surface.DrawRect(w - 48, y + 24, 3, 12)

	render.SetScissorRect(w - 310 + moar_w, y + 22, w - 45, y + 68, true)
	surface.SetAlphaMultiplier(0.5)
	DrawScrollingText("///     " .. text .. "     ", w - 300, y + 30, 300, col.w)
	surface.SetAlphaMultiplier(1)
	render.SetScissorRect(0, 0, 0, 0, false)

	y = y + height + 25
end)
--[[

local laser = Material("effects/bluelaser1")

local dist = 5000

hook.Remove("PostDrawOpaqueRenderables", "Zones.Debug", function()
	local ply = LocalPlayer()
	local mypos = ply:GetPos()
	for k, v in pairs(DarkRP.Zones.List) do
		local pos1, pos2 = v.pos[1], v.pos[2]
		if pos1:Distance(mypos) > dist and pos2:Distance(mypos) > dist then continue end
		local mid = LerpVector(0.5, pos1, pos2)
		local ang = Angle(0, ply:GetAngles().y - 90, 90)
		cam.IgnoreZ(true)
		cam.Start3D2D(mid, ang, 1)
			draw.SimpleTextOutlined(v.name, "Point_Font", 0, 20, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(0, 0, 0))
		cam.End3D2D()
		cam.IgnoreZ(false)
		render.SetMaterial(laser)
		render.DrawWireframeBox(Vector(0, 0, 0), Angle(0, 0, 0), pos1, pos2, Color(255, 0, 0), false)
	end
end)

]]
