include("shared.lua")

local math = math
local IsValid = IsValid
local CurTime = CurTime
local FrameTime = FrameTime
local function FindInCone(origin, direction, radius, angle)
	local pos = LocalPlayer():GetPos()
	if pos:Distance(origin) > radius then return end

	local dir = pos - origin
	dir:Normalize()
	direction:Normalize()

	return direction:Dot(dir) > math.cos(angle)
end

local tr = {}
local traceData = {
	start = Vector(),
	endpos = Vector(),
	filter = {NULL, NULL},
	output = tr
}

function ENT:HandleLocking()
	if not self:GetActive() then return end
	local DT = self:GetTable()
	if not DT.lock_targets then
		if DT.lock then self:Unlock() end
		return
	end

	local pos = self:GetPos()
	-- find a target to lock on to
	if not DT.lock then
		if CurTime() >= DT.next_search then
			DT.next_search = CurTime() + 1
			local att = self:GetAttachment(1)
			local v = LocalPlayer()
			if FindInCone(att.Pos, att.Ang:Forward(), DT.lock_radius, 0.95) and v:Alive() and v:GetMoveType() == MOVETYPE_WALK then
				local x1, y1 = pos:Unpack()
				local x2, y2 = v:EyePos():Unpack()
				if math.Distance(x1, y1, x2, y2) <= DT.lock_radius then
					traceData.start = self:GetCamInfo()
					traceData.endpos = self:GetLockPos(v)
					traceData.filter[1] = self
					traceData.filter[2] = v
					util.TraceLine(traceData)
					if tr.HitWorld then return end
					if not v:isCP() and not v:isGman() and v:Team() ~= TEAM_ADMIN then self:Lock(v) end
				end
			end
		end
		return
	end

	if not IsValid(DT.lock_ent) and DT.lock then
		self:Unlock()
		return
	end

	local lock_pos = DT.lock_ent:EyePos()
	local x1, y1 = pos:Unpack()
	local x2, y2 = lock_pos:Unpack()
	-- unlock if our target is too close or far away in the xy plane
	-- ignore the z-plane because we're at the ceiling
	traceData.start = self:GetCamInfo()
	traceData.endpos = lock_pos
	traceData.filter[1] = self
	traceData.filter[2] = DT.lock_ent
	util.TraceLine(traceData)
	if (tr.Hit or math.Distance(x1, y1, x2, y2) >= DT.lock_radius or not DT.lock_ent:Alive() or DT.lock_ent:GetMoveType() ~= MOVETYPE_WALK) and CurTime() >= DT.next_search then
		DT.next_search = CurTime() + 1
		self:Unlock()
	end
end

function ENT:UpdateGoalAngs()
	local CT = CurTime()
	local DT = self:GetTable()
	local pitch, yaw = 20
	if DT.lock and IsValid(DT.lock_ent) then
		-- local ap, ay = self:GetAimYaw(), self:GetAimPitch()
		-- local cam_ang = self:GetAngles() + Angle(ap - 5, ay, 0)
		local cam_pos = self:EyePos() -- self:GetBonePosition(DT.bones["Combine_Camera.Lens"]) + cam_ang:Forward() * 5
		-- v looks odd when the camera bounces up and down with the player movement
		--local bone_id = DT.lock_ent:LookupBone("ValveBiped.Bip01_Spine")
		local lock_pos = self:GetLockPos(DT.lock_ent)
		local ang = (lock_pos - cam_pos):Angle()
		pitch, yaw = ang:Unpack()
		local _, self_yaw = self:GetAngles():Unpack()
		yaw = math.NormalizeAngle(yaw - self_yaw)
		pitch = math.NormalizeAngle(pitch)
	elseif not DT.halting then
		yaw = 50 * math.sin(self:GetSweepSpeed() * (CT - self:GetSine()))
	else
		yaw = DT.goal_angle[2]
	end

	DT.goal_angle:SetUnpacked(pitch, yaw, 0)
end

function ENT:UpdatePoseParams()
	local CT = CurTime()
	local DT = self:GetTable()
	local pitch, yaw = (DT.stored_pitch or 0.5) * 180, (DT.stored_yaw or 0.5) * 360 -- i hate my life
	local speed = FrameTime() * self:MaxYawSpeed()
	local goal_pitch, goal_yaw = DT.goal_angle:Unpack()

	goal_pitch = (goal_pitch - pitch) * speed
	goal_yaw = (goal_yaw - yaw) * speed

	local aim_yaw = math.NormalizeAngle(yaw + goal_yaw)
	local aim_pitch = math.NormalizeAngle(pitch + goal_pitch)

	if (math.abs(goal_yaw) >= 0.1 or math.abs(goal_pitch) >= 1) and CT >= DT.next_move_sound then
		DT.next_move_sound = CT + 1
		self:EmitSound("NPC_CombineCamera.Move")
	end

	self:SetPoseParameter("aim_yaw", aim_yaw)
	self:SetPoseParameter("aim_pitch", aim_pitch)
	DT.stored_pitch, DT.stored_yaw = aim_pitch / 180, aim_yaw / 360

	self:InvalidateBoneCache()
end

local function RequestForWanted(a, e)
	local ply = LocalPlayer()
	--if ply:isWanted() then
	--	return
	--end
	netstream.Start("CrimeDetected", a, e)
end

local now = 0
hook.Add("Think", "CameraSpectating", function()
	if now > CurTime() then return end
	now = CurTime() + 1
	local ply = LocalPlayer()
	if ply:GetMoveType() ~= MOVETYPE_WALK or ply:Team() == TEAM_ADMIN or ply:isCP() then return end
	local e = ply.CameraSpectating
	if not e or not IsValid(e) or not e:GetActive() then return end
	local camPos = e:GetCamInfo()
	local plyPos = ply:EyePos()
	if camPos:Distance(plyPos) > 400 then return end
	traceData.start = camPos
	traceData.endpos = plyPos
	traceData.filter[1] = e
	traceData.filter[2] = ply
	util.TraceLine(traceData)
	if tr.HitWorld then return end
	local reason = (ply:isRebel() and not ply.Disguised) and 1 or ply:HasGun() and 2 or (not ply:isLoyal() and ply:IsSprinting() and ply:GetVelocity():Length() >= 50) and 3 or ply:isWanted() and 4
	if not reason then return end
	RequestForWanted(reason, e)
	now = CurTime() + 30
end)
