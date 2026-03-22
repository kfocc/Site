local NameID = FindMetaTable("Player").NameID
plogs.Register("Слухи", true, Color(0, 255, 0))
plogs.AddHook("PlayerAdverted", function(pl, text)
	plogs.PlayerLog(pl, "Слухи", NameID(pl) .. " - " .. text, {
		["Name"] = pl:Name(),
		["SteamID"] = pl:SteamID()
	})
end)

plogs.Register("Коды", true, Color(0, 255, 0))
local codes = {
	["YK"] = "Желтый код",
	["KK"] = "Красный код",
	["LK"] = "Комендантский час"
}

plogs.AddHook("CodeStarted", function(pl, which, text)
	which = codes[which] or "unknown"
	text = text or "unknown"
	if not IsValid(pl) then
		plogs.Log("Коды", which .. " был активирован. Причина - " .. text)
		return
	end

	plogs.PlayerLog(pl, "Коды", NameID(pl) .. " включил - " .. which .. " - " .. text, {
		["Name"] = IsValid(pl) and pl:Name() or "unknown",
		["SteamID"] = IsValid(pl) and pl:SteamID() or "STEAM_0:0:0"
	})
end)

plogs.AddHook("CodeStopped", function(pl)
	if not IsValid(pl) then
		plogs.Log("Коды", "Все активные коды были отключены")
		return
	end

	plogs.PlayerLog(pl, "Коды", NameID(pl) .. " выключил активные коды", {
		["Name"] = pl:Name(),
		["SteamID"] = pl:SteamID()
	})
end)

plogs.Register("Точки", true, Color(0, 255, 0))
plogs.AddHook("CPoints.StartCapture", function(pl, point)
	plogs.PlayerLog(pl, "Точки", NameID(pl) .. " начал захват " .. (point or "unknown"), {
		["Name"] = pl:Name(),
		["SteamID"] = pl:SteamID()
	})
end)

plogs.AddHook("CPoints.StopCapture", function(point) plogs.PlayerLog(pl, "Точки", "Захват " .. (point or "unknown") .. " был остановлен") end)
plogs.AddHook("CPoints.Force.StartCapture", function(pl, point)
	plogs.PlayerLog(pl, "Точки", NameID(pl) .. " начал возврат " .. (point or "unknown"), {
		["Name"] = IsValid(pl) and pl:Name() or "unknown",
		["SteamID"] = IsValid(pl) and pl:SteamID() or "STEAM_0:0:0"
	})
end)

plogs.AddHook("CPoints.Force.FinishCapture", function(pl, point)
	plogs.PlayerLog(pl, "Точки", NameID(pl) .. " вернул точку " .. (point or "unknown"), {
		["Name"] = IsValid(pl) and pl:Name() or "unknown",
		["SteamID"] = IsValid(pl) and pl:SteamID() or "STEAM_0:0:0"
	})
end)

-- hook.Run("captureBases.ZoneStopCapture", zoneData, isEnded)
-- hook.Run("captureBases.ZoneStartCapture", zoneData)
plogs.Register("Базы", true, Color(0, 255, 0))
local function tabToJSON(tab)
	local new = {}
	for k in pairs(tab) do
		if IsValid(k) then table.insert(new, k:Name() .. "(" .. k:SteamID() .. ") - " .. k:getDarkRPVar("job", "UNKNOWN")) end
	end
	return util.TableToJSON(new)
end

local captureBasesStart = "Начался захват базы: '{name}'. Количество захватывающих: {captureCount} / {captureRequire}. Лидер: {leaderCount} / {leaderRequire}."
plogs.AddHook("captureBases.ZoneStartCapture", function(zoneData)
	plogs.Log("Базы", string.Interpolate(captureBasesStart, {
		name = zoneData.name,
		captureCount = zoneData.insideZoneCount or 0,
		captureRequire = zoneData.minimumInsideZoneCount or 0,
		leaderCount = zoneData.leaderCount or 0,
		leaderRequire = zoneData.leaderRequire or 0,
	}), {
		["Name"] = zoneData.name,
		["Attackers"] = tabToJSON(zoneData.insideZone)
	})
end)

local captureBasesStop = "Закончился захват базы: '{name}'. Статус: {isEnded}. Количество захватывающих: {captureCount} / {captureRequire}. Лидер: {leaderCount} / {leaderRequire}."
plogs.AddHook("captureBases.ZoneStopCapture", function(zoneData, isEnded)
	plogs.Log("Базы", string.Interpolate(captureBasesStop, {
		name = zoneData.name,
		isEnded = isEnded and "Успешно" or "Прерван",
		captureCount = zoneData.insideZoneCount or 0,
		captureRequire = zoneData.minimumInsideZoneCount or 0,
		leaderCount = zoneData.leaderCount or 0,
		leaderRequire = zoneData.leaderRequire or 0
	}), {
		["Name"] = zoneData.name,
		["Attackers"] = tabToJSON(zoneData.insideZone)
	})
end)

