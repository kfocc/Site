include("shared.lua")
function ENT:Draw(flags)
	self:DrawModel(flags)
end

local tbl = {}
tbl["MAIN"] = "https://fallout.fm:8000/falloutfm1.ogg"
tbl["DC"] = "https://fallout.fm:8000/falloutfm6.ogg"
tbl["CR"] = "https://fallout.fm:8000/falloutfm7.ogg"
tbl["MWTCF"] = "https://fallout.fm:8000/falloutfm8.ogg"

local maxdist = 300
local maxvol = 0.3
function ENT:Think()
	local ply = LocalPlayer()
	local dist = ply:GetPos():Distance(self:GetPos())
	local index = "DC"
	if dist >= maxdist then return end

	if not self.SoundValid and not IsValid(self.RadioSound) then
		self.SoundValid = true
		local url = tbl[index]
		if IsValid(ply.RadioSound) then ply.RadioSound:Stop() end
		--
		sound.PlayURL(url, "", function(sound, errorid, errorname)
			if not IsValid(sound) then return end
			ply.RadioSound = sound
			sound:Play()
			sound:SetVolume(maxvol)
		end)
		return
	end

	local sound = ply.RadioSound
	if not IsValid(sound) then return end
	local volume = maxvol - maxvol * (dist / maxdist)
	sound:SetVolume(math.Clamp(volume, 0, 1))
end

function ENT:OnRemove()
	local ply = LocalPlayer()
	if IsValid(ply.RadioSound) then ply.RadioSound:SetVolume(0) end
end
