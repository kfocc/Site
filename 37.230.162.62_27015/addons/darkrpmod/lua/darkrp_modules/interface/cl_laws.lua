local surface_CreateFont = surface.CreateFont
local draw_SimpleText = draw.SimpleText
local draw_RoundedBoxEx = draw.RoundedBoxEx
local hook_Add = hook.Add
local draw_GetFontHeight = draw.GetFontHeight
local math = math
local draw = draw
local ipairs = ipairs

laws = laws or {}
local MAX_LAW_SYMBOLS = 80
local MAX_LAWS_COUNT = 26
-- local toggle = CreateClientConVar("Union_board_toggle", "1", true, false)

-- addLaw
-- removeLaw
-- resetLaws
local function S(v)
	return ScrH() * (v / 900)
end

local function paint_me(btn)
	if not IsValid(btn) then return end
	btn.Paint = function(self, w, h)
		local col = col.o
		if self:IsDown() then col = col:darken(30) end
		if self.entered and not self:IsDown() then col = col:lighten(30) end

		draw.RoundedBox(0, 0, 0, w, h, col)
	end

	btn.OnCursorEntered = function(self) if not self.entered then self.entered = true end end
	btn.OnCursorExited = function(self) if self.entered then self.entered = nil end end
end

local function addLine(pnl, id, txt)
	if not pnl or not pnl:IsValid() then return end

	local panel = vgui.Create("DPanel")
	panel:Dock(TOP)
	panel:DockMargin(4, 3, 4, 0)
	panel:SetTall(S(20))
	panel.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, col.ba:lighten(35)) end

	pnl:AddItem(panel)

	local dlabel = panel:Add("DLabel")
	dlabel:Dock(LEFT)
	dlabel:SetWide(20)
	dlabel:SetTextColor(color_white)
	dlabel:SetText(" " .. id .. ":")
	dlabel:SetContentAlignment(5)

	local dbut = panel:Add("DButton")
	dbut:Dock(RIGHT)
	dbut:SetWide(20)
	dbut:SetTextColor(color_white)
	dbut:SetText("X")
	dbut:SetContentAlignment(5)

	dbut.DoClick = function()
		-- RunConsoleCommand("darkrp", "removelaw", id)
		netstream.Start("DRP_RemoveLaw", id)
	end
	paint_me(dbut)

	local dbuts = panel:Add("DImageButton")
	dbuts:SetImage("icon16/disk.png")
	dbuts:Dock(RIGHT)
	dbuts:DockMargin(0, 0, 3, 0)
	dbuts:SetWide(20)
	-- dbuts:SetTextColor(color_white)
	-- dbuts:SetText("X")
	dbuts:SetContentAlignment(5)
	dbuts:SetVisible(false)

	dbuts.DoClick = function()
		local text = tostring(panel.dte:GetText())
		-- RunConsoleCommand("darkrp", "changelaw", id, text)
		netstream.Start("DRP_ChangeLaw", id, text)
	end
	-- paint_me(dbuts)

	local dte = panel:Add("DTextEntry")
	dte:Dock(FILL)
	dte:SetPaintBackground(false)
	dte:SetTextColor(color_white)
	dte:SetCursorColor(color_white)
	dte:SetText(txt)

	dte.OnEnter = function(self)
		local text = tostring(self:GetText())
		-- RunConsoleCommand("darkrp", "changelaw", id, text)
		netstream.Start("DRP_ChangeLaw", id, text)
	end

	dte.OnChange = function(self)
		local oldText = DarkRP.getLaws()[id]
		if not oldText then return end
		local currentText = self:GetText()
		if currentText ~= oldText then
			if dbuts:IsVisible() then return end
			dbuts:SetVisible(true)
		else
			dbuts:SetVisible(false)
		end
	end

	if GAMEMODE.Config.DefaultLaws[id] then dte:SetEnabled(false) end
	panel.dte = dte
	return panel
end

