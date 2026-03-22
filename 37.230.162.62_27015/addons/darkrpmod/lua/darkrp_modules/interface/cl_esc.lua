local PANEL = {}

local function createFont(name, data, blursize)
  surface.CreateFont(name, data)

  if blursize then
    data.blursize = blursize
    surface.CreateFont(name .. "Blur", data)
  end
end

createFont("ESCMenuTitle", {
  font = "Inter Light",
  size = 116,
  weight = 300,
  extended = true
}, 4)

createFont("ESCMenuSubTitle1", {
  font = "Inter Medium",
  size = 19,
  weight = 700,
  extended = true
}, 4)
createFont("ESCMenuSubTitle2", {
  font = "Inter Medium",
  size = 15,
  weight = 700,
  extended = true
}, 4)

createFont("ESCMenuButton", {
  font = "Inter",
  size = 36,
  weight = 500,
  extended = true
}, 4)

createFont("ESCMenuSidebarText", {
  font = "Inter Medium",
  size = 18,
  weight = 500,
  extended = true
}, 4)

createFont("ESCMenuCrashscreenTitle", {
  font = "Inter Bold",
  size = 32,
  weight = 500,
  extended = true
}, 4)

createFont("ESCMenuCrashscreenText", {
  font = "Inter Medium",
  size = 24,
  weight = 500,
  extended = true
}, 4)

function PANEL.drawLabel(text, font, fontShadow, x, y, color, align_x, align_y)
  surface.SetFont(font)
  local w, h = surface.GetTextSize(text)
  x, y = x - w * align_x, y - h * align_y

  surface.SetTextPos(x + 1, y + 1)
  surface.SetFont(fontShadow)
  surface.SetTextColor(0, 0, 0)
  surface.DrawText(text)
  surface.SetTextPos(x - 1, y - 1)
  surface.DrawText(text)

  surface.SetTextPos(x, y)
  surface.SetFont(font)
  surface.SetTextColor(color.r, color.g, color.b, color.a)
  surface.DrawText(text)

  return w, h
end

local function buttonPaint(self, w, h)
  self._targetAlpha = self:IsHovered() and 1 or 0
  self._currectAlpha = Lerp(FrameTime() * 6, self._currectAlpha or 0, self._targetAlpha)
  local frac = self._currectAlpha

  surface.SetAlphaMultiplier(frac * 0.5)
  surface.SetDrawColor(0, 0, 0, 255)
  surface.DrawRect(0, 0, w, h)
  surface.SetAlphaMultiplier(frac * 0.9 + 0.1)

  surface.SetDrawColor(Lerp(frac, 255, col.o.r), Lerp(frac, 255, col.o.g), Lerp(frac, 255, col.o.b), 255)
  surface.DrawRect(0, 0, 4, h)

  surface.SetAlphaMultiplier(frac * 0.2 + 0.8)
  PANEL.drawLabel(self:GetText(), "ESCMenuButton", "ESCMenuButtonBlur", 16, h / 2, color_white, 0, 0.5)

  return true
end

local tick = 0
local color1, color2 = Color(0, 0, 0, 255 * 0.6), Color(0, 0, 0, 0)
function PANEL.drawBackground(w, h)
  if tick == FrameNumber() then return end
  tick = FrameNumber()
  surface.drawGradientBox(0, 0, w * 0.5, h, 0, color2, color1)
  surface.drawGradientBox(0, 0, w * 0.33, h, 0, color2, color1)

  surface.SetFont("ESCMenuTitle")
  local wide, tall = surface.GetTextSize("U N I O N")
  local x, y = wide / 2 + 64, 98
  PANEL.drawLabel("H     λ     L     F    –    L     I     F     E", "ESCMenuSubTitle1", "ESCMenuSubTitle1Blur", x - 5, y + 9, col.w, 0.5, 1)
  PANEL.drawLabel("U N I O N", "ESCMenuTitle", "ESCMenuTitleBlur", x, y, col.o, 0.5, 0)
  PANEL.drawLabel("R    O    L    E    P    L    A    Y", "ESCMenuSubTitle2", "ESCMenuSubTitle2Blur", x, y + tall - 11, col.w, 0.5, 0)
