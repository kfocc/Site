include("shared.lua")

local SHIELD_MATERIAL = Material("effects/combineshield/comshieldwall3")
local GetDTInt = FindMetaTable("Entity").GetDTInt

local forcefieldsList = ForceFieldsList or {}
ForceFieldsList = forcefieldsList
function ENT:Initialize()
	self:InitializeMeshes()

	forcefieldsList[self] = true
	hook.Call("OnForceFieldCreated", nil, self)
end

local vector_forward = Vector(1, 0, 0)
local vector_190 = Vector(0, 0, 190)
local vector_150 = Vector(0, 0, 150)
local vector_40 = Vector(0, 0, -40)
local vector_05 = Vector(2, 0, 0)
function ENT:InitializeMeshes()
	local dummy = self:GetDummy()
	if not IsValid(dummy) then return end
	local vertex = self:WorldToLocal(dummy:GetPos())
	local verts = {
		{
			pos = vector_40 - vector_05
		},
		{
			pos = vector_150 - vector_05
		},
		{
			pos = vertex + vector_150 - vector_05
		},
		{
			pos = vertex + vector_150 + vector_05
		},
		{
			pos = vertex + vector_40 + vector_05
		},
		{
			pos = vector_40 + vector_05
		}
	}

	local obj = Mesh()
	local frac = vertex:Length2D() / 45
	mesh.Begin(obj, MATERIAL_QUADS, 1)
	mesh.Position(vector_origin)
	mesh.TexCoord(0, 0, 0)
	mesh.AdvanceVertex()

	mesh.Position(vector_190)
	mesh.TexCoord(0, 0, 5)
	mesh.AdvanceVertex()

	mesh.Position(vertex + vector_190)
	mesh.TexCoord(0, frac, 5)
	mesh.AdvanceVertex()

	mesh.Position(vertex)
	mesh.TexCoord(0, frac, 0)
	mesh.AdvanceVertex()
	mesh.End()

	self:PhysicsFromMesh(verts)
	self:DrawShadow(false)
	timer.Simple(1, function() self:SetRenderBounds(vector_40, vertex + vector_150) end)

	self.mesh = obj
	self.vertex = vertex
end

function ENT:OnRemove()
	forcefieldsList[self] = nil
	hook.Call("OnForceFieldRemoved", nil, self)
end

local cam = cam
local render = render
local NULL = NULL
local mtx = Matrix()
local angle_flip = Angle(0, 180, 0)
function ENT:Draw(flags)
	self:DrawModel(flags)

	if self.vertex and GetDTInt(self, 0) ~= 1 then
		local ply = LocalPlayer()
		local viewer = ply:GetViewEntity()
		if viewer == NULL then viewer = ply end
		local ang = self:GetAngles()
		mtx:SetTranslation(self:GetPos() + vector_40 - ang:Forward() * 1.5)
		mtx:SetAngles(ang)

		if self:WorldToLocal(viewer:GetPos()):Dot(vector_forward) < 0 then
			mtx:Translate(self.vertex)
			mtx:Rotate(angle_flip)
		end

		render.SetMaterial(SHIELD_MATERIAL)
		cam.PushModelMatrix(mtx)
		self.mesh:Draw()
		cam.PopModelMatrix()
	end
end

local offset = Vector(0, 0, -250)
function ENT:Think()
	local physobj = self:GetPhysicsObject()
	if not IsValid(physobj) then self:InitializeMeshes() end
	if not self:GetHacked() then
		self:SetNextClientThink(CurTime() + 1)
		return
	end

	local pos = self:GetPos()
	local emitter = ParticleEmitter(pos)
	for i = 0, 100 do
		local part = emitter:Add("effects/spark", pos)
		if part then
			part:SetDieTime(1)

			part:SetStartAlpha(255)
			part:SetEndAlpha(0)

			part:SetStartSize(5)
			part:SetEndSize(0)

			part:SetGravity(offset)
			part:SetVelocity(VectorRand() * 50)
		end
	end

	emitter:Finish()
	local rand = math.random(1, 4)
	self:SetNextClientThink(CurTime() + rand)
	return true
end

local Team = FindMetaTable("Player").Team
local TEAMS = {
	[TEAM_CITIZEN2] = true,
	[TEAM_CITIZEN3] = true,
	[TEAM_GSR6] = true
}

local function shouldNotCollide(a, b)
	if not b:IsPlayer() then return end
	local iMode = GetDTInt(a, 0) -- a:GetMode()
	if iMode == 1 then -- MODE_ALLOW_ALL
		return true
	end

	if b:isCP() 
		or Team(b) == TEAM_GMAN
		or Team(b) == TEAM_GSPY
		or Team(b) == TEAM_GFAST
		or Team(b) == TEAM_AGENT
		or Team(b) == TEAM_ELITE4 then 
		return true
	end -- Dont support cuffs

	if iMode == 2 then -- MODE_ALLOW_LOYAL
		return TEAMS[Team(b)]
	end
	return false
end

hook.Add("ShouldCollide", "forcefields", function(a, b)
	if forcefieldsList[a] and shouldNotCollide(a, b) then
		return false
	elseif forcefieldsList[b] and shouldNotCollide(b, a) then
		return false
	end
end)
