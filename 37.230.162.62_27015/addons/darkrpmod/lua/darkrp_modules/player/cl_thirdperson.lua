ThirdPerson = ThirdPerson or {}
local ThirdPerson = ThirdPerson
local strKey = "union_tp_int"
local lastChange = 0
local lastNotify = 0
local toggletp = cookie.GetNumber(strKey, 0) == 1
local NOTIFY_TIME = 2
local CHANGE_COOLDOWN = 3
local tempDisable = false
concommand.Add("union_tp_toggle", function(ply, cmd, args)
	local num = tonumber(args[1])
	local val = false
	if num == 1 then
		val = true
	elseif num == 0 then
		val = false
	else
		val = not toggletp
	end

	if val == toggletp then return end
	local curTime = CurTime()
	if lastChange >= curTime then
		if lastNotify <= curTime then
			lastNotify = curTime + NOTIFY_TIME
			notification.AddLegacy("Не так быстро.", NOTIFY_ERROR, 5)
			surface.PlaySound("buttons/lightswitch2.wav")
		end
		return
	end
	lastChange = curTime + CHANGE_COOLDOWN

	toggletp = val
	cookie.Set(strKey, toggletp and 1 or 0)
end)

function isThirdPersonToggle()
	return toggletp
end

function temporaryDisableThirdPerson(bool)
	tempDisable = bool
end

local --[[cvar_name,--]] smooth_name = --[["union_tp_toggle",--]] "union_tp_smooth"
-- ThirdPerson.cvar = CreateClientConVar(cvar_name, "0", true, false)
ThirdPerson.cvar_smooth = CreateClientConVar(smooth_name, "10", true, false)
ThirdPerson.cvar_position = CreateClientConVar("union_tp_position", "7", true, false, "", -10, 10)
local function scopeAiming()
	local wep = LocalPlayer():GetActiveWeapon()
	return IsValid(wep) and wep:IsTFA() and wep:GetIronSights()
end

local max_smooth = 15
-- toggletp = ThirdPerson.cvar:GetBool()
ThirdPerson.smoothMult = math.Clamp(ThirdPerson.cvar_smooth:GetInt(), 5, max_smooth)
local function toggleThirdPerson()
	-- toggletp = not toggletp
	-- ThirdPerson.cvar:SetBool(toggletp)
	RunConsoleCommand("union_tp_toggle")
end
ThirdPerson.toggle = toggleThirdPerson

function ThirdPerson.Update()
	-- toggletp = ThirdPerson.cvar:GetBool()
	local smooth = ThirdPerson.cvar_smooth:GetInt()
	smooth = math.Clamp(smooth, 5, max_smooth)
	ThirdPerson.smoothMult = smooth
end
-- cvars.AddChangeCallback(cvar_name, ThirdPerson.Update)
cvars.AddChangeCallback(smooth_name, ThirdPerson.Update)

function ThirdPerson.IsEnabled()
	return toggletp
end

local max = 0
hook.Add("PlayerButtonUp", "ThirdPerson.keyBind", function(ply, buttonId)
	if max > CurTime() then return end
	if ply ~= LocalPlayer() then return end
	if buttonId ~= MOUSE_MIDDLE then return end
	if gui.IsGameUIVisible() then return end
	if ply:IsTyping() then return end
	max = CurTime() + .2
	ThirdPerson.cvar_position:SetInt(-ThirdPerson.cvar_position:GetInt())
end)

local delayPos
local isIronSights = false
local traceOut = {}
local traceData = {
	mins = Vector(-10, -10, -10),
	maxs = Vector(10, 10, 10),
	output = traceOut
}

local retTab = {
	drawviewer = true,
}

local crmJob = {
	[TEAM_CREMATOR] = true
}

local crmAndJeffOffset = Vector(0, 0, 17)
local math_abs = math.abs
local LerpVector = LerpVector
local FrameTime = FrameTime
local util_TraceHull = util.TraceHull
hook.Add("CalcView", "ThirdPerson.view", function(client, position, angles, fov, znear, zfar)
	if tempDisable or not introPressed or not (LocalPlayer():GetNetVar("vomit") or toggletp) then
		delayPos = nil
		return
	end

	local ply = LocalPlayer()
	if ply:InVehicle() then
		delayPos = nil
		return
	end

	if ply:GetMoveType() == MOVETYPE_NOCLIP then
		delayPos = nil
		return
	end

	if ply:GetNetVar("Scanner") then
		delayPos = nil
		return
	end

	isIronSights = scopeAiming()

	local smoothMult = ThirdPerson.smoothMult
	local distance = isIronSights and 0 or 40
	local isCrm = crmJob[ply:Team()]
	if isCrm then position:Add(crmAndJeffOffset) end

	local shoulderCalculation = (not isIronSights and 1 or 0) * angles:Right() * ThirdPerson.cvar_position:GetInt()

	if isCrm then shoulderCalculation = shoulderCalculation * 2 end

	local distanceCalculation = position - angles:Forward() * distance + shoulderCalculation

	traceData.start = position
	traceData.endpos = distanceCalculation
	traceData.filter = ply
	util_TraceHull(traceData)

	local newDistance = traceOut.HitPos:Distance(position)
	if newDistance < distance - 10 then distance = newDistance - 10 end

	delayPos = delayPos or position + ply:GetVelocity() * (FrameTime() / 5)
	delayPos = LerpVector(FrameTime() * smoothMult, delayPos, distanceCalculation)

	local dist = delayPos:Distance(position)
	if dist > 256 or smoothMult == max_smooth then delayPos = distanceCalculation end

	if math_abs(delayPos.x - position.x) < 10 and math_abs(delayPos.y - position.y) < 10 and math_abs(delayPos.z - position.z) < 10 then return end

	if traceOut.Hit then delayPos = traceOut.HitPos end

	retTab.origin = delayPos
	retTab.angles = angles
	retTab.fov = fov
	retTab.drawviewer = not isIronSights
	retTab.znear = nearZ
	retTab.zfar = farZ

	return retTab
end, HOOK_HIGH)
