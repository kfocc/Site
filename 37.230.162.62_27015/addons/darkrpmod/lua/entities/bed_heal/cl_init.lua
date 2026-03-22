include("shared.lua")
surface.CreateFont("BedFont", {
	font = "Inter",
	size = 15,
	weight = 500,
	extended = true
})

local color_white = Color(255, 255, 255, 255)
local color_black = Color(0, 0, 0, 255)
local renderDist = 350 * 350
local icons = {
	player = Material("icon16/vcard.png"),
	name = Material("icon16/user_green.png"),
	health = Material("icon16/heart.png"),
	disease = Material("icon16/bug.png"),
	timeToHeal = Material("icon16/clock_red.png"),
	healCount = Material("icon16/pill.png")
}

local pos3D2D = Vector(6.2, -27, 34)
local function drawTextWithIcon(icon, x, y, text)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(icon)
	surface.DrawTexturedRect(x, y, 16, 16)
	x = x + 16 + 5
	y = y + 1
	draw.SimpleTextOutlined(text, "BedFont", x, y, color_white, nil, nil, 1, color_black)
end

function ENT:OnDraw()
	local mainBoard = self.mainBoard
	if not IsValid(mainBoard) then return end

	local boardPos = mainBoard:GetPos()
	local boardAng = mainBoard:GetAngles()
	local localPlayerPos = LocalPlayer():GetPos()
	local dist = boardPos:DistToSqr(localPlayerPos)
	if dist > renderDist then return end

	color_white.a = renderDist - dist
	color_black.a = renderDist - dist

	local bedUserInfo = self._bedUserInfo
	local playerName, diseaseName, healthPercent, timeToHeal
	if bedUserInfo then
		playerName = bedUserInfo.playerName
		diseaseName = bedUserInfo.diseaseName
		healthPercent = bedUserInfo.healthPercent
		timeToHeal = bedUserInfo.timeToHeal
	end

	local bedHealPoints, maxHealPoints = self:GetHealPoints(), self.MaxHealPoints

	boardAng:RotateAroundAxis(boardAng:Up(), 90)
	boardAng:RotateAroundAxis(boardAng:Forward(), 90)

	boardPos = mainBoard:LocalToWorld(pos3D2D)
	cam.Start3D2D(boardPos, boardAng, 0.2)
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(icons.player)
	surface.DrawTexturedRect(125, 0, 16, 16)

	draw.SimpleTextOutlined("Информация о пациенте", "BedFont", 60, 20, color_white, nil, nil, 1, color_black)

	if playerName and healthPercent then
		drawTextWithIcon(icons.name, 0, 45, "Имя: " .. playerName)
		drawTextWithIcon(icons.health, 0, 65, "Здоровье: " .. healthPercent)
		if diseaseName and timeToHeal then
			drawTextWithIcon(icons.disease, 0, 85, "Болезнь: " .. diseaseName)
			drawTextWithIcon(icons.timeToHeal, 0, 105, "Время до лечения: " .. timeToHeal)
		end
	end

	drawTextWithIcon(icons.healCount, 0, 135, "Лекарств в кровати: (" .. bedHealPoints .. " / " .. maxHealPoints .. ")")
	cam.End3D2D()
end

function ENT:OnPlaceRagdoll()
	local bedUser = self:GetUser()
	if IsValid(bedUser) and not self._bedUserInfo then
		self._bedUserInfo = {
			playerName = bedUser:GetName(),
		}

		local disease = bedUser:GetDisease()
		if not disease then return end

		local curTime, healTime = CurTime(), disease.heal_time
		local info = self._bedUserInfo
		info.diseaseName = disease.name
		info.timeToHeal = "∞. Нет лекарств."
		info.startHealTime = curTime
		info.diseaseHealTime = healTime
	end
end

function ENT:OnDeleteRagdoll()
	self._bedUserInfo = nil
end

function ENT:OneSecondThink()
	local bedUserInfo = self._bedUserInfo
	if bedUserInfo then
		local bedUser = self:GetUser()
		if IsValid(bedUser) then bedUserInfo.healthPercent = math.floor(100 * (bedUser:Health() / bedUser:GetMaxHealth())) .. "%" end
		if not bedUserInfo.diseaseName then return end
		local bedHealPoints = self:GetHealPoints()
		if bedHealPoints <= 0 then return end
		local diseaseHealTime = bedUserInfo.diseaseHealTime - 1
		if diseaseHealTime < 0 then return end
		bedUserInfo.timeToHeal = string.FormattedTime(diseaseHealTime, "%02i:%02i")
		bedUserInfo.diseaseHealTime = diseaseHealTime
	end
end