end

AccessorFunc(PANEL, "m_iFlags", "Flags", FORCE_NUMBER)

function PANEL:Init()
  local sidebar = vgui.Create("EditablePanel", self)
  sidebar:DockMargin(64, 256, 0, 64)
  sidebar:Dock(LEFT)
  self.Sidebar = sidebar

  sidebar.resume = self:AddButton("Продолжить", function(self) ESCMenu:Hide() RunConsoleCommand( "gamemenucommand", "ResumeGame" ) end)
  sidebar.settings = self:AddButton("Настройки", function(self) ESCMenu:Hide() gui.ActivateGameUI() RunConsoleCommand( "gamemenucommand", "OpenOptionsDialog" ) end)

  sidebar.quit = self:AddButton("Выйти", function() RunConsoleCommand( "gamemenucommand", "Quit" ) end)
  sidebar.quit:Dock(BOTTOM)

  sidebar.disconnect = self:AddButton("Отключиться", function() RunConsoleCommand( "gamemenucommand", "Disconnect" ) end)
  sidebar.disconnect:Dock(BOTTOM)

  sidebar.retry = self:AddButton("Перезайти сейчас", function() RunConsoleCommand( "retry" ) end)
  sidebar.retry:Dock(BOTTOM)

  local timer = self.Sidebar:Add("EditablePanel")
  timer:Dock(BOTTOM)
  timer:SetTall(20)
  timer:DockMargin(0, 0, 0, 8)
  function timer:Paint(w, h)
    local _, time = GetTimeoutInfo()
    PANEL.drawLabel("ПЕРЕПОДКЛЮЧЕНИЕ ЧЕРЕЗ " .. math.max(math.ceil(aCrashScreen.config.reconnectingTime - time), 0) .. " СЕКУНД", "ESCMenuSidebarText", "ESCMenuSidebarTextBlur", 16, 0, col.o, 0, 0)
  end
  sidebar.timer = timer

  self.m_iFlags = 0
end

function PANEL:SetFlags(val)
  self.m_iFlags = val
  /*if val == 0 then
    self:Remove()
  end*/

  if bit.band(val, 2^3) > 0 and not self.News then
    local edit = vgui.Create("EditablePanel", self)
    edit:SetSize( 428, 512 )
    self.News = edit

    local tg = vgui.Create("HTML", edit)
    tg:SetHTML([[<style type="text/css">*{padding:0px;margin:0px;overflow:hidden;border:0px;}</style><iframe id="preview" style="height:100%;width:100%;" src="https://xn--r1a.website/s/thehubclick"></iframe>]])
    tg:SetSize( 428 + 16, 512 )

    function edit:Paint(w, h)
      surface.SetDrawColor(0, 0, 0, 255 * 0.75  ^ (1 / 2.2))
      surface.DrawRect(0, 0, w, h)
    end

    function edit:PaintOver(w, h)
      surface.SetDrawColor(col.o)
      surface.DrawOutlinedRect(0, 0, w, h, 1)
    end
  end

  if bit.band(val, 2^1) > 0 then
    self.Sidebar.resume:Show()
    self.Sidebar.settings:Show()
  else
    self.Sidebar.resume:Hide()
    self.Sidebar.settings:Hide()
  end

  if bit.band(val, 2^2) > 0 then
    self.Sidebar.retry:Show()
    self.Sidebar.timer:Show()
  else
    self.Sidebar.retry:Hide()
    self.Sidebar.timer:Hide()
  end
end

