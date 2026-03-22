unionrp = unionrp or {}

local prib = {
	Vector(-8079.7685546875,8909.654296875,3740.03125),
	Vector(-8077.2275390625,9030.0263671875,3740.03125),
	Vector(-7957.962890625,9027.509765625,3740.03125),
	Vector(-7960.4418945312,8909.994140625,3740.03125),
	Vector(-7839.982421875,8990.7958984375,3740.03125),
	Vector(-7718.15234375,8986.2080078125,3740.03125),
	Vector(-7597.8500976562,9015.427734375,3740.03125),
	Vector(-7538.9887695312,8918.826171875,3740.03125),
	Vector(-7515.5439453125,9040.9755859375,3740.03125),
	Vector(-7404.5854492188,9040.71484375,3740.03125),
	Vector(-7404.9326171875,8896.4306640625,3740.03125),
	Vector(-7283.7172851562,8905.060546875,3740.03125),
	Vector(-7270.3984375,9040.734375,3740.03125),
	Vector(-7142.8041992188,9038.0048828125,3740.03125),
	Vector(-7135.2075195312,8912.7578125,3740.03125),
	Vector(-7047.3500976562,8913.4599609375,3740.03125),
	Vector(-7020.9086914062,9030.24609375,3740.03125),
	Vector(-6919.1928710938,9034.8193359375,3740.03125),
	Vector(-6885.62890625,8899.77734375,3740.03125),
	Vector(-6783.0239257812,8897.7294921875,3740.03125),
	Vector(-6761.1572265625,9029.9267578125,3740.03125),
	Vector(-6641.873046875,9029.005859375,3740.03125),
	Vector(-6642.0454101562,8901.3876953125,3740.03125),
	Vector(-6562.28125,8909.8369140625,3740.03125),
	Vector(-6549.4125976562,9019.029296875,3740.03125),
	Vector(-6430.3793945312,9230.8896484375,3740.03125),
	Vector(-6334.1982421875,9228.974609375,3740.03125),
	Vector(-6235.9755859375,9227.3642578125,3740.03125),
	Vector(-6237.8110351562,9141.431640625,3740.03125),
	Vector(-6330.3671875,9134.3701171875,3740.03125),
	Vector(-6334.5048828125,9048.5400390625,3740.03125),
	Vector(-6335.2705078125,8944.0078125,3740.03125),
	Vector(-6334.8017578125,8847.80859375,3740.03125),
	Vector(-6402.0634765625,8495.3037109375,3740.03125),
	Vector(-6399.9604492188,8606.2314453125,3740.03125),
	Vector(-6254.8569335938,8542.013671875,3740.03125),
	Vector(-6247.37890625,8693.0107421875,3740.03125),
	Vector(-6243.3745117188,8820.5634765625,3740.03125),
	Vector(-6241.689453125,8916.9755859375,3740.03125),
	Vector(-6249.1352539062,9074.0380859375,3740.03125),
	Vector(-6252.7573242188,9264.6982421875,3740.03125)
}
local cits = {
	Vector(-5570.591796875,10277.159179688,3868.03125),
	Vector(-5494.7421875,10178.5703125,3868.03125),
	Vector(-5461.6450195312,10276.766601562,3868.03125),
	Vector(-5359.0234375,10187.477539062,3868.03125),
	Vector(-5298.095703125,10284.924804688,3868.03125),
	Vector(-5204.8569335938,10197.978515625,3868.03125),
	Vector(-5154.6748046875,10289.173828125,3868.03125),
	Vector(-5053.6391601562,10201.51953125,3868.03125),
	Vector(-4988.3139648438,10288.123046875,3868.03125),
	Vector(-4884.771484375,10294.291992188,3868.03125),
	Vector(-4844.0161132812,10219.6640625,3868.03125)
}
local gsr = {
	Vector(-4781.5932617188,5106.4096679688,3804.03125),
	Vector(-4721.9829101562,5136.0502929688,3804.03125),
	Vector(-4621.2758789062,5131.3979492188,3804.03125),
	Vector(-4511.853515625,5130.2314453125,3804.03125),
	Vector(-4686.2314453125,5025.1967773438,3804.03125),
	Vector(-4752.8178710938,4944.7333984375,3804.03125)
}
local gsrzavod = {
	Vector(-8332.708984, 4438.718262, 3804.031250),
	Vector(-8280.905273, 4308.389160, 3804.031250)
}
local cps = {
	Vector(2524.8891601562,6954.9965820312,3796.03125),
	Vector(2445.4045410156,6952.1069335938,3796.03125),
	Vector(2367.83203125,6949.2866210938,3796.03125),
	Vector(2290.2595214844,6946.4663085938,3796.03125),
	Vector(2220.9943847656,6944.5947265625,3796.03125),
	Vector(2136.5029296875,6954.6171875,3796.03125),
	Vector(2138.9895019531,7024.0322265625,3796.03125),
	Vector(2216.5966796875,7022.525390625,3796.03125),
	Vector(2294.2194824219,7022.1391601562,3796.03125),
	Vector(2372.0554199219,7031.7612304688,3796.03125),
	Vector(2448.1787109375,7031.181640625,3796.03125),
	Vector(2525.8015136719,7030.8720703125,3796.03125),
	Vector(2525.4514160156,7110.40625,3796.03125),
	Vector(2448.1079101562,7113.13671875,3796.03125),
	Vector(2368.6123046875,7110.6005859375,3796.03125),
	Vector(2292.00390625,7109.234375,3796.03125),
	Vector(2215.3864746094,7108.6630859375,3796.03125),
	Vector(2141.6833496094,7108.2719726562,3796.03125),
	Vector(2141.3239746094,7177.5595703125,3796.03125),
	Vector(2218.9287109375,7179.255859375,3796.03125),
	Vector(2298.4411621094,7181.228515625,3796.03125),
	Vector(2367.7255859375,7182.076171875,3796.03125),
	Vector(2446.3498535156,7181.498046875,3796.03125),
	Vector(2523.97265625,7181.1118164062,3796.03125),
	Vector(2524.1137695312,7256.822265625,3796.03125),
	Vector(2446.4909667969,7256.4086914062,3796.03125),
	Vector(2368.8681640625,7255.9951171875,3796.03125),
	Vector(2292.7749023438,7262.3110351562,3796.03125),
	Vector(2211.1538085938,7261.7895507812,3796.03125),
	Vector(2135.8134765625,7261.3403320312,3796.03125)
}
local cmds = {
	Vector(1668.6881103516,12086.947265625,5332.03125),
	Vector(1569.3929443359,12100.809570312,5332.03125),
	Vector(1458.4375,12101.208007812,5332.03125),
	Vector(1361.7764892578,12075.810546875,5332.03125)
}
local otas = {
	Vector(1248.639160, 7804.563477, 5332.031250),
	Vector(1363.415527, 7807.266113, 5332.031250),
	Vector(1147.902466, 7652.585449, 5332.031250),
	Vector(1148.118530, 7558.835449, 5332.031250),
	Vector(1275.943359, 7404.757324, 5332.031250),
	Vector(1407.458008, 7378.817871, 5332.031250),
	Vector(1405.374878, 7500.670898, 5332.031250),
	Vector(1294.161499, 6907.672852, 5332.031250),
	Vector(1304.545288, 7173.394531, 5332.031250)
}
local rebel = {
Vector(-1024.988647, 9675.132812, 2477.031250),
Vector(-1118.795410, 9676.229492, 2477.031250),
Vector(-1212.835938, 9675.231445, 2477.031250),
Vector(-1309.719604, 9675.785156, 2477.031250),
Vector(-1400.460693, 9676.394531, 2477.031250),
Vector(-1500.522705, 9677.082031, 2477.031250),
Vector(-1594.279663, 9677.728516, 2477.031250),
Vector(-1198.407593, 10247.121094, 2477.031250),
Vector(-1104.735352, 10248.010742, 2477.031250),
Vector(-1007.862549, 10249.032227, 2477.031250),
Vector(-1007.422974, 10342.497070, 2477.031250),
Vector(-1101.189697, 10342.568359, 2477.031250),
Vector(-1198.039429, 10343.753906, 2477.031250),
Vector(-1197.547363, 10437.264648, 2477.031250),
Vector(-1100.514648, 10438.660156, 2477.031250),
Vector(-1003.836487, 10439.824219, 2477.031250),
Vector(-1007.177490, 10531.394531, 2477.031250),
Vector(-1099.883423, 10534.421875, 2477.031250),
Vector(-1196.430054, 10534.513672, 2477.031250),
}
local beg = {
Vector(288.77456665039, 8144.8432617188, 2813.03125),
Vector(61.605625152588, 8142.4936523438, 3133.03125),
Vector(787.91107177734, 8983.9130859375, 2797.03125),
Vector(873.94128417969, 11779.655273438, 2717.03125),
Vector(134.79696655273, 11467.022460938, 3045.03125),
Vector(-41.513233184814, 9760.7578125, 2973.03125),
Vector(-1045.3109130859, 6347.3896484375, 3496.03125),
}
local bangs = {
Vector(-1650.165527, 7130.000977, 3940.031250),
Vector(-1643.213745, 7236.900391, 3940.031250),
Vector(-1734.424805, 7249.466309, 3940.031250),
Vector(-1734.352417, 7134.245605, 3940.031250),
}
local admin = {
	Vector(-3998.573486, 7799.464355, 5726.031250),
	Vector(-3845.464600, 7805.587402, 5726.031250),
	Vector(-3646.024658, 7818.075195, 5726.031250),
}
local rct = {
	Vector(-6334.6376953125,10970.17578125,3740.03125),
	Vector(-6338.4135742188,10816.771484375,3740.03125),
	Vector(-6354.458984375,10707.583984375,3740.03125),
	Vector(-6544.8623046875,11135.291015625,3740.03125),
}
local zombie = {
  Vector(-1893.1212158203, 16162.334960938, 3382.03125),
  Vector(-4227.548828, 15390.991211, 3804.031250),
  Vector(-2033.950562, 15005.584961, 2647.031250),
  Vector(-2293.895264, 13870.958984, 2626.031250),
  Vector(-469.334625, 13842.601563, 2701.031250),
  Vector(110.919060, 8073.418457, 2973.031250),
  Vector(-1074.250610, 6321.901367, 3496.031250),
  Vector(578.194763, 8694.673828, 2798),
}

