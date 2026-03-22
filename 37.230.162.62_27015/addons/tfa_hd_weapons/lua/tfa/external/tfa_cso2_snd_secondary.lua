
--AF2011A0
TFA.AddFireSound( "tfa_cso2_af2011a0.1", "tfa_cso2/weapons/af2011a0/af2011a0-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_af2011a0.Clipout", "tfa_cso2/weapons/af2011a0/af2011a0_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_af2011a0.Throw", "tfa_cso2/weapons/af2011a0/af2011a0_throw.wav")
TFA.AddWeaponSound( "tfa_cso2_af2011a0.Boltpull", "tfa_cso2/weapons/af2011a0/af2011a0_reload.wav")
TFA.AddWeaponSound( "tfa_cso2_af2011a0.Draw", "tfa_cso2/weapons/af2011a0/af2011a0_draw.wav")

--AF2011A1
TFA.AddFireSound( "tfa_cso2_af2011a1.1", "tfa_cso2/weapons/af2011a1/af2011a1-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_af2011a1.Clipout", "tfa_cso2/weapons/af2011a1/af2011a1_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_af2011a1.Clipin", "tfa_cso2/weapons/af2011a1/af2011a1_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_af2011a1.Slideback", "tfa_cso2/weapons/af2011a1/af2011a1_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_af2011a1.Draw", "tfa_cso2/weapons/af2011a1/af2011a1_draw.wav")

--Anaconda
TFA.AddFireSound( "tfa_cso2_anaconda.1", "tfa_cso2/weapons/anaconda/anaconda-1.wav", true, "^" )

TFA.AddWeaponSound( "tfa_cso2_anaconda.Shellout", "tfa_cso2/weapons/anaconda/anaconda_shell_out.wav")
TFA.AddWeaponSound( "tfa_cso2_anaconda.Shellin", "tfa_cso2/weapons/anaconda/anaconda_shell_in.wav")
TFA.AddWeaponSound( "tfa_cso2_anaconda.Open", "tfa_cso2/weapons/anaconda/anaconda_open.wav")
TFA.AddWeaponSound( "tfa_cso2_anaconda.Close", "tfa_cso2/weapons/anaconda/anaconda_close.wav")
TFA.AddWeaponSound( "tfa_cso2_anaconda.Draw", "tfa_cso2/weapons/anaconda/anaconda_draw.wav")

--AR57
TFA.AddFireSound( "tfa_cso2_ar57.1", "tfa_cso2/weapons/ar57/ar57-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_ar57.Clipout", "tfa_cso2/weapons/ar57/ar57_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_ar57.Clipin", "tfa_cso2/weapons/ar57/ar57_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_ar57.Draw", "tfa_cso2/weapons/ar57/ar57_draw.wav")

--Knife
TFA.AddFireSound( "tfa_cso2_knife.Deploy", "tfa_cso2/weapons/knife/knife_deploy1.wav", true )
TFA.AddFireSound( "tfa_cso2_knife.Stab", "tfa_cso2/weapons/knife/knife_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_knife.Slash", { "tfa_cso2/weapons/knife/knife_slash1.wav", "tfa_cso2/weapons/knife/knife_slash2.wav" }, true )
TFA.AddFireSound( "tfa_cso2_knife.Hit", { "tfa_cso2/weapons/knife/knife_hit1.wav", "tfa_cso2/weapons/knife/knife_hit2.wav", "tfa_cso2/weapons/knife/knife_hit3.wav", "tfa_cso2/weapons/knife/knife_hit4.wav" }, true )
TFA.AddFireSound( "tfa_cso2_knife.Hitwall", "tfa_cso2/weapons/knife/knife_hitwall1.wav", true )

--C4
TFA.AddFireSound( "tfa_cso2_c4.1", "tfa_cso2/weapons/c4/c4_plant.wav", false )
sound.Add( {
	name = "tfa_cso2_c4.Explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = ")tfa_cso2/weapons/c4/c4_explode1.wav"
} )
sound.Add( {
	name = "tfa_cso2_c4.beep",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = 100,
	sound = ")tfa_cso2/weapons/c4/c4_beep1.wav"
} )

