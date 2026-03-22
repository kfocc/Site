---------------------
--  ANTISPAM MENU  --
---------------------
function cl_PProtect.as_menu(p)
	-- clear Panel
	p:ClearControls()
	-- Main Settings
	p:addlbl("Основные настройки:", true)
	p:addchk("АнтиСпам", nil, cl_PProtect.Settings.Antispam["enabled"], function(c) cl_PProtect.Settings.Antispam["enabled"] = c end)
	if cl_PProtect.Settings.Antispam["enabled"] then
		-- General
		p:addchk("Исключение админам", nil, cl_PProtect.Settings.Antispam["admins"], function(c) cl_PProtect.Settings.Antispam["admins"] = c end)
		p:addchk("Звук предупреждения", nil, cl_PProtect.Settings.Antispam["alert"], function(c) cl_PProtect.Settings.Antispam["alert"] = c end)
		-- Anti-Spam features
		p:addlbl("\nВключение/Отключение:", true)
		p:addchk("Проп спам", nil, cl_PProtect.Settings.Antispam["prop"], function(c) cl_PProtect.Settings.Antispam["prop"] = c end)
		p:addchk("АнтиСпам Тулганом", nil, cl_PProtect.Settings.Antispam["tool"], function(c) cl_PProtect.Settings.Antispam["tool"] = c end)
		p:addchk("Запрет тулгана", nil, cl_PProtect.Settings.Antispam["toolblock"], function(c) cl_PProtect.Settings.Antispam["toolblock"] = c end)
		p:addchk("Запрет пропов", nil, cl_PProtect.Settings.Antispam["propblock"], function(c) cl_PProtect.Settings.Antispam["propblock"] = c end)
		p:addchk("Запрет энтитов", nil, cl_PProtect.Settings.Antispam["entblock"], function(c) cl_PProtect.Settings.Antispam["entblock"] = c end)
		p:addchk("Проп в пропе", nil, cl_PProtect.Settings.Antispam["propinprop"], function(c) cl_PProtect.Settings.Antispam["propinprop"] = c end)
		-- Tool Protection
		if cl_PProtect.Settings.Antispam["tool"] then p:addbtn("Настроить антиспам для тулов", "pprotect_request_tools", {"antispam"}) end
		-- Tool Block
		if cl_PProtect.Settings.Antispam["toolblock"] then p:addbtn("Настроить запрещенные тулы", "pprotect_request_tools", {"blocked"}) end
		-- Prop Block
		if cl_PProtect.Settings.Antispam["propblock"] then p:addbtn("Настроить заблокированные пропы", "pprotect_request_ents", {"props"}) end
		-- Ent Block
		if cl_PProtect.Settings.Antispam["entblock"] then p:addbtn("Настроить заблокированные энтити", "pprotect_request_ents", {"ents"}) end
		-- Cooldown
		--[[p:addlbl("\nDuration till the next prop-spawn/tool-fire:", true)
		p:addsld(0, 10, "Cooldown (Seconds)", cl_PProtect.Settings.Antispam["cooldown"], "Antispam", "cooldown", 1)
		p:addlbl("Number of props till admins get warned:")
		p:addsld(0, 40, "Amount", cl_PProtect.Settings.Antispam["spam"], "Antispam", "spam", 0)
		p:addlbl("Automatic action after spamming:")
		p:addcmb({"Nothing", "Cleanup", "Kick", "Ban", "Command"}, "spamaction", cl_PProtect.Settings.Antispam["spamaction"])

		-- Spamaction
		if cl_PProtect.Settings.Antispam["spamaction"] == "Ban" then
			p:addsld(0, 60, "Ban (Minutes)", cl_PProtect.Settings.Antispam["bantime"], "Antispam", "bantime", 0)
		elseif cl_PProtect.Settings.Antispam["spamaction"] == "Command" then
			p:addlbl("Use '<player>' to use the spamming player!")
			p:addlbl("Some commands need sv_cheats 1 to run,\nlike 'kill <player>'")
			p:addtxt(cl_PProtect.Settings.Antispam["concommand"])
		end]]
	end

	-- save Settings
	p:addbtn("Сохранить", "pprotect_save", {"Antispam"})