local laws_menu
function laws.BuildMenu()
	if IsValid(laws_menu) then
		laws_menu:Remove()
		laws_menu = nil
	end

	local wW, wH = S(600), S(400)
	laws_menu = vgui.Create("DFrame")
	laws_menu:SetSize(wW, wH)
	laws_menu:Center()
	laws_menu:MakePopup()
	laws_menu:SetTitle("Управление законами")
	-- laws_menu:SetDraggable(false)
	laws_menu:ShowCloseButton(false)
	laws_menu.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.ba)
		draw.RoundedBox(0, 0, 0, w, 23, col.o)
		draw.RoundedBox(0, 0, 23, w, 1, col.w)
	end

	local dp = laws_menu:Add("DScrollPanel")
	dp:Dock(FILL)
	dp.Paint = function(self, w, h) draw.RoundedBox(0, 0, 0, w, h, col.ba:darken(10)) end
	dp.Rebuilds = function(self)
		self:Clear()
		for k, v in ipairs(DarkRP.getLaws()) do
			addLine(self, k, v)
		end
	end

	laws_menu.dp = dp
	dp:Rebuilds()
	local dbt = laws_menu:Add("DButton")
	dbt:Dock(BOTTOM)
	dbt:SetTall(S(25))
	dbt:SetTextColor(color_white)
	dbt:SetFont("UnionFont")
	dbt:SetText("Добавить новый закон")
	dbt:SetContentAlignment(5)
	dbt.DoClick = function()
		Derma_StringRequest("Добавить закон", "Введите текст закона.", "", function(text)
			-- RunConsoleCommand("darkrp", "addlaw", text)
			netstream.Start("DRP_AddLaw", text)
		end, function() end, "Добавить", "Закрыть")
	end
	paint_me(dbt)

	-- local dbt1 = laws_menu:Add("DButton")
	-- dbt1:Dock(BOTTOM)
	-- dbt1:DockMargin(0, 0, 0, 3)
	-- dbt1:SetTall(S(25))
	-- dbt1:SetTextColor(color_white)
	-- dbt1:SetFont("UnionFont")
	-- dbt1:SetText("Обновить")
	-- dbt1:SetContentAlignment(5)
	-- dbt1.DoClick = function()
	-- 	dp:Rebuilds()
	-- end
	local step = S(7)
	local buttonSize = S(16)
	local posW = wW - buttonSize - step
	local posH = S(4)
	local cb = laws_menu:Add("DImageButton")
	cb:SetImage("icon16/cancel.png")
	-- cb:Dock(BOTTOM)
	-- cb:DockMargin(0, 0, 0, 3)
	cb:SetSize(buttonSize, buttonSize)
	cb:SetPos(posW, posH)
	cb:SetContentAlignment(5)
	cb.DoClick = function() laws_menu:Remove() end
	paint_me(cb)
	posW = posW - buttonSize - step
	local dbt1 = laws_menu:Add("DImageButton")
	dbt1:SetImage("icon16/arrow_refresh.png")
	-- dbt1:Dock(BOTTOM)
	-- dbt1:DockMargin(0, 0, 0, 3)
	dbt1:SetSize(buttonSize, buttonSize)
	dbt1:SetPos(posW, posH)
	dbt1:SetContentAlignment(5)
	dbt1.DoClick = function() dp:Rebuilds() end
	paint_me(dbt1)
end

-- addLaw
-- removeLaw
-- resetLaws
local hooks = {
	addLaw = function(id, law)
		if not IsValid(laws_menu) then return end
		addLine(laws_menu.dp, id, law)
	end,
	changeLaw = function(id, law)
		if not IsValid(laws_menu) then return end
		laws_menu.dp:Rebuilds()
	end,
	removeLaw = function()
		if not IsValid(laws_menu) then return end
		laws_menu.dp:Rebuilds()
	end,
	resetLaws = function()
		if not IsValid(laws_menu) then return end
		laws_menu.dp:Rebuilds()
	end,
	loadLaws = function()
		if not IsValid(laws_menu) then return end
		laws_menu.dp:Rebuilds()
	end,
}

for k, v in pairs(hooks) do
	hook.Add(k, "updateMayorLaws", v)
end

local function notify(txt)
	notification.AddLegacy(txt, NOTIFY_ERROR, 5)
	surface.PlaySound("buttons/lightswitch2.wav")
	Msg("[DarkRP] " .. txt .. "\n")
end

local filePath = "unionrp/laws/save_laws.json"
local fileSpecificPath = "unionrp/laws/save_laws_c" .. (TEAM_GORDON and "17" or "2") .. ".json"
function laws:SaveCurrentLaws()
	local numOfDefaultLaws = #GAMEMODE.Config.DefaultLaws
	local currentLaws = DarkRP.getLaws()
	local numOfCurrentLaws = #DarkRP.getLaws()
	if numOfCurrentLaws <= numOfDefaultLaws then
		notify("Вы не можете сохранить стандартные законы.")
		return
	end

	local sortTbl = {}
	for i = numOfDefaultLaws + 1, numOfCurrentLaws do
		table.insert(sortTbl, currentLaws[i])
	end

	if not file.Exists("unionrp/laws", "DATA") then file.CreateDir("unionrp/laws") end
	file.Write(fileSpecificPath, util.TableToJSON(sortTbl))
end

function laws:LoadSavedLaws()
	local path = fileSpecificPath
	local isExist = file.Exists(path, "DATA")
	if not isExist then
		path = filePath
		isExist = file.Exists(path, "DATA")
	end

	if not isExist then
		notify("У Вас нет сохраненных законов.")
		return
	end

	local content = file.Read(path, "DATA")
	local st, res = pcall(util.JSONToTable, content)
	if not st or not res then
		notify("Произошла ошибка загрузки сохраненных законов." .. (not res and " Из-за ошибки конвертации." or ""))
		return
	end

	local realMax = MAX_LAWS_COUNT - #GAMEMODE.Config.DefaultLaws
	local lawsCount = #res
	if lawsCount > realMax then
		notify("Сохраненных законов слишком много - " .. lawsCount .. ". Максимальное количество: " .. realMax .. "!")
		return
	end

	for k, v in ipairs(res) do
		if not isstring(v) then continue end
		local strLen = string.utf8len(v)
		if strLen < 10 then
			continue
		elseif strLen > MAX_LAW_SYMBOLS then
			res[k] = v:utf8sub(1, MAX_LAW_SYMBOLS) .. "..."
		end
	end

	netstream.Start("DRP_LoadLaws", res)
end
