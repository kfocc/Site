local DarkRP = istable(DarkRP) and DarkRP or {}
DarkRP.CPoints = DarkRP.CPoints or {}
local CPoints = DarkRP.CPoints
CPoints.points = {}
local pMeta = FindMetaTable("Player")
function pMeta:IsCaptured()
	return self:GetNetVar("Captured") ~= nil or false
end

--[=[--[[-------------------------------------------------------------------------
DEBUG
---------------------------------------------------------------------------]]
function pMeta:isCP()
	return self:Team() == TEAM_BICH1
end
function pMeta:isRebel()
	return self:Team() == TEAM_CITIZEN
end
--[[-------------------------------------------------------------------------
DEBUG
---------------------------------------------------------------------------]]]=]
if SERVER then
	local function AddPoint(id, data)
		if istable(data) then
			CPoints.points[id] = data
			CPoints.points[id].id = id
			CPoints.points[id].players = {}
			CPoints.points[id].players.cp = {}
			CPoints.points[id].players.rebel = {}
			CPoints.points[id].kills = {}
			CPoints.points[id].kills.cp = 0
			CPoints.points[id].kills.rebel = 0
			CPoints.points[id].newcooldown = 0
			CPoints.points[id].owner = ""
			CPoints.points[id].capture = false
		end
	end

	--[[-------------------------------------------------------------------------
	Description:
	int - integer - число.
	AddPoint("id точки",{
		name = "Имя точки, string",
		pos = { -- Позиция точки.
			[1] = Vector(0, 0, 0), -- Позиция первой точки с одной стороны.
			[2] = Vector(1, 1, 1) -- Позиция второй точки с другой стороны.
		}, -- Должна получить коробка с центром, в котором будет производиться захват.
		ctime = int, -- Время до окончания захвата точки от ее начала.
		cooldown = int, -- Время кулдауна после захвата или защиты точки, за которое игроки выйгравшей стороны будут получать награду.
		min = { -- Минимальное количество игроков атакующих, либо защищающихся.
			attackers = int,
			defenders = int
		},
		reward = { -- Награда, которую получит победившая сторона.
			money = int, -- Деньги.
			xp = int, -- Опыт.
			func = function(Player) -- (Опционально) Функция, запускающаяся для каждого игрока выйгравшей стороны.
		},
		rewardtime = { -- Время до выдачи награды.
			before = int, -- Промежуточная награда при удержании точки, выдается тому, у кого больше всего киллов.
			after = int -- После захвата точки, до его следующего захвата будет выдаваться награда победившей стороне ( Каждые n секунд. )
		},
		terminal = {
			model = "string", -- Модель терминала захвата точки.
			pos = Vector(0, 0, 0), -- Точка в которой находится терминал захвата точки.
			ang = Angle(0, 0, 0) -- Позиция в сторону которой будет повернут терминал.
		}
	})
---------------------------------------------------------------------------]]
	AddPoint("nexus", {
		name = "Цитадель",
		notOperation = true,
		pos = {
			[1] = Vector(2191.1672363281, 9904.3310546875, 4588.5224609375),
			[2] = Vector(915.65832519531, 8060.3930664062, 3491.3032226562)
		},
		ctime = 300,
		cooldown = 15,
		min = {
			attackers = 12,
			defenders = 15
		},
		reward = {
			money = 5000,
			xp = 50
		},
		rewardtime = {
			before = 300,
			after = 600
		},
		terminal = {
			model = "models/props_combine/combine_interface001.mdl",
			pos = Vector(1934.468750, 9257.187500, 3796.343750),
			ang = Angle(0, 180, 0)
		},
		autocode = true,
	})

	AddPoint("d3", {
		name = "КПП - D3",
		pos = {
			[1] = Vector(-1342, 4698, 3746),
			[2] = Vector(450, 6832, 4444)
		},
		ctime = 300,
		cooldown = 15,
		min = {
			attackers = 8,
			defenders = 12
		},
		reward = {
			money = 2000,
			xp = 50
		},
		rewardtime = {
			before = 300,
			after = 600
		},
		terminal = {
			model = "models/props_combine/combine_interface003.mdl",
			pos = Vector(-487.785980, 6229.609863, 3802.799072),
			ang = Angle(0, 180, 0)
		},
	})

	AddPoint("prom_zone", {
		name = "Промзона",
		pos = {
			[1] = Vector(-8049.3090820312, 3550.5380859375, 3734.4296875),
			[2] = Vector(-10021.303710938, 5377.4477539062, 4762.2358398438)
		},
		ctime = 300,
		cooldown = 15,
		min = {
			attackers = 8,
			defenders = 12
		},
		reward = {
			money = 3000,
			xp = 50
		},
		rewardtime = {
			before = 300,
			after = 600
		},
		terminal = {
			model = "models/props_combine/combine_interface003.mdl",
			pos = Vector(-9097.500000, 4879.562500, 3736.406250),
			ang = Angle(0, 180, 0)
		},
		autocode = true,
	})

	AddPoint("d6", {
		name = "КПП - D6",
		pos = {
			[1] = Vector(-2811.031250, 11416.205078, 3700.159424),
			[2] = Vector(-4896.851562, 12524.777344, 5106.715332)
		},
		ctime = 300,
		cooldown = 15,
		min = {
			attackers = 8,
			defenders = 12
		},
		reward = {
			money = 1700,
			xp = 50
		},
		rewardtime = {
			before = 300,
			after = 600
		},
		terminal = {
			model = "models/props_combine/combine_interface002.mdl",
			pos = Vector(-3208.6613769531, 12497.483398438, 3804.3862304688),
			ang = Angle(0, -90, 0)
		}
	})
	AddPoint("d6zone", {
		name = "Сектор - D6",
		pos = {
			[1] = Vector(-4618.131348, 12533.856445, 5155.770020),
			[2] = Vector(-1748.303955, 16299.968750, 3382.256348)
		},
		ctime = 300,
		cooldown = 15,
		min = {
			attackers = 8,
			defenders = 12
		},
		reward = {
			money = 1500,
			xp = 50
		},
		rewardtime = {
			before = 300,
			after = 600
		},
		terminal = {
			model = "models/props_combine/combine_interface002.mdl",
			pos = Vector(-4048.635742, 13398.118164, 3802.375732),
			ang = Angle(0.001, -179.963, 0.001)
		}
	})

	AddPoint("d3zone", {
		name = "Сектор - D3",
		pos = {
			[1] = Vector(1599, 5586, 4510),
			[2] = Vector(-131, 2680, 3667)
		},
		ctime = 300,
		cooldown = 15,
		min = {
			attackers = 8,
			defenders = 12
		},
		reward = {
			money = 2500,
			xp = 50
		},
		rewardtime = {
			before = 300,
			after = 600
		},
		terminal = {
			model = "models/props_combine/combine_interface002.mdl",
			pos = Vector(835.501099, 3675.883057, 3804.298096),
			ang = Angle(0, 90, 0)
		}
	})
end
