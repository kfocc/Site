local list = {}
--list[""] = function(ply) return ply:isBandit() or ply:isCP() end -- Если Бандит или Альянс - не может
list["Радость"] = function(ply)
	return ply:isCP() or ply:Team() == TEAM_GMAN -- Если Альянс - не может
end

list["Лев"] = function(ply) return ply:isCP() or ply:Team() == TEAM_GMAN end
list["Смех"] = function(ply) return ply:isCP() end
list["Имитация зомби"] = function(ply) return ply:isCP() or ply:Team() == TEAM_GMAN end
list["Танец робота"] = function(ply) return ply:isCP() or ply:Team() == TEAM_GMAN end
list["Распутный танец"] = function(ply) return ply:isCP() or ply:Team() == TEAM_GMAN end
list["Танец"] = function(ply) return ply:isCP() or ply:Team() == TEAM_GMAN end
list["Дэб"] = function(ply) return ply:isCP() or ply:Team() == TEAM_GMAN or not ply:isVIP() end
-----------------------
list["Руки вверх"] = function(ply) return ply:Team() == TEAM_GMAN end
list["Салютовать"] = function(ply) return ply:Team() == TEAM_GMAN end
list["Поднять руку"] = function(ply) return ply:Team() == TEAM_GMAN end
local function LoadCFG(ply, name)
	if ply:isZombie() then return false end
	if not list[name] then return end
	local should = list[name](ply)
	if should then return false end
end

hook.Add("PlayerCanTaunt", "TauntConfig", LoadCFG)
hook.Add("PlayerCanTaunt", "_TauntCheckSit", function(ply, anim)
	local veh = ply:GetVehicle()
	if IsValid(veh) or ply:IsFrozen() then return false, "Вы не можете использовать анимации." end
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep:GetClass() == "weapon_lockpick" or wep.IsTFAWeapon or wep.SWBWeapon then return false, "Вы не можете использовать анимации." end
end)
