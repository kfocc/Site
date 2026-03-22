local math = math

local view = {}
view.drawviewer = false
view.znear = 1
view.zfar = 10000

local currentPath = 1
local currentT = 0
local pathStartTime = 0
local pathDuration = 0
local currentPoints = {}
local currentAngles = {}
local currentSpeed = 500
local pathEndNotified = false

local camPos, camAng = Vector(), Angle()
local function CatmullRomSpline(t, p0, p1, p2, p3)
	local t2 = t * t
	local t3 = t2 * t

	return 0.5 * ((2 * p1) +
		(-p0 + p2) * t +
		(2 * p0 - 5 * p1 + 4 * p2 - p3) * t2 +
		(-p0 + 3 * p1 - 3 * p2 + p3) * t3)
end

local function CalculatePathLength(points)
	local total = 0
	for i = 1, #points - 1 do
		total = total + points[i]:Distance(points[i + 1])
	end
	return total
end

local function GetSplinePoint(t, points)
	local n = #points
	if n < 2 then
		camPos:Set(points[1] or vector_zero)
		return
	end

	t = math.Clamp(t, 0, 1)

	if n == 2 then
		camPos = LerpVector(t, points[1], points[2])
	elseif n == 3 then
		local p0 = points[1]
		local p1 = points[2]
		local p2 = points[3]

		if t < 0.5 then
			local localT = t * 2
			camPos:SetUnpacked(
				CatmullRomSpline(localT, p0.x, p0.x, p1.x, p2.x),
				CatmullRomSpline(localT, p0.y, p0.y, p1.y, p2.y),
				CatmullRomSpline(localT, p0.z, p0.z, p1.z, p2.z)
			)
		else
			local localT = (t - 0.5) * 2
			camPos:SetUnpacked(
				CatmullRomSpline(localT, p0.x, p1.x, p2.x, p2.x),
				CatmullRomSpline(localT, p0.y, p1.y, p2.y, p2.y),
				CatmullRomSpline(localT, p0.z, p1.z, p2.z, p2.z)
			)
		end
	else
		local segment = math.floor(t * (n - 1))
		local localT = t * (n - 1) - segment

		segment = math.Clamp(segment, 0, n - 2)

		local p0 = points[math.max(1, segment)]
		local p1 = points[segment + 1]
		local p2 = points[math.min(n, segment + 2)]
		local p3 = points[math.min(n, segment + 3)]

		if segment == 0 then p0 = p1 - (p2 - p1) end
		if segment >= n - 2 then p3 = p2 + (p2 - p1) end

		camPos:SetUnpacked(
			CatmullRomSpline(localT, p0.x, p1.x, p2.x, p3.x),
			CatmullRomSpline(localT, p0.y, p1.y, p2.y, p3.y),
			CatmullRomSpline(localT, p0.z, p1.z, p2.z, p3.z)
		)
	end
end

local function GetSplineAngle(t, angles)
	local n = #angles
	if n < 2 then
		camAng:Set(angles[1] or angle_zero)
		return
	end

	t = math.Clamp(t, 0, 1)

	if n == 2 then
		camAng = LerpAngle(t, angles[1], angles[2])
	elseif n == 3 then
		local a0 = angles[1]
		local a1 = angles[2]
		local a2 = angles[3]

		-- For the first segment, use a0, a1, a2, a2
		if t < 0.5 then
			local localT = t * 2
			camAng:SetUnpacked(
				CatmullRomSpline(localT, a0.p, a0.p, a1.p, a2.p),
				CatmullRomSpline(localT, a0.y, a0.y, a1.y, a2.y),
				CatmullRomSpline(localT, a0.r, a0.r, a1.r, a2.r)
			)
		-- For the second segment, use a0, a1, a2, a2
		else
			local localT = (t - 0.5) * 2
			camAng:SetUnpacked(
				CatmullRomSpline(localT, a0.p, a1.p, a2.p, a2.p),
				CatmullRomSpline(localT, a0.y, a1.y, a2.y, a2.y),
				CatmullRomSpline(localT, a0.r, a1.r, a2.r, a2.r)
			)
		end
	else
		local segment = math.floor(t * (n - 1))
		local localT = t * (n - 1) - segment

		segment = math.Clamp(segment, 0, n - 2)

		local a0 = angles[math.max(1, segment)]
		local a1 = angles[segment + 1]
		local a2 = angles[math.min(n, segment + 2)]
		local a3 = angles[math.min(n, segment + 3)]

		if segment == 0 then a0 = a1 - (a2 - a1) end
		if segment >= n - 2 then a3 = a2 + (a2 - a1) end

		camAng:SetUnpacked(
			CatmullRomSpline(localT, a0.p, a1.p, a2.p, a3.p),
			CatmullRomSpline(localT, a0.y, a1.y, a2.y, a3.y),
			CatmullRomSpline(localT, a0.r, a1.r, a2.r, a3.r)
		)
	end