local iventzombie = {
  Vector(-462.066376, 11607.469727, 2543.196777),
  Vector(872.71533203125, 11767.375, 2717.03125),
  Vector(773.82464599609, 12939.4453125, 2725.1467285156),
  Vector(786.767029, 14647.405273, 2719.325439),
  Vector(-444.69711303711, 14228.692382812, 2701.03125),
  Vector(-1028.5024414062, 14054.650390625, 2626.03125),
  Vector(-371.67279052734, 9698.7109375, 2973.03125),
  Vector(-9590.259765625, 4522.4057617188, 3836.5498046875),
  Vector(-8368.3466796875, 4375.6879882812, 3800.03125),
  Vector(-6679.3295898438, 6336.8022460938, 3612.03125),
  Vector(-5504.9604492188, 6327.5390625, 3612.03125),
  Vector(-3173.6142578125, 4775.2651367188, 3804.03125),
  Vector(-1986.2838134766, 5220.9301757812, 3804.03125),
  Vector(-1088.7796630859, 6478.447265625, 3804.03125),
  Vector(-1055.1890869141, 7772.3579101562, 3940.03125),
  Vector(-4966.9990234375, 6542.6098632812, 3804.03125),
  Vector(-6605.4829101562, 7119.0864257812, 3804.03125),
  Vector(-4030.7365722656, 10138.427734375, 3804.03125),
  Vector(-3650.7487792969, 11305.776367188, 3804.03125),
  Vector(-4108.1362304688, 12345.743164062, 3796.03125),
  Vector(-4309.2114257812, 13477.470703125, 3804.03125),
  Vector(-3006.37890625, 16130.959960938, 3796.03125)
}
local freeman = {
	Vector(-11620, 5148, 3866),
}
local azbreen = {
	Vector(2817.2163085938,9526.6005859375,7376.03125),
	Vector(3050.6149902344,9970.5361328125,7376.03125),
}
local iventzone1 = {
	Vector(5416.1259765625, 8032.654296875, 7664.03125),
}
local iventzone2 = {
	Vector(5408.9526367188, -1447.1798095703, 7664.03125),
}
local iventzone3 = {
	Vector(14824.842773438, -1461.1328125, 7664.03125),
}
local iventzone4 = {
	Vector(14830.923828125, 8024.1440429688, 7664.03125),
}

--ГРАЖДАНСКИЕ
TEAM_CITIZEN = DarkRP.createJob("Неопознанное лицо", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/Group01/female_01.mdl",
		"models/player/Group01/female_02.mdl",
		"models/player/Group01/female_03.mdl",
		"models/player/Group01/female_04.mdl",
		"models/player/Group01/female_05.mdl",
		"models/player/Group01/female_06.mdl",
		"models/player/Group01/male_01.mdl",
		"models/player/Group01/male_02.mdl",
		"models/player/Group01/male_03.mdl",
		"models/player/Group01/male_04.mdl",
		"models/player/Group01/male_05.mdl",
		"models/player/Group01/male_06.mdl",
		"models/player/Group01/male_07.mdl",
		"models/player/Group01/male_08.mdl",
		"models/player/Group01/male_09.mdl"
	},
	description = [[Только приехал в город.]],
	weapons = {"keys", "hl2_hands"},
	command = "citizen",
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	nousescreeds = true,
	max = 0,
	maxarmor = 0,
	spawns = prib,
	salary = 10,
	admin = 0,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	category = "Others",
})
TEAM_BICH1 = DarkRP.createJob("Отброс общества", {
	color = Color(131, 64, 13, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Больной, никому не нужный человек.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new"},
	command = "bich1",
	cantbuydoor = true,
	cantberobbed = true,
	max = 0,
	spawns = bangs,
	citizen = true,
	salary = 10,
	admin = 0,
	vote = false,
	hasLicense = false,
	canusebandmask = true,

	type = "Bandits",
	category = "Others",
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(4, 5)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 1)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_CITIZEN1 = DarkRP.createJob("Гражданин", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[У вас есть CID карта и статус гражданина!
	Не нарушайте законы Альянса и возможно вы проживете еще один день.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "citizen1",
	max = 0,
	salary = 100,
	spawns = cits,
	admin = 0,
	vote = false,
	citizen = true,
	hasLicense = false,
	canusebandmask = true,
	category = "Citizens",
	type = "Commerce",
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})


--ГРАЖДАНСКИЕ БАНДИТЫ
TEAM_BICH2 = DarkRP.createJob("Гражданин [Вор]", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Уже освоился в городе. Но встал на тёмную дорогу.
	Теперь ворует токены и обчищает чужие дома!]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "bich2",
	max = 3,
	salary = 100,
	admin = 0,
	sname = true,
	citizen = true,
	hidetabjob = true,
	vote = false,
	hasLicense = false,
	canusebandmask = true,
	thief = true,
	spawns = cits,
	type = "Bandits",
	unlockCost = 15000,
	category = "Citizens",
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_BICH3 = DarkRP.createJob("Гражданин [Контрабандист]", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Уже освоился в городе.
	Зарабатывает продавая нелегальные вещи!]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "bich3",
	max = 3,
	salary = 100,
	admin = 0,
	sname = true,
	citizen = true,
	hidetabjob = true,
	vote = false,
	hasLicense = false,
	canusebandmask = true,
	contrabandseller = true,
	ammoseller = true,
	spawns = cits,
	type = "Bandits",
	unlockCost = 15000,
	category = "Citizens",
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})


--БАНДИТЫ
TEAM_BAND1 = DarkRP.createJob("Шестерка", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Низшая масть в иеерархии бандитов.
	Подчиняется старшим по масти.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "money_checker", "robbery"},
	command = "band1",
	max = 4,
	salary = 10,
	armor = 10,
	admin = 0,
	vote = false,
	gang = true,
	sname = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = bangs,
	category = "Citizens",
	type = "Bandits",
	unlockCost = 10000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_BAND2 = DarkRP.createJob("Гопник", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Гопает жителей города.
	Забирает у них токены и еду.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery", "money_checker"},
	command = "band2",
	max = 4,
	salary = 20,
	admin = 0,
	armor = 15,
	vote = false,
	gang = true,
	sname = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = bangs,
	category = "Citizens",
	type = "Bandits",
	unlockCost = 30000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_BAND1
})
TEAM_BAND3 = DarkRP.createJob("Гангстер", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Опасный грабитель и убийца.
	Не имеет жалости и моральных ценностей.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery", "money_checker"},
	command = "band3",
	max = 2,
	salary = 30,
	admin = 0,
	armor = 20,
	vote = false,
	gang = true,
	sname = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = bangs,
	category = "Citizens",
	type = "Bandits",
	unlockCost = 80000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_BAND2
})
TEAM_BAND4 = DarkRP.createJob("Авторитет", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Самый авторитетный человек криминального мира.
	Всадит пулю вам в лоб за любую провинность.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery", "money_checker"},
	command = "band4",
	max = 1,
	salary = 50,
	admin = 0,
	armor = 25,
	lives = 10,
	vote = false,
	gang = true,
	sname = true,
	hasLicense = false,
	canusebandmask = true,
	ammoseller = true,
	spawns = bangs,
	category = "Citizens",
	type = "Bandits",
	unlockCost = 250000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_BAND3
})
TEAM_AFERIST = DarkRP.createJob("Аферист", {
	color = Color(0, 201, 8, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Знаменитый в узких кругах бандит-одиночка.
	За свою жизнь успел обзавестись инструментами для проведения разных афер.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery", "money_checker"},
	command = "band5",
	max = 1,
	salary = 100,
	admin = 0,
	lives = 8,
	vote = false,
	citizen = true,
	sname = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = bangs,
	category = "Citizens",
	type = "Bandits",
	unlockCost = 850000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 3)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_BAND4
})

--ЛОЯЛИСТЫ И РАЗНОЕ
TEAM_CITIZEN2 = DarkRP.createJob("Лоялист", {
	color = Color(255, 160, 122, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Гражданин с высоким статусом лояльности.
	Может бегать и хранить принтеры легально.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "citizen2",
	max = 6,
	salary = 300,
	loyallvl = 100,
	spawns = cits,
	admin = 0,
	vote = false,
	hasLicense = false,
	loyal = true,
	nousescreeds = true,
	category = "Citizens",
	type = "Commerce",
	unlockCost = 50000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(8, 9)) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, 4) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, math.random(0, 2)) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_CITIZEN3 = DarkRP.createJob("Доверенный лоялист", {
	color = Color(255, 160, 122, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Один из самых доверенных лиц Альянса.
	Служит Альянсу верой и правдой!]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "citizen3",
	max = 3,
	salary = 400,
	loyallvl = 150,
	spawns = cits,
	admin = 0,
	vote = false,
	hasLicense = false,
	loyal = true,
	nousescreeds = true,
	category = "Citizens",
	type = "Commerce",
	unlockCost = 100000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 10) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, 4) -- Ноги
		ply:SetBodygroup(4, 2) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, math.random(0, 2)) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_CITIZEN2
})
TEAM_MAYOR = DarkRP.createJob("Администратор Земли", {
	color = Color(255, 0, 0, 255),
	model = {"models/player/breen.mdl"},
	description = [[Полноценный правитель всей Землёй
	Его дело правое - служить Альянсу!]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "tfa_usp_kmatch"},
	ammo = {
		["Pistol"] = 180,
	},
	command = "mayor",
	max = 1,
	salary = 2000,
	admin = 0,
	armor = 50,
	maxarmor = 50,
	vote = false,
	newname = "Уоллес Брин",
	cantbuydoor = true,
	hasLicense = false,
	dodemote = true,
	nojobnamechange = true,
	loyalmap = true,
	can_broadcast = true,
	cityAdmin = true,
	lives = 1,
	spawns = azbreen,
	canstartlock = true,
	canstartyk = true,
	canstartkk = true,
	mayor = true,
	canHearCWUChat = true,
	category = "Police",
	type = "Commerce",
	unlockCost = 900000,
	requireUnlock = TEAM_CITIZEN3
})
TEAM_VORT = DarkRP.createJob("Вортигонт [Раб]", {
	color = Color(133, 99, 13, 255),
	model = {"models/player/bms_vortigaunt.mdl"},
	description = [[Древняя раса гуманоидов которая существует много веков.
	Вас поработил Альянс, выполняйте все прихоти Альянса!]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_broom"},
	command = "vort1",
	max = 6,
	vort = true,
	cantbuydoor = true,
	cantberobbed = true,
	nousescreeds = true,
	salary = 50,
	citizen = true,
	admin = 0,
	maxarmor = 0,
	vote = false,
	maxhealth = 200,
	hasLicense = false,
	cantAdvert = true,
	spawns = cits,
	category = "Others",
	type = "Commerce",
	unlockCost = 12000, BodyGroup = function(ply) ply:SetBodygroup(1, 0) end,
})


--ГСР!
TEAM_GSR1 = DarkRP.createJob("Уборщик ГСР", {
	color = Color(129, 163, 7, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Делает улицы города чище.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_radio"},
	command = "gsr1",
	max = 0,
	salary = 150,
	admin = 0,
	vote = false,
	gsr = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = gsr,
	category = "Citizens",
	type = "Commerce2",
	unlockCost = 4000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 11) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, 2) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_GSR3 = DarkRP.createJob("Повар ГСР", {
	color = Color(129, 163, 7, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Продает разные продукты одобренные Альянсом.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_radio"},
	command = "gsr3",
	max = 4,
	salary = 450,
	admin = 0,
	vote = false,
	gsr = true,
	cook = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = gsr,
	category = "Citizens",
	type = "Commerce2",
	unlockCost = 8000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 12) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_GSR1
})
TEAM_GSR4 = DarkRP.createJob("Медик ГСР", {
	color = Color(129, 163, 7, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Лечит травмы людям.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_medkit", "weapon_radio"},
	command = "gsr4",
	max = 4,
	salary = 500,
	admin = 0,
	vote = false,
	gsr = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = gsr,
	category = "Citizens",
	type = "Commerce2",
	unlockCost = 16000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 13) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 2) -- Маска
		ply:SetBodygroup(7, math.random(0, 1)) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_GSR3
})
TEAM_GSR2 = DarkRP.createJob("Курьер ГСР", {
	color = Color(129, 163, 7, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Выполняет тяжелый физический труд.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_radio"},
	command = "gsr2",
	max = 5,
	salary = 350,
	admin = 0,
	vote = false,
	gsr = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = gsr,
	category = "Citizens",
	type = "Commerce2",
	unlockCost = 22000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 11) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 1) -- Сумка
	end,
	requireUnlock = TEAM_GSR4
})
TEAM_GSR5 = DarkRP.createJob("Фасовщик ГСР", {
	color = Color(129, 163, 7, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Самая прибыльная, но тяжелая работа на заводе.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_radio"},
	command = "gsr5",
	max = 2,
	salary = 400,
	admin = 0,
	vote = false,
	gsr = true,
	hasLicense = false,
	canusebandmask = true,
	spawns = gsrzavod,
	category = "Citizens",
	type = "Commerce2",
	unlockCost = 35000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 11) -- Тело
		ply:SetBodygroup(2, 1) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, 2) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, math.random(0, 1)) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_GSR2
})
TEAM_GSR6 = DarkRP.createJob("Глава ГСР", {
	color = Color(129, 163, 7, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Следит за работой всех сотрудников ГСР и руководит ими.]],
	weapons = {"cid_new", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "nalogswep", "weapon_radio"},
	command = "gsr6",
	max = 1,
	salary = 600,
	admin = 0,
	vote = false,
	gsr = true,
	hasLicense = false,
	can_use_notice = true,
	give_orders = true,
	cwu_leader = true,
	can_edit_squad = true,
	spawns = gsr,
	category = "Citizens",
	dodemote = true,
	cmd = true,
	type = "Commerce2",
	unlockCost = 55000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 14) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, 4) -- Ноги
		ply:SetBodygroup(4, 2) -- Руки
		ply:SetBodygroup(5, 4) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, math.random(0, 2)) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
	requireUnlock = TEAM_GSR5
})