end

--------------
--  FRAMES  --
--------------
cl_PProtect.Blocked = {
	props = {},
	ents = {},
	atools = {},
	btools = {}
}

-- ANTISPAMED/BLOCKED TOOLS
net.Receive("pprotect_send_tools", function()
	local t = net.ReadString()
	local typ = "antispam"
	if t == "btools" then typ = "blocked" end
	cl_PProtect.Blocked[t] = net.ReadTable()
	local frm = cl_PProtect.addfrm(250, 350, typ .. " tools:", false)
	for key, _ in SortedPairs(cl_PProtect.Blocked[t]) do
		frm:addchk(key, nil, cl_PProtect.Blocked[t][key], function(c)
			net.Start("pprotect_save_tools")
			net.WriteTable({t, typ, key, c})
			net.SendToServer()
			cl_PProtect.Blocked[t][key] = c
		end)
	end
end)

-- BLOCKED PROPS/ENTS
net.Receive("pprotect_send_ents", function()
	local typ = net.ReadString()
	cl_PProtect.Blocked[typ] = net.ReadTable()
	local frm = cl_PProtect.addfrm(800, 600, "blocked " .. typ .. ":", true, "Save " .. typ, {typ, cl_PProtect.Blocked[typ]}, "pprotect_save_ents")
	for name, model in pairs(cl_PProtect.Blocked[typ]) do
		frm:addico(model, name, function(icon)
			local menu = DermaMenu()
			menu:AddOption("Убрать запрет", function()
				net.Start("pprotect_save_ents")
				net.WriteTable({typ, name})
				net.SendToServer()
				icon:Remove()
			end)

			menu:Open()
		end)
	end
end)

local pan = FindMetaTable("Panel")
local sldnum = 0
function pan:addslider(min, max, text, value, convar_name, decimals)
	local sld = vgui.Create("DNumSlider")
	sld:SetMin(min)
	sld:SetMax(max)
	sld:SetDecimals(decimals)
	sld:SetText(text)
	sld:SetDark(true)
	sld:SetValue(value)
	sld.TextArea:SetFont(cl_PProtect.setFont("Inter", 14, 500, true))
	sld.Label:SetFont(cl_PProtect.setFont("Inter", 14, 500, true))
	sld.Scratch:SetVisible(false)
	sld.OnValueChanged = function(self, number)
		if sldnum ~= math.Round(number, decimals) then sldnum = math.Round(number, decimals) end
		GetConVar(convar_name):SetFloat(sldnum)
	end

	function sld.Slider.Knob:Paint()
		draw.RoundedBox(6, 2, 2, 12, 12, Color(255, 150, 0))
	end

	function sld.Slider:Paint()
		draw.RoundedBox(2, 8, 15, 115, 2, Color(200, 200, 200))
	end

	self:AddItem(sld)
end

