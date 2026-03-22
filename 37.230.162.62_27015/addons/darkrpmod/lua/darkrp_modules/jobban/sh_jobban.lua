if ulx then
	local CATEGORY_NAME = "DarkRP"
	local function checkArgs(...)
		local check = false
		local hasDouble = false
		for k, v in pairs({...}) do
			if v == nil then continue end
			if not check then
				check = true
			else
				hasDouble = true
			end
		end
		return hasDouble
	end

	function ulx.jobBan(calling_ply, target_ply, time, side, group, job, reason)
		if side == "Сторона" then side = nil end
		if group == "Группа" then group = nil end
		job = job:Trim()
		if job == "" or job == "Профессия" then job = nil end
		if checkArgs(side, group, job) then
			ULib.tsayError(calling_ply, "Вы должны выбрать только один аргумент: сторону/группу/профессию!", true)
			return
		end

		local arg = job or side or group
		if not arg then
			ULib.tsayError(calling_ply, "Введены некорректные данные!", true)
			return
		end

		arg = arg:Trim()
		job, side, group = DarkRP.localizeJobBan(arg)
		arg = job or side or group
		if not arg then
			ULib.tsayError(calling_ply, "Введены некорректные данные!", true)
			return
		end

		local newName = DarkRP.localize(arg)
		local res, banTime = DarkRP.isJobBanned(calling_ply:SteamID(), arg)
		if res then
			if banTime ~= 0 then banTime = banTime - os.time() end
			ULib.tsayError(calling_ply, "У игрока уже имеется активный бан: " .. newName .. ", остаток: " .. util.TimeToStr(banTime), true)
			return
		end

		local retStr = job and "профессии" or side and "стороны" or group and "категории"
		if time == 0 then
			ulx.fancyLogAdmin(calling_ply, "#A выдал #T перманетный бан " .. retStr .. " #s, с причиной #s.", target_ply, newName, reason)
		else
			time = time * 60
			ulx.fancyLogAdmin(calling_ply, "#A выдал #T бан " .. retStr .. " #s на #s, с причиной #s.", target_ply, newName, util.TimeToStr(time), reason)
		end

		DarkRP.jobBan(target_ply:SteamID(), time, job, side, group)
	end

	local jobBan = ulx.command(CATEGORY_NAME, "ulx jobban", ulx.jobBan, "!jobban")
	jobBan:addParam{
		type = ULib.cmds.PlayerArg
	}

	jobBan:addParam{
		type = ULib.cmds.NumArg,
		hint = "minutes, 0 for perma",
		ULib.cmds.optional,
		ULib.cmds.allowTimeString,
		min = 0
	}

	jobBan:addParam{
		type = ULib.cmds.StringArg,
		completes = {"Сторона", "Альянс", "Сопротивление"},
		hint = "Сторона",
		error = "invalid side \"%s\" specified",
		ULib.cmds.restrictToCompletes,
		default = "Сторона",
		ULib.cmds.optional,
	}

	local naming = {
		"Группа",
		"Повстанцы",
		"ГСР",
		"ОТА",
		"Беглецы",
		"Командование повстанцев",
		"ГО",
		"Командование ГО",
		"Гангстеры",
		"Зомби",
		"HYDRA",
		"Лоялисты"
	}
	jobBan:addParam{
		type = ULib.cmds.StringArg,
		completes = naming,
		hint = "Группа",
		error = "invalid group \"%s\" specified",
		ULib.cmds.restrictToCompletes,
		default = "Группа",
		ULib.cmds.optional,
	}

	local exCat = {
		None = true,
		Iventboy = true,
		Secret = true,
		Zombienpc = true,
	}

	local function collectJobNames()
		local l = {}
		for k, v in ipairs(RPExtraTeams) do
			if exCat[v.type] then continue end
			table.insert(l, v.name)
		end
		return l
	end

	jobBan:addParam{
		hint = "Профессия",
		type = ULib.cmds.StringArg,
		completes = collectJobNames(),
	}

	jobBan:addParam{
		type = ULib.cmds.StringArg,
		hint = "reason"
	}

	jobBan:defaultAccess(ULib.ACCESS_SUPERADMIN)
	jobBan:help("Bans target from specified job.")
	function ulx.jobUnBan(calling_ply, target_ply, side, group, job, reason)
		if side == "Сторона" then side = nil end
		if group == "Группа" then group = nil end
		job = job:Trim()
		if job == "" or job == "Профессия" then job = nil end
		if checkArgs(side, group, job) then
			ULib.tsayError(calling_ply, "Вы должны выбрать только один аргумент: сторону/группу/профессию!", true)
			return
		end

		local arg = job or side or group
		if not arg then
			ULib.tsayError(calling_ply, "Введены некорректные данные!", true)
			return
		end

		arg = arg:Trim()
		job, side, group = DarkRP.localizeJobBan(arg)
		arg = job or side or group
		if not arg then
			ULib.tsayError(calling_ply, "Введены некорректные данные!", true)
			return
		end

		local newName = DarkRP.localize(arg)
		DarkRP.jobUnban(target_ply:SteamID(), job, side, group)
		local retStr = job and "профессии" or side and "стороны" or group and "категории"
		ulx.fancyLogAdmin(calling_ply, "#A снял #T бан " .. retStr .. " #s, с причиной #s.", target_ply, newName, reason)
	end

	local jobUnBan = ulx.command(CATEGORY_NAME, "ulx jobunban", ulx.jobUnBan, "!jobunban")
	jobUnBan:addParam{
		type = ULib.cmds.PlayerArg
	}

	jobUnBan:addParam{
		type = ULib.cmds.StringArg,
		completes = {"Сторона", "Альянс", "Сопротивление"},
		hint = "Сторона",
		error = "invalid side \"%s\" specified",
		ULib.cmds.restrictToCompletes,
		default = "Сторона",
		ULib.cmds.optional,
	}

	jobUnBan:addParam{
		type = ULib.cmds.StringArg,
		completes = naming,
		hint = "Группа",
		error = "invalid group \"%s\" specified",
		ULib.cmds.restrictToCompletes,
		default = "Группа",
		ULib.cmds.optional,
	}

	jobUnBan:addParam{
		hint = "Профессия",
		type = ULib.cmds.StringArg,
		completes = collectJobNames(),
	}

	jobUnBan:addParam{
		type = ULib.cmds.StringArg,
		hint = "reason"
	}

	jobUnBan:defaultAccess(ULib.ACCESS_SUPERADMIN)
	jobUnBan:help("Unbans target from specified job.")
end
