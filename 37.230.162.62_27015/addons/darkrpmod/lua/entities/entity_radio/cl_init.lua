include("shared.lua")
-- local vec = Vector(0, 0, 30)
-- local col_white = Color(255, 255, 255)
-- local col_black = Color(0, 0, 0)
function ENT:Draw(flags)
	self:DrawModel(flags)
	--[[
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())

	if (dist > 350) then return end

	col_white.a = 350 - dist
	col_black.a = 350 - dist

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	ang:RotateAroundAxis(ang:Right(), math.sin(CurTime() * math.pi) * -45)

	cam.Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.25)
		draw.SimpleTextOutlined("Станция раций", "DermaLarge", 0, 0, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, col_black)
	cam.End3D2D()

	ang:RotateAroundAxis(ang:Right(), 180)

	cam.Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.25)
		draw.SimpleTextOutlined("Станция раций", "DermaLarge", 0, 0, col_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, col_black)
	cam.End3D2D()
  --]]
	nameplates.DrawEnt(self, self:GetPos() + Vector(0, 0, 25), 350, "UnionHUDO50")
end

local function S(v)
	return ScrH() * (v / 900)
end

surface.CreateFont("ra_menu_title", {
	font = "Roboto",
	size = 35,
	weight = 400,
	extented = true
})

local function set_selected(tbl, bool)
	for _, v in ipairs(tbl) do
		v:SetSelected(bool)
	end
end

local function get_selected(tbl)
	local selected = {}
	for _, v in ipairs(tbl) do
		if v:IsLineSelected() then
			local ply = v.player
			if IsValid(ply) then table.insert(selected, ply) end
		end
	end
	return selected
end

local buttons_cfg = {
	[1] = {
		text = "Выделить всех",
		func = function(lines) set_selected(lines, true) end
	},
	[2] = {
		text = "Снять выделение со всех",
		margin = true,
		func = function(lines) set_selected(lines, false) end
	},
	[3] = {
		text = "Включить рацию",
		margin = true,
		func = function(lines)
			local selects = get_selected(lines)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_on", selects)
		end
	},
	[4] = {
		text = "Выключить рацию",
		func = function(lines)
			local selects = get_selected(lines)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_off", selects)
		end
	},
	[5] = {
		text = "Вернуть значение до изменения",
		func = function(lines)
			local selects = get_selected(lines)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "restore", selects)
		end
	},
	[6] = {
		text = "Включить микрофон",
		margin = true,
		func = function(lines)
			local selects = get_selected(lines)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_off_force", selects)
		end
	},
	[7] = {
		text = "Выключить микрофон",
		func = function(lines)
			local selects = get_selected(lines)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_on_force", selects)
		end
	},
	[8] = {
		text = "Режим \"Speak To All\"",
		margin = true,
		func = function() RunConsoleCommand("radio_speak_to_all") end
	},
}

local function right_click(line, ply)
	local m = DermaMenu()
	if IsValid(ply) then
		m:AddOption("Скопировать SteamID", function()
			local steamid = ply:SteamID()
			if steamid then SetClipboardText(steamid) end
		end):SetIcon("icon16/application_double.png")

		local r_disabled = ply:isRadioDisabled()
		local text = r_disabled and "Включить рацию" or "Выключить рацию"
		local icon = r_disabled and "icon16/transmit.png" or "icon16/transmit_blue.png"
		local func = r_disabled and "turn_on" or "turn_off"
		m:AddOption(text, function() netstream.Start("radio.admins", func, {ply}) end):SetIcon(icon)

		local r_force_disabled = ply:isRadioForceDisabled()
		local text = r_force_disabled and "Включить микрофон" or "Выключить микрофон"
		local icon = r_force_disabled and "icon16/transmit.png" or "icon16/transmit_blue.png"
		local func = r_force_disabled and "turn_off_force" or "turn_on_force"
		m:AddOption(text, function() netstream.Start("radio.admins", func, {ply}) end):SetIcon(icon)
	end

	m:AddOption("Снять выделение", function() line:SetSelected(false) end):SetIcon("icon16/cancel.png")
	m:AddOption("Закрыть", function() end):SetIcon("icon16/cancel.png")
	m:Open()
end

local function admin_menu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(S(800), S(600))
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Управление рациями")
	frame.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.ba)
		draw.RoundedBox(0, 0, 0, w, 23, col.o)
	end

	local fw, fh = frame:GetWide(), frame:GetTall()
	local p1 = frame:Add("DPanel")
	p1:Dock(RIGHT)
	p1:DockMargin(1, 1, 1, 1)
	p1:SetWide(fw * .28)
	p1.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(75, 75, 75, 155)) end

	local p2 = frame:Add("DPanel")
	p2:Dock(FILL)
	p2:DockMargin(1, 1, 1, 1)
	p2.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(75, 75, 75, 155)) end

	local p21 = p2:Add("DPanel")
	p21:Dock(FILL)
	p21:DockMargin(1, 1, 1, 1)
	p21.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(255, 128, 0, 155)) end

	local dlabel = p21:Add("DLabel")
	dlabel:Dock(TOP)
	dlabel:SetTall(S(30))
	dlabel:SetContentAlignment(5)
	dlabel:SetFont("ra_menu_title")
	dlabel:SetText("Сопротивление")
	dlabel:SizeToContents()

	local dlist = p21:Add("DListView")
	dlist:Dock(FILL)
	dlist:AddColumn("Игрок")
	dlist:AddColumn("Ранг")
	dlist.OnRowRightClick = function(_, _, line) right_click(line, line.player) end

	local get_count = player.GetCount()
	local get_all = player.GetAll()
	for i = 1, get_count do
		local ply = get_all[i]
		if ply:r_isRebCmD() then continue end
		if ply:isRebel() then dlist:AddLine(ply:Name() or "UNKNOWN", team.GetName(ply:Team()) or "UNKNOWN").player = ply end
	end

	dlist:SortByColumn(1)
	local lines = dlist:GetLines()
	local b_num = #buttons_cfg
	for i = 1, b_num do
		local btn = buttons_cfg[i]
		local button = p1:Add("DButton")
		button:Dock(TOP)
		button:DockMargin(1, btn.margin and 16 or 1, 1, 1)
		button:SetTall(30)
		button:SetTextColor(color_white)
		button:SetText(btn.text or "UNKNOWN")
		button.DoClick = function(_) btn.func(lines) end
		button.Paint = function(self, w, h)
			local col = col.o
			if self:IsDown() then col = col:darken(30) end
			if self.entered and not self:IsDown() then col = col:lighten(30) end
			draw.RoundedBox(0, 0, 0, w, h, col)
		end

		button.OnCursorEntered = function(self) if not self.entered then self.entered = true end end
		button.OnCursorExited = function(self) if self.entered then self.entered = nil end end
	end
end

netstream.Hook("trigger_radio_menu", admin_menu)
