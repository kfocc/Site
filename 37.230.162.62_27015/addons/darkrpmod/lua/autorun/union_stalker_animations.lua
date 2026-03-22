local acts = {
	[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_WALK_CROUCH,
	[ACT_MP_STAND_IDLE] = ACT_IDLE,
	-- [ACT_HL2MP_SIT] = ACT_GMOD_SIT_ROLLERCOASTER,
	[ACT_MP_JUMP] = ACT_HL2MP_JUMP_SLAM
}

local ACT_MP_RUN = ACT_MP_RUN
local ACT_MP_WALK = ACT_MP_WALK
local LookupSequence = FindMetaTable("Entity").LookupSequence
local GetSequenceActivity = FindMetaTable("Entity").GetSequenceActivity
hook.Add("TranslateActivity", "StalkerActs", function(pl, act)
	if pl:GetModel() == "models/union/union_stalker.mdl" then -- and IsValid(pl:GetActiveWeapon())
		if act == ACT_MP_WALK or act == ACT_MP_RUN then
			local yaw = pl:GetPoseParameter("move_yaw") * 360 - 180
			local act2
			if yaw > -30 and yaw <= 30 then -- forward
				act2 = "walk_forw"
			elseif yaw > -120 and yaw <= -60 then -- right
				act2 = "walk_right"
			elseif yaw > 60 and yaw <= 120 then -- left
				act2 = "walk_left"
			elseif yaw > 120 and yaw <= 150 then -- sw
				act2 = "walk_sw"
			elseif yaw > 30 and yaw <= 120 then -- nw
				act2 = "walk_nw"
			elseif yaw > -120 and yaw <= -30 then -- ne
				act2 = "walk_ne"
			elseif yaw > -150 and yaw <= -120 then -- se
				act2 = "walk_se"
			elseif yaw > -150 or yaw <= 150 then -- back
				act2 = "walk_back"
			end

			act2 = GetSequenceActivity(pl, LookupSequence(pl, act2))
			return act2 or act
		end

		if acts[act] then return acts[act] end
	end
end, HOOK_HIGH)
