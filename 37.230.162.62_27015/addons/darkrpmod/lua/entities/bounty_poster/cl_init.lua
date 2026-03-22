include('shared.lua')
local font = "UnionRP.Bounty"
surface.CreateFont(font, {
	font = "Roboto",
	size = 25,
	weight = 1500,
	extended = true
})

local mat = Material("icon16/heart_delete.png", "nocull noclamp smooth")
local kill = Material("icon16/cut_red.png", "nocull noclamp smooth")
local money = Material("icon16/money_add.png", "nocull noclamp smooth")
local iconsize = 30
function ENT:DrawBounty(Pos, Ang)
	local target, price, description = self:GetNetVar("Bounty"), self:GetNetVar("BountyPrice", 0), self:GetNetVar("BountyDescription", "Нанести вред")
	if not IsValid(target) then return end
	local name, col = target:Name(), target:GetTeamColor()
	draw.SimpleText(name, font, 90, 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText("Требуется:", font, 90, 100, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText(description, font, 90, 120, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	draw.SimpleText("Нажмите E", font, 90, 180, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw.SimpleText("для выполнения", font, 90, 205, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(description == "Нанести вред" and mat or description == "Устранить" and kill or money)
	surface.DrawTexturedRect(90 - iconsize / 2, 270 - iconsize, iconsize, iconsize)
	draw.SimpleText(DarkRP.formatMoney(price), font, 90, 270, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT)
end

function ENT:Draw(flags)
	self:DrawModel(flags)
end

function ENT:DrawTranslucent()
	local Pos, Ang = self:GetPos() + self:GetRight() * 5 + self:GetUp() * 9 + self:GetForward() * .3, self:GetAngles()
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), -90)
	cam.Start3D2D(Pos, Ang, .06)
	self:DrawBounty(Pos, Ang)
	cam.End3D2D()
end

netstream.Hook("Bounty.Verify", function(target, price, description)
	if IsValid(main_terminal_menu) then main_terminal_menu:Remove() end
	local name = target:Name()
	local text = "Вы точно желаете выполнить заказ на " .. name .. "?" .. "\n" .. "Детали: " .. description .. "\n" .. "За это вы получите " .. DarkRP.formatMoney(price)
	main_terminal_menu = vgui.Create("DPanel")
	main_terminal_menu:SetSize(600, 180)
	main_terminal_menu:Center()
	main_terminal_menu:MakePopup()
	main_terminal_menu.Paint = function()
		draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), main_terminal_menu:GetTall(), col.ba)
		draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), 40, col.o)
		draw.RoundedBox(0, 0, 35, main_terminal_menu:GetWide(), 5, col.w)
	end

	local close_button = vgui.Create("MButton", main_terminal_menu)
	close_button:SetText("x")
	close_button:SetPos(main_terminal_menu:GetWide() - 30, 0)
	close_button:OnClick(function() main_terminal_menu:Remove() end)

	local logol = vgui.Create("DImage", main_terminal_menu)
	logol:SetImage("materials/union/logo.png")
	logol:SetSize(36, 36)
	logol:SetPos(0, 0)

	local face = vgui.Create("MLabel", main_terminal_menu)
	face:SetText(text)
	face:SetPos(logol:GetWide(), logol:GetTall() + 10)
	face:SizeToContents()
	face:SetColor(col.w)
	face:SetFont("ChatFont")

	local w = main_terminal_menu:GetWide()
	local apply = vgui.Create("UButton", main_terminal_menu)
	apply:SetText("Подтвердить")
	apply:SetFont("ChatFont")
	apply:SetWide(w / 3)
	apply:SetPos(50, face:GetTall() + 10)
	apply.DoClick = function()
		netstream.Start("Bounty.Verify")
		main_terminal_menu:Remove()
	end

	local decline = vgui.Create("UButton", main_terminal_menu)
	decline:SetText("Отменить")
	decline:SetFont("ChatFont")
	decline:SetWide(w / 3)
	decline:SetPos(w - 50 - w / 3, face:GetTall() + 10)
	decline.DoClick = function() main_terminal_menu:Remove() end
end)
