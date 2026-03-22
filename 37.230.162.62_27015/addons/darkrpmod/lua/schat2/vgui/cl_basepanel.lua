local PANEL = {}
-- Color(12, 12, 12, 180)
-- Color(216, 101, 74)
local sscale = util.SScale
local utf8_force = utf8.force
local string_utf8len = string.utf8len
local string_utf8sub = string.utf8sub

local richTextEntryColor = Color(0, 0, 0, 255)
local textEntryColor = Color(0, 0, 0, 255)
local mainPanelBlack = Color(0, 0, 0, 255)
local mainPanelOrange = Color(216, 101, 74, 255)
local mainPanelWhite = Color(255, 255, 255, 255)

-- local pMeta = FindMetaTable("Player")
-- local oldSteamID = _G.oldSteamID or pMeta.SteamID
-- _G.oldSteamID = oldSteamID
-- function pMeta:SteamID()
--	 if self:IsBot() then
--		 return "STEAM_0:0:" .. self:UniqueID()
--	 end

--	 return oldSteamID(self)
-- end

local preffixMap = {
	["!"] = function(text, chatTypeCMD)
		local explodeText = string.match(text, "^(![a-zA-ZЀ-џ0-9%p]+)") or ""
		return ULib.commandsMap[explodeText] or SChat2.Config.customExclamationCommand[explodeText]
	end,
	["/"] = function(text, chatTypeCMD)
		local explodeText = string.match(text, "^/([a-zA-ZЀ-џ0-9%p]+)") or ""
		return DarkRP.getChatCommand(explodeText) ~= nil or SChat2.Config.customSlashCommand[explodeText]
	end,
}

local dMenu
local function buildDMenu()
	if IsValid(dMenu) then
		dMenu:Remove()
	end

	dMenu = DermaMenu()
	function dMenu:AddSpacer(strText, funcFunction)
		local pnl = vgui.Create("EditablePanel", self)
		pnl.Paint = function(p, w, h)
			surface.SetDrawColor(col.o)
			surface.DrawRect(0, 0, w, h)
		end

		pnl:SetTall(1)
		self:AddPanel(pnl)

		return pnl
	end

	local col1 = col.o:darken(20)
	local oldAddOption = dMenu.AddOption
	dMenu.AddOption = function(dmenu, name, func, icon)
		local option = oldAddOption(dmenu, name, func)
		option:SetTextColor(col.w)
		option.Paint = function(_self, w, h)
			if name == "" then return end
			if _self:IsHovered() then
				draw.RoundedBox(0, 0, 0, w, h, col1)
			end
		end

		if icon then
			option:SetIcon(icon)
		end
	end

	dMenu.Paint = function(_, w, h)
		draw.RoundedBox(0, 0, 0, w, h, col.ba)
	end

	return dMenu
end

