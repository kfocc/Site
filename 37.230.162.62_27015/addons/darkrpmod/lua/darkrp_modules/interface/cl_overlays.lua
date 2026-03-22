-- local clientConvar = CreateClientConVar("unionrp_combineoverlay", "1", true, false)
DarkRP.combineDisplayLines = {}
local combineDisplayLines = DarkRP.combineDisplayLines
local font_name = "CPVisor"
local font_size = ScreenScaleH(7)

surface.CreateFont(font_name, {
	font = "Inter",
	size = font_size,
	weight = 500,
	additive = true,
	extended = true,
	outline = true
})

local font_name_lines = "CPVisorLines"
local font_size_lines = ScreenScaleH(6)
surface.CreateFont(font_name_lines, {
	font = "Inter",
	size = font_size_lines,
	weight = 500,
	additive = true,
	extended = true,
	outline = true
})

local font_name_squad = "CPVisorSquadName"
surface.CreateFont(font_name_squad, {
	font = "Inter",
	extended = true,
	size = 32,
	weight = 500
})

local sampleFont = font_name

local function getSpaceWidth()
	surface.SetFont(sampleFont)
	return surface.GetTextSize("::")
end
local space_width = getSpaceWidth()

local function getMaxNameWidth(texts)
	surface.SetFont(sampleFont)
	local max = 0
	for _, v in ipairs(texts) do
		local right_text = v[1]
		local w = surface.GetTextSize(right_text)
		if w > max then max = w end
	end
	return max
end

local linesX = 16
local displayDuration = 1
local fullDisplayDuration = 7

