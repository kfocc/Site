local pda_mats = {
	citizen = Material("union/pda/citizen"),
	alliance = Material("union/pda/alliance"),
}

local minimaps = {
	{0, Material("union/pda/map_canals")},
	{3470, Material("union/pda/map_city")},
	{5290, Material("union/pda/map_2floor")},
	{7250, Material("union/pda/map_3floor")}
}
DarkRP.minimaps = minimaps

local canals_rebel = Material("union/pda/map_canals_rebels")

DarkRP.Requests = DarkRP.Requests or {}

netstream.Hook("PDA.Request", function(id, text, name, pos, requestTo, icon, sound, cid)
	local request = {
		id = id,
		text = text,
		name = name,
		pos = pos,
		requestTo = requestTo,
		icon = icon,
		sound = sound,
		cid = cid
	}

	table.insert(DarkRP.Requests, 1, request)
end)

netstream.Hook("request.get", function(id, by, cid)
	for k, v in ipairs(DarkRP.Requests) do
		if v.id == id then
			if not v.solved then
				v.solved = by
				v.solved_by = cid
			end

			break
		end
	end
end)

--local scrw, scrh = 1920, 1080
local scrw, scrh = ScrW(), ScrH()
local x_size, y_size = 1733, 1381

local scale_x, scale_y = scrw / x_size, scrh / y_size

local scale = math.min(scale_x, scale_y, 1)

x_size = math.ceil(x_size * scale)
y_size = math.ceil(y_size * scale)

-- 0.00057703404500866 -- Один пиксель на 3440х3440

local skip_w, skip_h = math.floor(x_size * 0.11656087709175), math.ceil(y_size * 0.11658218682)
local box_w, box_h = math.ceil(x_size * 0.77091748413157), math.ceil(y_size * 0.80448950036206)

local screen_h = math.ceil(y_size * 0.71614771904)
local buttons_h = math.ceil(y_size * 0.055)

local f_size = math.ceil(x_size * 0.031159838430467)

local name_fontsize = ScreenScaleH(25)
surface.CreateFont("PDA.Name", {
	font = "Roboto",
	extended = true,
	size = name_fontsize,
	weight = 700,
})

local cid_fontsize = name_fontsize * .75
surface.CreateFont("PDA.CID", {
	font = "Roboto",
	extended = true,
	size = cid_fontsize,
	weight = 600,
})

local button_fontsize = cid_fontsize * .75
surface.CreateFont("PDA.Buttons", {
	font = "Roboto",
	extended = true,
	size = button_fontsize,
	weight = 600,
})

local smallerbutton_fontsize = button_fontsize * .75
surface.CreateFont("PDA.SmallerButton", {
	font = "Roboto",
	extended = true,
	size = smallerbutton_fontsize,
	weight = 600,
})

local contextbutton_fontsize = button_fontsize * .5
surface.CreateFont("PDA.ContextButton", {
	font = "Roboto",
	extended = true,
	size = contextbutton_fontsize,
	weight = 600,
})

surface.CreateFont("PDA.MapFont", {
	font = "Roboto",
	extended = true,
	size = smallerbutton_fontsize,
	weight = 600
})

local col_back = Color(20, 20, 20) -- Color(27, 27, 27)--Color(20, 20, 20)
local name_col = Color(195, 198, 207, 255)
local cid_col = Color(96, 99, 107, 255)
local logo = Material("union/logo.png")
local function cpaint(s, bw, bh)
	surface.SetDrawColor(s:IsHovered() and col.oa or col.ba)
	surface.DrawRect(0, 0, bw, bh)
end

local sscale2 = ScreenScaleH(2)
local function scrolledit(scroll)
	local sbar = scroll:GetVBar()
	sbar:SetWide(sscale2)
	sbar:SetHideButtons(true)
	function sbar:Paint(w, h)
		--draw.RoundedBox(0, 0, 0, w, h, col.b)
	end

	function sbar.btnGrip:Paint(w, h)
		draw.RoundedBox(w * .5, 0, 0, w, h, col.o)
	end
end

local function AddOption(c, option_name, option_icon, func)
	local option = c:AddOption(option_name, func)
	option:SetIcon(option_icon)
	option.Paint = cpaint

	option:SetTextColor(color_white)
	option:SetFont("PDA.ContextButton")
	option:SetAutoStretchVertical(true)

	local o = option.PerformLayout
	function option:PerformLayout(w, h)
		o(self, w, h)
		self.m_Image:SetSize(h, h)
		self:SetTextInset(h * 1.5, 0)
	end
	return option
end

local function AddSubMenu(c, option_name, option_icon)
	local option, parent = c:AddSubMenu(option_name)
	option.Paint = cpaint

	parent:SetTextColor(color_white)
	parent.Paint = cpaint
	parent:SetIcon(option_icon)
	parent:SetFont("PDA.ContextButton")
	parent:SetAutoStretchVertical(true)

	local o = parent.PerformLayout
	function parent:PerformLayout(w, h)
		o(self, w, h)
		self.m_Image:SetSize(h, h)
		self:SetTextInset(h * 1.5, 0)
	end
	return option, parent
end

