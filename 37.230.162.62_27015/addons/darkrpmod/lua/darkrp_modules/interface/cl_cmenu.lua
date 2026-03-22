local pairs = pairs
local table_GetFirstValue = table.GetFirstValue
local table_insert = table.insert
local Derma_StringRequest = Derma_StringRequest
local Derma_DrawBackgroundBlur = Derma_DrawBackgroundBlur
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local LocalPlayer = LocalPlayer
local net_Start = net.Start
local net_WriteBool = net.WriteBool
local net_WriteString = net.WriteString
local net_SendToServer = net.SendToServer
local RunConsoleCommand = RunConsoleCommand
local tostring = tostring
local istable = istable
local SortedPairs = SortedPairs
local player_GetAll = player.GetAll
local table_sort = table.sort
local ipairs = ipairs
local string_format = string.format
local netstream = netstream
local SortedPairsByMemberValue = SortedPairsByMemberValue
local print = print
local net_WriteEntity = net.WriteEntity
local IsValid = IsValid
local netvars_GetNetVar = netvars.GetNetVar
local radio_admin_menu = radio_admin_menu
local tonumber = tonumber
local isnumber = isnumber
local build_law_menu = build_law_menu
local team_GetName = team.GetName
local DarkRP = DarkRP
local Color = Color
local netvars = netvars
local isfunction = isfunction
local GetTauntList = GetTauntList
local hook_Run = hook.Run
local StartTaunt = StartTaunt
local hook_Add = hook.Add
local vgui_Create = vgui.Create
local ScrH = ScrH
local ScrW = ScrW
local AccessorFunc = AccessorFunc
local draw_RoundedBox = draw.RoundedBox
local math_max = math.max
local math_min = math.min
local derma_SkinHook = derma.SkinHook
local DScrollPanel = DScrollPanel
local gui_MouseX = gui.MouseX
local gui_MouseY = gui.MouseY
local derma_DefineControl = derma.DefineControl
local draw_NoTexture = draw.NoTexture
local surface_DrawPoly = surface.DrawPoly
local CloseDermaMenus = CloseDermaMenus
local DButton = DButton
local table_IsEmpty = table.IsEmpty
local draw_SimpleText = draw.SimpleText
local string_Interpolate = string.Interpolate
--[[ #NoSimplerr# ]]
local function fnFilter(f, xs)
	local res = {}
	for k, v in pairs(xs) do
		if f(v) then res[k] = v end
	end
	return res
end

local function fnHead(xs)
	return table_GetFirstValue(xs)
end

local context_menu_pos = "left" --available bot,right,left
local Menu = {}
local function Option(title, icon, cmd, check)
	table_insert(Menu, {
		title = title,
		icon = icon,
		cmd = cmd,
		check = check
	})
end

local function SubMenu(title, icon, func, check)
	table_insert(Menu, {
		title = title,
		icon = icon,
		func = func,
		check = check
	})
end

local function Spacer(check)
	table_insert(Menu, {
		check = check
	})
end

-- Derma_Query(
--     "Are you sure about that?",
--     "Confirmation:",
--     "Yes",
--     function() print("They clicked the yes button.") end,
--   "No",
--   function() print("They clicked the no button.") end
-- )
local function UI_Derma_Query(text, title, btnText1, func1, btnText2, func2, btnText3)
	return function()
		local painter = Derma_Query(text, title, btnText1, func1, btnText2, func2, btnText3)
		painter:SetTitle("")
		painter.Paint = function(s, w, h)
			Derma_DrawBackgroundBlur(s, s.start)
			surface_SetDrawColor(col.ba)
			surface_DrawRect(0, 0, w, h)

			surface_SetDrawColor(col.o)
			surface_DrawRect(0, 0, w, 20)

			draw_SimpleText(title, "DermaDefault", 8, 10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		painter.PaintOver = function(s, w, h)
			surface_SetDrawColor(75, 75, 75, 200)
			surface_DrawOutlinedRect(0, 0, w, h, 1)
		end
	end
end

local function Request(title, text, defText, func, extended)
	return function()
		if isfunction(defText) then
			extended = func
			func = defText
			defText = ""
		end

		local painter = Derma_StringRequest(title, text, defText, function(s) func(s) end)
		painter:SetTitle("")

		painter.Paint = function(s, w, h)
			Derma_DrawBackgroundBlur(s, s.start)
			surface_SetDrawColor(col.ba)
			surface_DrawRect(0, 0, w, h)

			surface_SetDrawColor(col.o)
			surface_DrawRect(0, 0, w, 24)

			draw_SimpleText(title, "DermaDefault", 8, 12, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		painter.PaintOver = function(s, w, h)
			surface_SetDrawColor(75, 75, 75, 200)
			surface_DrawOutlinedRect(0, 0, w, h, 1)
		end

		if extended then
			local InnerPanel = painter:GetChild(4)
			local ButtonPanel = painter:GetChild(5)
			local TextEntry = InnerPanel:GetChild(1)
			painter:SetTall(painter:GetTall() + 24)
			painter:Center()
			InnerPanel:StretchToParent(5, 25, 5, 45)
			TextEntry:StretchToParent(5, nil, 5, 0)
			TextEntry:SetMultiline(true)
			function TextEntry:AllowInput(char)
				if char == "\n" then return true end
			end

			ButtonPanel:CenterHorizontal()
			ButtonPanel:AlignBottom(8)
		end
	end
end

_G.UI_Request = Request
_G.UI_Derma_Query = UI_Derma_Query

local function isCP()
	return LocalPlayer():isCP()
end

local function SH()
	return LocalPlayer():CanUsePhrases()
end

local function add(t)
	table_insert(Menu, t)
end

--[[ YOU CAN EDIT STUFF BELOW THIS POINT ]]
--bullet_wrench
--[[SubMenu("Гильдии", "icon16/user_comment.png", function(self)
  self:AddOption("Меню гильдии", function()
    RunConsoleCommand("org_menu")
  end)
  self:AddOption("Выйти из гильдии", function()
    RunConsoleCommand("org_leave")
  end)
end)]]
Option("Вызов администратора", "icon16/flag_red.png", Request("Вызов администратора", "Опишите жалобу как можно точнее.", function(s)
	net_Start("SChat2.Send")
	net_WriteBool(false)
	net_WriteString("/// " .. s)
	net_SendToServer()
end))

--Option("Застрял", "icon16/flag_blue.png", function()
--RunConsoleCommand("say", "/unstuck")
--end)
Option("Объявление", "icon16/flag_yellow.png", function()
	RunConsoleCommand("darkrp", "advert")
end)
--[[
Option("Крик", "icon16/comment_add.png", Request("Крик", "Напишите текст ниже.", function(s)
  RunConsoleCommand("darkrp", "y", s)
end))

Option("Шепот", "icon16/comment_delete.png", Request("Шепот", "Напишите текст ниже.", function(s)
  RunConsoleCommand("darkrp", "w", s)
end))
--]]
Spacer()

Option("Донат", "icon16/coins_add.png", function()
	RunConsoleCommand("say", "/donate")
end)

--Option("Бонусы", "icon16/ruby.png", function()
--  RunConsoleCommand("say", "/rewards")
--end)
Spacer()

Option("Остановить звуки", "icon16/sound_delete.png", function()
	RunConsoleCommand("stopsound")
end)

local teams = {
	[TEAM_GFAST] = true,
	[TEAM_GSPY] = true,
	[TEAM_AGENT] = true,
	[TEAM_ELITE4] = true
}

SubMenu("Токены", "icon16/money.png", function(self)
	self:AddOption("Выкинуть токены", Request("Выкинуть токены", "Сколько вы хотите выкинуть токенов?", function(s) RunConsoleCommand("darkrp", "dropmoney", tostring(s)) end)):SetIcon("icon16/money.png")

	self:AddOption("Дать токены", Request("Дать токены", "Сколько вы хотите передать токенов?", function(s) RunConsoleCommand("darkrp", "give", tostring(s)) end)):SetIcon("icon16/money_add.png")

	local sbutton, submenu = self:AddSubMenu("Выписать чек")
	submenu:SetIcon("icon16/note_edit.png")

	local lp = LocalPlayer()
	local plys = player.GetAll()
	table.sort(plys, function(a, b) return a:GetLocalPlayerRelativeTeam() < b:GetLocalPlayerRelativeTeam() end)

	for k, v in ipairs(plys) do
		if v == lp then continue end
		if v:GetNetVar("MaskMe") then continue end
		if (lp:isCP() and not lp:isRebel()) and teams[v:Team()] and not v:GetNetVar("TeamNum") then continue end

		local lteam = v:GetLocalPlayerRelativeTeam()
		local name, job, jobcolor = v:Name(), team.GetName(lteam), v:GetTeamColor()
		local opt = sbutton:AddOption(string_format("%s(%s)", name, job), Request("Сумма", "Введите сумму для чека", function(s) RunConsoleCommand("darkrp", "check", v:SteamID(), s) end))
		-- opt:SetImage("icon16/note_edit.png")
		opt:SetColor(jobcolor)
	end
end)

SubMenu("Фразы", "icon16/user.png", function(self)
	local tbl = LocalPlayer():getJobTable().sounds
	if istable(tbl[1]) then
		if LocalPlayer():isFemale() then
			tbl = tbl[1]
		else
			tbl = tbl[2]
		end
	end

	for k, v in SortedPairs(tbl) do
		self:AddOption(k, function() RunConsoleCommand("say", k) end):SetImage("icon16/user_comment.png")
	end
end, SH)

SubMenu("Действия", "icon16/plugin_go.png", function(self)
	local ply = LocalPlayer()
	self:AddOption("Выкинуть оружие", function() RunConsoleCommand("darkrp", "drop") end):SetIcon("icon16/gun.png")

	self:AddOption("Продать все двери", function() RunConsoleCommand("darkrp", "sellalldoors") end):SetIcon("icon16/door.png")

	--[[self:AddOption("Выбить дверь", function()
		RunConsoleCommand("say", "/doorkick")
	end):SetIcon("icon16/lock_delete.png")]]
	self:AddOption("Сменить имя", Request("Смена имени", "Какое имя вы себе хотите?", function(s) RunConsoleCommand("darkrp", "rpname", s) end)):SetIcon("icon16/comment_edit.png")

	self:AddOption("Бросить кубик", function() RunConsoleCommand("say", "/roll 6") end):SetIcon("icon16/bell.png")

	self:AddOption("Случайное число", function() RunConsoleCommand("say", "/roll 100") end):SetIcon("icon16/bell.png")

	if ply:Team() == TEAM_BAND4 then self:AddOption("Установить цену заказа", Request("Установка цены за заказ", "Введите вашу цену за заказ", function(s) RunConsoleCommand("darkrp", "hitprice", s) end)):SetIcon("icon16/layout.png") end

	local MAX_REQUEST_LENGTH = 256
	if ply:isCitizen() or ply:isGSR() or ply:isLoyal() or ply:isGang() or ply:Team() == TEAM_BICH1 or ply:Team() == TEAM_BICH2 or ply:Team() == TEAM_BICH3 then
		self:AddOption("Запрос медика ГСР", Request("Запрос медика ГСР", "Напишите причину запроса ниже (" .. MAX_REQUEST_LENGTH .. " символов).", function(s)
			-- ply:ConCommand("say /03 " .. s)
			if utf8.len(s) >= MAX_REQUEST_LENGTH then s = utf8.sub(s, 1, MAX_REQUEST_LENGTH) .. "..." end
			netstream.Start("request.call", "03", s)
		end)):SetIcon("icon16/telephone_error.png")
	end

	if ply:isCitizen() or ply:isGSR() or ply:isLoyal() or ply:isGang() or ply:isCP() and not ply:isOTA() and not ply:isSynth() or ply:Team() == TEAM_BICH1 or ply:Team() == TEAM_BICH2 or ply:Team() == TEAM_BICH3 then
		self:AddOption("Запрос повара ГСР", Request("Запрос повара ГСР", "Напишите причину запроса ниже (" .. MAX_REQUEST_LENGTH .. " символов).", function(s)
			-- ply:ConCommand("say /calleat " .. s)
			if utf8.len(s) >= MAX_REQUEST_LENGTH then s = utf8.sub(s, 1, MAX_REQUEST_LENGTH) .. "..." end
			netstream.Start("request.call", "calleat", s)
		end)):SetIcon("icon16/telephone_error.png")
	end

	if ply:isCitizen() or ply:isGSR() or ply:isLoyal() or ply:isGang() then
		self:AddOption("Запрос ГО", Request("Запрос ГО", "Напишите причину запроса ниже (" .. MAX_REQUEST_LENGTH .. " символов).", function(s)
			-- ply:ConCommand("say /911 " .. s)
			if utf8.len(s) >= MAX_REQUEST_LENGTH then s = utf8.sub(s, 1, MAX_REQUEST_LENGTH) .. "..." end
			netstream.Start("request.call", "911", s)
		end)):SetIcon("icon16/telephone_error.png")
	end

	if ply.Disguised then self:AddOption("Снять маскировку", function() netstream.Start("UnDisguise") end):SetIcon("icon16/user_delete.png") end
end)

Option("Стать человеком", "icon16/pill.png", function() RunConsoleCommand("darkrp", "citizen") end, function() return LocalPlayer():isZombie() or LocalPlayer():Team() == TEAM_GMAN end)
local fIcon = "icon16/%s.png"
SubMenu("GPS", "icon16/map_magnify.png", function(self)
	local deac = self:AddOption("Отключить GPS", function(s) if gps:IsActive() then gps:Deactivate() end end)
	deac:SetIcon("icon16/cancel.png")
	self:AddSpacer()
	-- local categories = gps:GetCategories()
	local categories = gps:GetAccessedCategories()
	local gpsConfig = gps.config
	local defCategoryIcon = gpsConfig.defaultCategoryIcon
	for categoryName, categoryData in SortedPairsByMemberValue(categories, "priority") do
		local c, p = self:AddSubMenu(categoryName)
		local icon = categoryData.icon or defCategoryIcon
		p:SetIcon(fIcon:format(icon))
		for pointName, pointData in SortedPairs(categoryData.list) do
			local point = c:AddOption(pointName, function(s) gps:Activate(pointName) end)
			local icon = pointData.icon or gpsConfig.defaultIcon
			point:SetIcon(fIcon:format(icon))
		end
	end
end)

SubMenu("Маска", "icon16/user_suit.png", function(self)
	local isMaskActive = LocalPlayer():GetNetVar("HideName")
	self:AddOption("Состояние: " .. (isMaskActive and "Надета" or "Не надета"), function(s) end):SetIcon("icon16/note.png")
	self:AddSpacer()
	self:AddOption(isMaskActive and "Снять" or "Надеть", function(s)
		net_Start("UnionRP.B.Mask")
		net_SendToServer()
	end):SetIcon(isMaskActive and "icon16/cancel.png" or "icon16/user_gray.png")
end, function() return LocalPlayer():GetNetVar("bandana.CanUse") end)

local voices
local translate_category = {
	malecitizenhl2 = "Гражданские",
	femalecitizenhl2 = "Гражданские",
	breenhl2 = "Брин",
	kleinerhl2 = "Кляйнер",
	metropolicehl2 = "ГО",
	vipmemes = "VIP",
	barneyhl2 = "Барни",
	mossmanhl2 = "Моссман",
	gmanhl2 = "GMAN",
	elihl2 = "Илай",
	vortigaunthl2 = "Вортигонт",
	grigoriyhl2 = "Григорий",
	alyxhl2 = "Аликс",
	combinesoldierhl2 = "ОТА",
	odessahl2	 = "Одесса",
}
SubMenu("Общение", "icon16/group.png", function(self)
	local stored = unionrp.sounds.stored
	if #voices == 1 then
		local class = voices[1]
		local pan = self
		for j, data in SortedPairsByMemberValue(stored[class], "phrase") do
			self:AddOption(data.phrase, function(self) RunConsoleCommand("say", self:GetText()) end):SetImage("icon16/user_comment.png")
		end
	else
		for i, class in ipairs(voices) do
			local pan, option = self:AddSubMenu(translate_category[class] or class)
			for j, data in SortedPairsByMemberValue(stored[class], "phrase") do
				pan:AddOption(data.phrase, function(self) RunConsoleCommand("say", self:GetText()) end):SetImage("icon16/user_comment.png")
			end
		end
	end
end, function()
	voices = unionrp.sounds.GetClass(LocalPlayer())
	return #voices > 0
end)

local color_red = Color(255, 0, 0)
local color_green = Color(0, 255, 0)

Spacer(function() return LocalPlayer():isRebel() end)

SubMenu("Сопротивление", "icon16/user_red.png", function(self)
	local teleportStatus = netvars_GetNetVar("Teleport.Destroyed")
	local teleport, s = self:AddSubMenu("Состояние телепорта")
	s:SetIcon("icon16/lightning.png")

	local tpStat = teleport:AddOption("Статус: " .. (teleportStatus and "Сломан" or "Работает"), function(s) end)
	tpStat:SetImage(teleportStatus and "icon16/error.png" or "icon16/connect.png")
	tpStat:SetColor(teleportStatus and color_red or color_green)

	if teleportStatus then
		teleport:AddSpacer()
		local count = netvars_GetNetVar("Teleport.IronersCount", 0)
		local matCount = teleport:AddOption("Количество материалов для починки: " .. count .. " / 30.", function(s) end)
		matCount:SetImage("icon16/folder.png")
	end

	local isPillPoisoned = LocalPlayer():GetNetVar("pill.isPoisoned")
	if isPillPoisoned then
		self:AddSpacer()
		self:AddOption("Использовать капсулу с ядом", function(s)
			isPillPoisoned = LocalPlayer():GetNetVar("pill.isPoisoned")
			if not isPillPoisoned then return end
			netstream.Start("pill.UsePoison")
		end):SetIcon("icon16/pill_go.png")
	end
end, function() return LocalPlayer():isRebel() end)

Spacer(function() return LocalPlayer():isRebel() end)
Spacer(function() return LocalPlayer():isGSR() and not LocalPlayer():isRebel() end)
--Option("Радио - частота", "icon16/telephone_add.png", Request("Выбор частоты радио", "Выберите частоту от 0 до 100", function(s)
--	LocalPlayer():ConCommand("say /channel "..s)
--end))
--Option("Радио - общение", "icon16/telephone.png", Request("Общение по радио", "Напишите текст на настроенную частоту", function(s)
--	LocalPlayer():ConCommand("say /radio "..s)
--end))
local list = {"Обнаружено тяжкое несоотвествие. Асоциальный статус подтверждён", "Ваш квартал обвиняется в недоносительстве. Штраф - 5 пищ.единиц", "Судебное разбирательство отменено. Казнь - по усмотрению", "Отказ от сотрудничества - выселение в нежилое пространство", "Вы обвиняетесь в антиобщественной деятельности первого уровня", "Введен код действия при беспорядках", "О противоправном поведении немедленно доложить силам ГО", "Вниманию юнитам ГО! Приговор выносить по усмотрению", "Вам предъявлено обвинение в социальной угрозе, уровень 1", "Вам предъявлено обвинение в социальной угрозе, уровень 5", "Вы обвиняетесь во множественных нарушениях", "Отряду ГО: признаки антиобщественной деятельности", "Внимание! Уклонистское поведение. Неподчинение обвиняемого", "Обнаружены локальные беспорядки", "Неопознанное лицо! Подтвердите статус в отделе ГО", "Вниманию наземных сил! В сообществе найден нарушитель", "Внимание! В квартале потенциальный источник вреда обществу", "Вниманию отряда ГО, обнаружено уклонение от надзора", "Сотрудничество с отрядом ГО награждается полным пищ.рационом", "Производится проверка данных. Занять места для инспекции", "Жилому кварталу, занять места для инспекции", "Директива 2. Сдерживать вторжение извне", "Внимание! Отключены системы наблюдения и обнаружения", "Угроза вторжения! Во вторжении может участвовать Фримен", "Провал миссии влечет выселение в нежилое пространство", "Обнаружена аномальная, внешняя активность", "Отключены ограничители периметра, всем принять участие в сдерживании",}

Spacer(isCP)

SubMenu("Альянс", "icon16/shield_go.png", function(self)
	local lp = LocalPlayer()
	if LocalPlayer():isMP() and not lp:isSynth() then
		self:AddOption("Надеть/снять маску", function()
			net_Start("Mask")
			net_SendToServer()
		end):SetIcon("icon16/application_xp.png")
	end

	if lp:Team() == TEAM_CMD3 then
		local phrase, menus = self:AddSubMenu("Вещание")
		menus:SetIcon("icon16/shape_square_go.png")

		for k, v in ipairs(list) do
			phrase:AddOption(v, function(s) RunConsoleCommand("darkrp", "broadcast", v) end)
		end
	end

	local players = player_GetAll()
	table_sort(players, function(a, b) return a:GetName() < b:GetName() end)

	self:AddOption("Просмотр фотографий сканера", function() RunConsoleCommand("union_scannerCache") end):SetImage("icon16/page_white_camera.png")
end, isCP)

Spacer(function() return LocalPlayer():isCP() and not LocalPlayer():isMayor() end)

SubMenu("Статус-коды", "icon16/transmit_blue.png", function(self)
	for k, v in ipairs(broadCodes.status) do
		self:AddOption(v, function() netstream.Start("cp.BroadCode", v) end):SetImage("icon16/user_comment.png")
	end
end, function() return LocalPlayer():isCP() and not LocalPlayer():isMayor() end)

SubMenu("Прочие коды", "icon16/transmit_blue.png", function(self)
	for k, v in ipairs(broadCodes.other) do
		self:AddOption(v, function() netstream.Start("cp.BroadCode", v) end):SetImage("icon16/user_comment.png")
	end
end, function() return LocalPlayer():isCP() and not LocalPlayer():isMayor() end)

Option("Вещание", "icon16/sound.png", Request("Вещание", "Введите текст для вещания", function(s) RunConsoleCommand("darkrp", "broadcast", s) end), function() return LocalPlayer():isMayor() end)

Option("Транслировать сообщение", "icon16/transmit_blue.png", Request("Транслировать сообщение", "Напишите ваше сообщение ниже.", function(s)
	local textLen = string.utf8len(s)
	if textLen < 3 or textLen > 150 then return end
	netstream.Start("cp.BroadCode", s)
end), function() return (LocalPlayer():isCP() or LocalPlayer():isOTA()) and not LocalPlayer():isRebel() end)

Spacer(function()
	return LocalPlayer():Team() == TEAM_ADMIN --[[or LocalPlayer():IsSuperAdmin()--]]
end)

SubMenu("Администрирование", "icon16/note_edit.png", function(self)
	self:AddOption("Логи", function() RunConsoleCommand("say", "!logs") end):SetIcon("icon16/report.png")

	self:AddOption("Меню", function() RunConsoleCommand("ulx", "menu") end):SetIcon("icon16/report.png")

	local sbutton, submenu = self:AddSubMenu("Рации")
	submenu:SetIcon("icon16/transmit_blue.png")

	local textButton, textSubmenu = sbutton:AddSubMenu("Текстовые")
	textSubmenu:SetIcon("icon16/page_gear.png")

	local lp = LocalPlayer()
	local textRadios, voiceRadios = lp:GetNetVar("radio.set.Text"), lp:GetNetVar("radio.set.Voice")
	local textIsAlliance = textRadios == 1 or textRadios == -1
	textButton:AddOption(textIsAlliance and "Выключить командный чат альянса" or "Включить командный чат альянса", function() netstream.Start("admin.ManageRadios", 1, textIsAlliance and 0 or 1) end):SetIcon(textIsAlliance and "icon16/page_delete.png" or "icon16/page_add.png")

	local textIsRebel = textRadios == 2 or textRadios == -1
	textButton:AddOption(textIsRebel and "Выключить командный чат сопротивления" or "Включить командный чат сопротивления", function() netstream.Start("admin.ManageRadios", 1, textIsRebel and 0 or 2) end):SetIcon(textIsRebel and "icon16/page_delete.png" or "icon16/page_add.png")

	local textIsGSR = textRadios == 3 or textRadios == -1
	textButton:AddOption(textIsGSR and "Выключить командный чат ГСР" or "Включить командный чат ГСР", function() netstream.Start("admin.ManageRadios", 1, textIsGSR and 0 or 3) end):SetIcon(textIsGSR and "icon16/page_delete.png" or "icon16/page_add.png")

	local textIsBandit = textRadios == 4 or textRadios == -1
	textButton:AddOption(textIsBandit and "Выключить командный чат бандитов" or "Включить командный чат бандитов", function() netstream.Start("admin.ManageRadios", 1, textIsBandit and 0 or 4) end):SetIcon(textIsBandit and "icon16/page_delete.png" or "icon16/page_add.png")

	local textIsRefugee = textRadios == 5 or textRadios == -1
	textButton:AddOption(textIsBandit and "Выключить командный чат беглецов" or "Включить командный чат беглецов", function() netstream.Start("admin.ManageRadios", 1, textIsRefugee and 0 or 5) end):SetIcon(textIsRefugee and "icon16/page_delete.png" or "icon16/page_add.png")

	textButton:AddSpacer()

	textButton:AddOption("Включить все текстовые", function() netstream.Start("admin.ManageRadios", 1, -1) end):SetIcon("icon16/accept.png")

	textButton:AddOption("Заглушить все текстовые", function() netstream.Start("admin.ManageRadios", 1, 0) end):SetIcon("icon16/cross.png")

	local voiceButton, voiceSubmenu = sbutton:AddSubMenu("Голосовые")
	voiceSubmenu:SetIcon("icon16/transmit_edit.png")
	local voiceIsAlliance = voiceRadios == 1
	voiceButton:AddOption(voiceIsAlliance and "Выключить рацию альянса" or "Включить рацию альянса", function() netstream.Start("admin.ManageRadios", 2, voiceIsAlliance and 0 or 1) end):SetIcon(voiceIsAlliance and "icon16/sound_mute.png" or "icon16/sound.png")

	local voiceIsRebel = voiceRadios == 2
	voiceButton:AddOption(voiceIsRebel and "Выключить рацию сопротивления" or "Включить рацию сопротивления", function() netstream.Start("admin.ManageRadios", 2, voiceIsRebel and 0 or 2) end):SetIcon(voiceIsRebel and "icon16/sound_mute.png" or "icon16/sound.png")

	local voiceIsGSR = voiceRadios == 3
	voiceButton:AddOption(voiceIsGSR and "Выключить рацию ГСР" or "Включить рацию ГСР", function() netstream.Start("admin.ManageRadios", 2, voiceIsGSR and 0 or 3) end):SetIcon(voiceIsGSR and "icon16/sound_mute.png" or "icon16/sound.png")

	voiceButton:AddSpacer()

	voiceButton:AddOption("Заглушить все голосовые", function() netstream.Start("admin.ManageRadios", 2, 0) end):SetIcon("icon16/cross.png")

	self:AddOption("Включить коллизию(на 1 минуту)", function() netstream.Start("admin.CollideDisable") end):SetIcon("icon16/wrench.png")

	local fadingDoorsMenu, fadingDoorsSubmenu = self:AddSubMenu("Fading Doors")
	fadingDoorsSubmenu:SetIcon("icon16/page_gear.png")
	local adminFDConvar = GetConVar("unionrp_admin_wallhack_fd")
	local adminFDBool = adminFDConvar:GetBool()
	fadingDoorsMenu:AddOption((adminFDBool and "Выключить" or "Включить") .. " подсветку FD", function()
		adminFDBool = not adminFDBool
		adminFDConvar:SetBool(adminFDBool)
		DarkRP.notify(2, 4, "Вы " .. (adminFDBool and "включили" or "выключили") .. " подсветку FD.")
	end):SetIcon("icon16/wrench.png")

	local fadingDoorsListMenu, fadingDoorsListSubmenu = fadingDoorsMenu:AddSubMenu("Список ближайших FD")
	fadingDoorsListSubmenu:SetIcon("icon16/page_gear.png")
	for _, ent in ipairs(DarkRP.adminGetClosestFadingDoors()) do
		if not IsValid(ent) then return end
		local key = ent:EntIndex()
		local fadingDoorOwnerMenu, fadingDoorOwnerSubmenu = fadingDoorsListMenu:AddSubMenu(key)
		fadingDoorOwnerSubmenu:SetIcon("icon16/page_gear.png")
		local entModel = ent:GetModel()
		fadingDoorOwnerMenu:AddOption("Модель пропа: " .. entModel, function()
			chat.AddText(color_red, "Скопирована модель пропа FD.")
			surface.PlaySound("UI/buttonclick.wav")
			SetClipboardText(entModel)
		end)

		local name, sid
		local owner = ent:CPPIGetOwner()
		if IsValid(owner) then
			sid = owner:SteamID()
			name = owner:Name() .. "(" .. sid .. ")"
		else
			name = "UNKNOWN(игрок вышел)"
		end

		fadingDoorOwnerMenu:AddOption("Владелец пропа: " .. name, function()
			chat.AddText(color_red, "Скопировано имя владельца FD.")
			surface.PlaySound("UI/buttonclick.wav")
			SetClipboardText(name)
		end)

		fadingDoorOwnerMenu:AddOption("SteamID: " .. sid, function()
			chat.AddText(color_red, "Скопирован SteamID владельца.")
			surface.PlaySound("UI/buttonclick.wav")
			SetClipboardText(sid)
		end)

		fadingDoorOwnerMenu:AddSpacer()
		fadingDoorOwnerMenu:AddOption("Удалить?", UI_Derma_Query("Вы уверены, что хотите удалить FD " .. key .. " игрока: " .. name .. "?", "Подтверждение:", "Да", function()
			if not IsValid(ent) then return end
			netstream.Start("admin.DeleteActiveFD", ent)
		end, "Нет", function() end))
	end
end, function()
	return LocalPlayer():Team() == TEAM_ADMIN --[[or LocalPlayer():IsSuperAdmin()--]]
end)

Spacer(function() return LocalPlayer():Team() == TEAM_CMD3 or LocalPlayer():Team() == TEAM_CMD2 or LocalPlayer():Team() == TEAM_CMD1 end)

Option("Открыть планшет", "icon16/calculator.png", OpenPDA, function() return LocalPlayer():isCP() or LocalPlayer():isRebel() and not LocalPlayer():isRefugee() or LocalPlayer():isGSR() end)

local cwuWorkerJobs = {
	[TEAM_GSR1] = true,
	[TEAM_GSR4] = true,
	[TEAM_GSR2] = true,
}

Spacer(function() return LocalPlayer():isGSR() end)

SubMenu("ГСР", "icon16/user_suit.png", function(self)
	local ply = LocalPlayer()
	local plyTeam = ply:Team()
	if cwuWorkerJobs[plyTeam] then
		self:AddOption("Обновить метку на активную работу", function(s)
			if ply._lastCWUWakeJob and ply._lastCWUWakeJob >= CurTime() then return end
			ply._lastCWUWakeJob = CurTime() + 10

			netstream.Start("cwu.wakeJobMark")
		end):SetIcon("icon16/add.png")
	end
end, function() return LocalPlayer():isGSR() end)

Spacer()

SubMenu("Законы", "icon16/text_columns.png", function(self)
	for k, v in pairs(DarkRP.getLaws()) do
		self:AddOption(k .. ". " .. v, function() end):SetImage("icon16/text_align_center.png")
	end
end)

local icons = {
	[1] = "icon16/award_star_gold_1.png",
	[2] = "icon16/award_star_silver_1.png",
	[3] = "icon16/award_star_bronze_1.png",
}

local codes = {
	["KK"] = {{"Военное положение", "Проведение боевых действий"}, "icon16/exclamation.png"},
	["YK"] = {{"Желтый код: Проверка населения", "Желтый код: Сбор на точке"}, "icon16/error.png"},
	["LK"] = {"Комендантский час", "icon16/house.png"},
}

local instructionInterpolateStr = {
	cp = "Текущее указание: {instruction} | {instructionGiver}",
	ota = "Текущий протокол: {instruction} | {instructionGiver}"
}

SubMenu("Информация", "icon16/table_lightning.png", function(self)
	local ply = LocalPlayer()
	local sbutton, submenu = self:AddSubMenu("Активные коды")
	submenu:SetIcon("icon16/transmit_blue.png")
	local currentCode = netvars.GetNetVar("Current.Code")
	if currentCode then
		local isOperation = netvars.GetNetVar("KK.IsOperation") or netvars.GetNetVar("YK.IsGathering")
		local codesRow = codes[currentCode[1]]
		local reason = currentCode[2]
		local codeName = codesRow[1]
		codeName = istable(codeName) and (isOperation and codeName[2] or codeName[1]) or codeName
		sbutton:AddOption("Активен: " .. codeName, function(s) end):SetIcon(codesRow[2])

		sbutton:AddOption("Причина: " .. (reason or "n/a"), function(s) end)

		local autoEndTime = netvars.GetNetVar("Code.EndTime")
		if autoEndTime and autoEndTime > CurTime() then sbutton:AddOption("Автоматическое завершение через: " .. util.TimeToStr(math.floor(autoEndTime - CurTime())), function(s) end) end
	else
		sbutton:AddOption("Активные коды отсутствуют", function(s) end)
	end

	if ply:isRebel() or ply:isRefugee() or ply:isCP() or ply:Team() == TEAM_ADMIN or ply:Team() == TEAM_GMAN then
		local sbutton, submenu = self:AddSubMenu("Точки")
		submenu:SetIcon("icon16/server_lightning.png")

		for k, v in pairs(DarkRP.CPoints.points) do
			local owner = v.owner == "alliance" and Color(0, 111, 255) or v.owner == "rebels" and Color(229, 131, 25) or col.r
			local owns = v.capture and "Захват" or v.owner == "alliance" and "Альянс" or v.owner == "rebels" and "Повстанцы" or "Неизвестно"
			local t = v.name .. " - " .. owns
			sbutton:AddOption(t, function(s) end):SetColor(owner)
		end
	end

	local sbutton, submenu = self:AddSubMenu("Игрок")
	submenu:SetIcon("icon16/user_comment.png")

	local tbl = {
		[1] = {
			t = ply:Health() .. " / " .. ply:GetMaxHealth(),
			icon = "icon16/heart.png"
		},
		[2] = {
			t = ply:Armor() .. " / " .. ply:GetMaxArmor(),
			icon = "icon16/shield.png"
		},
		[3] = {
			t = team_GetName(ply:Team()),
			icon = "icon16/user_suit.png"
		},
		[4] = {
			t = ply:isWanted() and "В розыске" or "Не в розыске",
			icon = "icon16/status_online.png"
		},
		[5] = {
			t = "CID: #" .. ply:GetID(),
			icon = "icon16/vcard_edit.png"
		},
		[6] = {
			t = DarkRP.formatMoney(ply:getDarkRPVar("money" or 0)) .. " / " .. DarkRP.formatMoney(ply:getJobTable().salary or 0),
			icon = "icon16/coins.png"
		},
		[7] = {
			t = "Количество пропов: " .. (ply:GetCount("props") .. " / " .. ply:GetNetVar("props.limit", cvars.Number("sbox_maxprops", 0))),
			icon = "icon16/bricks.png"
		}
	}

	if ply:Team() == TEAM_AGENT then
		tbl[8] = {
			t = "Количество украденной еды: " .. ply:GetNetVar("stolenFood", 0),
			icon = "icon16/cup.png"
		}
	elseif ply:Team() == TEAM_FOODSHOP then
		tbl[8] = {
			t = "Количество готовой еды: " .. ply:GetNetVar("boughtFood", 0),
			icon = "icon16/cup.png"
		}
	end

	for k, v in ipairs(tbl) do
		sbutton:AddOption(v.t, function(s) end):SetImage(v.icon)
	end

	if ply:Team() == TEAM_GSR3 then sbutton:AddOption("Еда на продажу: " .. ply:GetNetVar("gsr.food.count", 0) .. " / " .. 50, function(s) end):SetImage("icon16/cart_remove.png") end

	local lives = ply:GetNetVar("lives")
	if lives then sbutton:AddOption("Жизни: " .. lives .. " / " .. ply:GetNetVar("maxLives", -1), function(s) end):SetImage("icon16/heart.png") end

	if ply:GetNetVar("HasPass") then sbutton:AddOption("У Вас есть разрешение, чтобы вступить в Альянс."):SetImage("icon16/accept.png") end

	if ply:Team() == TEAM_GSR4 or ply:isRebel() then
		local healPoints = ply:GetNetVar("bed.HealPoints", 0)
		local rawHealPoints = ply:GetNetVar("bed.rawHealPoints", 0)
		sbutton:AddOption("Количество готовых лекарств: " .. healPoints, function(s) end):SetImage("icon16/pill.png")
		sbutton:AddOption("Количество не переработанных лекарств: " .. rawHealPoints .. " / " .. "50", function(s) end):SetImage("icon16/pill.png")
	end

	if ply:isRebel() then
		local ironerCount = ply:GetNetVar("ironerCount", 0)
		sbutton:AddOption("Количество собранных материалов: " .. ironerCount, function(s) end):SetImage("icon16/folder.png")
	end

	local text, icon
	if netvars_GetNetVar("Nabor_Active") or not allianceRecruitingHasCmd() then
		text = "Набор в альянс - открыт"
		icon = "icon16/add.png"
	else
		text = "Набор в альянс - закрыт"
		icon = "icon16/stop.png"
	end

	self:AddOption(text):SetImage(icon)
	if netvars_GetNetVar("zombie_event_passed") then
		text = "Зомби ивент - проведен"
		icon = "icon16/hourglass.png"
	else
		text = "Зомби ивент - доступен"
		icon = "icon16/star.png"
	end

	self:AddOption(text):SetImage(icon)
	local top10Chess = netvars_GetNetVar("top10Chess", {})
	if top10Chess and top10Chess[1] then
		local rbutton, rsubmenu = self:AddSubMenu("Рейтинг")
		rsubmenu:SetIcon("icon16/chart_pie.png")
		local sbutton, submenu = rbutton:AddSubMenu("Шахматы")
		submenu:SetIcon("icon16/brick.png")

		for k, v in ipairs(top10Chess) do
			sbutton:AddOption(k .. ". " .. v.nick .. "(" .. v.steamID .. ") - " .. v.chessElo, function(s) end):SetImage(icons[k] or "icon16/award_star_bronze_2.png")
		end

		local sbutton, submenu = rbutton:AddSubMenu("Шашки")
		submenu:SetIcon("icon16/contrast.png")
		local top10Draughts = netvars_GetNetVar("top10Draughts", {})
		for k, v in ipairs(top10Draughts) do
			sbutton:AddOption(k .. ". " .. v.nick .. "(" .. v.steamID .. ") - " .. v.draughtsElo, function(s) end):SetImage(icons[k] or "icon16/award_star_bronze_2.png")
		end

		local chessRank, draughtsRank = ply:GetChessRank(), ply:GetChessRank(true)
		local chessTotal = netvars_GetNetVar("chess.TotalCount", "UNKNOWN")
		local sbutton, submenu = rbutton:AddSubMenu("Ваш рейтинг")
		submenu:SetIcon("icon16/star.png")
		sbutton:AddOption("Шахматы:", function(s) end):SetImage("icon16/brick.png")
		sbutton:AddOption("Место: " .. chessRank .. " из " .. chessTotal .. "", function(s) end):SetImage("icon16/rosette.png")
		sbutton:AddOption("Рейтинг: " .. ply:GetChessElo(), function(s) end):SetImage(icons[k] or "icon16/award_star_bronze_2.png")
		sbutton:AddOption("Всего игр: " .. ply:GetGamesCount() .. ".", function(s) end):SetImage("icon16/world.png")

		sbutton:AddSpacer()

		sbutton:AddOption("Шашки:", function(s) end):SetImage("icon16/brick.png")
		sbutton:AddOption("Место: " .. draughtsRank .. " из " .. chessTotal .. "", function(s) end):SetImage("icon16/rosette.png")
		sbutton:AddOption("Рейтинг: " .. ply:GetDraughtsElo(), function(s) end):SetImage(icons[k] or "icon16/award_star_bronze_2.png")
		sbutton:AddOption("Всего игр: " .. ply:GetGamesCount(true) .. ".", function(s) end):SetImage("icon16/world.png")
	end
end)

SubMenu("Анимации", "icon16/emoticon_waii.png", function(self)
	local lp = LocalPlayer()
	local sbutton, submenu = self:AddSubMenu("Стиль анимаций")
	submenu:SetIcon("icon16/user_gray.png")

	for anim_cat, anim_name in pairs(UAnim.StyleNames or {}) do
		local sbutton, submenu = sbutton:AddSubMenu(anim_name)
		submenu:SetIcon("icon16/group_link.png")
		local nv = UAnim.IdToNetVar[anim_cat]
		local cur = lp:GetNetVar(nv, 1)
		local acts = UAnim.Styles[anim_cat]
		local active
		for anim_id, anim_data in ipairs(acts) do
			local b = sbutton:AddOption(anim_data.name, function(s)
				netstream.Start("SetStyle", anim_cat, anim_id)
				if active then active:SetIcon("icon16/cross.png") end
				s:SetIcon("icon16/tick.png")
				active = s
			end)

			if anim_id == cur then
				b:SetIcon("icon16/tick.png")
				active = b
			else
				b:SetIcon("icon16/cross.png")
			end
		end
	end

	if not isfunction(GetTauntList) then return end
	self:AddSpacer()
	local list = GetTauntList()
	for tk, tbl in ipairs(list) do
		for num, an in ipairs(tbl) do
			local should = hook_Run("PlayerCanTaunt", lp, an.name)
			if should == false then continue end
			self:AddOption(an.name or "UNKNOWN", function() StartTaunt(an, num, tk) end):SetIcon(an.icon or (an.act and "icon16/tag_purple.png" or "icon16/plugin_add.png"))
		end

		self:AddSpacer()
	end
end)

--[[ DO NOT EDIT STUFF BELOW THIS POINT UNLESS YOU KNOW WHAT YOU ARE DOING ]]
local menu
hook_Add("OnContextMenuOpen", "CMenuOnContextMenuOpen", function()
	local lpe = LocalPlayer():GetEyeTraceNoCursor().Entity
	if not (IsValid(lpe) and lpe:GetClass():find("mediaplayer")) then
		if not g_ContextMenu:IsVisible() then
			local orig = g_ContextMenu.Open
			g_ContextMenu.Open = function(self, ...)
				self.Open = orig
				orig(self, ...)
				menu = vgui_Create("CMenuExtension")
				menu:SetDrawOnTop(false)
				for k, v in pairs(Menu) do
					if not v.check or v.check() then
						if v.cmd then
							menu:AddOption(v.title, isfunction(v.cmd) and v.cmd or function() RunConsoleCommand(v.cmd) end):SetImage(v.icon)
						elseif v.func then
							local m, s = menu:AddSubMenu(v.title)
							s:SetImage(v.icon)
							v.func(m)
						else
							menu:AddSpacer()
						end
					end
				end

				menu:Open()

				if context_menu_pos == "bot" then
					menu:CenterHorizontal()
					menu.y = ScrH()
					menu:MoveTo(menu.x, ScrH() - menu:GetTall() - 8, .1, 0)
				elseif context_menu_pos == "right" then
					menu:CenterVertical()
					menu.x = ScrW()
					menu:MoveTo(ScrW() - menu:GetWide() - 8, menu.y, .1, 0)
				elseif context_menu_pos == "left" then
					menu:CenterVertical()
					menu.x = -menu:GetWide()
					menu:MoveTo(8, menu.y, .1, 0)
				else
					menu:CenterHorizontal()
					menu.y = -menu:GetTall()
					menu:MoveTo(menu.x, 30 + 8, .1, 0)
				end

				menu:MakePopup()
			end
		end
	end
end)

hook_Add("CloseDermaMenus", "CMenuCloseDermaMenus", function() if menu and menu:IsValid() then menu:MakePopup() end end)

hook_Add("OnContextMenuClose", "CMenuOnContextMenuClose", function() if menu and menu:IsValid() then menu:Remove() end end)

local f = RegisterDermaMenuForClose
local PANEL = {}
AccessorFunc(PANEL, "m_bBorder", "DrawBorder")
AccessorFunc(PANEL, "m_bDeleteSelf", "DeleteSelf")
AccessorFunc(PANEL, "m_iMinimumWidth", "MinimumWidth")
AccessorFunc(PANEL, "m_bDrawColumn", "DrawColumn")
AccessorFunc(PANEL, "m_iMaxHeight", "MaxHeight")
AccessorFunc(PANEL, "m_pOpenSubMenu", "OpenSubMenu")
--[[---------------------------------------------------------
  Init
-----------------------------------------------------------]]
function PANEL:Init()
	self:SetIsMenu(true)
	self:SetDrawBorder(true)
	self:SetDrawBackground(true)
	self:SetMinimumWidth(100)
	self:SetDrawOnTop(true)
	self:SetMaxHeight(ScrH() * 0.9)
	self:SetDeleteSelf(true)
	self:SetPadding(0)
end

--[[---------------------------------------------------------
  AddPanel
-----------------------------------------------------------]]
function PANEL:AddPanel(pnl)
	self:AddItem(pnl)
	pnl.ParentMenu = self
end

--[[---------------------------------------------------------
  AddOption
-----------------------------------------------------------]]
function PANEL:AddOption(strText, funcFunction)
	local pnl = vgui_Create("CMenuOption", self)
	pnl:SetMenu(self)
	pnl:SetText(strText)
	pnl:SetTextColor(col.w)

	if funcFunction then pnl.DoClick = funcFunction end

	self:AddPanel(pnl)
	return pnl
end

--[[---------------------------------------------------------
  AddCVar
-----------------------------------------------------------]]
function PANEL:AddCVar(strText, convar, on, off, funcFunction)
	local pnl = vgui_Create("DMenuOptionCVar", self)
	pnl:SetMenu(self)
	pnl:SetText(strText)
	pnl:SetTextColor(col.w)

	if funcFunction then pnl.DoClick = funcFunction end

	pnl:SetConVar(convar)
	pnl:SetValueOn(on)
	pnl:SetValueOff(off)
	self:AddPanel(pnl)
	return pnl
end

--[[---------------------------------------------------------
  AddSpacer
-----------------------------------------------------------]]
function PANEL:AddSpacer(strText, funcFunction)
	local pnl = vgui_Create("DPanel", self)

	pnl.Paint = function(p, w, h)
		surface_SetDrawColor(col.o)
		surface_DrawRect(0, 0, w, h)
	end

	pnl:SetTall(1)
	self:AddPanel(pnl)

	return pnl
end

--[[---------------------------------------------------------
  AddSubMenu
-----------------------------------------------------------]]
function PANEL:AddSubMenu(strText, funcFunction)
	local pnl = vgui_Create("CMenuOption", self)
	local SubMenu = pnl:AddSubMenu(strText, funcFunction)
	pnl:SetText(strText)
	pnl:SetTextColor(col.w)

	if funcFunction then pnl.DoClick = funcFunction end

	self:AddPanel(pnl)
	return SubMenu, pnl
end

--[[---------------------------------------------------------
  Hide
-----------------------------------------------------------]]
function PANEL:Hide()
	local openmenu = self:GetOpenSubMenu()
	if openmenu then openmenu:Hide() end

	self:SetVisible(false)
	self:SetOpenSubMenu(nil)
end

--[[---------------------------------------------------------
  OpenSubMenu
-----------------------------------------------------------]]
function PANEL:OpenSubMenu(item, menu)
	-- Do we already have a menu open?
	local openmenu = self:GetOpenSubMenu()
	if IsValid(openmenu) then
		-- Don't open it again!
		if menu and openmenu == menu then return end
		-- Close it!
		self:CloseSubMenu(openmenu)
	end

	if not IsValid(menu) then return end
	local x, y = item:LocalToScreen(self:GetWide(), 0)
	menu:Open(x - 3, y, false, item)
	self:SetOpenSubMenu(menu)
end

--[[---------------------------------------------------------
  CloseSubMenu
-----------------------------------------------------------]]
function PANEL:CloseSubMenu(menu)
	menu:Hide()
	self:SetOpenSubMenu(nil)
end

--[[---------------------------------------------------------
  Paint
-----------------------------------------------------------]]
function PANEL:Paint(w, h)
	if not self:GetDrawBackground() then return end
	draw_RoundedBox(0, 0, 0, w, h, col.ba)
end

function PANEL:ChildCount()
	return #self:GetCanvas():GetChildren()
end

function PANEL:GetChild(num)
	return self:GetCanvas():GetChildren()[num]
end

--[[---------------------------------------------------------
  PerformLayout
-----------------------------------------------------------]]
function PANEL:PerformLayout()
	local w = self:GetMinimumWidth()
	-- Find the widest one
	for k, pnl in pairs(self:GetCanvas():GetChildren()) do
		pnl:PerformLayout()
		w = math_max(w, pnl:GetWide())
	end

	self:SetWide(w)
	local y = 0 -- for padding
	for k, pnl in pairs(self:GetCanvas():GetChildren()) do
		pnl:SetWide(w)
		pnl:SetPos(0, y)
		pnl:InvalidateLayout(true)
		y = y + pnl:GetTall()
	end

	y = math_min(y, self:GetMaxHeight())
	self:SetTall(y)
	derma_SkinHook("Layout", "Menu", self)
	DScrollPanel.PerformLayout(self)
end

--[[---------------------------------------------------------
	Open - Opens the menu.
	x and y are optional, if they're not provided the menu
		will appear at the cursor.
-----------------------------------------------------------]]
function PANEL:Open(x, y, skipanimation, ownerpanel)
	local maunal = x and y
	x = x or gui_MouseX()
	y = y or gui_MouseY()
	local OwnerHeight = 0
	local OwnerWidth = 0
	if ownerpanel then OwnerWidth, OwnerHeight = ownerpanel:GetSize() end

	self:PerformLayout()
	local w = self:GetWide()
	local h = self:GetTall()
	self:SetSize(w, h)

	if y + h > ScrH() then y = (maunal and ScrH() or y + OwnerHeight) - h end
	if x + w > ScrW() then x = (maunal and ScrW() or x) - w end
	if y < 1 then y = 1 end
	if x < 1 then x = 1 end

	self:SetPos(x, y)
	self:MakePopup()
	self:SetVisible(true)
	-- Keep the mouse active while the menu is visible.
	self:SetKeyboardInputEnabled(false)
end

--
-- Called by CMenuOption
--
function PANEL:OptionSelectedInternal(option)
	self:OptionSelected(option, option:GetText())
end

function PANEL:OptionSelected(option, text)
	-- For override
end

function PANEL:ClearHighlights()
	for k, pnl in pairs(self:GetCanvas():GetChildren()) do
		pnl.Highlight = nil
	end
end

function PANEL:HighlightItem(item)
	for k, pnl in pairs(self:GetCanvas():GetChildren()) do
		if pnl == item then pnl.Highlight = true end
	end
end

--[[---------------------------------------------------------
   Name: GenerateExample
-----------------------------------------------------------]]
function PANEL:GenerateExample(ClassName, PropertySheet, Width, Height)
end

derma_DefineControl("CMenuExtension", "ContxtMenuC", PANEL, "DScrollPanel")
--=======================================================================================================--
--=======================================================================================================--
--=======================================================================================================--
--=======================================================================================================--
--=======================================================================================================--
--=======================================================================================================--
local PANEL = {}
AccessorFunc(PANEL, "m_pMenu", "Menu")
AccessorFunc(PANEL, "m_bChecked", "Checked")
AccessorFunc(PANEL, "m_bCheckable", "IsCheckable")
function PANEL:Init()
	self:SetContentAlignment(4)
	self:SetTextInset(30, 0) -- Room for icon on left
	self:SetTextColor(col.w)
	self:SetChecked(false)
end

function PANEL:SetSubMenu(menu)
	self.SubMenu = menu
	if not self.SubMenuArrow then
		self.SubMenuArrow = vgui_Create("DPanel", self)
		self.SubMenuArrow.Paint = function(panel, w, h)
			local rightarrow = {
				{
					x = 5,
					y = 3
				},
				{
					x = w - 5,
					y = h / 2
				},
				{
					x = 5,
					y = h - 3
				}
			}

			surface_SetDrawColor(col.w)
			draw_NoTexture()
			surface_DrawPoly(rightarrow)
		end
	end
end

function PANEL:AddSubMenu()
	if not self then CloseDermaMenus() end
	local SubMenu = vgui_Create("CMenuExtension", self)
	SubMenu:SetVisible(false)
	SubMenu:SetParent(self)
	SubMenu.Paint = function(p, w, h) draw_RoundedBox(0, 0, 0, w, h, col.ba) end

	self:SetSubMenu(SubMenu)

	return SubMenu
end

function PANEL:OnCursorEntered()
	if IsValid(self.ParentMenu) then
		self.ParentMenu:OpenSubMenu(self, self.SubMenu)
		return
	end
	--self:GetParent():OpenSubMenu( self, self.SubMenu )
end

function PANEL:OnCursorExited()
end

function PANEL:Paint(w, h)
	--derma.SkinHook( "Paint", "MenuOption", self, w, h )
	if self:IsHovered() then draw_RoundedBox(0, 0, 0, w, h, col.baw) end
	--
	-- Draw the button text
	--
	return false
end

function PANEL:OnMousePressed(mousecode)
	self.m_MenuClicking = true
	DButton.OnMousePressed(self, mousecode)
end

function PANEL:OnMouseReleased(mousecode)
	DButton.OnMouseReleased(self, mousecode)
	if self.m_MenuClicking and mousecode == MOUSE_LEFT then
		self.m_MenuClicking = false
		CloseDermaMenus()
	end
end

function PANEL:DoRightClick()
	if self:GetIsCheckable() then self:ToggleCheck() end
end

function PANEL:DoClickInternal()
	if self:GetIsCheckable() then self:ToggleCheck() end
	if self.m_pMenu then self.m_pMenu:OptionSelectedInternal(self) end
end

function PANEL:ToggleCheck()
	self:SetChecked(not self:GetChecked())
	self:OnChecked(self:GetChecked())
end

function PANEL:OnChecked(b)
end

function PANEL:PerformLayout()
	self:SizeToContents()
	self:SetWide(self:GetWide() + 30)
	local w = math_max(self:GetParent():GetWide(), self:GetWide())
	surface.SetFont("DermaDefault")
	local _, textH = surface.GetTextSize(self:GetText())
	self:SetSize(w, textH + 10)
	if self.SubMenuArrow then
		self.SubMenuArrow:SetSize(15, 15)
		self.SubMenuArrow:CenterVertical()
		self.SubMenuArrow:AlignRight(4)
	end

	DButton.PerformLayout(self)
end

function PANEL:GenerateExample()
	-- Do nothing!
end

derma_DefineControl("CMenuOption", "ContxtMenuD", PANEL, "DButton")
