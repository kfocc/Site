local GM = GM or GAMEMODE
local FrameTime = FrameTime
local math_Clamp = math.Clamp
local math_Approach = math.Approach
local bit_bor = bit.bor
local MOVETYPE_NOCLIP = MOVETYPE_NOCLIP
local ACT_MP_STAND_IDLE = ACT_MP_STAND_IDLE -- 990 = 991 -- 0011 1101 1110 = 0011 1101 1111
local ACT_MP_WALK = ACT_MP_WALK -- 997 = 999 -- 0011 1110 0101 = 0011 1110 0111
local ACT_MP_RUN = ACT_MP_RUN -- 996 = 999 -- 0011 1110 0100 = 0011 1110 0111
local FL_ANIMDUCKING = FL_ANIMDUCKING

local PLAYER = FindMetaTable("Player")
local InVehicle = PLAYER.InVehicle
local GetActiveWeapon = PLAYER.GetActiveWeapon
local ENTITY = FindMetaTable("Entity")
local EyeAngles = ENTITY.EyeAngles
local GetTable = ENTITY.GetTable
local IsFlagSet = ENTITY.IsFlagSet
local IsOnGround = ENTITY.IsOnGround
local GetMoveType = ENTITY.GetMoveType
local LookupSequence = ENTITY.LookupSequence
local SetPoseParameter = ENTITY.SetPoseParameter
local Length2DSqr = FindMetaTable("Vector").Length2DSqr
local normalizeAngle = math.NormalizeAngle
local vectorAngle = FindMetaTable("Vector").Angle

function GM:HandlePlayerDucking(ply, velocity, plyTable)
end

function GM:CalcMainActivity(ply, velocity)
	local plyTable = GetTable(ply)
	plyTable.CalcIdeal = ACT_MP_STAND_IDLE
	plyTable.CalcSeqOverride = -1

	SetPoseParameter(ply, "move_yaw", normalizeAngle(vectorAngle(velocity)[2] - EyeAngles(ply)[2]))

	self:HandlePlayerLanding(ply, velocity, plyTable.m_bWasOnGround)

	if not (self:HandlePlayerNoClipping(ply, velocity, plyTable)
		or self:HandlePlayerDriving(ply, plyTable)
		or self:HandlePlayerVaulting(ply, velocity, plyTable)
		or self:HandlePlayerJumping(ply, velocity, plyTable)
		or self:HandlePlayerSwimming(ply, velocity, plyTable)) then

		local len2d = Length2DSqr(velocity)
		local ideal = ACT_MP_STAND_IDLE
		if len2d > 22500 then
			ideal = ACT_MP_RUN
		elseif len2d > 0.25 then
			ideal = ACT_MP_WALK
		end

		if IsFlagSet(ply, FL_ANIMDUCKING) then ideal = bit_bor(ideal, 3) end
		plyTable.CalcIdeal = ideal
	end

	plyTable.m_bWasOnGround = IsOnGround(ply)
	plyTable.m_bWasNoclipping = GetMoveType(ply) == MOVETYPE_NOCLIP and not InVehicle(ply)

	local wep = GetActiveWeapon(ply)
	if IsValid(wep) and wep.TranslateSequenceHoldType then
		local holdtype = wep:GetHoldType()
		local TranslateSequenceHoldType = wep.TranslateSequenceHoldType
		if TranslateSequenceHoldType[holdtype] then
			local override = TranslateSequenceHoldType[holdtype][plyTable.CalcIdeal]
			if override then
				plyTable.CalcSeqOverride = LookupSequence(ply, override)
			end
		end
	end

	return plyTable.CalcIdeal, plyTable.CalcSeqOverride
end

-- If you don't want the player to grab his ear in your gamemode then just override this
function GM:GrabEarAnimation(ply)
	-- Don't show this when we're playing a taunt!
	if ply:IsPlayingTaunt() then return end
	local weight = ply.ChatGestureWeight or 0
	if weight == 0 then
		if not ply:IsTyping() then
			-- No slot work has to be done if no animation is in progress
			return
		end

		weight = math_Approach(0, 1, FrameTime() * 5)
		ply.ChatGestureWeight = weight
	elseif weight == 1 then
		if not ply:IsTyping() then
			weight = math_Approach(1, 0, FrameTime() * 5)
			ply.ChatGestureWeight = weight
		end
	else
		weight = math_Approach(weight, ply:IsTyping() and 1 or 0, FrameTime() * 5)
		ply.ChatGestureWeight = weight
	end

	ply:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true)
	ply:AnimSetGestureWeight(GESTURE_SLOT_VCD, weight)
end

-- Skip a loop by calling SetFlexWeight for each flex manually
-- Localise player functions to save on __index calls
local function UpdateMouthFlexes(ply, weight)
	local fSetFlexWeight = ply.SetFlexWeight
	local fGetFlexIDByName = ply.GetFlexIDByName
	local flexes = {
		fGetFlexIDByName(ply, "jaw_drop"),
		fGetFlexIDByName(ply, "left_part"),
		fGetFlexIDByName(ply, "right_part"),
		fGetFlexIDByName(ply, "left_mouth_drop"),
		fGetFlexIDByName(ply, "right_mouth_drop")
	}
	local i, v = next(flexes, nil)
	while i do
		fSetFlexWeight(ply, v, weight)
		i, v = next(flexes, i)
	end
end

-- Moves the mouth when talking on voicecom
function GM:MouthMoveAnimation(ply)
	--[[if ( ply:IsSpeaking() ) then
    ply.m_bSpeaking = true
    UpdateMouthFlexes( ply, math_Clamp( ply:VoiceVolume() * 2, 0, 2 ) )
  elseif ( ply.m_bSpeaking ) then
    ply.m_bSpeaking = false
    UpdateMouthFlexes( ply, 0 )
  end]]
end

local IdleActivityTranslate = {
	[ACT_MP_SWIM_IDLE] = ACT_HL2MP_SWIM_IDLE,
	[ACT_MP_WALK] = ACT_HL2MP_WALK,
	[ACT_MP_RUN] = ACT_HL2MP_RUN,
	[ACT_MP_SPRINT] = ACT_HL2MP_RUN,
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH,
	[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH,
	[ACT_BUSY_SIT_GROUND] = ACT_HL2MP_SIT,
	[ACT_BUSY_SIT_CHAIR] = ACT_HL2MP_SIT,
	[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE,
	--[ ACT_MP_AIRWALK ]		= ACT_HL2MP_WALK,
	[ACT_MP_JUMP] = ACT_HL2MP_JUMP_SLAM, -- ACT_HL2MP_JUMP isn't in m_anm
	[ACT_MP_SWIM] = ACT_HL2MP_SWIM,
	[ACT_LAND] = ACT_LAND,
}

-- it is preferred you return ACT_MP_* in CalcMainActivity, and if you have a specific need to not translate through the weapon do it here
function GM:TranslateActivity(ply, act)
	local newact = ply:TranslateWeaponActivity(act)
	-- Select idle anims if the weapon didn't decide
	return newact ~= act and newact > -1 and newact or IdleActivityTranslate[act]
end
