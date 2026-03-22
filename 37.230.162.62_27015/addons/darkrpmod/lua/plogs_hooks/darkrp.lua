-- Hit logs
if plogs.cfg.LogTypes['hhh'] and plogs.cfg.LogTypes['hitmodule'] then
	plogs.Register('Заказы', true, Color(51, 128, 255))
	plogs.AddHook('onHitAccepted', function(hitman, target, customer)
		plogs.PlayerLog(hitman, 'Заказы', hitman:NameID() .. ' принял заказ на ' .. target:NameID() .. '  от ' .. customer:NameID(), {
			['Имя киллера'] = hitman:Name(),
			['SteamID киллера'] = hitman:SteamID(),
			['Имя заказчика'] = customer:Name(),
			['SteamID заказчика'] = customer:SteamID(),
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
		})
	end)

	plogs.AddHook('onHitCompleted', function(hitman, target, customer)
		plogs.PlayerLog(hitman, 'Заказы', hitman:NameID() .. ' выполнил заказ на ' .. target:NameID() .. '  от ' .. customer:NameID(), {
			['Имя киллера'] = hitman:Name(),
			['SteamID киллера'] = hitman:SteamID(),
			['Имя заказчика'] = customer:Name(),
			['SteamID заказчика'] = customer:SteamID(),
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
		})
	end)

	plogs.AddHook('onHitFailed', function(hitman, target)
		plogs.PlayerLog(hitman, 'Заказы', hitman:NameID() .. ' провалил заказ на ' .. target:NameID(), {
			['Имя киллера'] = hitman:Name(),
			['SteamID киллера'] = hitman:SteamID(),
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
		})
	end)
end

-- Names
plogs.Register('Имена', true, Color(51, 128, 255))
plogs.AddHook('onPlayerChangedName', function(pl, old, new)
	if IsValid(pl) and old ~= nil then
		plogs.PlayerLog(pl, 'Имена', pl:NameID() .. ' изменил имя на ' .. new .. ' из ' .. old, {
			['Имя'] = pl:Name(),
			['SteamID'] = pl:SteamID()
		})
	end
end)

-- Job changes
plogs.Register('Профессии', true, Color(51, 128, 255))
plogs.AddHook('OnPlayerChangedTeam', function(pl, old, new)
	if IsValid(pl) then
		plogs.PlayerLog(pl, 'Профессии', pl:NameID() .. ' изменил профессию на ' .. team.GetName(new) .. ' из ' .. team.GetName(old), {
			['Имя'] = pl:Name(),
			['SteamID'] = pl:SteamID()
		})
	end
end)

-- Demotions
plogs.Register('Увольнения', true, Color(51, 128, 255))
plogs.AddHook('onPlayerDemoted', function(demoter, demotee, reason)
	if IsValid(demoter) and IsValid(demotee) then
		plogs.PlayerLog(demoter, 'Увольнения', demoter:NameID() .. ' уволил ' .. demotee:NameID() .. ' - ' .. reason, {
			['Имя цели'] = demotee:Name(),
			['SteamID цели'] = demotee:SteamID(),
			['Имя увольняющего'] = demoter:Name(),
			['SteamID увольняющего'] = demoter:SteamID(),
		})
	end
end)

-- Police logs
plogs.Register('Альянс', true, Color(51, 128, 255))
plogs.AddHook('playerArrested', function(target, time, officer, reason)
	if IsValid(officer) then
		plogs.PlayerLog(officer, 'Альянс', officer:NameID() .. ' арестовал ' .. target:NameID() .. " на " .. time .. "секунд - " .. reason, {
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
			['Имя офицера'] = officer:Name(),
			['SteamID офицера'] = officer:SteamID(),
		})
	end
end)

plogs.AddHook('playerUnArrested', function(target, officer)
	if IsValid(officer) then
		plogs.PlayerLog(officer, 'Альянс', officer:NameID() .. ' выпустил ' .. target:NameID(), {
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
			['Имя офицера'] = officer:Name(),
			['SteamID офицера'] = officer:SteamID(),
		})
	else
		plogs.Log('Альянс', target:NameID() .. ' был выпущен из тюрьмы.', {
			['Имя'] = target:Name(),
			['SteamID'] = target:SteamID(),
		})
	end
end)