TFA.AddWeaponSound( "tfa_cso2_c4.Click0", "tfa_cso2/weapons/c4/c4_click0.wav")
TFA.AddWeaponSound( "tfa_cso2_c4.Click3", "tfa_cso2/weapons/c4/c4_click3.wav")
TFA.AddWeaponSound( "tfa_cso2_c4.Click5", "tfa_cso2/weapons/c4/c4_click5.wav")
TFA.AddWeaponSound( "tfa_cso2_c4.Click6", "tfa_cso2/weapons/c4/c4_click6.wav")
TFA.AddWeaponSound( "tfa_cso2_c4.Click7", "tfa_cso2/weapons/c4/c4_click7.wav")
TFA.AddWeaponSound( "tfa_cso2_c4.Click8", "tfa_cso2/weapons/c4/c4_click8.wav")

--CSLS06 /  CS06
TFA.AddFireSound( "tfa_cso2_csls06.1", "tfa_cso2/weapons/csls06/csls06-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_csls06.Boltpull", "tfa_cso2/weapons/csls06/csls06_boltpull.wav")
TFA.AddWeaponSound( "tfa_cso2_csls06.Clipout", "tfa_cso2/weapons/csls06/csls06_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_csls06.Clipin", "tfa_cso2/weapons/csls06/csls06_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_csls06.Draw", "tfa_cso2/weapons/csls06/csls06_draw.wav")


--Crowbar
TFA.AddFireSound( "tfa_cso2_crowbar.Draw", "tfa_cso2/weapons/crowbar/crowbar_draw.wav", true )
TFA.AddFireSound( "tfa_cso2_crowbar.Stab", "tfa_cso2/weapons/crowbar/crowbar_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_crowbar.Stabmiss", "tfa_cso2/weapons/crowbar/crowbar_stabmiss.wav", true )
TFA.AddFireSound( "tfa_cso2_crowbar.Attack01", "tfa_cso2/weapons/crowbar/crowbar_attack_1.wav", true )
TFA.AddFireSound( "tfa_cso2_crowbar.Attack02", "tfa_cso2/weapons/crowbar/crowbar_attack_2.wav", true )
TFA.AddFireSound( "tfa_cso2_crowbar.Hit", { "tfa_cso2/weapons/knife/knife_hit1.wav", "tfa_cso2/weapons/knife/knife_hit2.wav", "tfa_cso2/weapons/knife/knife_hit3.wav", "tfa_cso2/weapons/knife/knife_hit4.wav" }, true )
TFA.AddFireSound( "tfa_cso2_crowbar.Hitwall", "tfa_cso2/weapons/knife/knife_hitwall1.wav", true )

--DDEP
TFA.AddFireSound( "tfa_cso2_ddep.1", "tfa_cso2/weapons/deaglephoenix/deaglephoenix-2.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_ddep.Draw", "tfa_cso2/weapons/deaglephoenix/ddep_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_ddep.Clipout", "tfa_cso2/weapons/deaglephoenix/ddep_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_ddep.RightHand.Clipin", "tfa_cso2/weapons/deaglephoenix/ddep_right_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_ddep.LeftHand.Clipin", "tfa_cso2/weapons/deaglephoenix/ddep_left_clipin.wav")

--DEP
TFA.AddFireSound( "tfa_cso2_dep.1", "tfa_cso2/weapons/deaglephoenix/deaglephoenix-2.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_dep.Draw", "tfa_cso2/weapons/deaglephoenix/dep_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_dep.Clipout", "tfa_cso2/weapons/deaglephoenix/dep_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_dep.Clipin", "tfa_cso2/weapons/deaglephoenix/dep_clipin.wav")

--Desert Eagle / Deagle
TFA.AddFireSound( "tfa_cso2_deagle.1", "tfa_cso2/weapons/deagle/deagle-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_deagle.Deploy", "tfa_cso2/weapons/deagle/de_deploy.wav")
TFA.AddWeaponSound( "tfa_cso2_deagle.Clipout", "tfa_cso2/weapons/deagle/de_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_deagle.Clipin", "tfa_cso2/weapons/deagle/de_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_deagle.Slideback", "tfa_cso2/weapons/deagle/de_slideback.wav")

