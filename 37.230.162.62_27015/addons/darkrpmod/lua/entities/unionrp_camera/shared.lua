ENT.Type = "anim"
ENT.Base = "base_debloat"
ENT.PrintName = "Combine Camera"
ENT.Category = "Альянс"
ENT.Author = "Union"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.nonfreeze = true

ENT.color_idle = Color(0, 255, 0, 255)
ENT.color_lock = Color(255, 150, 0, 255)
ENT.color_angry = Color(255, 0, 0, 255)
ENT.color = ENT.color_idle

ENT.next_ping = 0
ENT.next_move_sound = 0
ENT.next_search = 0

ENT.lock_targets = true
ENT.lock_radius = 256
ENT.lock = false

ENT.take_picture = 0
ENT.refresh_rate = 5

ENT.goal_angle = Angle(0, 0, 0)

ENT.bones = {
	["Combine_Camera.Camera_bone"] = 10,
	["Combine_Camera.Lens"] = 11
}

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Active")
	self:NetworkVar("Angle", 0, "GoalAngle")
	self:NetworkVar("Float", 0, "AimYaw")
	self:NetworkVar("Float", 1, "AimPitch")
	self:NetworkVar("Float", 2, "Sine")
	self:NetworkVar("Float", 3, "SweepSpeed")
end

function ENT:Lock(ent)
	if not IsValid(ent) then return end
	if not self:GetActive() then return end
	self.lock = true
	self.lock_ent = ent
	self.color = self.color_lock
	ent.CameraSpectating = self
	if CLIENT then self:EmitSound("NPC_CombineCamera.Active", 75) end
end

function ENT:Unlock()
	if IsValid(self.lock_ent) then self.lock_ent.CameraSpectating = nil end
	self.lock = false
	self.color = self.color_idle
end

function ENT:Ping()
	local CT = CurTime()
	if CT >= self.next_ping then
		self.next_ping = CT + 3
		self:EmitSound("npc/turret_floor/ping.wav", 58)
	end
end

function ENT:Retract()
	if self.animation then return end
	self:SetActive(false)
	self:SetGoalAngle(angle_zero)
	--self:RenderCameraView(false, true)
	if self.lock and IsValid(self.lock_ent) then self:Unlock() end
	self:PerformSequence("retract", function()
		self:SetAimYaw(0)
		self:SetAimPitch(0)
	end)
end

function ENT:Think()
	-- local CT = CurTime()
	if SERVER then
		self:DoSeqAnims()
	elseif not self:IsDormant() then
		self:HandleLocking()
		if self:GetActive() or self.animation then
			if not self.animation then self:UpdateGoalAngs() end
			self:UpdatePoseParams()
		end

		if self:GetActive() and not self.lock and self.take_picture == 0 then self:Ping() end
	end
	--return true
end

local vector_camInfo = Angle()
function ENT:GetCamInfo()
	vector_camInfo:SetUnpacked(self:GetAimYaw() - 5, self:GetAimPitch(), 0)
	vector_camInfo:Add(self:GetAngles())
	local cam_pos = self:GetBonePosition(self.bones["Combine_Camera.Lens"]) + vector_camInfo:Forward() * 5
	return cam_pos, vector_camInfo
end

function ENT:MaxYawSpeed()
	local DT = self:GetTable()
	if DT.lock and IsValid(DT.lock_ent) or DT.take_picture ~= 0 or DT.animation then return 5 end
	return 2.5
end

-- returns the position the camera would look towards if locked to the entity
function ENT:GetLockPos(ent)
	local obb = ent:OBBCenter()
	local _, _, z = obb:Unpack()
	obb:SetUnpacked(0, 0, z)
	obb:Add(ent:EyePos())
	return obb
end