plogs.AddHook('playerWanted', function(target, officer, reason)
	if IsValid(officer) then
		plogs.PlayerLog(officer, 'Альянс', officer:NameID() .. ' объявил в розыск ' .. target:NameID() .. ' - ' .. reason, {
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
			['Имя офицера'] = officer:Name(),
			['SteamID офицера'] = officer:SteamID(),
		})
	end
end)

plogs.AddHook('playerUnWanted', function(target, officer)
	if IsValid(officer) then
		plogs.PlayerLog(officer, 'Альянс', officer:NameID() .. ' снял розыск у ' .. target:NameID(), {
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
			['Имя офицера'] = officer:Name(),
			['SteamID офицера'] = officer:SteamID(),
		})
	else
		plogs.Log('Альянс', 'Розыск ' .. target:NameID() .. ' истёк ', {
			['Имя'] = target:Name(),
			['SteamID'] = target:SteamID(),
		})
	end
end)

plogs.AddHook('playerWarranted', function(target, officer, reason)
	if IsValid(officer) then
		plogs.PlayerLog(officer, 'Альянс', officer:NameID() .. ' запросил ордер на ' .. target:NameID() .. ' - ' .. reason, {
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
			['Имя офицера'] = officer:Name(),
			['SteamID офицера'] = officer:SteamID(),
		})
	end
end)

plogs.AddHook('playerUnWarranted', function(target, officer)
	if IsValid(officer) then
		plogs.PlayerLog(officer, 'Альянс', officer:NameID() .. ' убрал ордер ' .. target:NameID(), {
			['Имя цели'] = target:Name(),
			['SteamID цели'] = target:SteamID(),
			['Имя офицера'] = officer:Name(),
			['SteamID офицера'] = officer:SteamID(),
		})
	else
		plogs.Log('Альянс', 'Ордер на ' .. target:NameID() .. ' истёк', {
			['Имя'] = target:Name(),
			['SteamID'] = target:SteamID(),
		})
	end
end)

-- Lockpicks
plogs.Register('Взлом', true, Color(0, 255, 0))
local correctname = {
	["func_door_rotating"] = "двери",
	["func_door"] = "двери",
	["prop_door_rotating"] = "двери",
	["prop_physics"] = "пропа",
}

plogs.AddHook('lockpickStarted', function(pl, ent)
	local class = ent:GetClass()
	local name = correctname[class] or class:find("rx_printer") and "Мани принтера" or class
	local owner = ent.dt and IsValid(ent.dt.owning_ent) and ent.dt.owning_ent or ent:getDoorOwner() or ent:CPPIGetOwner()
	if owner then
		plogs.PlayerLog(pl, 'Взлом', pl:NameID() .. ' начал взлом ' .. name .. ' ' .. owner:NameID(), {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID(),
			["Имя владельца"] = owner:Name(),
			["SteamID владельца"] = owner:SteamID()
		})
	else
		plogs.PlayerLog(pl, 'Взлом', pl:NameID() .. ' начал взлом ' .. name, {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID()
		})
	end
end)

plogs.AddHook('onLockpickCompleted', function(pl, succ, ent)
	local class = IsValid(ent) and ent:GetClass()
	local name = class and (correctname[class] or class:find("rx_printer") and "Мани принтера" or class) or "Invalid entity"
	local owner = IsValid(ent) and (ent.dt and IsValid(ent.dt.owning_ent) and ent.dt.owning_ent or ent:getDoorOwner() or ent:CPPIGetOwner())
	if owner then
		plogs.PlayerLog(pl, 'Взлом', pl:NameID() .. ' закончил взлом ' .. name .. ' ' .. owner:NameID() .. ' (' .. (succ and 'успешно' or 'неуспешно') .. ')', {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID(),
			["Имя владельца"] = owner:Name(),
			["SteamID владельца"] = owner:SteamID()
		})
	else
		plogs.PlayerLog(pl, 'Взлом', pl:NameID() .. ' закончил взлом ' .. name .. ' (' .. (succ and 'успешно' or 'неуспешно') .. ')', {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID()
		})
	end
end)

timer.Simple(0, function() DarkRP.log = function() end end)