--elite
TFA.AddFireSound( "tfa_cso2_elite.1", "tfa_cso2/weapons/elite/elite-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_elite.Deploy", "tfa_cso2/weapons/elite/elite_deploy.wav")
TFA.AddWeaponSound( "tfa_cso2_elite.Reloadstart", "tfa_cso2/weapons/elite/elite_reloadstart.wav")
TFA.AddWeaponSound( "tfa_cso2_elite.Clipout", "tfa_cso2/weapons/elite/elite_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_elite.Rclipin", "tfa_cso2/weapons/elite/elite_rightclipin.wav")
TFA.AddWeaponSound( "tfa_cso2_elite.Lclipin", "tfa_cso2/weapons/elite/elite_leftclipin.wav")
TFA.AddWeaponSound( "tfa_cso2_elite.Sliderelease", "tfa_cso2/weapons/elite/elite_sliderelease.wav")

--Firework
TFA.AddFireSound( "fbfirework.Pullpin", "tfa_cso2/weapons/fbfirework/fbfirework_pullpin.wav", true )
TFA.AddFireSound( "fbfirework.Throw", "tfa_cso2/weapons/fbfirework/fbfirework_throw.wav", true )

sound.Add( {
	name = "fbfirework.Idle",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 70,
	pitch = 100,
	sound = ")tfa_cso2/weapons/fbfirework/fbfirework_idle1.wav"
} )

sound.Add( {
	name = "fbfirework.Explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/hegrenade/newyear_event_hegrenade_explode_1.wav", ")tfa_cso2/weapons/hegrenade/newyear_event_hegrenade_explode_2.wav", ")tfa_cso2/weapons/hegrenade/newyear_event_hegrenade_explode_3.wav" }
} )
sound.Add( {
	name = "fbfirework_wm.Loop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = 100,
	sound =  ")tfa_cso2/weapons/fbfirework/fbfirework_idle2.wav"
} )

--FiveSeven/Five-Seven/57
TFA.AddFireSound( "tfa_cso2_fiveseven.1", "tfa_cso2/weapons/fiveseven/fiveseven-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_fiveseven.Deploy", "tfa_cso2/weapons/fiveseven/fiveseven_deploy.wav")
TFA.AddWeaponSound( "tfa_cso2_fiveseven.Clipout", "tfa_cso2/weapons/fiveseven/fiveseven_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_fiveseven.Clipin", "tfa_cso2/weapons/fiveseven/fiveseven_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_fiveseven.Slideback", "tfa_cso2/weapons/fiveseven/fiveseven_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_fiveseven.Slidepull", "tfa_cso2/weapons/fiveseven/fiveseven_slidepull.wav")
TFA.AddWeaponSound( "tfa_cso2_fiveseven.Sliderelease", "tfa_cso2/weapons/fiveseven/fiveseven_sliderelease.wav")

--Flasbang/smoke/normalnade/hegrenade/fraggrenade
TFA.AddWeaponSound( "tfa_cso2.Pullpin_grenade", "tfa_cso2/weapons/pinpull.wav")

sound.Add( {
	name = "tfa_cso2_flashbang.Explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/flashbang/flashbang_explode1.wav", ")tfa_cso2/weapons/flashbang/flashbang_explode2.wav" }
} )

sound.Add( {
	name = "tfa_cso2_flashbang.Bounce",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/flashbang/grenade_hit1.wav", ")tfa_cso2/weapons/flashbang/grenade_hit2.wav", ")tfa_cso2/weapons/flashbang/grenade_hit3.wav" }
} )

sound.Add( {
	name = "tfa_cso2_fraggrenade.Explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/hegrenade/explode3.wav", ")tfa_cso2/weapons/hegrenade/explode4.wav", ")tfa_cso2/weapons/hegrenade/explode5.wav" }
} )

sound.Add( {
	name = "tfa_cso2_fraggrenade.Bounce",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 70,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/hegrenade/he_bounce1.wav", ")tfa_cso2/weapons/hegrenade/he_bounce2.wav", ")tfa_cso2/weapons/hegrenade/he_bounce3.wav" }
} )

--GlocK18
TFA.AddFireSound( "tfa_cso2_glock.1", "tfa_cso2/weapons/glock/glock18-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_glock.Deploy", "tfa_cso2/weapons/glock/glock_deploy.wav")
TFA.AddWeaponSound( "tfa_cso2_glock.Clipout", "tfa_cso2/weapons/glock/glock_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_glock.Clipin", "tfa_cso2/weapons/glock/glock_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_glock.Slideback", "tfa_cso2/weapons/glock/glock_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_glock.Sliderelease", "tfa_cso2/weapons/glock/glock_sliderelease.wav")

