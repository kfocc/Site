-- fonts stuff
local ss = util.SScale
do

	surface.CreateFont("UnionHUD25", {
		font = "Inter",
		size = ss(23),
		weight = 400,
		extended = true
	})

	surface.CreateFont("UnionHUD30", {
		font = "Inter",
		size = ss(30),
		weight = 500,
		extended = true
	})

	surface.CreateFont("UnionHUDO50", {
		font = "Inter",
		size = ss(50),
		weight = 900,
		extended = true
	})

	surface.CreateFont('HUDEHL2FontIcons', {
		font = 'HalfLife2',
		size = ss(10),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUDEHL2FontLittle", {
		font = "Inter",
		dc = false,
		size = ss(16),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUDEHL2FontSmall", {
		font = "Inter",
		dc = false,
		size = ss(20),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUDEHL2FontLarge", {
		font = "Inter",
		dc = false,
		size = ss(52),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUDEHL2FontMiddle", {
		font = "Inter",
		dc = false,
		size = ss(28),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUD_Font15", {
		font = "Inter",
		size = ss(20),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUD_Font1", {
		font = "Inter",
		size = ss(20),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUD_Font2", {
		font = "Inter",
		size = ss(35),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("HUD_Font3", {
		font = "Inter",
		size = ss(28),
		weight = 500,
		extended = true,
	})

	surface.CreateFont("CP_HUD_Font1", {
		font = "Inter",
		size = ss(28),
		weight = 500,
		extended = true,
	})
end

local hideHUD = {
	["DarkRP_HUD"] = true,
	["DarkRP_ChatReceivers"] = true,
	["DarkRP_EntityDisplay"] = false,
	["DarkRP_ZombieInfo"] = true,
	["DarkRP_LocalPlayerHUD"] = true,
	["DarkRP_Hungermod"] = true,
	["DarkRP_Agenda"] = true,
	["DarkRP_LockdownHUD"] = true,
	["DarkRP_ArrestedHUD"] = true,
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudBattery"] = true,
	["CHudDamageIndicator"] = true,
	["CHUDAutoAim"] = true
}

hook.Add("HUDShouldDraw", "HideHUD", function(name) if hideHUD[name] then return false end end)
local function GetEntityOwner()
	local txt = ""
	local lp = LocalPlayer()
	if not cl_PProtect.Settings.Propprotection["enabled"] or not cl_PProtect.Settings.CSettings["ownerhud"] then return end
	local ent = lp:GetEyeTrace().Entity
	if not ent or not ent:IsValid() or ent:IsWorld() or ent:IsPlayer() then return end
	local Owner = ent:CPPIGetOwner()
	if not Owner then return end
	if IsValid(Owner) and Owner:IsPlayer() then
		txt = Owner:Nick()
	else
		txt = "вышел."
	end
	return txt or "UNKNOWN", IsValid(Owner) and Owner:IsPlayer() and Owner
end

local function GetTimeText()
	local time = StormFox2.Time.Get()
	local hr = math.floor(time / 60)
	local min = math.floor(time % 60)
	local text
	if min < 10 then min = "0" .. min end
	text = hr .. ":" .. min .. " | " .. weeks.GetName()
	return text
end

local function barCalculateLerp(num, numTo, numMax)
	-- num = math.Approach(num or 1, math.Clamp(numTo, 0, numMax), FrameTime() * 25)
	num = Lerp(FrameTime() * 5, num or 1, math.Clamp(numTo, 0, numMax))
	return num
end

local function barCalculatePercent(num, numMax)
	num = num / numMax
	num = math.Clamp(num, 0, numMax)
	return num
end

local heart = Material("materials/union/hp.png", "no smooth")
local burger = Material("materials/union/hunger.png", "no smooth")
local shields = Material("materials/union/shield_full.png", "no smooth")
local energy = Material("icons/fa32/battery.png", "no smooth")
local smootha, smoothh, smoothp, smoothammo, smoothe = 0, 0, 0, 0, 0
local showtime = CreateClientConVar("unionrp_time", "1", true, false)
local Union_hud_accurate = CreateClientConVar("Union_hud_accurate", 0, true, "Отображать точные значения")
local powerHud
do
	local function drawText(text, font, x, y, color, alignx, aligny)
		draw.SimpleText(text, font, x + 1, y + 1, col.ba, alignx, aligny)
		draw.SimpleText(text, font, x, y, color, alignx, aligny)
	end

	local iconSize = ss(48)
	local function drawIcon(mat, x, y, color)
		surface.SetDrawColor(col.ba)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(x + 1, y + 1, iconSize, iconSize)
		surface.SetDrawColor(color)
		surface.SetMaterial(mat)
		surface.DrawTexturedRect(x, y, iconSize, iconSize)
	end

	local hudFont = "HUDEHL2FontLarge"
	local px2 = ss(2)
	local function drawBar(x, y, icon, text, color)
		drawIcon(icon, x, y + px2, color)
		drawText(math.Round(text), hudFont, x + iconSize, y, color, TEXT_ALIGN_LEFT)
	end

	local mainColor = col.o
	local lowHPColor = col.r
	local visorHP = Material("vgui/visor/health.png")
	local visorAP = Material("vgui/visor/armor.png")

	local leftStep = ss(40)
	function powerHud()
		local ply = LocalPlayer()
		if not ply:IsValid() or not ply:Alive() then return end
		local w, h = ScrW(), ScrH()
		local x, y = leftStep, h * 0.93

		local accurate = Union_hud_accurate:GetBool()
		local hp, maxHP = ply:Health(), ply:GetMaxHealth()
		local resHP = barCalculatePercent(hp, maxHP) * 100
		drawBar(x, y, visorHP, accurate and hp or resHP, Either(resHP > 50, mainColor, lowHPColor))

		local ap = ply:Armor()
		if ap > 0 then
			local maxAP = ply:GetMaxArmor()
			maxAP = maxAP ~= 0 and maxAP or 100
			local resAP = barCalculatePercent(ap, maxAP) * 100
			x = x + leftStep * 5
			drawBar(x, y, visorAP, accurate and ap or resAP, Either(resAP > 50, mainColor, lowHPColor))
		end

		local wep = ply:GetActiveWeapon()
		if IsValid(wep) and not ply:InVehicle() then
			local primaryType = wep:GetPrimaryAmmoType()
			local secondaryType = wep:GetSecondaryAmmoType()
			local clip = wep:Clip1()
			local text = clip .. " / " .. ply:GetAmmoCount(primaryType)
			local color = (ply:GetAmmoCount(primaryType) <= 0 and ply:GetAmmoCount(secondaryType) <= 0) and col.r or col.o

			x = w * 0.9
			if primaryType > -1 then drawText(text, hudFont, x, y, color, TEXT_ALIGN_CENTER) end
		end

		local money = ply:getDarkRPVar("money")
		drawText(DarkRP.formatMoney(money), hudFont, w * 0.5, y, mainColor, TEXT_ALIGN_CENTER)
	end
end

local hud = {}

local hudColor = {
	bgBar = Color(15, 15, 15, 100),
	bgGray = Color(75, 75, 75),
	bgLightGray = Color(124, 124, 124),
	armor = Color(0, 138, 255),
	hp = Color(216, 101, 74),
	energy = Color(255, 138, 0),
	bgDark = Color(0, 0, 0, 55)
}

local bgBoxSizeX, bgBoxSizeY = ss(350), ss(40)
local iconSize = ss(32)
local sizeLine, stepSize, stepYSize, stepRectSize = ss(5), ss(55), ss(10), ss(6)
do
	local maxTextLine, minTextLine = ss(330), ss(350 * 0.6)
	if ScrW() / ScrH() <= 1.35 then
		bgBoxSizeX = bgBoxSizeX * .8
		maxTextLine = maxTextLine * .8
		minTextLine = minTextLine * .8
	end

	function hud.drawBar(x, y, value, percent, text1, icon, color, accurate)
		draw.RoundedBox(0, x, y, bgBoxSizeX, bgBoxSizeY, hudColor.bgBar)

		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(icon)
		surface.DrawTexturedRect(x + stepYSize, y + stepRectSize, iconSize, iconSize)

		draw.RoundedBox(0, x, y + bgBoxSizeY, bgBoxSizeX, sizeLine, hudColor.bgGray)
		draw.RoundedBox(0, x, y + bgBoxSizeY, math.Clamp(bgBoxSizeX * percent, 0, bgBoxSizeX), sizeLine, color)

		draw.SimpleText(text1, "HUD_Font1", x + stepSize, y + stepYSize, color_white)

		percent = math.Round(percent * 100)
		draw.SimpleText(accurate and math.Round(value) or percent .. "%", "HUD_Font15", math.Clamp(bgBoxSizeX * percent, minTextLine, maxTextLine), y + stepYSize, color)
	end
end

do
	local mainBoxSize = ss(304)
	local linePixels1 = ss(1)
	local linePixels2 = ss(2)
	local linePixels3 = ss(3)
	local linePixels4 = ss(4)
	local linePixels6 = ss(6)
	local linePixels9 = ss(9)
	local ammoBoxSize = ss(300)
	local secondBoxSize = ss(100)
	local bgBoxSize = ss(50)
	local ammoStepNameX = ss(152)
	local ammoStepAmmoX = ss(147)
	local ammoStepMaxAmmoX = ss(155)
	local ammoStepNameY = ss(20)
	local ammoStepAmmoY = ss(7)
	local ammoStepMaxAmmoY = ss(10)
	local twoStepSize = ss(2)
	-- local
	function hud.drawWeaponBar(x, y, ammo, maxClip, percent, ammotype, wepname)
		x = x - mainBoxSize * 0.5

		draw.RoundedBox(0, x, y, mainBoxSize, linePixels1, hudColor.bgLightGray)
		draw.RoundedBox(0, x, y + linePixels9, mainBoxSize, linePixels1, hudColor.bgLightGray)

		local ly = y - linePixels4
		draw.RoundedBox(0, x, ly, secondBoxSize, linePixels2, hudColor.bgLightGray)
		ly = y - 7

		draw.RoundedBox(0, x, ly, bgBoxSize, linePixels3, hudColor.bgLightGray)

		local rx = x + mainBoxSize - secondBoxSize
		local ry = y - linePixels4
		draw.RoundedBox(0, rx, ry, secondBoxSize, linePixels2, hudColor.bgLightGray)

		ry = y - 7
		rx = x + mainBoxSize - bgBoxSize
		draw.RoundedBox(0, rx, ry, bgBoxSize, linePixels3, hudColor.bgLightGray)
		draw.RoundedBox(0, x, y + twoStepSize, mainBoxSize, linePixels6, hudColor.bgDark)

		-- print(ammo, maxClip)
		if ammo ~= -1 and (maxClip ~= -1 and maxClip ~= 0) then
			draw.RoundedBox(0, x + twoStepSize, y + twoStepSize, math.Clamp(ammoBoxSize * percent, 0, ammoBoxSize), linePixels6, hudColor.hp)
		else
			draw.RoundedBox(0, x + twoStepSize, y + twoStepSize, ammoBoxSize, linePixels6, hudColor.hp)
		end

		draw.SimpleText(wepname, "HUD_Font15", x + ammoStepNameX, ry - ammoStepNameY, color_white, TEXT_ALIGN_CENTER)
		if ammotype >= 0 then
			local maxammo = LocalPlayer():GetAmmoCount(ammotype)
			draw.SimpleText(ammo, "HUD_Font2", x + ammoStepAmmoX, y + ammoStepAmmoY, hudColor.hp, TEXT_ALIGN_RIGHT)
			draw.SimpleText(maxammo, "HUD_Font3", x + ammoStepMaxAmmoX, y + ammoStepMaxAmmoY, hudColor.bgLightGray, TEXT_ALIGN_LEFT)
		end
	end
end

do
	local mainBoxSize = ss(480)
	local mainBoxSizeY = ss(55)
	local mainLineSize = ss(240)
	local halfBoxSize = mainBoxSize * 0.5
	local halfBoxSizeY = mainBoxSizeY * 0.5

	local doubleMainLineSize = ss(60)
	local px1 = ss(1)
	local px2 = ss(2)
	local px6 = ss(6)
	local pxMainLines = ss(29)
	local stepName = ss(6)
	local stepJob = ss(30)
	function hud.drawMainInfo(x, y, job, tColor, name, money, cid)
		local lx = x - halfBoxSize
		draw.RoundedBox(0, lx, y, mainBoxSize, mainBoxSizeY, hudColor.bgBar)

		local ly = y + halfBoxSizeY
		lx = lx + halfBoxSize * 0.5
		draw.RoundedBox(0, lx, ly, mainLineSize, px1, hudColor.bgLightGray)

		draw.RoundedBox(0, lx, ly, px1, px6, hudColor.bgLightGray)
		draw.RoundedBox(0, lx + mainLineSize, ly, px1, px6, hudColor.bgLightGray)

		local halfMainLineSize = mainLineSize * 0.5
		local lLineX = x - doubleMainLineSize - halfMainLineSize - pxMainLines
		local rLineX = x + halfMainLineSize + pxMainLines
		draw.RoundedBox(0, lLineX, ly, doubleMainLineSize, px2, hudColor.bgLightGray)
		draw.RoundedBox(0, rLineX, ly, doubleMainLineSize, px2, hudColor.bgLightGray)

		draw.SimpleText(name, "HUD_Font1", x, y + stepName, color_white, TEXT_ALIGN_CENTER)

		draw.SimpleText(job, "HUD_Font1", x, y + stepJob, tColor, TEXT_ALIGN_CENTER)

		draw.SimpleText("ТОКЕНЫ", "HUD_Font1", lLineX + pxMainLines, y + stepName, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText(money, "HUD_Font1", lLineX + pxMainLines, y + stepJob, color_white, TEXT_ALIGN_CENTER)

		draw.SimpleText("CID", "HUD_Font1", rLineX + pxMainLines, y + stepName, color_white, TEXT_ALIGN_CENTER)
		draw.SimpleText("#" .. cid, "HUD_Font1", rLineX + pxMainLines, y + stepJob, color_white, TEXT_ALIGN_CENTER)
	end
end

local sStepSize = ss(10)
local restartText = "Рестарт через: %02d:%02d."
local function drawMainHUD()
	if not introPressed then return end
	local lp = LocalPlayer()
	local hidden_info
	if not IsValid(lp) or lp.disabledhud then return end
	local ret = hook.Call("HUDShouldDraw", GAMEMODE, "UnionHUD")
	if ret == false then return end
	if lp:GetObserverMode() == OBS_MODE_IN_EYE then
		local target = lp:GetObserverTarget()
		if IsValid(target) and target:IsPlayer() then
			lp = target
			hidden_info = true
		end
	end

	do
		local plannedRestart = netvars.GetNetVar("plannedRestart")
		if not plannedRestart then
			local text = os.date("!%H:%M - %d/%m/%Y", os.time() + 10800)
			surface.SetFont("UnionHUD30")
			local w = surface.GetTextSize(text)
			local uw = w + 10
			local x, y = ScrW() - uw, ScrH() * 0.02
			surface.SetDrawColor(col.o)
			-- surface.DrawOutlinedRect(x, y, uw, 35)
			-- draw.RoundedBox(0, x, y, uw, 35, col.ba)
			draw.SimpleText(text, "UnionHUD30", x + 5, y + 3, col.w)
		elseif plannedRestart and plannedRestart >= CurTime() then
			plannedRestart = plannedRestart - CurTime()
			local sec = math.floor(math.fmod(plannedRestart, 60))
			local min = math.floor(math.fmod(plannedRestart, 3600) / 60)
			local uw = 105
			local text = restartText:format(min, sec)
			surface.SetFont("HUD_Font3")
			local width, height = surface.GetTextSize(text)
			draw.RoundedBox(0, ScrW() - width - uw, 3, width + 99, height + 5, col.o)
			draw.SimpleText(text, "HUD_Font3", ScrW() - (width + uw) * 0.85, 5, col.w, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
		end
	end

	if lp:Team() != TEAM_ADMIN and lp:IsNabor() then
		local cnt = netvars.GetNetVar("cats.ticketsCount", 0)
		if cnt != 0 and cnt >= team.NumPlayers(TEAM_ADMIN) then
			draw.SimpleText("Открытых тикетов: " .. cnt, "UnionHUD25", ScrW() - 8, 200, col.w, TEXT_ALIGN_RIGHT)
		end
	end

	if lp:IsRagdolled() or not lp:Alive() or lp:Team() == 0 or lp:GetNW2Bool("Jailed") or lp:GetNetVar("Scanner") or not lp:getJobTable() then return end
	local veh = lp:GetVehicle()
	if IsValid(veh) and veh:GetNWBool("IsChessSeat") or lp.Chess_Spectating then return end
	local w, h = ScrW(), ScrH()
	if showtime:GetBool() then draw.SimpleText(GetTimeText(), "HUD_Font15", w * 0.5, ss(20), col.w, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) end
	if GetEntityOwner() then draw.SimpleText("Владелец пропа: " .. GetEntityOwner(), "HUD_Font1", w, 0, Color(255, 255, 255), TEXT_ALIGN_RIGHT) end
	if lp:isOTA() or lp:isSynth() then
		powerHud()
		return
	end

	local x, y = ss(25), h * 0.92
	local drawBar = hud.drawBar
	local accurate = Union_hud_accurate:GetBool() and lp:Health() < 1000
	-- Голод
	local hunger = lp:getDarkRPVar("Energy", 0)
	smoothh = barCalculateLerp(smoothh, hunger, 100)
	drawBar(x, y, smoothh, barCalculatePercent(smoothh, 100), "СЫТОСТЬ", burger, hudColor.energy, accurate)
	y = y - bgBoxSizeY - sStepSize

	-- Броня
	local ap = lp:Armor()
	if ap > 0 then
		local maxAP = lp:GetMaxArmor()
		maxAP = maxAP ~= 0 and maxAP or 100
		smootha = barCalculateLerp(smootha, ap, maxAP)
		drawBar(x, y, smootha, barCalculatePercent(smootha, maxAP), "БРОНЯ", shields, hudColor.armor, accurate)
		y = y - bgBoxSizeY - sStepSize
	end

	-- Здоровье
	local hp, maxHealth = lp:Health(), lp:GetMaxHealth()
	smoothp = barCalculateLerp(smoothp, hp, maxHealth)
	drawBar(x, y, smoothp, barCalculatePercent(smoothp, maxHealth), "ЗДОРОВЬЕ", heart, hudColor.hp, accurate)
	y = y - bgBoxSizeY

	-- Заряд
	if lp:Team() == TEAM_GORDON then
		local val = lp:GetNetVar("PowerLevel", 10)
		local max = 100
		smoothe = barCalculateLerp(smoothe, val, max) -- Инверсия, чтобы отобразить заряд, а не расход
		drawBar(x, y, max - smoothe, barCalculatePercent(max - smoothe, max), "ЗАРЯД", energy, hudColor.energy, false)
		y = y - bgBoxSizeY - sStepSize
	end

	local voiceIcon = lp:GetVoiceDistanceIcon()
	if voiceIcon then
		local _x = x + stepYSize
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(voiceIcon)
		surface.DrawTexturedRect(_x, y, iconSize, iconSize)
	end

	-- Оружие
	x, y = w * 0.5, h * 0.95
	--if w < 1600 then
	--  x = w * 0.44
	--end
	local wep = lp:GetActiveWeapon()
	if IsValid(wep) then
		local maxClip = wep:GetMaxClip1() or 0
		local ammo = wep:Clip1() or 0
		local ammoType = wep:GetPrimaryAmmoType()
		local wepname = wep:GetPrintName()
		smoothammo = barCalculateLerp(smoothammo, ammo, maxClip)
		hud.drawWeaponBar(x, y, math.Round(smoothammo), maxClip, barCalculatePercent(smoothammo, maxClip), ammoType, wepname)
	end

	-- Основная информация(оружие, патроны, CID и деньги.)
	x, y = w * 0.5, h * 0.84
	--if w < 1600 then
	--  x = w * 0.55
	--end
	local job = lp:getDarkRPVar("job", "UNKNOWN")
	local name = lp:getDarkRPVar("rpname", "UNKNOWN")
	local money = hidden_info and "UNKNOWN" or DarkRP.formatMoney(lp:getDarkRPVar("money") or 0)
	local cid = lp:GetID() or "00000"
	local t = lp:GetNetVar("TeamNum", lp:Team())
	local tColor = team.GetColor(t)
	hud.drawMainInfo(x, y, job, tColor, name, money, cid)
end

hook.Add("HUDPaint", "mainHUD", drawMainHUD)