end

local function InitPath(pathIndex)
	local path = DarkRP.IntroScenes[pathIndex]
	if not path then return end

	currentPath = pathIndex
	currentPoints = path.points
	currentAngles = path.angles
	currentSpeed = path.speed or 500
	pathStartTime = RealTime()

	local pathLength = CalculatePathLength(currentPoints)
	pathDuration = pathLength / currentSpeed
end

local function CalculateCamera()
	if #currentPoints == 0 then
		InitPath(1)
		return
	end

	local elapsed = RealTime() - pathStartTime
	currentT = math.Clamp(elapsed / pathDuration, 0, 1)

	GetSplinePoint(currentT, currentPoints)
	GetSplineAngle(currentT, currentAngles)

	local nextPath = (currentPath % #DarkRP.IntroScenes) + 1
	if currentT >= 1 then
		netstream.Start("SwitchIntroScene", nextPath)
		pathEndNotified = false
		InitPath(nextPath)
	elseif pathDuration - elapsed <= 0.5 and not pathEndNotified then
		netstream.Start("SwitchIntroScene", nextPath, true)
		pathEndNotified = true
	end
end

hook.Add("CalcView", "preloadScene", function(ply, pos, angles, fov)
	if introPressed then return end

	CalculateCamera()

	-- Update view
	view.origin = camPos
	view.angles = camAng
	view.fov = fov or 90

	return view
end)

local presses = {
	IN_ATTACK,
	IN_JUMP,
	IN_DUCK,
	IN_FORWARD,
	IN_BACK,
	IN_USE,
	IN_LEFT,
	IN_RIGHT,
	IN_MOVELEFT,
	IN_MOVERIGHT,
	-- IN_ATTACK2,
	IN_RELOAD,
	IN_SPEED
}

hook.Add("Move", "MoveIntroCheck", function(pl, mv)
	if not introPressed then
		for _, v in ipairs(presses) do
			if mv:KeyDown(v) or mv:KeyReleased(v) then
				introPressed = true
				hook.Run("IntroPressed")
				netstream.Start("SwitchIntroScene")
				break
			end
		end
	end
end)

local shitSnd
local music = {
	"music/HL2_song7.mp3",
	"music/HL2_song8.mp3",
	"music/HL2_song10.mp3",
	"music/HL2_song13.mp3",
	"music/HL2_song17.mp3",
	"music/HL2_song19.mp3",
	"music/HL2_song26.mp3",
	"music/HL2_song30.mp3",
	"music/HL2_song33.mp3",
	"music/HL1_song3.mp3",
	"music/HL1_song5.mp3",
	"music/HL1_song6.mp3",
	"music/HL1_song14.mp3",
	"music/HL1_song20.mp3"
}
hook.Add("Think", "SoundThink", function()
	if not shitSnd and not introPressed then
		hook.Remove("Think", "SoundThink")
		shitSnd = CreateSound(game.GetWorld(), music[math.random(#music)])
		if shitSnd then
			shitSnd:SetSoundLevel(0)
			shitSnd:Play()
			-- playTime = CurTime() + SoundDuration(snd) + 1
		end

		local nextThink = CurTime()
		hook.Add("Think", "CheckSnd", function()
			if nextThink >= CurTime() then return end
			nextThink = CurTime() + 1
			if introPressed and shitSnd and shitSnd:IsPlaying() then
				hook.Remove("Think", "CheckSnd")
				shitSnd:Stop()
				shitSnd = nil
			end
		end)
	end
end)