--Harpoon
TFA.AddFireSound( "tfa_cso2_harpoon.Draw", "tfa_cso2/weapons/harpoon/harpoon_draw.wav", true )
TFA.AddFireSound( "tfa_cso2_harpoon.Stab01", "tfa_cso2/weapons/harpoon/harpoon_stab_1.wav", true )
TFA.AddFireSound( "tfa_cso2_harpoon.Stab02", "tfa_cso2/weapons/harpoon/harpoon_stab_2.wav", true )
TFA.AddFireSound( "tfa_cso2_harpoon.Stabmiss", "tfa_cso2/weapons/harpoon/harpoon_stabmiss.wav", true )
TFA.AddFireSound( "tfa_cso2_harpoon.Midslash01",  "tfa_cso2/weapons/harpoon/harpoon_midslash_1.wav", true )
TFA.AddFireSound( "tfa_cso2_harpoon.Midslash02", "tfa_cso2/weapons/harpoon/harpoon_midslash_2.wav", true )
TFA.AddFireSound( "tfa_cso2_harpoon.Hit", { "tfa_cso2/weapons/knife/knife_hit1.wav", "tfa_cso2/weapons/knife/knife_hit2.wav", "tfa_cso2/weapons/knife/knife_hit3.wav", "tfa_cso2/weapons/knife/knife_hit4.wav" }, true )
TFA.AddFireSound( "tfa_cso2_harpoon.Hitwall", "tfa_cso2/weapons/knife/knife_hitwall1.wav", true )

--Heart Grenade / Valentine Grenade
TFA.AddWeaponSound( "ValentineGrenade.Pullpin", "tfa_cso2/weapons/valentine_grenade/valentine_grenade_pullpin2.wav", false )
TFA.AddWeaponSound( "ValentineGrenade.Throw", "tfa_cso2/weapons/valentine_grenade/valentine_grenade_throw2.wav", false )
TFA.AddWeaponSound( "ValentineGrenade.Draw", "tfa_cso2/weapons/valentine_grenade/valentine_grenade_draw.wav", false )

sound.Add( {
	name = "ValentineGrenade.Explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/valentine_grenade/valentine_grenade_explode1.wav", ")tfa_cso2/weapons/valentine_grenade/valentine_grenade_explode2.wav", ")tfa_cso2/weapons/valentine_grenade/valentine_grenade_explode3.wav", ")tfa_cso2/weapons/valentine_grenade/valentine_grenade_explode4.wav" }
} )

--Hunting knife
TFA.AddFireSound( "tfa_cso2_huntknife.Deploy", "tfa_cso2/weapons/huntknife/huntknife_deploy.wav", true )
TFA.AddFireSound( "tfa_cso2_huntknife.Stab", "tfa_cso2/weapons/huntknife/huntknife_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_huntknife.Slash", { "tfa_cso2/weapons/huntknife/huntknife_slash1.wav", "tfa_cso2/weapons/huntknife/huntknife_slash2.wav", "tfa_cso2/weapons/huntknife/huntknife_slash3.wav" }, true )
TFA.AddFireSound( "tfa_cso2_huntknife.Hit", { "tfa_cso2/weapons/huntknife/huntknife_hit1.wav", "tfa_cso2/weapons/huntknife/huntknife_hit2.wav", "tfa_cso2/weapons/huntknife/huntknife_hit3.wav", "tfa_cso2/weapons/huntknife/huntknife_hit4.wav" }, true )

--K1a
TFA.AddFireSound( "tfa_cso2_k1a.1", "tfa_cso2/weapons/k1/k1-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_k1.Clipout", "tfa_cso2/weapons/k1/k1_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_k1.Clipin", "tfa_cso2/weapons/k1/k1_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_k1.Boltpull", "tfa_cso2/weapons/k1/k1_boltpull.wav")
TFA.AddWeaponSound( "tfa_cso2_k1.Draw", "tfa_cso2/weapons/k1/k1_draw.wav")
TFA.AddFireSound( "tfa_cso2_huntknife.Hitwall", "tfa_cso2/weapons/huntknife/huntknife_hitwall1.wav", true )


--K5
TFA.AddFireSound( "tfa_cso2_k5.1", "tfa_cso2/weapons/k5/k5-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_k5.Draw", "tfa_cso2/weapons/k5/k5_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_k5.Clipout", "tfa_cso2/weapons/k5/k5_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_k5.Clipin", "tfa_cso2/weapons/k5/k5_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_k5.Sliderelease", "tfa_cso2/weapons/k5/k5_sliderelease.wav")

