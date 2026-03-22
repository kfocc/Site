local CATEGORY_NAME = "DarkRP"
local pluralizeLives = PL.Add("jobLives", {"жизнь", "жизни", "жизней"})
do
	local printLivesFmt = "У {name} осталось ({lives}/{maxLives})."
	function ulx.getlives(ply, target)
		local lives, maxLives = target:GetLives(), target:GetMaxLives()
		ply:ChatPrint(tostring(string.Interpolate(printLivesFmt, {
			name = tostring(target:NameID()),
			lives = lives,
			maxLives = maxLives
		})))
	end

	local getLives = ulx.command(CATEGORY_NAME, "ulx getlives", ulx.getlives, "!getlives")
	getLives:addParam{
		type = ULib.cmds.PlayerArg
	}

	getLives:defaultAccess(ULib.ACCESS_SUPERADMIN)
	getLives:help("Получить количество жизней у игрока в данный момент.")
end

do
	local addLivesFmt = "Вы добавили {name} {count} жизнь(и), теперь у него: ({lives}/{maxLives})."
	function ulx.addlives(ply, target, livesCount)
		livesCount = math.abs(livesCount)
		local maxLives = target:GetMaxLives()
		if maxLives == -1 then
			ULib.tsayError(ply, "У игрока нет жизней, либо они отключены!", true)
			return
		end

		local currentLives = target:GetLives()
		if currentLives == maxLives then
			ULib.tsayError(ply, "У игрока максимальное количество жизней!", true)
			return
		end

		local finallyLives = currentLives + livesCount
		if finallyLives > maxLives then
			local livesEnd = maxLives - currentLives
			ULib.tsayError(ply, "Вы можете добавить только " .. pluralizeLives(livesEnd) .. "!", true)
			return
		end

		target:AddLives(livesCount, true)
		ply:ChatPrint(tostring(string.Interpolate(addLivesFmt, {
			name = tostring(target:NameID()),
			count = livesCount,
			lives = target:GetLives(),
			maxLives = maxLives
		})))

		ulx.fancyLogAdmin(ply, "#A добавил #T #s.", target, pluralizeLives(livesCount))
	end

	local addLives = ulx.command(CATEGORY_NAME, "ulx addlives", ulx.addlives, "!addlives")
	addLives:addParam{
		type = ULib.cmds.PlayerArg
	}

	addLives:addParam{
		type = ULib.cmds.NumArg,
		hint = "lives",
		default = 1,
		min = 1,
		max = 10,
		ULib.cmds.round
	}

	addLives:defaultAccess(ULib.ACCESS_SUPERADMIN)
	addLives:help("Добавить количество жизней игроку.")
end

do
	local subLivesFmt = "Вы забрали у {name} {count} жизнь(и), теперь у него: ({lives}/{maxLives})."
	function ulx.sublives(ply, target, livesCount)
		livesCount = math.abs(livesCount)
		local maxLives = target:GetMaxLives()
		if maxLives == -1 then
			ULib.tsayError(ply, "У игрока нет жизней, либо они отключены!", true)
			return
		end

		local currentLives = target:GetLives()
		if currentLives <= 1 then
			ULib.tsayError(ply, "У игрока и так минимальное количество жизней!", true)
			return
		end

		local finallyLives = currentLives - livesCount
		if finallyLives <= 0 then
			local livesEnd = currentLives - 1
			ULib.tsayError(ply, "Вы можете отнять только " .. pluralizeLives(livesEnd) .. "!", true)
			return
		end

		target:SubLives(livesCount, true)
		ply:ChatPrint(tostring(string.Interpolate(subLivesFmt, {
			name = tostring(target:NameID()),
			count = livesCount,
			lives = target:GetLives(),
			maxLives = maxLives
		})))

		ulx.fancyLogAdmin(ply, "#A забрал у #T #s.", target, pluralizeLives(livesCount))
	end

	local subLives = ulx.command(CATEGORY_NAME, "ulx sublives", ulx.sublives, "!sublives")
	subLives:addParam{
		type = ULib.cmds.PlayerArg
	}

	subLives:addParam{
		type = ULib.cmds.NumArg,
		hint = "lives",
		default = 1,
		min = 1,
		max = 10,
		ULib.cmds.round
	}

	subLives:defaultAccess(ULib.ACCESS_SUPERADMIN)
	subLives:help("Забрать количество жизней у игрока.")
end

do
	local setLivesFmt = "Вы установили для {name} {count} жизнь(и), теперь у него: ({lives}/{maxLives})."
	function ulx.setlives(ply, target, livesCount)
		livesCount = math.abs(livesCount)
		local maxLives = target:GetMaxLives()
		if maxLives == -1 then
			ULib.tsayError(ply, "У игрока нет жизней, либо они отключены!", true)
			return
		end

		if livesCount <= 0 or livesCount > maxLives then
			ULib.tsayError(ply, "Вы можете установить от 1 до " .. pluralizeLives(maxLives) .. "!", true)
			return
		end

		target:SetLives(livesCount, true)
		ply:ChatPrint(tostring(string.Interpolate(setLivesFmt, {
			name = tostring(target:NameID()),
			count = livesCount,
			lives = target:GetLives(),
			maxLives = target:GetMaxLives()
		})))

		ulx.fancyLogAdmin(ply, "#A установил для #T #s.", target, pluralizeLives(livesCount))
	end

	local setLives = ulx.command(CATEGORY_NAME, "ulx setlives", ulx.setlives, "!setlives")
	setLives:addParam{
		type = ULib.cmds.PlayerArg
	}

	setLives:addParam{
		type = ULib.cmds.NumArg,
		hint = "lives",
		default = 1,
		min = 1,
		max = 10,
		ULib.cmds.round
	}

	setLives:defaultAccess(ULib.ACCESS_SUPERADMIN)
	setLives:help("Установить количество жизней для игрока.")
end

do
	local setMaxLivesFmt = "Вы установили для {name} максимальное количество жизней: {count}, теперь у него: ({lives}/{maxLives})."
	function ulx.setmaxlives(ply, target, livesCount)
		if livesCount < -1 or livesCount > 10 or livesCount == 0 then
			ULib.tsayError(ply, "Выберите значение в пределах от -1 до 10, за исключением 0!", true)
			return
		end

		local setCount = livesCount
		if livesCount == -1 then livesCount = nil end
		target:SetMaxLives(livesCount)
		target:SetLives(livesCount)
		ply:ChatPrint(tostring(string.Interpolate(setMaxLivesFmt, {
			name = tostring(target:NameID()),
			count = setCount,
			lives = target:GetLives(),
			maxLives = target:GetMaxLives()
		})))

		if setCount == -1 then
			ulx.fancyLogAdmin(ply, "#A убрал для #T лимит жизней.", target)
		else
			ulx.fancyLogAdmin(ply, "#A установил для #T лимит: #s.", target, pluralizeLives(setCount))
		end
	end

	local setMaxLives = ulx.command(CATEGORY_NAME, "ulx setmaxlives", ulx.setmaxlives, "!setmaxlives")
	setMaxLives:addParam{
		type = ULib.cmds.PlayerArg
	}

	setMaxLives:addParam{
		type = ULib.cmds.NumArg,
		hint = "lives",
		default = 1,
		min = -1,
		max = 10,
		ULib.cmds.round
	}

	setMaxLives:defaultAccess(ULib.ACCESS_SUPERADMIN)
	setMaxLives:help("Установить количество жизней для игрока.")
end