--ГО!
TEAM_MPF1 = DarkRP.createJob("C17.MPF.RCT", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Рекрут Гражданской Обороны.
	Гражданин, который только недавно поступил на службу в Г.О.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf1",
	max = 8,
	weaponsinbox = {"door_ram"},
	spawns = rct,
	cp = true,
	maskid = 1,
	salary = 100,
	armor = 60,
	maxarmor = 60,
	admin = 0,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	type = "Police",
	category = "Police", unlockCost = 15000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 0) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end,
})
TEAM_MPF2 = DarkRP.createJob("C17.MPF.PCU.03", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Рядовой Гражданской Обороны.
	Новобранец - Патрульно контрольный юнит.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf2",
	max = 7,
	weaponsinbox = {"tfa_usp_match", "door_ram"},
	cp = true,
	acceptedMaskFor = true,
	spawns = rct,
	maskid = 1,
	salary = 180,
	admin = 0,
	armor = 65,
	maxarmor = 65,
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police",
	category = "Police", unlockCost = 30000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_MPF1
})
TEAM_MPF3 = DarkRP.createJob("C17.MPF.PCU.02", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Сержант Гражданской Обороны.
	Опытный - Патрульно контрольный юнит.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf3",
	max = 6,
	weaponsinbox = {"tfa_usp_match", "tfa_mp7_l", "door_ram"},
	cp = true,
	acceptedMaskFor = true,
	spawns = cps,
	maskid = 1,
	salary = 260,
	admin = 0,
	armor = 70,
	maxarmor = 70,
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police",
	category = "Police", unlockCost = 60000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_MPF2
})
TEAM_MPF4 = DarkRP.createJob("C17.MPF.PCU.01", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Капитан Гражданской Обороны.
	Командует младшим составом. Прошел специальный курс подготовки.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf4",
	max = 5,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_mp7_l", "door_ram"},
	cp = true,
	acceptedMaskFor = true,
	spawns = cps,
	maskid = 1,
	salary = 300,
	admin = 0,
	armor = 75,
	maxarmor = 75,
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police",
	category = "Police", unlockCost = 120000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_MPF3
})
TEAM_MPF5 = DarkRP.createJob("C17.MPF.OFC", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Офицер Гражданской Обороны.
	Руководит всеми патрульно контрольными юнитами.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf5",
	max = 2,
	weaponsinbox = {"tfa_revolver", "tfa_spas12", "door_ram"},
	cp = true,
	spawns = cps,
	max_warns = 2,
	maskid = 2,
	salary = 500,
	can_use_cp_ping_unit = true,
	can_use_notice = true,
	loyalmap = true,
	custom_ping_teams = {
		[TEAM_MPF1] = true,
		[TEAM_MPF2] = true,
		[TEAM_MPF3] = true,
		[TEAM_MPF4] = true,
	},
	can_edit_squad = true,
	give_orders = true,
	admin = 0,
	armor = 80,
	maxarmor = 80,
	vote = false,
	hasLicense = false,
	dodemote = true,

	type = "Police",
	category = "Police", unlockCost = 400000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(2, 2) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 1) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_MPF7
})
TEAM_MPF6 = DarkRP.createJob("C17.SU.MEDIC", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Медик Гражданской Обороны.
	Следит за состоянием юнитов и оказывает ПМП при штурмах.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf6",
	max = 3,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_mp7_pdw", "med_kit", "door_ram"},
	cp = true,
	acceptedMaskFor = true,
	spawns = cps,
	salary = 400,
	admin = 0,
	armor = 80,
	maxarmor = 80,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	saMask = true,
	type = "Police",
	category = "Police", unlockCost = 240000,
	BodyGroup = function(ply) ply:SetSkin(4) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 2) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF4
})
TEAM_MPF7 = DarkRP.createJob("C17.SU.TECH", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Инженер Гражданской Обороны.
	Специалист по снаряжению и технике.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf7",
	max = 2,
	weaponsinbox = {"tfa_mp9_cqc", "tfa_usp_kmatch", "door_ram", "armor_kit_tech"},
	cp = true,
	acceptedMaskFor = true,
	spawns = cps,
	salary = 450,
	ammoseller = true,
	admin = 0,
	armor = 90,
	maxarmor = 90,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	saMask = true,
	type = "Police",
	category = "Police", unlockCost = 350000,
	BodyGroup = function(ply) ply:SetSkin(2) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF6
})
TEAM_MPF8 = DarkRP.createJob("C17.SU.BERSERK", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Спецназ Гражданской Обороны.
	Штурмует помещения.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf8",
	max = 3,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_spas12", "tfa_mp9_lsw", "door_ram", "weapon_frag"},
	cp = true,
	acceptedMaskFor = true,
	spawns = cps,
	salary = 550,
	maskid = 2,
	admin = 0,
	armor = 150,
	maxarmor = 150,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	saMask = true,

	type = "Police",
	category = "Police", unlockCost = 400000,
	BodyGroup = function(ply) ply:SetSkin(6) ply:SetBodygroup(2, 2) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 3) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF7
})
TEAM_MPF9 = DarkRP.createJob("C17.SU.GHOST", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Снайпер Гражданской Обороны.
	Юнит поддержки, в основе используется при зачистке открытой области.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf9",
	max = 2,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_osr1", "tfa_mp5k_10", "door_ram"},
	cp = true,
	spawns = cps,
	maskid = 5,
	salary = 800,
	admin = 0,
	armor = 100,
	maxarmor = 100,
	vip = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	type = "Police",
	category = "Police", unlockCost = 500000,
	BodyGroup = function(ply) ply:SetSkin(6) ply:SetBodygroup(2, 5) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_MPF8
})
TEAM_MPF12 = DarkRP.createJob("C17.SU.HUNTER", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Специальный юнит Гражданской Обороны.
	Обычно используется для патруля запретных секторов, разведки и уничтожение А-К.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf12",
	max = 1,
	weaponsinbox = {"tfa_sniper_combine", "tfa_mp5k_357", "tfa_usp_kmatch", "weapon_slam", "door_ram"},
	cp = true,
	spawns = cps,
	lives = 10,
	maskid = 6,
	salary = 850,
	admin = 0,
	armor = 130,
	maxarmor = 130,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	canCuffWithGun = true,
	type = "Police",
	category = "Police", unlockCost = 850000,
	BodyGroup = function(ply) ply:SetSkin(6) ply:SetBodygroup(2, 6) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 1) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) end, requireUnlock = TEAM_MPF8
})
TEAM_MPF10 = DarkRP.createJob("C17.SU.GUARD", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Охранный юнит Гражданской Обороны.
	Выполняет приказы CMD и АЗ.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf10",
	max = 3,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_spas12", "tfa_oicw_combine", "door_ram"},
	cp = true,
	spawns = cps,
	salary = 750,
	maskid = 6,
	admin = 0,
	armor = 170,
	maxarmor = 170,
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police",
	category = "Police", unlockCost = 500000,
	BodyGroup = function(ply) ply:SetSkin(6) ply:SetBodygroup(2, 6) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 3) ply:SetBodygroup(5, 1) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF8
})
TEAM_MPF11 = DarkRP.createJob("C17.MPF.INSP", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Инспектор Гражданской Обороны.
	Следит за работой ГО и ГСР. Командует специальными подразделениями.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpf11",
	max = 2,
	weaponsinbox = {"tfa_revolver", "tfa_oicw_combine", "door_ram"},
	cp = true,
	spawns = cps,
	max_warns = 2,
	can_use_notice = true,
	can_use_cp_ping_unit = true,
	can_use_cwu_advert = true,
	custom_ping_teams = {
		[TEAM_MPF6] = true,
		[TEAM_MPF7] = true,
		[TEAM_MPF8] = true,
		[TEAM_MPF9] = true,
		[TEAM_MPF12] = true,
		[TEAM_MPF10] = true,
	},
	can_edit_squad = true,
	give_orders = true,
	salary = 800,
	maskid = 6,
	admin = 0,
	armor = 120,
	maxarmor = 120,
	loyalmap = true,
	vote = false,
	hasLicense = false,
	dodemote = true,
	canHearCWUChat = true,
	type = "Police",
	category = "Police", unlockCost = 700000,
	BodyGroup = function(ply) ply:SetSkin(5) ply:SetBodygroup(2, 6) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 2) ply:SetBodygroup(5, 1) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF10
})
TEAM_OBS = DarkRP.createJob("C17.MPF.OBS", {
	color = Color(0, 111, 255, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Сыщик и наблюдатель Гражданской Обороны.
	Занимается патрулем жилых зон и поиском потенциально опасных нарушителей.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "mpfobs",
	max = 1,
	weaponsinbox = {"tfa_revolver", "tfa_hl2_scopedar2", "door_ram"},
	cp = true,
	spawns = cps,
	salary = 820,
	maskid = 2,
	admin = 0,
	armor = 130,
	maxarmor = 130,
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police",
	category = "Police", unlockCost = 800000,
	BodyGroup = function(ply) ply:SetSkin(5) ply:SetBodygroup(2, 2) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF11
})


--КМД!
TEAM_CMD1 = DarkRP.createJob("C17.CMD.EPU", {
	color = Color(95, 4, 232, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Элитный Юнит.
	Командует всеми юнитами ГО. Проводит курсы подготовки.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "cmd1",
	max = 1,
	weaponsinbox = {"tfa_revolver", "tfa_oicw_combine", "door_ram"},
	cp = true,
	spawns = cmds,
	lives = 7,
	salary = 850,
	admin = 0,
	maskid = 3,
	armor = 150,
	maxarmor = 150,
	cmd = true,
	max_warns = 2,
	give_orders = true,
	can_edit_cp_radio = true,
	can_start_nabor = true,
	can_use_notice = true,
	can_use_cp_ping_unit = true,
	can_edit_squad = true,
	loyalmap = true,
	vote = false,
	hasLicense = false,
	dodemote = true,
	captureCPLeader = true,
	type = "Police2",
	category = "Police", unlockCost = 800000,
	BodyGroup = function(ply) ply:SetSkin(1) ply:SetBodygroup(2, 3) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 3) ply:SetBodygroup(5, 1) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_MPF11
})
TEAM_CMD2 = DarkRP.createJob("C17.CMD.DVL", {
	color = Color(95, 4, 232, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Дивизионный лидер.
	Имеет в распоряжении сверхчеловеческий отдел.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "cmd2",
	max = 1,
	weaponsinbox = {"tfa_revolver", "tfa_spas12", "tfa_oicw_p_combine", "door_ram"},
	cp = true,
	give_orders = true,
	spawns = cmds,
	lives = 7,
	salary = 1000,
	admin = 0,
	maskid = 4,
	armor = 160,
	maxarmor = 160,
	cmd = true,
	max_warns = 2,
	can_edit_cp_radio = true,
	can_start_nabor = true,
	can_use_notice = true,
	can_use_cp_ping_unit = true,
	can_edit_squad = true,
	loyalmap = true,
	vote = false,
	hasLicense = false,
	dodemote = true,
	captureCPLeader = true,
	canstartlock = false,
	canstartyk = true,
	canstartkk = true,
	type = "Police2",
	category = "Police", unlockCost = 900000,
	BodyGroup = function(ply) ply:SetSkin(1) ply:SetBodygroup(2, 4) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 3) ply:SetBodygroup(5, 1) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_CMD1
})
TEAM_CMD3 = DarkRP.createJob("C17.CMD.DISPATCH", {
	color = Color(95, 4, 232, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Одна из самых важных единиц Альянса, управляет и контролирует
	сотрудников Г.О.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "cmd3",
	max = 1,
	weaponsinbox = {"tfa_revolver", "tfa_oicw_p_combine", "door_ram"},
	cp = true,
	cmd = true,
	max_warns = 2,
	give_orders = true,
	can_edit_cp_radio = true,
	can_start_nabor = true,
	can_use_notice = true,
	can_use_cp_ping_unit = true,
	can_edit_squad = true,
	loyalmap = true,
	can_broadcast = true,
	lives = 7,
	spawns = cmds,
	salary = 1250,
	maskid = 2,
	canmapradio = true,
	canspectate = true,
	dodemote = true,
	canstartlock = false,
	canstartyk = true,
	canstartkk = true,
	admin = 0,
	armor = 170,
	maxarmor = 170,
	vote = false,
	hasLicense = false,

	type = "Police2",
	category = "Police", unlockCost = 1000000,
	BodyGroup = function(ply) ply:SetSkin(3) ply:SetBodygroup(2, 2) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 0) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_OBS
})
TEAM_CMD4 = DarkRP.createJob("C17.CMD.SEC", {
	color = Color(95, 4, 232, 255),
	model = {
		"models/ggl/cp/cp_male_1.mdl",
		"models/ggl/cp/cp_male_2.mdl",
		"models/ggl/cp/cp_male_3.mdl",
		"models/ggl/cp/cp_male_4.mdl",
		"models/ggl/cp/cp_male_5.mdl",
		"models/ggl/cp/cp_male_7.mdl",
		"models/ggl/cp/cp_male_8.mdl",
		"models/ggl/cp/cp_male_9.mdl",
		"models/ggl/cp/cp_male_10.mdl",
		"models/ggl/cp/cp_male_11.mdl",
		"models/ggl/cp/cp_male_12.mdl",
		"models/ggl/cp/cp_male_14.mdl",
		"models/ggl/cp/cp_male_15.mdl",
		"models/ggl/cp/cp_male_18.mdl",
		"models/ggl/cp/cp_male_19.mdl",
		"models/ggl/cp/cp_male_20.mdl",
		"models/ggl/cp/cp_male_21.mdl",
		"models/ggl/cp/cp_male_6.mdl"
	},
	description = [[Секториальный командир.
	Глава сектора и командует всеми. Проводит построения.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "cid_new", "mp_stunstick"},
	command = "cmd4",
	max = 1,
	weaponsinbox = {"tfa_spas14", "tfa_revolver", "tfa_oicw_p_combine", "door_ram"},
	cp = true,
	give_orders = true,
	loyalmap = true,
	spawns = cmds,
	salary = 1500,
	lives = 7,
	maskid = 7,
	admin = 0,
	armor = 180,
	maxarmor = 180,
	vote = false,
	cmd = true,
	max_warns = 2,
	can_edit_cp_radio = true,
	can_start_nabor = true,
	can_use_notice = true,
	can_use_cp_ping_unit = true,
	can_edit_squad = true,
	hasLicense = false,
	dodemote = true,
	captureCPLeader = true,
	canstartlock = false,
	canstartyk = true,
	canstartkk = true,
	type = "Police2",
	category = "Police", unlockCost = 1500000,
	BodyGroup = function(ply) ply:SetSkin(3) ply:SetBodygroup(2, 7) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 3) ply:SetBodygroup(5, 1) ply:SetBodygroup(6, 0) end, requireUnlock = TEAM_CMD3
})


--ОТА!
TEAM_OTA1 = DarkRP.createJob("C17.OTA.ECHO.OWS", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_soldier.mdl"
	},
	description = [[Новобранец в структуре Сверхчеловеческого отдела.
	Основная боевая единица Сверхчеловеческого отдела.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "ota1",
	max = 2,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_mp9_lsw", "door_ram"},
	ota = true,
	make_time = 10,
	spawns = otas,
	cantberobbed = true,
	nocuffs = true,
	maxhealth = 150,
	salary = 400,
	admin = 0,
	armor = 150,
	maxarmor = 150,
	defaultProtocol = "ЩИТ | Любая точка под контролем Альянса",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 400000,
	BodyGroup = function(ply) ply:SetSkin(0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(220) end, requireUnlock = TEAM_MPF8
})
TEAM_OTA2 = DarkRP.createJob("C17.OTA.ECHO.OWC", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_soldier_customcombinepmv2.mdl"
	},
	description = [[Офицерская боевая единица, основного ударного корпуса сил
	Сверхчеловеческого отдела]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "ota2",
	max = 1,
	weaponsinbox = {"tfa_hl2_scopedar2", "tfa_spas12", "door_ram"},
	ota = true,
	make_time = 15,
	spawns = otas,
	cantberobbed = true,
	nocuffs = true,
	maxhealth = 160,
	salary = 500,
	admin = 0,
	armor = 160,
	maxarmor = 160,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 500000,
	BodyGroup = function(ply) ply:SetSkin(math.random(0,3)) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(220) end, requireUnlock = TEAM_OTA1
})
TEAM_OTANOVA1 = DarkRP.createJob("C17.OTA.NOVA.OWS", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_soldier_prisonguard_customcombinepmv2.mdl"
	},
	description = [[Боевая тюремная единица Сверхчеловеческого отдела.
	Предназначен для контроля и охраны тюремного блока!]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "nova1",
	max = 2,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_mp9_lsw", "door_ram"},
	ota = true,
	can_see_visor_detailed_info = true,
	make_time = 20,
	spawns = otas,
	cantberobbed = true,
	maxhealth = 170,
	salary = 600,
	admin = 0,
	armor = 170,
	maxarmor = 170,
	defaultProtocol = "ЩИТ | Любая точка под контролем Альянса",
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	canCuffWithGun = true,

	type = "Police3",
	category = "Police", unlockCost = 600000,
	BodyGroup = function(ply) ply:SetSkin(math.random(0,1)) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(240) end, requireUnlock = TEAM_OTA2
})
TEAM_OTANOVA2 = DarkRP.createJob("C17.OTA.NOVA.OWC", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_soldier_prisonguard.mdl"
	},
	description = [[Офицерская тюремная единица Сверхчеловеческого отдела.
	Предназначен для командованья младшими единицами.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "nova2",
	max = 1,
	weaponsinbox = {"tfa_mp9_cqc", "tfa_hl2_scopedar2", "tfa_usp_kmatch", "door_ram"},
	ota = true,
	can_see_visor_detailed_info = true,
	make_time = 25,
	spawns = otas,
	cantberobbed = true,
	visor = true,
	maxhealth = 180,
	salary = 800,
	admin = 0,
	armor = 180,
	maxarmor = 180,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	canCuffWithGun = true,

	type = "Police3",
	category = "Police", unlockCost = 700000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(240) end, requireUnlock = TEAM_OTANOVA1
})
TEAM_OTANOVA3 = DarkRP.createJob("C17.OTA.NOVA.EOW", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_elite_guard.mdl"
	},
	description = [[Элитная тюремная единица Сверхчеловеческого отдела.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "nova3",
	max = 1,
	weaponsinbox = {"tfa_mp9_lsw", "tfa_usp_kmatch", "tfa_hl2_scopedar2", "tfa_spas12", "door_ram"},
	ota = true,
	can_see_visor_detailed_info = true,
	make_time = 30,
	spawns = otas,
	cantberobbed = true,
	maxhealth = 200,
	visor = true,
	salary = 900,
	admin = 0,
	armor = 200,
	maxarmor = 200,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	canCuffWithGun = true,

	type = "Police3",
	category = "Police", unlockCost = 800000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(240) end, requireUnlock = TEAM_OTANOVA2
})
TEAM_OTA3 = DarkRP.createJob("C17.OTA.ELITE.OWC", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_super_elite_soldier.mdl"
	},
	description = [[Элитная боевая единица, основного ударного корпуса сил
	Сверхчеловеческого отдела]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "ota3",
	max = 2,
	weaponsinbox = {"tfa_hl2_ar2_mk2", "tfa_spas12", "tfa_mp9_lsw", "door_ram", "weapon_frag"},
	ota = true,
	make_time = 35,
	spawns = otas,
	cantberobbed = true,
	nocuffs = true,
	maxhealth = 190,
	salary = 1000,
	admin = 0,
	armor = 190,
	maxarmor = 190,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 900000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(220) end, requireUnlock = TEAM_OTANOVA3
})
TEAM_OTA4 = DarkRP.createJob("C17.OTA.ELITE.EOW", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_super_soldier_armored.mdl"
	},
	description = [[Элитная командующая единица, основного ударного корпуса сил
	Сверхчеловеческого отдела]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "ota4",
	max = 1,
	weaponsinbox = {"tfa_oicw_combine", "tfa_spas14", "weapon_frag", "door_ram"},
	ota = true,
	make_time = 40,
	give_orders = true,
	spawns = otas,
	cantberobbed = true,
	nocuffs = true,
	visor = true,
	maxhealth = 250,
	salary = 1200,
	admin = 0,
	armor = 250,
	maxarmor = 250,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 1000000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(200) end, requireUnlock = TEAM_OTA3
})
TEAM_OTA5 = DarkRP.createJob("C17.OTA.KING.EOW", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_super_soldier_customcombinepmv2.mdl"
	},
	description = [[Командующий всеми подразделениями Сверхчеловеческого Отдела.
	Одна из самых важнейших единиц командования Альянса.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "ota5",
	max = 1,
	weaponsinbox = {"tfa_oicw_p_combine", "tfa_spas14", "weapon_frag", "door_ram", "weapon_rpg"},
	ota = true,
	make_time = 45,
	give_orders = true,
	cantberobbed = true,
	nocuffs = true,
	can_edit_cp_radio = true,
	can_use_cp_ping_unit = true,
	can_edit_squad = true,
	spawns = otas,
	visor = true,
	maxhealth = 200,
	salary = 1500,
	admin = 0,
	armor = 200,
	maxarmor = 200,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	dodemote = true,
	cmd = true,
	type = "Police3",
	category = "Police", unlockCost = 1500000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(260) end, requireUnlock = TEAM_OTA4
})
TEAM_OTA6 = DarkRP.createJob("C17.OTA.HEV.OWS", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_heavy.mdl"
	},
	description = [[Тяжелая боевая единица, созданная для подавления
	мятежей и восстаний!]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "ota6",
	max = 1,
	weaponsinbox = {"tfa_usp_kmatch", "tfa_cmar2", "tfa_spas14", "weapon_frag", "door_ram"},
	ota = true,
	make_time = 50,
	visor = true,
	nocuffs = true,
	cantberobbed = true,
	vip = true,
	spawns = otas,
	maxhealth = 350,
	salary = 1250,
	admin = 0,
	armor = 350,
	maxarmor = 350,
	defaultProtocol = "ЩИТ | Любая точка под контролем Альянса",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 1500000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(180) end, requireUnlock = TEAM_OTA3
})
TEAM_OTAFANTOM = DarkRP.createJob("C17.OTA.SNPR.EOW", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/player/combine_advisor_guard.mdl"
	},
	description = [[Элитная снайперская единица.
	Самостоятельная боевая единица способная внедриться в тыл врага
	и в одиночку выполнять самые сложные задания!]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket"},
	command = "otafantom",
	max = 1,
	weaponsinbox = {"tfa_mp5k_10", "tfa_sniper_s_combine", "tfa_spas12", "door_ram", "weapon_slam"},
	ota = true,
	make_time = 45,
	spawns = otas,
	cantberobbed = true,
	visor = true,
	nocuffs = true,
	vip = true,
	maxhealth = 190,
	salary = 1300,
	admin = 0,
	armor = 190,
	maxarmor = 190,
	defaultProtocol = "АВТОНОМ",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 1500000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(240) end, requireUnlock = TEAM_OTA6
})


