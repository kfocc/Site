local dist = broadcasts.maxDist
local volume = broadcasts.volume

local currentPlaying = {}
function broadcasts:PlaySound(ent, snd)
	local entPos = ent:GetPos()
	local lpPos = LocalPlayer():GetPos()
	sound.PlayFile("sound/" .. snd, "3d noplay", function(station, errCode, errStr)
		if not IsValid(station) then return end
		currentPlaying[ent] = station
		station:SetPos(entPos)
		station:Set3DFadeDistance(768, 1024)
		if lpPos:DistToSqr(entPos) > dist then
			station:SetVolume(0.0)
		else
			station:SetVolume(volume)
		end

		station:Play()
	end)
end

local speakers = {}
netstream.Hook("broadcast.PlayRandom", function(snd)
	for _, ent in ipairs(speakers) do
		broadcasts:PlaySound(ent, snd)
	end
end)

hook.Add("OnEntityCreated", "broadcast.Speakers", function(ent)
	if not IsValid(ent) then return end
	if ent:GetModel() ~= broadcasts.speakerModel then return end
	table.insert(speakers, ent)
end)

hook.Add("EntityRemoved", "broadcast.Speakers", function(ent)
	if not IsValid(ent) then return end
	if ent:GetModel() ~= broadcasts.speakerModel then return end

	currentPlaying[ent] = nil

	for index, _ent in ipairs(speakers) do
		if ent == _ent then
			table.remove(speakers, index)
			return
		end
	end
end)

hook.Add("InitPostEntity", "broadcast.Speakers", function()
	timer.Create("broadcast.Speakers", 1, 0, function()
		local lpPos = LocalPlayer():GetPos()
		for k, v in pairs(currentPlaying) do
			if not IsValid(k) or not v:IsValid() then
				currentPlaying[k] = nil
				continue
			end

			local entPos = k:GetPos()
			if lpPos:DistToSqr(entPos) > dist then
				v:SetVolume(0.0)
			else
				v:SetVolume(volume)
			end
		end
	end)
end)
