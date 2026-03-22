include("shared.lua")
-- local CurTime = CurTime
local LocalPlayer = LocalPlayer
-- local math_sin = math.sin
-- local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local vec = Vector(0, 0, 75)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

function ENT:Draw(flags)
	self:DrawModel(flags)

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if dist > 350 then return end

	color_white.a = 350 - dist
	color_black.a = 350 - dist

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	-- ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)

	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.25)
	draw_SimpleTextOutlined("Терминал транспортника", "DermaLarge", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end

netstream.Hook("Aliance.SendMeTo", function(ent)
	if IsValid(main_terminal_menu) then main_terminal_menu:Remove() end
	main_terminal_menu = vgui.Create("DPanel")
	main_terminal_menu:SetSize(600, 250)
	main_terminal_menu.Paint = function()
		draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), main_terminal_menu:GetTall(), col.ba)
		draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), 40, col.o)
		draw.RoundedBox(0, 0, 35, main_terminal_menu:GetWide(), 5, col.w)
	end

	local destinations = ent.destinations or {}
	local close_button = vgui.Create("MButton", main_terminal_menu)
	close_button:SetText("x")
	close_button:SetPos(main_terminal_menu:GetWide() - 30, 0)
	close_button:OnClick(function() main_terminal_menu:Remove() end)
	local logol = vgui.Create("DImage", main_terminal_menu)
	logol:SetImage("materials/union/logo.png")
	logol:SetSize(36, 36)
	logol:SetPos(0, 0)

	local face = vgui.Create("MLabel", main_terminal_menu)
	face:SetText("CMB.TRANSPORTER")
	face:SetPos(logol:GetWide() * 1.5, 0)
	face:SizeToContents()
	face:SetColor(col.w)

	local left = true
	local y = 80
	local max = #destinations
	for k, v in pairs(destinations) do
		local x = left and main_terminal_menu:GetWide() / 2 - 255 or main_terminal_menu:GetWide() / 2 + 40
		local but = vgui.Create("UButton", main_terminal_menu)
		but:SetFont("UButton")
		but:SetText(v.name)
		but:SetSound("UI/buttonrollover.wav")
		but:SetSize(215, 45)
		but:SetColor(col.w)
		but:SetBackgroundColor(col.ba)
		but:SetPos(x, y)
		but.DoClick = function(self) netstream.Start("Aliance.SendMeTo", ent, k) end
		if k == max then continue end
		y = not left and y + 80 or y
		left = not left
	end

	main_terminal_menu:SetSize(600, 75 + y)
	main_terminal_menu:Center()
	main_terminal_menu:MakePopup()
end)
