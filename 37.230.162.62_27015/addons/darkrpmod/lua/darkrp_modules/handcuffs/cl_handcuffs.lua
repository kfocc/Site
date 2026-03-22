surface.CreateFont("UButton", {
	font = "Arial Black",
	extended = true,
	weight = 300,
	size = 28,
})

local PANEL = {}
AccessorFunc(PANEL, "Text", "Text")
AccessorFunc(PANEL, "Font", "Font")
AccessorFunc(PANEL, "Color", "Color")
AccessorFunc(PANEL, "Sound", "Sound")
AccessorFunc(PANEL, "OldColor", "OldColor")
AccessorFunc(PANEL, "BackgroundColor", "BackgroundColor")
AccessorFunc(PANEL, "Uppercase", "Uppercase")
AccessorFunc(PANEL, "TextAlign", "TextAlign")

function PANEL:Init()
	self:SetColor(COLOR_WHITE)
	self:SetFont("HeaderFont")
	self:SetUppercase(false)
	self:SetBackgroundColor(col.ba)
	self:SetTextAlign(TEXT_ALIGN_LEFT)
end

function PANEL:SetColor(color)
	self:SetOldColor(self:GetColor() or color)
	self.Color = color
end

function PANEL:SetText(text)
	if self:GetUppercase() or string.find(self:GetFont(), "HeaderFont") then text = string.upper(text) end

	self:SetSize(surface.GetTextWidth(text, self:GetFont()))
	self.Text = text
end

function PANEL:Paint()
	draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), self:GetBackgroundColor())
	draw.RoundedBox(0, 0, self:GetTall() - 2, self:GetWide(), 2, col.o)
	self:SetOldColor(LerpColor(0.1, self:GetOldColor(), self:GetColor()))
	surface.DrawShadowText(self:GetText(), self:GetFont(), self:GetWide() / 2, 5, self:GetOldColor(), COLOR_BLACK, TEXT_ALIGN_CENTER)
end

function PANEL:OnCursorEntered()
	self:SetColor(col.o)
	if self:GetSound() then surface.PlaySound(self:GetSound()) end
end

function PANEL:OnMousePressed()
	self.DoClick(self)
end

function PANEL:OnCursorExited()
	self:SetColor(col.w)
end

derma.DefineControl("UButton", "", PANEL)
--[[ Shit ]]
-- A single function to just remove the hooks when the menu is closed (also closes the menu :-) ).
function removeJSHooks()
	-- local ply = LocalPlayer()
	if pnotify then pnotify:Remove() end

	hook.Remove("Think", "JSCloseMenuChecks")
	hook.Remove("Think", "ChangeRestrainText")
	hook.Remove("Think", "ChangeEscortText")
	if main_terminal_menu then main_terminal_menu:Remove() end
end

local function addHooks(hent)
	local ply = LocalPlayer()
	local entperp = hent
	hook.Add("Think", "JSCloseMenuChecks", function()
		if not main_terminal_menu or not IsValid(main_terminal_menu) then removeJSHooks() end
		if not entperp:IsWorld() then if not IsValid(entperp) then removeJSHooks() end end

		-- For some reason, it skips the check above until the second time it runs
		if IsValid(entperp) and entperp:IsPlayer() then
			local dis = ply:GetPos():Distance(entperp:GetPos())
			-- Distance Check
			if dis >= 75 then removeJSHooks() end
		elseif not IsValid(entperp) then
			removeJSHooks()
		end
	end)

	local curtext
	hook.Add("Think", "ChangeEscortText", function()
		local ply = ply or LocalPlayer()
		if not escort or not IsValid(escort) then
			removeJSHooks()
			return
		end

		-- If ply isn't escorting and perp isn't being escorted
		if not entperp:GetNW2Bool("JSEscorted") and not ply:GetNW2Bool("JSEscorting") then
			curtext = "Вести"
		elseif ply:GetNW2Bool("JSEscorting") then
			curtext = "Отпустить"
		else
			curtext = "Ошибка"
		end

		escort:SetText(curtext)
		escort:SetSize(215, 45)
	end)

	local curtext
	hook.Add("Think", "ChangeRestrainText", function()
		if not restrain or not IsValid(restrain) or not IsValid(entperp) then
			removeJSHooks()
			return
		end

		if not entperp:GetNW2Bool("JSRestrained") then
			curtext = "Связать"
		elseif entperp:GetNW2Bool("JSRestrained") then
			curtext = "Развязать"
		end

		restrain:SetText(curtext)
		restrain:SetSize(215, 45)
	end)
end

