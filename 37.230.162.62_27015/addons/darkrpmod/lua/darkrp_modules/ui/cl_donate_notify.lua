local color_b = Color(15, 15, 15, 244)
local color_o = Color(216, 101, 74)
local color_line = Color(200, 200, 200, 155)
surface.CreateFont("donate.Notify", {
	font = "Inter",
	size = 20,
	weight = 500,
	extended = true,
})

surface.CreateFont("donate.Notify.button", {
	font = "Inter",
	size = 20,
	weight = 500,
	extended = true,
})

local salesData = _G.salesData or {}
_G.salesData = salesData

local function checkTextSize(text, currentW, currentH)
	local _w, _h = util.GetTextSize(text, "donate.Notify")
	_h = _h + 10
	if _w > currentW then currentW = _w + 80 end
	if currentH then currentH = currentH + _h end
	return currentW, currentH
end

local function createDonateNotifyMenu(title, footer, body)
	gui.EnableScreenClicker(true)

	local w, h = ScrW(), ScrH()
	input.SetCursorPos(w * 0.5, h * 0.62)

	local maxBodyW, maxBodyH = 550, 170
	maxBodyW = checkTextSize(title, maxBodyW)
	maxBodyW = checkTextSize(footer, maxBodyW)
	for i = 1, #body do
		maxBodyW, maxBodyH = checkTextSize(body[i][2], maxBodyW, maxBodyH)
	end

	local panelW, panelH = util.ScreenScale(maxBodyW), util.ScreenScale(maxBodyH)
	local main = vgui.Create("DFrame")
	main:SetSize(panelW, panelH)
	main:SetAlpha(0)
	main:AlphaTo(255, 1, 0)
	-- main:SetPos(-panelW, h * 0.5 - panelH * 0.5)
	main:Center()
	main:SetTitle("")
	main:SetDraggable(false)
	main:MakePopup()
	main:ShowCloseButton(false)
	-- main:SetDeleteOnClose(false)
	-- main:MoveTo((w * 0.5) - (panelW * 0.5), (h * 0.5) - (panelH * 0.5), 1, 0, -1)

	local upperSize = util.ScreenScale(20)
	main.Paint = function(self, _w, _h)
		draw.RoundedBox(0, 0, 0, _w, _h, color_b)
		draw.RoundedBox(0, 0, 0, _w, upperSize, color_o)
	end

	local dp = main:Add("DPanel")
	dp:Dock(FILL)
	local lineSize = util.ScreenScale(2)
	local skipSize = util.ScreenScale(10)
	dp.Paint = function(_self, _w, _h)
		local _tw, _th = draw.SimpleTextOutlined(title, "donate.Notify", _w * 0.5, _h * 0.025, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black)
		local lineH = _h * 0.025 + lineSize + _th + skipSize

		surface.DrawLine(0, lineH, w, lineH)
		lineH = lineH + skipSize

		_tw, _th = draw.SimpleTextOutlined(footer, "donate.Notify", _w * 0.5, lineH, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black)
		lineH = lineH + lineSize + _th + skipSize

		surface.DrawLine(0, lineH, w, lineH)
		lineH = lineH + lineSize + skipSize

		for i = 1, #body do
			local v = body[i]
			local text, icon = v[2], v[1]
			_tw, _th = draw.SimpleTextOutlined(text, "donate.Notify", _w * 0.5, lineH, color_white, TEXT_ALIGN_CENTER, nil, 1, color_black)

			if icon then
				surface.SetDrawColor(255, 255, 255, 255)
				surface.SetMaterial(icon)
				surface.DrawTexturedRect(_w * 0.5 - 20 - _tw * 0.5, lineH + 4, 16, 16)
			end

			lineH = lineH + _th + skipSize
		end
	end

	local bottomPanel = main:Add("DPanel")
	bottomPanel:Dock(BOTTOM)
	bottomPanel:SetTall(util.ScreenScale(35))
	bottomPanel.Paint = function(self, w, h)
		surface.SetDrawColor(color_line)
		surface.DrawLine(0, lineSize, w, lineSize)
	end

	local buttonSize = util.ScreenScale(170)
	local cb = bottomPanel:Add("DButton")
	cb:Dock(FILL)
	cb:DockMargin(buttonSize, util.ScreenScale(6), buttonSize, 0)

	cb:SetFont("donate.Notify.button")
	cb:SetTextColor(color_white)
	cb:SetText("Закрыть")
	cb.DoClick = function(_self)
		-- main:Close()
		main:AlphaTo(0, 0.3, 0, function()
			main:Remove()
			gui.EnableScreenClicker(false)
		end)

		surface.PlaySound("UI/buttonclickrelease.wav")
	end

	cb.Paint = function(self, w, h)
		local col = col.o
		if self:IsDown() then col = col:darken(30) end
		if self.entered and not self:IsDown() then col = col:lighten(30) end
		draw.RoundedBox(2, 0, 0, w, h, col)
	end

	cb.OnCursorEntered = function(self) if not self.entered then self.entered = true end end
	cb.OnCursorExited = function(self) if self.entered then self.entered = nil end end
end

local needToShow = false
local function showDonateNotifyMenu()
	needToShow = false

	if salesData.only_one_show_per_day then
		local currentDate = os.date("%d%m%Y", os.time())
		local isShowed = cookie.GetString("union_donate_notify") == currentDate
		if not isShowed then
			createDonateNotifyMenu(salesData.title, salesData.footer, salesData.body)
			cookie.Set("union_donate_notify", currentDate)
		end
	else
		createDonateNotifyMenu(salesData.title, salesData.footer, salesData.body)
	end
end

hook.Add("IntroPressed", "donateNotifyShow", function()
	if table.IsEmpty(salesData) then
		needToShow = true
	else
		showDonateNotifyMenu()
	end
end)

netstream.Hook("sendSalesInfo", function(data)
	for k, v in ipairs(data.body) do
		if v[1] then v[1] = Material(v[1]) end
	end

	table.Merge(salesData, data)
	if needToShow then showDonateNotifyMenu() end
end)
