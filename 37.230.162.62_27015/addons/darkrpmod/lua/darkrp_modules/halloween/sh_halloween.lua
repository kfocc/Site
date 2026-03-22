-- halloweenItems = halloweenItems or {}
halloweenItems = {}
halloweenCfg = {}

PL.Add("HPoints", {"поинта", "поинтов", "поинтов"})
PL.Add("HPointsEnt", {"поинт", "поинта", "поинтов"})

local pMeta = FindMetaTable("Player")
function pMeta:GetHPoints()
	return self:GetNetVar("halloween.Points", 0)
end

hook.Add("loadCustomDarkRPItems", "halloweenItems", function()
	if not union.cvars.winter:GetBool() then return end
	-- local function randomBdgrps(ply)
	-- 	local num = ply:GetNumBodyGroups() - 1
	-- 	for i = 1, num do
	-- 		local max = ply:GetBodygroupCount(i)
	-- 		ply:SetBodygroup(i, math.random(0, max - 1))
	-- 	end
	-- end
	table.insert(halloweenItems, {
		id = "zck_snowballswep_dmg",
		price = 5,
		model = "models/zerochain/props_christmas/snowballswep/zck_w_snowballswep.mdl",
		name = "Волшебный снежок",
		desc = "Дает снежок, который может наносить урон.",
		req = function(ply)
			if ply:HasWeapon("zck_snowballswep_dmg") then return false, "У Вас уже есть этот свеп!" end
			return true
		end,
		func = function(ply) ply:Give("zck_snowballswep_dmg") end
	})
end)

table.insert(halloweenItems, {
	id = "money1",
	price = 5,
	model = "models/props/cs_assault/money.mdl",
	name = "10.000 токенов",
	desc = "Меняет поинты на токены",
	func = function(ply) ply:addMoney("10000") end
})

table.insert(halloweenItems, {
	id = "money2",
	price = 12,
	model = "models/props/cs_assault/money.mdl",
	name = "40.000 токенов",
	desc = "Меняет поинты на токены",
	func = function(ply) ply:addMoney("40000") end
})

table.insert(halloweenItems, {
	id = "money3",
	price = 18,
	model = "models/props/cs_assault/money.mdl",
	name = "60.000 токенов",
	desc = "Меняет поинты на токены",
	func = function(ply) ply:addMoney("60000") end
})

local milk
table.insert(halloweenItems, {
	id = "magicmilk",
	price = 3,
	model = "models/props_junk/garbage_milkcarton002a.mdl",
	name = "Волшебное молоко",
	desc = "Дает таинственную силу.",
	func = function(ply)
		if not milk then
			for _, v in pairs(FoodItems) do
				if v.name == "Волшебное молоко" then milk = v end
			end
		end

		local sfood = ents.Create("spawned_food")
		if not IsValid(sfood) then return end
		-- sfood.DarkRPItem = foodTable
		sfood:Setowning_ent(ply)
		sfood:SetPos(ply:EyePos())
		sfood.onlyremover = true
		sfood.SID = ply.SID
		sfood:SetModel("models/props_junk/garbage_milkcarton002a.mdl")
		sfood.FoodName = milk.name
		sfood.FoodEnergy = milk.energy
		sfood.FoodPrice = milk.price
		sfood.foodItem = milk
		sfood:Spawn()
		timer.Simple(0.1, function()
			local canPickup = hook.Run("canPocketLimit", ply, sfood)
			if canPickup == false then
				DarkRP.notify(ply, 0, 4, "У Вас недостаточно места в сумке, молоко у вас под ногами!")
			else
				ply:addPocketItem(sfood)
				DarkRP.notify(ply, 2, 4, "Молоко у Вас в сумке!")
			end
		end)
	end
})