---------------------------
--  PROPPROTECTION MENU  --
---------------------------
function cl_PProtect.pp_menu(p)
	-- clear Panel
	p:ClearControls()
	-- Main Settings
	p:addlbl("Основные настройки:", true)
	p:addchk("Включение защиты", nil, cl_PProtect.Settings.Propprotection["enabled"], function(c) cl_PProtect.Settings.Propprotection["enabled"] = c end)
	if cl_PProtect.Settings.Propprotection["enabled"] then
		-- General
		p:addchk("Игнорирование создателями", nil, cl_PProtect.Settings.Propprotection["superadmins"], function(c) cl_PProtect.Settings.Propprotection["superadmins"] = c end)
		p:addchk("Игнорирование админами", nil, cl_PProtect.Settings.Propprotection["admins"], function(c) cl_PProtect.Settings.Propprotection["admins"] = c end)
		p:addchk("Админы могут использовать клинап", nil, cl_PProtect.Settings.Propprotection["adminscleanup"], function(c) cl_PProtect.Settings.Propprotection["adminscleanup"] = c end)
		-- Protections
		p:addlbl("\nНастройки защиты:", true)
		p:addchk("Использование", nil, cl_PProtect.Settings.Propprotection["use"], function(c) cl_PProtect.Settings.Propprotection["use"] = c end)
		-- p:addchk("Перезаряда", nil, cl_PProtect.Settings.Propprotection["reload"], function(c)
		-- 	cl_PProtect.Settings.Propprotection["reload"] = c
		-- end)
		p:addchk("Урон", nil, cl_PProtect.Settings.Propprotection["damage"], function(c) cl_PProtect.Settings.Propprotection["damage"] = c end)
		p:addchk("Гравипушка", nil, cl_PProtect.Settings.Propprotection["gravgun"], function(c) cl_PProtect.Settings.Propprotection["gravgun"] = c end)
		p:addchk("Поднятие пропов", "Pick up props with 'use'-key", cl_PProtect.Settings.Propprotection["proppickup"], function(c) cl_PProtect.Settings.Propprotection["proppickup"] = c end)
		p:addlbl("\nУдаление пропов при отключении:", true)
		p:addchk("Удаление", nil, cl_PProtect.Settings.Propprotection["propdelete"], function(c) cl_PProtect.Settings.Propprotection["propdelete"] = c end)
		-- Prop-Delete
		if cl_PProtect.Settings.Propprotection["propdelete"] then
			--   p:addchk("Keep admin's props", nil, cl_PProtect.Settings.Propprotection['adminsprops'], function(c)
			--     cl_PProtect.Settings.Propprotection['adminsprops'] = c
			--   end)
			p:addsld(5, 300, "Ожидание(секунд)", cl_PProtect.Settings.Propprotection["delay"], "Propprotection", "delay", 0)
		end
	end

	-- save Settings
	p:addbtn("Сохранить", "pprotect_save", {"Propprotection"})
end

------------------
--  BUDDY MENU  --
------------------
local txt, perms, sply = "", {
	phys = false,
	tool = false,
	use = false,
	prop = false,
	dmg = false
}, nil

local function edit_perm(ply, data)
	txt:SetText("Права (" .. ply:Nick() .. "):")
	for key, perm in pairs(data) do
		local permission = perms[key]
		if permission then permission:SetChecked(perm) end
	end
end

function cl_PProtect.b_menu(p)
	-- clear Panel
	p:ClearControls()
	-- add buddies
	p:addlbl("Друзья:", true)
	p:addlbl("Нажать на ник -> изменить права.", false)
	p:addlbl("Поставить галочку -> добавить/удалить друга.", false)
	-- add permissions
	p:addlbl("", true)
	txt = p:addlbl("Права:", true)
	perms.phys = p:addchk("Физган", nil, false, function(c) cl_PProtect.setBuddyPerm(sply, "phys", c) end)
	perms.tool = p:addchk("Тулган", nil, false, function(c) cl_PProtect.setBuddyPerm(sply, "tool", c) end)
	-- perms.use = p:addchk("Использование", nil, false, function(c)
	-- 	cl_PProtect.setBuddyPerm(sply, "use", c)
	-- 	end)
	perms.prop = p:addchk("С-Меню", nil, false, function(c) cl_PProtect.setBuddyPerm(sply, "prop", c) end)
	-- perms.dmg = p:addchk("Урон", nil, false, function(c)
	-- 	cl_PProtect.setBuddyPerm(sply, "dmg", c)
	-- end)
	p:addlbl("", true)
	local pls = player.GetAll()
	table.sort(pls, function(a, b)
		local _a, _b = utf8.force(a:Nick()), utf8.force(b:Nick())
		return string.utf8lower(_a) < string.utf8lower(_b)
	end)

	for _, ply in player.Iterator() do
		if ply == LocalPlayer() then continue end
		local chk = false
		local id = ply:SteamID()
		if istable(cl_PProtect.Buddies[id]) then chk = cl_PProtect.Buddies[id].bud end
		p:addplp(ply, chk, function()
			sply = ply
			local ps = {
				phys = false,
				tool = false,
				use = false,
				prop = false,
				dmg = false
			}

			if cl_PProtect.Buddies[id] then ps = cl_PProtect.Buddies[id].perm end
			edit_perm(ply, ps)
		end, function(c) cl_PProtect.setBuddy(ply, c) end)
	end
