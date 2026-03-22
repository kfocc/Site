if SERVER then
	util.AddNetworkString("advmat.Materialize")
	util.AddNetworkString("advmat.Init")
end

materials = materials or {}
materials.stored = materials.stored or {}
materials.entList = materials.entList or {}
materials.blackList = {
	-- overlay
	["union/combine_tactview2"] = true,
	["effects/combine_binocoverlay"] = true,

	["models/weapons/v_toolgun/screen_bg"] = true,
	["phoenix_storms/glass"] = true,
	["models/props_combine/health_charger_glass"] = true,
	["models/props/cs_assault/moneywrap02"] = true,
	["models/effects/vol_light001"] = true,
	["vgui/screens/vgui_button_pushed"] = true,
	["debug/debugportals"] = true,
	["debug/env_cubemap_model"] = true,
	["sprites/glow04_noz_gmod"] = true,
	["sprites/glow04_noz"] = true,
	["sprites/glow01"] = true,
	["sprites/glow02"] = true,
	["sprites/glow03"] = true,
	["sprites/glow04"] = true,
	["sprites/glow05"] = true,
	["sprites/glow06"] = true,
	["sprites/glow07"] = true,
	["sprites/glow08"] = true,
	["effects/tvscreen_noise001a"] = true,
	["models/props_lab/suitcase_glass"] = true,
	["vgui/common/message_dialog_error"] = true,
	["vgui/common/message_dialog"] = true,
	["vgui/screens/vgui_button_enabled"] = true,
	["vgui/screens/vgui_button_hover"] = true,
	["vgui/common/message_dialog_warning"] = true,
	["models/spawn_effect"] = true,
	["decals/dark"] = true,
	["decals/light"] = true,
	["!flags16/ua-png+1+1+0+0"] = true,
	["!flags16/ru-png+1+1+0+0"] = true,
	["!vgui/hsv-bar+1+1+0+0"] = true,
	["Effects/CombineShield/comshieldwall3"] = true, -- Запрет из-за бага по перекраске полей https://f.unionrp.info/threads/%D0%9F%D0%B5%D1%80%D0%B5%D0%BA%D1%80%D0%B0%D1%81%D0%BA%D0%B0-%D0%BF%D0%BE%D0%BB%D0%B5%D0%B9-%D0%BD%D0%B0-%D0%B2%D1%81%D0%B5%D0%B9-%D0%BA%D0%B0%D1%80%D1%82%D0%B5.113131/

	-- НЕОП. ЛИЦА
	["models/humans/female/fmouth"] = true,
	["models/humans/male/mouth"] = true,
	["models/humans/female/eyeball_l"] = true,
	["models/humans/male/eyeball_r"] = true,
	["models/humans/female/group01/players_sheet"] = true,
	["models/humans/male/group01/players_sheet"] = true,
	["models/humans/female/eyeball_r"] = true,
	["models/humans/male/eyeball_l"] = true,
	["models/humans/male/group01/van_facemap"] = true,
	["models/humans/male/group01/ted_facemap"] = true,
	["models/humans/male/group01/joe_facemap"] = true,
	["models/humans/male/group01/eric_facemap"] = true,
	["models/humans/male/group01/art_facemap"] = true,
	["models/humans/male/group01/sandro_facemap"] = true,
	["models/humans/male/group01/mike_facemap"] = true,
	["models/humans/male/group01/vance_facemap"] = true,
	["models/humans/male/group01/erdim_cylmap"] = true,
	["models/humans/female/group01/joey_facemap"] = true,
	["models/humans/female/group01/kanisha_cylmap"] = true,
	["models/humans/female/group01/kim_facemap"] = true,
	["models/humans/female/group01/chau_facemap"] = true,
	["models/humans/female/group01/lakeetra_facemap"] = true,
	["models/humans/female/group01/naomi_facemap"] = true,
	-- ЗЕКИ
	["models/humans/un_prison/un_prison_cup"] = true,
	["models/humans/un_prison/un_prison_sheet_f"] = true,
	["models/humans/un_prison/un_prison_sheet"] = true,
	--["models/humans/un_prison/pband"] = true,
	-- АЛИКС ДЕФОЛТ
	["models/alyx/alyx_faceandhair"] = true,
	["models/alyx/eyeball_r"] = true,
	["models/alyx/eyeball_l"] = true,
	["models/alyx/hairbits"] = true,
	["models/alyx/fmouth"] = true,
	["models/alyx/plyr_sheet"] = true,
	["models/alyx/plyr_sheet_skin"] = true,
	-- БРИН ДЕФОЛТ
	["models/breen/breen_face"] = true,
	["models/breen/players_sheet"] = true,
	-- ЗАЛОЖНИКИ КСС
	["models/hostages/art_facemap"] = true,
	["models/hostages/eyeball_l"] = true,
	["models/hostages/mouth"] = true,
	["models/hostages/eyeball_r"] = true,
	["models/hostages/hostage_sheet"] = true,
	["models/hostages/pupil_r"] = true,
	["models/hostages/glint"] = true,
	["models/hostages/pupil_l"] = true,
	["models/hostages/sandro_facemap"] = true,
	["models/hostages/vance_facemap"] = true,
	["models/hostages/glassesside_walter"] = true,
	["models/hostages/glassesfront_walter"] = true,
	["models/hostages/glass2"] = true,
	["models/hostages/cohrt"] = true,
	-- ТЕРЫ КСС
	["models/player/t_guerilla/t_guerilla"] = true,
	["models/player/t_leet/t_leet"] = true,
	["models/player/t_leet/t_leet_glass"] = true,
	["models/player/t_phoenix/t_phoenix"] = true,
	["models/player/t_arctic/t_arctic"] = true,
	-- КОМБАЙНЫ ДЕФОЛТ
	["models/police/metrocop_sheet"] = true,
	["models/combine_soldier/combinesoldiersheet_prisonguard_shotgun"] = true,
	["models/combine_scanner/scanner_sheet"] = true,
	["models/combine_turrets/floor_turret/combine_gun002"] = true,
	-- ФРИМЕН
	["models/sirgibs/gordon_survivor/mouth"] = true,
	["models/sirgibs/gordon_survivor/gordon_cylmap2"] = true,
	["models/sirgibs/gordon_survivor/eyeball_l"] = true,
	["models/sirgibs/gordon_survivor/eyeball_r"] = true,
	["models/sirgibs/gordon_survivor/glasses"] = true,
	["models/sirgibs/gordon_survivor/rense"] = true,
	["models/sirgibs/gordon_survivor/gordon_sheet"] = true,
	["models/sirgibs/gordon_survivor/hevsuit_sheet"] = true,
	["models/sirgibs/gordon_survivor/hev_suit"] = true,
	["models/sirgibs/gordon_survivor/v_hand_sheet"] = true,
	["models/humans/male/group01/citizen_sheet"] = true,
	["models/sirgibs/gordon_survivor/body"] = true,
	["models/sirgibs/gordon_survivor/base_m_d"] = true,
	["models/sirgibs/gordon_survivor/gordon_cylmap2_ep2"] = true,
	["models/sirgibs/gordon_survivor/gordon_sheet_ep2"] = true,
	["models/sirgibs/gordon_survivor/hevsuit_sheet_ep2"] = true,
	["models/sirgibs/gordon_survivor/body_dirty"] = true,
	["models/sirgibs/gordon_survivor/gordon_cylmap2_enh"] = true,
	["models/sirgibs/gordon_survivor/eyeball_l_enh"] = true,
	["models/sirgibs/gordon_survivor/eyeball_r_enh"] = true,
	["models/sirgibs/gordon_survivor/gordon_cylmap2_enh_ep2"] = true,
	["models/sirgibs/gordon_survivor/gordon_cylmap2_enh_bm"] = true,
	-- ВОРТ РАБ
	["models/xenians/vortigaunt/shackles"] = true,
	["models/xenians/vortigaunt/vortigaunt_base"] = true,
	["models/xenians/vortigaunt/uprighteyeball"] = true,
	["models/xenians/vortigaunt/vort_eye"] = true,
	["models/xenians/vortigaunt/upmideyeball"] = true,
	["models/xenians/vortigaunt/uplefteyeball"] = true,
	-- C2 ГО
	["models/dpfilms/metropolice/arctic/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/arctic/metrocopboots"] = true,
	["models/dpfilms/metropolice/arctic/hands"] = true,
	["models/dpfilms/metropolice/arctic/gasmask_neck"] = true,
	["models/dpfilms/metropolice/arctic/gasmask_lens"] = true,
	["models/dpfilms/metropolice/badass_police/gasmask"] = true,
	["models/dpfilms/metropolice/badass_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/badass_police/black_glassesside"] = true,
	["models/dpfilms/metropolice/badass_police/black_glasslens"] = true,
	["models/dpfilms/metropolice/badass_police/aviator"] = true,
	["models/dpfilms/metropolice/badass_police/suit_sheet"] = true,
	["models/dpfilms/metropolice/badass_police/shirt_sheet"] = true,
	["models/dpfilms/metropolice/badass_police/gloves"] = true,
	["models/dpfilms/metropolice/biopolice/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/biopolice/metrocopboots"] = true,
	["models/dpfilms/metropolice/biopolice/hands"] = true,
	["models/dpfilms/metropolice/biopolice/gasmask"] = true,
	["models/dpfilms/metropolice/biopolice/gasmask_neck"] = true,
	["models/dpfilms/metropolice/biopolice/gasmask_lens"] = true,
	["models/dpfilms/metropolice/biopolice/w_rifle"] = true,
	["models/dpfilms/metropolice/biopolice/geart"] = true,
	["models/dpfilms/metropolice/biopolice/oxygen_tank"] = true,
	["models/dpfilms/metropolice/biopolice/wire"] = true,
	["models/dpfilms/metropolice/biopolice/gasmask_cl"] = true,
	["models/dpfilms/metropolice/biopolice/gasmask_lens_cl"] = true,
	["models/dpfilms/metropolice/biopolice/gasmask_neck_cl"] = true,
	["models/dpfilms/metropolice/biopolice/hands_cl"] = true,
	["models/dpfilms/metropolice/biopolice/metrocop_sheet_cl"] = true,
	["models/dpfilms/metropolice/blacop/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/blacop/metrocopboots"] = true,
	["models/dpfilms/metropolice/blacop/hands"] = true,
	["models/dpfilms/metropolice/blacop/gasmask"] = true,
	["models/dpfilms/metropolice/blacop/gasmask_neck"] = true,
	["models/dpfilms/metropolice/blacop/gasmask_black"] = true,
	["models/dpfilms/metropolice/blacop/gasmask_skull"] = true,
	["models/dpfilms/metropolice/c08cop/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/c08cop/metrocopboots"] = true,
	["models/dpfilms/metropolice/c08cop/hands"] = true,
	["models/dpfilms/metropolice/c08cop/gasmask"] = true,
	["models/dpfilms/metropolice/c08cop/gasmask_neck"] = true,
	["models/dpfilms/metropolice/c08cop/gasmask_lens"] = true,
	["models/dpfilms/metropolice/civil_medic/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/civil_medic/metrocopboots"] = true,
	["models/dpfilms/metropolice/civil_medic/hands"] = true,
	["models/dpfilms/metropolice/civil_medic/gasmask"] = true,
	["models/dpfilms/metropolice/civil_medic/gasmask_neck"] = true,
	["models/dpfilms/metropolice/civil_medic/gasmask_lens"] = true,
	["models/dpfilms/metropolice/elite/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/elite/metrocopboots"] = true,
	["models/dpfilms/metropolice/elite/hands"] = true,
	["models/dpfilms/metropolice/elite/gasmask"] = true,
	["models/dpfilms/metropolice/elite/elite_gasmask"] = true,
	["models/dpfilms/metropolice/elite/gasmask_neck"] = true,
	["models/manhack/manhack_sheet"] = true,
	["models/manhack/manhack_sheet"] = true,
	["models/dpfilms/metropolice/hd_police/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/hd_police/metrocopboots"] = true,
	["models/dpfilms/metropolice/hd_police/hands"] = true,
	["models/dpfilms/metropolice/hd_police/gasmask"] = true,
	["models/dpfilms/metropolice/hd_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/hd_police/gasmask_lens"] = true,
	["models/dpfilms/metropolice/hl2beta_cop/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/hl2beta_cop/metrocopboots"] = true,
	["models/dpfilms/metropolice/hl2beta_cop/hands"] = true,
	["models/dpfilms/metropolice/hl2beta_cop/gasmask"] = true,
	["models/dpfilms/metropolice/hl2beta_cop/gasmask_lens"] = true,
	["models/dpfilms/metropolice/hl2beta_cop/gasmask_neck"] = true,
	["models/dpfilms/metropolice/hl2_concept/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/hl2_concept/metrocopboots"] = true,
	["models/dpfilms/metropolice/hl2_concept/hands"] = true,
	["models/dpfilms/metropolice/hl2_concept/gasmask"] = true,
	["models/dpfilms/metropolice/hl2_concept/gasmask_neck"] = true,
	["models/dpfilms/metropolice/hl2_concept/gasmask_lens"] = true,
	["models/dpfilms/metropolice/ministrider_police/metrocopboots"] = true,
	["models/dpfilms/metropolice/ministrider_police/hands"] = true,
	["models/dpfilms/metropolice/ministrider_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/ministrider_police/gasmask_lens"] = true,
	["models/dpfilms/metropolice/ministrider_police/metal"] = true,
	["models/dpfilms/metropolice/ministrider_police/gasmask"] = true,
	["models/dpfilms/metropolice/ministrider_police/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/ministrider_police/chest"] = true,
	["models/dpfilms/metropolice/phoenix/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/phoenix/metrocopboots"] = true,
	["models/dpfilms/metropolice/phoenix/hands"] = true,
	["models/dpfilms/metropolice/phoenix/gasmask"] = true,
	["models/dpfilms/metropolice/phoenix/gasmask_neck"] = true,
	["models/dpfilms/metropolice/phoenix/gasmask_lens"] = true,
	["models/dpfilms/metropolice/phoenix/gasmask_future"] = true,
	["models/dpfilms/metropolice/elite/gasmask_bt"] = true,
	["models/dpfilms/metropolice/cpfrag/metrocopboots"] = true,
	["models/dpfilms/metropolice/cpfrag/hands"] = true,
	["models/dpfilms/metropolice/cpfrag/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/cpfrag/chest"] = true,
	["models/dpfilms/metropolice/cpfrag/gasmask_lens"] = true,
	["models/dpfilms/metropolice/cpfrag/gasmask"] = true,
	["models/dpfilms/metropolice/cpfrag/gasmask_bt"] = true,
	["models/dpfilms/metropolice/cpfrag/gasmask_lens"] = true,
	["models/dpfilms/metropolice/resistance_police/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/resistance_police/metrocopboots"] = true,
	["models/dpfilms/metropolice/resistance_police/hands"] = true,
	["models/dpfilms/metropolice/resistance_police/gasmask"] = true,
	["models/dpfilms/metropolice/resistance_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/resistance_police/gasmask_lens"] = true,
	["models/dpfilms/metropolice/retrocop/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/retrocop/metrocopboots"] = true,
	["models/dpfilms/metropolice/retrocop/hands"] = true,
	["models/dpfilms/metropolice/retrocop/gasmask"] = true,
	["models/dpfilms/metropolice/retrocop/gasmask_neck"] = true,
	["models/dpfilms/metropolice/retrocop/gasmask_lens"] = true,
	["models/dpfilms/metropolice/rogue/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/rogue/metrocopboots"] = true,
	["models/dpfilms/metropolice/rogue/hands"] = true,
	["models/dpfilms/metropolice/rogue/gasmask"] = true,
	["models/dpfilms/metropolice/rogue/gasmask_lens"] = true,
	["models/dpfilms/metropolice/rogue/gasmask_neck"] = true,
	["models/dpfilms/metropolice/metrold/gasmask"] = true,
	["models/dpfilms/metropolice/metrold/gasmask_lens"] = true,
	["models/dpfilms/metropolice/metrold/hands"] = true,
	["models/dpfilms/metropolice/metrold/metrocopboots"] = true,
	["models/dpfilms/metropolice/metrold/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/metrold/vest"] = true,
	["models/dpfilms/metropolice/metrold/backpack"] = true,
	["models/dpfilms/metropolice/metrold/gear"] = true,
	["models/dpfilms/metropolice/metrold/radio"] = true,
	["models/dpfilms/metropolice/tron_police/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/tron_police/metrocopboots"] = true,
	["models/dpfilms/metropolice/tron_police/hands"] = true,
	["models/dpfilms/metropolice/tron_police/gasmask"] = true,
	["models/dpfilms/metropolice/tron_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/tron_police/gasmask_lens"] = true,
	["models/dpfilms/metropolice/tron_police/metrocop_sheet2"] = true,
	["models/dpfilms/metropolice/tron_police/gasmask2"] = true,
	["models/dpfilms/metropolice/tron_police/gasmask_lens2"] = true,
	["models/dpfilms/metropolice/tron_police/hands2"] = true,
	["models/dpfilms/metropolice/urban_police/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/urban_police/metrocopboots"] = true,
	["models/dpfilms/metropolice/urban_police/hands"] = true,
	["models/dpfilms/metropolice/urban_police/gasmask"] = true,
	["models/dpfilms/metropolice/urban_police/gasmask_lens"] = true,
	["models/dpfilms/metropolice/urban_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/zombie_police/metrocop_sheet"] = true,
	["models/dpfilms/metropolice/zombie_police/metrocopboots"] = true,
	["models/dpfilms/metropolice/zombie_police/hands"] = true,
	["models/dpfilms/metropolice/zombie_police/gasmask"] = true,
	["models/dpfilms/metropolice/zombie_police/gasmask_neck"] = true,
	["models/dpfilms/metropolice/zombie_police/gasmask_lens"] = true,
	["models/dpfilms/metropolice/zombie_police/face"] = true,
	["models/dpfilms/metropolice/zombie_police/eyeball_l"] = true,
	["models/dpfilms/metropolice/zombie_police/fast_zombie_sheet"] = true,
	-- C17 ГО
	["models/ggl/cp/metrocop_sheet"] = true,
	["models/ggl/cp/metrocopboots"] = true,
	["models/humans/male/eyeball_l"] = true,
	["models/humans/male/eyeball_r"] = true,
	["models/ggl/cp/radio"] = true,
	["models/ggl/cp/hands"] = true,
	["models/ggl/cp/gasmask"] = true,
	["models/ggl/cp/gasmask_elite"] = true,
	["models/ggl/cp/gasmask_bt"] = true,
	["models/ggl/cp/gasmask_shock"] = true,
	["models/ggl/cp/mask"] = true,
	["models/ggl/cp/gasmask_black"] = true,
	["models/ggl/cp/barney_neck"] = true,
	["models/ggl/cp/woods_hair1"] = true,
	["models/ggl/cp/gear"] = true,
	["models/ggl/cp/itemssheet"] = true,
	["models/ggl/cp/kevlar_vest"] = true,
	["models/manhack/manhack_sheet"] = true,
	["models/ggl/cp/metrocop_sheet1"] = true,
	["models/ggl/cp/metrocop_sheet2"] = true,
	["models/ggl/cp/metrocop_sheet3"] = true,
	["models/ggl/cp/metrocop_sheet4"] = true,
	["models/ggl/cp/metrocop_sheet5"] = true,
	["models/ggl/cp/metrocop_sheet6"] = true,
	-- С17 ЛИЦА ГО
	["models/ggl/cp/slow_head"] = true,
	["models/police/barneyface"] = true,
	["models/ggl/cp/vank_facemap"] = true,
	["models/ggl/cp/shep_scalp"] = true,
	["models/ggl/cp/shep_facemap"] = true,
	["models/ggl/cp/hair_jb"] = true,
	["models/ggl/cp/face_jb"] = true,
	["models/ggl/cp/sam_facemap"] = true,
	["models/ggl/cp/vito_facemap"] = true,
	["models/ggl/cp/mason_facemap"] = true,
	["models/ggl/cp/jacob_facemap"] = true,
	["models/ggl/cp/jacob_scalp"] = true,
	["models/ggl/cp/avp_facemap"] = true,
	["models/ggl/cp/max_facemap"] = true,
	["models/ggl/cp/ted_facemap"] = true,
	["models/ggl/cp/foley_facemap"] = true,
	["models/ggl/cp/dunn_facemap"] = true,
	["models/ggl/cp/joe_facemap"] = true,
	["models/ggl/cp/eric_facemap"] = true,
	["models/ggl/cp/art_facemap"] = true,
	["models/ggl/cp/vosky_cylmap"] = true,
	["models/ggl/cp/mike_facemap"] = true,
	["models/ggl/cp/vance_facemap"] = true,
	["models/ggl/cp/erdim_facemap"] = true,
	-- ОТА
	["models/soldier_stripped/soldier_stripped_comp"] = true,
	["models/combine_soldier/combinesoldiersheet_player"] = true,
	["models/combine_soldier/combinesoldiersheet_player_shotgun"] = true,
	-- ОТА С2
	["models/combine_soldier/city_8_cota_soldier"] = true,
	["models/combine_soldier/city_8_cota_e"] = true,
	["models/combine_hell/combinesoldiersheet"] = true,
	["models/combine_hell/bits"] = true,
	["models/combine_soldier/atlas_sheet"] = true,
	["models/combine_soldier_concepts/soldiers/combinesoldier_swamp"] = true,
	["models/combine_soldier_elite/soldiers/combine_soldier_elite"] = true,
	["models/combine_soldier_tox/soldiers/combinesoldier_tox"] = true,
	["models/e3assassin/fassassin_sheet"] = true,
	["models/e3assassin/boot_sheet"] = true,
	["models/sorge/elite_soldier/elite_overwatch"] = true,
	-- ОТА С17
	["models/combine_soldier/combine_advisor_guard"] = true,
	["models/combine_soldier/combinesoldier_chestplate9"] = true,
	["models/combine_soldier/combine_advisor_guard_soldier"] = true,
	["models/combine_soldier/combine_elite_guard"] = true,
	["models/combine_soldier/combinesoldier_chestplate6"] = true,
	["models/combine_soldier/combine_elite_soldier"] = true,
	["models/combine_soldier/combinesoldier_chestplate5"] = true,
	["models/combine_soldier/combinesoldiersheet_prisonguard"] = true,
	["models/combine_soldier/combine_heavy"] = true,
	["models/combine_soldier/combinesoldier_chestplate8"] = true,
	["models/combine_soldier/combine_helmet"] = true,
	["models/combine_soldier/combine_hunter"] = true,
	["models/combine_soldier/combinesoldier_chestplate4"] = true,
	["models/combine_soldier/combine_hunter_soldier"] = true,
	["models/combine_soldier/combinesoldiersheet_shotgun"] = true,
	["models/combine_soldier/combinesoldier_chestplate2"] = true,
	["models/combine_soldier/combinesoldiersheet"] = true,
	["models/combine_soldier/combinesoldier_chestplate"] = true,
	["models/combine_soldier/combine_super_elite_soldier"] = true,
	["models/combine_soldier/combinesoldier_chestplate7"] = true,
	["models/combine_soldier/combine_super_shotgunner"] = true,
	["models/combine_soldier/combine_elite"] = true,
	["models/combine_soldier/combinesoldier_chestplate3"] = true,
	["models/conceptbine_playerv2/combine_elite"] = true,
	["models/conceptbine_playerv2/manos"] = true,
	["models/conceptbine_playerv2/tela_elite"] = true,
	["models/conceptbine_playerv2/pockets"] = true,
	["models/conceptbine_playerv2/holster"] = true,
	["models/conceptbine_playerv2/botas"] = true,
	["models/conceptbine_playerv2/vest"] = true,
	["models/conceptbine_playerv2/beret_sheet"] = true,
	["models/conceptbine_playerv2/w_knife_t"] = true,
	["models/conceptbine_playerv2/combine_elite_playercolor"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_prisonguard"] = true,
	["models/conceptbine_playerv2/tela_prison"] = true,
	["models/conceptbine_playerv2/gsccc"] = true,
	--["models/conceptbine_playerv2/visor1_glass"] = true,
	["models/conceptbine_playerv2/visor1"] = true,
	["models/conceptbine_playerv2/ct_gsg9"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_prisonguard_shotgun"] = true,
	--["models/conceptbine_playerv2/visor2_glass"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_prisonguard_playercolor"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_prisonguard_shotgun_playercolor"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet"] = true,
	["models/conceptbine_playerv2/tela"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_shotgun"] = true,
	["models/conceptbine_playerv2/tela_shotgun"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_playercolor"] = true,
	["models/conceptbine_playerv2/combinesoldiersheet_shotgun_playercolor"] = true,
	-- СТАЛКЕР
	["models/stalker/stalker_sheet"] = true,
	-- КРЕМАТОР
	["models/union/cremator/cremsuit"] = true,
	["models/union/cremator/ball"] = true,
	-- ботинки ["models/union/cremator/ball"] = true,
	-- руки ["models/union/cremator/arm"] = true,
	["models/union/cremator/hands"] = true,
	["models/union/cremator/face"] = true,
	-- голова ["models/union/cremator/head"] = true,
	-- ВОРТ ВОИН
	["models/vortigaunt/uprighteyeball"] = true,
	["models/vortigaunt/vortigaunt_base"] = true,
	["models/vortigaunt/vort_eye"] = true,
	["models/vortigaunt/upmideyeball"] = true,
	["models/vortigaunt/uplefteyeball"] = true,
	["models/vortigaunt/shackles"] = true,
	-- КЛЯЙНЕР
	["models/kleiner/mouth"] = true,
	["models/kleiner/eyeball_r"] = true,
	["models/kleiner/glassesside_walter"] = true,
	["models/kleiner/walter_face"] = true,
	["models/kleiner/eyeball_l"] = true,
	["models/kleiner/players_sheet"] = true,
	["models/kleiner/glassesfront_walter"] = true,
	["models/kleiner/glass2"] = true,
	-- АДМИН С17
	["models/garrysmod/hevgmod/hevsuit_sheet"] = true,
	["models/garrysmod/hevgmod/black"] = true,
	["models/garrysmod/hevgmod/glassvisor2"] = true,
	["models/garrysmod/hevgmod/black2"] = true,
	-- GMAN
	["models/gman/gman_facehirez"] = true,
	["models/gman/plyr_sheet"] = true,
	["models/gman/tongue"] = true,
	["models/gman/eyeball_l"] = true,
	["models/gman/eyeball_r"] = true,
	["models/gman/lower_teeth"] = true,
	["models/gman/upper_teeth"] = true,
	-- ЗОМБИ ДЕФОЛТ
	["models/zombie_classic/zombie_players_sheet"] = true,
	["models/headcrab_classic/headcrabsheet"] = true,
	-- ЗОМБИ ФАСТ
	["models/zombie_fast_players/fast_zombie_sheet"] = true,
	-- ЗОМБИ ОТА
	["models/zombie_classic/combinesoldiersheet_zombie"] = true,
	["models/headcrab_classic/headcrabsheet"] = true,
	["models/zombie_classic/zombie_classic_sheet"] = true,
	-- ЗОМБИ ЯДИК
	["models/zombie_poison/poisonzombie_sheet"] = true,
	["models/headcrab_black/blackcrab_sheet"] = true,
	-- ДЖЕФФ
	["models/hlvr/zombie/blind/hair"] = true,
	["models/hlvr/zombie/blind/jeff"] = true,
	["models/hlvr/zombie/blind/jeff_m"] = true,
	-- СПЕЦАГЕНТ
	["models/union/sagent/face/eyeball_l"] = true,
	["models/union/sagent/face/eyeball_r"] = true,
	["models/union/sagent/clothes/trenchcoat_dirty"] = true,
	["models/union/sagent/clothes/male_rebel"] = true,
	["models/union/sagent/clothes/gloves"] = true,
	["models/union/sagent/face/mike_facemap"] = true,
	["models/union/sagent/clothes/headgear1"] = true,
	["models/union/sagent/clothes/headgear2"] = true,
	["models/union/sagent/clothes/gasmask_black"] = true,
	["models/union/sagent/clothes/rebel_cota"] = true,
	["models/union/sagent/clothes/facewrap"] = true,
	["models/union/sagent/clothes/backpack"] = true,
	["models/union/sagent/clothes/coyote_black"] = true,
	["models/union/sagent/clothes/metrocop_sheet"] = true,
	["models/union/sagent/clothes/metrocop_boots"] = true,
	["models/union/sagent/face/mike_facemap2"] = true,
	["models/union/sagent/face/mike_facemap3"] = true,
	["models/union/sagent/face/mike_facemap4"] = true,
	-- ВОЕННЫЙ С2
	["models/jugger_materials/skin_07/body_02"] = true,
	["models/jugger_materials/shared/eyeball_r"] = true,
	["models/jugger_materials/shared/eyeball_l"] = true,
	["models/jugger_materials/shared/mouth"] = true,
	["models/jugger_materials/skin_07/face_01"] = true,
	["models/jugger_materials/shared/headgear_01"] = true,
	["models/jugger_materials/skin_07/gear_01"] = true,
	["models/jugger_materials/skin_07/gear_02"] = true,
	["models/jugger_materials/skin_07/gear_03"] = true,
	["models/jugger_materials/skin_07/gear_04"] = true,
	["models/jugger_materials/skin_07/body_01"] = true,
	["models/jugger_materials/shared/sleeves"] = true,
	["models/jugger_materials/skin_07/helmet_04"] = true,
	["models/jugger_materials/shared/glass"] = true,
	["models/jugger_materials/shared/gasmask_02"] = true,
	["models/jugger_materials/shared/gasmask_01"] = true,
	["models/jugger_materials/skin_07/helmet_03"] = true,
	["models/jugger_materials/skin_07/helmet_01"] = true,
	-- АРНЕ ОРИГИНАЛ
	["models/magnusson/magnusson_face"] = true,
	["models/humans/male/mouth"] = true,
	["models/magnusson/players_body"] = true,
	["models/magnusson/magnusson_hair"] = true,
	["models/magnusson/eyeball_r"] = true,
	["models/magnusson/eyeball_l"] = true,
	-- ОДЕССА ОРИГИНАЛ
	["models/odessa/odessa_face"] = true,
	["models/humans/male/mouth"] = true,
	["models/odessa/eyeball_r"] = true,
	["models/odessa/players_sheet"] = true,
	["models/odessa/eyeball_l"] = true,
	-- ОДЕССА ВОЕННЫЙ
	["unionrp/newodessa/newodessa_beret"] = true,
	["unionrp/newodessa/rebel_patch"] = true,
	["unionrp/newodessa/body_02_worn"] = true,
	["unionrp/newodessa/gear_01_worn"] = true,
	["unionrp/newodessa/gear_02_worn"] = true,
	["unionrp/newodessa/gear_03_worn"] = true,
	["unionrp/newodessa/gear_04_worn"] = true,
	-- ОФИЦЕР ГИДРЫ SCP C2
	["models/pmc/pmc_4/gsaaa"] = true,
	["models/pmc/pmc_4/gsccc"] = true,
	["models/pmc/pmc_4/inner"] = true,
	["models/pmc/pmc_4/best"] = true,
	["models/pmc/pmc_4/arm"] = true,
	["models/pmc/pmc_4/gear"] = true,
	["models/pmc/pmc_4/gear2"] = true,
	["models/pmc/pmc_shared/sbbb"] = true,
	["models/pmc/pmc_4/iris_identitya"] = true,
	["models/pmc/pmc_shared/t_arctic"] = true,
	["models/pmc/pmc_shared/citizen_sheet"] = true,
	["models/pmc/pmc_shared/mouth"] = true,
	["models/pmc/pmc_shared/eric_facemap"] = true,
	["models/pmc/pmc_shared/eyeball_r"] = true,
	["models/pmc/pmc_shared/eyeball_l"] = true,
	["models/pmc/pmc_4/band"] = true,
	["models/pmc/pmc_4/headset_b"] = true,
	["models/pmc/pmc_shared/usmc_lenses_sp_col"] = true,
	["models/pmc/pmc_shared/glass"] = true,
	["models/pmc/pmc_shared/head"] = true,
	-- Лидер С2
	["models/sgg/hev/hevsuit_sheet"] = true,
	--["models/sgg/hev/player_chrome1"] = true,
	["models/sgg/hev/glassvisor"] = true,
	--["models/sgg/hev/hev_helmet"] = true,
	--["models/sgg/hev/hev_helmet_top"] = true,
	["models/sgg/hev/black"] = true,
	["models/sgg/hev/black2"] = true,
	["models/sgg/hev/glassvisor2"] = true,
	-- TNB PACK
	["models/tnb/heads/eyeball_l"] = true,
	["models/tnb/heads/eyeball_r"] = true,
	["models/tnb/heads/fang_facemap1"] = true,
	["models/tnb/citizens/female_citizen1"] = true,
	["models/tnb/citizens/female_arm_white"] = true,
	["models/tnb/citizens/female_citizen3"] = true,
	["models/tnb/citizens/trenchcoat_dirty1"] = true,
	["models/tnb/citizens/female_citizen2"] = true,
	["models/tnb/citizens/bag1"] = true,
	["models/tnb/combine/metrocop_sheet"] = true,
	["models/tnb/combine/metrocop_armband"] = true,
	["models/tnb/combine/metrocop_gloves"] = true,
	["models/tnb/citizens/molle1"] = true,
	["models/tnb/citizens/female_rebel1"] = true,
	["models/tnb/citizens/rebel_cota1"] = true,
	["models/tnb/citizens/male_rebel1"] = true,
	["models/tnb/citizens/female_citizen4"] = true,
	["models/tnb/citizens/rebel_metrocop1"] = true,
	["models/tnb/citizens/wintercoat1"] = true,
	["models/tnb/citizens/workerboots1"] = true,
	["models/tnb/combine/metrocop_boots"] = true,
	["models/tnb/citizens/female_citizen_hands1"] = true,
	["models/tnb/heads/fang_hair_trans1"] = true,
	["models/tnb/citizens/gasmask1"] = true,
	["models/tnb/citizens/gasmask_glass"] = true,
	["models/tnb/heads/hair_kate1"] = true,
	["models/tnb/heads/zoey_facemap1"] = true,
	["models/tnb/heads/eyeball_b"] = true,
	["models/tnb/citizens/female_citizen_hands4"] = true,
	["models/tnb/heads/hair_kate3"] = true,
	--["models/tnb/citizens/facewrap1"] = true,
	--["models/tnb/citizens/facewrap2"] = true,
	["models/tnb/citizens/headgear1"] = true,
	["models/tnb/heads/zoey_facemap2"] = true,
	["models/tnb/heads/sherry_facemap1"] = true,
	["models/tnb/heads/hair_sherry1"] = true,
	["models/tnb/citizens/shemagh1"] = true,
	["models/tnb/heads/hair_anime1"] = true,
	["models/tnb/heads/hair_anime2"] = true,
	["models/tnb/heads/hair_claire_brown1"] = true,
	["models/tnb/heads/hair_claire_brown2"] = true,
	["models/tnb/heads/claire_facemap"] = true,
	["models/tnb/citizens/female_shoes1"] = true,
	["models/tnb/citizens/zara_jeans"] = true,
	["models/tnb/citizens/trenchcoat_leather1"] = true,
	["models/tnb/citizens/rebel_cota2"] = true,
	["models/tnb/citizens/bag2"] = true,
	["models/tnb/citizens/female_rebel3"] = true,
	["models/tnb/citizens/molle2"] = true,
	["models/tnb/citizens/female_admin2"] = true,
	["models/tnb/citizens/trenchcoat_dirty2"] = true,
	["models/tnb/citizens/airex_1"] = true,
	["models/tnb/citizens/female_rebel2"] = true,
	["models/tnb/heads/clara_facemap1"] = true,
	["models/tnb/citizens/female_admin1"] = true,
	["models/tnb/citizens/female_pants1"] = true,
	["models/tnb/heads/hair_kate1_fill"] = true,
	["models/tnb/heads/eyeball_g"] = true,
	["models/tnb/citizens/cap1"] = true,
	["models/tnb/heads/female_facemap1"] = true,
	["models/tnb/heads/hair_zoey1"] = true,
	["models/tnb/citizens/visormask1"] = true,
	["models/tnb/heads/anime_facemap1"] = true,
	["models/tnb/heads/dragon_facemap1"] = true,
	["models/tnb/heads/hair_updo1_alpha"] = true,
	["models/tnb/heads/hair_updo1"] = true,
	["models/tnb/heads/miranda_facemap1"] = true,
	["models/tnb/heads/miranda_scalp1"] = true,
	["models/tnb/heads/hair_miranda1"] = true,
	["models/tnb/heads/rexl_facemap"] = true,
	--["models/tnb/heads/eyeball_z"] = true,
	["models/tnb/citizens/male_citizen4"] = true,
	["models/tnb/citizens/male_arm_white"] = true,
	["models/tnb/citizens/male_citizen3"] = true,
	["models/tnb/citizens/male_rebel3"] = true,
	["models/tnb/citizens/backpack1"] = true,
	["models/tnb/citizens/elbowpad"] = true,
	["models/tnb/citizens/neckbrace"] = true,
	["models/tnb/citizens/male_citizen2"] = true,
	["models/tnb/citizens/rexarmor1"] = true,
	["models/tnb/combine/metrocop_gear"] = true,
	["models/tnb/citizens/peacoat1"] = true,
	["models/tnb/citizens/male_admin2"] = true,
	["models/tnb/citizens/male_citizen_hands1"] = true,
	["models/tnb/citizens/gloves1"] = true,
	["models/tnb/citizens/headgear4"] = true,
	["models/tnb/citizens/rex_lense"] = true,
	["models/tnb/heads/woods_facemap1"] = true,
	["models/tnb/heads/soap_facemap2"] = true,
	["models/tnb/citizens/scarf1"] = true,
	["models/tnb/heads/woods_hair1"] = true,
	["models/tnb/citizens/gasmask_tacreb"] = true,
	["models/tnb/heads/dusty_facemap1"] = true,
	["models/tnb/heads/dusty_beard1"] = true,
	["models/tnb/heads/dusty_facemap2"] = true,
	["models/tnb/heads/dusty_beard2"] = true,
	["models/tnb/heads/kane_facemap1"] = true,
	["models/tnb/citizens/helmet1"] = true,
	["models/tnb/citizens/rebel_metrocop2"] = true,
	["models/tnb/citizens/gasmask_black"] = true,
	["models/tnb/citizens/rebel_cota4"] = true,
	["___error"] = true,
	["models/tnb/citizens/coyote_black"] = true,
	["models/tnb/citizens/male_citizen1"] = true,
	["models/tnb/combine/metrocop_gasmask_neck"] = true,
	["models/tnb/citizens/male_rebel2"] = true,
	["models/tnb/citizens/wintercoat2"] = true,
	["models/tnb/citizens/gear3"] = true,
	["models/tnb/citizens/gear4"] = true,
	["models/tnb/citizens/gear1"] = true,
	["models/humans/female/eye_new_r"] = true,
	["models/humans/suitsfem/kanisha_cylmap"] = true,
	["models/humans/female/eye_new_l"] = true,
	["models/humans/suitsfem/handfemale"] = true,
	["models/humans/suitsfem/femsuit"] = true,
	["models/humans/suitsfem/skirt"] = true,
	["models/lt_c/gallahan/kelly_suit"] = true,
	["models/lt_c/gallahan/erdim_cylmap"] = true,
	["models/humans/male/eye_new_l"] = true,
	["models/humans/male/eye_new_r"] = true,
	["models/lt_c/gallahan/lynch_suit"] = true,
	["models/lt_c/gallahan/lynch_hands"] = true,
	["models/tnb/combine/metrocop_lens1"] = true,
	["models/tnb/combine/metrocop_gasmask_elite"] = true,
	["models/tnb/combine/metrocop_armband01"] = true,
	["models/tnb/combine/metrocop_armband02"] = true,
	["models/tnb/combine/metrocop_armband03"] = true,
	["models/tnb/combine/metrocop_armband04"] = true,
	["models/tnb/combine/metrocop_comma"] = true,
	["models/tnb/combine/metrocop_armbandcmd"] = true,
	["models/tnb/heads/max_facemap1"] = true,
	["models/tnb/citizens/male_citizen_hands4"] = true,
	["models/police/bmouth"] = true,
	["models/police/barneyface"] = true,
	["models/tnb/heads/avp_facemap1"] = true,
	["models/tnb/citizens/scientist1"] = true,
	["models/tnb/heads/avp_facemap2"] = true,
	["models/tnb/heads/avp_facemap3"] = true,
	["models/tnb/heads/jacob_facemap1"] = true,
	["models/tnb/heads/jacob_scalp"] = true,
	["models/tnb/heads/mason_facemap1"] = true,
	["models/tnb/heads/vito_facemap1"] = true,
	["models/tnb/heads/vito_facemap2"] = true,
	["models/tnb/heads/vito_facemap3"] = true,
	["models/tnb/heads/vito_facemap1"] = true,
	["models/tnb/heads/sam_facemap1"] = true,
	["models/tnb/heads/hair_sam1"] = true,
	["models/tnb/heads/hair_jb"] = true,
	["models/tnb/heads/face_jb"] = true,
	["models/tnb/heads/shep_scalp1"] = true,
	["models/tnb/heads/shep_facemap1"] = true,
	["models/tnb/heads/erdim_facemap"] = true,
	["models/tnb/heads/erdim_facemap2"] = true,
	["models/tnb/heads/erdim_facemap3"] = true,
	["models/tnb/heads/erdim_facemap4"] = true,
	["models/tnb/heads/vance_facemap"] = true,
	["models/tnb/heads/vance_facemap2"] = true,
	["models/tnb/heads/vance_facemap3"] = true,
	["models/tnb/heads/vance_facemap4"] = true,
	["models/tnb/heads/mike_facemap"] = true,
	["models/tnb/heads/mike_facemap2"] = true,
	["models/tnb/heads/mike_facemap3"] = true,
	["models/tnb/heads/mike_facemap4"] = true,
	["models/tnb/heads/sandro_facemap"] = true,
	["models/tnb/heads/sandro_facemap2"] = true,
	["models/tnb/heads/sandro_facemap3"] = true,
	["models/tnb/heads/sandro_facemap4"] = true,
	["models/tnb/heads/art_facemap"] = true,
	["models/tnb/heads/art_facemap2"] = true,
	["models/tnb/heads/art_facemap3"] = true,
	["models/tnb/heads/art_facemap4"] = true,
	["models/tnb/heads/eric_facemap"] = true,
	["models/tnb/heads/eric_facemap2"] = true,
	["models/tnb/heads/eric_facemap3"] = true,
	["models/tnb/heads/eric_facemap4"] = true,
	["models/tnb/heads/joe_facemap"] = true,
	["models/tnb/citizens/male_arm_black"] = true,
	["models/tnb/heads/joe_facemap2"] = true,
	["models/tnb/heads/joe_facemap3"] = true,
	["models/tnb/heads/joe_facemap4"] = true,
	["models/tnb/heads/ted_facemap"] = true,
	["models/tnb/heads/ted_facemap2"] = true,
	["models/tnb/heads/ted_facemap3"] = true,
	["models/tnb/heads/ted_facemap4"] = true,
	["models/tnb/heads/van_facemap"] = true,
	["models/tnb/heads/van_facemap2"] = true,
	["models/tnb/heads/van_facemap3"] = true,
	["models/tnb/heads/van_facemap4"] = true,
	["models/tnb/heads/jill_lashes"] = true,
	["models/tnb/heads/jill_facemap1"] = true,
	["models/tnb/heads/hair_jill2_x"] = true,
	["models/tnb/heads/hair_jill2"] = true,
	["models/tnb/heads/jill_facemap2"] = true,
	["models/tnb/heads/hair_jill1"] = true,
	["models/tnb/heads/hair_jill1_x"] = true,
	["models/tnb/heads/kate_facemap1"] = true,
	["models/tnb/heads/hair_d1"] = true,
	["models/tnb/heads/hair_d2"] = true,
	["models/tnb/heads/hair_d2_x"] = true,
	["models/tnb/heads/hair_d1_x"] = true,
	["models/tnb/heads/ashes_lashes"] = true,
	["models/tnb/heads/ashes_facemap1"] = true,
	["models/tnb/heads/hair_ashes1"] = true,
	["models/tnb/heads/hair_ashes2"] = true,
	["models/tnb/heads/ashes_facemap2"] = true,
	["models/tnb/heads/sax_facemap"] = true,
	["models/tnb/heads/sax_facemap2"] = true,
	["models/tnb/heads/sax_facemap3"] = true,
	["models/tnb/heads/sax_facemap4"] = true,
	["models/tnb/heads/naomi_facemap"] = true,
	["models/tnb/heads/naomi_facemap2"] = true,
	["models/tnb/heads/naomi_facemap3"] = true,
	["models/tnb/heads/naomi_facemap4"] = true,
	["models/tnb/heads/sheeva_facemap"] = true,
	["models/tnb/heads/sheeva_facemap2"] = true,
	["models/tnb/heads/sheeva_facemap3"] = true,
	["models/tnb/heads/sheeva_facemap4"] = true,
	["models/tnb/heads/hair_zoey3"] = true,
	["models/tnb/heads/hair_kate2"] = true,
	["models/tnb/heads/hair_zoey2"] = true,
	["models/tnb/heads/chau_facemap"] = true,
	["models/tnb/heads/chau_facemap2"] = true,
	["models/tnb/heads/chau_facemap3"] = true,
	["models/tnb/heads/chau_facemap4"] = true,
	["models/tnb/heads/rochelle_facemap"] = true,
	["models/tnb/heads/rochelle_facemap2"] = true,
	["models/tnb/heads/kanisha_cylmap"] = true,
	["models/tnb/heads/kanisha_cylmap2"] = true,
	["models/tnb/heads/kanisha_cylmap3"] = true,
	["models/tnb/heads/kanisha_cylmap4"] = true,
	["models/tnb/heads/joey_facemap"] = true,
	["models/tnb/heads/joey_facemap2"] = true,
	["models/tnb/heads/joey_facemap3"] = true,
	["models/tnb/heads/joey_facemap4"] = true,
	["models/tnb/citizens/welding_kit"] = true,
	["models/tnb/citizens/male_arm_latex"] = true,
	["models/tnb/citizens/rebel_cota3"] = true,
	["models/tnb/citizens/vest_bicep"] = true,
	["models/tnb/citizens/helmet_altyn"] = true,
	["models/tnb/citizens/ghillie"] = true,
	-- Материалы без глубины
	["phoenix_storms/fender_chrome"] = true,
	["phoenix_storms/fender_white"] = true,
	["debug/env_cubemap_model"] = true,
}

for k in pairs(materials.blackList) do
	materials.blackList[string.lower(string.Trim(k))] = true
end

function materials:GetStored()
	return self.stored
end

function materials:Set(ent, texture, data, filter)
	if SERVER then
		if texture then
			texture = string.lower(texture)
			texture = string.Trim(texture)
		end

		net.Start("advmat.Materialize")
		net.WriteEntity(ent)
		net.WriteString(texture)
		net.WriteTable(data)

		if filter then
			net.Send(filter)
		else
			net.Broadcast()
		end

		if texture == nil or texture == "" then
			if IsValid(ent) then
				ent:SetMaterial("")
				ent.MaterialData = nil

				materials.entList[ent:EntIndex()] = nil
			end

			return
		end

		ent:SetMaterial("")

		local matData = {
			texture = texture,
			ScaleX = data.ScaleX or 1,
			ScaleY = data.ScaleY or 1,
			OffsetX = data.OffsetX or 0,
			OffsetY = data.OffsetY or 0,
			UseNoise = data.UseNoise or false,
			NoiseTexture = data.NoiseTexture or "detail/noise_detail_01",
			NoiseScaleX = data.NoiseScaleX or 1,
			NoiseScaleY = data.NoiseScaleY or 1,
			NoiseOffsetX = data.NoiseOffsetX or 0,
			NoiseOffsetY = data.NoiseOffsetY or 0,
		}
		ent.MaterialData = matData

		local uid = texture .. "+" .. (data.ScaleX or 1) .. "+" .. (data.ScaleY or 1) .. "+" .. (data.OffsetX or 0) .. "+" .. (data.OffsetY or 0)
		if data.UseNoise then
			uid = uid .. (data.NoiseTexture or "detail/noise_detail_01") .. "+" .. (data.NoiseScaleX or 1) .. "+" .. (data.NoiseScaleY or 1) .. "+" .. (data.NoiseOffsetX or 0) .. "+" .. (data.NoiseOffsetY or 0)
		end

		uid = string.gsub(uid, "%.", "-")
		ent:SetMaterial("!" .. uid)
		duplicator.StoreEntityModifier(ent, "MaterialData", matData)

		materials.entList[ent:EntIndex()] = matData
	else
		if texture == nil or texture == "" then
			if IsValid(ent) then
				ent:SetMaterial("")
				ent.MaterialData = nil

				materials.entList[ent:EntIndex()] = nil
			end

			return
		end

		ent:SetMaterial("")
		data = data or {}
		data.texture = texture
		data.UseNoise = data.UseNoise or false
		data.ScaleX = data.ScaleX or 1
		data.ScaleY = data.ScaleY or 1
		data.OffsetX = data.OffsetX or 0
		data.OffsetY = data.OffsetY or 0
		data.NoiseTexture = data.NoiseTexture or "detail/noise_detail_01"
		data.NoiseScaleX = data.NoiseScaleX or 1
		data.NoiseScaleY = data.NoiseScaleY or 1
		data.NoiseOffsetX = data.NoiseOffsetX or 0
		data.NoiseOffsetY = data.NoiseOffsetY or 0
		texture = texture:lower()
		texture = string.Trim(texture)
		local tempMat = Material(texture)
		if string.find(texture, "../", 1, true) or string.find(texture, "pp/", 1, true) then return end
		local uid = texture .. "+" .. data.ScaleX .. "+" .. data.ScaleY .. "+" .. data.OffsetX .. "+" .. data.OffsetY

		if data.UseNoise then
			uid = uid .. (data.NoiseTexture or "detail/noise_detail_01") .. "+" .. (data.NoiseScaleX or 1) .. "+" .. (data.NoiseScaleY or 1) .. "+" .. (data.NoiseOffsetX or 0) .. "+" .. (data.NoiseOffsetY or 0)
		end

		uid = string.gsub(uid, "%.", "-")
		if not self.stored[uid] then
			if not tempMat:GetTexture("$basetexture") then
				return
			end

			local matTable = {
				["$basetexture"] = tempMat:GetName(),
				["$basetexturetransform"] = "center .5 .5 scale " .. (1 / data.ScaleX) .. " " .. (1 / data.ScaleY) .. " rotate 0 translate " .. data.OffsetX .. " " .. data.OffsetY,
				["$vertexalpha"] = 0,
				["$vertexcolor"] = 1
			}

			for k, v in pairs(data) do
				if k:sub(1, 1) == "$" then
					matTable[k] = v
				end
			end

			if data.UseNoise then
				matTable["$detail"] = data.NoiseTexture
			end

			if file.Exists("materials/" .. texture .. "_normal.vtf", "GAME") then
				matTable["$bumpmap"] = texture .. "_normal"
				matTable["$bumptransform"] = "center .5 .5 scale " .. (1 / data.ScaleX) .. " " .. (1 / data.ScaleY) .. " rotate 0 translate " .. data.OffsetX .. " " .. data.OffsetY
			end

			local matrix = Matrix()
			matrix:Scale(Vector(1 / data.ScaleX, 1 / data.ScaleY, 1))
			matrix:Translate(Vector(data.OffsetX, data.OffsetY, 0))
			local noiseMatrix = Matrix()
			noiseMatrix:Scale(Vector(1 / data.NoiseScaleX, 1 / data.NoiseScaleY, 1))
			noiseMatrix:Translate(Vector(data.NoiseOffsetX, data.NoiseOffsetY, 0))

			local stored = CreateMaterial(uid, "VertexLitGeneric", matTable)
			stored:SetTexture("$basetexture", tempMat:GetTexture("$basetexture"))
			stored:SetMatrix("$basetexturetransform", matrix)
			stored:SetMatrix("$detailtexturetransform", noiseMatrix)
			self.stored[uid] = stored
		end

		ent.MaterialData = {
			texture = texture,
			ScaleX = data.ScaleX or 1,
			ScaleY = data.ScaleY or 1,
			OffsetX = data.OffsetX or 0,
			OffsetY = data.OffsetY or 0,
			UseNoise = data.UseNoise or false,
			NoiseTexture = data.NoiseTexture or "detail/noise_detail_01",
			NoiseScaleX = data.NoiseScaleX or 1,
			NoiseScaleY = data.NoiseScaleY or 1,
			NoiseOffsetX = data.NoiseOffsetX or 0,
			NoiseOffsetY = data.NoiseOffsetY or 0,
		}

		ent:SetMaterial("!" .. uid)
	end
end

if CLIENT then
	net.Receive("advmat.Materialize", function()
		local ent = net.ReadEntity()
		local texture = net.ReadString()
		local data = net.ReadTable()

		if IsValid(ent) then
			materials:Set(ent, texture, data)
		end
	end)

	netstream.Hook("advmat.Init", function(tab)
		if istable(tab) and not table.IsEmpty(tab) then
			table.Merge(materials.entList, tab)
		end
	end)

	hook.Add("OnEntityCreated", "matEditor.Init", function(ent)
		if not IsValid(ent) then return end

		local entIndex = ent:EntIndex()
		local info = materials.entList[entIndex]
		if info then
			materials:Set(ent, info.texture, info)
		end
	end)
else
	-- timer.Create("AdvMatSync", 30, 0, function()
	-- 	for k, v in pairs(ents.GetAll()) do
	-- 		if IsValid(v) and v.MaterialData then
	-- 			materials:Set(v, v.MaterialData.texture, v.MaterialData)
	-- 		end
	-- 	end
	-- end)

	hook.Add("PlayerInitialized", "matEditor.Sync", function(ply)
		netstream.Start(ply, "advmat.Init", materials.entList)
	end)
end

duplicator.RegisterEntityModifier("MaterialData", function(player, entity, data)
	materials:Set(entity, data.texture, data)
end)