--Kriss Vector / Kriss Super V / KrissV / Kriss-V
TFA.AddFireSound( "tfa_cso2_kriss_superv.1", "tfa_cso2/weapons/kriss_superv/kriss_superv-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_kriss_superv.Clipout", "tfa_cso2/weapons/kriss_superv/kriss_superv_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_kriss_superv.Clipin", "tfa_cso2/weapons/kriss_superv/kriss_superv_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_kriss_superv.Reload", "tfa_cso2/weapons/kriss_superv/kriss_superv_reload.wav")
TFA.AddWeaponSound( "tfa_cso2_kriss_superv.Draw", "tfa_cso2/weapons/kriss_superv/kriss_superv_draw.wav")

--Knife Woman / Knife_Woman
TFA.AddFireSound( "tfa_cso2_knife_woman.Deploy", "tfa_cso2/weapons/knife_woman/knife_woman_deploy1.wav", true )
TFA.AddFireSound( "tfa_cso2_knife_woman.Stab", "tfa_cso2/weapons/knife_woman/knife_stab_w.wav", true )
TFA.AddFireSound( "tfa_cso2_knife_woman.Slash", { "tfa_cso2/weapons/knife_woman/knife_woman_slash1.wav", "tfa_cso2/weapons/knife_woman/knife_woman_slash2.wav" }, true )
TFA.AddFireSound( "tfa_cso2_knife_woman.Hit", { "tfa_cso2/weapons/knife/knife_hit1.wav", "tfa_cso2/weapons/knife/knife_hit2.wav", "tfa_cso2/weapons/knife/knife_hit3.wav", "tfa_cso2/weapons/knife/knife_hit4.wav" }, true )
TFA.AddFireSound( "tfa_cso2_knife_woman.Hitwall", "tfa_cso2/weapons/knife/knife_hitwall1.wav", true )

--Mac10
TFA.AddFireSound( "tfa_cso2_mac10.1", "tfa_cso2/weapons/mac10/mac10-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mac10.Boltpull", "tfa_cso2/weapons/mac10/mac10_boltpull.wav")
TFA.AddWeaponSound( "tfa_cso2_mac10.Clipout", "tfa_cso2/weapons/mac10/mac10_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mac10.Clipin", "tfa_cso2/weapons/mac10/mac10_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mac10.Grab", "tfa_cso2/weapons/mac10/mac10_grab.wav")
TFA.AddWeaponSound( "tfa_cso2_mac10.Draw", "tfa_cso2/weapons/mac10/mac10_draw.wav")

--MP5 Navy
TFA.AddFireSound( "tfa_cso2_mp5navy.1", "tfa_cso2/weapons/mp5navy/mp5-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mp5navy.Clipout", "tfa_cso2/weapons/mp5navy/mp5_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mp5navy.Clipin", "tfa_cso2/weapons/mp5navy/mp5_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mp5navy.Draw", "tfa_cso2/weapons/mp5navy/mp5_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_mp5navy.Mag", "tfa_cso2/weapons/mp5navy/mp5_mag.wav")
TFA.AddWeaponSound( "tfa_cso2_mp5navy.Slideback", "tfa_cso2/weapons/mp5navy/mp5_slideback.wav")

--MP7A1
TFA.AddFireSound( "tfa_cso2_mp7.1", "tfa_cso2/weapons/mp7/mp7-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mp7.Clipon", "tfa_cso2/weapons/mp7/mp7_clipon.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7.Clipin", "tfa_cso2/weapons/mp7/mp7_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7.Clippush", "tfa_cso2/weapons/mp7/mp7_clippush.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7.Clipout", "tfa_cso2/weapons/mp7/mp7_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7.Draw", "tfa_cso2/weapons/mp7/mp7_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7.Pullbar", "tfa_cso2/weapons/mp7/mp7_pullbar.wav")

--MP7 Phoenix
TFA.AddFireSound( "tfa_cso2_mp7phoenix.1", "tfa_cso2/weapons/mp7phoenix/mp7phoenix-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Cliphit", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_cliphit.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Clipin", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Clipout", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Reload01", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_reload01.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Reload02", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_reload02.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Draw", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_draw.wav")

TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Skilled.Reload", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_skilled_reload.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Skilled.Clipout", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_skilled_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Skilled.Clipin", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_skilled_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mp7phoenix.Skilled.Draw", "tfa_cso2/weapons/mp7phoenix/mp7phoenix_skilled_draw.wav")

--Mx4
TFA.AddFireSound( "tfa_cso2_mx4.1", "tfa_cso2/weapons/mx4/mx4-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mx4.Clipout", "tfa_cso2/weapons/mx4/mx4_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mx4.Clipin", "tfa_cso2/weapons/mx4/mx4_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mx4.Boltpull", "tfa_cso2/weapons/mx4/mx4_boltpull.wav")
TFA.AddWeaponSound( "tfa_cso2_mx4.Draw", "tfa_cso2/weapons/mx4/mx4_draw.wav")

--P90
TFA.AddFireSound( "tfa_cso2_p90.1", "tfa_cso2/weapons/p90/p90-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_p90.Clipout", "tfa_cso2/weapons/p90/p90_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_p90.Clipin", "tfa_cso2/weapons/p90/p90_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_p90.Cliprelease", "tfa_cso2/weapons/p90/p90_cliprelease.wav")
TFA.AddWeaponSound( "tfa_cso2_p90.Boltpull", "tfa_cso2/weapons/p90/p90_boltpull.wav")

--Chicken Knife / Knife Chicken / Knife 2017 Chicken
TFA.AddFireSound( "tfa_cso2_knife_2017chicken.Draw", "tfa_cso2/weapons/knife_2017chicken/knife_2017chicken_draw.wav", true )

--M1911-A1 ( thanks glob lol )
TFA.AddFireSound( "tfa_cso2_m1911a1.1", "tfa_cso2/weapons/m1911a1/m1911a1-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_m1911a1.Clipout", "tfa_cso2/weapons/m1911a1/m1911a1_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_m1911a1.Clipin", "tfa_cso2/weapons/m1911a1/m1911a1_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_m1911a1.Sliderelease", "tfa_cso2/weapons/m1911a1/m1911a1_sliderelease.wav")
TFA.AddWeaponSound( "tfa_cso2_m1911a1.Draw", "tfa_cso2/weapons/m1911a1/m1911a1_draw.wav")

--M9 Bayonet
TFA.AddWeaponSound( "tfa_cso2_m9bayonet.Deploy", "tfa_cso2/weapons/m9bayonet/m9bayonet_draw.wav")

--Micknife
TFA.AddFireSound( "tfa_cso2_micknife.Draw", "tfa_cso2/weapons/micknife/micknife_draw.wav", true )
TFA.AddFireSound( "tfa_cso2_micknife.Stab", "tfa_cso2/weapons/micknife/micknife_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_micknife.Stabmiss", "tfa_cso2/weapons/micknife/micknife_stabmiss.wav", true )
TFA.AddFireSound( "tfa_cso2_micknife.Attack01", "tfa_cso2/weapons/micknife/micknife_midslash01.wav", true )
TFA.AddFireSound( "tfa_cso2_micknife.Attack02", "tfa_cso2/weapons/micknife/micknife_midslash02.wav", true )

--Mk23
TFA.AddFireSound( "tfa_cso2_mk23.1", "tfa_cso2/weapons/mk23_socom/mk23_unsil-1.wav", false, "^" )
TFA.AddFireSound( "tfa_cso2_mk23.2", "tfa_cso2/weapons/mk23_socom/mk23-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_mk23.Clipout", "tfa_cso2/weapons/mk23_socom/mk23_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_mk23.Clipin", "tfa_cso2/weapons/mk23_socom/mk23_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_mk23.Draw", "tfa_cso2/weapons/mk23_socom/mk23_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_mk23.Slideback", "tfa_cso2/weapons/mk23_socom/mk23_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_mk23.Sliderelease", "tfa_cso2/weapons/mk23_socom/mk23_sliderelease.wav")
TFA.AddWeaponSound( "tfa_cso2_mk23.Detachsilencer", "tfa_cso2/weapons/mk23_socom/mk23_detachsilencer.wav")
TFA.AddWeaponSound( "tfa_cso2_mk23.Attachsilencer", "tfa_cso2/weapons/mk23_socom/mk23_attachsilencer.wav")