--[[ plogs.Register("NLR", true, Color(0,255,0))

plogs.AddHook("NLR.InsideNLR", function(pl, area)
  plogs.PlayerLog(pl, "NLR", NameID(pl) .. " заходит в зону NLR около " .. area, {
	["Name"] = pl:Name(),
    ["SteamID"] = pl:SteamID()
  })
end)
plogs.AddHook("NLR.OutsideNLR", function(pl, area)
  plogs.PlayerLog(pl, "NLR", NameID(pl) .. " выходит из зоны NLR около " .. area, {
    ["Name"] = pl:Name(),
    ["SteamID"] = pl:SteamID()
  })
end)

--]]
plogs.Register("Принтеры", true, Color(0, 255, 0))
plogs.AddHook("MoneyPrinter.Destroy", function(ent, pl, award)
	local pOwner = ent:GetPrinterOwner()
	local bOwnerValid = IsValid(pOwner) and pOwner:IsPlayer()
	local bDestroyerValid = IsValid(pl)
	local bDestroyerIsPlayer = bDestroyerValid and pl:IsPlayer()
	plogs.PlayerLog(pl, "Принтеры", (bDestroyerValid and NameID(pl) or "unknown") .. " уничтожил принтер игрока " .. (bOwnerValid and NameID(pOwner) or "unknown") .. (award and " и получил вознаграждение" or ""), {
		["Name"] = bDestroyerValid and (bDestroyerIsPlayer and pl:Name() or pl:GetClass()),
		["SteamID"] = bDestroyerValid and (bDestroyerIsPlayer and pl:SteamID() or "unknown(not a player)"),
		["Owner Name"] = bOwnerValid and pOwner:Name() or "unknown",
		["Owner SteamID"] = bOwnerValid and pOwner:SteamID() or "unknown"
	})
end)

plogs.AddHook("MoneyPrinter.Returning", function(ent, pl, hacker)
	local bHackerValid = IsValid(hacker)
	plogs.PlayerLog(pl, "Принтеры", NameID(pl) .. " восстановил своё владение принтером, после взлома " .. (bHackerValid and NameID(hacker) or "unknown"), {
		["Name"] = IsValid(pl) and pl:Name() or "STEAM_0:0:0",
		["SteamID"] = IsValid(pl) and pl:SteamID() or "unknown",
		["Hacker Name"] = bHackerValid and hacker:Name() or "unknown",
		["Hacker SteamID"] = bHackerValid and hacker:SteamID() or "unknown"
	})
end)

plogs.AddHook("playerBoughtCustomEntity", function(pl, tblEnt, ent, cost)
	local class = ent:GetClass()
	if string.sub(tblEnt.ent, 1, 11) ~= "rx_printer_" then return end
	plogs.PlayerLog(pl, "Принтеры", NameID(pl) .. " приобрел " .. tblEnt.name, {
		["Name"] = pl:Name(),
		["SteamID"] = pl:SteamID(),
	})
end)

plogs.Register("Протоколы", true, Color(0, 255, 0))
plogs.AddHook("OnOTAProtocolSet", function(pl, targets, protocol)
	local target = "всем"
	local data = {
		["Name"] = pl:Name(),
		["SteamID"] = pl:SteamID(),
	}

	if #targets == 1 then
		target = NameID(targets[1])
		data["Target Name"] = targets[1]:Name()
		data["Target SteamID"] = targets[1]:SteamID()
	end

	plogs.PlayerLog(pl, "Протоколы", NameID(pl) .. " выдал " .. target .. " протокол: " .. protocol, data)
end)

plogs.AddHook("OnOTAProtocolReset", function(pl, targets)
	local target = "всем"
	local data = {
		["Name"] = pl:Name(),
		["SteamID"] = pl:SteamID(),
	}

	if #targets == 1 then
		target = NameID(targets[1])
		data["Target Name"] = targets[1]:Name()
		data["Target SteamID"] = targets[1]:SteamID()
	end

	plogs.PlayerLog(pl, "Протоколы", NameID(pl) .. " сбросил протокол " .. target, data)
end)