function PANEL:Paint(w, h)
  PANEL.drawBackground(w, h)

  if bit.band(self.m_iFlags, 2^2) == 2^2 then
    local x, y = w / 2, h * 0.41
    local tw, th = PANEL.drawLabel("СЕРВЕР НЕ ОТВЕЧАЕТ ИЛИ ПЕРЕЗАГРУЖАЕТСЯ!", "ESCMenuCrashscreenTitle", "ESCMenuCrashscreenTitleBlur", x, y, col.w, 0.5, 0)
    y = y + th + 8
    surface.SetDrawColor(col.o)
    surface.DrawRect(x - 256, y, 512, 4)
    y = y + 4 + 12
    surface.SetAlphaMultiplier(0.8 ^ 2.2)
    tw, th = PANEL.drawLabel("В СЛУЧАЕ ПЕРЕЗАГРУЗКИ СЕРВЕРА ВАМ БУДУТ ВОЗВРАЩЕНЫ:", "ESCMenuCrashscreenText", "ESCMenuCrashscreenTextBlur", x, y, col.w, 0.5, 0)
    y = y + th
    tw, th = PANEL.drawLabel("ТОКЕНЫ ЗА ПРИНТЕРЫ, ВАША ПРОФЕССИЯ, ОРУЖИЕ И ПРОПЫ", "ESCMenuCrashscreenText", "ESCMenuCrashscreenTextBlur", x, y, col.w, 0.5, 0)
    surface.SetAlphaMultiplier(1)
  end
end

function PANEL:AddButton(text, func)
  local button = vgui.Create("DButton", self.Sidebar)
  button:SetText(utf8.upper(text))
  button:SetFont("ESCMenuButton")
  button:SetTextColor(color_white)
  button:SetContentAlignment(4)
  button:SetTextInset(16, 0)
  button:SetTall(52)
  button:Dock(TOP)
  button:DockMargin(0, 0, 0, 8)
  button.DoClick = function()
		surface.PlaySound( "garrysmod/ui_click.wav" )
		if func then
			func()
		end
	end
	button.OnCursorEntered = function(self)
		surface.PlaySound( "garrysmod/ui_hover.wav" )
		DButton.OnCursorEntered(self)
	end
  button.Paint = buttonPaint
  return button
end

function PANEL:OnRemove()
  hook.Remove("HUDPaint", "ESCMenu")
  hook.Remove("Think", "ESCMenu")
end

function PANEL:AnimationThink()
  self:SetVisible(not gui.IsGameUIVisible())

  self:AnimationThinkInternal()
end

function PANEL:PerformLayout(w, h)
  surface.SetFont("ESCMenuTitle")
  local wide = surface.GetTextSize("U N I O N")
  self.Sidebar:SetWide(wide)

  if self.News then
    if bit.band(self.m_iFlags, 2^3) > 0 then
      self.News:SetPos( w - self.News:GetWide() - 64, 64 )
      self.News:Show()
    else
      self.News:Hide()
    end
  end
end

function PANEL:OnScreenSizeChanged(oldW, oldH, w, h)
  self:PerformLayout(w, h)
end

vgui.Register("ESCMenu", PANEL, "EditablePanel")

if IsValid(ESCMenu) then
  ESCMenu:Remove()
end
hook.Add("OnPauseMenuShow", "ESCMenu", function()
  if IsValid(ESCMenu) then
		if ESCMenu:IsVisible() then
			ESCMenu:SetFlags(bit.band(ESCMenu:GetFlags(), bit.bnot(2^1)))
		else
			ESCMenu:SetFlags(bit.bor(ESCMenu:GetFlags(), 2^1))
		end
    if bit.band(ESCMenu:GetFlags(), 2^0) == 0 then
      ESCMenu:ToggleVisible()
    end
    return false
  end
end, HOOK_LOW)

hook.Add("HUDShouldDraw", "ESCMenu", function(name)
  if name == "UnionHUD" and ESCMenu and ESCMenu:IsVisible() then
    return false
  end
end)

do
	local PANEL = FindMetaTable("Panel")
	local closeMenus = setmetatable({}, {__mode = "kv"})
	function PANEL:CloseOnEscape()
		closeMenus[self] = true
	end

	hook.Add("OnPauseMenuShow", "ClosePanels", function()
		local closed = false
		for k, v in pairs(closeMenus) do
			if IsValid(k) then
				local func = k.Close or k.Remove
				if func then
					func(k)
					closed = true
				end
			end
			closeMenus[k] = nil
		end

		if closed then
			return false
		end
	end)
end

if IsValid(ESCMenu) then
  ESCMenu:Remove()
end
ESCMenu = vgui.Create("ESCMenu")
ESCMenu:SetSize(ScrW(), ScrH())
ESCMenu:MakePopup()
ESCMenu:InvalidateChildren(true)
ESCMenu:SetVisible(false)
