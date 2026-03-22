hook.Add("PlayerEnterZone", "AmbientSongPlaza", function(ply, zone)
  if zone != "Главная площадь" then return end

  hook.Remove("PlayerEnterZone", "AmbientSongPlaza")
  if ply:GetNetVar("Zone.Old") == "Холл вокзала" then
    local snd = CreateSound(Entity(0), "song_plaza")
    snd:ChangeVolume(0.6)
    snd:Play()
    timer.Simple(60, function()
      snd:FadeOut(30)
    end)
    timer.Simple(90, function()
      snd:Stop()
    end)
  end
end)