--P228
TFA.AddFireSound( "tfa_cso2_p228.1", "tfa_cso2/weapons/p228/p228-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_p228.Clipout", "tfa_cso2/weapons/p228/p228_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_p228.Clipin", "tfa_cso2/weapons/p228/p228_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_p228.Sliderelease", "tfa_cso2/weapons/p228/p228_sliderelease.wav")
TFA.AddWeaponSound( "tfa_cso2_p228.Slideback", "tfa_cso2/weapons/p228/p228_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_p228.Slidepull", "tfa_cso2/weapons/p228/p228_slidepull.wav")

--Pickax
TFA.AddFireSound( "tfa_cso2_pickax.Draw", "tfa_cso2/weapons/pickax/pickax_draw.wav", false )
TFA.AddFireSound( "tfa_cso2_pickax.Stab", "tfa_cso2/weapons/pickax/pickax_stab.wav", false )
TFA.AddFireSound( "tfa_cso2_pickax.Idle", "tfa_cso2/weapons/pickax/pickax_idle.wav", false )
TFA.AddFireSound( "tfa_cso2_pickax.Stabmiss", "tfa_cso2/weapons/pickax/pickax_stabmiss.wav", false )
TFA.AddFireSound( "tfa_cso2_pickax.Attack01", "tfa_cso2/weapons/pickax/pickax_attack01.wav", false )
TFA.AddFireSound( "tfa_cso2_pickax.Attack02", "tfa_cso2/weapons/pickax/pickax_attack02.wav", false )

--QsZ92
TFA.AddFireSound( "tfa_cso2_qsz92.1", "tfa_cso2/weapons/qsz92/qsz92-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_qsz92.Draw", "tfa_cso2/weapons/qsz92/qsz92_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_qsz92.Clipout", "tfa_cso2/weapons/qsz92/qsz92_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_qsz92.Clipin", "tfa_cso2/weapons/qsz92/qsz92_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_qsz92.Sliderelease", "tfa_cso2/weapons/qsz92/qsz92_sliderelease.wav")

--Smoke Grenade

sound.Add( {
	name = "tfa_cso2_smokegrenade.Explode",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 140,
	pitch = 100,
	sound = { ")tfa_cso2/weapons/smokegrenade/sg_explode.wav" }
} )

--Taser Knife
TFA.AddFireSound( "tfa_cso2_taserknife.Deploy", "tfa_cso2/weapons/taserknife/taserknife_deploy.wav", true )
TFA.AddFireSound( "tfa_cso2_taserknife.Stab", "tfa_cso2/weapons/taserknife/taserknife_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_taserknife.Slash", { "tfa_cso2/weapons/taserknife/taserknife_slash1.wav", "tfa_cso2/weapons/taserknife/taserknife_slash2.wav", "tfa_cso2/weapons/taserknife/taserknife_slash3.wav" }, true )
TFA.AddFireSound( "tfa_cso2_taserknife.Hit", { "tfa_cso2/weapons/taserknife/taserknife_hit1.wav", "tfa_cso2/weapons/taserknife/taserknife_hit2.wav", "tfa_cso2/weapons/taserknife/taserknife_hit3.wav", "tfa_cso2/weapons/taserknife/taserknife_hit4.wav" }, true )

--Thunder
TFA.AddFireSound( "tfa_cso2_thunder.1", "tfa_cso2/weapons/thunder/thunder-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_thunder.Clipout", "tfa_cso2/weapons/thunder/thunder_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_thunder.Clipin", "tfa_cso2/weapons/thunder/thunder_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_thunder.Draw", "tfa_cso2/weapons/thunder/thunder_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_thunder.Boltpull", "tfa_cso2/weapons/thunder/thunder_boltpull.wav")

--TMP
TFA.AddFireSound( "tfa_cso2_tmp.1", "tfa_cso2/weapons/tmp/tmp-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_tmp.Clipout", "tfa_cso2/weapons/tmp/tmp_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_tmp.Clipin", "tfa_cso2/weapons/tmp/tmp_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_tmp.Draw", "tfa_cso2/weapons/tmp/tmp_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_tmp.Boltpull", "tfa_cso2/weapons/tmp/tmp_boltpull.wav")