local cd = 0
local cdTime = 1
hook.Add("PlayerBindPress", "JSOpenMenuBind", function(ply, bind, pressed)
	if bind ~= "gm_showhelp" then return end
	if IsValid(main_terminal_menu) then main_terminal_menu:Remove() end

	ply = LocalPlayer()
	local jobTable = ply:getJobTable()
	if jobTable.nocuffs then return end
	if ply:HasGun() then
		DarkRP.notify(1, 4, "Уберите оружие из рук.")
		return
	end

	local isScreeds
	if not ply:isCP() then
		if ply:CanUseScreeds() then
			isScreeds = true
		else
			return
		end
	end

	local hent
	if ply:GetNW2Bool("JSEscorting", false) then
		hent = ply:GetNWEntity("JSEscortPerp")
	else
		hent = ply:getEyeSightHitEntity(nil, nil, function(p) return p ~= ply and p:IsPlayer() and p:Alive() and p:IsSolid() end)
	end

	if not hent or not IsValid(hent) or not hent:IsPlayer() then return end
	if not hent:Alive() or ply:GetPos():Distance(hent:GetPos()) > 75 then return end
	if hent:getJobTable().nocuffs then return end
	if hent:HasGun() and not jobTable.canCuffWithGun then return end
	main_terminal_menu = vgui.Create("DPanel")
	main_terminal_menu:SetSize(600, 250)
	main_terminal_menu:Center()
	main_terminal_menu:MakePopup()

	main_terminal_menu.Paint = function()
		draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), main_terminal_menu:GetTall(), col.ba)
		draw.RoundedBox(10, 0, 0, main_terminal_menu:GetWide(), 40, col.o)
		draw.RoundedBox(0, 0, 35, main_terminal_menu:GetWide(), 5, col.w)
	end

	local close_button = vgui.Create("MButton", main_terminal_menu)
	close_button:SetText("x")
	close_button:SetPos(main_terminal_menu:GetWide() - 30, 0)
	close_button:OnClick(function() main_terminal_menu:Remove() end)

	local logol = vgui.Create("DImage", main_terminal_menu)
	logol:SetImage("materials/union/logo.png")
	logol:SetSize(36, 36)
	logol:SetPos(0, 0)

	local face = vgui.Create("MLabel", main_terminal_menu)
	local text = isScreeds and "Стяжки" or "CMB.CUFFS #" .. ply:GetID()
	face:SetText(text)
	face:SetPos(logol:GetWide() * 1.5, 0)
	face:SizeToContents()
	face:SetColor(col.w)
	restrain = vgui.Create("UButton", main_terminal_menu)
	restrain:SetFont("UButton")
	restrain:SetText(hent:GetNW2Bool("JSRestrained") and "Развязать" or "Связать")
	restrain:SetSound("UI/buttonrollover.wav")
	restrain:SetSize(215, 45)
	restrain:SetColor(col.w)
	restrain:SetBackgroundColor(col.ba)
	restrain:SetPos(main_terminal_menu:GetWide() / 2 - restrain:GetWide() - 40, 80)

	restrain.DoClick = function(self)
		if cd > CurTime() then return end
		cd = CurTime() + cdTime
		netstream.Start("Handcuffs.Action", hent, "restrain")
	end

	escort = vgui.Create("UButton", main_terminal_menu)
	escort:SetFont("UButton")
	escort:SetText(hent:GetNW2Bool("JSEscorted") and "Отпустить" or "Тащить")
	escort:SetSound("UI/buttonrollover.wav")
	escort:SetSize(215, 45)
	escort:SetColor(col.w)
	escort:SetBackgroundColor(col.ba)
	escort:SetPos(main_terminal_menu:GetWide() / 2 + 40, 80)
	escort.DoClick = function(self)
		if cd > CurTime() then return end
		cd = CurTime() + cdTime
		netstream.Start("Handcuffs.Action", hent, "escort")
	end

	if isScreeds then
		main_terminal_menu:SetSize(600, 170)
	else
		local overlook = vgui.Create("UButton", main_terminal_menu)
		overlook:SetFont("UButton")
		overlook:SetText("Обыскать")
		overlook:SetSound("UI/buttonrollover.wav")
		overlook:SetSize(215, 45)
		overlook:SetColor(col.w)
		overlook:SetBackgroundColor(col.ba)
		overlook:SetPos(main_terminal_menu:GetWide() / 2 - overlook:GetWide() - 40, 160)
		overlook.DoClick = function(self)
			if cd > CurTime() then return end
			cd = CurTime() + cdTime
			netstream.Start("Handcuffs.Action", hent, "lookup")
		end

		local stripguns = vgui.Create("UButton", main_terminal_menu)
		stripguns:SetFont("UButton")
		stripguns:SetText("Конфискация")
		stripguns:SetSound("UI/buttonrollover.wav")
		stripguns:SetSize(215, 45)
		stripguns:SetColor(col.w)
		stripguns:SetBackgroundColor(col.ba)
		stripguns:SetPos(main_terminal_menu:GetWide() / 2 + 40, 160)
		stripguns.DoClick = function(self)
			if cd > CurTime() then return end
			cd = CurTime() + cdTime
			netstream.Start("Handcuffs.Action", hent, "stip")
		end
	end

	addHooks(hent)