end

--------------------
--  CLEANUP MENU  --
--------------------
local o_global, o_players = 0, {}
function cl_PProtect.cu_menu(p)
	-- clear Panel
	p:ClearControls()
	p:addlbl("Очистить всё:", true)
	p:addbtn("Очистить всё (" .. tostring(o_global) .. " пропов)", "pprotect_cleanup", {"all"})
	p:addlbl("\nОчистить пропы игроков, которые вышли:", true)
	p:addbtn("Очистить пропы отключенных", "pprotect_cleanup", {"disc"})
	p:addlbl("\nCleanup unowned props:", true)
	p:addbtn("Cleanup all unowned props", "pprotect_cleanup", {"unowned"})
	if o_global == 0 then return end
	p:addlbl("\nОчистить пропы игроков:", true)
	for pl, c in pairs(o_players) do
		p:addbtn("Очистить пропы  " .. pl:Nick() .. " (" .. tostring(c) .. ")", "pprotect_cleanup", {"ply", pl, tostring(c)})
	end
end

----------------------------
--  CLIENT SETTINGS MENU  --
----------------------------
function cl_PProtect.cs_menu(p)
	-- clear Panel
	if not p then return end
	local lp = LocalPlayer()
	p:ClearControls()
	p:addlbl("Ивенты", true)
	p:addchk("Озвучка", "Музыка", GetConVar("unionrp_music"):GetBool() or false, function(c) RunConsoleCommand("unionrp_music", GetConVar("unionrp_music"):GetBool() and 0 or 1) end)
	p:addsld(0, 100, "Громкость музыки", GetConVar("unionrp_music_volume"):GetInt() * 100, nil, nil, 0, function(c)
		RunConsoleCommand("unionrp_music_volume", c / 100)
	end)

	p:addlbl("Игроки", true)
	p:addchk("Озвучка", "Текст в чате озвучивается", GetConVar("unionrp_chatsounds"):GetBool() or false, function(c) RunConsoleCommand("unionrp_chatsounds", GetConVar("unionrp_chatsounds"):GetBool() and 0 or 1) end)
	p:addchk("Украинская озвучка", "Текст в чате озвучивается украинским языком", GetConVar("unionrp_ukr"):GetBool() or false, function(c) RunConsoleCommand("unionrp_ukr", GetConVar("unionrp_ukr"):GetBool() and 0 or 1) end)
	p:addlbl("Чат", true)
	p:AddControl("Numpad", {
		Label = "Смена дальности чата и войса",
		Command = "union_voice_proximity_key"
	})

	p:addchk("Выключить OOC", "Выключение показа OOC чата", lp:GetNetVar("ooc_state", false), function(c) RunConsoleCommand("change_ooc_state") end)
	p:addchk("Выключить LOOC", "Выключение показа LOOC чата", lp:GetNetVar("looc_state", false), function(c) RunConsoleCommand("change_looc_state") end)
	p:addchk("Скрыть ULX логи", "Отключение отображения действий администрации в чате", GetConVar("unionrp_ulxlog_disable"):GetBool() or false, function(c) RunConsoleCommand("unionrp_ulxlog_disable", GetConVar("unionrp_ulxlog_disable"):GetBool() and 0 or 1) end)
	p:addlbl("", true)
	p:addchk("Включить показ времени", "Включение показа времени перед сообщением в чате", SChat2:GetConvar("showTimestamps", false), function(c) SChat2:SetConvar("showTimestamps", c) end)
	p:addchk("Включить звук PM сообщения", "Включение звука получения сообщения в чате", SChat2:GetConvar("playPMSound", false), function(c) SChat2:SetConvar("playPMSound", c) end)
	p:addchk("Закрывать чат после отправки", "Закрывать чат после отправки сообщения?", SChat2:GetConvar("closeOnEnter", true), function(c) SChat2:SetConvar("closeOnEnter", c) end)
	p:addchk("Закрывать чат после отправки PM", "Закрывать чат после отправки приватного сообщения?", SChat2:GetConvar("closeOnEnterPM", true), function(c) SChat2:SetConvar("closeOnEnterPM", c) end)
	p:addsld(-3, 6, "Размер шрифта", SChat2.richTextFonts[SChat2:GetConvar("richTextFont", SChat2.Config.richTextFont)], nil, nil, 0, function(c)
		timer.Create("change.TextFont.Panel.Throttle", 0.5, 1, function()
			local chatFont = SChat2.richTextFonts[c]
			if not chatFont then chatFont = SChat2.Config.richTextFont end
			SChat2:SetConvar("richTextFont", chatFont)
		end)
	end)
	p:addchk("Включить фильтрацию ненормативной лексики", "Заменять ругательства и оскорбления на «♥♥♥» или «***» через фильтры Steam", GetConVar("gm_safespace_enabled"):GetBool(), function(c) GetConVar("gm_safespace_enabled"):SetBool(c) end)

	if lp:isVIP() then
		p:addlbl("VIP", true)
		p:addchk("Вип чат", "Отображение вип чата", GetConVar("unionrp_vipchat"):GetBool() or false, function(c) RunConsoleCommand("unionrp_vipchat", GetConVar("unionrp_vipchat"):GetBool() and 0 or 1) end)
	end

	p:addbtn("Сбросить настройки", "reset_settings", function() SChat2:ResetConvars() end)
	p:addlbl("Предметы", true)
	p:addchk("Владелец пропа", "Отображение владельца пропа.", cl_PProtect.Settings.CSettings["ownerhud"], function(c) cl_PProtect.update_csetting("ownerhud", c) end)
	p:addchk("Оповещение", "Получение оповещений с пропами.", cl_PProtect.Settings.CSettings["notes"], function(c) cl_PProtect.update_csetting("notes", c) end)
	p:addchk("Отображение опоры", "При взятии пропа отображает плоскость опоры на мир.", checkCollideDisplay == true, function(c) checkCollideDisplay = c end)
	p:addlbl("Игрок", true)
	local tpChk = p:addchk("Вид от 3-го лица", "Вид от 3-го лица. При прицеле идет отключение", ThirdPerson.IsEnabled(), function(c) RunConsoleCommand("union_tp_toggle") end)
	tpChk.OnChange = function(self)
		RunConsoleCommand("union_tp_toggle")
		timer.Simple(0, function() self:SetChecked(ThirdPerson.IsEnabled()) end)
	end

	p:addslider(5, 15, "Скорость анимации", GetConVar("union_tp_smooth"):GetInt(), "union_tp_smooth", 0)
	p:addslider(-10, 10, "Положение камеры", GetConVar("union_tp_position"):GetInt(), "union_tp_position", 0)
	p:addchk("Ноги", "Отображение ног в виде от 1-го лица", GetConVar("Union_legs_toggle"):GetBool() or false, function(c) RunConsoleCommand("Union_legs_toggle", GetConVar("Union_legs_toggle"):GetBool() and 0 or 1) end)
	p:addlbl("Интерфейс", true)
	p:addchk("Отображать точные значения", "Показывает сколько осталось здоровья и брони без перевода в проценты", GetConVar("Union_hud_accurate"):GetBool() or false, function(c) RunConsoleCommand("Union_hud_accurate", GetConVar("Union_hud_accurate"):GetBool() and 0 or 1) end)
	p:addchk("Выбор оружия", "Наш интерфейс выбора оружия", GetConVar("Union_weapon_selector"):GetBool() or false, function(c) RunConsoleCommand("Union_weapon_selector", GetConVar("Union_weapon_selector"):GetBool() and 0 or 1) end)
	p:addchk("Сторона выбора оружия", "Выбор с какой стороны будет выбор оружия", GetConVar("Union_weapon_selector_side"):GetBool() or false, function(c) RunConsoleCommand("Union_weapon_selector_side", GetConVar("Union_weapon_selector_side"):GetBool() and 0 or 1) end)
	p:addchk("Зоны", "Отображение названий зон при входе", GetConVar("unionrp_zonehud"):GetBool() or false, function(c) RunConsoleCommand("unionrp_zonehud", GetConVar("unionrp_zonehud"):GetBool() and 0 or 1) end)
	p:addchk("Время", "Отображение времени в интерфейсе", GetConVar("unionrp_time"):GetBool() or false, function(c) RunConsoleCommand("unionrp_time", GetConVar("unionrp_time"):GetBool() and 0 or 1) end)
	if lp:isZombie() then p:addchk("Зомби-фильтр", "Включение/Выключение зеленого фильтра у зомби.", GetConVar("union_zombie_nv"):GetBool() or false, function(c) RunConsoleCommand("union_zombie_nv", GetConVar("union_zombie_nv"):GetBool() and 0 or 1) end) end
	-- if lp:isCP() then
	-- 	p:addlbl("Альянс", true)
	-- 	p:addchk("Визор шлема", "Включение/Выключение визора.", GetConVar("unionrp_combineoverlay"):GetBool() or false, function(c)
	-- 		RunConsoleCommand("unionrp_combineoverlay", GetConVar("unionrp_combineoverlay"):GetBool() and 0 or 1)
	-- 	end)
	-- 	p:addchk("Фото от сканеров", "Включение/Выключение приема фото от сканеров.", GetConVar("unionrp_scanner_photo"):GetBool() or false, function(c)
	-- 		RunConsoleCommand("unionrp_scanner_photo", GetConVar("unionrp_scanner_photo"):GetBool() and 0 or 1)
	-- 	end)
	-- end
	-- if lp:IsNabor() then
	-- 	p:addlbl("Администратор", true)
	-- 	p:addchk("AN", "Система админ нотификаций в чате.", GetConVar("unionrp_adminnotify"):GetBool(), function(c)
	-- 		RunConsoleCommand("unionrp_adminnotify", GetConVar("unionrp_adminnotify"):GetBool() and 0 or 1)
	-- 	end)
	-- end
	if cats.config.allowedUsergroups[lp:GetUserGroup()] then p:addchk("ESP", "Отображение ESP во время ноклипа", GetConVar("unionrp_admin_wallhack"):GetBool(), function(c) RunConsoleCommand("unionrp_admin_wallhack", GetConVar("unionrp_admin_wallhack"):GetBool() and 0 or 1) end) end
	if lp:IsNabor() then p:addchk("Отключение маскировки", "Отключает отображение маскировки в табе", GetConVar("unionrp_ignore_mask"):GetBool(), function(c) RunConsoleCommand("unionrp_ignore_mask", GetConVar("unionrp_ignore_mask"):GetBool() and 0 or 1) end) end
	p:addlbl("Голосование", true)
	p:AddControl("Numpad", {
		Label = "Голосование (За)",
		Command = "union_vote_y_key"
	})

	p:AddControl("Numpad", {
		Label = "Голосование (Против)",
		Command = "union_vote_n_key"
	})
