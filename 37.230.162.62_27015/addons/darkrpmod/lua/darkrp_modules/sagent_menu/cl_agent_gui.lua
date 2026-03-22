surface.CreateFont("sAgent.HackingButtons", {
	size = 25,
	weight = 500,
	extended = true,
	-- italic = true,
	font = "Roboto Bold"
})

surface.CreateFont("sAgent.Hacking", {
	size = 14,
	weight = 500,
	extended = true,
	-- italic = true,
	font = "Lucida Console"
})

local SScale = util.SScale
local hackedText = {[[
█░█ ▄▀█ █▀▀ █▄▀   █▀▀ █▀█ █▄░█ █▀ █▀█ █░░ █▀▀
█▀█ █▀█ █▄▄ █░█   █▄▄ █▄█ █░▀█ ▄█ █▄█ █▄▄ ██▄
		~Tools for hacking alliance ass.
]], [[
$Вы авт�оризовал�ись как №]] .. math.random(11111, 99999) .. [[.
]], [[
$Вы н�е имеете ра�зре�шений для ���������.
]], [[
1�) Начать взлом.
2�) Отменить взлом.
3�) �����  ����.
4�) ��  �������  ������.
5�) ����  ���  ��  �����.
6�) �  �����  ���  ��� ���.
]]}
local PANEL = {}
function PANEL:Init()
	if not vgui.CursorVisible() then hook.Run("ShowSpare1") end
	-- local dpanel = vgui.Create("DPanel")
	self:Dock(FILL)
	-- self:MakePopup()
	self.Paint = function(_self, w, h) draw.RoundedBox(0, 0, 0, w, h, col.ba) end
	self.OnRemove = function()
		if vgui.CursorVisible() then hook.Run("ShowSpare1") end
		netstream.Start("sAgent.resetHacking")
	end

	local scrW, scrH = ScrW(), ScrH()
	local sizeW, sizeH = SScale(800), SScale(600)
	local rTextPanel = self:Add("DPanel")
	rTextPanel:SetSize(sizeW, sizeH)
	rTextPanel:SetPos(scrW * 0.5 - sizeW * 0.5, scrH * 0.5 - sizeH * 0.5)
	rTextPanel.Paint = function(_self, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(12, 12, 12)) end
	local rUpperPanel = rTextPanel:Add("DPanel")
	rUpperPanel:Dock(TOP)
	rUpperPanel.Paint = function(_self, w, h) draw.RoundedBox(0, 0, 0, w, h, col.o) end
	-- rUpperPanel:DockMargin(15, 15, 0, 0)
	local rUpCloseButton = rUpperPanel:Add("DButton")
	rUpCloseButton:Dock(RIGHT)
	rUpCloseButton:SetWide(32)
	rUpCloseButton:SetTextColor(color_white)
	rUpCloseButton:SetFont("sAgent.HackingButtons")
	rUpCloseButton:SetText("X")
	-- rUpCloseButton:SizeToContents()
	rUpCloseButton.DoClick = function() self:Remove() end
	rUpCloseButton.Paint = function() end
	local rText = rTextPanel:Add("RichText")
	rText:Dock(FILL)
	rText:DockMargin(15, 15, 0, 0)
	-- rText.Paint = function(_self, w, h)
	-- 	-- draw.RoundedBox(0, 0, 0, w, h, col.ba)
	-- end
	function rText:PerformLayout()
		self:SetFontInternal("sAgent.Hacking")
		self:SetBGColor(Color(12, 12, 12))
	end

	-- rText:Dock(FILL)
	rText:InsertColorChange(192, 192, 192, 255)
	rText:AppendText(hackedText[1])
	rText:AppendText("\n\n\n")
	rText:InsertColorChange(255, 64, 64, 255)
	rText:AppendText(hackedText[2])
	rText:AppendText(hackedText[3])
	rText:AppendText("\n\n\n")
	rText:InsertColorChange(192, 192, 192, 255)
	rText:AppendText(hackedText[4])
	rText:AppendText("\n\n\n")
	local dIconLPanel = rTextPanel:Add("DPanel")
	dIconLPanel:Dock(BOTTOM)
	dIconLPanel:SetHeight(SScale(48))
	dIconLPanel.Paint = function() end
	local dProgress = rTextPanel:Add("DProgress")
	dProgress:Dock(BOTTOM)
	dProgress:SetHeight(SScale(30))
	dProgress:SetFraction(0)
	dProgress:SetVisible(false)
	dProgress.Think = function(_self)
		local startTime, endTime = _self.startTime, _self.endTime
		if (startTime and endTime) and startTime < endTime then
			local time = endTime - startTime
			local nowTime = CurTime() - startTime
			local frac = nowTime / time
			dProgress:SetFraction(frac)
		end
	end

	local dIconL = dIconLPanel:Add("DIconLayout")
	dIconL:Dock(FILL)
	dIconL:SetSpaceY(4)
	dIconL:SetSpaceX(4)
	dIconL:SetBorder(4)
	dIconL:SetStretchHeight(true)
	local paintFuncDIB = function(_self, w, h)
		local col = col.o
		if _self:IsHovered() then
			-- 	surface.SetDrawColor(col.oa)
			-- else
			-- surface.SetDrawColor(col.o)
			-- col:lighten(150)
			col = col:lighten(50)
		end

		surface.SetDrawColor(col)
		surface.DrawRect(0, 0, w, h)
	end

	-- surface.SetDrawColor(col.oa)
	-- surface.DrawRect(0, _self:GetTall() / 2, _self:GetWide(), _self:GetTall() / 2)
	local sW, sH = SScale(75), SScale(40)
	local buttons = {}
	for i = 1, 10 do
		local ListItem = dIconL:Add("DButton")
		ListItem:SetSize(sW, sH)
		ListItem:SetText(i)
		ListItem:SetTextColor(color_white)
		ListItem:SetFont("sAgent.HackingButtons")
		ListItem:SetText(i)
		ListItem.Paint = paintFuncDIB
		table.insert(buttons, ListItem)
	end

	buttons[1].DoClick = function(_self)
		local ent = self.ent
		if not IsValid(ent) or ent:GetClass() ~= "sagent_terminal" then return end
		netstream.Start("sAgent.StartHacking", ent)
	end

	buttons[2].DoClick = function(_self)
		self:Remove()
		if vgui.CursorVisible() then hook.Run("ShowSpare1") end
	end

	dIconL.buttons = buttons
	self.dIconL = dIconL
	self.rText = rText
	self.buttons = buttons
	self.dProgress = dProgress
end

local defColor = Color(192, 192, 192, 255)
function PANEL:AppendText(text, color, newLine)
	text = tostring(text)
	local rText = self.rText
	if not color then color = defColor end
	if not text:find("\n") then text = text .. "\n" end
	local r, g, b, a = color.r, color.g, color.b, color.a
	rText:InsertColorChange(r, g, b, a)
	rText:AppendText(text)
	if newLine then rText:AppendText("\n") end
end

vgui.Register("UnSAgentMenu", PANEL, "DPanel")
