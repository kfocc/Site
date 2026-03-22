if SERVER then
	AddCSLuaFile()
end

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.Equip",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/crovel/palmhit1.wav", "weapons/tfa_kf2/crovel/palmhit2.wav", "weapons/tfa_kf2/crovel/palmhit3.wav", "weapons/tfa_kf2/crovel/palmhit4.wav" },
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.Holster",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/zweihander/sheath_1.wav", "weapons/tfa_kf2/zweihander/sheath_2.wav" },
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.Swing",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/zweihander/swing_light_1.wav", "weapons/tfa_kf2/zweihander/swing_light_2.wav" },
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.SwingHard",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/zweihander/swing_hard_1.wav", "weapons/tfa_kf2/zweihander/swing_hard_2.wav", "weapons/tfa_kf2/zweihander/swing_hard_3.wav", "weapons/tfa_kf2/zweihander/swing_hard_4.wav" },
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.Twirl",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/zweihander/twirl_1.wav", "weapons/tfa_kf2/zweihander/twirl_2.wav" },
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.HitFlesh",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/zweihander/hitflesh_1.wav", "weapons/tfa_kf2/zweihander/hitflesh_2.wav", "weapons/tfa_kf2/zweihander/hitflesh_3.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.HitFleshHard",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/zweihander/hitflesh_1.wav", "weapons/tfa_kf2/zweihander/hitflesh_2.wav", "weapons/tfa_kf2/zweihander/hitflesh_3.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.HitWorld",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/katana_impact_world1.wav", "weapons/tfa_kf2/katana/katana_impact_world2.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_ZWEIHANDER.Block",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/block01.wav", "weapons/tfa_kf2/katana/block02.wav", "weapons/tfa_kf2/katana/block03.wav"},
	["pitch"] = {95, 105}
})