end)

function notifyply(message)
	--if !main_terminal_menu or !IsValid(main_terminal_menu) then return end
	if not (not pnotify) then
		curnotify = false
		pnotify:Remove()
	end

	if curnotify == false or curnotify == nil then
		curnotify = true
		timer.Simple(6, function() if curnotify == true then curnotify = false end end)
		pnotify = vgui.Create("DNotify")
		--main_terminal_menu:SetSize(750,200)
		pnotify:SetSize(350, 75)
		pnotify:SetPos(ScrW() - pnotify:GetWide(), pnotify:GetTall() / 2)
		local mainbar = vgui.Create("DPanel", pnotify)
		mainbar:SetSize(pnotify:GetWide(), pnotify:GetTall())
		mainbar:SetBackgroundColor(col.ba)
		mainbar:SetPos(0, 0)
		local titlebar = vgui.Create("DPanel", mainbar)
		titlebar:SetSize(pnotify:GetWide(), 25)
		titlebar:SetBackgroundColor(col.o)
		titlebar:SetPos(0, 0)
		local ntitle = vgui.Create("DLabel", titlebar)
		ntitle:SetSize(pnotify:GetWide(), 25)
		ntitle:SetText("Оповещение")
		ntitle:SetColor(col.w)
		ntitle:SetFont("Trebuchet24")
		ntitle:SetPos(4, 1)
		local nmess = vgui.Create("DLabel", mainbar)
		nmess:SetSize(pnotify:GetWide(), 50)
		nmess:SetPos(5, 25)
		nmess:SetFont("CloseCaption_Normal")
		nmess:SetColor(col.w)
		nmess:SetText(message)
		pnotify:AddItem(mainbar)
	end
end

local acts = {
	["lookup"] = function(ply, weapon_table, pocket_table)
		chat.AddText(col.o, "\nСписок нелегала у " .. ply:Name())
		for k, v in ipairs(weapon_table) do
			chat.AddText(col.o, v)
		end

		if #pocket_table == 0 then
			chat.AddText(col.o, "Сумка пуста")
			return
		end

		chat.AddText(col.o, "Предметы в сумке:")
		for k, v in ipairs(pocket_table) do
			chat.AddText(col.o, v)
		end
	end,
	["notify"] = function(ply, text) notifyply(text) end
}

netstream.Hook("Handcuffs.Action", function(act, ply, ...)
	if not acts[act] then return end
	acts[act](ply, ...)
end)

local text1 = "Вы в наручниках"
local text2 = "Вы связаны"
hook.Add("HUDPaint", "handcuffs.HUD", function()
	local ply = LocalPlayer()
	if ply:GetNW2Bool("JSRestrained") then

		surface.SetFont("UnionHUD30")
		surface.SetDrawColor(col.o)
		local text = ply:GetNetVar("JSRestrained.Screeds") and text2 or text1
		local tw = surface.GetTextSize(text)
		local uw, uh = tw + 10
		local x, y = ScrW() - uw, ScrH() * 0.07
		draw.SimpleText(text, "UnionHUD30", x + 5, y + 3, col.w)

		if not ply:GetNW2Bool("JSEscorted") then
			local handcuff_timer = ply:GetNetVar("HandCuffTimer", 0)
			local cur = CurTime()
			local reload_bind = string.upper(input.LookupBinding("+reload") or "NO_BIND")
			local uncuff_text = "[" .. reload_bind .. "] Вы можете вырваться"
			if handcuff_timer > cur then
				local outTime = math.ceil(handcuff_timer - cur)
				uncuff_text = "[" .. reload_bind .. "] Возможность вырваться через: " .. string.FormattedTime(outTime, "%02i:%02i")
			end

			uw, uh = surface.GetTextSize(uncuff_text)
			uw = uw + 10
			x, y = ScrW() - uw, y + uh
			draw.SimpleText(uncuff_text, "UnionHUD30", x + 5, y + 3, col.w)
		end
	end
end)
