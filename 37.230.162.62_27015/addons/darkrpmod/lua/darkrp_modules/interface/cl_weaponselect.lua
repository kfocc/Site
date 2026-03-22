local replace_sounds = {
    ["common/wpn_moveselect.wav"] = "ambient/weather/rain_drip1.wav",
    ["common/wpn_select.wav"] = "ambient/weather/rain_drip3.wav",
    ["common/wpn_hudoff.wav"] = "ambient/weather/rain_drip2.wav"
}

hook.Add("EntityEmitSound", "OverrideWeaponSelectorSounds", function(data)
    if not data.SoundName then return end
    local newSound = replace_sounds[data.SoundName]
    if newSound then
        data.SoundName = newSound
        data.Volume = 0.3
        data.Pitch = 100
        return true
    end
end)