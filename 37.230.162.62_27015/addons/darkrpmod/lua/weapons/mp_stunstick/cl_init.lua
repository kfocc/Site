include("shared.lua")
function SWEP:Reload()
	if (self.nextup or 0) > CurTime() then return end
	self.nextup = CurTime() + 1
	if self:GetActivated() then return end
	if IsValid(main_terminal_menu) then main_terminal_menu:Remove() end

	main_terminal_menu = vgui.Create("DPanel")
	main_terminal_menu:SetSize(600, 250)
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
	face:SetText("CMB.STUNSTICK #" .. LocalPlayer():GetID())
	face:SetPos(logol:GetWide() * 1.5, 0)
	face:SizeToContents()
	face:SetColor(col.w)

	local right, height = false, 80
	local w, h = 215, 45
	for num, tbl in pairs(self.Modes) do
		local x = right and main_terminal_menu:GetWide() / 2 + 40 or main_terminal_menu:GetWide() / 2 - 255
		local but = vgui.Create("UButton", main_terminal_menu)
		but:SetFont("UButton")
		but:SetText(tbl.name)
		but:SetSound("UI/buttonrollover.wav")
		but:SetSize(w, h)
		but:SetColor(col.w)
		but:SetBackgroundColor(col.ba)
		but:SetPos(x, height) -- main_terminal_menu:GetWide()/2+40,80 / main_terminal_menu:GetWide()/2-overlook:GetWide()-40,160
		but.DoClick = function(self)
			netstream.Start("Stunstick.ChangeMode", num)
			if IsValid(main_terminal_menu) then main_terminal_menu:Remove() end
		end

		if right then height = height + 80 end
		right = not right
	end
	return
end

local cur_power, damaged = 0, false
netstream.Hook("PainAndCrying", function(power)
	damaged = true
	cur_power = power
end)

local function HUDDamage()
	if not LocalPlayer().DamagedByCP then return end
	cur_power = cur_power - 1
	if cur_power == 0 then damaged = false end
	draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255, 255, 255, math.Clamp(cur_power, 0, 255)))
end
hook.Add("HUDPaint", "Stunstick.Pain", HUDDamage)
