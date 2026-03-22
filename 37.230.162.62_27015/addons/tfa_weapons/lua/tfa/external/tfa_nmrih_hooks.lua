TFA.AddStatus( "NMRIH_MELEE_SWING" )
TFA.AddStatus( "NMRIH_MELEE_CHARGE_START" )
TFA.AddStatus( "NMRIH_MELEE_CHARGE_LOOP" )
TFA.AddStatus( "NMRIH_MELEE_CHARGE_END" )
TFA.AddStatus( "NMRIH_MELEE_MOTOR_START" )
TFA.AddStatus( "NMRIH_MELEE_MOTOR_LOOP" )
TFA.AddStatus( "NMRIH_MELEE_MOTOR_ATTACK" )
TFA.AddStatus( "NMRIH_MELEE_MOTOR_END" )

-- local swing_threshold = 0.1

-- local function M_PRESS(plyv, key)
-- 	if key ~= IN_ATTACK then return end
-- 	if plyv.HasTFANMRIMSwing then return end
-- 	local wep = plyv:GetActiveWeapon()
-- 	if not ( IsValid(wep) and wep.TFA_NMRIH_MELEE and wep:GetStatus() == TFA.Enum.STATUS_IDLE ) then return end

-- 	plyv.LastNMRIMSwing = CurTime()
-- 	plyv.HasTFANMRIMSwing = true
-- end

-- hook.Add("KeyPress","TFANMRIH_M",M_PRESS)

-- local function M_RELEASE(plyv, key)
-- 	if key ~= IN_ATTACK then return end
-- 	local wep = plyv:GetActiveWeapon()
-- 	if not ( IsValid(wep) and wep.TFA_NMRIH_MELEE  ) then return end
-- 	if wep:GetStatus() == TFA.Enum.STATUS_IDLE then
-- 		if CurTime() <= ( plyv.LastNMRIMSwing or CurTime() ) + swing_threshold then
-- 			plyv:GetActiveWeapon():PrimaryAttack( true, false )
-- 			plyv.LastNMRIMSwing = nil
-- 			plyv.HasTFANMRIMSwing = nil
-- 		elseif CurTime() > ( plyv.LastNMRIMSwing or CurTime() ) + swing_threshold then
-- 			plyv.HasTFANMRIMSwing = true
-- 		    plyv:GetActiveWeapon():PrimaryAttack( true, true )
-- 		    plyv.LastNMRIMSwing = CurTime()
-- 		end
-- 	end
-- end

-- hook.Add("KeyRelease","TFANMRIH_M",M_RELEASE)

-- local function M_SPAWN(plyv)
	-- plyv.LastNMRIMSwing = nil
	-- plyv.HasTFANMRIMSwing = true
-- end

-- hook.Add("PlayerSpawn","TFANMRIH_M",M_SPAWN)