halloweenCfg.poses = {
	Vector(-7494.2041015625, 8760.51171875, 3781.6770019531),
	Vector(-7221.9248046875, 7934.2407226563, 3740.03125),
	Vector(-5986.7026367188, 8372.61328125, 3740.03125),
	Vector(-7688.0180664063, 9927.5966796875, 3740.03125),
	Vector(-6503.8256835938, 11122.466796875, 3740.03125),
	Vector(-5496.6162109375, 11248.682617188, 3700.03125),
	Vector(-6024.1284179688, 10744.921875, 3740.03125),
	Vector(-4992.3129882813, 10811.08984375, 3708.03125),
	Vector(-5390.099609375, 9466.2431640625, 3868.03125),
	Vector(-3772.1240234375, 10455.500976563, 4132.03125),
	Vector(-2551.7663574219, 10734.466796875, 3804.03125),
	Vector(-3137.4660644531, 11490.658203125, 3804.03125),
	Vector(-4288.68359375, 13488.379882813, 3804.03125),
	Vector(-3432.7775878906, 12758.770507813, 3804.03125),
	Vector(-4223.203125, 15401.356445313, 3804.03125),
	Vector(-2527.1997070313, 15964.419921875, 3868.03125),
	Vector(-2564.9475097656, 15473.505859375, 4268.03125),
	Vector(-4341.6005859375, 13698.34765625, 2621.03125),
	Vector(-3925.2897949219, 14721.44140625, 2222.03125),
	Vector(-4613.1303710938, 14167.724609375, 2439.03125),
	Vector(-3669.9721679688, 14257.905273438, 2621.03125),
	Vector(-1639.4765625, 12884.588867188, 2621.03125),
	Vector(-190.40264892578, 13398.04296875, 2679.03125),
	Vector(508.79095458984, 14388.21875, 2701.03125),
	Vector(624.38751220703, 12922.758789063, 2701.03125),
	Vector(444.97018432617, 11942.470703125, 3045.03125),
	Vector(579.68804931641, 8659.3564453125, 2797.03125),
	Vector(720.92291259766, 8979.873046875, 2925.03125),
	Vector(334.51702880859, 7744.4150390625, 2637.03125),
	Vector(-1065.0404052734, 6372.302734375, 3496.03125),
	Vector(-875.89654541016, 6159.6552734375, 3890.212890625),
	Vector(-497.78329467773, 5816.5322265625, 3895.5607910156),
	Vector(-3755.2741699219, 10694.034179688, 4356.03125),
	Vector(-2534.3298339844, 8351.828125, 4356.03125),
	Vector(683.61016845703, 9515.6923828125, 3796.03125),
	Vector(992.55743408203, 9922.240234375, 3796.03125),
	Vector(995.08404541016, 10327.8515625, 3796.03125),
	Vector(2446.6840820313, 11007.850585938, 3796.03125),
	Vector(2940.2912597656, 11332.60546875, 3796.03125),
	Vector(2093.8823242188, 6409.0375976563, 3796.03125),
	Vector(2928.2705078125, 6265.7153320313, 3796.03125),
	Vector(1814.6334228516, 7058.6708984375, 3796.03125),
	Vector(229.34791564941, 6083.0732421875, 3924.03125),
	Vector(2551.2319335938, 7556.5678710938, 5332.03125),
	Vector(2044.2072753906, 12718.891601563, 5332.03125),
	Vector(2893.7966308594, 12143.7734375, 4789.03125),
	Vector(1058.3966064453, 10133.626953125, 7376.03125),
	Vector(2513.1550292969, 8772.8564453125, 8112.03125),
	Vector(-1143.9047851563, 7835.2939453125, 3940.03125),
	Vector(-1525.3227539063, 6969.1606445313, 3940.03125),
	Vector(-3577.0280761719, 7252.2739257813, 3804.03125),
	Vector(-3657.3395996094, 7845.7963867188, 4060.03125),
	Vector(-4693.6840820313, 6496.6162109375, 4067.03125),
	Vector(-6432.0625, 7421.3701171875, 3867.53125),
	Vector(-6010.0278320313, 6548.1479492188, 3804.03125),
	Vector(-3181.9313964844, 4840.9375, 3804.03125),
	Vector(-2690.4262695313, 5514.2080078125, 3804.03125),
	Vector(-1518.33203125, 4911.82421875, 3556.6223144531),
	Vector(-4810.84375, 4683.7109375, 4060.03125),
	Vector(-5230.6044921875, 4609.1845703125, 3804.03125),
	Vector(-6313.8676757813, 6452.580078125, 3476.03125),
	Vector(-7541.9956054688, 7238.0263671875, 3868.03125),
	Vector(-7088.4208984375, 6448.8901367188, 3804.03125),
	Vector(-7115.7333984375, 5894.91015625, 3868.03125),
	Vector(-7553.1870117188, 4728.8540039063, 3800.03125),
	Vector(-8061.4516601563, 4660.8354492188, 3800.03125),
	Vector(-9642.02734375, 4751.787109375, 3844.2609863281),
	Vector(-6663.8120117188, 6525.3188476563, 3612.03125),
	Vector(-10274.487304688, 5576.3095703125, 3800.03125),
	Vector(-10535.186523438, 6051.9033203125, 3419.2431640625),
	Vector(-10869.8671875, 6229.779296875, 3929.03125),
	Vector(-11694.90625, 5304.0971679688, 3865.03125),
	Vector(-11484.07421875, 4929.859375, 3864.03125),
	Vector(-9451.51953125, 5003.2172851563, 3736.03125),
	Vector(-6368.4423828125, 6453.57421875, 4188.03125),
	Vector(-5046.958984375, 6353.7700195313, 4316.03125),
	Vector(-5585.662109375, 6459.0776367188, 4188.03125),
	Vector(-9745.3916015625, 5600.2543945313, 4320.03125),
	Vector(-3171.1196289063, 5236.1401367188, 3819.03125),
	Vector(-4505.1962890625, 4740.2329101563, 3804.03125),
}
