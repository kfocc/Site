captureBases = captureBases or {}
captureBases.debug = false

local basesCfg = captureBases.basesCfg
captureBases.basesCfg = basesCfg or {
	{
		name = "База Сопротивления",
		icon = Material("icon16/shield.png"),
		nextCapture = 0,
		lastCapture = 0,

		leaderCount = 0,

		leaderRequire = 1,

		insideZoneCount = 0,
		minimumInsideZoneCount = 5,

		maxSeeDist = 250 * 250,
		canSee = function(ply)
			return ply:Team() == TEAM_ADMIN or ply:isCP() and not ply:isRebel()
		end,
		pos = {
			-- Vector 1 и 2 - сама зона. Vector 3 - текст.
			Vector(-1766.312744, 10948.968750, 2620.636963),
			Vector(-2228.615479, 10381.031250, 2477.401123),
			Vector(-2017.065308, 10719.994141, 2594.480713)
		}
	},
	{
		name = "База Альянса",
		icon = Material("icon16/shield.png"),
		nextCapture = 0,
		lastCapture = 0,

		leaderCount = 0,

		leaderRequire = 1,

		insideZoneCount = 0,
		minimumInsideZoneCount = 5,

		maxSeeDist = 250 * 250,
		canSee = function(ply)
			return ply:Team() == TEAM_ADMIN or ply:isRebel()
		end,
		pos = {
			-- Vector 1 и 2 - сама зона. Vector 3 - текст.
			Vector(3628.968750, 11926.269531, 4780.910645),
			Vector(3264.031250, 12559.547852, 4988.196777),
			Vector(3498.285156, 12211.454102, 4883.345703)
		}
	}
}