local function DrawDisplayLines()
	local y = 40
	local curTime = CurTime()
	local totalDuration = displayDuration + fullDisplayDuration

	for k, v in ipairs(combineDisplayLines) do
		local end_time = v[2]
		if curTime >= end_time then
			table.remove(combineDisplayLines, k)
		else
			local textTable = v[1]
			local textColor = v[3] or color_white
			local elapsedTime = totalDuration - (end_time - curTime)
			local stringIDToShow = math.min(math.floor(elapsedTime / displayDuration * #textTable), #textTable)
			local subText = textTable[stringIDToShow] or ""

			draw.SimpleText(subText, font_name_lines, linesX, y, textColor)
			y = y + font_size_lines
		end
	end
end

function DarkRP.AddCombineDisplayLine(text, color)
	local displayText = "<:: " .. text .. " ::>"
	local utf8Table = {}
	for i = 1, utf8.len(displayText) do
		table.insert(utf8Table, utf8.sub(displayText, 1, i))
	end
	table.insert(combineDisplayLines, {utf8Table, CurTime() + displayDuration + fullDisplayDuration, color})
end

local scr_w, scr_h = ScrW(), ScrH()
local squadX = 16
local squadY = scr_h * .2

local squadsCol = Color(32, 131, 153)
local function GetNiceJob(ply)
	local job = ply:getDarkRPVar("job", "-")
	if string.StartWith(job, "C17") then
		job = string.sub(job, 5)
	end
	return job
end

local function GetNiceColor(ply, is_leader)
	local col = team.GetColor(ply:GetNetVar("TeamNum", ply:Team()))
	return col
end

local function CanSee(ply)
	return ply:Alive() and (ply:GetNetVar("HideCPName") or ply:isOTA())
end

local squadDormant = CreateClientConVar("unionrp_squad_dormant", "0", true, false):GetBool()
cvars.AddChangeCallback("unionrp_squad_dormant", function(_, _, new)
	squadDormant = tobool(new)
end, "unionrp_squad_dormant")

local squadOutlineDistMin = 512
local squadOutlineDistMax = 4096
local squadOutlineDist = CreateClientConVar("unionrp_squad_maxdist", "2048", true, false, nil, squadOutlineDistMin, squadOutlineDistMax):GetInt()
cvars.AddChangeCallback("unionrp_squad_maxdist", function(_, _, new)
	squadOutlineDist = math.Clamp(tonumber(new) or 0, squadOutlineDistMin, squadOutlineDistMax)
end, "unionrp_squad_maxdist")

local squadMembers = {}
local squadTexts = {}
local squadMaxW = 0
local squadOutlineDistZ = 1024
local function UpdateSquadTexts(ply)
	squadTexts, squadMembers = {}, {}
	local squad_id = DarkRP.Squads.GetPlayerGroupID(ply)
	if not squad_id then return end
	local squad_info = DarkRP.Squads.GetGroup(squad_id)
	if not squad_info then return end
	local name, leader = squad_info.name, squad_info.leader
	local members = DarkRP.Squads.GetMembers(squad_id)
	local should_outline = CanSee(ply)
	local my_pos = ply:GetPos()
	table.insert(squadTexts, {"ОТРЯД", name, squadsCol})
	if not IsValid(leader) then return end
	table.insert(squadTexts, {"ЮНИТ", GetNiceJob(leader) .. " [Л]", GetNiceColor(leader, true)})
	if leader ~= ply then
		table.insert(squadTexts, {"ЮНИТ", GetNiceJob(ply), GetNiceColor(ply)})
	end
	for k, v in ipairs(members) do
		if not IsValid(v) then continue end
		if v == ply then continue end
		local nice_col = GetNiceColor(v)
		local target_pos = v:GetPos()
		if should_outline and CanSee(v) and target_pos:Distance(my_pos) < squadOutlineDist and math.abs(target_pos.z - my_pos.z) < squadOutlineDistZ and (squadDormant or not v:IsDormant()) then
			squadMembers[v] = nice_col
		end
		if v == leader then continue end
		table.insert(squadTexts, {"ЮНИТ", GetNiceJob(v), nice_col})
	end
	squadMaxW = getMaxNameWidth(squadTexts)
end

local function drawLeftCenteredText(leftText, rightText, y, color)
	draw.SimpleText(leftText, sampleFont, squadX, y, color, TEXT_ALIGN_LEFT)
	draw.SimpleText("::", sampleFont, squadX + squadMaxW + space_width, y, color, TEXT_ALIGN_LEFT)
	draw.SimpleText(rightText, sampleFont, squadX + squadMaxW + space_width * 3, y, color, TEXT_ALIGN_LEFT)
end

local function DrawSquad(ply)
	local y = squadY
	for k, v in ipairs(squadTexts) do
		drawLeftCenteredText(v[1], v[2], squadY + (k - 1) * font_size, v[3])
		y = y + font_size
	end
end

local function Nothing() end

local OUTLINE_MODE_BOTH = OUTLINE_MODE_BOTH
local function AddOutline(Add)
	for k, v in pairs(squadMembers) do
		Add({k}, v, OUTLINE_MODE_BOTH)
	end
end
local SquadAddOutline = AddOutline
local squadOutline = CreateClientConVar("unionrp_squad_outline", "1", true, false):GetBool()
cvars.AddChangeCallback("unionrp_squad_outline", function(_, _, new)
	squadOutline = tobool(new)
	SquadAddOutline = squadOutline and AddOutline or Nothing
end, "unionrp_squad_outline")
SquadAddOutline = squadOutline and AddOutline or Nothing

hook.Add("SetupOutlines", "Combine.Squad.Outlines", function(Add)
	SquadAddOutline(Add)
end)

local squadColGreen = Color(0, 255, 0)
local squadColRed = Color(255, 0, 0)
local icon = Material("icons/fa32/child.png")
local icon_size = 32

local function DrawCircle(x, y, w, h, col)
	surface.SetDrawColor(col.r, col.g, col.b, col.a)
	Eris:DrawCircle(0, 0, icon_size, icon_size, col)
end
local SquadDrawCircle = DrawCircle

local function DrawIcon(x, y, w, h, ply)
	local hp_percentage = ply:Health() / ply:GetMaxHealth()
	local col_hp = LerpColor(hp_percentage, squadColRed, squadColGreen)
	surface.SetDrawColor(col_hp.r, col_hp.g, col_hp.b, col_hp.a)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(-icon_size * .5, -icon_size * .5, icon_size, icon_size)
end
local SquadDrawIcon = DrawIcon

local function DrawName(x, y, ply)
	local name = "#" .. ply:GetCID()
	draw.SimpleText(name, font_name_squad, x, y, color_white, TEXT_ALIGN_CENTER)
end
local SquadDrawName = DrawName


local squadDrawCircle = CreateClientConVar("unionrp_squad_drawcircle", "1", true, false):GetBool()
cvars.AddChangeCallback("unionrp_squad_drawcircle", function(_, _, new)
	squadDrawCircle = tobool(new)
	SquadDrawCircle = squadDrawCircle and DrawCircle or Nothing
end, "unionrp_squad_drawcircle")
SquadDrawCircle = squadDrawCircle and DrawCircle or Nothing

local squadDrawHealth = CreateClientConVar("unionrp_squad_drawhealth", "1", true, false):GetBool()
cvars.AddChangeCallback("unionrp_squad_drawhealth", function(_, _, new)
	squadDrawHealth = tobool(new)
	SquadDrawIcon = squadDrawHealth and DrawIcon or Nothing
end, "unionrp_squad_drawhealth")
SquadDrawIcon = squadDrawHealth and DrawIcon or Nothing

local squadDrawName = CreateClientConVar("unionrp_squad_drawname", "1", true, false):GetBool()
cvars.AddChangeCallback("unionrp_squad_drawname", function(_, _, new)
	squadDrawName = tobool(new)
	SquadDrawName = squadDrawName and DrawName or Nothing
end, "unionrp_squad_drawname")
SquadDrawName = squadDrawName and DrawName or Nothing

hook.Add("PostDrawTranslucentRenderables", "Combine.Squad.Outlines", function(a, b, c)
	if a or b or c then return end
	local lp = LocalPlayer()
	local lp_ang = lp:EyeAngles()
	local offset = Vector(0, 0, 40)
	local ang = Angle(0, lp_ang.y - 90, 90)
	cam.IgnoreZ(true)
	for ply, col in pairs(squadMembers) do
		if not IsValid(ply) then
			squadMembers[ply] = nil
			continue
		end
		local pos = ply:GetPos() + offset
		cam.Start3D2D(pos, ang, .125)
			surface.SetAlphaMultiplier(0.4)
			SquadDrawCircle(0, 0, icon_size, icon_size, col)
			surface.SetAlphaMultiplier(1)
			SquadDrawIcon(0, 0, icon_size, icon_size, ply)
			SquadDrawName(0, icon_size, ply)
		cam.End3D2D()
	end
	cam.IgnoreZ(false)
end)

gameevent.Listen( "player_disconnect" )
hook.Add( "player_disconnect", "Combine.Squad.Outlines", function()
	for ply, col in pairs(squadMembers) do
		if not IsValid(ply) then
			squadMembers[ply] = nil
			break
		end
	end
end)

local function GetTimeText()
	local time = StormFox2.Time.Get()
	local hr = math.floor(time / 60)
	local min = math.floor(time % 60)
	local text
	if min < 10 then min = "0" .. min end
	local day = weeks.GetName()
	text = day .. " ( " .. hr .. ":" .. min .. " )"
	return text
end

local infoX = scr_w - 16
local infoY = scr_h * .2
local infoMaxW = 0

local colorTime = Color(218, 215, 166)
local colorZone = Color(165, 154, 65)
local colorProtocol = Color(32, 131, 153)
local colorRadio = Color(70, 164, 160)

local unitTexts = {}
local function UpdateUnitTexts(ply)
	local protocol_name = ply:isOTA() and "ПРОТОКОЛ" or "УКАЗАНИЯ"
	local protocol = ply:GetNetVar("ota.protocol") or ply:getJobTable().defaultProtocol or "Отсутствуют"
	local radio_text = ply:isRadioForceDisabled() and "Отключен" or ply:isRadioDisabled() and "Отключено" or ply:isSpeakToAll() and "Speak to all" or "Включена ( " .. ply:GetFreq() .. " )"
	unitTexts = {
		{"ВРЕМЯ", GetTimeText(), colorTime},
		{"ЛОКАЦИЯ", ply:GetNiceZone(), colorZone},
		{protocol_name, protocol, colorProtocol},
		{"РАЦИЯ", radio_text, colorRadio}
	}
	infoMaxW = getMaxNameWidth(unitTexts)
end

local function drawRightCenteredText(rightText, leftText, y, color)
	draw.SimpleText(rightText, sampleFont, infoX, y, color, TEXT_ALIGN_RIGHT)
	draw.SimpleText("::", sampleFont, infoX - infoMaxW - space_width, y, color, TEXT_ALIGN_RIGHT)
	draw.SimpleText(leftText, sampleFont, infoX - infoMaxW - space_width * 3, y, color, TEXT_ALIGN_RIGHT)
end

local function DrawUnitInfo(ply)
	for k, v in ipairs(unitTexts) do
		drawRightCenteredText(v[1], v[2], infoY + (k - 1) * font_size, v[3])
	end
end

hook.Add("HUDPaint", "DrawCombineOverlay", function()
	-- local convar = clientConvar:GetInt()
	-- if convar == 0 then return end
	local ply = LocalPlayer()
	if not ply or not ply:Alive() then return end
	if not ply:isCP() or ply:Team() == TEAM_MAYOR then return end
	if ply:isMP() and not ply:isEnabledMask() then return end
	DrawDisplayLines()
	DrawUnitInfo(ply)
	DrawSquad(ply)
end)


net.Receive("CPNotify", function(_, ply)
	local text = net.ReadString() or "ERROR"
	local color = net.ReadColor() or col.w
	DarkRP.AddCombineDisplayLine(text, color)
end)

local randomDisplayLines = {
	"Передача Вашего местоположения...",
	"Проверка всех физических показателей...",
	"Отслеживание важных задач...",
	"Получение новых директив...",
	"Обновление координат биосигнала...",
	"Обновление и подтверждение наличия связи...",
	"Загрузка последних обновлений...",
	--"Windows 10 требуется обновление...",
	"Обновление всех внешних подключений...",
	"Синхронизация всех данных...",
	"Обновление радиосигнала...",
	"Поиск свободной точки сигнала...",
	"Проверка сенсора...",
	"Проверка пинга до центрального сервера...",
	"Ожидание подключения...",
	"Инициализация протоколов наблюдения...",
	"Анализ внешних условий...",
	"Проверка целостности биосигнала...",
	"Поиск источников аномальной активности...",
	"Обновление параметров безопасности...",
	"Сканирование окружающей среды...",
	"Проверка систем энергоснабжения...",
	"Обработка телеметрических данных...",
	"Подготовка оперативного отчета...",
	"Синхронизация с локальной сетью...",
	"Поиск угроз в радиусе 50 метров...",
	"Проверка резервных каналов связи...",
	"Проверка статуса систем защиты...",
	"Запрос на подтверждение команды...",
	"Обновление навигационных данных...",
	"Диагностика модуля ввода-вывода...",
	"Калибровка сенсорных систем...",
	"Сбор данных для аналитики...",
	"Отправка данных в центральный узел...",
	"Инициализация аварийных протоколов...",
	"Синхронизация данных с планшетом...",
	"Анализ сетевого окружения...",
	"Подготовка к следующей операции...",
	"Оптимизация маршрутов передачи данных...",
	"Идентификация близлежащих сигналов...",
	"Проверка доступа к зашифрованным каналам...",
	"Оценка состояния коммуникационных систем...",
	"Загрузка обновленных инструкций...",
	"Анализ потенциальных рисков...",
	"Проверка мощности сигнала...",
	"Запуск систем наблюдения...",
	"Инициализация протоколов эвакуации...",
	"Сбор данных о погодных условиях...",
	"Координация с ближайшими устройствами...",
	"Проверка целостности оборудования...",
	"Обновление списка приоритетных задач...",
	"Уведомление о статусе мониторинга...",
	"Анализ трафика передачи данных...",
	"Оценка уровня внешних угроз...",
	"Установление защищенного соединения...",
	"Контроль энергопотребления...",
	"Подключение к вспомогательным модулям...",
	"Запуск внутренней диагностики...",
	"Поиск ближайших маяков связи...",
	"Проверка конфигурации сенсоров...",
	"Сканирование неизвестных объектов...",
	"Активация расширенного режима анализа...",
	"Координация данных с главным сервером...",
	"Обновление базы данных объектов...",
	"Обнаружение возможных неисправностей...",
	"Запрос резервных инструкций...",
	"Проверка логов активности..."
}

local curTime, health, armor
local nextHealthWarning = CurTime() + 2
local nextRandomLine = CurTime() + 3
local lastRandomDisplayLine = ""
hook.Add("PlayerOneSecond", "DisplayLine_Tick", function(ply)
	if ply ~= LocalPlayer() then return end
	-- local convar = clientConvar:GetInt()
	-- if convar == 0 then return end

	--local convar = ply:isEnabledMask()
	local is_cp = (ply:isCP() or ply:isOTA()) and ply:Team() ~= TEAM_MAYOR
	if not ply:Alive() or not is_cp then
		unitTexts = {}
		squadTexts = {}
		squadMembers = {}
		return
	end

	UpdateUnitTexts(ply)
	UpdateSquadTexts(ply)
	curTime = CurTime()
	health = ply:Health()
	armor = ply:Armor()

	if nextHealthWarning <= curTime then
		if ply.lastHealth then
			if health < ply.lastHealth then
				if health == 0 then
					DarkRP.AddCombineDisplayLine("!ERROR! ОТКАЗ СИСТЕМ ЖИЗНЕОБЕСПЕЧЕНИЯ!", Color(255, 0, 0, 255))
				else
					DarkRP.AddCombineDisplayLine("!WARNING! Обнаружено физическое повреждение!", Color(255, 0, 0, 255))
				end
			elseif health > ply.lastHealth then
				if health >= ply:GetMaxHealth() then
					DarkRP.AddCombineDisplayLine("Физические показатели восстановлены.", Color(0, 255, 0, 255))
				else
					DarkRP.AddCombineDisplayLine("Физические показатели восстанавливаются.", Color(0, 0, 255, 255))
				end
			end
		end

		if ply.lastArmor then
			if armor < ply.lastArmor then
				if armor == 0 then
					DarkRP.AddCombineDisplayLine("!ERROR! Внешняя защита исчерпана!", Color(255, 0, 0, 255))
				else
					DarkRP.AddCombineDisplayLine("!WARNING! Обнаружено повреждение внешней защиты!", Color(255, 0, 0, 255))
				end
			elseif armor > ply.lastArmor then
				if armor >= ply:GetMaxArmor() then
					DarkRP.AddCombineDisplayLine("Внешняя защита восстановлена.", Color(0, 255, 0, 255))
				else
					DarkRP.AddCombineDisplayLine("Внешняя защита восстанавливается.", Color(0, 0, 255, 255))
				end
			end
		end

		nextHealthWarning = curTime + 2
		ply.lastHealth = health
		ply.lastArmor = armor
	end

	if nextRandomLine <= curTime then
		local text = randomDisplayLines[math.random(1, #randomDisplayLines)]
		if text and lastRandomDisplayLine ~= text then
			DarkRP.AddCombineDisplayLine(text)
			lastRandomDisplayLine = text
		end

		nextRandomLine = CurTime() + math.random(3, 6)
	end
end)

local cfgCombineMaterial = {
	{"union/combine_tactview2", 0.6},
	{"effects/combine_binocoverlay", 0.4}
}

hook.Add("InitPostEntity", "Combine_SetMaterialAlpha", function()
	for k, v in ipairs(cfgCombineMaterial) do
		local material = Material(v[1])
		if material:GetFloat("$alpha") ~= v[2] then material:SetFloat("$alpha", v[2]) end
	end
end)

hook.Add("RenderScreenspaceEffects", "Combine_Overlay_Effects", function()
	-- local convar = clientConvar:GetInt()
	-- if convar == 0 then return end
	local ply = LocalPlayer()
	if ThirdPerson.IsEnabled() then return end
	if not ply:isEnabledMask() and not ply:isOTA() or ply:GetModel() == "models/player/soldier_stripped.mdl" then return end

	if IsValid(ply) and ply:isCP() and ply:Team() ~= TEAM_MAYOR then
		if ply:isOTA() then
			DrawMaterialOverlay("union/combine_tactview2", 0)
		else
			DrawMaterialOverlay("effects/combine_binocoverlay", 0)
		end
	end
end)

timer.Create("checkprotocol", 60, 0, function()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not ply:Alive() then return end
	if not ply:isOTA() or ply:Team() == TEAM_MAYOR then return end
	local protocol = ply:GetNetVar("ota.protocol") or ply:getJobTable().defaultProtocol
	DarkRP.AddCombineDisplayLine(protocol and "Активен протокол " .. protocol or "Требуется запрос протокола", Color(0, 0, 255))
end)

local dist = 250 * 250
local icon = Material("icon16/lock.png")
hook.Add("HUDPaint", "DrawLocked", function()
	local ply = LocalPlayer()
	local ent = ply:GetEyeTraceNoCursor().Entity
	local w, h = ScrW(), ScrH()
	if IsValid(ent) and ent:GetNetVar("fading") and ply:GetPos():DistToSqr(ent:GetPos()) < dist then
		surface.SetMaterial(icon)
		surface.SetDrawColor(color_white:Unpack())
		surface.DrawTexturedRect(w * 0.5 - 8, h * 0.53, 16, 16)
	end
end)

netstream.Hook("cmd.NoticeAdd", function(text, icon, time, color)
	local ply = LocalPlayer()
	if ply:isCP() and ply:Alive() then DarkRP.CPoints:AddLine(text, icon, time, color) end
end)

local convar_names = {
	--["unionrp_combineoverlay"] = "Отображение оверлея",
	["unionrp_squad_outline"] = "Отображение контуров отряда",
	["unionrp_squad_drawcircle"] = "Отображение круга под иконкой",
	["unionrp_squad_drawhealth"] = "Отображение иконки здоровья",
	["unionrp_squad_drawname"] = "Отображение CID",
	["unionrp_squad_dormant"] = "Отображение игроков в дорманте"
}

hook.Add("PopulateToolMenu", "Combine.Squads", function()
	spawnmenu.AddToolMenuOption("UnionRP", "Настройки", "Combine.Squads", "Отряды", "", "", function(option)
		option:ClearControls()
		option:addlbl("Отряды ГО/ОТА:", true)
		for k, v in pairs(convar_names) do
			local convar = GetConVar(k)
			option:addchk(v, nil, convar:GetBool(), function(c)
				convar:SetBool(c)
			end)
		end
		option:addslider(squadOutlineDistMin, squadOutlineDistMax, "Максимальная дистанция ( юниты )", GetConVar("unionrp_squad_maxdist"):GetInt(), "unionrp_squad_maxdist", 0)
	end)
end)