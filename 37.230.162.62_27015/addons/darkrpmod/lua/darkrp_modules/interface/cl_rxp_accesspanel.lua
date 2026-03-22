local sscale = util.SScale

local PANEL = {}

local dMenu
local function buildDMenu()
	if IsValid(dMenu) then dMenu:Remove() end

	dMenu = DermaMenu()
	function dMenu:AddSpacer(strText, funcFunction)
		local pnl = vgui.Create("DPanel", self)
		pnl.Paint = function(p, w, h)
			surface.SetDrawColor(col.o)
			surface.DrawRect(0, 0, w, h)
		end

		pnl:SetTall(1)
		self:AddPanel(pnl)
		return pnl
	end

	local col1 = col.o:darken(20)
	local oldAddOption = dMenu.AddOption
	dMenu.AddOption = function(dmenu, name, func, icon)
		local option = oldAddOption(dmenu, name, func)
		option:SetTextColor(col.w)
		option.Paint = function(_self, w, h) if _self:IsHovered() then draw.RoundedBox(0, 0, 0, w, h, col1) end end
		if icon then option:SetIcon(icon) end
	end

	dMenu.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, col.ba) end
	return dMenu
end

function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
end

local color_orange = col.o
local color_orange_darken = col.o:darken(25)
local color_orange_light = col.o:lighten(50)
function PANEL:SetUp(CoOwners)
	local selfPlayer = LocalPlayer()
	local CloseButton = vgui.Create("DButton", self)
	CloseButton:SetPos(self:GetWide() - sscale(102), sscale(2))
	CloseButton:SetSize(sscale(100), sscale(30))
	CloseButton:SetText("")
	CloseButton.Paint = function(slf, w, h) draw.SimpleText("X", "RXPV_Header", w * 0.75, h / 2, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
	CloseButton.DoClick = function(slf) self:Remove() end

	local sscale5 = sscale(5)
	local Main = vgui.Create("DPanel", self)
	Main:Dock(FILL)
	Main:DockMargin(sscale5, sscale5 * 3, sscale5, sscale5)
	Main.Paint = function(slf, w, h)
		surface.SetDrawColor(col.ba)
		surface.DrawRect(0, 0, w, h)
	end

	local function buttonPaint(_self, w, h)
		local col1 = color_orange_darken
		local col2 = color_orange
		if _self:IsHovered() then col2 = color_orange_light end
		surface.drawGradientPanelBox(_self, 0, 0, w, h, 1, col1, col2, col2, col1)
	end

	local buttonSize = self:GetTall() * 0.28
	local addAccessButton = vgui.Create("DButton", Main)
	addAccessButton:Dock(TOP)
	addAccessButton:SetText("Добавить совладельца")
	addAccessButton:SetTextColor(col.w)
	addAccessButton:SetFont("johnnyhats_17")
	addAccessButton:SetTall(buttonSize)
	addAccessButton.Paint = buttonPaint
	addAccessButton.DoClick = function(_self)
		local dmenu = buildDMenu()
		local plys = player.GetAll()
		table.sort(plys, function(a, b) return a:Name() < b:Name() end)
		for _, v in ipairs(plys) do
			if v == selfPlayer then continue end

			local sid = v:SteamID()
			if CoOwners[sid] then continue end

			dmenu:AddOption(v:Name(), UI_Derma_Query("Вы уверены, что хотите дать доступ " .. v:Name() .. " к принтеру?", "Подтверждение:", "Да", function()

				net.Start("RXP_AccessAction_C2S")
				net.WriteString("add")
				net.WriteString(sid)
				net.SendToServer()

				CoOwners[sid] = true
			end, "Нет", function() end), "icon16/user.png")
		end

		local w, h = _self:LocalToScreen(_self:GetWide(), 0)
		dmenu:Open(w, h, false, _self)
	end

	local removeAccessButton = vgui.Create("DButton", Main)
	removeAccessButton:Dock(TOP)
	removeAccessButton:DockMargin(0, sscale5, 0, 0)
	removeAccessButton:SetText("Удалить совладельца")
	removeAccessButton:SetTextColor(col.w)
	removeAccessButton:SetFont("johnnyhats_17")
	removeAccessButton:SetTall(buttonSize)
	removeAccessButton.Paint = buttonPaint
	removeAccessButton.DoClick = function(_self)
		local dmenu = buildDMenu()
		local plys = player.GetAll()
		table.sort(plys, function(a, b) return a:Name() < b:Name() end)
		for _, v in ipairs(plys) do
			if v == selfPlayer then continue end
			local sid = v:SteamID()
			if not CoOwners[sid] then continue end

			dmenu:AddOption(v:Name(), UI_Derma_Query("Вы уверены, что хотите забрать доступ у " .. v:Name() .. " к принтеру?", "Подтверждение:", "Да", function()

				net.Start("RXP_AccessAction_C2S")
				net.WriteString("delete")
				net.WriteString(sid)
				net.SendToServer()

				CoOwners[sid] = nil
			end, "Нет", function() end), "icon16/user.png")
		end

		local w, h = _self:LocalToScreen(_self:GetWide(), 0)
		dmenu:Open(w, h, false, _self)
	end

	local clearAccessButton = vgui.Create("DButton", Main)
	clearAccessButton:Dock(TOP)
	clearAccessButton:DockMargin(0, sscale5, 0, 0)
	clearAccessButton:SetText("Очистить совладельцев")
	clearAccessButton:SetTextColor(col.w)
	clearAccessButton:SetFont("johnnyhats_17")
	clearAccessButton:SetTall(buttonSize)
	clearAccessButton.Paint = buttonPaint
	clearAccessButton.DoClick = function(_self)
		UI_Derma_Query("Вы уверены, что хотите сбросить всех совладельцев этого принтера?", "Подтверждение:", "Да", function()
			net.Start("RXP_AccessAction_C2S")
			net.WriteString("clear")
			net.SendToServer()

			table.Empty(CoOwners)
		end, "Нет", function() end)()
	end
end

local sscale2 = sscale(2)
local sscale4 = sscale(4)
local sscale10 = sscale(10)
local sscale18 = sscale(18)
local sscale32 = sscale(32)
function PANEL:Paint()
	surface.SetDrawColor(col.ba)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	surface.SetDrawColor(col.o)
	surface.DrawRect(sscale2, sscale2, self:GetWide() - sscale4, sscale32)
	draw.SimpleText("Меню доступа", "RXPV_Text1", sscale10, sscale18, col.w, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RXP_PrinterAccessPanel", PANEL, "DFrame")
