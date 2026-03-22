DarkRP.RobberyStuff = DarkRP.RobberyStuff or {}
local robbery_stuff = DarkRP.RobberyStuff

robbery_stuff.timeToSteal = 10 -- время ограбление в секундах
robbery_stuff.stealCooldown = 5 * 60 -- КД ограбления на цель в секундах
robbery_stuff.minMoneyCount = 10000 -- минимальное количество денег для ограбления
robbery_stuff.maxDist = 70 ^ 2 -- дистанция до жертвы
robbery_stuff.moneyBackTime = 3 * 60 -- время за которое в секундах жертва может вернуть деньги

robbery_stuff.acceptedWeaponBase = {
	["swb_base"] = true,
	["swb_melee"] = true,
	["tfa_gun_base"] = true,
	["tfa_scoped_base"] = true,
	["tfa_shotty_base"] = true,
	["tfa_bash_base"] = true,
	["tfa_melee_base"] = true,
	["tfa_nmrimelee_base"] = true,
}

robbery_stuff.acceptedWeaponClass = {}
-- ["weapon_shit"] = true

robbery_stuff.canUseJobs = {
	-- кто может пользоваться функционалом
	[TEAM_CITIZEN1] = true,
	[TEAM_BAND1] = true,
	[TEAM_BAND2] = true,
	[TEAM_BAND3] = true,
	[TEAM_BAND4] = true,
	[TEAM_AFERIST] = true,
	[TEAM_GANG1] = true,
	[TEAM_BEGLEC1] = true,
	[TEAM_BEGLEC2] = true,
	[TEAM_BEGLEC3] = true,
}

robbery_stuff.robberyExcludeJobs = {
	-- маппинг проф который грабить нельзя вообще
	[TEAM_NONE] = true,
}

function robbery_stuff:canRobberyJob(ply, target)
	-- if ply:Team() == target:Team() then return false end
	if ply:isBandit() and target:isBandit() then return false end
	return true
end

function robbery_stuff:canShowMenu(ply, target)
	if not self.canUseJobs[ply:Team()] then return false end
	return true
end