--СИНТЕТЫ
TEAM_STALKER = DarkRP.createJob("C17.SPRT.STALKER", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/union/union_stalker.mdl"
	},
	description = [[Единица поддержки, следит за целостностью Цитадели и контролирует работу
	всех её технических частей.]],
	weapons = {"keys", "stalker_swep"},
	command = "stalker",
	max = 2,
	synth = true,
	stalker = true,
	spawns = otas,
	nocuffs = true,
	cantberobbed = true,
	nospawnprop = true,
	nosys = true,
	maxhealth = 250,
	salary = 800,
	admin = 0,
	maxarmor = 0,
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 1000000,
	PlayerSpawn = function(ply) ply:SetWalkSpeed(70) ply:SetRunSpeed(70) end, requireUnlock = TEAM_OTA1
})
TEAM_CREMATOR = DarkRP.createJob("C17.SYNTH.CREMATOR", {
	color = Color(164, 17, 186, 255),
	model = {
		"models/unionrp/newcremator.mdl"
	},
	description = [[Высокий синтет-крематор.
	Обладает иммолятором, склизкой кожей, огнеупорным плащем, воняет гарью.]],
	weapons = {"keys", "hl2_hands", "weapon_immolator"},
	command = "cremator",
	max = 1,
	synth = true,
	cantberobbed = true,
	nospawnprop = true,
	nocuffs = true,
	spawns = otas,
	maxhealth = 500,
	salary = 800,
	admin = 0,
	armor = 200,
	maxarmor = 200,
	defaultProtocol = "ПАТРУЛЬ | City17",
	vote = false,
	hasLicense = false,
	cantAdvert = true,

	type = "Police3",
	category = "Police", unlockCost = 1200000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(100) end, requireUnlock = TEAM_OTA1
})


