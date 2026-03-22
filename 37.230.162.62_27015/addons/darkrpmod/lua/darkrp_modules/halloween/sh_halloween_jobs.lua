hook.Add("loadCustomDarkRPItems", "halloween", function()
	if not union.cvars.halloween:GetBool() then return end
	local halloween_spawn1 = {
		Vector(-6606.384277, 7508.295410, 3867.531250),
		Vector(-6029.937500, 6613.931641, 3804.031250),
		Vector(-1078.476196, 7782.395020, 3940.031250),
		Vector(-3108.000488, 4794.535645, 3804.031250),
		Vector(-10648.084961, 5616.570801, 3800.031250),
	}
	local halloween_spawn2 = {
		Vector(-6116.420898, 6341.208496, 3476.031250),
		Vector(-6368.534668, 6441.352539, 4188.031250),
		Vector(-5047.875488, 6312.562500, 4316.031250),
		Vector(-5717.861328, 4669.288086, 3932.031250),
		Vector(-4299.580078, 7637.506348, 4060.031250),
		Vector(-3766.143555, 7807.393555, 4060.031250),
		Vector(-3535.629395, 7766.102051, 4316.031250),
		Vector(-3626.390381, 10798.324219, 4132.031250),
	}
	local halloween_spawn3 = {
		Vector(-1893.1212158203, 16162.334960938, 3382.03125),
		Vector(-4227.548828, 15390.991211, 3804.031250),
		Vector(-2033.950562, 15005.584961, 2647.031250),
		Vector(-2293.895264, 13870.958984, 2621.031250),
		Vector(-469.334625, 13842.601563, 2701.031250),
		Vector(640.716614, 13236.450195, 2745.031250),
		Vector(643.988464, 12919.039063, 2745.031250),
		Vector(110.919060, 8073.418457, 2973.031250),
		Vector(-1074.250610, 6321.901367, 3496.031250),
		Vector(640.080994, 8655.763672, 2797.031250),
	}

	TEAM_HALLOWEEN1 = DarkRP.createJob("Хэллоуинский псих", {
		color = Color(99, 0, 0, 255),
		model = {"models/splinks/jeff_the_killer/jeff.mdl",},
		description = [[Кажется Медики ГСР что-то напутали с дозировкой лекарств...
		Нападает только на вооруженных игроков. Умирает через 10 минут.]],
		weapons = {"zombieswep2", "med_kit_onlyme"},
		command = "halloween1_2025",
		nosoundsc = true,
		max = 1,
		armor = 100,
		maxarmor = 100,
		cantbuydoor = true,
		cantberobbed = true,
		nospawnprop = true,
		nostun = true,
		bhop = true,
		salary = 0,
		admin = 0,
		spawns = halloween_spawn1,
		citizen = true,
		vote = false,
		nocuffs = true,
		hasLicense = false,
		cantAdvert = true,
		PlayerDeath = function(ply)
			if ply:Team() == TEAM_HALLOWEEN1 then
				ply:changeTeam(TEAM_CITIZEN1, true)
				DarkRP.notifyAll(1, 4, "Хэллоуинский псих был убит!")
			end
		end,
		type = "Commerce2",
		unlockCost = 100000,
		category = "Others",
		PlayerSpawn = function(ply) ply:SetRunSpeed(500) end,
	})

	TEAM_HALLOWEEN2 = DarkRP.createJob("Хэллоуинский маньяк", {
		color = Color(99, 0, 0, 255),
		model = {"models/models/konnie/jasonpart2/jasonpart2.mdl",},
		description = [[Таинственный маньяк, может принимать облик людей.
		Орудует только в городе! Убивает кого угодно. Умирает через 10 минут.]],
		weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "lockpick_pro", "swep_disguise_briefcase", "tfa_nmrih_fireaxe", "tfa_nmrih_asaw"},
		command = "halloween2_2025",
		max = 1,
		salary = 0,
		spawns = halloween_spawn2,
		admin = 0,
		vote = false,
		citizen = true,
		nocuffs = true,
		nostun = true,
		hasLicense = false,
		sname = true,
		PlayerDeath = function(ply)
			if ply:Team() == TEAM_HALLOWEEN2 then
				ply:changeTeam(TEAM_CITIZEN1, true)
				DarkRP.notifyAll(1, 4, "Хэллоуинский маньяк был убит!")
			end
		end,
		category = "Citizens",
		type = "Bandits",
		unlockCost = 100000,
		BodyGroup = function(ply) ply:SetBodygroup(1, math.random(0, 1)) end,
		PlayerSpawn = function(ply) ply:SetRunSpeed(290) end,
	})

	TEAM_HALLOWEEN3 = DarkRP.createJob("Хэллоуинский потрошитель", {
		color = Color(99, 0, 0, 255),
		model = {"models/models/konnie/savini/savini.mdl"},
		description = [[Отродье из ада, обладает сверхспособностями.
		Орудует только в запретном секторе! Убивает кого угодно. Умирает через 10 минут.]],
		weapons = {"med_kit_onlyme", "hidden", "jeffswep"},
		command = "halloween3_2025",
		max = 1,
		salary = 0,
		spawns = halloween_spawn3,
		admin = 0,
		armor = 100,
		maxarmor = 100,
		cantbuydoor = true,
		cantberobbed = true,
		nospawnprop = true,
		nostun = true,
		vote = false,
		citizen = true,
		nocuffs = true,
		hasLicense = false,
		PlayerDeath = function(ply)
			if ply:Team() == TEAM_HALLOWEEN3 then
				ply:changeTeam(TEAM_CITIZEN1, true)
				DarkRP.notifyAll(1, 4, "Хэллоуинский потрошитель был убит!")
			end
		end,
		category = "Citizens",
		type = "Sector6",
		unlockCost = 100000,
		BodyGroup = function(ply) ply:SetBodygroup(1, math.random(0, 1)) end,
		PlayerSpawn = function(ply) ply:SetRunSpeed(300) end,
	})

	local admin = RPExtraTeams[TEAM_ADMIN]
	admin.model = {
		"models/death_a_grim_bundle/player_models/death_classic/death_classic_01.mdl",
		"models/death_a_grim_bundle/player_models/death_painted/death_painted_01.mdl",
		"models/death_a_grim_bundle/player_models/death_black/death_black_01.mdl",
	}
	admin.BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 20))
		ply:SetBodygroup(1, math.random(0, 12))
		ply:SetBodygroup(2, math.random(0, 12))
		ply:SetBodygroup(3, math.random(0, 1))
		ply:SetBodygroup(4, math.random(0, 2))
		ply:SetBodygroup(5, math.random(0, 12))
		ply:SetBodygroup(6, math.random(0, 3))
		ply:SetBodygroup(7, math.random(0, 1))
		ply:SetBodygroup(8, math.random(0, 1))
		ply:SetBodygroup(9, math.random(0, 10))
	end

	for k, v in pairs(admin.model) do
		util.PrecacheModel(v)
	end