end

--------------------
--  CREATE MENUS  --
--------------------
--hook.Add("AddToolMenuTabs", "myHookClass", function()
--spawnmenu.AddToolTab("UnionRP", "UnionRP", "icon16/plugin.png")
--end)
local function CreateMenus()
	-- Anti-Spam
	spawnmenu.AddToolMenuOption("UnionRP", "Админ", "PPAntiSpam", "АнтиСпам", "", "", function(p) cl_PProtect.UpdateMenus("as", p) end)
	-- Prop-Protection
	spawnmenu.AddToolMenuOption("UnionRP", "Админ", "PPPropProtection", "Защита", "", "", function(p) cl_PProtect.UpdateMenus("pp", p) end)
	-- Buddy
	spawnmenu.AddToolMenuOption("UnionRP", "Настройки", "PPBuddy", "Доступ", "", "", function(p) cl_PProtect.UpdateMenus("b", p) end)
	-- Cleanup
	spawnmenu.AddToolMenuOption("UnionRP", "Админ", "PPCleanup", "Очистка", "", "", function(p) cl_PProtect.UpdateMenus("cu", p) end)
	-- Client-Settings
	spawnmenu.AddToolMenuOption("UnionRP", "Настройки", "PPClientSettings", "Интерфейс", "", "", function(p) cl_PProtect.UpdateMenus("cs", p) end)