--БЕГЛЕЦЫ!
TEAM_GANG1 = DarkRP.createJob("Беглец", {
	color = Color(107, 107, 107, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Смог сбежать от диктатуры Альянса
	Теперь его единственная цель - выжить.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "money_checker", "robbery"},
	command = "pov1",
	max = 0,
	salary = 10,
	admin = 0,
	-- rebel = true,
	refugee = true,
	noreward = true,
	spawns = beg,
	vote = false,
	hasLicense = false,
	canusebandmask = true,
	cantAdvert = true,
	category = "Fugitive",
	type = "Sector6",
	unlockCost = 5000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, math.random(0, 5)) -- Тело
		ply:SetBodygroup(2, math.random(0, 1)) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_BEGLEC1 = DarkRP.createJob("Беглец [Повар]", {
	color = Color(107, 107, 107, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Повар ГСР, который смог сбежать от диктатуры Альянса
	И успел даже прихватить полную сумку еды.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "money_checker", "robbery"},
	command = "beglec1",
	max = 2,
	salary = 10,
	admin = 0,
	-- rebel = true,
	refugee = true,
	cook = true,
	noreward = true,
	spawns = beg,
	vote = false,
	hasLicense = false,
	canusebandmask = true,
	cantAdvert = true,
	category = "Fugitive",
	type = "Sector6",
	NeedToChangeFrom = TEAM_GSR3,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 12) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, 0) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_BEGLEC2 = DarkRP.createJob("Беглец [Медик]", {
	color = Color(107, 107, 107, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Медик ГСР, который смог сбежать от диктатуры Альянса
	Украл со склада ГСР полный комплект медикаментов.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_medkit", "money_checker", "robbery"},
	command = "beglec2",
	max = 2,
	salary = 10,
	admin = 0,
	-- rebel = true,
	refugee = true,
	noreward = true,
	spawns = beg,
	vote = false,
	hasLicense = false,
	canusebandmask = true,
	cantAdvert = true,
	category = "Fugitive",
	type = "Sector6",
	NeedToChangeFrom = TEAM_GSR4,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 13) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, math.random(0, 1)) -- Очки
		ply:SetBodygroup(8, 0) -- Сумка
	end,
})
TEAM_BEGLEC3 = DarkRP.createJob("Беглец [Контрабандист]", {
	color = Color(107, 107, 107, 255),
	model = {
		"models/player/tnb/citizens/male_citizen_01.mdl",
		"models/player/tnb/citizens/male_citizen_02.mdl",
		"models/player/tnb/citizens/male_citizen_03.mdl",
		"models/player/tnb/citizens/male_citizen_04.mdl",
		"models/player/tnb/citizens/male_citizen_05.mdl",
		"models/player/tnb/citizens/male_citizen_06.mdl",
		"models/player/tnb/citizens/male_citizen_07.mdl",
		"models/player/tnb/citizens/male_citizen_08.mdl",
		"models/player/tnb/citizens/male_citizen_09.mdl",
		"models/player/tnb/citizens/male_citizen_10.mdl",
		"models/player/tnb/citizens/male_citizen_12.mdl",
		"models/player/tnb/citizens/male_citizen_13.mdl",
		"models/player/tnb/citizens/male_citizen_14.mdl",
		"models/player/tnb/citizens/male_citizen_15.mdl",
		"models/player/tnb/citizens/male_citizen_16.mdl",
		"models/player/tnb/citizens/male_citizen_18.mdl",
		"models/player/tnb/citizens/male_citizen_20.mdl",
		"models/player/tnb/citizens/male_citizen_21.mdl",
		"models/player/tnb/citizens/male_citizen_22.mdl",
		"models/player/tnb/citizens/male_citizen_23.mdl",
		"models/player/tnb/citizens/male_citizen_24.mdl",

		"models/player/tnb/citizens/female_citizen_01.mdl",
		"models/player/tnb/citizens/female_citizen_02.mdl",
		"models/player/tnb/citizens/female_citizen_03.mdl",
		"models/player/tnb/citizens/female_citizen_04.mdl",
		"models/player/tnb/citizens/female_citizen_05.mdl",
		"models/player/tnb/citizens/female_citizen_06.mdl",
		"models/player/tnb/citizens/female_citizen_07.mdl",
		"models/player/tnb/citizens/female_citizen_09.mdl",
		"models/player/tnb/citizens/female_citizen_10.mdl",
		"models/player/tnb/citizens/female_citizen_14.mdl",
		"models/player/tnb/citizens/female_citizen_19.mdl",
		"models/player/tnb/citizens/female_citizen_20.mdl",
		"models/player/tnb/citizens/female_citizen_21.mdl",
		"models/player/tnb/citizens/female_citizen_22.mdl",
		"models/player/tnb/citizens/female_citizen_23.mdl",
	},
	description = [[Контрабандист, которому по тем или иным причинам опасно быть в городе
	Засел на дно в запретном секторе и торгует оружием там.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "money_checker", "robbery"},
	command = "beglec3",
	max = 2,
	salary = 10,
	admin = 0,
	-- rebel = true,
	refugee = true,
	noreward = true,
	ammoseller = true,
	spawns = beg,
	vote = false,
	hasLicense = false,
	canusebandmask = true,
	cantAdvert = true,
	category = "Fugitive",
	type = "Sector6",
	NeedToChangeFrom = TEAM_BICH3,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 3))
		ply:SetBodygroup(1, 15) -- Тело
		ply:SetBodygroup(2, 0) -- Броня
		ply:SetBodygroup(3, math.random(0, 3)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 2)) -- Руки
		ply:SetBodygroup(5, math.random(0, 5)) -- Голова
		ply:SetBodygroup(6, 0) -- Маска
		ply:SetBodygroup(7, math.random(0, 2)) -- Очки
		ply:SetBodygroup(8, 1) -- Сумка
	end,
})


