if SERVER then
	AddCSLuaFile()
end

sound.Add({
	["name"] = "TFA_KF2_KATANA.Equip",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/knife_deploy.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_KATANA.Holster",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/katana_holster.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_KATANA.Swing",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/katana_swing_miss1.wav", "weapons/tfa_kf2/katana/katana_swing_miss2.wav", "weapons/tfa_kf2/katana/katana_swing_miss3.wav", "weapons/tfa_kf2/katana/katana_swing_miss4.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_KATANA.HitFlesh",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/melee_katana_01.wav", "weapons/tfa_kf2/katana/melee_katana_04.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_KATANA.HitFleshHard",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/melee_katana_02.wav", "weapons/tfa_kf2/katana/melee_katana_03.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_KATANA.HitWorld",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/katana_impact_world1.wav", "weapons/tfa_kf2/katana/katana_impact_world2.wav"},
	["pitch"] = {95, 105}
})

sound.Add({
	["name"] = "TFA_KF2_KATANA.Block",
	["channel"] = CHAN_STATIC,
	["sound"] = {"weapons/tfa_kf2/katana/block01.wav", "weapons/tfa_kf2/katana/block02.wav", "weapons/tfa_kf2/katana/block03.wav"},
	["pitch"] = {95, 105}
})