plogs.Register("Ограбления", true, Color(0, 255, 0))
plogs.AddHook("OnRobberyPlayer", function(ply, target, weaponClass, money)
	local plyPos, targetPos = ply:GetPos(), target:GetPos()
	local posTab = {}
	if plyPos then
		table.insert(posTab, {
			key = "tpToPos",
			text = "ТП на позицию грабителя",
			data = plyPos
		})
	end

	if targetPos then
		table.insert(posTab, {
			key = "tpToPos",
			text = "ТП на позицию жертвы",
			data = targetPos
		})
	end

	plogs.Log("Ограбления", ply:NameID() .. " ограбил " .. target:NameID() .. " на " .. DarkRP.formatMoney(money) .. " с помощью " .. weaponClass, {
		["Жертва"] = target:SteamID(),
		["Грабитель"] = ply:SteamID(),
		["Оружие"] = weaponClass
	}, posTab)
end)

plogs.AddHook("OnStealPlayer", function(ply, target, money, isCid)
	local plyPos, targetPos = ply:GetPos(), target:GetPos()
	local posTab = {}
	if plyPos then
		table.insert(posTab, {
			key = "tpToPos",
			text = "ТП на позицию вора",
			data = plyPos
		})
	end

	if targetPos then
		table.insert(posTab, {
			key = "tpToPos",
			text = "ТП на позицию жертвы",
			data = targetPos
		})
	end

	plogs.Log("Ограбления", ply:NameID() .. " своровал у " .. target:NameID() .. ": " .. DarkRP.formatMoney(money) .. (isCid and " и CID-карту" or ""), {
		["Жертва"] = target:SteamID(),
		["Грабитель"] = ply:SteamID(),
		["Оружие"] = weaponClass
	}, posTab)
end)

plogs.AddHook("OnRobberyCashback", function(ply, target, money, isCid)
	plogs.Log("Ограбления", ply:NameID() .. " вернул от " .. target:NameID() .. ": " .. (money and DarkRP.formatMoney(money) or "") .. (isCid and " и CID-карту" or ""), {
		["Жертва"] = target:SteamID(),
		["Грабитель"] = ply:SteamID(),
	})
end)

plogs.Register("Вызовы", true, Color(0, 255, 0))
plogs.AddHook("request.send", function(ply, id, text, params)
	plogs.Log("Вызовы", ply:NameID() .. " сделал " .. params.requestText .. text, {
		["SteamID"] = ply:SteamID(),
	})
end)

plogs.AddHook("cmd.NoticeAdd", function(ply, text, time, show_pos)
	text = "альянса на " .. time .. " секунд. С текстом: " .. text
	if show_pos then
		text = " начал построение" .. text
	else
		text = " запустил объявление" .. text
	end

	plogs.Log("Вызовы", ply:NameID() .. text, {
		["SteamID"] = ply:SteamID(),
	})
end)

plogs.Register("Предупреждения", true, Color(0, 255, 0))
plogs.AddHook("onPlayerWarned", function(ply, target, reason)
	plogs.PlayerLog(ply, "Предупреждения", NameID(ply) .. " выдал предупреждение " .. NameID(target) .. " за " .. reason, {
		["Name"] = IsValid(ply) and ply:Name() or "Unknown",
		["SteamID"] = IsValid(ply) and ply:SteamID() or "STEAM_0:0:0",
		["Target Name"] = target:Name(),
		["Target SteamID"] = target:SteamID()
	})
end)

plogs.AddHook("onPlayerUnWarned", function(ply, target, reason)
	plogs.PlayerLog(ply, "Предупреждения", NameID(ply) .. " снял предупреждение " .. NameID(target) .. " за " .. reason, {
		["Name"] = IsValid(ply) and ply:Name() or "Unknown",
		["SteamID"] = IsValid(ply) and ply:SteamID() or "STEAM_0:0:0",
		["Target Name"] = target:Name(),
		["Target SteamID"] = target:SteamID()
	})
end)

plogs.AddHook("onPlayerResetWarns", function(ply, target)
	plogs.PlayerLog(ply, "Предупреждения", NameID(ply) .. " снял все предупреждения " .. NameID(target), {
		["Name"] = IsValid(ply) and ply:Name() or "Unknown",
		["SteamID"] = IsValid(ply) and ply:SteamID() or "STEAM_0:0:0",
		["Target Name"] = target:Name(),
		["Target SteamID"] = target:SteamID()
	})
end)

