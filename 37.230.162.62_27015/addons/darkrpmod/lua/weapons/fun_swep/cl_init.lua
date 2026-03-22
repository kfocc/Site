include("shared.lua")

local vac_panel, ban_panel, fun_panel
local function VACPanel()
	if IsValid(ban_panel) then return end
	if IsValid(vac_panel) then vac_panel:Remove() end
	gui.HideGameUI()
	RunConsoleCommand("stopsound")
	timer.Simple(15, function() if IsValid(vac_panel) then vac_panel:Remove() end end)
	local vac_bg = vgui.Create("HTML")
	vac_bg:SetSize(ScrW(), ScrH())
	vac_bg:OpenURL[[asset://garrysmod/html/loading.html]]
	vac_bg:MakePopup()
	vac_bg:SetMouseInputEnabled(false)

	vac_panel = vgui.Create("DPanel")
	vac_panel:SetSize(400, 180)
	vac_panel:Center()
	vac_panel:MakePopup()
	vac_panel.OnRemove = function(self) vac_bg:Remove() end

	vac_panel.Paint = function(self, w, h)
		surface.SetDrawColor(108, 111, 114, 250)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	vac_panel:SetKeyBoardInputEnabled(true)
	vac_panel.OnKeyCodePressed = function()
		gui.HideGameUI()
		return false
	end

	vac_panel.Think = function()
		gui.HideGameUI()
		RunConsoleCommand("stopsound")
	end

	local cancel = vac_panel:Add("DButton")
	cancel:SetText("#GameUI_Close")
	cancel:SetPos(300, 136)
	cancel:SetSize(72, 24)
	cancel:SetCursor("arrow")
	cancel.Paint = function(self, w, h)
		surface.SetDrawColor(227, 227, 227, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local delay = CurTime() + 2
	cancel.DoClick = function()
		if delay >= CurTime() then return end
		if IsValid(vac_panel) then vac_panel:Remove() end
	end

	local lbl = vac_panel:Add("DLabel")
	lbl:SetWrap(true)
	lbl:SetPos(80, 24)
	lbl:SetSize(300, 120)
	lbl:SetText("#VAC_ConnectionRefusedDetail")
	local ttl = vac_panel:Add("DLabel")
	ttl:SetPos(10, 10)
	ttl:SetText("#VAC_ConnectionRefusedTitle")
	ttl:SizeToContents()
	local img = vac_panel:Add("DImage")
	img:SetPos(30, 42)
	img:SetSize(64, 64)
	img:SetImage("vgui/resource/icon_vac")
end

local text_ban = [[
-------===== [ Заблокирован ] =====-------
Вы забанены на Union HL2RP С17
FUN

Забанил
(Console)

Осталось
(Permaban)
Апелляция - f.unionrp.info
]]
local function BanPanel()
	if IsValid(vac_panel) then return end
	if IsValid(ban_panel) then ban_panel:Remove() end
	gui.HideGameUI()
	RunConsoleCommand("stopsound")
	timer.Simple(15, function() if IsValid(ban_panel) then ban_panel:Remove() end end)
	local ban_bg = vgui.Create("HTML")
	ban_bg:SetSize(ScrW(), ScrH())
	ban_bg:OpenURL[[asset://garrysmod/html/loading.html]]
	ban_bg:MakePopup()
	ban_bg:SetMouseInputEnabled(false)
	ban_panel = vgui.Create("DPanel")
	ban_panel:SetSize(400, 220)
	ban_panel:Center()
	ban_panel:MakePopup()
	ban_panel.OnRemove = function(self) ban_bg:Remove() end
	ban_panel.Paint = function(self, w, h)
		surface.SetDrawColor(108, 111, 114, 250)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	ban_panel:SetKeyBoardInputEnabled(true)
	ban_panel.OnKeyCodePressed = function()
		gui.HideGameUI()
		return false
	end

	ban_panel.Think = function()
		gui.HideGameUI()
		RunConsoleCommand("stopsound")
	end

	local cancel = ban_panel:Add("DButton")
	cancel:SetText("#GameUI_Close")
	cancel:SetPos(310, 180)
	cancel:SetSize(72, 24)
	cancel:SetCursor("arrow")
	cancel.Paint = function(self, w, h)
		surface.SetDrawColor(227, 227, 227, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local delay = CurTime() + 2
	cancel.DoClick = function()
		if delay >= CurTime() then return end
		if IsValid(ban_panel) then ban_panel:Remove() end
	end

	local x = ban_panel:Add("DButton")
	x:SetText("")
	x:SetPos(310, 10)
	x:SetSize(72, 24)
	x:SetCursor("arrow")
	x.Paint = function(self, w, h) draw.SimpleText("×", "Trebuchet24", w, h - 10, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
	x.DoClick = function()
		if delay >= CurTime() then return end
		if IsValid(ban_panel) then ban_panel:Remove() end
	end

	local lbl = ban_panel:Add("DLabel")
	lbl:SetWrap(true)
	lbl:SetPos(25, 0)
	lbl:SetSize(300, 220)
	lbl:SetText(text_ban)
	lbl:SetContentAlignment(5)
end

local text_ban = [[
-------===== [ Заблокирован ] =====-------
Вы забанены на Union HL2RP C17
fun // Johnny

Забанил
(Unknown)

Осталось
(Permaban)
Апелляция - forum.unionrp.info
]]
local function FunPanel()
	if IsValid(vac_panel) then return end
	if IsValid(ban_panel) then ban_panel:Remove() end
	gui.HideGameUI()
	RunConsoleCommand("stopsound")
	timer.Simple(15, function() if IsValid(ban_panel) then ban_panel:Remove() end end)
	local ban_bg = vgui.Create("HTML")
	ban_bg:SetSize(ScrW(), ScrH())
	ban_bg:OpenURL[[asset://garrysmod/html/loading.html]]
	ban_bg:MakePopup()
	ban_bg:SetMouseInputEnabled(false)
	ban_panel = vgui.Create("DPanel")
	ban_panel:SetSize(400, 220)
	ban_panel:Center()
	ban_panel:MakePopup()
	ban_panel.OnRemove = function(self) ban_bg:Remove() end
	ban_panel.Paint = function(self, w, h)
		surface.SetDrawColor(108, 111, 114, 250)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	ban_panel:SetKeyBoardInputEnabled(true)
	ban_panel.OnKeyCodePressed = function()
		gui.HideGameUI()
		return false
	end

	ban_panel.Think = function()
		gui.HideGameUI()
		RunConsoleCommand("stopsound")
	end

	local cancel = ban_panel:Add("DButton")
	cancel:SetText("#GameUI_Close")
	cancel:SetPos(310, 180)
	cancel:SetSize(72, 24)
	cancel:SetCursor("arrow")
	cancel.Paint = function(self, w, h)
		surface.SetDrawColor(227, 227, 227, 255)
		surface.DrawRect(0, 0, w, h)
		surface.SetDrawColor(40, 40, 40, 255)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local delay = CurTime() + 2
	cancel.DoClick = function()
		if delay >= CurTime() then return end
		if IsValid(ban_panel) then ban_panel:Remove() end
	end

	local x = ban_panel:Add("DButton")
	x:SetText("")
	x:SetPos(310, 10)
	x:SetSize(72, 24)
	x:SetCursor("arrow")
	x.Paint = function(self, w, h) draw.SimpleText("×", "Trebuchet24", w, h - 10, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) end
	x.DoClick = function()
		if delay >= CurTime() then return end
		if IsValid(ban_panel) then ban_panel:Remove() end
	end

	local lbl = ban_panel:Add("DLabel")
	lbl:SetWrap(true)
	lbl:SetPos(25, 0)
	lbl:SetSize(300, 220)
	lbl:SetText(text_ban)
	lbl:SetContentAlignment(5)
end

netstream.Hook("pranked_menu", function(mode)
	if mode == "vac" then
		VACPanel()
	elseif mode == "ban" then
		BanPanel()
	elseif mode == "fun" then
		FunPanel()
	end
end)

netstream.Hook("request_amount", function() Derma_StringRequest("Фейк деньги", "Введите количество (0 - 1'000'000)", "", function(text) netstream.Start("request_amount", text) end, function() end) end)
function SWEP:DrawHUD()
	local w, h = ScrW(), ScrH()
	local text = input.LookupBinding("reload"):upper() .. ", чтобы сменить мод."
	draw.SimpleText(text, "Trebuchet24", 15, h / 2 - 35, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	local mode = self.Modes[self:GetMode()]
	if not mode then return end
	local t1, t2, t3 = mode[1], mode[2], mode[3]
	local y = h / 2
	local w, h = draw.SimpleText(t1, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	y = y + h + 5
	local w, h = draw.SimpleText(t2, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	y = y + h + 5
	local w, h = draw.SimpleText(t3, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	local use1, use2 = self:GetLastUseL() or 0, self:GetLastUseR() or 0
	if use1 > CurTime() then
		y = y + h + 5
		local time = "ЛКМ перезарядится через " .. math.Round(use1 - CurTime()) .. "c"
		draw.SimpleText(time, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end

	if use2 > CurTime() then
		y = y + h + 5
		local time = "ПКМ перезарядится через " .. math.Round(use2 - CurTime()) .. "c"
		draw.SimpleText(time, "Trebuchet24", 15, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
end
