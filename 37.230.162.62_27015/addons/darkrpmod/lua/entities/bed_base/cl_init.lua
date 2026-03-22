include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	if self.MainBoard then self:CreateMainBoard() end
	self.oneSecondThink = 0
	self.halfSecondThink = 0
end

function ENT:OnRemove()
	self:DeleteRagdoll()
	self:DeleteMainBoard()
end

function ENT:Draw(flags)
	self:DrawModel(flags)
	self:OnDraw()
end

local boardLocalPos = Vector(-50, 0, 45)
function ENT:CreateMainBoard()
	self:DeleteMainBoard()

	local mainBoard = ClientsideModel("models/props/cs_office/tv_plasma.mdl")
	mainBoard:SetParent(self)
	mainBoard:SetLocalAngles(angle_zero)
	mainBoard:SetLocalPos(boardLocalPos)
	mainBoard:Spawn()

	self.mainBoard = mainBoard
end

function ENT:DeleteMainBoard()
	if IsValid(self.mainBoard) then
		self.mainBoard:Remove()
		self.mainBoard = nil
	end
end

local function setBodyGroups(ent, bodyGroups)
	for id, group in pairs(bodyGroups) do
		ent:SetBodygroup(id, group)
	end
end

local function manipulateBoneAngles(bed, ragdoll)
	local entBoneAngles = bed.boneAngles
	for _, data in ipairs(entBoneAngles) do
		local boneIndex = ragdoll:LookupBone(data[1])
		if boneIndex then ragdoll:ManipulateBoneAngles(boneIndex, data[2]) end
	end
end

local ragdollPos = Vector(35, 0, 23)
local ragdollAng = Angle(-90, 0, 0)
function ENT:PlaceRagdoll()
	local ragdollInfo = self:GetRagdollInfo()
	if not ragdollInfo then return end
	self:DeleteRagdoll()

	local playerRagdoll = ClientsideModel(ragdollInfo.model)
	if not IsValid(playerRagdoll) then return end
	playerRagdoll:SetSkin(ragdollInfo.skin)
	playerRagdoll:Spawn()

	playerRagdoll:SetParent(self)
	playerRagdoll:SetLocalPos(ragdollPos)
	playerRagdoll:SetLocalAngles(ragdollAng)

	playerRagdoll:SetCollisionGroup(COLLISION_GROUP_WEAPON)

	playerRagdoll:SetSkin(ragdollInfo.skin)
	setBodyGroups(playerRagdoll, ragdollInfo.bodygroups)
	manipulateBoneAngles(self, playerRagdoll)

	self.playerRagdoll = playerRagdoll

	self:OnPlaceRagdoll()
end

function ENT:DeleteRagdoll()
	if IsValid(self.playerRagdoll) then
		self.playerRagdoll:Remove()
		self.playerRagdoll = nil

		self:OnDeleteRagdoll()
	end
end

function ENT:Think()
	local curTime = CurTime()
	self:OnThink()

	if self.oneSecondThink <= curTime then
		self.oneSecondThink = curTime + 1
		self:OneSecondThink()
	end

	if self.halfSecondThink <= curTime then
		self.halfSecondThink = curTime + 0.5
		self:HalfSecondThink()

		local ragdollInfo = self:GetRagdollInfo()
		if ragdollInfo and not IsValid(self.playerRagdoll) then
			self:PlaceRagdoll()
		elseif not ragdollInfo and IsValid(self.playerRagdoll) then
			self:DeleteRagdoll()
		end
	end

	self:SetNextClientThink(curTime + 0.1)
	return true
end

--[[
	Funcions to override
--]]
function ENT:OnDraw(flags)
end

function ENT:OnThink()
end

function ENT:HalfSecondThink()
end

function ENT:OneSecondThink()
end

function ENT:OnPlaceRagdoll()
end

function ENT:OnDeleteRagdoll()
end
