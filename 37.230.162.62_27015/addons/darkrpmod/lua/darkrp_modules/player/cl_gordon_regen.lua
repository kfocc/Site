netstream.Hook("gordon.RegenSound", function(snd)
	sound.PlayFile("sound/" .. snd, "mono", function(station)
		if not IsValid(station) then return end
		station:SetVolume(0.7)
		station:Play()
	end)
end)