--ПОВСТАНЦЫ!
TEAM_GANG2 = DarkRP.createJob("Повстанец [Новобранец]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[Только вступил в ряды сопротивления!
	Учится и выполняет приказы вышестоящих по званию.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "pov2",
	max = 8,
	salary = 25,
	admin = 0,
	armor = 60,
	maxarmor = 60,
	vote = false,
	rebel = true,
	spawns = rebel,
	hasLicense = false,
	category = "Ganger",
	type = "Crime",
	unlockCost = 15000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, 0) -- Тело
		ply:SetBodygroup(2, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(3, math.random(0, 1)) -- Руки
		ply:SetBodygroup(4, math.random(0, 2)) -- Голова
	end,
})
TEAM_GANG3 = DarkRP.createJob("Повстанец [Солдат]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[Активно противодействует диктатуре Альянса!
	Основная сила сопротивления.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "pov3",
	max = 7,
	salary = 50,
	admin = 0,
	rebel = true,
	armor = 80,
	maxarmor = 80,
	vote = false,
	hasLicense = false,
	spawns = rebel,
	category = "Ganger",
	type = "Crime",
	unlockCost = 30000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, math.random(1, 3)) -- Тело
		ply:SetBodygroup(2, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(3, math.random(0, 1)) -- Руки
		ply:SetBodygroup(4, math.random(1, 3)) -- Голова
	end,
	requireUnlock = TEAM_GANG2
})
TEAM_GUNSHOP = DarkRP.createJob("Оружейный Снабдитель", {
	color = Color(230, 175, 46, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[Торговец в рядах сопротивления!
	Знает где можно достать и продать стволы.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "gunshop",
	max = 3,
	salary = 55,
	admin = 0,
	rebel = true,
	armor = 60,
	maxarmor = 60,
	vote = false,
	hasLicense = false,
	ammoseller = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime",
	unlockCost = 50000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, 12) -- Тело
		ply:SetBodygroup(2, 4) -- Ноги
		ply:SetBodygroup(3, math.random(0, 2)) -- Руки
		ply:SetBodygroup(4, 3) -- Голова
	end,
	requireUnlock = TEAM_GANG3
})
TEAM_FOODSHOP = DarkRP.createJob("Пищевой Снабдитель", {
	color = Color(230, 175, 46, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[Повар в рядах сопротивления!
	Знает где можно достать и продать еду.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_radio", "robbery"},
	command = "foodshop",
	max = 1,
	salary = 55,
	admin = 0,
	rebel = true,
	cook = true,
	armor = 60,
	maxarmor = 60,
	vote = false,
	spawns = rebel,
	hasLicense = false,
	category = "Ganger",
	type = "Crime",
	unlockCost = 50000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, 12) -- Тело
		ply:SetBodygroup(2, 4) -- Ноги
		ply:SetBodygroup(3, math.random(0, 2)) -- Руки
		ply:SetBodygroup(4, 5) -- Голова
	end,
	requireUnlock = TEAM_GANG3
})
TEAM_GANG4 = DarkRP.createJob("Повстанец [Медик]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[Солдат поддержки сопротивления!
	Помогает раненым в бою товарищам.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_medkit_rebel", "robbery"},
	command = "pov4",
	max = 3,
	salary = 60,
	admin = 0,
	rebel = true,
	armor = 90,
	maxarmor = 90,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime",
	unlockCost = 60000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, 4) -- Тело
		ply:SetBodygroup(2, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(3, math.random(1, 2)) -- Руки
		ply:SetBodygroup(4, 4) -- Голова
	end,
	requireUnlock = TEAM_GANG3
})
TEAM_GMED = DarkRP.createJob("Опытный Медик", {
	color = Color(230, 175, 46, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[В прошлом опытный хирург.
	Использует свои навыки на поле боя!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "med_kit", "robbery"},
	command = "bang3",
	max = 2,
	salary = 250,
	rebel = true,
	admin = 0,
	armor = 110,
	maxarmor = 110,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime",
	unlockCost = 120000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, 5) -- Тело
		ply:SetBodygroup(2, 2) -- Ноги
		ply:SetBodygroup(3, math.random(1, 2)) -- Руки
		ply:SetBodygroup(4, 6) -- Голова
	end,
	requireUnlock = TEAM_GANG4
})
TEAM_GANG5 = DarkRP.createJob("Повстанец [Штурмовик]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",

		"models/player/tnb/citizens/female_rebel01.mdl",
		"models/player/tnb/citizens/female_rebel02.mdl",
		"models/player/tnb/citizens/female_rebel03.mdl",
		"models/player/tnb/citizens/female_rebel04.mdl",
		"models/player/tnb/citizens/female_rebel05.mdl",
		"models/player/tnb/citizens/female_rebel06.mdl",
		"models/player/tnb/citizens/female_rebel07.mdl",
		"models/player/tnb/citizens/female_rebel09.mdl",
		"models/player/tnb/citizens/female_rebel10.mdl",
		"models/player/tnb/citizens/female_rebel14.mdl",
		"models/player/tnb/citizens/female_rebel19.mdl",
		"models/player/tnb/citizens/female_rebel20.mdl",
		"models/player/tnb/citizens/female_rebel21.mdl",
		"models/player/tnb/citizens/female_rebel22.mdl",
		"models/player/tnb/citizens/female_rebel23.mdl",
	},
	description = [[Ударная сила сопротивления!
	Хорошо обученный боец сопротивления.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "pov5",
	max = 6,
	salary = 100,
	admin = 0,
	armor = 130,
	maxarmor = 130,
	vote = false,
	hasLicense = false,
	spawns = rebel,
	rebel = true,
	category = "Ganger",
	type = "Crime",
	unlockCost = 240000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, math.random(6, 7)) -- Тело
		ply:SetBodygroup(2, 2) -- Ноги
		ply:SetBodygroup(3, math.random(1, 2)) -- Руки
		ply:SetBodygroup(4, 9) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(270) end, requireUnlock = TEAM_GANG4
})
TEAM_GFAST = DarkRP.createJob("Вербовщик", {
	color = Color(0, 155, 180, 255),
	model = {"models/player/tnb/citizens/male_spy.mdl"},
	description = [[Обучен незаметно внедрятся в город!
	Помогает людям вступать в ряды сопротивления!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "swep_disguise_briefcase", "robbery"},
	command = "bang2",
	max = 1,
	salary = 250,
	admin = 0,
	armor = 30,
	maxarmor = 30,
	lives = 10,
	tochange = TEAM_GANG1,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	spyguy = true,
	rebel = true,
	type = "Crime",
	unlockCost = 400000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 1))
		ply:SetBodygroup(1, 1) -- Тело
		ply:SetBodygroup(2, math.random(1, 2)) -- Ноги
		ply:SetBodygroup(3, math.random(0, 1)) -- Руки
		ply:SetBodygroup(4, 3) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_GANG5
})
TEAM_GANG6 = DarkRP.createJob("Повстанец [Ветеран]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",
	},
	description = [[Тяжеловооружённый боец сопротивления!
	Прошел через множество боев и доказал свою верность.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "pov6",
	max = 5,
	salary = 200,
	admin = 0,
	armor = 150,
	maxarmor = 150,
	vote = false,
	rebel = true,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime",
	unlockCost = 380000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, math.random(8, 9)) -- Тело
		ply:SetBodygroup(2, math.random(2, 3)) -- Ноги
		ply:SetBodygroup(3, 2) -- Руки
		ply:SetBodygroup(4, math.random(7, 8)) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(270) end, requireUnlock = TEAM_GANG5
})
TEAM_ARMY = DarkRP.createJob("Рейнджер", {
	color = Color(230, 175, 46, 255),
	model = {
		"models/player/tnb/citizens/male_sniper.mdl"
	},
	description = [[В прошлом боец специального подразделения.
	Выжил после семичасовой войны, теперь сражается на стороне сопротивления!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "bang6",
	max = 2,
	salary = 400,
	admin = 0,
	armor = 130,
	maxarmor = 130,
	vote = false,
	rebel = true,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	type = "Crime",
	unlockCost = 550000,
	BodyGroup = function(ply)
		ply:SetSkin(0)
		ply:SetBodygroup(1, 0) -- Накидка
		ply:SetBodygroup(2, math.random(0, 2)) -- Тело
		ply:SetBodygroup(3, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(4, 1) -- Руки
		ply:SetBodygroup(5, 0) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) end, requireUnlock = TEAM_GANG6
})
TEAM_GPYRO = DarkRP.createJob("Пиротехник", {
	color = Color(230, 175, 46, 255),
	model = {
		"models/player/tnb/citizens/male_pyro.mdl"
	},
	description = [[Хороший солдат и мастер по пиротехнике.
	Собрал самодельный арбалет, стреляющий раскаленными болтами!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "bangpyro",
	max = 1,
	salary = 450,
	admin = 0,
	armor = 130,
	maxarmor = 130,
	vote = false,
	rebel = true,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	type = "Crime",
	unlockCost = 800000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 1))
		ply:SetBodygroup(2, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(4, math.random(0, 1)) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) end, requireUnlock = TEAM_ARMY
})
TEAM_GANG7 = DarkRP.createJob("Повстанец [Мастер]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_rebel01.mdl",
		"models/player/tnb/citizens/male_rebel02.mdl",
		"models/player/tnb/citizens/male_rebel03.mdl",
		"models/player/tnb/citizens/male_rebel04.mdl",
		"models/player/tnb/citizens/male_rebel05.mdl",
		"models/player/tnb/citizens/male_rebel06.mdl",
		"models/player/tnb/citizens/male_rebel07.mdl",
		"models/player/tnb/citizens/male_rebel08.mdl",
		"models/player/tnb/citizens/male_rebel09.mdl",
		"models/player/tnb/citizens/male_rebel10.mdl",
		"models/player/tnb/citizens/male_rebel12.mdl",
		"models/player/tnb/citizens/male_rebel13.mdl",
		"models/player/tnb/citizens/male_rebel14.mdl",
		"models/player/tnb/citizens/male_rebel15.mdl",
		"models/player/tnb/citizens/male_rebel16.mdl",
		"models/player/tnb/citizens/male_rebel18.mdl",
		"models/player/tnb/citizens/male_rebel20.mdl",
		"models/player/tnb/citizens/male_rebel21.mdl",
		"models/player/tnb/citizens/male_rebel22.mdl",
		"models/player/tnb/citizens/male_rebel23.mdl",
		"models/player/tnb/citizens/male_rebel24.mdl",
	},
	description = [[Тяжеловооружённый и бронированный воин!
	Настоящий профессионал и машина для убийств.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "pov7",
	max = 4,
	salary = 300,
	admin = 0,
	armor = 170,
	maxarmor = 170,
	rebel = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	type = "Crime",
	unlockCost = 600000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 2))
		ply:SetBodygroup(1, math.random(10, 11)) -- Тело
		ply:SetBodygroup(2, 2) -- Ноги
		ply:SetBodygroup(3, 2) -- Руки
		ply:SetBodygroup(4, 10) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(270) end, requireUnlock = TEAM_GANG6
})
TEAM_GSPY = DarkRP.createJob("Партизан", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/player/tnb/citizens/male_spy.mdl"
	},
	description = [[Мастер маскировки.
	Внедряется в отряды ГО, узнает важные сведения и устраивает диверсии!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "swep_disguise_briefcase", "robbery"},
	command = "bang4",
	max = 1,
	salary = 380,
	admin = 0,
	armor = 50,
	maxarmor = 50,
	lives = 10,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spyguy = true,
	rebel = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	type = "Crime",
	unlockCost = 800000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 1))
		ply:SetBodygroup(1, 0) -- Тело
		ply:SetBodygroup(2, 0) -- Ноги
		ply:SetBodygroup(3, 1) -- Руки
		ply:SetBodygroup(4, 0) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_GANG7
})
TEAM_AGENT = DarkRP.createJob("Спецагент", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/player/tnb/citizens/male_spy.mdl",
	},
	description = [[Специалист в области компьютерных технологий.
	Ловкий агент, обладающий широкими навыками, но слаб в бою!
	Может взламывать терминалы, травить рационы ГО и имеет повышенный урон по CMD Альянса.]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "weapon_radio", "swep_disguise_briefcase", "robbery"},
	command = "special_agent",
	max = 1,
	salary = 520,
	admin = 0,
	lives = 6,
	tochange = TEAM_GANG1,
	armor = 40,
	maxarmor = 40,
	spyguy = true,
	rebel = true,
	spawns = rebel,
	can_get_items = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,

	category = "Ganger",
	type = "Crime",
	unlockCost = 1800000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 1))
		ply:SetBodygroup(1, 2) -- Тело
		ply:SetBodygroup(2, math.random(0, 2)) -- Ноги
		ply:SetBodygroup(3, 1) -- Руки
		ply:SetBodygroup(4, 2) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end,
	requireUnlock = TEAM_GSPY
})
TEAM_BANG1 = DarkRP.createJob("Вортигонт [Воин]", {
	color = Color(230, 175, 46, 255),
	model = {
		"models/player/bms_vortigaunt.mdl"
	},
	description = [[Освободившийся от рабства Альянса вортигонт!
	Обладает большой силой и уникальными способностями!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "swep_vortigaunt_beam"},
	command = "bang1",
	max = 3,
	vort = true,
	nousescreeds = true,
	salary = 250,
	nostun = true,
	admin = 0,
	maxarmor = 0,
	rebel = true,
	maxhealth = 250,
	vote = false,
	hasLicense = false,
	spawns = rebel,
	category = "Ganger",
	type = "Crime",
	unlockCost = 400000,
	BodyGroup = function(ply) ply:SetBodygroup(1, 1) end, requireUnlock = TEAM_VORT
})
TEAM_GANG8 = DarkRP.createJob("Повстанец [Подрывник]", {
	color = Color(229, 131, 45, 255),
	model = {
		"models/player/tnb/citizens/male_boomer.mdl"
	},
	description = [[Вооружен гранатометом и очень опасен!
	Настоящий профессионал и защищенный боец.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "pov8",
	max = 1,
	salary = 400,
	admin = 0,
	armor = 190,
	maxarmor = 190,
	rebel = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	type = "Crime",
	unlockCost = 700000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 1))
		ply:SetBodygroup(3, math.random(0, 1)) -- Руки
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(270) end, requireUnlock = TEAM_GANG7
})


--ПОВСТАНЦЫ ЭЛИТНЫЕ!
TEAM_ELITE1 = DarkRP.createJob("Рекрут [HYDRA]", {
	color = Color(169, 124, 0, 255),
	model = {
		"models/player/tnb/citizens/male_hydra.mdl"
	},
	description = [[Рекрут элитного отряда Сопротивления.
	Только недавно закончил обучение для вступление в спецотряд Гидра!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "elite1",
	max = 3,
	salary = 500,
	admin = 0,
	armor = 190,
	maxarmor = 190,
	rebel = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	nostun = true,
	can_get_items = true,
	category = "Ganger",
	type = "Crime3",
	unlockCost = 800000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) end,
	BodyGroup = function(ply)
		ply:SetBodygroup(1, math.random(0, 1)) -- Тело
		ply:SetBodygroup(2, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(4, 1) -- Голова
	end,
	requireUnlock = TEAM_GANG8
})
TEAM_ELITE2 = DarkRP.createJob("Повстанец [HYDRA]", {
	color = Color(169, 124, 0, 255),
	model = {
		"models/player/tnb/citizens/male_hydra.mdl"
	},
	description = [[Солдат элитного отряда Сопротивления.
	Идеально обученный и подготовленный повстанец!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "elite2",
	max = 2,
	salary = 800,
	admin = 0,
	armor = 200,
	maxarmor = 200,
	rebel = true,
	vip = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	nostun = true,
	can_get_items = true,
	category = "Ganger",
	type = "Crime3",
	unlockCost = 900000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) end,
	BodyGroup = function(ply)
		ply:SetBodygroup(1, math.random(2, 3)) -- Тело
		ply:SetBodygroup(2, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(4, 2) -- Голова
	end,
	requireUnlock = TEAM_ELITE1
})
TEAM_ELITE3 = DarkRP.createJob("Снайпер [HYDRA]", {
	color = Color(169, 124, 0, 255),
	model = {
		"models/player/tnb/citizens/male_sniper.mdl"
	},
	description = [[Один из самых метких стрелков в рядах сопротивления.
	Отличная подготовка и профессионализм!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "elite3",
	max = 1,
	salary = 900,
	admin = 0,
	armor = 160,
	maxarmor = 160,
	rebel = true,
	vip = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	nostun = true,
	can_get_items = true,
	category = "Ganger",
	type = "Crime3",
	unlockCost = 1000000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(310) end,
	BodyGroup = function(ply)
		ply:SetSkin(1)
		ply:SetBodygroup(1, 1) -- Накидка
		ply:SetBodygroup(2, math.random(3, 4)) -- Тело
		ply:SetBodygroup(3, math.random(0, 1)) -- Ноги
		ply:SetBodygroup(4, 1) -- Руки
		ply:SetBodygroup(5, math.random(1, 2)) -- Голова
	end,
	requireUnlock = TEAM_ELITE2
})
TEAM_ELITE4 = DarkRP.createJob("Шпион [HYDRA]", {
	color = Color(169, 124, 0, 255),
	model = {
		"models/player/tnb/citizens/male_spy.mdl"
	},
	description = [[Профессиональный разведчик и агент.
	Устраивает диверсии и убирает высокопоставленных офицеров Альянса!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "swep_disguise_briefcase", "robbery"},
	command = "elite4",
	max = 1,
	lives = 10,
	tochange = TEAM_GANG1,
	salary = 1000,
	admin = 0,
	armor = 100,
	maxarmor = 100,
	rebel = true,
	vip = true,
	vote = false,
	hasLicense = false,
	canusemask1 = true,
	spawns = rebel,
	can_get_items = true,
	category = "Ganger",
	type = "Crime3",
	unlockCost = 1100000,
	BodyGroup = function(ply)
		ply:SetSkin(math.random(0, 1))
		ply:SetBodygroup(1, 3) -- Тело
		ply:SetBodygroup(2, math.random(0, 2)) -- Ноги
		ply:SetBodygroup(3, 1) -- Руки
		ply:SetBodygroup(4, 1) -- Голова
	end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) end, requireUnlock = TEAM_ELITE3
})
TEAM_ELITE5 = DarkRP.createJob("Коммандер [HYDRA]", {
	color = Color(169, 124, 0, 255),
	model = {
		"models/player/tnb/citizens/male_commader.mdl"
	},
	description = [[Коммандер Гидры - О его прошлом мало что известно, да и сам он никогда ничего не рассказывал.
	Один из самых подготовленных бойцов и командиров Сопротивления, основавший это подразделение!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "elite5",
	max = 1,
	lives = 7,
	tochange = TEAM_GANG1,
	salary = 1100,
	admin = 0,
	armor = 250,
	maxarmor = 250,
	maxhealth = 200,
	nocuffs = true,
	rebel = true,
	vip = true,
	vote = false,
	cmd = true,
	dodemote = true,
	give_orders = true,
	captureRebelLeader = true,
	can_edit_rebel_radio = true,
	can_use_notice = true,
	can_edit_squad = true,
	hasLicense = false,
	spawns = rebel,
	can_get_items = true,
	nostun = true,
	category = "Ganger",
	type = "Crime3",
	unlockCost = 1300000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(1, 15) ply:SetBodygroup(2, math.random(4,6)) ply:SetBodygroup(3, math.random(0,1)) ply:SetBodygroup(4, math.random(0,3)) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(220) end, requireUnlock = TEAM_ELITE4
})


--ПОВСТАНЦЫ ЛИДЕРЫ!
TEAM_KLEINER = DarkRP.createJob("Ученый сопротивления", {
	color = Color(255, 77, 0, 255),
	model = {
		"models/player/kleiner.mdl"
	},
	description = [[Архетипичный "рассеянный гениальный учёный".
	Является автором ряда работ по телепортации и межпространственному путешествию!
	Может создавать уникальные образцы оружия.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery"},
	command = "kleiner",
	lives = 7,
	tochange = TEAM_GANG1,
	max = 1,
	salary = 800,
	admin = 0,
	newname = "Айзек Кляйнер",
	cmd = true,
	give_orders = true,
	armor = 60,
	maxarmor = 60,
	rebel = true,
	vote = false,
	hasLicense = false,
	ammoseller = true,
	dodemote = true,
	can_edit_rebel_radio = true,
	can_use_notice = true,
	can_edit_squad = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime2",
	unlockCost = 800000,
	requireUnlock = TEAM_GANG8
})
TEAM_BARNEY = DarkRP.createJob("Агент сопротивления", {
	color = Color(0, 155, 180, 255),
	model = {
		"models/ggl/cp/cp_male_17.mdl"
	},
	description = [[Оперативник Сопротивления под прикрытием в Альянсе.
	Работает под видом сотрудника режима.
	Разведка, координация и скрытая поддержка операций.]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "tfa_usp_match", "robbery", "mp_stunstick", "cid_new"},
	command = "barne",
	lives = 7,
	tochange = TEAM_GANG1,
	max = 1,
	nostun = true,
	salary = 1000,
	fakejobname = "C17.MPF.PCU.03",
	fakejob = TEAM_MPF2,
	admin = 0,
	rebel = true,
	armor = 100,
	maxarmor = 100,
	maskid = 1,
	cp = true,
	can_get_items = true,
	vote = false,
	hasLicense = false,
	dodemote = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime2",
	unlockCost = 900000,
	BodyGroup = function(ply) ply:SetSkin(0) ply:SetBodygroup(2, 0) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) ply:SetBodygroup(5, 0) ply:SetBodygroup(6, 0) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(280) end, requireUnlock = TEAM_KLEINER
})
TEAM_ALYX = DarkRP.createJob("Техник сопротивления", {
	color = Color(255, 77, 0, 255),
	model = {
		"models/player/alyx.mdl"
	},
	description = [[Один из лидеров Сопротивления.
	У Аликс так же есть и навыки учёного-техника!
	Известно, что она принимала участие в создании телепортов Сопротивления и занималась инженерными работами!]],
	weapons = {"weapon_radio", "keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery", "armor_kit"},
	command = "alex",
	lives = 7,
	tochange = TEAM_GANG1,
	max = 1,
	salary = 1250,
	admin = 0,
	female = true,
	armor = 110,
	maxarmor = 110,
	rebel = true,
	cmd = true,
	give_orders = true,
	ammoseller = true,
	gender = "female",
	newname = "Аликс Вэнс",
	vote = false,
	captureRebelLeader = true,
	can_edit_rebel_radio = true,
	can_use_notice = true,
	can_edit_squad = true,
	hasLicense = false,
	dodemote = true,
	spawns = rebel,
	category = "Ganger",
	type = "Crime2",
	unlockCost = 1000000,
	PlayerSpawn = function(ply) ply:SetRunSpeed(310) end, requireUnlock = TEAM_BARNEY
})
TEAM_GORDON = DarkRP.createJob("Лидер сопротивления", {
	color = Color(255, 77, 0, 255),
	model = {
		"models/sirgibs/ragdolls/gordon_survivor_player.mdl"
	},
	description = [[Глава всего сопротивления!
		Командует всеми подразделениями повстанцев!
	Обладатель редкого защитного костюма Hev Suit Mark]],
	weapons = {"keys", "hl2_hands", "weapon_physcannon", "gmod_tool", "weapon_physgun", "pocket", "robbery", "weapon_radio"},
	weaponsinbox = {"weapon_crowbar", "tfa_crossbow", "tfa_spas14", "tfa_hl2_ar2_mk2", "tfa_usp_kmatch", "weapon_rpg"},
	command = "gordon",
	lives = 7,
	tochange = TEAM_GANG1,
	max = 1,
	bhop = false,
	salary = 1500,
	admin = 0,
	armor = 240,
	maxarmor = 240,
	maxhealth = 240,
	rebel = true,
	nostun = true,
	nocuffs = true,
	vip = true,
	cmd = true,
	give_orders = true,
	newname = "Гордон Фримен",
	vote = false,
	captureRebelLeader = true,
	can_edit_rebel_radio = true,
	can_use_notice = true,
	can_edit_squad = true,
	hasLicense = false,
	dodemote = true,
	spawns = freeman,
	category = "Ganger",
	type = "Crime2",
	--customCheck = function(ply)
		--team.NumPlayers(TEAM_BARNEY) or 0 > 0
	--end,
	--CustomCheckFailMsg = "Сейчас нету Барни",
	unlockCost = 1500000,
	BodyGroup = function(ply) ply:SetSkin(3) ply:SetBodygroup(1, 1) ply:SetBodygroup(2, 3) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(290) ply:SetLocalVar("IgnoreArmor", true) ply:SelectWeapon("keys", "hl2_hands") end, requireUnlock = TEAM_ALYX
})


--РАЗНОЕ!
TEAM_ADMIN = DarkRP.createJob("Администрация", {
	color = Color(125, 15, 66, 255),
	model = {
		"models/player/garrysmod/hev_gmod.mdl",
	},
	description = [[.]],
	weapons = {"gmod_tool", "weapon_physgun", "keys", "gmod_camera", "weaponchecker"},
	command = "admin",
	max = 0,
	salary = 250,
	cantbuydoor = true,
	cantberobbed = true,
	maxhealth = 10000000,
	admin = 0,
	maxarmor = 0,
	vip = true,
	nostun = true,
	nocuffs = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	spawns = admin,
	type = "None",
})
TEAM_GMAN = DarkRP.createJob("G-Man", {
	color = Color(107, 34, 171, 255),
	model = {
		"models/player/gman_high.mdl"
	},
	description = [[Таинственный персонаж.
 Называемый «зловещим межпространственным бюрократом».
	Он имеет особенности поведения и возможности, стоящие за пределом человеческих.]],
	weapons = {"gman_case"},
	command = "gman",
	max = 1,
	salary = 500,
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	maxhealth = 10000000,
	admin = 0,
	maxarmor = 0,
	vip = true,
	nostun = true,
	nocuffs = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	type = "Commerce", unlockCost = 250000,
	category = "Others",
	PlayerSpawn = function(ply) ply:DrawShadow(false) end,
})
TEAM_ZOMB1 = DarkRP.createJob("Зомби", {
	color = Color(107, 34, 171, 255),
	model = {
		"models/player/zombie_classic.mdl"
	},
	description = [[Живой труп.]],
	weapons = {"zombieswep"},
	command = "zomb1",
	nosoundsc = true,
	bhop = true,
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	max = 5,
	salary = 0,
	admin = 0,
	maxarmor = 0,
	nocuffs = true,
	spawns = iventzombie,
	zombie = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	type = "None",
	category = "Others",
	BodyGroup = function(ply) ply:SetBodygroup(1, 1) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(300) end,
})


--ЗОМБИ!
TEAM_ZOMBIE1 = DarkRP.createJob("Обычный зомби", {
	color = Color(199,21,133, 255),
	model = {
		"models/player/zombie_classic.mdl"
	},
	description = [[Вы обычный зомби который бродит по катакомбам поисках жертвы.]],
	weapons = {"zombieswep"},
	command = "zombclassic",
	nosoundsc = true,
	max = 1,
	maxhealth = 500,
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	salary = 0,
	killreward = 100,
	admin = 0,
	maxarmor = 0,
	spawns = zombie,
	zombie = true,
	vote = false,
	nocuffs = true,
	hasLicense = false,
	cantAdvert = true,
	type = "Zombienpc",
	unlockCost = 600000,
	category = "Others",
	BodyGroup = function(ply) ply:SetBodygroup(1, 1) end,
	PlayerSpawn = function(ply) ply:SetBodygroup(1, 1) ply:SetRunSpeed(270) end,
})
TEAM_ZOMBIE2 = DarkRP.createJob("Быстрый зомби", {
	color = Color(199,21,133, 255),
	model = {
		"models/unionrp/newzombie_fast.mdl"
	},
	description = [[Вы очень опасный и мобильный монстр.
	Способный в одиночку создать проблемы целому отряду!]],
	weapons = {"zombieswep2"},
	command = "zombfast",
	nosoundsc = true,
	max = 1,
	bhop = true,
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	maxhealth = 330,
	salary = 0,
	killreward = 200,
	admin = 0,
	maxarmor = 0,
	spawns = zombie,
	zombie = true,
	nocuffs = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
	type = "Zombienpc",
	unlockCost = 1000000,
	category = "Others",
	BodyGroup = function(ply) ply:SetBodygroup(0, 1) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(320) end, requireUnlock = TEAM_ZOMBIE1
})
TEAM_ZOMBIE3 = DarkRP.createJob("Зомбайн", {
	color = Color(199,21,133, 255),
	model = {
		"models/player/zombine/combine_zombie.mdl"
	},
	description = [[Ваше тело защищено толстой броней.
	А смертоносные удары и ваша способность самоучнитожиться пугает многих обитателей подземелий!]],
	weapons = {"zombieswep3"},
	command = "zombota",
	nosoundsc = true,
	max = 1,
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	maxhealth = 600,
	salary = 0,
	killreward = 300,
	admin = 0,
	maxarmor = 0,
	spawns = zombie,
	zombie = true,
	nocuffs = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
		customCheck = function(ply)
			return #team.GetPlayers(TEAM_ZOMBIE4) < 1
		end,
			CustomCheckFailMsg = "Сейчас зомби слишком сильные!",
	type = "Zombienpc", unlockCost = 1500000,
	category = "Others",
	BodyGroup = function(ply) ply:SetBodygroup(1, 1) end,
	PlayerSpawn = function(ply) ply:SetRunSpeed(260) end, requireUnlock = TEAM_ZOMBIE2
})
TEAM_ZOMBIE4 = DarkRP.createJob("Ядовитый зомби", {
	color = Color(199,21,133, 255),
	model = {
		"models/player/poison_player.mdl"
	},
	description = [[Вы вид зомби, который покрыт ядовитыми хедкрабами.
	Обладаете большим запасом здоровья, чем обычный зомби, и способны заражать людей смертельной болезнью.]],
	weapons = {"zombieswep4"},
	command = "zombtox",
	nosoundsc = true,
	max = 1,
	cantbuydoor = true,
	cantberobbed = true,
	nospawnprop = true,
	maxhealth = 1000,
	salary = 0,
	killreward = 400,
	admin = 0,
	maxarmor = 0,
	nocuffs = true,
	spawns = zombie,
	zombie = true,
	vote = false,
	hasLicense = false,
	cantAdvert = true,
		customCheck = function(ply)
			return #team.GetPlayers(TEAM_ZOMBIE3) < 1
		end,
			CustomCheckFailMsg = "Сейчас зомби слишком сильные!",
	type = "Zombienpc", unlockCost = 1500000,
	category = "Others",
	BodyGroup = function(ply) ply:SetBodygroup(1, 1) ply:SetBodygroup(2, 1) ply:SetBodygroup(3, 1) ply:SetBodygroup(4, 1) end,
	PlayerSpawn = function(ply) ply:SetWalkSpeed(85) ply:SetRunSpeed(220) end, requireUnlock = TEAM_ZOMBIE2
})


-- ИВЕНТ!
TEAM_IVENT1 = DarkRP.createJob("Команда A", {
	color = Color(255, 0, 0, 255),
	model = {
		"models/player/guerilla.mdl"
	},
	description = [[Профессия для ивентов #1]],
	weapons = {"weapon_physgun", "gmod_tool", "keys", "hl2_hands"},
	command = "ivent1",
	event = 1,
	max = 0,
	salary = 0,
	ammoseller = true,
	spawns = iventzone1,
	admin = 0,
	vote = false,
	hasLicense = false,

	type = "Iventboy",
	category = "Others", PlayerSpawn = function(ply) end,
})
TEAM_IVENT2 = DarkRP.createJob("Команда B", {
	color = Color(85, 255, 0, 255),
	model = {
		"models/player/arctic.mdl"
	},
	description = [[Профессия для ивентов #2]],
	weapons = {"weapon_physgun", "gmod_tool", "keys", "hl2_hands"},
	command = "ivent2",
	event = 2,
	max = 0,
	salary = 0,
	ammoseller = true,
	spawns = iventzone2,
	admin = 0,
	vote = false,
	hasLicense = false,

	type = "Iventboy",
	category = "Others", PlayerSpawn = function(ply) end,
})
TEAM_IVENT3 = DarkRP.createJob("Команда C", {
	color = Color(0, 34, 255, 255),
	model = {
		"models/player/leet.mdl"
	},
	description = [[Профессия для ивентов #3]],
	weapons = {"weapon_physgun", "gmod_tool", "keys", "hl2_hands"},
	command = "ivent3",
	event = 3,
	max = 0,
	salary = 0,
	ammoseller = true,
	spawns = iventzone3,
	admin = 0,
	vote = false,
	hasLicense = false,

	type = "Iventboy",
	category = "Others", PlayerSpawn = function(ply) end,
})
TEAM_IVENT4 = DarkRP.createJob("Команда D", {
	color = Color(255, 213, 0, 255),
	model = {
		"models/player/phoenix.mdl"
	},
	description = [[Профессия для ивентов #4]],
	weapons = {"weapon_physgun", "gmod_tool", "keys", "hl2_hands"},
	command = "ivent4",
	event = 4,
	max = 0,
	salary = 0,
	ammoseller = true,
	spawns = iventzone4,
	admin = 0,
	vote = false,
	hasLicense = false,

	type = "Iventboy",
	category = "Others", PlayerSpawn = function(ply) end,
})


--ЗАГОТОВКА!
TEAM_NONE = DarkRP.createJob("COMING SOON...", {
	color = Color(255, 213, 0, 255),
	model = {
		"models/player/dod_german.mdl"
	},
	description = [[Профессия для ивентов #4]],
	weapons = {"weapon_physgun", "gmod_tool", "keys"},
	command = "comingsoon",
	max = 0,
	salary = 0,
	admin = 0,
	maxarmor = 0,
	vote = false,
	hasLicense = false,

	type = "Secret",
	category = "Others", PlayerSpawn = function(ply) end,
})

-- Профессия при заходе на сервер.
if GAMEMODE then
	GAMEMODE.DefaultTeam = TEAM_CITIZEN

	-- Написать TEAM Гос. сотрудников.
	GAMEMODE.CivilProtection = {
		[TEAM_MPF1] = true,
		[TEAM_MPF2] = true,
		[TEAM_MPF3] = true,
		[TEAM_MPF4] = true,
		[TEAM_MPF5] = true,
		[TEAM_MPF6] = true,
		[TEAM_MPF7] = true,
		[TEAM_MPF8] = true,
		[TEAM_MPF9] = true,
		[TEAM_MPF12] = true,
		[TEAM_MPF10] = true,
		[TEAM_MPF11] = true,
		[TEAM_OBS] = true,
		[TEAM_CMD1] = true,
		[TEAM_CMD2] = true,
		[TEAM_CMD3] = true,
		[TEAM_CMD4] = true,
		[TEAM_OTA1] = true,
		[TEAM_OTA2] = true,
		[TEAM_OTA3] = true,
		[TEAM_OTA4] = true,
		[TEAM_OTA5] = true,
		[TEAM_OTA6] = true,
		[TEAM_MAYOR] = true,
		[TEAM_OTANOVA1] = true,
		[TEAM_OTANOVA2] = true,
		[TEAM_OTANOVA3] = true,
		[TEAM_STALKER] = true,
		[TEAM_CREMATOR] = true,
		[TEAM_BARNEY] = true,
		[TEAM_OTAFANTOM] = true,
	}
end
-- Киллер меню
if DarkRP and DarkRP.addHitmanTeam then
	DarkRP.addHitmanTeam(TEAM_BAND4) -- У кого можно заказывать убийство.
end