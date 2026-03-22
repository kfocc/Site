captureBases = captureBases or {}
local basesCfg = captureBases.basesCfg
local color_black = Color(15, 15, 15)
local function DrawShadowText(text, font, x, y, color, align1, align2)
	local w, h = draw.SimpleText(text, font, x, y, color_black, align1, align2)
	draw.SimpleText(text, font, x - 1, y - 1, color, align1, align2)
	return w, h
end

local function drawIcon(material, color, x, y, sizex, sizey)
	if not sizey then sizey = sizex end

	surface.SetDrawColor(color.r, color.g, color.b, color.a)
	surface.SetMaterial(material)
	surface.DrawTexturedRect(x, y, sizex, sizey)
end

local function drawSeparatorLine(y)
	surface.SetDrawColor(col.o)
	surface.DrawLine(-200, y, 200, y)
	y = y + 11
	return y
end

local color_white = color_white
local color_red = Color(196, 23, 0)
local function zoneDraw(ply, plyPos, zoneData)
	local pos = zoneData.pos[3]
	local ang = Angle(0, ply:GetAngles().y - 90, 90)
	cam.Start3D2D(pos, ang, 0.25)
	drawIcon(zoneData.icon, color_white, 0, -30, 16)
	local y = 0
	local _, h = DrawShadowText(zoneData.name, "Point_Font", 0, y, color_white, TEXT_ALIGN_CENTER)
	y = y + h + 10
	y = drawSeparatorLine(y)
	local isStarted = zoneData.started
	_, h = DrawShadowText("Статус захвата: " .. (zoneData.started and "Начат" or "Не начат"), "Point_Font", 0, y, color_white, TEXT_ALIGN_CENTER)
	y = y + h + 5
	local leaderRequireCount = zoneData.leaderRequire
	if leaderRequireCount then
		local leaderCount = zoneData.insideZoneCount
		local capturedColor = leaderCount < leaderRequireCount and color_red or color_white
		_, h = DrawShadowText("Лидер: " .. zoneData.leaderCount .. " / " .. leaderRequireCount, "Point_Font", 0, y, capturedColor, TEXT_ALIGN_CENTER)
		y = y + h + 5
	end

	local insideZoneCount = zoneData.insideZoneCount
	local minimumInsideZoneCount = zoneData.minimumInsideZoneCount
	local capturedColor = insideZoneCount < minimumInsideZoneCount and color_red or color_white
	_, h = DrawShadowText("Захватывающих: " .. insideZoneCount .. " / " .. minimumInsideZoneCount, "Point_Font", 0, y, capturedColor, TEXT_ALIGN_CENTER)
	y = y + h + 5
	if isStarted then
		local captureTime = math.ceil(zoneData.lastCapture - CurTime())
		if captureTime > 0 then
			local toEndTime = util.TimeToStr(captureTime)
			_, h = DrawShadowText("До конца захвата: " .. toEndTime, "Point_Font", 0, y, color_white, TEXT_ALIGN_CENTER)
			y = y + h + 5
		end
	else
		local cooldown = math.ceil(zoneData.nextCapture - CurTime())
		if cooldown > 0 then
			y = y + 10
			y = drawSeparatorLine(y)
			local toEndTime = util.TimeToStr(cooldown)
			_, h = DrawShadowText("Кулдаун: " .. toEndTime, "Point_Font", 0, y, color_red, TEXT_ALIGN_CENTER)
			y = y + h + 5
		end
	end

	y = y + 10
	drawSeparatorLine(y)
	cam.End3D2D()
end

local function DrawInfo(bDrawingDepth, bDrawingSkybox, isDraw3DSkybox)
	if bDrawingDepth or bDrawingSkybox or isDraw3DSkybox then return end
	local ply = LocalPlayer()
	local plyPos = ply:EyePos()
	for zoneID, zoneData in ipairs(basesCfg) do
		if not zoneData.drawing then continue end
		zoneDraw(ply, plyPos, zoneData)
	end
end
hook.Add("PostDrawOpaqueRenderables", "DrawCaptureBases", DrawInfo)

local function canSee(ply, plyPos, zoneData)
	if not zoneData.canSee(ply) then return false end

	local zonePos = zoneData.pos
	local distance = zonePos[3]:DistToSqr(plyPos)
	if distance > zoneData.maxSeeDist then return false end
	return true
end

hook.Add("PlayerOneSecond", "captureBases.CheckZone", function(ply)
	if ply ~= LocalPlayer() then return end
	local plyPos = ply:EyePos()
	for zoneID, zoneData in ipairs(basesCfg) do
		if zoneData.drawing then
			if not canSee(ply, plyPos, zoneData) then zoneData.drawing = false end
		else
			if canSee(ply, plyPos, zoneData) then zoneData.drawing = true end
		end
	end
end)

local laser = Material("effects/bluelaser1")
local color_green = Color(0, 255, 0)
local color_white = color_white
local vector_zero = Vector()
local angle_zero = Angle()
hook.Add("PostDrawOpaqueRenderables", "DebugCapturePoints", function()
	local ply = LocalPlayer()
	if not captureBases.debug then return end
	if not ply:IsSuperAdmin() then return end

	for _, zoneData in ipairs(basesCfg) do
		local pos1, pos2 = zoneData.pos[1], zoneData.pos[2]
		local mid = LerpVector(0.5, pos1, pos2)
		local ang = Angle(0, ply:GetAngles().y - 90, 90)
		local isStarted = zoneData.started
		local color = isStarted and color_red or color_green
		local owner = isStarted and "Захватывается" or "В ожидании"
		cam.IgnoreZ(true)
		cam.Start3D2D(mid, ang, 1)
		draw.SimpleTextOutlined("Base: " .. zoneData.name, "Point_Font", 0, 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Status: " .. owner, "Point_Font", 0, 50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Leader: " .. zoneData.leaderCount .. "/" .. zoneData.leaderRequire, "Point_Font", 0, 80, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined("Capture count: " .. zoneData.minimumInsideZoneCount .. "/" .. zoneData.insideZoneCount, "Point_Font", 0, 110, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		if isStarted then
			local captureTime = math.ceil(zoneData.lastCapture - CurTime())
			if captureTime > 0 then
				local toEndTime = util.TimeToStr(captureTime)
				draw.SimpleTextOutlined("Time: " .. toEndTime, "Point_Font", 0, 140, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end
		end

		cam.End3D2D()
		cam.IgnoreZ(false)
		render.SetMaterial(laser)
		render.DrawWireframeBox(vector_zero, angle_zero, pos1, pos2, color_red, false)
	end
end)
