local PANEL = {}

function PANEL:Init()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetDraggable(false)
end

local localizeStats = {
	["HP"] = "Прочность",
	["RPM"] = "Скорость печати в секунду",
	["HullDecreSpeed"] = "Расходование энергии",
	["MaxMoney"] = "Вместительность",
	["BreakDownRate"] = "Шанс поломки",
}

local CheckLocalUpgrades = RXPrinters_Config.CheckLocalUpgrades
function PANEL:SetUp(Ent, Stat, DefaultStat, Boosts, TB)
	local CloseButton = vgui.Create("DButton", self)
	CloseButton:SetPos(self:GetWide() - 102, 2)
	CloseButton:SetSize(100, 30)
	CloseButton:SetText("")
	CloseButton.Paint = function(slf)
		-- if CloseButton:IsHovered() then
		-- 	surface.SetDrawColor(col.o:darken(50))
		-- else
		-- 	surface.SetDrawColor(col.o:lighten(50))
		-- end
		-- surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
		draw.SimpleText("X", "RXPV_Header", slf:GetWide() * 0.75, slf:GetTall() / 2, col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	CloseButton.DoClick = function(slf)
		if true then
			self:Remove()
			return
		end

		if RXP_PrinterPanel and RXP_PrinterPanel:IsValid() then RXP_PrinterPanel:Remove() end
		RXP_PrinterPanel = vgui.Create("RXP_PrinterPanel")
		RXP_PrinterPanel:SetSize(750, 400)
		RXP_PrinterPanel:Center()
		RXP_PrinterPanel:SetUp(Ent, Stat, DefaultStat, Boosts, TB)
		RXP_PrinterPanel:MakePopup()
	end

	local LeftBG = vgui.Create("DPanel", self)
	LeftBG:SetPos(6, 40)
	LeftBG:SetSize(self:GetWide() / 2 - 9, self:GetTall() - 46)
	LeftBG.Paint = function(slf)
		surface.SetDrawColor(col.ba)
		surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
	end

	local LeftLister = vgui.Create("DPanelList", LeftBG)
	LeftLister:SetPos(2, 2)
	LeftLister:SetSize(LeftBG:GetWide() - 4, LeftBG:GetTall() - 4)
	LeftLister:EnableHorizontal(false)
	LeftLister:EnableVerticalScrollbar(true)
	LeftLister:SetSpacing(3)

	for k, v in pairs(Stat) do
		local Updates = vgui.Create("DButton")
		Updates:SetSize(LeftLister:GetWide() - 20, 50)
		Updates:SetText("")
		-- local maxStr = v .. " / " .. DefaultStat[k]
		local maxStr = v
		local boost = Boosts[k]
		if boost then maxStr = maxStr .. " + " .. boost end
		local localizeStat = localizeStats[k]
		Updates.Paint = function(slf)
			if slf:IsHovered() then
				surface.SetDrawColor(col.o)
			else
				surface.SetDrawColor(col.oa)
			end

			surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(0, slf:GetTall() / 2, slf:GetWide(), slf:GetTall() / 2)
			draw.SimpleText(localizeStat, "RXPV_Text1", 5, 0, Color(200, 220, 255, 255))
			draw.SimpleText(maxStr, "RXPV_Text1", 5, 25, Color(200, 220, 255, 255))
		end

		LeftLister:AddItem(Updates)
	end

	local RightBG = vgui.Create("DPanel", self)
	RightBG:SetPos(self:GetWide() / 2 + 3, 40)
	RightBG:SetSize(self:GetWide() / 2 - 9, self:GetTall() - 46)
	RightBG.Paint = function(slf)
		surface.SetDrawColor(col.ba)
		surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
	end

	local RightLister = vgui.Create("DPanelList", RightBG)
	RightLister:SetPos(2, 2)
	RightLister:SetSize(RightBG:GetWide() - 4, RightBG:GetTall() - 4)
	RightLister:EnableHorizontal(false)
	RightLister:EnableVerticalScrollbar(true)
	RightLister:SetSpacing(3)

	for k, v in pairs(RXP_Tuners) do
		local isRestricted, localMaxPrice, localMaxlevel = CheckLocalUpgrades(Ent, k)
		if isRestricted then continue end

		local CurLevel, MaxLevel = TB.TuneLevel[k] or 0, localMaxlevel or v.MaxLevel
		local Price = localMaxPrice or v.Price
		local Rate = CurLevel / MaxLevel
		local addPanel = vgui.Create("DPanel")
		addPanel:SetSize(RightLister:GetWide() - 20, 50)
		addPanel.Paint = function() end

		local Updates = vgui.Create("DButton", addPanel)
		Updates:Dock(FILL)
		Updates:SetText("")
		Updates.Paint = function(slf)
			if slf:IsHovered() then
				surface.SetDrawColor(col.o)
			else
				surface.SetDrawColor(col.oa)
			end

			surface.DrawRect(0, 0, slf:GetWide(), slf:GetTall())
			surface.SetDrawColor(col.oa)
			surface.DrawRect(0, slf:GetTall() / 2, slf:GetWide(), slf:GetTall() / 2)
			draw.SimpleText(v.PrintName .. " ", "RXPV_Text1", 5, 0, col.w)
			draw.SimpleText("₮" .. Price, "RXPV_Text1", slf:GetWide() - 5, 0, col.w, TEXT_ALIGN_RIGHT)
			draw.SimpleText(CurLevel .. " / " .. MaxLevel, "RXPV_Text1", slf:GetWide() - 5, 25, col.w, TEXT_ALIGN_RIGHT)

			local PX, PY, SX, SY = 10, slf:GetTall() / 2 + 2, slf:GetWide() - 100, slf:GetTall() / 2 - 4
			surface.SetDrawColor(col.ra)
			surface.DrawRect(PX, PY, SX, SY)
			surface.SetDrawColor(col.ba)
			surface.DrawRect(PX + 2, PY + 2, SX - 4, SY - 4)
			surface.SetDrawColor(col.o)
			surface.DrawRect(PX + 4, PY + 4, (SX - 8) * Rate, SY - 8)
		end

		Updates.DoClick = function(slf) RXP_DoUpgrade(Ent, v.LuaName) end
		local fillUpdates = vgui.Create("DImageButton", addPanel)
		fillUpdates:Dock(RIGHT)
		fillUpdates:SetWide(32)
		local icon = Either(CurLevel ~= MaxLevel, "icon16/accept.png", "icon16/cancel.png")
		fillUpdates:SetImage(icon)
		-- fillUpdates:SetKeepAspect(true)
		fillUpdates:SetStretchToFit(false)
		fillUpdates.Paint = function(_self)
			if _self:IsHovered() then
				surface.SetDrawColor(col.o)
			else
				surface.SetDrawColor(col.oa)
			end

			surface.DrawRect(0, 0, _self:GetWide(), _self:GetTall())
			surface.SetDrawColor(col.oa)
			surface.DrawRect(0, _self:GetTall() / 2, _self:GetWide(), _self:GetTall() / 2)
		end

		fillUpdates.DoClick = function(_self)
			if CurLevel ~= MaxLevel then
				net.Start("RXP_ApplyTune_C2SAll")
				net.WriteEntity(Ent)
				net.WriteString(k)
				net.SendToServer()
			end
		end

		RightLister:AddItem(addPanel)
	end

	local UpdatesAll = vgui.Create("DButton", self)
	UpdatesAll:Dock(BOTTOM)
	UpdatesAll:SetText("Улучшить всё")
	UpdatesAll:SetTextColor(col.w)
	UpdatesAll:SetFont("RXPV_Text1")
	UpdatesAll:SetContentAlignment(5)
	UpdatesAll.Paint = function(_self)
		if _self:IsHovered() then
			surface.SetDrawColor(col.o:lighten(30))
		else
			surface.SetDrawColor(col.o)
		end

		surface.DrawRect(0, 0, _self:GetWide(), _self:GetTall())
	end

	UpdatesAll.DoClick = function(_self)
		local toUpdate = false
		for name, data in pairs(RXP_Tuners) do
			local CurLevel, MaxLevel = TB.TuneLevel[name] or 0, data.MaxLevel
			if CurLevel ~= MaxLevel then
				toUpdate = true
				break
			end
		end

		if toUpdate then
			net.Start("RXP_ApplyTune_C2SAll")
			net.WriteEntity(Ent)
			net.SendToServer()
		end
	end
	-- UpdatesAll:DockPadding(0, 15, 0, 0)
end

function PANEL:Paint()
	surface.SetDrawColor(col.ba)
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	surface.SetDrawColor(col.o)
	surface.DrawRect(2, 2, self:GetWide() - 4, 32)
	draw.SimpleText("Меню улучшений", "RXPV_Text1", 10, 18, col.w, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

vgui.Register("RXP_PrinterPanel", PANEL, "DFrame")