--Toyhammer
TFA.AddFireSound( "tfa_cso2_toyhammer.Draw", "tfa_cso2/weapons/toyhammer/toyhammer_draw.wav", true )
TFA.AddFireSound( "tfa_cso2_toyhammer.Stab", "tfa_cso2/weapons/toyhammer/toyhammer_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_toyhammer.Stabmiss", "tfa_cso2/weapons/toyhammer/toyhammer_stabmiss.wav", true )
TFA.AddFireSound( "tfa_cso2_toyhammer.Attack01", "tfa_cso2/weapons/toyhammer/toyhammer_attack01.wav", true )
TFA.AddFireSound( "tfa_cso2_toyhammer.Attack02", "tfa_cso2/weapons/toyhammer/toyhammer_attack02.wav", true )
TFA.AddFireSound( "tfa_cso2_toyhammer.Hit", "tfa_cso2/weapons/toyhammer/toyhammer_stab_hit.wav", true )
TFA.AddFireSound( "tfa_cso2_toyhammer.Hitwall", { "tfa_cso2/weapons/toyhammer/toyhammer_attack_hit_1.wav", "tfa_cso2/weapons/toyhammer/toyhammer_attack_hit_2.wav" }, true )

--Usp
TFA.AddFireSound( "tfa_cso2_usp.1", "tfa_cso2/weapons/usp/usp_unsil-1.wav", false, "^" )
TFA.AddFireSound( "tfa_cso2_usp.2", "tfa_cso2/weapons/usp/usp1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_usp.Clipout", "tfa_cso2/weapons/usp/usp_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Clipin", "tfa_cso2/weapons/usp/usp_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Draw", "tfa_cso2/weapons/usp/usp_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Slideback", "tfa_cso2/weapons/usp/usp_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Sliderelease", "tfa_cso2/weapons/usp/usp_sliderelease.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Detachsilencer", "tfa_cso2/weapons/usp/usp_silencer_off.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Attachsilencer", "tfa_cso2/weapons/usp/usp_silencer_on.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Spinsoft", "tfa_cso2/weapons/usp/usp_spin_hard.wav")
TFA.AddWeaponSound( "tfa_cso2_usp.Spinhard", "tfa_cso2/weapons/usp/usp_spin_soft.wav")

--UMP45
TFA.AddFireSound( "tfa_cso2_ump45.1", "tfa_cso2/weapons/ump45/ump45-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_ump45.Clipin", "tfa_cso2/weapons/ump45/ump45_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_ump45.Clipout", "tfa_cso2/weapons/ump45/ump45_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_ump45.Boltslap", "tfa_cso2/weapons/ump45/ump45_boltslap.wav")

--Walther PP / WaltherPP
TFA.AddFireSound( "tfa_cso2_waltherpp.1", "tfa_cso2/weapons/waltherpp/waltherpp-1.wav", false, "^" )

TFA.AddWeaponSound( "tfa_cso2_waltherpp.Deploy", "tfa_cso2/weapons/waltherpp/waltherpp_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_waltherpp.Clipout", "tfa_cso2/weapons/waltherpp/waltherpp_clipout.wav")
TFA.AddWeaponSound( "tfa_cso2_waltherpp.Clipin", "tfa_cso2/weapons/waltherpp/waltherpp_clipin.wav")
TFA.AddWeaponSound( "tfa_cso2_waltherpp.Slideback", "tfa_cso2/weapons/waltherpp/waltherpp_slideback.wav")
TFA.AddWeaponSound( "tfa_cso2_waltherpp.Slidepull", "tfa_cso2/weapons/waltherpp/waltherpp_draw.wav")
TFA.AddWeaponSound( "tfa_cso2_waltherpp.Sliderelease", "tfa_cso2/weapons/waltherpp/waltherpp_sliderelease.wav")

--Wrench
TFA.AddFireSound( "tfa_cso2_wrench.Draw", "tfa_cso2/weapons/wrench/wrench_draw.wav", true )
TFA.AddFireSound( "tfa_cso2_wrench.Stab", "tfa_cso2/weapons/wrench/wrench_stab.wav", true )
TFA.AddFireSound( "tfa_cso2_wrench.Stabmiss", "tfa_cso2/weapons/wrench/wrench_stabmiss.wav", true )
TFA.AddFireSound( "tfa_cso2_wrench.Attack01", "tfa_cso2/weapons/wrench/wrench_attack01.wav", true )
TFA.AddFireSound( "tfa_cso2_wrench.Attack02", "tfa_cso2/weapons/wrench/wrench_attack02.wav", true )