end)

hook.Add("PostGamemodeLoaded", "Halloween", function()
	if not union.cvars.halloween:GetBool() then return end
	diseases.config.TeamsToImmune[TEAM_HALLOWEEN1] = true
	diseases.config.TeamsToImmune[TEAM_HALLOWEEN2] = true
	diseases.config.TeamsToImmune[TEAM_HALLOWEEN3] = true
	GetPropList()["Хэллоуин"] = {
		"models/death_a_grim_bundle/death_scythe/death_scythe_01.mdl",
		"models/halloweenpropstuff/axe.mdl",
		"models/halloweenpropstuff/bone.mdl",
		"models/halloweenpropstuff/bowl of candy corn.mdl",
		"models/halloweenpropstuff/candle.mdl",
		"models/halloweenpropstuff/cauldron.mdl",
		"models/halloweenpropstuff/coffin.mdl",
		"models/halloweenpropstuff/knife.mdl",
		"models/halloweenpropstuff/lantern.mdl",
		"models/halloweenpropstuff/pumpkin.mdl",
		"models/halloweenpropstuff/scythe.mdl",
		"models/halloweenpropstuff/witch hat.mdl",
		"models/props/pumpkin_z.mdl",
		"models/props_halloween/pumpkin_03.mdl",
		"models/props_halloween/jackolantern_01.mdl",
		"models/props_halloween/pumpkin_02.mdl",
		"models/props_halloween/pumpkin_01.mdl",
		"models/props_halloween/jackolantern_02.mdl"
	}
end, HOOK_LOW)
