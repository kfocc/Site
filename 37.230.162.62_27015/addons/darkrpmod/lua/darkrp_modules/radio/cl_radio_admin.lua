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

local function get_selected(tbl, tbl1)
	local selected = {}
	for _, v in ipairs(tbl) do
		if v:IsLineSelected() then
			local ply = v.player
			if IsValid(ply) then table.insert(selected, ply) end
		end
	end

	for _, v in ipairs(tbl1) do
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
		func = function(lines, lines1)
			set_selected(lines, true)
			set_selected(lines1, true)
		end
	},
	[2] = {
		text = "Выделить всех ГО",
		func = function(lines, _) set_selected(lines, true) end
	},
	[3] = {
		text = "Выделить всех ОТА",
		func = function(_, lines1) set_selected(lines1, true) end
	},
	[4] = {
		text = "Снять выделение со всех",
		margin = true,
		func = function(lines, lines1)
			set_selected(lines, false)
			set_selected(lines1, false)
		end
	},
	[5] = {
		text = "Снять выделение с ГО",
		func = function(lines, _) set_selected(lines, false) end
	},
	[6] = {
		text = "Снять выделение с ОТА",
		func = function(_, lines1) set_selected(lines1, false) end
	},
	[7] = {
		text = "Включить рацию",
		margin = true,
		func = function(lines, lines1)
			local selects = get_selected(lines, lines1)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_on", selects)
		end
	},
	[8] = {
		text = "Выключить рацию",
		func = function(lines, lines1)
			local selects = get_selected(lines, lines1)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_off", selects)
		end
	},
	[9] = {
		text = "Вернуть значение до изменения",
		func = function(lines, lines1)
			local selects = get_selected(lines, lines1)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "restore", selects)
		end
	},
	[10] = {
		text = "Включить микрофон",
		margin = true,
		func = function(lines, lines1)
			local selects = get_selected(lines, lines1)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_off_force", selects)
		end
	},
	[11] = {
		text = "Выключить микрофон",
		func = function(lines, lines1)
			local selects = get_selected(lines, lines1)
			if #selects < 1 then return end
			netstream.Start("radio.admins", "turn_on_force", selects)
		end
	},
	[12] = {
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

function radio_admin_menu()
	local frame = vgui.Create("DFrame")
	frame:SetSize(S(800), S(600))
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Управление рациями ГО и ОТА")
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
	p21.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(4, 209, 232, 155)) end

	local dlabel = p21:Add("DLabel")
	dlabel:Dock(TOP)
	dlabel:SetTall(S(30))
	dlabel:SetContentAlignment(5)
	dlabel:SetFont("ra_menu_title")
	dlabel:SetText("ГО")
	dlabel:SizeToContents()

	local dlist = p21:Add("DListView")
	dlist:Dock(FILL)
	dlist:AddColumn("Игрок")
	dlist:AddColumn("Ранг")
	dlist.OnRowRightClick = function(_, _, line) right_click(line, line.player) end

	local p22 = p2:Add("DPanel")
	p22:Dock(RIGHT)
	p22:DockMargin(1, 1, 1, 1)
	p22:SetWide(p1:GetWide() * 1.25)
	p22.Paint = function(_, w, h) draw.RoundedBox(0, 0, 0, w, h, Color(164, 17, 186, 155)) end

	local dlabel1 = p22:Add("DLabel")
	dlabel1:Dock(TOP)
	dlabel1:SetTall(S(30))
	dlabel1:SetContentAlignment(5)
	dlabel1:SetFont("ra_menu_title")
	dlabel1:SetText("ОТА")
	dlabel1:SizeToContents()

	local dlist1 = p22:Add("DListView")
	dlist1:Dock(FILL)
	dlist1:AddColumn("Игрок")
	dlist1:AddColumn("Ранг")
	dlist1.OnRowRightClick = function(_, _, line) right_click(line, line.player) end

	local get_count = player.GetCount()
	local get_all = player.GetAll()
	for i = 1, get_count do
		local ply = get_all[i]
		if ply:r_isCPCmD() then continue end
		-- if ply:isRebel() then continue end
		if ply:isOTA() and ply:isRebel() then continue end
		if ply:isCP() and not ply:isOTA() then
			local t = ply:GetNetVar("TeamNum", ply:Team())
			dlist:AddLine(ply:Name() or "UNKNOWN", team.GetName(t) or "UNKNOWN").player = ply
		elseif ply:isOTA() then
			dlist1:AddLine(ply:Name() or "UNKNOWN", team.GetName(ply:Team()) or "UNKNOWN").player = ply
		end
	end

	dlist:SortByColumn(1)
	dlist1:SortByColumn(1)

	local lines = dlist:GetLines()
	local lines1 = dlist1:GetLines()
	local b_num = #buttons_cfg
	for i = 1, b_num do

		local btn = buttons_cfg[i]
		local button = p1:Add("DButton")
		button:Dock(TOP)
		button:DockMargin(1, btn.margin and 16 or 1, 1, 1)
		button:SetTall(30)
		button:SetTextColor(color_white)
		button:SetText(btn.text or "UNKNOWN")
		button.DoClick = function(_) btn.func(lines, lines1) end
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
-- concommand.Add("test", admin_menu)
