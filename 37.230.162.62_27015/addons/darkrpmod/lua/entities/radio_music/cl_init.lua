include("shared.lua")

function ENT:Draw(flags)
	self:DrawModel(flags)
end

local minDist = 200 * 200
function ENT:Play(snd)
	self:Stop()
	if not snd then return end
	snd = CreateSound(self, snd)
	if snd then
		if LocalPlayer():GetPos():DistToSqr(self:GetPos()) >= minDist then
			snd:ChangeVolume(0)
			self.outPAS = true
		end

		snd:Play()
	end

	self.currentSound = snd
end

function ENT:Stop()
	if self.currentSound then
		self.currentSound:Stop()
		self.currentSound = nil
	end
end

function ENT:IsPlaying()
	return self.currentSound and self.currentSound:IsPlaying()
end

function ENT:OnRemove()
	if self:IsPlaying() then self.currentSound:Stop() end
end

function ENT:Think()
	self:SetNextClientThink(CurTime() + 1)
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) < minDist then
		if not self.outPAS then return end
		self.outPAS = nil
		if self.currentSound then self.currentSound:ChangeVolume(1) end
	else
		if self.outPAS then return end
		self.outPAS = true
		if self:IsPlaying() then self.currentSound:ChangeVolume(0) end
	end
	return
end

netstream.Hook("radioSetSound", function(ent, snd) if IsValid(ent) and ent:GetClass() == "radio_music" then ent:Play(snd) end end)