local cur_tbl, cur_add, cur_active
local function OpenPlayerInfo(tbl)
	if not IsValid(PDA) then return end

	local screen = PDA.Screen
	if not IsValid(screen) then return end

	screen:Clear()
	PDA.Page = "player_info"
	cur_tbl = tbl
	local w, h = screen:GetWide(), screen:GetTall()
	local ply = tbl.ply
	local name = IsValid(ply) and ply:Name() or tbl.name or "Неизвестно"
	local cid = "##" .. (tbl.CID or "00000")
	local status = tbl.status or "Неизвестно" --[[IsValid(ply) and (ply:isOTA() and "ОТА" or ply:isCP() and "Сотрудник ГО") or]]
	local citizenship = (IsValid(tbl.ply) and ply:Alive()) and ((ply:isRebel() and not ply.Disguised and not ply:isCP()) and "Отозвано" or ply:isWanted() and "В розыске" or ply:isArrested() and "Арестован" or "Активно") or "Ампутирован"

	local header_h = name_fontsize * 2
	local sides_skip = w * 0.01
	local panels_w = w - sides_skip * 2

	local header = screen:Add("DPanel")
	header:SetTall(header_h)
	header:DockMargin(sides_skip, h * 0.005, sides_skip, h * 0.005)
	header:Dock(TOP)

	local dlabel_name = Label(name, header)
	dlabel_name:SetFont("PDA.Name")
	dlabel_name:SetTextColor(name_col)
	dlabel_name:SizeToContents()
	dlabel_name:Dock(TOP)

	local dlabel_cid = Label(cid, header)
	dlabel_cid:SetFont("PDA.CID")
	dlabel_cid:SetTextColor(cid_col)
	dlabel_cid:SizeToContents()
	dlabel_cid:Dock(TOP)

	function dlabel_cid:OnRemove()
		cur_tbl = nil
		cur_add = nil
	end

	local logo_size = header_h - 4
	local logo_x = panels_w - logo_size - 4
	function header:Paint(header_w, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(logo_x, 0, logo_size, logo_size)

		draw.SimpleText("Статус: " .. status, "PDA.Buttons", logo_x, 0, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Лояльность: " .. tbl.loyality, "PDA.Buttons", logo_x, button_fontsize, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Гражданство: " .. citizenship, "PDA.Buttons", logo_x, button_fontsize * 2, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.RoundedBox(0, 0, logo_size, w, 2, col.o)
	end

	local player_buttons = screen:Add("DPanel")
	player_buttons:SetTall(h * .05)
	player_buttons:Dock(BOTTOM)
	player_buttons:DockMargin(sides_skip, 0, sides_skip, sides_skip)
	function player_buttons:Paint()
		return
	end

	local p_buttons = {
		{
			col.o,
			"СОЗДАТЬ ЗАПИСЬ",
			function(target)
				if not IsValid(target) or not target:Alive() then
					notification.AddLegacy("Игрок мертв", NOTIFY_ERROR, 5)
					return
				end

				local context = DermaMenu(false, player_buttons)
				context.Paint = cpaint

				if LocalPlayer():isCP() then
					local wanted_actions = AddSubMenu(context, "Розыск", "icons/fa32/star-o.png")
					AddOption(wanted_actions, "Объявить в розыск", "icons/fa32/user-plus.png", UI_Request("Объявление в розыск " .. name, "Введите причину объявления в розыск", function(reason)
						if not IsValid(target) then return end
						RunConsoleCommand("darkrp", "wanted", target:UserID(), reason)
					end))

					AddOption(wanted_actions, "Снять розыск", "icons/fa32/user-times.png", function()
						if not IsValid(target) then return end
						RunConsoleCommand("darkrp", "unwanted", target:UserID())
					end)

					AddOption(context, "Запросить ордер", "icons/fa32/file-text-o.png", UI_Request("Запрос ордера на " .. name, "Введите причину запроса ордера", function(reason) RunConsoleCommand("darkrp", "warrant", target:UserID(), reason) end))
				end

				if LocalPlayer():isCPCMD() then
					local pass_actions = AddSubMenu(context, "Разрешение на вступление", "icons/fa32/lock.png")
					local has = target:GetNetVar("HasPass", false)
					if not has then
						AddOption(pass_actions, "Выдать разрешение", "icons/fa32/unlock.png", UI_Request("Выдача разрешения " .. name, "Введите причину выдачи разрешения", function(reason) netstream.Start("GivePass", target, reason, true) end))
					else
						AddOption(pass_actions, "Отозвать разрешение", "icons/fa32/lock.png", UI_Request("Отзыв разрешения " .. name, "Введите причину отзыва разрешения", function(reason) netstream.Start("GivePass", target, reason) end))
					end
				end

				if LocalPlayer():getJobTable().loyalmap then
					local loyality_actions = AddSubMenu(context, "Лояльность", "icons/fa32/check-circle-o.png")
					AddOption(loyality_actions, "Повысить лояльность", "icons/fa32/plus-circle.png", UI_Request("Повышение лояльности " .. name, "Введите количество очков лояльности ( от 1 до 10 )", function(num)
						num = tonumber(num)
						if not num then
							notification.AddLegacy("Неверное количество очков", NOTIFY_ERROR, 5)
							return
						end

						UI_Request("Повышение лояльности " .. name, "Введите причину повышения лояльности", function(reason) netstream.Start("Union.LoyalPoints", ply, num, reason) end)()
					end))

					AddOption(loyality_actions, "Понизить лояльность", "icons/fa32/minus-circle.png", UI_Request("Понижение лояльности " .. name, "Введите количество очков лояльности ( от 1 до 10 )", function(num)
						num = tonumber(num)
						if not num then
							notification.AddLegacy("Неверное количество очков", NOTIFY_ERROR, 5)
							return
						end

						UI_Request("Понижение лояльности " .. name, "Введите причину понижения лояльности", function(reason) netstream.Start("Union.LoyalPoints", ply, num, reason, true) end)()
					end))
				end

				if LocalPlayer():Team() == TEAM_GSR4 or LocalPlayer():isGSRCMD() then
					AddOption(context, "Добавить медицинскую запись", "icons/fa32/medkit.png", UI_Request("Добавление медицинской записи " .. name, "Введите текст записи", function(info)
						netstream.Start("PDA.AddEntry", ply, info, "med_logs")
					end))
				end
				if LocalPlayer():isCP() or LocalPlayer():isGSRCMD() and not LocalPlayer().Disguised then
					AddOption(context, "Добавить заметку", "icons/fa32/sticky-note-o.png", UI_Request("Добавление заметки " .. name, "Введите текст заметки", function(info)
						netstream.Start("PDA.AddEntry", ply, info, "notes")
					end))
				end
				context:Open()
			end
		}
	}

	local player_buttons_skip = panels_w * .005
	local actual_panels_w = panels_w / #p_buttons - (#p_buttons - 1) * player_buttons_skip

	for k, v in ipairs(p_buttons) do
		local b = player_buttons:Add("DButton")
		b:SetText("")
		b:SetWide(actual_panels_w)
		--b:DockMargin(player_buttons_skip, 0, player_buttons_skip, 0)
		b:Dock(LEFT)
		b:SetText(v[2])
		b:SetTextColor(color_white)
		b:SetFont("PDA.SmallerButton")

		local hovered, non_hovered = v[1], ColorAlpha(v[1], 100)
		function b:Paint(bw, bh)
			surface.SetDrawColor(self:IsHovered() and non_hovered or non_hovered)
			surface.DrawRect(0, 0, bw, bh)

			surface.SetDrawColor(hovered)
			surface.DrawOutlinedRect(0, 0, bw, bh, 2)
		end

		function b:DoClick()
			v[3](ply)
		end
	end

	local pnl = screen:Add("DPanel")
	pnl:DockMargin(sides_skip, 0, sides_skip, sides_skip)
	pnl:Dock(FILL)
	function pnl:Paint(bw, bh)
		surface.SetDrawColor(col.o)
		surface.DrawOutlinedRect(0, 0, bw, bh, 2)
	end

	local buttons = pnl:Add("EditablePanel")
	buttons:SetTall(h * 0.05)
	buttons:SetWide(w - sides_skip * 2)
	buttons:Dock(TOP)

	local scroll = pnl:Add("DScrollPanel")
	--scroll:ErisScrollbar()
	scrolledit(scroll)
	scroll:DockMargin(sides_skip, 2, sides_skip, 2)
	scroll:Dock(FILL)
	local function Add(bcol, reason, info, who, time)
		local short_info = utf8.len(info) > 30 and utf8.sub(info, 1, 30) .. "..." or info
		local date = os.date("%H:%M %d.%m", time)
		local pnl = scroll:Add("DPanel")
		pnl:SetTall(h * .1)
		pnl:DockMargin(0, 8, 0, 8)
		pnl:Dock(TOP)
		function pnl:Paint(bw, bh)
			surface.SetDrawColor(col.oa)
			surface.DrawRect(0, 0, bw, bh)
		end

		local b = pnl:Add("DButton")
		b:SetTall(h * .1)
		b:Dock(TOP)
		b:SetText("")
		function b:Paint(bw, bh)
			local xl, xr = bw * .015, bw * .985
			local y = bh * .5
			draw.RoundedBox(4, 0, 0, bw, bh, bcol)
			draw.SimpleText(reason, "PDA.Buttons", xl, y, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(short_info, "PDA.Buttons", xl, y, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

			draw.SimpleText(who, "PDA.Buttons", xr, y, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(date, "PDA.Buttons", xr, y, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end

		function b:DoClick()
			pnl.open = not pnl.open
			pnl:SizeTo(pnl:GetWide(), pnl.open and h * .2 or h * .1, 0.2, 0, -1, function() pnl:InvalidateParent(true) end)
		end

		local reason_scroll = pnl:Add("DScrollPanel")
		--reason_scroll:ErisScrollbar()
		scrolledit(reason_scroll)
		reason_scroll:DockMargin(4, 4, 4, 4)
		reason_scroll:Dock(FILL)

		local reason_text = Label(info, reason_scroll)
		reason_text:SetFont("PDA.Buttons")
		reason_text:SetWrap(true)
		reason_text:SetAutoStretchVertical(true)
		reason_text:Dock(FILL)
	end


	local buttons_tbl = {
		{"ЗАМЕТКИ", tbl.notes},
		{"ЛОЯЛЬНОСТЬ", tbl.loyality_logs},
		{"МЕД. ЗАПИСИ", tbl.med_logs},
		{"ВЫГОВОРЫ", tbl.reprimands}
	}
	local buttons_sorted = {}
	for _, inf in ipairs(buttons_tbl) do
		if inf[2] then table.insert(buttons_sorted, inf) end
	end

	cur_active = 1
	for button_id, v in ipairs(buttons_sorted) do
		local btbl = v[2]
		local b = buttons:Add("DButton")
		b:SetWide(buttons:GetWide() / #buttons_sorted)
		b:Dock(LEFT)
		b:SetText(v[1])
		b:SetTextColor(color_white)
		b:SetFont("PDA.Buttons")

		function b:Paint(bw, bh)
			if self:IsHovered() or button_id == cur_active then
				surface.SetDrawColor(col.o)
			else
				surface.SetDrawColor(col.oa)
			end

			surface.DrawRect(0, 0, bw, bh)
			surface.SetDrawColor(col.o)
			surface.DrawOutlinedRect(0, 0, bw, bh, 2)
		end

		function b:DoClick()
			scroll:Clear()
			cur_active = button_id
			for _, cit_entry in ipairs(btbl) do
				Add(unpack(cit_entry))
			end
		end

		if cur_active == button_id then b:DoClick() end
	end

	cur_add = Add
end

DarkRP.PDACache = DarkRP.PDACache or {}
local function RequestPlayerData(cid)
	cid = string.Replace(cid, "#", "")
	local data = DarkRP.PDACache[cid]
	if data then
		OpenPlayerInfo(data)
		return
	end

	netstream.Start("PDA.OpenPlayerInfo", cid)
end

netstream.Hook("PDA.OpenPlayerInfo", function(cid, data)
	data.CID = cid
	DarkRP.PDACache[cid] = data
	OpenPlayerInfo(data)
end)

local add_to_id = {
	["notes"] = 1,
	["loyality_logs"] = 2,
	["med_logs"] = 3,
	["reprimands"] = 4,
}

local function AddToExisting(cid, tab, data)
	if not IsValid(PDA.Screen) or PDA.Page ~= "player_info" or not cur_tbl or cur_tbl.CID ~= cid then return end
	if not istable(cur_tbl[tab]) then
		cur_tbl[tab] = data
		return
	end

	cur_tbl[tab] = cur_tbl[tab] or {}
	--table.insert(cur_tbl[tab], data)
	if add_to_id[tab] == cur_active then cur_add(unpack(data)) end
end

netstream.Hook("PDA.AddEntry", function(cid, tab, data)
	local user = DarkRP.PDACache[cid]
	if not user then return end
	local tbl = user[tab]
	if not istable(tbl) then
		user[tab] = data
		return
	end

	user[tab] = user[tab] or {}
	table.insert(user[tab], data)
	AddToExisting(cid, tab, data)
end)

netstream.Hook("PDA.RemovePlayer", function(cid)
	DarkRP.PDACache[cid] = nil
end)

local function GetMinimapLayer(z, lp)
	local id = 1
	local map = minimaps[id][2]
	for k, v in ipairs(minimaps) do
		if z > v[1] then
			id = k
			map = v[2]
		end
	end

	if id == 1 and lp:isRebel() then map = canals_rebel end
	return id, map
end

-- Function for define page
local key_to_button = {}
local buttons_pos = {}
local pages = {}
local map_pages = {}

local function definePage(name, tooltip, key, x, size, func)
	local idx = map_pages[name] or #pages + 1
	map_pages[name] = idx
	pages[idx] = func

	local tbl = {
		x = x,
		size = size,
		tooltip = tooltip,
		func = function(self)
			if PDA then
				PDA.SetPage(map_pages[name])
			end
		end
	}

	table.insert(buttons_pos, tbl)
	if key then
		key_to_button[key] = tbl
	end
end

local bind_key_convar = CreateClientConVar("union_pda_bind_key", KEY_M, true, false, "Биндит вашу кнопку на открытие планшета.")
function OpenPDA()
	if PDA and IsValid(PDA) then PDA:Remove() end
	if not LocalPlayer():Alive() or LocalPlayer():IsHandcuffed() then return end

	local blur = vgui.Create("EditablePanel")
	blur:SetSize(ScrW(), ScrH())
	blur:SetZPos(32767)

	local now = RealTime()
	local anim_time = 0.2
	function blur:Paint(bw, bh)
		if not IsValid(PDA) then return end
		local blurnow = RealTime() - now
		local blurcol = ColorAlpha(col.ba, Lerp(blurnow / anim_time, 0, 200))
		draw.RoundedBox(0, 0, 0, bw, bh, blurcol)
	end

	local diode
	PDA = vgui.Create("DFrame")
	PDA:ShowCloseButton(false)
	PDA:SetTitle("")
	PDA:SetSize(x_size, y_size)
	local pda_mat = LocalPlayer():isCP() and pda_mats.alliance or pda_mats.citizen
	function PDA:PaintOver(bw, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(pda_mat)
		surface.DrawTexturedRect(0, 0, bw, bh)

		diode:PaintManual()
	end
	function PDA:Think()
		if not LocalPlayer():Alive() then
			self:Close()
		end
	end

	PDA:SetAlpha(0)
	PDA:AlphaTo(255, anim_time, 0)

	function PDA:Paint()
		return
	end

	--function PDA:Paint(bw, bh)
	--  surface.SetDrawColor(255, 255, 255)
	--  surface.SetMaterial(mat)
	--  surface.DrawTexturedRect(0, 0, bw, bh)
	--end
	function PDA:OnRemove()
		hook.Remove("OnPauseMenuShow", "PDA")
		if IsValid(blur) then blur:Remove() end
	end

	hook.Add("OnPauseMenuShow", "PDA", function()
		PDA:Remove()
		return false
	end, HOOK_HIGH)

	PDA:Center()

	local pda_background = PDA:Add("EditablePanel") -- Screen + Buttons
	pda_background:SetSize(box_w, box_h)
	pda_background:SetPos(skip_w, skip_h)

	local pda_screen = pda_background:Add("DPanel")
	pda_screen:SetSize(box_w, screen_h)
	pda_screen:Dock(TOP)
	PDA.Screen = pda_screen

	function pda_screen:Paint(bw, bh)
		surface.SetDrawColor(col_back)
		surface.DrawRect(0, 0, bw, bh)
	end

	local pda_buttons = pda_background:Add("EditablePanel")
	pda_buttons:SetSize(box_w, buttons_h)
	pda_buttons:Dock(BOTTOM)

	local function SetPage(id)
		PDA.Page = id
		local screen = pda_screen
		screen:Clear()
		local page = pages[id]
		if not page then
			local label = Label("404 - NOT FOUND", screen)
			label:SetFont("PDA.CID")
			label:SizeToContents()
			label:Center()
			return
		end

		page(screen, screen:GetWide(), screen:GetTall())
		screen:InvalidateChildren()
	end

	PDA.SetPage = SetPage

	function PDA:OnKeyCodeReleased(key)
		local but = key_to_button[key]
		if but and but.func then
			but.func(but.button)
			return true
		end

		if bind_key_convar:GetInt() == key then
			self:Remove()
			return true
		end
	end

	PDA:MakePopup()
	SetPage(1)
	for _, tbl in ipairs(buttons_pos) do
		local x, y = tbl.x * x_size, tbl.y or 0
		local size_x, size_y = tbl.size * f_size, tbl.h or buttons_h
		local button = pda_buttons:Add("DButton")
		tbl.button = button
		button:SetPos(x, y)
		button:SetSize(size_x, size_y)
		button:SetText("")
		button:SetTooltip(tbl.tooltip)

		button.Paint = tbl.paint or function() end
		button.DoClick = tbl.func or function() end
	end

	local diode_x, diode_y = x_size * 0.75302942873 - skip_w, y_size * 0.89355539464 - skip_h
	local diode_size = x_size * 0.00724112961
	local diode_round = diode_size * 0.5
	local diode_col1, diode_col2 = Color(242, 66, 66), Color(94, 189, 75)

	diode = pda_background:Add("DPanel")
	diode:SetPos(diode_x, diode_y)
	diode:SetSize(diode_size, diode_size)
	diode:SetPaintedManually(true)

	diode.Paint = function(self, bw, bh)
		local diode_col = os.time() % 2 == 0 and diode_col1 or diode_col2
		draw.RoundedBox(diode_round, 0, 0, bw, bh, diode_col)
	end
end

--x_size * 0.57761107905366, -- Diode
definePage("Mouse", "Карта", nil, 0.65781881130987, 1.7222222222222, TEAM_GORDON and not minimaps[1][2]:IsError() and function(screen, w, h)
	local lp = LocalPlayer()
	local minimap_id, minimap_mat = GetMinimapLayer(lp:GetPos().z, lp)
	local bound1, bound2 = game.GetWorld():GetModelBounds()
	local map_w = math.abs(bound1.x - bound2.x)
	local map_h = math.abs(bound1.y - bound2.y)
	local map = screen:Add("DPanel")
	local map_overlay = screen:Add("EditablePanel")

	local function PosToMinimap(vec)
		local x = (vec.x - bound1.x) / map_w
		local y = 1 - (vec.y - bound1.y) / map_h
		return x, y
	end

	local function MinimapToPos(cursor_x, cursor_y)
		local vec = Vector()
		local cur_map_w, cur_map_h = map:GetSize()
		vec.x = bound1.x + map_w * (cursor_x / cur_map_w)
		vec.y = bound1.y + map_h * (1 - cursor_y / cur_map_h) -- Инвертируем ось Y
		return vec
	end

	local function MinimapCenterAt(x, y)
		local cur_map_w, cur_map_h = map:GetSize()
		x, y = x * cur_map_w, y * cur_map_h

		map_overlay:MoveMap(-x + w * .5, -y + h * .5)
	end

	map_overlay:SetSize(w, h)
	local min_scale = w / map_w
	if h / map_h < min_scale then min_scale = h / map_h end

	local max_scale = min_scale * 10

	map.zoom = min_scale * 2
	map.zoom_min = min_scale
	map.zoom_max = max_scale
	map.zoom_speed = min_scale * 0.1

	map.x = 0
	map.y = 0

	map_overlay:SetMouseInputEnabled(true)
	map:SetSize(map_w * map.zoom, map_h * map.zoom)

	function map_overlay:OnMouseWheeled(delta)
		if map.zoom == map.zoom_min and delta < 0 then return end
		local old_cursor_x, old_cursor_y = map:CursorPos()
		local old_pos_scale_x, old_pos_scale_y = old_cursor_x / map:GetWide(), old_cursor_y / map:GetTall()
		map.zoom = math.Clamp(map.zoom + delta * map.zoom_speed, map.zoom_min, map.zoom_max)
		local new_w, new_h = map_w * map.zoom, map_h * map.zoom
		map:SetSize(new_w, new_h)
		local new_cursor_x, new_cursor_y = old_pos_scale_x * new_w, old_pos_scale_y * new_h
		local x, y = map.x - (new_cursor_x - old_cursor_x), map.y - (new_cursor_y - old_cursor_y)
		self:MoveMap(x, y)
	end

	function map_overlay:MoveMap(x, y)
		map:SetSize(map_w * map.zoom, map_h * map.zoom)
		if x > 0 then
			x = 0
		elseif x < w - map:GetWide() then
			x = w - map:GetWide()
		end

		if y > 0 then
			y = 0
		elseif y < h - map:GetTall() then
			y = h - map:GetTall()
		end

		map:SetPos(x, y)
		map.x, map.y = x, y
	end

	function map_overlay:OnMousePressed(key)
		if key == MOUSE_LEFT and map.zoom ~= map.zoom_min then
			self:SetCursor("sizeall")
			map.dragging = {
				x = gui.MouseX() - map.x,
				y = gui.MouseY() - map.y
			}
		elseif key == MOUSE_RIGHT then
			local x, y = map:CursorPos()
			local vec = MinimapToPos(x, y)
			vec.z = lp:GetPos().z
			local current_gps = gps:IsActive()
			if current_gps then
				local point = gps:GetPoint(current_gps)
				local pos = point.pos
				if pos:Distance2D(vec) < 256 then
					gps:Deactivate()
					return
				end
			end

			gps.config.pointsList["Метка с планшета"] = {
				category = "Планшет",
				pointData = {
					pos = vec,
					icon = "arrow_up",
				}
			}

			gps:Activate("Метка с планшета")
		end
	end

	function map_overlay:OnMouseReleased(key)
		if key == MOUSE_LEFT then
			self:SetCursor("arrow")
			map.dragging = nil
		end
	end

	function map_overlay:Think()
		if map.dragging then
			local x = gui.MouseX() - map.dragging.x
			local y = gui.MouseY() - map.dragging.y
			map_overlay:MoveMap(x, y)
			if not input.IsMouseDown(MOUSE_LEFT) then self:OnMouseReleased(MOUSE_LEFT) end
		end
	end

	local members = {}
	local squad = DarkRP.Squads.GetPlayerGroupID(lp)
	if squad then
		for k, v in player.Iterator() do
			local layer_id, _ = GetMinimapLayer(v:GetPos().z, lp)
			if DarkRP.Squads.GetPlayerGroupID(v) == squad and layer_id == minimap_id then
				local cur_col = lp == v and col.o or v:GetTeamColor()
				table.insert(members, {
					ply = v,
					col = cur_col
				})
			end
		end
	else
		table.insert(members, {
			ply = lp,
			col = col.o
		})
	end

	local lp_pos = lp:GetPos()
	MinimapCenterAt(PosToMinimap(lp_pos))
	local poses = {}
	for k, v in pairs(DarkRP.Zones.List) do
		local name = v.name
		local bounds = v.pos
		local start_z, end_z = bounds[1].z, bounds[2].z
		if start_z > end_z then start_z, end_z = end_z, start_z end
		if lp_pos.z < start_z or lp_pos.z > end_z then continue end

		local start_x, start_y = PosToMinimap(bounds[1])
		local end_x, end_y = PosToMinimap(bounds[2])
		if start_x > end_x then start_x, end_x = end_x, start_x end
		if start_y > end_y then start_y, end_y = end_y, start_y end

		table.insert(poses, {name, start_x, start_y, end_x, end_y})
	end

	local marker = Material("icons/fa32/map-marker.png")
	local player_marker = Material("icons/fa32/location-arrow.png")
	function map:Paint(bw, bh)
		local mouse_x, mouse_y = self:CursorPos()

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(minimap_mat)
		surface.DrawTexturedRect(0, 0, bw, bh)

		for k, v in ipairs(poses) do
			local name, start_x, start_y, end_x, end_y = unpack(v)
			local x, y = start_x * bw, start_y * bh
			local w, h = (end_x - start_x) * bw, (end_y - start_y) * bh
			--draw.RoundedBox(0, x, y, w, h, col.oa)
			--surface.SetDrawColor(col.oa)
			--surface.DrawOutlinedRect(x, y, w, h, 2)
			if mouse_x > x and mouse_x < x + w and mouse_y > y and mouse_y < y + h then

				local text_pos_x, text_pos_y = x + w * .5, y + h * .5
				draw.SimpleText(name, "PDA.MapFont", text_pos_x + 2, text_pos_y + 2, col.b, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText(name, "PDA.MapFont", text_pos_x, text_pos_y, col.o, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		local is_active = gps:IsActive()
		if gps:IsActive() then
			local point = gps:GetPoint(is_active)
			if point then
				local size = 200 * map.zoom
				local x, y = PosToMinimap(point.pos)
				surface.SetDrawColor(col.o.r, col.o.g, col.o.b, 255)
				surface.SetMaterial(marker)
				surface.DrawTexturedRect(x * bw - size * .5, y * bh - size, size, size)
			end
		end

		local size = 200 * map.zoom
		for k, v in ipairs(members) do
			local ply, tcol = v.ply, v.col
			if IsValid(ply) then
				local x, y = PosToMinimap(ply:GetPos())
				local ang = ply:EyeAngles().y - 90 + 45
				surface.SetDrawColor(tcol.r, tcol.g, tcol.b, 255)
				surface.SetMaterial(player_marker)
				surface.DrawTexturedRectRotated(x * bw, y * bh, size, size, ang)
				--surface.DrawTexturedRect(x * bw - size * .5, y * bh - size * .5, size, size)
			end
		end

		if minimap_id == 1 then
			local x, y = map_overlay:LocalToScreen(0, 0)
			local ow, oh = map_overlay:GetSize()
			render.SetScissorRect(x, y, x + ow, y + oh, true)
			cam.Start2D()
			surface.SetMaterial(minimap_mat)
			renderGlith(x, y, ow, oh, 32, 16, map.zoom * 25)
			cam.End2D()
			render.SetScissorRect(0, 0, 0, 0, false)
		end
	end
end)
definePage("Logo", "Информация", nil, 0.3669936526255, 1.1851851851852, function(screen, w, h)
	local lp = LocalPlayer()
	local capture_icon = Material("icons/fa32/exclamation.png")
	local header_h = name_fontsize * 2
	local sides_skip = w * 0.01
	local panels_w = w - sides_skip * 2

	local header = screen:Add("DPanel")
	header:SetTall(header_h)
	header:DockMargin(sides_skip, h * 0.005, sides_skip, h * 0.005)
	header:Dock(TOP)

	local dlabel_name = Label(lp:Name(), header)
	dlabel_name:SetFont("PDA.Name")
	dlabel_name:SetTextColor(name_col)
	dlabel_name:SizeToContents()
	dlabel_name:Dock(TOP)

	local dlabel_cid = Label("##" .. lp:GetCID(), header)
	dlabel_cid:SetFont("PDA.CID")
	dlabel_cid:SetTextColor(cid_col)
	dlabel_cid:SizeToContents()
	dlabel_cid:Dock(TOP)

	local logo_size = header_h - 4
	local logo_x = panels_w - logo_size - 4
	local job = team.GetName(lp:GetNetVar("TeamNum", lp:Team()))
	local zone = lp:GetNiceZone()
	local agenda_info = lp:getAgenda()
	local agenda_text = lp:getDarkRPVar("agenda") or "Отсутствует"
	local title = agenda_info and agenda_info.Title or "Название не найдено"
	function header:Paint(header_w, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(logo_x, 0, logo_size, logo_size)

		draw.SimpleText("Информация", "PDA.Buttons", logo_x, 0, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(job, "PDA.Buttons", logo_x, button_fontsize, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(zone, "PDA.Buttons", logo_x, button_fontsize * 2, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.RoundedBox(0, 0, logo_size, w, 2, col.o)
	end

	if agenda_info then
		local pnl = screen:Add("DPanel")
		pnl:DockMargin(sides_skip, 0, sides_skip, sides_skip)
		pnl:SetTall(h * .3)
		pnl:Dock(TOP)
		function pnl:Paint(bw, bh)
			surface.SetDrawColor(col.o)
			surface.DrawOutlinedRect(0, 0, bw, bh, 2)
		end

		local dlabel_agenda = Label(title, pnl)
		dlabel_agenda:SetFont("PDA.Name")
		dlabel_agenda:SetTextColor(name_col)
		dlabel_agenda:SetContentAlignment(5)
		dlabel_agenda:SizeToContents()
		dlabel_agenda:Dock(TOP)

		local text_scroll = pnl:Add("DScrollPanel")
		--text_scroll:ErisScrollbar()
		scrolledit(text_scroll)
		text_scroll:DockMargin(4, 4, 4, 4)
		text_scroll:Dock(FILL)
		text_scroll:InvalidateLayout(true)

		local rich = Label(agenda_text, text_scroll)
		rich:SetFont("PDA.Buttons")
		rich:SetWrap(true)
		rich:SetAutoStretchVertical(true)
		rich:Dock(FILL)
		rich:SetMouseInputEnabled(true)

		function rich:DoClick()
			SetClipboardText(agenda_text)
			notification.AddLegacy("Текст был скопирован в буфер обмена", NOTIFY_GENERIC, 5)
		end
	end

	local function GetPoints(scroll)
		for k, v in pairs(DarkRP.CPoints.points) do
			local name = v.name
			local owner = v.owner == "alliance" and "Альянс" or v.owner == "rebels" and "Сопротивление" or "Неизвестно"
			local cooldown = v.newcooldown or 0
			local capture = v.endofcapture or 0
			local b = scroll:Add("DButton")
			b:SetTall(h * .1)
			b:Dock(TOP)
			b:DockMargin(0, 8, 0, 8)
			b:SetText("")
			function b:Paint(bw, bh)
				local xl, xr = bw * .015, bw * .985
				local y = bh * .5
				draw.RoundedBox(4, 0, 0, bw, bh, col.oa)
				local name_pos = xl
				if v.capture then
					surface.SetDrawColor(col.o)
					surface.SetMaterial(capture_icon)
					surface.DrawTexturedRect(xl, 0, button_fontsize, button_fontsize)
					name_pos = name_pos + button_fontsize + 4
				end

				draw.SimpleText(name, "PDA.Buttons", name_pos, y, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(owner, "PDA.Buttons", xl, y, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

				local wait = cooldown > CurTime() and string.format("%s", string.ToMinutesSeconds(cooldown - CurTime())) or ""
				draw.SimpleText(wait, "PDA.Buttons", xr, y, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				local raid = capture > CurTime() and string.format("%s", string.ToMinutesSeconds(capture - CurTime())) or ""
				draw.SimpleText(raid, "PDA.Buttons", xr, y, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end
		end
	end

	local function GetResources(scroll)
		local is_rebel = lp:isRebel()
		local allowed = is_rebel and {
			["Каналы"] = true,
			["Старый завод"] = true
		} or lp:isGSR() and {
			["Цитадель"] = true,
			["Складское помещение охраны"] = true,
			["Офис ГСР"] = true,
			["Холл вокзала"] = true,
		} or {
			["Цитадель"] = true,
			["Складское помещение охраны"] = true,
			["Холл вокзала"] = true,
		}

		local function Add(lu, ld, ru, rd, pos)
			local b = scroll:Add("DButton")
			b:SetTall(h * .1)
			b:Dock(TOP)
			b:DockMargin(0, 8, 0, 8)
			b:SetText("")
			function b:Paint(bw, bh)
				local xl, xr = bw * .015, bw * .985
				local y = bh * .5
				draw.RoundedBox(4, 0, 0, bw, bh, col.oa)
				draw.SimpleText(lu or "", "PDA.Buttons", xl, y, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(ld or "", "PDA.Buttons", xl, y, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)

				draw.SimpleText(ru or "", "PDA.Buttons", xr, y, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				draw.SimpleText(rd or "", "PDA.Buttons", xr, y, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
			end

			function b:DoClick()
				if not pos then return end
				--Marks:AddPoint(lu, "pda_mark", pos, 60, "arrow_up", 6000, "Friends/message.wav")
				gps.config.pointsList[lu] = {
					category = "Планшет",
					pointData = {
						pos = pos,
						icon = "map",
					}
				}

				gps:Activate(lu)
			end
			return b
		end

		for k, v in ipairs(ents.FindByClass("union_fooddispenser")) do
			local food = v:GetFoodCount() .. "/" .. v._maxCount
			local pos = v:GetPos() + Vector(0, 0, 8)
			local food_zone = DarkRP.Zones.GetZone(pos)
			if allowed[food_zone] then Add("Еда", food_zone, food, nil, pos) end
		end

		for k, v in ipairs(ents.FindByClass("rationdispencer")) do
			if not v.GetAmount then break end
			local amount = v:GetAmount()
			local status = v:GetDisabled() and "Отключен" or "Включен"
			local pos = v:GetPos() + Vector(0, 0, 8)
			local ration_zone = DarkRP.Zones.GetZone(pos)
			if allowed[ration_zone] then Add("Рационы", ration_zone, amount, status, pos) end
		end

		if is_rebel then
			for k, v in ipairs(ents.FindByClass("union_fooddispenser_rebel")) do
				local food = v:GetFoodCount() .. "/" .. v._maxCount
				local pos = v:GetPos() + Vector(0, 0, 8)
				local food_zone = DarkRP.Zones.GetZone(pos)
				Add("Еда", food_zone, food, nil, pos)
			end

			for k, v in ipairs(ents.FindByClass("rebel_stove")) do
				local ready_food = v:GetReadyFood()
				local stolen_food = v:GetStolenFood()
				local pos = v:GetPos() + Vector(0, 0, 8)
				local food_zone = DarkRP.Zones.GetZone(pos)
				Add("Плита", food_zone, "Готово: " .. ready_food, "Украдено: " .. stolen_food, pos)
			end

			for k, v in ipairs(ents.FindByClass("u_ammo_crate_r")) do
				local ammo = GetGlobalInt("Rebel.Ammo", 0)
				local pos = v:GetPos() + Vector(0, 0, 8)
				local ammo_zone = DarkRP.Zones.GetZone(pos)
				local lp_ammo = lp:GetNW2Int("Rebel.Ammo", 0)
				Add("Патроны", ammo_zone, string.Comma(ammo), lp_ammo > 0 and "На руках: " .. string.Comma(lp_ammo) or "", pos)
			end

			for k, v in ipairs(ents.FindByClass("unionrp_teleport")) do
				local pos = v:GetPos() + Vector(0, 0, 8)
				local teleport_zone = DarkRP.Zones.GetZone(pos)
				local broken = v:GetNetVar("Destroyed") and "Сломан" or ""
				Add("Телепорт", teleport_zone, broken, nil, pos)
			end

			for k, v in ipairs(ents.FindByClass("rebeldrawer")) do
				local pos = v:GetPos() + Vector(0, 0, 8)
				local drawer_zone = DarkRP.Zones.GetZone(pos)
				local dresses = v:GetDressCount()
				local cids = v:GetCIDCount()
				Add("Оружейная", drawer_zone, "Форм: " .. string.Comma(dresses), "CID: " .. string.Comma(cids), pos)
			end
		end

		for k, v in ipairs(ents.FindByClass("bed_heal")) do
			local heal = v:GetHealPoints() .. "/" .. v.MaxHealPoints
			local pos = v:GetPos() + Vector(0, 0, 8)
			local heal_zone = DarkRP.Zones.GetZone(pos)
			if allowed[heal_zone] then Add("Кровать", heal_zone, heal, nil, pos) end
		end
	end

	local buttons_tbl = lp:isGSR() and {
		{"Ресурсы", GetResources}
	} or {
		{"Точки", GetPoints},
		{"Ресурсы", GetResources}
	}
	local pnl2 = screen:Add("DPanel")
	pnl2:DockMargin(sides_skip, 0, sides_skip, sides_skip)
	pnl2:Dock(FILL)
	function pnl2:Paint(bw, bh)
		surface.SetDrawColor(col.o)
		surface.DrawOutlinedRect(0, 0, bw, bh, 2)
	end

	local buttons = pnl2:Add("EditablePanel")
	buttons:SetTall(h * 0.05)
	buttons:SetWide(w - sides_skip * 2)
	buttons:Dock(TOP)

	local scroll = pnl2:Add("DScrollPanel")
	--scroll:ErisScrollbar()
	scrolledit(scroll)
	scroll:DockMargin(sides_skip, 2, sides_skip, 2)
	scroll:Dock(FILL)
	local buttons_sorted = {}
	for _, inf in ipairs(buttons_tbl) do
		if inf[2] then table.insert(buttons_sorted, inf) end
	end

	local active = 1
	for button_id, v in ipairs(buttons_sorted) do
		local btbl = v[2]
		local b = buttons:Add("DButton")
		b:SetWide(buttons:GetWide() / #buttons_sorted)
		b:SetText(v[1])
		b:SetFont("PDA.Buttons")
		b:SetTextColor(color_white)
		b:Dock(LEFT)
		function b:Paint(bw, bh)
			if self:IsHovered() or button_id == active then
				surface.SetDrawColor(col.o)
			else
				surface.SetDrawColor(col.oa)
			end

			surface.DrawRect(0, 0, bw, bh)
			surface.SetDrawColor(col.o)
			surface.DrawOutlinedRect(0, 0, bw, bh, 2)
		end

		function b:DoClick()
			scroll:Clear()
			active = button_id
			btbl(scroll)
		end

		if active == button_id then b:DoClick() end
	end
end)
definePage("F1", "Поиск", KEY_F1, 0.14137334102712, 1, function(screen, w, h)
	-- Информация о юните
	if not LocalPlayer():isCP() and not LocalPlayer():isGSR() then
		local label = Label("NO ACCESS", screen)
		label:SetFont("PDA.CID")
		label:SizeToContents()
		label:Center()
		return
	end

	local entry_info = screen:Add("EditablePanel")
	entry_info:SetSize(w * .5, h * .35)
	entry_info:Center()

	local dlabel = Label("Введите CID", entry_info)
	dlabel:SetTall(entry_info:GetTall() / 3)
	dlabel:Dock(TOP)
	dlabel:SetTextColor(color_white)
	dlabel:SetFont("PDA.Name")
	dlabel:SetContentAlignment(5)
	local entry_panel = entry_info:Add("DPanel")
	entry_panel:SetTall(entry_info:GetTall() / 3)
	entry_panel:Dock(TOP)
	function entry_panel:Paint(bw, bh)
		surface.SetDrawColor(col.oa)
		surface.DrawRect(0, 0, bw, bh)
		surface.SetDrawColor(col.o)
		surface.DrawOutlinedRect(0, 0, bw, bh, 2)
	end

	local entry = entry_panel:Add("DTextEntry")
	entry:Dock(FILL)
	entry:SetFont("PDA.Name")
	entry:SetPaintBackground(false)
	entry:SetTextColor(color_white)
	entry:SetCursorColor(color_white)
	entry:SetText(LocalPlayer():GetCID())
	local red = Color(200, 20, 20)
	function entry:OnChange()
		local val = string.Replace(self:GetText(), "#", "")
		local cid = tonumber(val)
		if not cid or string.len(val) > 5 then
			dlabel:SetTextColor(red)
		else
			dlabel:SetTextColor(color_white)
		end
	end

	local searchbut = entry_info:Add("DButton")
	searchbut:SetTall(entry_info:GetTall() / 3.5)
	searchbut:Dock(BOTTOM)
	searchbut:SetText("Поиск")
	searchbut:SetFont("PDA.Name")
	searchbut:SetTextColor(color_white)
	function searchbut:Paint(bw, bh)
		surface.SetDrawColor(self:IsHovered() and col.o or col.oa)
		surface.DrawRect(0, 0, bw, bh)
		surface.SetDrawColor(col.o)
		surface.DrawOutlinedRect(0, 0, bw, bh, 2)
	end

	function searchbut:DoClick()
		screen:Clear()
		local logo_size = h * .25
		local logo_x, logo_y = (w - logo_size) * .5, (h - logo_size) * .5
		local loading = Material("icons/fa32/spinner.png")
		local loading_size = h * .05
		local loading_x, loading_y = (w - loading_size) * .5 + loading_size * .5, logo_y + logo_size + loading_size * .5
		local waiting = screen:Add("DPanel")
		waiting:Dock(FILL)
		function waiting:Paint(bw, bh)
			local ang = RealTime() * 25 % 360
			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(logo)
			surface.DrawTexturedRect(logo_x, logo_y, logo_size, logo_size)

			surface.SetDrawColor(255, 255, 255)
			surface.SetMaterial(loading)
			surface.DrawTexturedRectRotated(loading_x, loading_y, loading_size, loading_size, ang)
		end

		--OpenPlayerInfo(citizen_info)
		RequestPlayerData(entry:GetText())
	end
	--local scroll = screen:Add("DScrollPanel")
	--scroll:ErisScrollbar()
	--scroll:DockMargin(sides_skip, 0, sides_skip, 0)
	--scroll:Dock(FILL)
	--for i = 1, 100 do
	--  local b = scroll:Add("DButton")
	--  b:Dock(TOP)
	--  b:DockMargin(0, 2, 0, 2)
	--  function b:Paint(bw, bh)
	--    draw.RoundedBox(4, 0, 0, bw, bh, col.oa)
	--  end
	--end
end)
definePage("F2", "Управление составом", KEY_F2, 0.17830351990767, 1, function(screen, w, h)
	local icon_inactive, icon_active = Material("icons/fa32/chevron-left.png"), Material("icons/fa32/chevron-down.png")
	local group_icon = Material("icons/fa32/users.png")
	local leader_material, disabled_speaker, enabled_speaker = Material("icons/fa32/star.png"), Material("icons/fa32/assistive-listening-systems.png"), Material("icons/fa32/volume-up.png")
	local warns = Material("icons/fa32/balance-scale.png")
	local force_disabled_voice, force_enabled_voice, make_leader = Material("icons/fa32/microphone-slash.png"), Material("icons/fa32/microphone.png"), Material("icons/fa32/id-badge.png")
	local profile = Material("icons/fa32/user-circle.png")

	local lp = LocalPlayer()
	local jobtbl = LocalPlayer():getJobTable()
	local header_h = name_fontsize * 2
	local sides_skip = w * 0.01
	local panels_w = w - sides_skip * 2

	local header = screen:Add("DPanel")
	header:SetTall(header_h)
	header:DockMargin(sides_skip, h * 0.005, sides_skip, h * 0.005)
	header:Dock(TOP)

	local dlabel_name = Label(lp:Name(), header)
	dlabel_name:SetFont("PDA.Name")
	dlabel_name:SetTextColor(name_col)
	dlabel_name:SizeToContents()
	dlabel_name:Dock(TOP)

	local dlabel_cid = Label("##" .. lp:GetCID(), header)
	dlabel_cid:SetFont("PDA.CID")
	dlabel_cid:SetTextColor(cid_col)
	dlabel_cid:SizeToContents()
	dlabel_cid:Dock(TOP)

	local logo_size = header_h - 4
	local logo_x = panels_w - logo_size - 4
	local faction = lp:isRebel() and "Повстанцы" or lp:isGSR() and "ГСР" or lp:isCP() and "Альянс" or "Неизвестно"
	local is_cmd = lp:isMayor() and "Администратор Земли" or lp:r_isCmD() and "Командование" or lp:Team() == TEAM_GSR6 and "Глава ГСР" or "Отсутствуют"
	function header:Paint(header_w, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(logo_x, 0, logo_size, logo_size)

		draw.SimpleText("Управление составом", "PDA.Buttons", logo_x, 0, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Фракция: " .. faction, "PDA.Buttons", logo_x, button_fontsize, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Доступ: " .. is_cmd, "PDA.Buttons", logo_x, button_fontsize * 2, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.RoundedBox(0, 0, logo_size, w, 2, col.o)
	end

	local pnl = screen:Add("DPanel")
	pnl:DockMargin(sides_skip, 0, sides_skip, sides_skip)
	pnl:Dock(FILL)
	function pnl:Paint(bw, bh)
		surface.SetDrawColor(col.o)
		surface.DrawOutlinedRect(0, 0, bw, bh, 2)
	end

	local buttons = pnl:Add("EditablePanel")
	buttons:SetTall(h * 0.05)
	buttons:SetWide(w - sides_skip * 2)
	buttons:Dock(TOP)
	buttons.active = nil -- Active panel
	function buttons:PerformLayout(w, h)
		local children = self:GetChildren()
		for _, v in ipairs(children) do
			v:SetWide(w / #children)
		end
	end

	--local scroll = pnl:Add("DScrollPanel")
	--scroll:ErisScrollbar()
	--scroll:DockMargin(sides_skip, 2, sides_skip, 2)
	--scroll:Dock(FILL)
	local scroll_list = pnl:Add("DCategoryList")
	scroll_list:Dock(FILL)
	--scroll_list:ErisScrollbar()
	scrolledit(scroll_list)
	function scroll_list:SetUp()
		return
	end

	function scroll_list:Paint(bw, bh)
		return
	end

	function buttons:AddButton(name, onOpen)
		local b = self:Add("DButton")
		b:SetText(name)
		b:SetTextColor(color_white)
		b:SetFont("PDA.Buttons")
		b:Dock(LEFT)

		function b:Paint(bw, bh)
			if self:IsHovered() or self == buttons.active then
				surface.SetDrawColor(col.o)
			else
				surface.SetDrawColor(col.oa)
			end

			surface.DrawRect(0, 0, bw, bh)
			surface.SetDrawColor(col.o)
			surface.DrawOutlinedRect(0, 0, bw, bh, 2)
		end

		function b:DoClick()
			scroll_list:Clear()
			buttons.active = self

			if isfunction(onOpen) then
				onOpen(scroll_list)
			end
		end

		return b
	end

	local function AddSeparator(cat)
		local panel = cat:Add("DPanel")
		panel:Dock(TOP)
		panel:SetTall(2)
		panel.separator = true
		function panel:Paint(bw, bh)
			draw.RoundedBox(0, 0, 0, bw, bh, col.o)
		end

		function panel:Think()
			local parent = self:GetParent()
			local children = self:GetChildren()
			if children[#children] ~= self then
				self:Remove()
				AddSeparator(parent)
			end
		end
	end

	local function Sort(cat)
		local children = cat:GetChildren()
		if cat:GetName() == "DCategoryList" then children = cat:GetCanvas():GetChildren() end

		for i, a in ipairs(children) do
			a._calc = a.team and (a.is_leader and 100 or a.ours and 99 or a.team)
			or a.group_id and (a.ours and a.group_id + 1000 or 1000)
			or a.b and (a.b.ours and a.b.group_id + 1000 or 1000)
			or 1000000
		end

		table.sort(children, function(a, b) return a._calc > b._calc end)

		for i, child in ipairs(children) do
			if child:GetName() == "DVScrollBar" then Sort(child) end
			if child:GetName() == "DScrollBarGrip" then continue end
			child:SetParent(nil)
			child:SetParent(cat)
		end
	end

	local squad_names, groups = {}, {}
	local function UpdateSquadNames()
		squad_names = {}
		for squad_id, squad in pairs(DarkRP.Squads.GetSquads()) do
			local leader = DarkRP.Squads.GetLeader(squad_id)
			if leader and DarkRP.Squads.Can(lp, leader) then squad_names[squad_id] = squad.name end
			--squad_names[squad_id] = squad.name
		end
	end

	UpdateSquadNames()
	local function Receiver(receiver, tbl, dropped)
		if not dropped then return end
		local target = tbl[1]
		local is_scroll = receiver == scroll_list
		local group_id = receiver.group_id
		--if not group_id and not is_scroll then return end
		if target.group_id == group_id then return end
		local panel = target:GetParent()
		local old_parent = panel:GetParent()
		if not is_scroll then
			for i = 0, 2 do
				if not receiver.Header then receiver = receiver:GetParent() end
			end
		end

		if not receiver.Header and not is_scroll and group_id then return end
		local add = DFrame.Add
		add(receiver, panel)
		receiver:InvalidateLayout()
		old_parent:InvalidateLayout()
		Sort(receiver)
		DarkRP.Squads.Move(panel.ply, group_id)
		target.group_id = group_id
	end

	local function AddSquad(group_id, group_name)
		local cat = scroll_list:Add(group_name)
		cat:SetHeaderHeight(50)
		cat:SetPaintBackground(false)
		cat:SetExpanded(false)
		cat.group_id = group_id
		cat:Receiver("unit_group", Receiver)
		cat.Header:SetFont("PDA.Buttons")
		cat.Header:SetText("")
		cat.Header.group_id = group_id
		cat.Header:Receiver("unit_group", Receiver)
		function cat.Header:Paint(bw, bh)
			--draw.RoundedBox(0, 0, 0, bw, bh, col.ba)
			--draw.RoundedBox(0, 0, bh - 1, bw, 1, col.o)
			surface.SetDrawColor(col.o)
			surface.SetMaterial(group_icon)
			surface.DrawTexturedRect(bh * .25, bh * .25, bh * .5, bh * .5)

			surface.SetFont("PDA.Buttons")
			local tw, th = surface.GetTextSize(group_name)
			surface.SetTextColor(name_col)
			surface.SetTextPos(bh * .25 + bh * .5 + 4, bh * .5 - th * .5)
			surface.DrawText(group_name)
			draw.RoundedBox(button_fontsize + 4, 0, bh - 1, button_fontsize + tw * 1.2, 1, col.o)

			surface.SetDrawColor(col.o)
			surface.SetMaterial(cat.m_bSizeExpanded and icon_active or icon_inactive)
			surface.DrawTexturedRect(bw - 32, bh * .5 - 16, 32, 32)

			draw.SimpleText(#cat:GetChildren() - 3, "PDA.Buttons", bw - 32, bh * .5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		function cat:Paint(bw, bh)
			return
		end

		function cat:OnRemove()
			self.Header:Remove()
		end

		local cat_header = cat.Header
		function cat_header:DoRightClick()
			local context = DermaMenu(false, self)
			context.Paint = cpaint

			AddOption(context, "Скопировать SteamID лидера", "icons/fa32/copy.png", function()
				local leader = DarkRP.Squads.GetLeader(group_id)
				if not IsValid(leader) then
					notification.AddLegacy("Лидер не найден", NOTIFY_ERROR, 5)
					return
				end

				SetClipboardText(leader:SteamID())
			end)

			--if jobtbl.give_orders or jobtbl.cmd then
			if jobtbl.give_orders then
				context:AddSpacer()
				AddOption(context, "Выдать указания отряду", "icons/fa32/object-group.png", UI_Request("Изменение указаний " .. group_id, "Введите новые указания", function(s) DarkRP.Squads.SetProtocol(group_id, s) end))

				AddOption(context, "Сбросить указания отряду", "icons/fa32/object-ungroup.png", function() DarkRP.Squads.ResetProtocol(group_id) end)

				context:AddSpacer()

				local radio_actions = AddSubMenu(context, "Рация", "icons/fa32/volume-down.png")
				AddOption(radio_actions, "Включить звук", "icons/fa32/volume-up.png", function() DarkRP.Squads.ToggleRadioSpeaker(group_id, true) end)

				AddOption(radio_actions, "Отключить звук", "icons/fa32/volume-off.png", function() DarkRP.Squads.ToggleRadioSpeaker(group_id, false) end)

				AddOption(radio_actions, "Включить микрофон", "icons/fa32/microphone.png", function() DarkRP.Squads.ToggleRadioMicrophone(group_id, true) end)

				AddOption(radio_actions, "Отключить микрофон", "icons/fa32/microphone-slash.png", function() DarkRP.Squads.ToggleRadioMicrophone(group_id, false) end)
			end

			if jobtbl.can_edit_squad then
				context:AddSpacer()
				AddOption(context, "Переименовать", "icons/fa32/text-height.png", UI_Request("Переименование отряда " .. group_name, "Введите новое название", function(s)
					DarkRP.Squads.RenameGroup(group_id, s)
				end))
			end

			context:Open()
		end

		function cat:CheckMembers()
			local squad = DarkRP.Squads.GetGroup(group_id)
			if not squad then
				for k, v in ipairs(self:GetChildren()) do
					if v.ply then
						v:SetParent(scroll_list)
						v.b.group_id = nil
					end
				end

				self:Remove()
				squad_names[group_id] = nil
				groups[group_id] = nil
			elseif squad.name ~= group_name then
				squad_names[group_id] = squad.name
				group_name = squad.name
				--self.Header:SetText(squad.name)
			end
		end

		local next_think = CurTime() + 1
		function cat:Think()
			if CurTime() > next_think then
				next_think = CurTime() + 1
				self:CheckMembers()
			end
		end

		--function cat:OnRemove()
		--  groups[group_id] = nil
		--  squad_names[group_id] = nil
		--end
		AddSeparator(cat)
		Sort(scroll_list)
		return cat
	end

	local function MovePlayer(panel, cur_group, should_remove)
		local cat
		if cur_group == nil then
			cat = scroll_list
		else
			cat = groups[cur_group]
			if not cat then
				UpdateSquadNames()
				local name = squad_names[cur_group]
				if not name then -- Скорее всего, не успели получить отряд, того ждём
					return
				end

				cat = AddSquad(cur_group, name)
				groups[cur_group] = cat
			end
		end

		local old_parent = panel:GetParent()
		panel:SetParent(cat)
		panel:InvalidateLayout(true)
		old_parent:InvalidateLayout(true)
		if panel.open then panel.b:DoClick() end
		panel.b.group_id = cur_group
		panel.next_think = CurTime() + 1
		if should_remove then panel:Remove() end
		Sort(scroll_list)
	end

	scroll_list:Receiver("unit_group", Receiver)
	local members = {}
	local function ExistsPlayer(ply) -- У повстанцев приоритет с реальной профой в отображении. Того добавляем всех кого нужно, если шпик/барни - не будет
		for k, v in ipairs(members) do
			if v[1] == ply then return true end
		end
		return false
	end

	local function isRebel(ply)
		local t = RPExtraTeams[ply:GetNetVar("TeamNum", ply:Team())]
		return t and t.rebel
	end
	for i, isFuncName in ipairs({isRebel, lp.isCP, lp.isGSR}) do
		local isFunc = isFuncName
		if not isFunc(lp) then continue end
		local job = function(v) return IsValid(v) and (i > 1 or RPExtraTeams[v:Team()].citizen and v:GetNetVar("TeamNum")) and v:getDarkRPVar("job") or team.GetName(v:Team()) or "Недоступно" end
		for k, v in player.Iterator() do
			if not isFunc(v) or ExistsPlayer(v) then continue end
			local group_id = DarkRP.Squads.GetPlayerGroupID(v)
			table.insert(members, {v, v:Name(), job, group_id, function(ply) return isFunc(ply) end})
		end
	end

	local squad_button = buttons:AddButton("Состав", function(scroll)
		for group_id, group_name in SortedPairs(squad_names or {}) do
			local cat = AddSquad(group_id, group_name)
			groups[group_id] = cat
		end

		for _, member in ipairs(members or {}) do
			local ply, name, job, group_id, should = unpack(member)
			if not IsValid(ply) then continue end
			local t = ply:GetNetVar("TeamNum", ply:Team())

			local can_interract_with = jobtbl.custom_ping_teams
			local can_edit_squad = jobtbl.can_edit_squad and (not can_interract_with or can_interract_with[t])
			local can_give_orders = jobtbl.give_orders and (not can_interract_with or can_interract_with[t])

			local cat = groups[group_id] or scroll
			if groups[group_id] and ply == LocalPlayer() then
				cat.ours = true
			end

			local pnl = vgui.Create("DPanel", cat)
			pnl:Dock(TOP)
			pnl:SetTall(smallerbutton_fontsize * 2)
			pnl:DockMargin(0, 4, 0, 4)
			pnl.team = t
			pnl.ply = ply
			pnl.ours = ply == LocalPlayer()

			function pnl:Paint(bw, bh)
				surface.SetDrawColor(col.oa)
				surface.DrawRect(0, 0, bw, bh)
				surface.SetDrawColor(col.o)
				return
			end

			pnl.next_think = 0
			function pnl:Think()
				if CurTime() < self.next_think then return end
				if not IsValid(ply) or not should(ply) then
					MovePlayer(pnl, nil, true)
					return
				end

				self.group_id = self.b.group_id
				self.next_think = CurTime() + 1
				self.is_leader = DarkRP.Squads.IsLeader(ply)
				local cur_group = DarkRP.Squads.GetPlayerGroupID(ply)
				if cur_group ~= self.b.group_id then
					MovePlayer(pnl, cur_group)
					self.group_id = cur_group
				end

				local protocol_new = ply:GetNetVar("ota.protocol", "Указания отсутствуют")
				if self.protocol_msg ~= protocol_new then
					self.protocol_msg = protocol_new
					self.target = self.protocol_msg ~= "Указания отсутствуют" and
						(utf8.len(self.protocol_msg) > 30 and utf8.sub(self.protocol_msg, 1, 30) .. "..." or self.protocol_msg) or ""
				end

				self.max_warns = ply:getJobTable().max_warns or 3

				local curwarns_tbl = cpWarn.list[ply:SteamID()] or {}
				if #curwarns_tbl ~= self.warns_amount then
					self.warns_amount = #curwarns_tbl
					self.warns_str = self.warns_amount .. "/" .. self.max_warns
					self.warns_tbl = curwarns_tbl
				end
			end

			local b = vgui.Create("DButton", pnl)
			pnl.b = b
			b:SetTall(smallerbutton_fontsize * 2)
			b:Dock(TOP)
			b:SetText("")
			b.group_id = group_id
			b.acts = {}
			b:Receiver("unit_group", Receiver)
			b:Droppable("unit_group")
			function b:Paint(bw, bh)
				if not IsValid(ply) then
					pnl:Remove()
					Sort(cat)
					return
				end

				if self:IsHovered() or pnl.open then
					surface.SetDrawColor(col.oa)
					surface.DrawRect(0, 0, bw, bh)
					surface.SetDrawColor(col.o)
				end

				local text_x = bw * .01
				if pnl.is_leader then
					surface.SetDrawColor(cid_col)
					surface.SetMaterial(leader_material)
					surface.DrawTexturedRect(text_x, 0, smallerbutton_fontsize, smallerbutton_fontsize)
					text_x = text_x + smallerbutton_fontsize + 4
				end

				draw.SimpleText(name, "PDA.SmallerButton", text_x, 0, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
				local job_x = bw * .01
				if ply:isRadioForceDisabled() then
					surface.SetDrawColor(cid_col)
					surface.SetMaterial(force_disabled_voice)
					surface.DrawTexturedRect(job_x, smallerbutton_fontsize, smallerbutton_fontsize, smallerbutton_fontsize)
					job_x = job_x + smallerbutton_fontsize + 4
				end

				if ply:isRadioDisabled() then
					surface.SetDrawColor(cid_col)
					surface.SetMaterial(disabled_speaker)
					surface.DrawTexturedRect(job_x, smallerbutton_fontsize, smallerbutton_fontsize, smallerbutton_fontsize)
					job_x = job_x + smallerbutton_fontsize + 4
				end

				local job_text = job(ply)
				draw.SimpleText(job_text, "PDA.SmallerButton", job_x, bh, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
				local location_x = bw * .99
				local should_see = true
				if not (isRebel(ply) and LocalPlayer():isRebel()) and ply:isCP() and not ply:isOTA() and not ply:GetNetVar("HideCPName") and not ply:isMayor() then should_see = false end
				local location = ply:Alive() and should_see and ply:GetNiceZone() or not ply:Alive() and ply:isCP() and "Отсутствует био-сигнал" or "Отсутствует связь"
				draw.SimpleText(location, "PDA.SmallerButton", location_x, 0, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
				draw.SimpleText(pnl.target, "PDA.SmallerButton", location_x, bh, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
			end
			function b:DoRightClick()
				local context = DermaMenu(false, self)
				context.Paint = cpaint
				for _, act in ipairs(self.acts) do
					if act.sub then
						local subcontext, option = AddSubMenu(context, act.name, act.icon)
						act.func(subcontext)
						subcontext:Hide()
					else
						AddOption(context, act.name, act.icon, act.func)
					end
				end
				context:Open()
			end
			pnl:Think()

			local protocol_scroll = vgui.Create("DScrollPanel", pnl)
			--protocol_scroll:ErisScrollbar()
			scrolledit(protocol_scroll)
			protocol_scroll:Dock(TOP)
			protocol_scroll:SetTall(smallerbutton_fontsize * 3)
			protocol_scroll:DockMargin(0, 4, 0, 4)
			protocol_scroll:Hide()

			local footer_buttons = vgui.Create("EditablePanel", pnl)
			footer_buttons:Dock(TOP)
			footer_buttons:SetTall(smallerbutton_fontsize * 2.5)
			footer_buttons:Hide()
			footer_buttons.acts = {}
			function footer_buttons:AddAction(name, icon, onClick, func)
				local b = vgui.Create("DButton", footer_buttons)
				b:Dock(LEFT)
				b:SetText(name)
				b:SetTextColor(cid_col)
				b:SetFont("PDA.SmallerButton")
				b:SetContentAlignment(8)
				b.icon = icon
				function b:Paint(bw, bh)
					if self:IsHovered() then
						surface.SetDrawColor(col.oa)
					else
						surface.SetDrawColor(20, 20, 20, 50)
					end

					surface.DrawRect(0, 0, bw, bh)
					--
					local icon_size = bh * .45
					surface.SetDrawColor(color_white)
					surface.SetMaterial(self.icon)
					surface.DrawTexturedRect(bw * .5 - icon_size * .5, 0, icon_size, icon_size)
				end
				function b:PerformLayout(_, h)
					b:SetTextInset(0, h * 0.5 - 2)
				end
				local onRightClick = function() end
				if func then
					onRightClick = function(self)
						local context = DermaMenu(false, self)
						context.Paint = cpaint
						func(context)
					end
					table.insert(pnl.b.acts, {name = name, icon = icon:GetString("$basetexture") .. ".png", func = func, sub = true})
				elseif onClick then
					table.insert(pnl.b.acts, {name = name, icon = icon:GetString("$basetexture") .. ".png", func = onClick})
				end
				if not onClick then
					onClick = onRightClick
				end
				b.DoClick = onClick
				b.DoRightClick = onRightClick
				footer_buttons.acts[name] = b
				return b
			end
			function footer_buttons:PerformLayout(w)
				local childs = self:GetChildren()
				for _, act in ipairs(childs) do
					act:SetWide(w / #childs)
				end
			end

			local protocol_text = Label("", protocol_scroll)
			protocol_text:SetFont("PDA.SmallerButton")
			protocol_text:SetWrap(true)
			protocol_text:SetContentAlignment(7)
			protocol_text:Dock(TOP)
			protocol_text:SetTextColor(name_col)
			protocol_text:SetMouseInputEnabled(true)

			function b:DoClick()
				pnl.open = not pnl.open
				if pnl.open then
					protocol_scroll:Show()
					footer_buttons:Show()
					pnl:SizeTo(pnl:GetWide(), smallerbutton_fontsize * 7.5, 0.2, 0, -1, function()
						pnl:InvalidateParent(true)
					end)
				else
					pnl:SizeTo(pnl:GetWide(), smallerbutton_fontsize * 2, 0.2, 0, -1, function()
						protocol_scroll:Hide()
						footer_buttons:Hide()
						pnl:InvalidateParent(true)
					end)
				end
			end

			function protocol_text:Think()
				local text = self:GetText()
				self:SizeToContentsY()
				if text == pnl.protocol_msg then return end
				self:SetText(pnl.protocol_msg)
			end

			function protocol_text:DoClick()
				SetClipboardText(pnl.protocol_msg)
				notification.AddLegacy("Текст был скопирован в буфер обмена", NOTIFY_GENERIC, 5)
			end

			local function protocol_click(context)
				AddOption(context, "Скопировать указания", "icons/fa32/copy.png", function()
					SetClipboardText(pnl.protocol_msg)
					notification.AddLegacy("Текст был скопирован в буфер обмена", NOTIFY_GENERIC, 5)
				end)

				if jobtbl.can_use_cp_ping_unit then
					local custom_ping_teams = lp:getJobTable().custom_ping_teams
					local should_ping = not custom_ping_teams or custom_ping_teams[pnl.team]
					if should_ping then AddOption(context, "Показать местоположение", "icons/fa32/map-marker.png", function() netstream.Start("cmd.PingUnit", ply) end) end
				end

				if jobtbl.canspectate then AddOption(context, "Наблюдать", "icons/fa32/eye.png", function() netstream.Start("cmd.Spectate", ply) end) end
				local giver = ply:GetNetVar("ota.protocol.giver")
				if giver then
					AddOption(context, "Выдал: " .. giver, "icons/fa32/user-secret.png", function()
						SetClipboardText(giver)
						notification.AddLegacy("Текст был скопирован в буфер обмена", NOTIFY_GENERIC, 5)
					end)
				end

				--if jobtbl.give_orders or jobtbl.cmd then
				if can_give_orders then
					context:AddSpacer()
					AddOption(context, "Сбросить указания", "icons/fa32/trash-o.png", function()
						if not IsValid(ply) then return end
						netstream.Start("ota.ResetProtocol", {ply})
					end)

					AddOption(context, "Изменить указания", "icons/fa32/edit.png", UI_Request("Изменение указаний " .. name, "Введите новые указания", function(s)
						if not IsValid(ply) then return end
						netstream.Start("ota.SetProtocol", {ply}, s)
					end))
				end
			end
			function protocol_text:DoRightClick()
				local context = DermaMenu(false, self)
				context.Paint = cpaint

				protocol_click(context)

				context:Open()
			end

			local elements = LocalPlayer():isRebel() and 4 or 5
			if not can_edit_squad then
				elements = elements - 1 -- Убираем отряды
			end

			local wide = w / elements
			if not LocalPlayer():isRebel() then
				footer_buttons:AddAction("Профиль", profile, function() RequestPlayerData(ply:GetCID()) end)
			end

			table.insert(pnl.b.acts, {name = "Указания", icon = "icons/fa32/file-text.png", func = protocol_click, sub = true})
			local b = footer_buttons:AddAction("Предупреждения", warns, nil, function(context)
				local warns_tbl = cpWarn.list[ply:SteamID()] or {}
				local warns_amount = #warns_tbl
				local max_warns = ply:getJobTable().max_warns or 3
				local warns_str = warns_amount .. "/" .. max_warns
				local can_demote = (not LocalPlayer():isOTA() or ply:isOTA()) and (not LocalPlayer():isRebel() or isRebel(ply))
				if jobtbl.dodemote and can_demote then
					AddOption(context, "Выдать предупреждение", "icons/fa32/exclamation-triangle.png", UI_Request("Выдача предупреждения " .. name, "Введите причину предупреждения", function(s)
						if not IsValid(ply) then return end
						local reason = tostring(s)
						reason = string.utf8len(reason) >= 30 and string.utf8sub(reason, 1, 30) .. "..." or reason
						netstream.Start("cpWarn.net", "warn", ply, {
							reason = tostring(reason)
						})
					end))

					AddOption(context, "Обнулить предупреждения", "icons/fa32/child.png", function()
						if not IsValid(ply) then return end
						netstream.Start("cpWarn.net", "resetwarns", ply)
					end)

					context:AddSpacer()
				end

				local warn_list = AddSubMenu(context, "Предупреждения", "icons/fa32/list.png")
				for warn_id, warn in ipairs(warns_tbl) do
					local cur_warn = AddSubMenu(warn_list, warn[1], "icons/fa32/file-excel-o.png")
					AddOption(cur_warn, warn[2], "icons/fa32/user-o.png")
					AddOption(cur_warn, "Удалить", "icons/fa32/trash-o.png", function()
						if not IsValid(ply) then return end
						netstream.Start("cpWarn.net", "unwarn", ply, {
							id = tonumber(id)
						})
					end)
				end

				if jobtbl.dodemote and can_demote then
					context:AddSpacer()
					AddOption(context, "Уволить", "icons/fa32/remove.png", UI_Request("Увольнение " .. name, "Введите причину увольнения", function(s)
						if not IsValid(ply) then return end
						RunConsoleCommand("darkrp", "demote", ply:UserID(), s)
					end))
				end

				context:Open()
			end)
			function b:Think()
				local text = self:GetText()
				if text == pnl.warns_str then return end
				self:SetText(pnl.warns_str)
			end


			local b = footer_buttons:AddAction("Рация", enabled_speaker, function()
				if not jobtbl.can_edit_cp_radio and not jobtbl.can_edit_rebel_radio or ply:r_isCmD() then
					notification.AddLegacy("У вас нет доступа к этой функции", NOTIFY_ERROR, 5)
					return
				end

				if ply:isRadioDisabled() then
					netstream.Start("radio.admins", "turn_on", {ply})
				else
					netstream.Start("radio.admins", "turn_off", {ply})
				end
			end)
			function b:Think()
				self.icon = ply:isRadioDisabled() and disabled_speaker or enabled_speaker
			end

			local b = footer_buttons:AddAction("Вещание", force_enabled_voice, function()
				if not jobtbl.can_edit_cp_radio and not jobtbl.can_edit_rebel_radio or ply:r_isCmD() then
					notification.AddLegacy("У вас нет доступа к этой функции", NOTIFY_ERROR, 5)
					return
				end

				if ply:isRadioForceDisabled() then
					netstream.Start("radio.admins", "turn_off_force", {ply})
				else
					netstream.Start("radio.admins", "turn_on_force", {ply})
				end
			end)
			function b:Think()
				self.icon = ply:isRadioForceDisabled() and force_disabled_voice or force_enabled_voice
			end

			if can_edit_squad then
				local b = footer_buttons:AddAction("Отряд", make_leader, function()
					if not IsValid(ply) then return end
					if pnl.is_leader then
						DarkRP.Squads.Disband(pnl.group_id)
					elseif pnl.group_id ~= nil then
						DarkRP.Squads.MakeLeader(ply, pnl.group_id)
					else
						DarkRP.Squads.Create(ply)
					end
				end)
				function b:Think()
					local text = self:GetText()
					local new_text = pnl.is_leader and "Расформировать" or pnl.group_id ~= nil and "Сделать лидером" or "Создать отряд"
					if text ~= new_text then
						self:SetText(new_text)
					end
				end
			end

			Sort(cat)
		end

		Sort(scroll)
	end)
	-- buttons_tbl = {{"Состав", {groups = squad_names, members = members}}}
	if lp:isCP() then
		buttons:AddButton("Заключённые", function(scroll)
			scroll:Clear()
			local arrestedPlayers = arrestSystem.arrestedPlayers
			for k, v in player.Iterator() do
				local sid = v:SteamID()
				local row = arrestedPlayers[sid]
				if not row then continue end
				local name = v:Name() .. " | #" .. v:GetCID()
				local arrest_time = row.time
				local unarrest = math.ceil(row.arrestedTime + arrest_time)
				local arrester = row.arrester or "Неизвестный"
				local reason = row.reason or "Неизвестно"
				--local reason_cut = utf8.len(reason) > 30 and utf8.sub(reason, 1, 30) .. "..." or reason
				local pnl = vgui.Create("DPanel", scroll)
				pnl:Dock(TOP)
				pnl:SetTall(smallerbutton_fontsize * 2)
				pnl:DockMargin(0, 4, 0, 4)
				function pnl:Paint(bw, bh)
					surface.SetDrawColor(col.oa)
					surface.DrawRect(0, 0, bw, bh)
					surface.SetDrawColor(col.o)
					return
				end

				local b = vgui.Create("DButton", pnl)
				b:SetTall(smallerbutton_fontsize * 2)
				b:Dock(TOP)
				b:SetText("")
				function b:Paint(bw, bh)
					if self:IsHovered() or pnl.open then
						surface.SetDrawColor(col.oa)
						surface.DrawRect(0, 0, bw, bh)
						surface.SetDrawColor(col.o)
					end

					local text_x = bw * .01
					draw.SimpleText(name, "PDA.SmallerButton", text_x, 0, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
					local job_x = bw * .01
					local left = math.ceil(unarrest - CurTime())
					draw.SimpleText(util.TimeToStr(left), "PDA.SmallerButton", job_x, bh, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					--draw.SimpleText(string.FormattedTime(left, "%02i:%02i"), "PDA.SmallerButton", job_x, bh, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
					local location_x = bw * .99
					draw.SimpleText(arrester, "PDA.SmallerButton", location_x, 0, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
					draw.SimpleText(util.TimeToStr(arrest_time), "PDA.SmallerButton", location_x, bh, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM)
				end

				function b:DoClick()
					pnl.open = not pnl.open
					pnl:SizeTo(pnl:GetWide(), pnl.open and smallerbutton_fontsize * 4 or smallerbutton_fontsize * 2, 0.2, 0, -1, function() pnl:InvalidateParent(true) end)
				end

				local reason_scroll = vgui.Create("DScrollPanel", pnl)
				--reason_scroll:ErisScrollbar()
				scrolledit(reason_scroll)
				reason_scroll:Dock(TOP)
				reason_scroll:SetTall(smallerbutton_fontsize * 3)
				reason_scroll:DockMargin(0, 4, 0, 4)

				local reason_text = Label(reason, reason_scroll)
				reason_text:SetFont("PDA.SmallerButton")
				reason_text:SetWrap(true)
				reason_text:SetAutoStretchVertical(true)
				reason_text:Dock(FILL)
				reason_text:SetTextColor(name_col)
				reason_text:SetMouseInputEnabled(true)

				local next_think = CurTime() + 1
				function pnl:Think()
					if CurTime() > next_think then
						next_think = CurTime() + 1
						local cur_row = arrestedPlayers[sid]
						if not IsValid(v) or not cur_row then
							self:Remove()
						elseif cur_row ~= row then
							unarrest = math.ceil(cur_row.arrestedTime + cur_row.time)
							arrester = cur_row.arrester or "Неизвестный"
							reason = cur_row.reason or "Неизвестно"
							reason_text:SetText(reason)
							--reason_cut = utf8.len(reason) > 30 and utf8.sub(reason, 1, 30) .. "..." or reason
							row = cur_row
						end
					end
				end
			end
		end)
	end

	squad_button:DoClick()
end)
definePage("F3", "Вызовы", KEY_F3, 0.21811886901327, 1, function(screen, w, h)
	-- Вызовы
	local ply = LocalPlayer()
	if not ply:isCP() and not ply:isGSR() then
		local label = Label("NO ACCESS", screen)
		label:SetFont("PDA.CID")
		label:SizeToContents()
		label:Center()
		return
	end

	local name = ply:Name()
	local cid = "##" .. ply:GetCID()
	local job = team.GetName(ply:GetNetVar("TeamNum", ply:Team()))
	local header_h = name_fontsize * 2
	local sides_skip = w * 0.01
	local panels_w = w - sides_skip * 2
	local header = screen:Add("DPanel")
	header:SetTall(header_h)
	header:DockMargin(sides_skip, h * 0.005, sides_skip, h * 0.005)
	header:Dock(TOP)

	local dlabel_name = Label(name, header)
	dlabel_name:SetFont("PDA.Name")
	dlabel_name:SetTextColor(name_col)
	dlabel_name:SizeToContents()
	dlabel_name:Dock(TOP)

	local dlabel_cid = Label(cid, header)
	dlabel_cid:SetFont("PDA.CID")
	dlabel_cid:SetTextColor(cid_col)
	dlabel_cid:SizeToContents()
	dlabel_cid:Dock(TOP)

	local logo_size = header_h - 4
	local logo_x = panels_w - logo_size - 4
	function header:Paint(header_w, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(logo_x, 0, logo_size, logo_size)

		draw.SimpleText("Вызовы", "PDA.Name", logo_x, 0, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText(job, "PDA.CID", logo_x, name_fontsize, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.RoundedBox(0, 0, logo_size, w, 2, col.o)
	end

	local scroll = screen:Add("DScrollPanel")
	--scroll:ErisScrollbar()
	scrolledit(scroll)
	scroll:DockMargin(sides_skip, 2, sides_skip, 2)
	scroll:Dock(FILL)

	local solved = Material("icons/fa32/eye.png")
	local get_location = Material("icons/fa32/location-arrow.png")
	local profile = Material("icons/fa32/user-circle.png")
	local get_report, delete_report = Material("icons/fa32/chain-broken.png"), Material("icons/fa32/trash-o.png")
	local function Add(request, num)
		local text, pos, who, who_id, request_id, is_solved = request.text, request.pos, request.name, request.cid, request.id, request.solved
		local target = utf8.len(text) > 30 and utf8.sub(text, 1, 30) .. "..." or text
		local location = DarkRP.Zones.GetZone(pos + Vector(0, 0, 8))
		local pnl = vgui.Create("DPanel", scroll)
		pnl:Dock(TOP)
		pnl:SetTall(smallerbutton_fontsize * 2)
		function pnl:Paint(bw, bh)
			surface.SetDrawColor(col.oa)
			surface.DrawRect(0, 0, bw, bh)
			surface.SetDrawColor(col.o)
			return
		end

		pnl:DockMargin(0, 4, 0, 4)
		local b = vgui.Create("DButton", pnl)
		b:SetTall(smallerbutton_fontsize * 2)
		b:Dock(TOP)
		b:SetText("")
		function b:Paint(bw, bh)
			if self:IsHovered() or pnl.open then
				surface.SetDrawColor(col.oa)
				surface.DrawRect(0, 0, bw, bh)
				surface.SetDrawColor(col.o)
			end

			local text_x = bw * .01
			if is_solved then
				surface.SetDrawColor(color_white)
				surface.SetMaterial(solved)
				surface.DrawTexturedRect(text_x, 0, smallerbutton_fontsize, smallerbutton_fontsize)
				text_x = text_x + smallerbutton_fontsize + 4
			end

			draw.SimpleText(who, "PDA.SmallerButton", text_x, 0, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			draw.SimpleText(target, "PDA.SmallerButton", bw * .01, bh, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(location, "PDA.SmallerButton", bw * .99, 0, cid_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		end

		function b:DoClick()
			pnl.open = not pnl.open
			pnl:SizeTo(pnl:GetWide(), pnl.open and smallerbutton_fontsize * 6 or smallerbutton_fontsize * 2, 0.2, 0, -1, function() pnl:InvalidateParent(true) end)
		end

		local function CreateInfo()
			if IsValid(pnl.report_scroll) then
				pnl.report_scroll:Clear()
			else
				local report_scroll = vgui.Create("DScrollPanel", pnl)
				--report_scroll:ErisScrollbar()
				scrolledit(report_scroll)
				report_scroll:Dock(TOP)
				report_scroll:SetTall(smallerbutton_fontsize * 2)
				--report_scroll:DockMargin(0, 4, 0, 4)
				pnl.report_scroll = report_scroll
			end

			if is_solved then
				local b = vgui.Create("DButton", pnl.report_scroll)
				b:Dock(FILL)
				b:SetTall(smallerbutton_fontsize * 2)
				b:SetText(is_solved)
				b:SetTextColor(cid_col)
				b:SetFont("PDA.SmallerButton")
				b:SetContentAlignment(2)
				function b:Paint(bw, bh)
					if self:IsHovered() then
						surface.SetDrawColor(col.oa)
					else
						surface.SetDrawColor(20, 20, 20, 50)
					end

					surface.DrawRect(0, 0, bw, bh)
					local icon_size = smallerbutton_fontsize
					surface.SetDrawColor(color_white)
					surface.SetMaterial(solved)
					surface.DrawTexturedRect(bw * .5 - icon_size * .5, 0, icon_size, icon_size)
				end

				function b:DoClick()
					RequestPlayerData(request.solved_by)
				end

				pnl.report_scroll:InvalidateLayout(true)
			else
				local report_text = Label(text, pnl.report_scroll)
				report_text:SetFont("PDA.SmallerButton")
				report_text:SetWrap(true)
				report_text:SetAutoStretchVertical(true)
				report_text:Dock(FILL)
				report_text:SetTextColor(name_col)
				report_text:SetContentAlignment(7)
				report_text:SetMouseInputEnabled(true)
				function report_text:DoClick()
					SetClipboardText(reason)
					notification.AddLegacy("Текст был скопирован в буфер обмена", NOTIFY_GENERIC, 5)
				end
			end
		end

		CreateInfo()
		local next_think = CurTime() + 1
		function pnl:Think()
			if CurTime() > next_think then
				next_think = CurTime() + 1
				if is_solved ~= request.solved then
					is_solved = request.solved
					CreateInfo()
				end
			end
		end

		local b = vgui.Create("DButton", pnl)
		b:SetWide(w * .33)
		b:SetTall(smallerbutton_fontsize * 2)
		b:Dock(LEFT)
		b:SetText("")
		function b:Paint(bw, bh)
			if self:IsHovered() then
				surface.SetDrawColor(col.oa)
			else
				surface.SetDrawColor(20, 20, 20, 50)
			end
			surface.DrawRect(0, 0, bw, bh)

			local icon_size = bh * .5
			surface.SetDrawColor(color_white)
			surface.SetMaterial(is_solved and delete_report or get_report)
			surface.DrawTexturedRect(bw * .5 - icon_size * .5, 0, icon_size, icon_size)
			draw.SimpleText(is_solved and "Удалить" or "Решено", "PDA.SmallerButton", bw * .5, bh, cid_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
		end

		function b:DoClick()
			if is_solved then
				table.RemoveByValue(DarkRP.Requests, request)
				pnl:Remove()
			else
				netstream.Start("request.get", request_id)
			end
		end

		local b = vgui.Create("DButton", pnl)
		b:SetWide(w * .33)
		b:SetTall(smallerbutton_fontsize * 2)
		b:Dock(RIGHT)
		b:SetText("Местоположение")
		b:SetTextColor(cid_col)
		b:SetFont("PDA.SmallerButton")
		b:SetContentAlignment(2)
		function b:Paint(bw, bh)
			if self:IsHovered() then
				surface.SetDrawColor(col.oa)
			else
				surface.SetDrawColor(20, 20, 20, 50)
			end

			surface.DrawRect(0, 0, bw, bh)
			local icon_size = bh * .5
			surface.SetDrawColor(color_white)
			surface.SetMaterial(get_location)
			surface.DrawTexturedRect(bw * .5 - icon_size * .5, 0, icon_size, icon_size)
		end

		function b:DoClick()
			--Marks:AddPoint("Местоположение вызова", "call_" .. request_id, pos, 60, request.icon, 6000, request.sound)
			gps.config.pointsList["Местоположение вызова"] = {
				category = "Планшет",
				pointData = {
					pos = pos,
					icon = "arrow_up",
				}
			}

			gps:Activate("Местоположение вызова")
		end

		local b = vgui.Create("DButton", pnl)
		b:SetWide(w * .33)
		b:SetTall(smallerbutton_fontsize * 2)
		b:Dock(FILL)
		b:SetText("Профиль")
		b:SetTextColor(cid_col)
		b:SetFont("PDA.SmallerButton")
		b:SetContentAlignment(2)
		function b:Paint(bw, bh)
			if self:IsHovered() then
				surface.SetDrawColor(col.oa)
			else
				surface.SetDrawColor(20, 20, 20, 50)
			end

			surface.DrawRect(0, 0, bw, bh)
			local icon_size = bh * .5
			surface.SetDrawColor(color_white)
			surface.SetMaterial(profile)
			surface.DrawTexturedRect(bw * .5 - icon_size * .5, 0, icon_size, icon_size)
		end

		function b:DoClick()
			RequestPlayerData(who_id)
		end
	end

	for num, request in ipairs(DarkRP.Requests) do
		Add(request, num)
	end
end)
definePage("F4", "Управление статусом", KEY_F4, 0.25504904789383, 1, function(screen, w, h)
	-- Коды и управление
	local lp = LocalPlayer()
	local jobtbl = LocalPlayer():getJobTable()
	local header_h = name_fontsize * 2
	local sides_skip = w * 0.01
	local panels_w = w - sides_skip * 2

	local header = screen:Add("DPanel")
	header:SetTall(header_h)
	header:DockMargin(sides_skip, h * 0.005, sides_skip, h * 0.005)
	header:Dock(TOP)

	local dlabel_name = Label(lp:Name(), header)
	dlabel_name:SetFont("PDA.Name")
	dlabel_name:SetTextColor(name_col)
	dlabel_name:SizeToContents()
	dlabel_name:Dock(TOP)

	local dlabel_cid = Label("##" .. lp:GetCID(), header)
	dlabel_cid:SetFont("PDA.CID")
	dlabel_cid:SetTextColor(cid_col)
	dlabel_cid:SizeToContents()
	dlabel_cid:Dock(TOP)

	local logo_size = header_h - 4
	local logo_x = panels_w - logo_size - 4
	local faction = lp:isRebel() and "Повстанцы" or lp:isGSR() and "ГСР" or lp:isCP() and "Альянс" or "Неизвестно"
	local is_cmd = lp:isMayor() and "Администратор Земли" or lp:r_isCmD() and "Командование" or lp:Team() == TEAM_GSR6 and "Глава ГСР" or "Отсутствуют"
	function header:Paint(header_w, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(logo_x, 0, logo_size, logo_size)

		draw.SimpleText("Управление статусом", "PDA.Buttons", logo_x, 0, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Фракция: " .. faction, "PDA.Buttons", logo_x, button_fontsize, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Доступ: " .. is_cmd, "PDA.Buttons", logo_x, button_fontsize * 2, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.RoundedBox(0, 0, logo_size, w, 2, col.o)
	end

	local scroll_list = screen:Add("DCategoryList")
	--scroll_list:ErisScrollbar()
	scrolledit(scroll_list)
	scroll_list:DockMargin(sides_skip, 2, sides_skip, 2)
	scroll_list:Dock(FILL)

	scroll_list.Paint = function() end

	local function Add(parent, lu, ld, func)
		local b = vgui.Create("DButton", parent)
		b:SetTall(h * .1)
		b:Dock(TOP)
		b:DockMargin(0, 8, 0, 8)
		b:SetText("")
		function b:Paint(bw, bh)
			local xl = bw * .015
			local y = bh * .5
			draw.RoundedBox(4, 0, 0, bw, bh, col.oa)
			draw.SimpleText(lu or "", "PDA.Buttons", xl, y, name_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
			draw.SimpleText(ld or "", "PDA.Buttons", xl, y, cid_col, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
		end

		function b:DoClick()
			if not func then return end
			func()
		end
		return b
	end

	local icon_inactive, icon_active = Material("icons/fa32/chevron-left.png"), Material("icons/fa32/chevron-down.png")
	local function AddCat(name, icon)
		local cat = scroll_list:Add(name)
		cat:SetHeaderHeight(50)
		cat:SetPaintBackground(false)
		cat:SetExpanded(false)
		cat.Header:SetFont("PDA.Buttons")
		cat.Header:SetText("")
		function cat.Header:Paint(bw, bh)
			--draw.RoundedBox(0, 0, 0, bw, bh, col.ba)
			--draw.RoundedBox(0, 0, bh - 1, bw, 1, col.o)
			surface.SetDrawColor(col.o)
			surface.SetMaterial(icon)
			surface.DrawTexturedRect(bh * .25, bh * .25, bh * .5, bh * .5)

			surface.SetFont("PDA.Buttons")
			local tw, th = surface.GetTextSize(name)
			surface.SetTextColor(name_col)
			surface.SetTextPos(bh * .25 + bh * .5 + 4, bh * .5 - th * .5)
			surface.DrawText(name)
			draw.RoundedBox(button_fontsize + 4, 0, bh - 1, button_fontsize + tw * 1.2, 1, col.o)

			surface.SetDrawColor(col.o)
			surface.SetMaterial(cat.m_bSizeExpanded and icon_active or icon_inactive)
			surface.DrawTexturedRect(bw - 32, bh * .5 - 16, 32, 32)

			draw.SimpleText(#cat:GetChildren() - 1, "PDA.Buttons", bw - 32, bh * .5, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		function cat:Paint(bw, bh)
			return
		end
		return cat
	end

	local can_start = jobtbl.canstartlock or jobtbl.canstartyk or jobtbl.canstartkk
	if can_start then
		local codes = AddCat("Коды", Material("icons/fa32/outdent.png"))
		Add(codes, "Красный код", "Объявить военное положение", UI_Request("Введите причину", "Введите причину объявления военного положения.", function(s) netstream.Start("DarkRP.startkk", tostring(s)) end))
		Add(codes, "Красный код", "Объявить проведение боевых действий", UI_Request("Введите причину", "Введите причину объявления боевых действий.", function(s) netstream.Start("DarkRP.startkk", tostring(s), true) end))
		Add(codes, "Желтый код", "Объявить проверку населения", UI_Request("Введите причину", "Введите причину проверки населения.", function(s) netstream.Start("DarkRP.startyk", tostring(s)) end))
		Add(codes, "Желтый код", "Объявить сбор населения", UI_Request("Введите причину", "Введите причину сбора населения.", function(s) UI_Derma_Query("Использовать вашу позицию для метки?", "Подтверждение:", "Да", function() netstream.Start("DarkRP.startyk", tostring(s), true, true) end, "Нет", function() netstream.Start("DarkRP.startyk", tostring(s), true) end)() end))
		Add(codes, "Ком. час", "Объявить Комендантский час", UI_Request("Введите причину", "Введите причину объявления комендантского часа.", function(s) RunConsoleCommand("darkrp", "lockdown", tostring(s)) end))
		Add(codes, "Отменить все коды", "", function() RunConsoleCommand("darkrp", "stopcodes") end)
	end

	if lp:isCP() and not lp:isMayor() then
		local status_codes = AddCat("Статус-коды", Material("icons/fa32/list-ol.png"))
		for _, v in ipairs(broadCodes.status) do
			Add(status_codes, v, "Передача статус-кода", function() netstream.Start("cp.BroadCode", v) end)
		end

		local other_codes = AddCat("Прочие коды", Material("icons/fa32/list-ul.png"))
		for _, v in ipairs(broadCodes.other) do
			Add(other_codes, v, "Передача прочего кода", function() netstream.Start("cp.BroadCode", v) end)
		end
	end

	if lp:getJobTable().can_use_notice then
		local adverts = AddCat("Объявления", Material("icons/fa32/comments-o.png"))
		Add(adverts, "Объявление", "Отобразить объявление", UI_Request("Введите время", "Введите время, на которое будет показываться объявление, от 5 до 60 секунд.", function(time)
			time = tonumber(time)
			if not isnumber(time) or time < 5 or time > 60 then
				local txt = "Время должно быть указаноот 5 до 60 секунд."
				notification.AddLegacy(txt, NOTIFY_ERROR, 5)
				surface.PlaySound("buttons/lightswitch2.wav")
				return
			end

			UI_Request("Введите текст", "Введите текст объявления.", "", function(s) netstream.Start("cmd.NoticeAdd", s, time) end)()
		end))

		Add(adverts, "Построение", "Объявление с точкой сбора", UI_Request("Введите время", "Введите время, на которое будет показываться объявление, от 5 до 60 секунд.", function(time)
			time = tonumber(time)
			if not isnumber(time) or time < 5 or time > 60 then
				local txt = "Время должно быть указаноот 5 до 60 секунд."
				notification.AddLegacy(txt, NOTIFY_ERROR, 5)
				surface.PlaySound("buttons/lightswitch2.wav")
				return
			end

			UI_Request("Введите текст", "Введите текст объявления.", "", function(s) netstream.Start("cmd.NoticeAdd", s, time, true) end)()
		end))
	end

	if lp:getJobTable().can_start_nabor then
		local ss = netvars.GetNetVar("Nabor_Active", false)
		local name = ss and "Закончить набор" or "Объявить набор"
		local desk = ss and "Закрыть приём заявок в ГО" or "Открыть приём заявок в ГО"
		Add(scroll_list, name, desk, function() netstream.Start("Nabor_Active", not ss) end)
	end

	if lp:isCP() then
		Add(scroll_list, "Транслировать сообщение", "Транслировать сообщение по рации", UI_Request("Транслировать сообщение", "Напишите ваше сообщение ниже.", function(s)
			local textLen = string.utf8len(s)
			if textLen < 3 or textLen > 150 then
				notification.AddLegacy("Сообщение должно быть от 3 до 150 символов.", NOTIFY_ERROR, 5)
				return
			end

			netstream.Start("cp.BroadCode", s)
		end))
	end

	if lp:r_isCmD() then Add(scroll_list, "Speak To All", "Включение/Отключение режима Speak To All", function() RunConsoleCommand("radio_speak_to_all") end) end
end)
definePage("F5", "Законы", KEY_F5, 0.29255626081939, 1, function(screen, w, h)
	local lp = LocalPlayer()
	local header_h = name_fontsize * 2
	local sides_skip = w * 0.01
	local panels_w = w - sides_skip * 2

	local header = screen:Add("DPanel")
	header:SetTall(header_h)
	header:DockMargin(sides_skip, h * 0.005, sides_skip, h * 0.005)
	header:Dock(TOP)

	local dlabel_name = Label(lp:Name(), header)
	dlabel_name:SetFont("PDA.Name")
	dlabel_name:SetTextColor(name_col)
	dlabel_name:SizeToContents()
	dlabel_name:Dock(TOP)

	local dlabel_cid = Label("##" .. lp:GetCID(), header)
	dlabel_cid:SetFont("PDA.CID")
	dlabel_cid:SetTextColor(cid_col)
	dlabel_cid:SizeToContents()
	dlabel_cid:Dock(TOP)

	local logo_size = header_h - 4
	local logo_x = panels_w - logo_size - 4
	local faction = lp:isRebel() and "Повстанцы" or lp:isGSR() and "ГСР" or lp:isCP() and "Альянс" or "Неизвестно"
	local is_cmd = lp:isMayor() and "Администратор Земли" or lp:r_isCmD() and "Командование" or lp:Team() == TEAM_GSR6 and "Глава ГСР" or "Отсутствуют"
	function header:Paint(header_w, bh)
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(logo)
		surface.DrawTexturedRect(logo_x, 0, logo_size, logo_size)

		draw.SimpleText("Законы", "PDA.Buttons", logo_x, 0, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Фракция: " .. faction, "PDA.Buttons", logo_x, button_fontsize, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)
		draw.SimpleText("Доступ: " .. is_cmd, "PDA.Buttons", logo_x, button_fontsize * 2, name_col, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP)

		draw.RoundedBox(0, 0, logo_size, w, 2, col.o)
	end

	if lp:isMayor() then
		local player_buttons = screen:Add("DPanel")
		player_buttons:SetTall(h * .05)
		player_buttons:Dock(BOTTOM)
		player_buttons:DockMargin(sides_skip, 0, sides_skip, sides_skip)
		function player_buttons:Paint()
			return
		end

		local p_buttons = {
			{
				col.o,
				"ДОБАВИТЬ",
				UI_Request("Введите текст", "Введите текст закона.", "", function(s)
					netstream.Start("DRP_AddLaw", s)
				end)
			},
			{
				col.o,
				"СБРОСИТЬ",
				UI_Derma_Query("Вы уверены, что хотите сбросить законы?",
				"Подтверждение:",
					"Да",
					function()
						netstream.Start("DRP_ResetLaws")
					end,
					"Нет",
					function() end
				)
			},
			{
				col.o,
				"ЗАГРУЗИТЬ",
				UI_Derma_Query("Вы уверены, что хотите загрузить сохраненные законы? (все текущие сбросятся)",
				"Подтверждение:",
					"Да",
					function()
						laws:LoadSavedLaws()
					end,
					"Нет",
					function() end
				)
			},
			{
				col.o,
				"СОХРАНИТЬ",
				UI_Derma_Query("Вы уверены, что хотите сохранить текущие законы? (они перезапишут предыдущее сохранение)",
				"Подтверждение:",
					"Да",
					function()
						laws:SaveCurrentLaws()
					end,
					"Нет",
					function() end
				)
			}
		}
		local player_buttons_skip = panels_w * .005
		local actual_panels_w = panels_w / #p_buttons - (#p_buttons - 1) * player_buttons_skip
		for k, v in ipairs(p_buttons) do
			local b = player_buttons:Add("DButton")
			b:SetWide(actual_panels_w)
			b:DockMargin(player_buttons_skip, 0, player_buttons_skip, 0)
			b:Dock(LEFT)
			b:SetText(v[2])
			b:SetTextColor(color_white)
			b:SetFont("PDA.SmallerButton")

			local hovered, non_hovered = v[1], ColorAlpha(v[1], 100)
			function b:Paint(bw, bh)
				surface.SetDrawColor(self:IsHovered() and non_hovered or non_hovered)
				surface.DrawRect(0, 0, bw, bh)

				surface.SetDrawColor(hovered)
				surface.DrawOutlinedRect(0, 0, bw, bh, 2)
			end

			function b:DoClick()
				v[3]()
			end
		end
	end

	local scroll_list = screen:Add("DScrollPanel")
	--scroll_list:ErisScrollbar()
	scrolledit(scroll_list)
	scroll_list:DockMargin(sides_skip, 2, sides_skip, 2)
	scroll_list:Dock(FILL)

	local delete_icon = Material("icons/fa32/trash-o.png")
	local function Add(parent, lu, law_id)
		local pnl = vgui.Create("DPanel", parent)
		pnl:SetTall(h * .1)
		pnl:Dock(TOP)
		function pnl:Paint(bw, bh)
			draw.RoundedBox(0, 0, bh - 2, bw, 2, col.oa)
		end

		if lp:isMayor() then
			local b = vgui.Create("DButton", pnl)
			b:SetWide(h * .1)
			b:SetTall(h * .1)
			b:Dock(RIGHT)
			b:SetText("")
			function b:Paint(bw, bh)
				local icon_size = bh * .5
				if self:IsHovered() then
					surface.SetDrawColor(col.o)
				else
					surface.SetDrawColor(cid_col)
				end

				surface.SetMaterial(delete_icon)
				surface.DrawTexturedRect((bw - icon_size) * .5, (bh - icon_size) * .5, icon_size, icon_size)
			end

			function b:DoClick()
				netstream.Start("DRP_RemoveLaw", law_id)
			end
		end

		local b = Label(lu or "", pnl)
		b:Dock(FILL)
		b:DockMargin(0, 8, 0, 8)
		b:SetFont("PDA.Buttons")
		b:SetTextColor(name_col)
		b:SetWrap(true)
		b:SetMouseInputEnabled(true)
		function b:DoClick()
			SetClipboardText(lu)
			notification.AddLegacy("Текст был скопирован в буфер обмена", NOTIFY_GENERIC, 5)
		end

		function b:DoRightClick()
			UI_Request("Введите новый текст", "Введите новый текст закона.", lu, function(s) netstream.Start("DRP_ChangeLaw", law_id, s) end)()
		end

		return b
	end

	local function BuildLaws()
		scroll_list:Clear()
		for k, v in ipairs(DarkRP.getLaws()) do
			Add(scroll_list, v, k)
		end
	end

	BuildLaws()
	local hooks = {
		addLaw = function(k, v) Add(scroll_list, v, k) end,
		changeLaw = BuildLaws,
		removeLaw = BuildLaws,
		resetLaws = BuildLaws,
		loadLaws = BuildLaws,
	}

	for k, v in pairs(hooks) do
		hook.Add(k, "PDA.updateLaws", v)
	end

	function scroll_list:OnRemove()
		for k, v in pairs(hooks) do
			hook.Remove(k, "PDA.updateLaws", v)
		end
	end
end)
definePage("F6", nil, KEY_F6, 0.33064050778996, 1, nil)
definePage("FN", nil, nil, 0.40969417195615, 1, nil)

local close = table.insert(buttons_pos, { -- OFF
	x = 0.4466243508367,
	size = 1,
	tooltip = "Выключить",
	func = function(self)
		PDA:Remove()
	end
})
--[[table.insert(buttons_pos, { -- bright down
	x = 0.48413156376226,
	size = 1
})
table.insert(buttons_pos, { -- bright up
	x = 0.52048470859781,
	size = 1
})]]
key_to_button[KEY_ENTER] = buttons_pos[close]

local dist = 256
local function checkDistance(ent, ply, allowScan)
	return IsValid(ent) and (allowScan and IsValid(ply:GetLocalVar("Scanner"))) or ent:GetPos():Distance(ply:GetPos()) <= dist
end

properties.Add("OpenPlayerInfo", {
	MenuLabel = "Открыть информацию о гражданине",
	Order = 10,
	MenuIcon = "icon16/calculator.png",
	Filter = function(self, ent, ply) return checkDistance(ent, ply) and ent:IsPlayer() and ent:Alive() and (ply:isGSR() or ply:isCP()) end,
	Action = function(self, ent)
		if not IsValid(ent) then
			DarkRP.notify(1, 4, "Игрок не найден")
			return
		end

		if ent:GetNetVar("HideName") or ent:GetNetVar("HideCPName") then
			DarkRP.notify(1, 4, "У игрока скрыт CID")
			return
		end

		if not ent:isRecognised() and not LocalPlayer():isOTA() then
			DarkRP.notify(1, 4, "Автоматически ввести можно только если игрок вам представится!")
			return
		end

		OpenPDA()
		RequestPlayerData(ent:GetCID())
	end
})

hook.Add("PopulateToolMenu", "PDA_button_setting", function()
	spawnmenu.AddToolMenuOption("UnionRP", "Настройки", "PDA_setting_menu", "Планшет", "", "", function(option)
		option:AddControl("Numpad", {
			Label = "Кнопка открытия планшета",
			Command = "union_pda_bind_key"
		})
	end)
end)

hook.Add("PlayerButtonUp", "PDA_Bind", function(ply, key)
	if not IsFirstTimePredicted() then return end
	local bind = bind_key_convar:GetInt() or KEY_M
	if key == bind and (ply:isCP() or ply:isRebel() or ply:isGSR()) then OpenPDA() end
end)
