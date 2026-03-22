sAgent = sAgent or {}
local sAgent = sAgent
--[[" / ",--]]
local operators = {" * ", " + ", " - "}
local function nodeTree(left, right, operator, first)
	if first then
		return "(" .. left .. operator .. right .. ")"
	else
		return left .. operator .. right
	end
end

local function generateExpression(level, notFirst)
	if level == 1 then return math.random(1, 30) end
	local left = generateExpression(math.floor(level / 2), true)
	local right = generateExpression(math.ceil(level / 2), true)
	local operator = operators[math.random(#operators)]
	return nodeTree(left, right, operator, notFirst)
end

sAgent.generateExpression = generateExpression
sAgent.cfg = {}
local cfg = sAgent.cfg
cfg.minimalOnline = 40

cfg.failCooldown = 120
cfg.hackCooldown = 900

cfg.forcefieldsCooldown = 60
cfg.codesDisabledCooldown = 420

cfg.techTimeToRepair = 20
cfg.techTimeToScan = 15

-- cfg.spyLimit = 3
--[[
	TERMINALS
]]
--[[
	terminals["terminal1"] = { -- id терминала. Должно быть уникальным.
	time = 20, -- время до взлома.
	reward = 4000, -- награда за успешный взлом.
	level = 2, -- уровень простоты предметов(не ниже 2).
	expressions = 1, -- количество примеров, которые потребуется решить
	attempts = 5, -- количество ошибок, которые можно совершить.
	cooldown = 600, -- таймаут на взлом терминала(10 минут)
	forcefieldsCooldown = 120, -- то время, которое поля будут отключены.
	resetWanted = true, -- сбрасывается ли розыск при взломе терминала
    cameraCooldown = 60, -- время отключения работы камер.
    dispatchCooldown = 60, -- время отключения работы наблюдения диспетчера.
	timeout = 120, -- то время, которое нельзя будет взломать терминал после успешного взлома.
	model = "models/props_combine/combine_interface003.mdl",
	pos = {Vector(577.375000, 3211.218750, 460.531250), Angle(-0.000, -180.000, 0.000)},
	warnTimeout = 10 -- время до уведомления ГО после взлома.

}
]]
cfg.terminals = {}
local terminals = cfg.terminals
terminals["terminal1"] = {
	time = 45,
	reward = 1000,
	level = 2,
	expressions = 4,
	forcefieldsCooldown = 30,
	cameraCooldown = 240,
	dispatchCooldown = 300,
	model = "models/props_combine/combine_interface003.mdl",
	pos = {Vector(-6940.489258, 5858.472168, 3804.321777), Angle(0, 90, 0)},
	warnTimeout = 5
}

terminals["terminal2"] = {
	time = 50,
	reward = 1500,
	level = 3,
	expressions = 3,
	forcefieldsCooldown = 50,
	resetWanted = true,
	cameraCooldown = 300,
	dispatchCooldown = 420,
	model = "models/props_combine/combine_interface003.mdl",
	pos = {Vector(-3805.965820, 6793.654297, 4121.297852), Angle(0, -135, 0)},
	warnTimeout = 3
}

terminals["terminal3"] = {
	time = 50,
	reward = 2000,
	level = 4,
	expressions = 2,
	forcefieldsCooldown = 60,
	cameraCooldown = 20,
	dispatchCooldown = 20,
	model = "models/props_combine/combine_interface001.mdl",
	pos = {Vector(2364.942627, 8925.519531, 8144.494629), Angle(0, -90, 0)},
	warnTimeout = 1,
	customFunc = function(ply, ent)
		ent.codeState = {
			isGathering = netvars.GetNetVar("YK.IsGathering", false),
			isOperation = netvars.GetNetVar("KK.IsOperation", false),
			YK_Started = netvars.GetNetVar("YK_Started", false),
			KK_Started = netvars.GetNetVar("KK_Started", false),
			DarkRP_LockDown = netvars.GetNetVar("DarkRP_LockDown", false),
			activeCode = netvars.GetNetVar("ActiveCode", nil)
		}

		hook.Run("CodeStopped", ply)

		netvars.SetNetVar("YK_Started", nil)
		netvars.SetNetVar("KK_Started", nil)
		netvars.SetNetVar("DarkRP_LockDown", nil)
		netvars.SetNetVar("KK.IsOperation", nil)
		netvars.SetNetVar("YK.IsGathering", nil)

		netvars.SetNetVar("ActiveCode", nil)
		netvars.SetNetVar("DarkRP_CodeStartTime", nil)

		DarkRP.CooldownCodes["global"] = CurTime() + cfg.codesDisabledCooldown
	end,
	resetCustomFunc = function(ply, ent)
		local codeState = ent.codeState
		local YK, KK, LD = codeState.YK_Started, codeState.KK_Started, codeState.DarkRP_LockDown
		netvars.SetNetVar("YK_Started", YK)
		netvars.SetNetVar("KK_Started", KK)
		netvars.SetNetVar("DarkRP_LockDown", LD)

		local isOperation = codeState.isOperation
		if isOperation then netvars.SetNetVar("KK.IsOperation", true) end
		local isGathering = codeState.isGathering
		if isGathering then netvars.SetNetVar("KK.IsGathering", true) end

		netvars.SetNetVar("ActiveCode", codeState.activeCode)
		netvars.SetNetVar("DarkRP_CodeStartTime", CurTime())

		DarkRP.CooldownCodes["global"] = CurTime() + 300

		local code = YK and "YK" or KK and "KK" or LD and "LK"
		hook.Run("CodeStarted", ply, code, "")
	end
}