plogs.Register("Отряды", true, Color(0, 255, 0))
plogs.AddHook("Squads.Create", function(ply, target, id, squad)
	if not IsValid(ply) then -- Системно
		return
	end

	local name = squad.name
	plogs.PlayerLog(ply, "Отряды", NameID(ply) .. " создал отряд #" .. id .. " " .. name .. " для " .. NameID(target), {
		["Name"] = ply:Name(),
		["SteamID"] = ply:SteamID(),
		["Target Name"] = target:Name(),
		["Target SteamID"] = target:SteamID(),
		["Squad Name"] = name,
		["Squad ID"] = id
	})
end)

plogs.AddHook("Squads.MakeLeader", function(ply, target, id, squad, old_leader)
	if not IsValid(ply) then
		return
	end
	if not old_leader then -- Создание отряда
		return
	end

	local squad_name = squad.name
	plogs.PlayerLog(ply, "Отряды", NameID(ply) .. " передал лидерство отряда #" .. id .. " " .. squad_name .. " " .. NameID(target) .. ". Прошлый лидер: " .. NameID(old_leader), {
		["Name"] = ply:Name(),
		["SteamID"] = ply:SteamID(),
		["Target Name"] = target:Name(),
		["Target SteamID"] = target:SteamID(),
		["Squad Name"] = squad_name,
		["Squad ID"] = id,
		["Old Leader Name"] = old_leader:Name(),
		["Old Leader SteamID"] = old_leader:SteamID()
	})
end)

plogs.AddHook("Squads.Disband", function(ply, id, squad)
	if not IsValid(ply) then -- Системно
		return
	end

	local name = squad.name
	local leader = squad.leader
	plogs.PlayerLog(ply, "Отряды", NameID(ply) .. " распустил отряд #" .. id .. " " .. name .. ". Лидер: " .. NameID(leader), {
		["Name"] = ply:Name(),
		["SteamID"] = ply:SteamID(),
		["Squad Name"] = name,
		["Squad ID"] = id,
		["Leader Name"] = leader:Name(),
		["Leader SteamID"] = leader:SteamID()
	})
end)

plogs.AddHook("Squads.Leave", function(ply, id, squad, by)
	local name = squad.name
	if not by then
		plogs.PlayerLog(ply, "Отряды", NameID(ply) .. " покинул отряд #" .. id .. " " .. name, {
			["Name"] = ply:Name(),
			["SteamID"] = ply:SteamID(),
			["Squad Name"] = name,
			["Squad ID"] = id
		})
		return
	end

	plogs.PlayerLog(ply, "Отряды", NameID(by) .. " исключил из отряда #" .. id .. " " .. name .. " " .. NameID(ply), {
		["Name"] = ply:Name(),
		["SteamID"] = ply:SteamID(),
		["Squad Name"] = name,
		["Squad ID"] = id,
		["By Name"] = by:Name(),
		["By SteamID"] = by:SteamID()
	})
end)

plogs.AddHook("Squads.Move", function(ply, target, id, squad)
	if not IsValid(ply) then
		return
	end

	local name = squad.name
	plogs.PlayerLog(ply, "Отряды", NameID(ply) .. " переместил " .. NameID(target) .. " в отряд #" .. id .. " " .. name, {
		["Name"] = ply:Name(),
		["SteamID"] = ply:SteamID(),
		["Target Name"] = target:Name(),
		["Target SteamID"] = target:SteamID(),
		["Squad Name"] = name,
		["Squad ID"] = id
	})
end)

plogs.AddHook("Squads.Rename", function(ply, id, squad, name)
	if not IsValid(ply) then
		return
	end
	local old_name = squad.name
	plogs.PlayerLog(ply, "Отряды", NameID(ply) .. " переименовал отряд #" .. id .. " из " .. old_name .. " в " .. name, {
		["Name"] = ply:Name(),
		["SteamID"] = ply:SteamID(),
		["Squad Name"] = name,
		["Squad ID"] = id
	})
end)

plogs.Register("Объявления", true, Color(0, 255, 0))
local id_to_fract = {
	["rebel"] = "повстанцев",
	["gsr"] = "ГСР",
	["cp"] = "альянса"
}

plogs.AddHook("cmd.NoticeAdd", function(ply, text, time, show_pos, cooldown_id)
	local target = id_to_fract[cooldown_id] or "неизвестно"
	local what = show_pos and "начинает построение" or "вещает объявление"
	local how_long = util.TimeToStr(time)
	plogs.Log("Объявления", NameID(ply) .. " " .. what .. " для " .. target .. ". Длительность: " .. how_long .. ". Текст: " .. text, {
		["SteamID"] = ply:SteamID(),
		["Текст"] = text,
		["Длительность"] = how_long
	})
end)
