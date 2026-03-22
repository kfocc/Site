local keys = {
	[KEY_W] = true,
	[KEY_A] = true,
	[KEY_S] = true,
	[KEY_D] = true,
	[KEY_R] = true,
	[KEY_SPACE] = true,
	[KEY_LCONTROL] = true,
	[KEY_LSHIFT] = true,
	[MOUSE_LEFT] = true,
	[MOUSE_RIGHT] = true
}

local afkTime = AFK_TIME
local isAFK = false
local lastPressed = 0
local i = 0

hook.Add("PlayerButtonDown", "storeLastPressedKey", function(_, key)
	if not IsFirstTimePredicted() then return end
	if keys[key] then
		lastPressed = CurTime()
		i = nil
	end
end)

local function calculateAFK(lp)
	return lp:Team() == TEAM_ADMIN and 60 or afkTime
end

local curTime = CurTime
local function initAFK()
	local ply = LocalPlayer()
	local timerCycle = 0.1
	timer.Create("checkAFK", timerCycle, 0, function()
		if not IsValid(ply) then
			ply = LocalPlayer()
			return
		end

		local isSuperAdmin = ply:IsSuperAdmin()
		local isJailed = ply:GetNWBool("Jailed")
		if lastPressed == 0 and not isSuperAdmin and not isJailed then
			i = i + timerCycle
			if i > afkTime and not isAFK then
				i = 0
				lastPressed = CurTime()
				netstream.Start("ping.AFK", true)
				isAFK = true
			end
			return
		end

		local afkTimeCalculate = calculateAFK(ply)
		if isSuperAdmin or isJailed then
			if isAFK then
				netstream.Start("ping.AFK", false)
				isAFK = false
			end
			return
		end

		local noFocus = not system.HasFocus()
		if curTime() - lastPressed >= afkTimeCalculate or noFocus then
			if not isAFK then
				netstream.Start("ping.AFK", true, noFocus)
				isAFK = true
			end
		else
			if isAFK then
				netstream.Start("ping.AFK", false)
				isAFK = false
			end
		end
	end)
end
hook.Add("PlayerInitialized", "initAFK", initAFK)

surface.CreateFont("AFKFont", {
	font = "Inter",
	extended = true,
	size = 25,
	weight = 900,
	additive = true
})

local text = "Вы AFK уже: %s."
-- local pColor = Color(22, 22, 22, 245)
local afkIcon = Material("icon16/control_pause_blue.png")
hook.Add("HUDPaint", "drawAFKInfo", function()
	local ply = LocalPlayer()
	if not ply:IsAFK() then return end

	local w, h = ScrW(), ScrH()
	-- draw.RoundedBox(0, 0, 0, w, h, pColor)
	surface.SetFont("AFKFont")
	local _afkTime = util.SecondsToClock(ply:GetAFKTime())
	local _text = text:format(_afkTime)
	local textW, textH = surface.GetTextSize(_text)
	w, h = w * 0.5, h * 0.5
	surface.SetTextPos(w - textW * 0.5, h + textH * 2)
	surface.SetTextColor(color_white)
	surface.DrawText(_text)
	surface.SetDrawColor(color_white)
	surface.SetMaterial(afkIcon)
	surface.DrawTexturedRect(w - 16, h, 32, 32)
end)
