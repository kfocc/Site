local playermodels = {}

local cp_path_models = file.Find("models/ggl/cp/*.mdl", "GAME")
for _, file_name in ipairs(cp_path_models) do
	table.insert(playermodels, {file_name:sub(0, -4), "models/ggl/cp/" .. file_name})
end

local citizen_path_models = file.Find("models/player/tnb/citizens/*.mdl", "GAME")
for _, file_name in ipairs(citizen_path_models) do
	table.insert(playermodels, {file_name:sub(0, -4), "models/player/tnb/citizens/" .. file_name})
end

-- local ota_models = {
-- 	"models/player/combine_advisor_guard.mdl",
-- 	"models/player/combine_advisor_guard_armored.mdl",
-- 	"models/player/combine_advisor_guard_soldier.mdl",
-- 	"models/player/combine_advisor_guard_soldier_armored.mdl",
-- 	"models/player/combine_elite_guard.mdl",
-- 	"models/player/combine_elite_guard_armored.mdl",
-- 	"models/player/combine_elite_soldier.mdl",
-- 	"models/player/combine_elite_soldier_armored.mdl",
-- 	"models/player/combine_guard_armored.mdl",
-- 	"models/player/combine_heavy.mdl",
-- 	"models/player/combine_hunter.mdl",
-- 	"models/player/combine_hunter_armored.mdl",
-- 	"models/player/combine_hunter_soldier.mdl",
-- 	"models/player/combine_hunter_soldier_armored.mdl",
-- 	"models/player/combine_shotgunner_armored.mdl",
-- 	"models/player/combine_soldier_armored.mdl",
-- 	"models/player/combine_soldier_customcombinepmv2.mdl",
-- 	"models/player/combine_soldier_prisonguard_customcombinepmv2.mdl",
-- 	"models/player/combine_super_elite_soldier.mdl",
-- 	"models/player/combine_super_elite_soldier_armored.mdl",
-- 	"models/player/combine_super_shotgunner.mdl",
-- 	"models/player/combine_super_shotgunner_armored.mdl",
-- 	"models/player/combine_super_soldier_armored.mdl",
-- 	"models/player/combine_super_soldier_customcombinepmv2.mdl"
-- }

local models = {
	"models/player/alyx.mdl",
	"models/player/arctic.mdl",
	"models/player/barney.mdl",
	"models/player/bms_vortigaunt.mdl",
	"models/player/breen.mdl",
	"models/player/charple.mdl",
	"models/player/combine_advisor_guard.mdl",
	"models/player/combine_advisor_guard_armored.mdl",
	"models/player/combine_advisor_guard_soldier.mdl",
	"models/player/combine_advisor_guard_soldier_armored.mdl",
	"models/player/combine_elite_guard.mdl",
	"models/player/combine_elite_guard_armored.mdl",
	"models/player/combine_elite_soldier.mdl",
	"models/player/combine_elite_soldier_armored.mdl",
	"models/player/combine_guard_armored.mdl",
	"models/player/combine_heavy.mdl",
	"models/player/combine_hunter.mdl",
	"models/player/combine_hunter_armored.mdl",
	"models/player/combine_hunter_soldier.mdl",
	"models/player/combine_hunter_soldier_armored.mdl",
	"models/player/combine_shotgunner_armored.mdl",
	"models/player/combine_soldier.mdl",
	"models/player/combine_soldier_armored.mdl",
	"models/player/combine_soldier_customcombinepmv2.mdl",
	"models/player/combine_soldier_prisonguard.mdl",
	"models/player/combine_soldier_prisonguard_customcombinepmv2.mdl",
	"models/player/combine_super_elite_soldier.mdl",
	"models/player/combine_super_elite_soldier_armored.mdl",
	"models/player/combine_super_shotgunner.mdl",
	"models/player/combine_super_shotgunner_armored.mdl",
	"models/player/combine_super_soldier.mdl",
	"models/player/combine_super_soldier_armored.mdl",
	"models/player/combine_super_soldier_customcombinepmv2.mdl",
	"models/player/corpse1.mdl",
	--"models/player/cs_player_shared.mdl",
	--"models/player/ct_gign.mdl", -- t-pose
	--"models/player/ct_gsg9.mdl", -- t-pose
	--"models/player/ct_sas.mdl", -- t-pose
	--"models/player/ct_urban.mdl", -- t-pose
	"models/player/dod_american.mdl",
	"models/player/dod_german.mdl",
	"models/player/eli.mdl",
	"models/player/gasmask.mdl",
	"models/player/gman_high.mdl",
	"models/player/guerilla.mdl",
	"models/player/kleiner.mdl",
	"models/player/leet.mdl",
	"models/player/magnusson.mdl",
	"models/player/monk.mdl",
	"models/player/mossman.mdl",
	"models/player/mossman_arctic.mdl",
	"models/player/odessa.mdl",
	"models/player/p2_chell.mdl",
	"models/player/phoenix.mdl",
	"models/player/poison_player.mdl",
	"models/player/police.mdl",
	"models/player/police_fem.mdl",
	"models/player/riot.mdl",
	"models/player/skeleton.mdl",
	"models/player/soldier_stripped.mdl",
	"models/player/swat.mdl",
	"models/player/t_arctic.mdl",
	"models/player/t_guerilla.mdl",
	"models/player/t_leet.mdl",
	"models/player/t_phoenix.mdl",
	"models/player/urban.mdl",
	"models/player/zombie_classic.mdl",
	"models/player/zombie_fast.mdl",
	"models/player/zombie_soldier.mdl",
}

for _, model in ipairs(models) do
	local name = model:sub(15, -5)
	table.insert(playermodels, {name, model})
end

local function ExistsModel(tbl, model)
	for _, v in pairs(tbl) do
		if v == model then return true end
	end
	return false
end

timer.Simple(0, function()
	local all_models = player_manager.AllValidModels()
	for _, model_info in ipairs(playermodels) do
		local name, path = unpack(model_info)
		if not ExistsModel(all_models, path) then player_manager.AddValidModel(name, path) end
	end
end)