end

hook.Add("PopulateToolMenu", "pprotect_make_menus", CreateMenus)
hook.Add("PopulateToolMenu", "pr_button_setting", function()
	spawnmenu.AddToolMenuOption("UnionRP", "Настройки", "pr_setting_menu", "Рация", "", "", function(option)
		option:AddControl("Numpad", {
			Label = "Кнопка разговора",
			Command = "union_radio_bind_key"
		})

		option:AddControl("Numpad", {
			Label = "Кнопка настройка (для ГО и ОТА)",
			Command = "union_radio_settings_key"
		})

		option:AddControl("Numpad", {
			Label = "Вкл/Выкл рацию (голос и звук)",
			Command = "union_radio_mute_key"
		})
	end)
end)

--------------------
--  UPDATE MENUS  --
--------------------
local function showErrorMessage(p, msg)
	p:ClearControls()
	p:addlbl(msg)
end

local pans = {}
function cl_PProtect.UpdateMenus(p_type, panel)
	-- add Panel
	-- if not p_type or not panel then return end
	if p_type and not IsValid(pans[p_type]) then pans[p_type] = panel end
	for t in pairs(pans) do
		if t == "as" or t == "pp" then
			if LocalPlayer():IsSuperAdmin() then
				RunConsoleCommand("pprotect_request_new_settings", t)
			else
				showErrorMessage(pans[t], "Вам нужно быть основателем для смены\nнастроек")
			end
		elseif t == "cu" then
			if LocalPlayer():IsSuperAdmin() or LocalPlayer():IsAdmin() and cl_PProtect.Settings.Propprotection["adminscleanup"] then
				RunConsoleCommand("pprotect_request_new_counts")
			else
				showErrorMessage(pans[t], "Вам нужно быть основателем для\nизменения настроек")
			end
		else
			if IsValid(pans[t]) then cl_PProtect[t .. "_menu"](pans[t]) end
		end
	end
end

hook.Add("SpawnMenuOpen", "pprotect_update_menus", cl_PProtect.UpdateMenus)
---------------
--  NETWORK  --
---------------
-- RECEIVE NEW SETTINGS
net.Receive("pprotect_new_settings", function()
	local settings = net.ReadTable()
	local typ = net.ReadString()
	cl_PProtect.Settings.Antispam = settings.AntiSpam
	cl_PProtect.Settings.Propprotection = settings.PropProtection
	if typ ~= "as" and typ ~= "pp" then return end
	if IsValid(pans[typ]) then cl_PProtect[typ .. "_menu"](pans[typ]) end
end)

-- RECEIVE NEW PROP-COUNTS
net.Receive("pprotect_new_counts", function()
	local counts = net.ReadTable()
	-- set new Count-Data
	o_global = counts.global
	o_players = counts.players
	-- create new Cleanup-Panel
	cl_PProtect.cu_menu(pans.cu)
end)