local color_black = color_black
local color_gray = Color(237, 237, 237)
local color_orange = Color(215, 100, 75, 255)
local color_orange_darken = color_orange:darken(25)
local color_orange_light = color_orange:lighten(20)
function PANEL:Init()
	self.currentChatType = 1
	self.chatsTypeEnum = {
		{
			cmd = "say",
			label = "Чат",
			ignore_hook = true
		},
		{
			cmd = "/g",
			label = "Team"
		},
		{
			cmd = "/looc",
			label = "LOOC"
		},
		{
			cmd = "/ooc",
			label = "OOC"
		},
		{
			cmd = "/adm",
			label = "ADM",
			canChange = function()
				local ply = LocalPlayer()
				return ply:isVIP() and not ply:IsUserGroup("vip")
			end,
		},
		{
			cmd = "/v",
			label = "VIP",
			canChange = function()
				return LocalPlayer():isVIP()
			end,
		},
		{
			cmd = "/pm",
			label = "PM",
			canChange = function()
				return self.customChatActive
			end,
		}
	}

	local posX, posY = SChat2:GetConvar("posX", 10), SChat2:GetConvar("posY", ScrH() * 0.5)
	local sizeW, sizeH = SChat2:GetConvar("sizeW", ScrW() / 3), SChat2:GetConvar("sizeH", ScrW() / 3)
	self:SetPos(posX, posY)
	self:SetSize(sizeW, sizeH)
	self:MakePopup()
	self:SetTitle("")
	self:ShowCloseButton(false)
	self:SetSizable(true)

	local minW, minH = SChat2.Config.sizeW / SChat2.Config.minSizeW, SChat2.Config.sizeH / SChat2.Config.minSizeH
	self:SetMinWidth(minW)
	self:SetMinHeight(minH)

	self.Alpha = 255
	self.Displayed = true
	self.BlurMat = Material("pp/blurscreen")

	local sscale1 = sscale(1)
	local closer = vgui.Create("DButton", self)
	closer:SetSize(sscale(35), sscale(18))
	closer:SetText("")
	closer:SetPos(self:GetWide() - sscale(33), 4)
	closer.Paint = function(this, w, h)
		draw.SimpleText("X", "SChat218", w / 2, h / 2 - 1, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	closer.DoClick = function()
		self:ChatHide()
	end
	self.Closer = closer

	local mainPanel = vgui.Create("EditablePanel", self)
	mainPanel:Dock(FILL)
	-- mainPanel:DockMargin(0, sscale(3), 0, 0)
	mainPanel.Paint = nil

	local sscale2 = sscale(2)
	local headerPanel = vgui.Create("EditablePanel", mainPanel)
	headerPanel:Dock(TOP)
	headerPanel:DockPadding(sscale(3), sscale(3), sscale(3), sscale(3))
	headerPanel:SetTall(sscale(30))
	headerPanel.Paint = function(_self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, richTextEntryColor)
	end

	local chatButton = vgui.Create("DButton", headerPanel)
	chatButton:Dock(LEFT)
	chatButton:SetWide(sscale(100))
	chatButton:SetText("")
	chatButton.DoClick = function()
		local currentActive = self.pmChatScroller.currentActive
		if currentActive then
			self.Txt:SetVisible(true)

			self.customChatActive = false
			self:SetChatType("say")

			currentActive[1].isActive = false
			currentActive[2]:SetVisible(false)
			self.pmChatScroller.currentActive = nil
		end
	end
	chatButton.Paint = function(_self, w, h)
		local col1 = color_orange_darken
		local col2 = color_orange
		if _self:IsHovered() then
			col2 = color_orange_light
		end
		surface.drawGradientPanelBox(_self, 0, 0, w, h, 1, col1, col2, col2, col1)
		draw.SimpleText("Чат", "SChat218", w * 0.5, h * 0.5, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.chatButton = chatButton

	local newChatButton = vgui.Create("DButton", headerPanel)
	newChatButton:Dock(LEFT)
	newChatButton:DockMargin(sscale(4), 0, 0, 0)
	newChatButton:SetWide(sscale(100))
	newChatButton:SetText("")
	newChatButton.DoClick = function(_self)
		local dmenu = buildDMenu()
		local plys = player.GetAll()
		local selfPlayer = LocalPlayer()
		table.sort(plys, function(a, b) return a:Name() < b:Name() end)
		for _, v in ipairs(plys) do
			if v == selfPlayer then continue end

			local sid = v:SteamID()
			local name = v:Name()
			dmenu:AddOption(name, function()
				self:createPrivateMessageTab(sid, name, true)
			end, "icon16/user.png")
		end

		local w, h = _self:LocalToScreen(_self:GetWide(), 0)
		dmenu:Open(w, h, false, _self)
	end
	newChatButton.Paint = function(_self, w, h)
		local col1 = color_orange_darken
		local col2 = color_orange
		if _self:IsHovered() then
			col2 = color_orange_light
		end
		surface.drawGradientPanelBox(_self, 0, 0, w, h, 1, col1, col2, col2, col1)
		draw.SimpleText("Написать...", "SChat218", w * 0.5, h * 0.5, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.newChatButton = newChatButton

	local buttonsScroller = vgui.Create("DHorizontalScroller", headerPanel)
	buttonsScroller:Dock(FILL)
	buttonsScroller:DockMargin(sscale(4), 0, 0, 0)
	buttonsScroller:SetOverlap(sscale(-3))
	buttonsScroller:SetUseLiveDrag(true)
	buttonsScroller.chats = {}
	local darkColor = Color(255, 255, 255, 10)
	buttonsScroller.Paint = function(_self, w, h)
		if not table.IsEmpty(_self.chats) then
			-- surface.SetDrawColor(255, 255, 255, 10)
			-- surface.DrawRect(0, 0, w, h, 1)
			draw.RoundedBoxEx(6, 0, 0, w, h, darkColor, true, true, false, false)
		end
	end

	self.pmChatScroller = buttonsScroller

	local bodyPanel = vgui.Create("EditablePanel", mainPanel)
	bodyPanel:Dock(FILL)
	bodyPanel:DockMargin(0, sscale2, 0, 0)
	bodyPanel.Paint = nil
	self.bodyPanel = bodyPanel

	local mainText = vgui.Create("RichText", bodyPanel)
	mainText:Dock(FILL)
	mainText:InsertColorChange(215, 215, 215, 255)
	mainText:SetBGColor(richTextEntryColor)
	mainText.Paint = nil
	mainText.PerformLayout = function(_self)
		_self:SetBGColor(richTextEntryColor)

		local font = SChat2:GetConvar("richTextFont", SChat2.Config.richTextFont)
		if _self:GetFont() == font then return end
		_self:SetFontInternal(font)
	end
	mainText.Think = function(_self)
		if not self.Displayed and (not _self.fadeOut or CurTime() > _self.fadeOut) then
			_self:SetVisible(false)
		end
	end
	self.Txt = mainText

	local bottomPanel = vgui.Create("EditablePanel", mainPanel)
	bottomPanel:Dock(BOTTOM)
	bottomPanel:DockMargin(0, sscale2, 0, 0)
	bottomPanel:SetTall(sscale(35))
	bottomPanel.Paint = nil

	local mainTextEntry = vgui.Create("DTextEntry", bottomPanel)
	mainTextEntry.History = {}
	mainTextEntry:Dock(FILL)
	mainTextEntry:DockMargin(0, sscale(1), 0, sscale(1))
	mainTextEntry:SetPaintBackgroundEnabled(true)
	mainTextEntry:SetHistoryEnabled(true)
	mainTextEntry:SetCursorColor(Color(200, 200, 200, 255))
	mainTextEntry:SetTextColor(Color(200, 200, 200, 255))
	mainTextEntry:SetHighlightColor(SChat2:GetConvar("Color", Color(66, 139, 202, 255)))
	mainTextEntry:SetBGColor(textEntryColor)
	mainTextEntry:RequestFocus()
	mainTextEntry:SetTabbingDisabled(true)
	mainTextEntry.Paint = nil
	mainTextEntry.PerformLayout = function(_self, w, h)
		_self:SetBGColor(textEntryColor)

		local font = SChat2:GetConvar("richTextFont", SChat2.Config.richTextFont)
		if _self:GetFont() == font then return end
		_self:SetFontInternal(font)
	end
	local oldKeyCodeTypes = mainTextEntry.OnKeyCodeTyped
	mainTextEntry.OnKeyCodeTyped = function(_self, key)
		if key == KEY_TAB and not self.customChatActive then
			self:NextChatType()
			return true
		end
		oldKeyCodeTypes(_self, key)
	end
	mainTextEntry.OnEnter = function()
		self:Chat()
	end
	mainTextEntry.OnChange = function(_self)
		local maxLen = SChat2.Config.maxTextLength
		local value = utf8_force(_self:GetText())
		local valueLen = string_utf8len(value)
		if valueLen >= maxLen then
			value = string_utf8sub(value, 1, maxLen)

			_self:SetText(value)
			_self:SetCaretPos(valueLen)
			surface.PlaySound("UI/buttonclick.wav")
		end
		local chatType = self:GetChatType()
		local cmd = (not chatType.ignore_hook and chatType.cmd) and (chatType.cmd .. " ") or ""
		local textIsCmd = string.sub(value, 1, 1)
		local mapFunc = preffixMap[textIsCmd]
		local real_cmd = mapFunc and mapFunc(value, cmd)
		if real_cmd then
			cmd = ""
		end
		gamemode.Call("ChatTextChanged", cmd .. value)
	end
	mainTextEntry.UpdateFromHistory = function(_self)
		local pos = _self.HistoryPos
		if pos < 0 then pos = #_self.History end
		if pos > #_self.History then pos = 0 end

		local text = _self.History[ pos ]
		if not text then text = "" end

		_self:SetText(text)
		_self:SetCaretPos(text:utf8len())

		_self:OnTextChanged()
		_self.HistoryPos = pos
	end
	self.TextEntry = mainTextEntry

	local sendButton = vgui.Create("DButton", bottomPanel)
	sendButton:Dock(RIGHT)
	sendButton:SetWide(sscale(100))
	sendButton:DockMargin(sscale(3), sscale(3), 0, sscale(3))
	sendButton:SetText("")
	sendButton.DoClick = function()
		self:Chat()
	end
	sendButton.Paint = function(_self, w, h)
		local col1 = color_orange_darken
		local col2 = color_orange
		if _self:IsHovered() then
			col2 = color_orange_light
		end
		surface.drawGradientPanelBox(_self, 0, 0, w, h, 1, col1, col2, col2, col1)
		draw.SimpleText("Отправить", "SChat218", w * 0.5, h * 0.5, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.TextActivate = sendButton

	local chatsTypeEnum = self.chatsTypeEnum
	local changeTypeButton = vgui.Create("DButton", bottomPanel)
	changeTypeButton:Dock(LEFT)
	changeTypeButton:SetWide(sscale(55))
	changeTypeButton:DockMargin(0, 0, sscale(4), sscale(1))
	changeTypeButton:SetText("")
	changeTypeButton.DoClick = function(_self)
		if self.customChatActive then return end

		local dmenu = buildDMenu()
		for i = 1, #chatsTypeEnum do
			local chatValue = chatsTypeEnum[i]
			local canChange = chatValue.canChange
			if canChange and canChange() == false then continue end

			dmenu:AddOption(chatValue.label, function()
				self:SetChatType(i)
			end)
		end
		local w, h = _self:LocalToScreen(_self:GetWide(), 0)
		dmenu:Open(w, h, false, _self)
	end
	changeTypeButton.Paint = function(_self, w, h)
		local col1 = color_orange_darken
		local col2 = color_orange
		if _self:IsHovered() then
			col2 = color_orange_light
		end
		surface.drawGradientPanelBox(_self, 0, 0, w, h, 1, col1, col2, col2, col1)

		local chatType = self:GetChatType().label
		draw.SimpleText(chatType, "SChat218", w * 0.5, h * 0.5, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	self.changeTypeButton = changeTypeButton

	mainTextEntry:SetAlpha(170)
	closer:SetAlpha(170)
	chatButton:SetAlpha(200)
	newChatButton:SetAlpha(200)
	changeTypeButton:SetAlpha(200)
	sendButton:SetAlpha(200)
	buttonsScroller:SetAlpha(200)
end

function PANEL:GetChatTypeInt()
	return self.currentChatType
end

function PANEL:GetChatType()
	return self.chatsTypeEnum[self.currentChatType]
end

function PANEL:NextChatType()
	local nextChatType = self.currentChatType
	local canChange = nil
	repeat
		nextChatType = nextChatType + 1
		if nextChatType > #self.chatsTypeEnum then
			nextChatType = 1
		end

		local chatType = self.chatsTypeEnum[nextChatType]
		canChange = chatType.canChange
	until (not canChange or canChange() == true)
	self.currentChatType = nextChatType
	self.TextEntry:OnChange()
end

function PANEL:SetChatType(chatType)
	local selectedChatType = chatType
	local chatEnums = self.chatsTypeEnum
	if isstring(chatType) then
		for i = 1, #chatEnums do
			local chatTypeData = chatEnums[i]
			if chatTypeData.cmd == chatType then
				selectedChatType = i
				break
			end
		end

		if isstring(selectedChatType) then
			return
		end
	end

	local chatTypeData = chatEnums[selectedChatType]
	if not chatTypeData then return end

	local canChange = chatTypeData.canChange
	if canChange and canChange() == false then return end
	self.currentChatType = selectedChatType
	self.TextEntry:OnChange()
end

function PANEL:Think()
	self.BaseClass.Think(self)

	local x, y = self:GetPos()
	local sizeX, sizeY = self:GetSize()
	local w, h = ScrW() - sizeX, ScrH() - sizeY
	if (x < 0 or x > w) or (y < 0 or y > h) then
		x = math.Clamp(x, 0, w)
		y = math.Clamp(y, 0, h)
		self:SetPos(x, y)
	end

	if not self.Displayed then
		self:MoveToBack()
	end

	local esc, tilda = input.IsKeyDown(KEY_ESCAPE), input.IsKeyDown(KEY_BACKQUOTE)
	if self.Displayed and (esc or tilda) --[[or gui.IsGameUIVisible()]] then
		gui.HideGameUI()
		if not tilda then
			self:ChatHide()
		end
	end
end

function PANEL:PerformLayout()
	self.BaseClass.PerformLayout(self)

	self.Closer:SetPos(self:GetWide() - sscale(33), 4)
end

function PANEL:DrawBlur(panel, layers, density, alpha)
	local x, y = panel:LocalToScreen(0, 0)
	local blurMaterial = self.BlurMat
	surface.SetDrawColor(255, 255, 255, alpha)
	surface.SetMaterial(blurMaterial)

	for i = 1, 3 do
		blurMaterial:SetFloat("$blur", (i / layers) * density)
		blurMaterial:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(-x, -y, ScrW(), ScrH())
	end
end

local defaultHostname = "UnionRP"
function PANEL:Paint(width, height)
	if self.Alpha == 0 then return true end
	self:DrawBlur(self, 1, 2, self.Alpha)

	mainPanelBlack.a = self.Alpha
	draw.RoundedBox(0, 0, 0, width, height, mainPanelBlack)

	mainPanelOrange.a = self.Alpha
	draw.RoundedBox(2, 0, 0, width, 25, mainPanelOrange)

	mainPanelWhite.a = self.Alpha
	draw.SimpleText(netvars.GetNetVar("main.hostname", defaultHostname), "SChat220", 10, 4, mainPanelWhite, TEXT_ALIGN_LEFT)
end

function PANEL:AddNewLine(info, insertPanel, notFade)
	local textPanel = insertPanel or self.Txt
	if SChat2:GetConvar("showTimestamps", false) then
		textPanel:InsertColorChange(215, 215, 215, 255)
		textPanel:AppendText("[" .. os.date("%X", os.time()) .. "] ")
		if not notFade then
			textPanel:InsertFade(10, 2)
		end
	end

	for _, v in ipairs(info) do
		if type(v) == "Player" then
			local _col = v:GetTeamColor()
			textPanel:InsertColorChange(_col.r, _col.g, _col.b, 255)
			textPanel:AppendText(v:Name())
			if not notFade then
				textPanel:InsertFade(10, 2)
			end
			textPanel:InsertColorChange(215, 215, 215, 255)
			textPanel:AppendText(": ")
			if not notFade then
				textPanel:InsertFade(10, 2)
			end
		elseif type(v) == "string" then
			textPanel:AppendText(v)
			if not notFade then
				textPanel:InsertFade(10, 2)
			end
		elseif type(v) == "table" then
			textPanel:InsertColorChange(v.r, v.g, v.b, 255)
		end
	end
	textPanel:AppendText("\n")
	if not notFade then
		textPanel.fadeOut = CurTime() + 10
		if textPanel == self.Txt and not self.Displayed then
			textPanel:SetVisible(true)
		end
	else
		textPanel.fadeOut = math.huge
	end
end

function PANEL:Chat()
	local textEntry = self.TextEntry
	local text = textEntry:GetValue()
	local textLen = text:utf8len()
	if textLen == 0 then
		self:ChatHide()
		return
	end

	if not (textEntry.lastLine or ""):find(text, 1, true) then
		local histCount = math.min(#textEntry.History, 19)
		textEntry.History[histCount + 1] = text

		textEntry.lastLine = text
	end

	if textLen > SChat2.Config.maxTextLength then
		surface.PlaySound("UI/buttonclick.wav")
		textEntry:SetCaretPos(textLen)
		return
	end

	textEntry:SetText("")
	textEntry:RequestFocus()

	local find = select(3, string.find(text, "^([абвгдеёжзийклмнопрстуфхцчшщъьыэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЬЫЭЮЯ%g%s]+)$"))
	if find ~= text then
		find = nil
		return
	end
	find = nil

	text = string.gsub(text, "%s+", " ")

	local currentChatType = self:GetChatType()
	local chatTypeCMD = currentChatType.cmd
	local pmBased = chatTypeCMD == "/pm"
	local teamBased = chatTypeCMD == "/g"
	if pmBased then
		local buttonsScroller = self.pmChatScroller
		local currentActive = buttonsScroller.currentActive
		if currentActive then
			local sid = currentActive[1].sid
			if sid then
				text = chatTypeCMD .. " " .. sid .. " " .. text
			else
				DarkRP.notify(1, 4, "Произошла ошибка. Получатель не был найден. Попробуйте переоткрыть диалог.")
				self:ChatHide(true)
				return
			end
		else
			DarkRP.notify(1, 4, "Произошла ошибка. Получатель не найден. Попробуйте переоткрыть диалог.")
			self:ChatHide(true)
			return
		end
	else
		if chatTypeCMD ~= "say" and not teamBased then
			local textIsCmd = string.sub(text, 1, 1)
			local mapFunc = preffixMap[textIsCmd]
			if not mapFunc or not mapFunc(text, chatTypeCMD) then
				text = chatTypeCMD .. " " .. text
			end
		end
	end

	net.Start("SChat2.Send")
	net.WriteBool(teamBased)
	net.WriteString(text)
	net.SendToServer()

	if not pmBased or SChat2:GetConvar("closeOnEnterPM", false) then
		self:ChatHide(true)
	end
end

function PANEL:ChatHide(enter)
	gamemode.Call("ChatTextChanged", "")
	if enter and not SChat2:GetConvar("closeOnEnter", true) then
		return
	end

	local x, y = self:GetPos()
	local w, h = self:GetSize()
	local _cvars = SChat2.cvars
	if x ~= _cvars["posX"] or y ~= _cvars["posY"] or w ~= _cvars["sizeW"] or h ~= _cvars["sizeH"] then
		SChat2:SetConvars({"sizeW", w}, {"sizeH", h}, {"posX", x}, {"posY", y})
	end

	self.Txt:SetVisible(true)
	local currentActive = self.pmChatScroller.currentActive
	if currentActive then
		currentActive[1].isActive = false
		currentActive[2]:SetVisible(false)
	end

	self.Displayed = false

	local textPanel = self.Txt
	textPanel:SetVerticalScrollbarEnabled(false)
	textPanel:ResetAllFades(false, true, 0)
	textPanel:GotoTextEnd()

	self:ApplyAlpha()
	self:SetMouseInputEnabled(false)
	self:SetKeyboardInputEnabled(false)
	gamemode.Call("FinishChat")

	local isTeam = self.isTeam
	if isTeam and self:GetChatType().cmd == "/g" then
		self:SetChatType(isTeam)
		self.isTeam = nil
	end

	net.Start("SCHat2.Typing")
	net.WriteBool(false)
	net.SendToServer()
end

function PANEL:ChatShow()
	self.Displayed = true

	local textPanel = self.Txt
	textPanel:SetVerticalScrollbarEnabled(true)
	textPanel:ResetAllFades(true, true, -1)

	self:ApplyAlpha()
	self:SetMouseInputEnabled(true)
	self:SetKeyboardInputEnabled(true)
	self.TextEntry:RequestFocus()
	local currentActive = self.pmChatScroller.currentActive
	if currentActive then
		self.Txt:SetVisible(false)
		currentActive[1].isActive = true
		currentActive[2]:SetVisible(true)
	else
		self.Txt:SetVisible(true)
	end
	local text = self.TextEntry:GetValue()
	local chatType = self:GetChatType()
	local cmd = (not chatType.ignore_hook and chatType.cmd) and (chatType.cmd .. " ") or ""
	local textIsCmd = string.sub(text, 1, 1)
	local mapFunc = preffixMap[textIsCmd]
	local real_cmd = mapFunc and mapFunc(text, cmd)
	if real_cmd then
		cmd = ""
	end
	gamemode.Call("ChatTextChanged", cmd .. text)
	gamemode.Call("StartChat")

	net.Start("SCHat2.Typing")
	net.WriteBool(true)
	net.SendToServer()
end

function PANEL:ApplyAlpha()
	if self.Displayed == true then
		self.Alpha = 170
	else
		self.Alpha = 0
	end

	richTextEntryColor.a = self.Alpha

	self.Closer:SetVisible(self.Displayed)
	self.TextEntry:SetVisible(self.Displayed)

	self.chatButton:SetVisible(self.Displayed)
	self.newChatButton:SetVisible(self.Displayed)
	self.changeTypeButton:SetVisible(self.Displayed)
	self.TextActivate:SetVisible(self.Displayed)
	self.pmChatScroller:SetVisible(next(self.pmChatScroller.chats) and self.Displayed)

	for k, v in pairs(self.pmChatScroller.chats) do
		v.panel:SetVisible(self.Displayed)
	end
end

local iconMaterial = Material("icon16/comments.png")
function PANEL:createPrivateMessageTab(sid, name, changeTo)
	local buttonsScroller = self.pmChatScroller
	local chats = buttonsScroller.chats
	if not chats[sid] then

		if changeTo then
			local currentActive = buttonsScroller.currentActive
			if currentActive then
				currentActive[1].isActive = false
				currentActive[2]:SetVisible(false)
			end

			self.Txt:SetVisible(false)

			self.customChatActive = true
			self:SetChatType("/pm")
		end

		surface.SetFont("SChat218")
		local nameW = surface.GetTextSize(name)
		local button = vgui.Create("DButton")
		button:SetWide(nameW + sscale(16) + sscale(30))
		button:SetText("")
		button:SetMaterial(iconMaterial)
		button.sid = sid
		button.DoClick = function(_self)
			_self.isNewMessage = false
			local currentActive = buttonsScroller.currentActive
			if currentActive then
				if currentActive[1] == _self then
					return
				else
					currentActive[1].isActive = false
					currentActive[2]:SetVisible(false)
				end
			end

			self.Txt:SetVisible(false)
			_self.privateText:SetVisible(true)

			self.customChatActive = true
			self:SetChatType("/pm")

			_self.isActive = true
			buttonsScroller.currentActive = {_self, _self.privateText}
		end
		button.DoRightClick = function(_self)
			local dmenu = buildDMenu()

			local isBlocked = SChat2.BlockedUsers[sid]
			local blockedName = isBlocked and "Разблокировать" or "Заблокировать"
			local blockedIcon = isBlocked and "icon16/lock_add.png" or "icon16/lock_delete.png"
			dmenu:AddOption(blockedName, function()
				if not IsValid(_self) then return end

				if isBlocked then
					SChat2.BlockedUsers[sid] = nil
				else
					SChat2.BlockedUsers[sid] = true
				end
			end, blockedIcon)

			dmenu:AddSpacer()
			dmenu:AddOption("", function() end)
			dmenu:AddOption("Открыть профиль", function()
				local _player = player.GetBySteamID(sid)
				if not IsValid(_player) then
					gui.OpenURL("https://steamcommunity.com/profiles/" .. util.SteamIDTo64(sid))
					return
				end

				local _ignore_mask = LocalPlayer():IsNabor() and GetConVar("unionrp_ignore_mask"):GetBool()
				local fake_target = (not _ignore_mask and _player:GetNetVar("FakePlayer")) and table.Random(player.GetAll()) or _player
				fake_target:ShowProfile()
			end, "icon16/world.png")
			dmenu:AddOption("Скопировать SteamID", function()
				if not IsValid(_self) then return end
				SetClipboardText(_self.sid)
			end, "icon16/page_add.png")
			dmenu:AddOption("Закрыть", function()
				if not IsValid(_self) then return end

				local _currentActive = buttonsScroller.currentActive
				if _currentActive and _currentActive[1] == _self then
					buttonsScroller.currentActive = nil
					self.Txt:SetVisible(true)
					self.customChatActive = false
					self:SetChatType("say")
				end

				local _sid = _self.sid
				local deleteChat = chats[_sid]
				if deleteChat then
					deleteChat.panel:Remove()
					deleteChat.privateText:Remove()
					buttonsScroller:InvalidateLayout()
					chats[_sid] = nil
				end
			end, "icon16/cancel.png")
			dmenu:Open(nil, nil, nil, _self)
		end

		local sscale1 = sscale(1)
		local sscale5 = sscale(8)
		button.Paint = function(_self, w ,h)
			-- local col1 = color_orange_darken
			local col2 = color_orange_darken
			if _self:IsHovered() or _self.isActive then
				col2 = color_orange_light
			end
			-- surface.drawGradientPanelBox(_self, 0, 0, w, h, sscale1, col1, col2, col2, col1)
			-- draw.RoundedBox(8, 0, 0, w, h, col2)
			draw.RoundedBoxEx(6, 0, 0, w, h, col2, true, true, false, false)

			if _self.isNewMessage then
				local a = 10 + (math.abs(math.sin(CurTime() * 2)) * 100)
				surface.SetDrawColor(250, 175, 36, a)
				surface.DrawRect(0, sscale1, w, h)
			end

			draw.SimpleText(name, "SChat218", w * 0.5 + sscale5, h * 0.5, color_gray, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		buttonsScroller:AddPanel(button)
		buttonsScroller:ScrollToChild(button)

		local privateText = vgui.Create("RichText", self.bodyPanel)
		privateText:Dock(FILL)
		privateText:InsertColorChange(215, 215, 215, 255)
		privateText:SetBGColor(richTextEntryColor)
		privateText:SetZPos(1)
		privateText.Paint = nil
		privateText.Think = self.Txt.Think
		privateText.PerformLayout = self.Txt.PerformLayout
		button.privateText = privateText
		privateText.privateButton = button

		chats[sid] = {
			panel = button,
			privateText = privateText
		}

		if changeTo then
			button.isActive = true
			buttonsScroller.currentActive = {button, privateText}
			self.TextEntry:RequestFocus()
		else
			privateText:SetVisible(false)
		end
	end
end

local self_color = Color(252, 134, 0)
function PANEL:AddPrivateMessage(sid, targetSid, teamColor, senderName, targetName, messageColor, message)
	local chatSID = sid
	if sid == LocalPlayer():SteamID() then
		teamColor = self_color
		name = "Вы"
		chatSID = targetSid
	else
		targetName = senderName
	end

	local buttonsScroller = self.pmChatScroller
	local chats = buttonsScroller.chats
	local selectedChat = chats[chatSID]
	if not selectedChat then
		self:createPrivateMessageTab(chatSID, targetName)
		selectedChat = chats[chatSID]
	end

	local _currentActive = buttonsScroller.currentActive
	if not _currentActive or _currentActive[1] ~= selectedChat.panel then
		selectedChat.panel.isNewMessage = true
	end
	self:AddNewLine({teamColor, senderName, ": ", messageColor, message}, selectedChat.privateText, true)
end

vgui.Register("SChat2Base", PANEL, "DFrame")
-- if SChat2.Panel and IsValid(SChat2.Panel) then
-- 	 SChat2.Panel:Remove()
-- 	 SChat2.Panel = nil
-- end
-- SChat2.Panel = vgui.Create("SChat2Base")
-- SChat2.Panel:ChatShow()
