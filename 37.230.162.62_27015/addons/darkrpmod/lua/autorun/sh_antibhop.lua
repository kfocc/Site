local string_find = string.find
local IsValid = IsValid
local FrameTime = FrameTime
local bit_bor = bit.bor
local bit_band = bit.band
local bit_bnot = bit.bnot

STAMINA_MAX = 100.0
STAMINA_COST_JUMP = 25.0
STAMINA_COST_FALL = 20.0
STAMINA_RECOVER_RATE = 19.0

hook.Add("PlayerBindPress", "AntiBHOP", function(ply, bind, pressed)
	 if string_find(bind, "+walk") and not IsValid(ply:GetVehicle()) then
		return true
	end
end)

local function ReduceTimers(ply)
	local flStamina = ply:GetNetVar("jumpstamina")
	if not flStamina then
		ply:SetLocalVar("jumpstamina", 0)
		return
	end

	if flStamina > 0 then
		local frame_msec = 1000.0 * FrameTime()
		ply:SetLocalVar("jumpstamina", math.max(0, flStamina - frame_msec))
	end
end

local function CheckJump(ply, mv, velocity)
	if not ply:Alive() then
		local buttons = bit_bor(mv:GetOldButtons(), IN_JUMP)
		mv:SetOldButtons(buttons)
		return
	end

	if ply:WaterLevel() >= 2 then return end
	if not ply:IsOnGround() then return end

	if ply:GetGroundEntity() == nil then
		local buttons = bit_bor(mv:GetOldButtons(), IN_JUMP)
		mv:SetOldButtons(buttons)
		return
	end

	if bit_band(mv:GetOldButtons(), IN_JUMP) ~= 0 then return end

	local flStamina = ply:GetNetVar("jumpstamina")
	if flStamina > 0 then
		local flRatio = (STAMINA_MAX - (flStamina / 1000.0) * STAMINA_RECOVER_RATE) / STAMINA_MAX
		local velX, velY, velZ = velocity:Unpack()
		velocity:SetUnpacked(velX, velY, velZ * flRatio)
	end

	ply:SetLocalVar("jumpstamina", (STAMINA_COST_JUMP / STAMINA_RECOVER_RATE) * 1000.0)
	return true
end

hook.Add("SetupMove", "AntiBHOP", function(ply, mv, cmd)
	if ply:GetNetVar("IgnoreBhop") then return end
	ReduceTimers(ply)

	local velocity = mv:GetVelocity()
	if bit_band(mv:GetButtons(), IN_JUMP) ~= 0 then
		CheckJump(ply, mv, velocity)
	else
		local buttons = bit_band(mv:GetOldButtons(), bit_bnot(IN_JUMP))
		mv:SetOldButtons(buttons)
	end

	local flStamina = ply:GetNetVar("jumpstamina")
	if flStamina > 0 and ply:IsOnGround() then
		local flRatio = (STAMINA_MAX - (flStamina / 1000.0) * STAMINA_RECOVER_RATE) / STAMINA_MAX
		local flReferenceFrametime = 1.0 / 70.0
		local flFrametimeRatio = FrameTime() / flReferenceFrametime
		flRatio = flRatio ^ flFrametimeRatio
		local velX, velY, velZ = velocity:Unpack()
		velocity:SetUnpacked(velX * flRatio, velY * flRatio, velZ)
	end

	mv:SetVelocity(velocity)
end)
