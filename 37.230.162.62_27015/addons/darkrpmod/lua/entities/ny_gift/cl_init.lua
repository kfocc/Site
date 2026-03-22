include("shared.lua")

surface.CreateFont("NYGiftFont", {
	font = "Inter",
	size = 32,
	weight = 700,
	extended = true,
	shadow = true
})

local amplitude = 4
local frequency = 2
local offset = 20
function ENT:Draw(flags)
	local ang = Angle(0, RealTime() * 100 % 360, 0)
	self:SetAngles(ang)
	self:DrawModel(flags)
	local pos = self:GetPos()
	local nameplate_pos = pos + Vector(0, 0, math.sin(RealTime() * frequency) * amplitude + offset)
	local nameplate_ang = LocalPlayer():EyeAngles()
	nameplates.DrawNameplate({
		ent = self,
		position = nameplate_pos,
		angle = nameplate_ang,
		maxDistance = 512,
		lookCenter = self:LocalToWorld(self:OBBCenter()),
		aimThreshold = math.pi / 6,
		func = function(uiSize)
			draw.SimpleText("НОВОГОДНИЙ ПОДАРОК", "NYGiftFont", 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	})
end

local url = "https://www.myinstants.com/media/sounds/free-bird-solo.mp3"
function ENT:StartMusic()
	if self.sound == true or IsValid(self.sound) then return end
	self.sound = true
	sound.PlayURL(url, "3d noblock", function(station)
		if IsValid(station) then
			if not IsValid(self) or not self.sound then
				station:Stop()
				return
			end
			station:SetPos(self:GetPos())
			--station:Set3DFadeDistance(512, 1024)
			station:EnableLooping(true)
			station:Play()
			self.sound = station
			self:CallOnRemove("StopMusic", function()
				self:StopMusic()
			end)
		end
	end)
end

function ENT:StopMusic()
	if self.sound then
		if self.sound ~= true then
			self.sound:Stop()
		end
		self.sound = nil
	end
	self:RemoveCallOnRemove("StopMusic")
end

function ENT:Think()
	self:NextThink(CurTime() + 0.1)
	if self:GetPos():Distance(LocalPlayer():GetPos()) > 512 then
		self:StopMusic()
	else
		self:StartMusic()
	end
	return true
end