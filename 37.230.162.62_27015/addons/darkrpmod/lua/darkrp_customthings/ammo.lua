local function restrict(ply)
	return ply:getJobTable().ammoseller
end

DarkRP.createAmmoType("pistol", {
	name = "Pistol | 100",
	model = "models/Items/BoxSRounds.mdl",
	price = 100,
	amountGiven = 100,
	customCheck = function(ply) return restrict(ply) end
})

DarkRP.createAmmoType("buckshot", {
	name = "Buckshot | 50",
	model = "models/Items/BoxBuckshot.mdl",
	price = 200,
	amountGiven = 50,
	customCheck = function(ply) return restrict(ply) end
})

DarkRP.createAmmoType("smg1", {
	name = "Smg | 100",
	model = "models/Items/BoxMRounds.mdl",
	price = 200,
	amountGiven = 100,
	customCheck = function(ply) return restrict(ply) end
})

DarkRP.createAmmoType("357", {
	name = "357 | 50",
	model = "models/Items/357ammo.mdl",
	price = 200,
	amountGiven = 50,
	customCheck = function(ply) return restrict(ply) end
})

DarkRP.createAmmoType("ar2", {
	name = "Assault | 100",
	model = "models/Items/combine_rifle_cartridge01.mdl",
	price = 300,
	amountGiven = 100,
	customCheck = function(ply) return restrict(ply) end
})

DarkRP.createAmmoType("xbowbolt", {
	name = "Болты | 20",
	model = "models/Items/CrossbowRounds.mdl",
	price = 500,
	amountGiven = 20,
	customCheck = function(ply) return restrict(ply) end
})

DarkRP.createAmmoType("rpg_round", {
	name = "Ракета | 1",
	model = "models/weapons/w_missile_closed.mdl",
	price = 600,
	amountGiven = 1,
	customCheck = function(ply) return restrict(ply) end
})

-- DarkRP.createAmmoType("rpg_round", {
--     name = "Ракета | 3",
--     model = "models/weapons/w_missile_closed.mdl",
--     price = 2000,
--     amountGiven = 3,
--     customCheck = function(ply)
--         return restrict(ply)
--     end
-- })
-- DarkRP.createAmmoType("rpg_round", {
--     name = "Ракета | 5",
--     model = "models/weapons/w_missile_closed.mdl",
--     price = 3500,
--     amountGiven = 5,
--     customCheck = function(ply)
--         return restrict(ply)
--     end
-- })
DarkRP.createAmmoType("smg1_grenade", {
	name = "Smg граната | 1",
	model = "models/Items/AR2_Grenade.mdl",
	price = 500,
	amountGiven = 1,
	customCheck = function(ply) return restrict(ply) end
})
