local CATEGORY_NAME = "Util"

if SERVER then
	util.AddNetworkString("OpenURL")
end

local groups_mask = {
	["user"] = true,
	["vip"] = true,
	["operator"] = true,
	["moderator"] = true,
	["administrator"] = true
}

local groups_allow_default = {
	["overwatch"] = true,
	["assistant_nabor"] = true,
	["advisor_nabor"] = true,
	["event_boss_nabor"] = true,
}

function ulx.warnlist(ply, target)
	local success, text = Warns.ListWarns(target, ply)
	DarkRP.notify(ply, 0, 4, text)
end
local warnlist = ulx.command(CATEGORY_NAME, "ulx warnlist", ulx.warnlist, "!warnlist")
warnlist:addParam{
	type = ULib.cmds.PlayerArg
}
warnlist:defaultAccess(ULib.ACCESS_SUPERADMIN)
warnlist:help("Просмотр варнов игрока")

function ulx.warn(ply, target, reason)
	if reason == "" then
		DarkRP.notify(ply, 1, 4, "Введите причину")
		return
	end

	local success, text = Warns.Warn(target, reason, ply)
	DarkRP.notify(ply, 0, 4, text)
end
local warn = ulx.command(CATEGORY_NAME, "ulx warn", ulx.warn, "!warn")
warn:addParam{
	type = ULib.cmds.PlayerArg
}
warn:addParam{
	type = ULib.cmds.StringArg,
	hint = "Причина",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
warn:defaultAccess(ULib.ACCESS_SUPERADMIN)
warn:help("Выдача варна игроку")

function ulx.unwarn(ply, target, num)
	local success, text = Warns.UnWarn(target, ply, num)
	DarkRP.notify(ply, 0, 4, text)
end
local unwarn = ulx.command(CATEGORY_NAME, "ulx unwarn", ulx.unwarn, "!unwarn")
unwarn:addParam{
	type = ULib.cmds.PlayerArg
}
unwarn:addParam{
	type = ULib.cmds.StringArg,
	hint = "Номер варна",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
unwarn:defaultAccess(ULib.ACCESS_SUPERADMIN)
unwarn:help("Выдача варна игроку")

function ulx.setadmin(calling_ply)
	local adms = {}
	for k, v in player.Iterator() do
		if not v:GetUserGroup():find("nabor") then continue end
		if v:Team() == TEAM_ADMIN then continue end

		table.insert(adms, v)
	end

	timer.Simple(.1, function()
		if #adms < 1 then
			DarkRP.notify(calling_ply, 1, 4, "Наборные администраторы не найдены")
			return
		end

		for k, man in ipairs(adms) do
			if not IsValid(man) then continue end
			man:changeTeam(TEAM_ADMIN, true)
			DarkRP.notify(man, 2, 10, "Администраторов недостаточно!")
			DarkRP.notify(calling_ply, 0, 4, man:Name() .. " был перемещен в админ профу")
		end

		AN("Заставил наборных работать", calling_ply)
	end)
end
local setadmin = ulx.command(CATEGORY_NAME, "ulx setadmin", ulx.setadmin, "!setadmin")
setadmin:defaultAccess(ULib.ACCESS_SUPERADMIN)
setadmin:help("Заставить наборных работать")

function ulx.setmyname(calling_ply, text)
	local force = groups_allow_default[calling_ply:GetUserGroup()] or calling_ply:IsSuperAdmin()
	local allowed = force or calling_ply:GetNetVar("cats.AllowMask")

	if not allowed then
		ULib.tsayError(calling_ply, "Недостаточно жалоб за месяц", true)
		return
	end

	text = text or ""
	calling_ply:setDarkRPVar("rpname", text)
	DarkRP.notify(calling_ply, 2, 4, "Вы изменили своё имя")
end

local setmyname = ulx.command("Mask", "ulx setmyname", ulx.setmyname, "!setmyname")
setmyname:addParam{
	type = ULib.cmds.StringArg,
	hint = "Имя",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
setmyname:defaultAccess(ULib.ACCESS_SUPERADMIN)
setmyname:help("Установка себе имени")

function ulx.setfakegroup(calling_ply, text)
	local force = groups_allow_default[calling_ply:GetUserGroup()] or calling_ply:IsSuperAdmin()
	local allowed = force or calling_ply:GetNetVar("cats.AllowMask")

	if not allowed then
		ULib.tsayError(calling_ply, "Недостаточно жалоб за месяц", true)
		return
	end

	text = text or "vip"

	if not groups_mask[text] and not force then
		ULib.tsayError(calling_ply, "Недопустимая привилегия", true)
		return
	end

	calling_ply:SetNetVar("FakeGroup", text)
	DarkRP.notify(calling_ply, 2, 4, "Маскировка группы активна")
end
local setfakegroup = ulx.command("Mask", "ulx setfakegroup", ulx.setfakegroup, "!setfakegroup")
setfakegroup:addParam{
	type = ULib.cmds.StringArg,
	hint = "Группа",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
setfakegroup:defaultAccess(ULib.ACCESS_SUPERADMIN)
setfakegroup:help("Установка группы. Для отключения поставьте пустую")

function ulx.mask(calling_ply, unmask)
	local force = groups_allow_default[calling_ply:GetUserGroup()] or calling_ply:IsSuperAdmin()
	local allowed = force or calling_ply:GetNetVar("cats.AllowMask")
	if not allowed then
		ULib.tsayError(calling_ply, "Недостаточно жалоб за месяц", true)
		return
	end

	if not unmask then
		calling_ply:SetNetVar("FakePlayer", true)
		DarkRP.notify(calling_ply, 2, 4, "Маскировка под человека в табе активна")
	else
		calling_ply:SetNetVar("FakePlayer", nil)
		calling_ply:SetNetVar("FakeSteamID", nil)
		calling_ply:SetNetVar("FakeGroup", nil)
		calling_ply:SetNetVar("MaskMe", nil)
		DarkRP.notify(calling_ply, 2, 4, "Маскировка отключена")
	end
end
local mask = ulx.command("Mask", "ulx mask", ulx.mask, "!mask")
mask:addParam{
	type = ULib.cmds.BoolArg,
	invisible = true
}
mask:defaultAccess(ULib.ACCESS_SUPERADMIN)
mask:help("Маскировка в табе")
mask:setOpposite("ulx unmask", {_, true}, "!unmask")

function ulx.maskid(calling_ply)
	local force = groups_allow_default[calling_ply:GetUserGroup()] or calling_ply:IsSuperAdmin()
	local allowed = force or calling_ply:GetNetVar("cats.AllowNiceMask")
	if not allowed then
		ULib.tsayError(calling_ply, "Недостаточно жалоб за месяц", true)
		return
	end

	-- calling_ply:GenerateCID(5, true)
	calling_ply:RandomizeCID(5)
	calling_ply:UpdateJobCode()
	DarkRP.notify(calling_ply, 2, 4, "Применён новый CID")
end
local maskid = ulx.command("Mask", "ulx maskid", ulx.maskid, "!maskid")
maskid:defaultAccess(ULib.ACCESS_SUPERADMIN)
maskid:help("Изменяет Citizen ID в табе и профе")

function ulx.smask(calling_ply)
	local force = groups_allow_default[calling_ply:GetUserGroup()] or calling_ply:IsSuperAdmin()
	local allowed = force or calling_ply:GetNetVar("cats.AllowMask") and calling_ply:Team() == TEAM_ADMIN
	if not allowed then
		ULib.tsayError(calling_ply, "Недостаточно жалоб за месяц", true)
		return
	end

	calling_ply:SetNetVar("MaskMe", true)
	DarkRP.notify(calling_ply, 2, 4, "Вы пропали из таба")
end
local smask = ulx.command("Mask", "ulx smask", ulx.smask, "!smask")
smask:defaultAccess(ULib.ACCESS_SUPERADMIN)
smask:help("Полностью убирает из таба")
if SERVER then
	hook.Add("OnPlayerChangedTeam", "Mask.Disable", function(ply)
		local force_admin = groups_allow_default[ply:GetUserGroup()] or ply:IsSuperAdmin()
		if force_admin then return end

		if ply:GetNetVar("MaskMe") then
			ply:SetNetVar("MaskMe", false)
		end
	end)
end

function ulx.nonotify(calling_ply)
	local force = groups_allow_default[calling_ply:GetUserGroup()] or calling_ply:IsSuperAdmin()
	local allowed = force or calling_ply:GetNetVar("cats.AllowNiceMask")

	if not allowed then
		ULib.tsayError(calling_ply, "Недостаточно жалоб за месяц", true)
		return
	end

	if not calling_ply:GetNetVar("HideCMDS") then
		calling_ply:SetNetVar("HideCMDS", true)
		DarkRP.notify(calling_ply, 2, 4, "Теперь действия с ulx будут скрыты")
	else
		calling_ply:SetNetVar("HideCMDS", nil)
		DarkRP.notify(calling_ply, 2, 4, "Теперь действия с ulx будут видны")
	end
end
local nonotify = ulx.command("Mask", "ulx not", ulx.nonotify, "!not", false, false, true)
nonotify:defaultAccess(ULib.ACCESS_SUPERADMIN)
nonotify:help("Скрытие действий")

function ulx.stopcodes(calling_ply, reason)
	reason = reason == "" and "Без причины" or reason
	ulx.fancyLogAdmin(calling_ply, "#A отключил активные коды (#s)", reason)
	DarkRP.StopCodes()
end
local stopcodes = ulx.command(CATEGORY_NAME, "ulx stopcodes", ulx.stopcodes, "!stopcodes")
stopcodes:addParam{
	type = ULib.cmds.StringArg,
	hint = "Причина",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
stopcodes:defaultAccess(ULib.ACCESS_SUPERADMIN)
stopcodes:help("Остановка активных кодов")

function ulx.freezeprops(calling_ply)
	ulx.fancyLogAdmin(calling_ply, "#A заморозил все предметы")
	for k, v in ents.Iterator() do
		if IsValid(v:GetPhysicsObject()) and not v:IsNPC() then
			v:GetPhysicsObject():EnableMotion(false)
		end
	end
end
local freezeprops = ulx.command(CATEGORY_NAME, "ulx freezeprops", ulx.freezeprops, "!freezeprops")
freezeprops:defaultAccess(ULib.ACCESS_SUPERADMIN)
freezeprops:help("Заморозка всего")

function ulx.administrate(calling_ply)
	if not calling_ply:Alive() then
		ULib.tsayError(calling_ply, "Вы мертвы", true)
		return
	end

	if calling_ply:isArrested() then
		ULib.tsayError(calling_ply, "Вы арестованы", true)
		return
	end

	if calling_ply:Team() ~= TEAM_ADMIN then
		local job = calling_ply:Team()
		local lives = calling_ply:GetNetVar("lives")
		calling_ply:changeTeam(TEAM_ADMIN, true)
		calling_ply.oldteam = job
		calling_ply.oldlives = lives
	else
		local oldTeam = calling_ply.oldteam
		if oldTeam then
			local jobTable = RPExtraTeams[oldTeam]
			local max = jobTable.max == nil and 0 or jobTable.max == 0 and 100 or jobTable.max

			local customCheck = jobTable.customCheck
			local canChange = customCheck == nil or customCheck(ply)
			if canChange and team.NumPlayers(oldTeam) < max then
				calling_ply:changeTeam(oldTeam, true)
				calling_ply.oldteam = nil
				calling_ply:SetLocalVar("lives", calling_ply.oldlives)
				calling_ply.oldlives = nil
				return
			end
		end

		calling_ply.oldteam = nil
		calling_ply.oldlives = nil
		calling_ply:changeTeam(TEAM_CITIZEN1, true)

		DarkRP.notify(calling_ply, 1, 4, "Был превышен лимит игроков на профессии или её нельзя брать сейчас.")
	end
end
local administrate = ulx.command(CATEGORY_NAME, "ulx administrate", ulx.administrate, {"!administrate", "!adm"})
administrate:defaultAccess(ULib.ACCESS_ADMIN)
administrate:help("Вход в режим администрации.")

function ulx.uncuff(calling_ply, target_ply, reason)
	if target_ply:GetNW2Bool("Jailed") then
		ULib.tsayError(calling_ply, "Данный игрок находится в тюрьме", true)
		return
	end

	if not reason or reason == "" then
		reason = "Без причины"
	end

	ulx.fancyLogAdmin(calling_ply, "#A убрал из наручников #T (#s)", target_ply, reason)

	if target_ply:GetNW2Bool("JSEscorted", false) then
		PolSys.resetColls(target_ply)
		PolSys.resetEscort(target_ply:GetNW2Entity("JSEscortCop"))
	end

	if target_ply:GetNW2Bool("JSEscorting", false) then
		PolSys.resetColls(target_ply:GetNW2Entity("JSEscortPerp"))
		PolSys.resetEscort(target_ply)
	end

	if target_ply:GetNW2Bool("JSRestrained", false) then
		PolSys.unrestrainPly(target_ply, false)
	end
end
local uncuff = ulx.command(CATEGORY_NAME, "ulx uncuff", ulx.uncuff, "!uncuff")
uncuff:addParam{
	type = ULib.cmds.PlayerArg
}
uncuff:addParam{
	type = ULib.cmds.StringArg,
	hint = "Причина",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
uncuff:defaultAccess(ULib.ACCESS_ADMIN)
uncuff:help("Снять наручники")

function ulx.generatename(calling_ply, target_ply, reason)
	if target_ply:GetNW2Bool("Jailed") then
		ULib.tsayError(calling_ply, "Данный игрок находится в тюрьме", true)
		return
	end

	if not reason or reason == "" then
		reason = "Без причины"
	end

	ulx.fancyLogAdmin(calling_ply, "#A изменил имя #T (#s)", target_ply, reason)
	GenerateName(target_ply)
end
local generatename = ulx.command(CATEGORY_NAME, "ulx generatename", ulx.generatename, "!generatename")
generatename:addParam{
	type = ULib.cmds.PlayerArg
}
generatename:addParam{
	type = ULib.cmds.StringArg,
	hint = "Причина",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
generatename:defaultAccess(ULib.ACCESS_ADMIN)
generatename:help("Генерация ника игроку")

function ulx.kick(calling_ply, target_ply, reason)
	if target_ply:IsListenServerHost() then
		ULib.tsayError(calling_ply, "This player is immune to kicking", true)
		return
	end

	if target_ply:GetNW2Bool("Jailed") then
		ULib.tsayError(calling_ply, "Данный игрок находится в тюрьме", true)
		return
	end

	if reason and reason ~= "" then
		ulx.fancyLogAdmin(calling_ply, "#A kicked #T (#s)", target_ply, reason)
	else
		reason = nil
		ulx.fancyLogAdmin(calling_ply, "#A kicked #T", target_ply)
	end

	-- Delay by 1 frame to ensure the chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall(ULib.kick, target_ply, reason, calling_ply)
end
local kick = ulx.command(CATEGORY_NAME, "ulx kick", ulx.kick, "!kick")
kick:addParam{
	type = ULib.cmds.PlayerArg
}
kick:addParam{
	type = ULib.cmds.StringArg,
	hint = "reason",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes = ulx.common_kick_reasons
}
kick:defaultAccess(ULib.ACCESS_ADMIN)
kick:help("Kicks target.")

------------------------------ Ban ------------------------------
function ulx.ban(calling_ply, target_ply, minutes, reason)
	if target_ply:IsListenServerHost() or target_ply:IsBot() then
		ULib.tsayError(calling_ply, "This player is immune to banning", true)
		return
	end

	if target_ply:GetNW2Bool("Jailed") then
		target_ply:SetNW2Bool("Jailed", false)
	end

	local time = "на #s"
	if minutes == 0 then
		time = "навсегда"
	end

	local str = "#A забанил #T " .. time
	if reason and reason ~= "" then
		str = str .. " (#s)"
	end

	ulx.fancyLogAdmin(calling_ply, str, target_ply, minutes ~= 0 and util.TimeToStr(minutes * 60) or reason, reason)
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall(ULib.kickban, target_ply, minutes, reason, calling_ply)

	if IsValid(calling_ply) then
		calling_ply:addStat("bans")
	end
end
local ban = ulx.command(CATEGORY_NAME, "ulx ban", ulx.ban, "!ban", false, false, true)
ban:addParam{
	type = ULib.cmds.PlayerArg
}
ban:addParam{
	type = ULib.cmds.NumArg,
	hint = "minutes, 0 for perma",
	ULib.cmds.optional, ULib.cmds.allowTimeString, min = 0
}
ban:addParam{
	type = ULib.cmds.StringArg,
	hint = "reason",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes = ulx.common_kick_reasons
}
ban:defaultAccess(ULib.ACCESS_ADMIN)
ban:help("Bans target.")

function ulx.banip(calling_ply, target_ply, minutes, reason)
	if target_ply:IsListenServerHost() or target_ply:IsBot() then
		ULib.tsayError(calling_ply, "This player is immune to banning", true)
		return
	end

	local ip = target_ply:IPAddress()
	local time = "на #s"

	if minutes == 0 then
		time = "навсегда"
	end

	local str = "#A забанил #T " .. time

	if reason and reason ~= "" then
		str = str .. " (#s)"
	end

	if ip then
		RunConsoleCommand("addip", "0", ip)
	end

	AN("Получил бан ip: " .. ip, target_ply)
	ulx.fancyLogAdmin(calling_ply, str, target_ply, minutes ~= 0 and util.TimeToStr(minutes * 60) or reason, reason)
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall(ULib.kickban, target_ply, minutes, reason, calling_ply)
end
local banip = ulx.command(CATEGORY_NAME, "ulx banip", ulx.banip, "!banip", false, false, true)
banip:addParam{
	type = ULib.cmds.PlayerArg
}
banip:addParam{
	type = ULib.cmds.NumArg,
	hint = "minutes, 0 for perma",
	ULib.cmds.optional, ULib.cmds.allowTimeString, min = 0
}
banip:addParam{
	type = ULib.cmds.StringArg,
	hint = "reason",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes = ulx.common_kick_reasons
}
banip:defaultAccess(ULib.ACCESS_SUPERADMIN)
banip:help("Bans target.")

function ulx.fakeban(calling_ply, target_ply, minutes, reason)
	if target_ply:IsListenServerHost() or target_ply:IsBot() then
		ULib.tsayError(calling_ply, "This player is immune to banning", true)
		return
	end

	local time = "на #s"

	if minutes == 0 then
		time = "навсегда"
	end

	local str = "#A забанил #T " .. time

	if reason and reason ~= "" then
		str = str .. " (#s)"
	end

	ulx.fancyLogAdmin(calling_ply, str, target_ply, minutes ~= 0 and util.TimeToStr(minutes * 60) or reason, reason)
end
local fakeban = ulx.command(CATEGORY_NAME, "ulx fakeban", ulx.fakeban, "!fakeban", false, false, true)
fakeban:addParam{
	type = ULib.cmds.PlayerArg
}
fakeban:addParam{
	type = ULib.cmds.NumArg,
	hint = "minutes, 0 for perma",
	ULib.cmds.optional, ULib.cmds.allowTimeString, min = 0
}
fakeban:addParam{
	type = ULib.cmds.StringArg,
	hint = "reason",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes = ulx.common_kick_reasons
}
fakeban:defaultAccess(ULib.ACCESS_SUPERADMIN)
fakeban:help("Bans target.")


function ulx.screengrabber(ply, pl, method, quality)
	local plName = pl:Name()
	SCR.RequestAndUpload(pl, function(url)
		if not IsValid(pl) then
			return false
		end

		net.Start("OpenURL")
		net.WriteString("https://unionrp.info/hl2rp/mine_shit/proxy.php?url=" .. url)
		net.WriteString("Скриншот игрока " .. plName)
		net.Send(ply)
	end, function()
		ply:ChatPrint(plName .. " не отправил скриншот, либо получил ошибку")
	end, "Скриншот игрока " .. plName)
end
local screengrabber = ulx.command("AntiCheat", "ulx sg", ulx.screengrabber, {"!screengrabber", "!sg"}, false, false, true)
screengrabber:addParam{
	type = ULib.cmds.PlayerArg
}
screengrabber:addParam{
	type = ULib.cmds.NumArg,
	min = 1,
	max = 5,
	default = 1,
	hint = "Метод скринграбба",
	ULib.cmds.round, ULib.cmds.optional
}
screengrabber:addParam{
	type = ULib.cmds.NumArg,
	min = 20,
	max = 100,
	default = 35,
	hint = "Качество скринграбба",
	ULib.cmds.round, ULib.cmds.optional
}
screengrabber:defaultAccess(ULib.ACCESS_SUPERADMIN)
screengrabber:help("Сделать скрин	")

------------------------------ BanID ------------------------------
------------------------------ BanID ------------------------------
function ulx.banid(calling_ply, steamid, minutes, reason)
	steamid = steamid:upper()

	if not ULib.isValidSteamID(steamid) then
		ULib.tsayError(calling_ply, "Неправильный SteamID.")

		return
	end

	if IsValid(calling_ply) and not calling_ply:IsSuperAdmin() and ULib.bans[steamid] then
		ULib.tsayError(calling_ply, "Игрок уже находится в бан-листе", true)
		return
	end

	local target_ply
	local plys = player.GetAll()
	local plys_count = player.GetCount()
	for i = 1, plys_count do
		local v = plys[i]
		if v:SteamID() == steamid then
			ulx.ban(calling_ply, v, minutes, reason)
			return
		end
	end

	local time = "на #s"
	if minutes == 0 then
		time = "навсегда"
	end

	local str = "#A забанил SteamID #s "
	local displayid = steamid
	str = str .. time
	if reason and reason ~= "" then
		str = str .. " (#4s)"
	end

	ulx.fancyLogAdmin(calling_ply, str, displayid, minutes ~= 0 and util.TimeToStr(minutes * 60) or reason, reason)
	-- Delay by 1 frame to ensure any chat hook finishes with player intact. Prevents a crash.
	ULib.queueFunctionCall(ULib.addBan, steamid, minutes, reason, name, calling_ply)
end
local banid = ulx.command(CATEGORY_NAME, "ulx banid", ulx.banid, nil, false, false, true)
banid:addParam{
	type = ULib.cmds.StringArg,
	hint = "steamid"
}
banid:addParam{
	type = ULib.cmds.NumArg,
	hint = "minutes, 0 for perma",
	ULib.cmds.optional, ULib.cmds.allowTimeString, min = 0
}
banid:addParam{
	type = ULib.cmds.StringArg,
	hint = "reason",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine, completes = ulx.common_kick_reasons
}
banid:defaultAccess(ULib.ACCESS_SUPERADMIN)
banid:help("Bans steamid.")

function ulx.baninfo(calling_ply, steamid)
	steamid = steamid:upper()

	if not steamid:IsSteamID() then
		ULib.tsayError(calling_ply, "Неверный SteamID / Игрок не найден")
		return
	end

	local ban = ULib.bans[steamid]
	if not ban then
		ULib.tsayError(calling_ply, "Игрок не находится в бан-листе", true)
		return
	end

	local admin = ban.admin
	local reason = ban.reason
	local hours = ban.unban == "0" and "Парочка столетий" or (ban.unban - ban.time) / 60 / 60 .. "ч"
	local when = os.date("%H:%M:%S - %d/%m/%Y", ban.time)
	local unban = ban.unban == "0" and "Чуть больше вечности" or os.date("%H:%M:%S - %d/%m/%Y", ban.unban)

	if IsValid(calling_ply) then
		calling_ply:ChatAddText(col.o, "[Информация о бане " .. steamid .. " ]", col.w, string.format("\nЗабанил: %s \nПричина: %s \nПродолжительность: %s \nДата: %s \nРазбан: %s", admin, reason, hours, when, unban))
	else
		print(string.format("\nЗабанил: %s \nПричина: %s \nПродолжительность: %s \nДата: %s \nРазбан: %s \n", admin, reason, hours, when, unban))
	end
end
local baninfo = ulx.command(CATEGORY_NAME, "ulx baninfo", ulx.baninfo, nil, false, false, true)
baninfo:addParam{
	type = ULib.cmds.StringArg,
	hint = "steamid"
}
baninfo:defaultAccess(ULib.ACCESS_SUPERADMIN)
baninfo:help("Информация о бане игрока по SteamID")

function ulx.unban(calling_ply, steamid)
	steamid = steamid:upper()

	if not steamid:IsSteamID() then
		ULib.tsayError(calling_ply, "Invalid steamid.")
		return
	end

	name = ULib.bans[steamid] and ULib.bans[steamid].name
	ULib.unban(steamid, calling_ply)

	if name then
		ulx.fancyLogAdmin(calling_ply, "#A разбанил #s", steamid .. " (" .. name .. ")")
	else
		ulx.fancyLogAdmin(calling_ply, "#A разбанил #s", steamid)
	end
end
local unban = ulx.command(CATEGORY_NAME, "ulx unban", ulx.unban, nil, false, false, true)
unban:addParam{
	type = ULib.cmds.StringArg,
	hint = "steamid"
}
unban:defaultAccess(ULib.ACCESS_ADMIN)
unban:help("Unbans steamid.")

function ulx.unbanid(calling_ply, steamid)
	if calling_ply:GetNW2Int("SlowDown") > CurTime() then
		calling_ply:ChatPrint("Не так быстро")
		return
	end

	calling_ply:SetNW2Int("SlowDown", CurTime() + 5)
	steamid = steamid:upper()

	if not steamid:IsSteamID() then
		ULib.tsayError(calling_ply, "Неверный SteamID")
		return
	end

	if not ULib.bans[steamid] then
		calling_ply:ChatPrint("SteamID не найден в банах")
		return
	end

	if not ULib.bans[steamid].admin or not ULib.bans[steamid].admin:find(calling_ply:SteamID()) then
		calling_ply:ChatPrint("SteamID не найден в ваших банах")
		return
	end

	name = ULib.bans[steamid] and ULib.bans[steamid].name
	ULib.unban(steamid, calling_ply)

	if name then
		ulx.fancyLogAdmin(calling_ply, "#A разбанил #s", steamid .. " (" .. name .. ")")
	else
		ulx.fancyLogAdmin(calling_ply, "#A разбанил #s", steamid)
	end
end
local unbanid = ulx.command(CATEGORY_NAME, "ulx unbanid", ulx.unbanid, nil, false, false, true)
unbanid:addParam{
	type = ULib.cmds.StringArg,
	hint = "steamid"
}
unbanid:defaultAccess(ULib.ACCESS_ADMIN)
unbanid:help("Разбан человека при ошибочном бане")

------------------------------ Noclip ------------------------------
function ulx.noclip(calling_ply)
	calling_ply:Kick("unbind ulx noclip")
end
local noclip = ulx.command(CATEGORY_NAME, "ulx noclip", ulx.noclip, "!noclip")
noclip:addParam{
	type = ULib.cmds.PlayerArg,
	ULib.cmds.optional
}
noclip:defaultAccess(ULib.ACCESS_ADMIN)
noclip:help("Toggles noclip on target(s).")

function ulx.addForcedDownload(path)
	if ULib.fileIsDir(path) then
		files = ULib.filesInDir(path)

		for _, v in ipairs(files) do
			ulx.addForcedDownload(path .. "/" .. v)
		end
	elseif ULib.fileExists(path) then
		resource.AddFile(path)
	else
		Msg("[ULX] ERROR: Tried to add nonexistent or empty file to forced downloads '" .. path .. "'\n")
	end
end

-- This cvar also exists in DarkRP (thanks, FPtje)
local cl_cvar_pickup = "cl_pickupplayers"
if CLIENT then
	CreateClientConVar(cl_cvar_pickup, "1", true, true)
end

local function playerPickup(ply, ent)
	local access, tag = ULib.ucl.query(ply, "ulx physgunplayer")

	if ent:GetClass() == "player" and ULib.isSandbox() and access and not ent.NoNoclip and not ent.frozen and ply:GetInfoNum(cl_cvar_pickup, 1) == 1 then
		-- Extra restrictions! UCL wasn't designed to handle this sort of thing so we're putting it in by hand...
		local restrictions = {}
		ULib.cmds.PlayerArg.processRestrictions(restrictions, ply, {}, tag and ULib.splitArgs(tag)[1])
		if restrictions.restrictedTargets == false or restrictions.restrictedTargets and not table.HasValue(restrictions.restrictedTargets, ent) then return end
		ent:SetMoveType(MOVETYPE_NONE) -- So they don't bounce

		return true
	end
end
hook.Add("PhysgunPickup", "ulxPlayerPickup", playerPickup, HOOK_HIGH) -- Allow admins to move players. Call before the prop protection hook.

if SERVER then
	ULib.ucl.registerAccess("ulx physgunplayer", ULib.ACCESS_ADMIN, "Ability to physgun other players", "Other")
end

local function playerDrop(ply, ent)
	if ent:GetClass() == "player" then
		ent:SetMoveType(MOVETYPE_WALK)
	end
end
hook.Add("PhysgunDrop", "ulxPlayerDrop", playerDrop)

function ulx.jailroom(ply, target, seconds, reason, unjail)
	if unjail == false then
		if target:GetNW2Bool("Jailed") then
			ULib.tsayError(ply, "Данный игрок находится в тюрьме", true)
			return
		end

		if not reason or reason == "" then
			AN(ply:Name() .. " использовал джаил без причины")
			print(ply, "Укажите причину")
			ULib.tsayError(ply, "Укажите причину")
			return
		end

		JailRoom(target, seconds)
		target:SetNW2String("JailedBySID", ply:SteamID())
		target:SetNW2String("JailedByName", ply:Name())
		target:SetNW2String("JailReason", reason)
		ply:addStat("jails")

		local str = "#A посадил #T в тюрьму на #s. Причина: #s"
		ulx.fancyLogAdmin(ply, str, target, util.TimeToStr(seconds), reason)
	else
		if not target:GetNW2Bool("Jailed") then
			ULib.tsayError(ply, "Данный игрок не находится в тюрьме", true)
			return
		end

		local str = "#A вытащил игрока #T из тюрьмы"
		ulx.fancyLogAdmin(ply, str, target)
		UnJail(target)
	end
end
local jailroom = ulx.command(CATEGORY_NAME, "ulx jail", ulx.jailroom, "!jail")
jailroom:addParam{
	type = ULib.cmds.PlayerArg
}
jailroom:addParam{
	type = ULib.cmds.NumArg,
	min = 0,
	default = 0,
	hint = "Секунды",
	ULib.cmds.round, ULib.cmds.optional
}
jailroom:addParam{
	type = ULib.cmds.StringArg,
	hint = "Причина",
	ULib.cmds.optional, ULib.cmds.takeRestOfLine
}
jailroom:addParam{
	type = ULib.cmds.BoolArg,
	invisible = true
}
jailroom:defaultAccess(ULib.ACCESS_ADMIN)
jailroom:help("Отправляет игрока в админскую тюрьму и сама позже выпускает ")
jailroom:setOpposite("ulx unjail", {_, _, _, _, true}, "!unjail")

--local jail_pos = Vector(1247.516235, 159.190598, -686.718750)
local jail_pos = Vector(-9697.7626953125, 10164.071289062, 2964.03125)
function JailRoom(ply, seconds)
	if ply:GetNW2Bool("Jailed") then return end
	ulx.freeze(NULL, ply, true, true)

	if ply:InVehicle() then
		ply.ErrorChessGame = true
		ply:ExitVehicle()
	end

	ply:changeTeam(TEAM_CITIZEN, true)
	ply:SetNW2Int("jailtime", CurTime() + seconds)
	ply:SetNW2Bool("Jailed", true)
	ply:Spawn()
	ply:SetPos(jail_pos)
	ply:StripWeapons()

	local timeID = ply:UniqueID() .. "ulxJailTimer"
	if timer.Exists(timeID) then
		timer.Remove(timeID)
	end

	timer.Create(timeID, seconds, 1, function()
		if ply:IsValid() then
			UnJail(ply, true)
		elseif ply:IsValid() then
			UnJail(ply)
		end
	end)

	if sv_PProtect then
		local uid = ply:SteamID()
		local _list = sv_PProtect.CollectEntities[uid]

		for i = 1, _list:Size() do
			local ent = _list[i]
			SafeRemoveEntity(ent)
		end

		_list:Clear()
	end
	-- if DarkRP then -- не нужно, т.к. есть в DarkRP при changeTeam.
	-- 	local uid = ply:UserID()
	-- 	local _list = DarkRP.CollectEntities[uid]
	-- 	for i = 1, _list:Size() do
	-- 		local ent = _list[i]
	-- 		SafeRemoveEntity(ent)
	-- 	end
	-- 	_list:Clear()
	-- end

	hook.Run("PlayerJailed", ply, seconds)
end

function UnJail(ply)
	if not ply:GetNW2Bool("Jailed") then return end

	ply:SetNW2Int("jailtime", 0)
	ply:SetNW2Bool("Jailed", false)
	timer.Remove(ply:UniqueID() .. "ulxJailTimer")
	ply:KillSilent()
	DarkRP.notify(ply, 2, 8, "Вы были выпущены из тюрьмы")

	hook.Run("PlayerUnjailed", ply)
end

hook.Add("PlayerSpawn", "ulxSpawnInJailIfDead", function(ply)
	if ply:GetNW2Bool("Jailed") then
		timer.Simple(1, function()
			ply:SetPos(jail_pos)
		end)
	end
end)

local function NoForJail(ply)
	if ply:GetNW2Bool("Jailed") then return false end
end

hook.Add("CanPlayerSuicide", "ulxSuicedeCheck", NoForJail)
hook.Add("PlayerSpawnProp", "ulxBlockSpawnIfInJail", NoForJail)
hook.Add("PlayerCanPickupWeapon", "ulxJailPickUpWeapon", NoForJail)
hook.Add("PlayerCanPickupItem", "ulxPickUpRest", NoForJail)
----------- ДАРКРП ХУЕТА -----------------
hook.Add("canAdvert", "ulxPickUpRest", NoForJail)
hook.Add("canBuyAmmo", "ulxPickUpRest", NoForJail)
hook.Add("canBuyCustomEntity", "ulxPickUpRest", NoForJail)
hook.Add("canBuyPistol", "ulxPickUpRest", NoForJail)
hook.Add("canBuyShipment", "ulxPickUpRest", NoForJail)
hook.Add("canBuyVehicle", "ulxPickUpRest", NoForJail)
hook.Add("canChangeJob", "ulxPickUpRest", NoForJail)
hook.Add("CanChangeRPName", "ulxPickUpRest", NoForJail)
hook.Add("canChatSound", "ulxPickUpRest", NoForJail)
hook.Add("playerCanChangeTeam", "ulxPickUpRest", NoForJail)
hook.Add("canPocket", "ulxPickUpRest", NoForJail)

------------------------------------------
if SERVER then
	_G.JailDiscPlys = JailDiscPlys or {}
	local disc_plys = JailDiscPlys

	hook.Add("PlayerDisconnected", "ulxJailDisconnected", function(ply)
		if ply:GetNW2Bool("Jailed") then
			local admin_name = ply:GetNW2String("JailedByName")
			local admin_sid = ply:GetNW2String("JailedBySID")
			local ply_sid = ply:SteamID()
			local ply_name = ply:Name()
			local reason = ply:GetNW2String("JailReason")
			local jail_time = ply:GetNW2Int("jailtime") - CurTime()
			if jail_time <= 0 then return end

			disc_plys[ply_sid] = {
				admin_name = admin_name,
				admin_sid = admin_sid,
				reason = reason,
				jail_time = jail_time
			}

			timer.Create("jail_disconnected_" .. ply:SteamID64(), 300, 1, function()
				if ULib.bans[ply_sid] then return end

				if disc_plys[ply_sid] then
					local admin_sid64, ply_sid64 = util.SteamIDTo64(admin_sid), util.SteamIDTo64(ply_sid)
					local text = "<b>🦹 Данные:</b> " .. TLG.MarkdownURL(ply_name, "https://steamcommunity.com/profiles/" .. ply_sid64, "html") .. "(<code>" .. ply_sid .. "</code>)" .. "\n" .. "<b>👮 Выдал: </b>" .. TLG.MarkdownURL(admin_name, "https://steamcommunity.com/profiles/" .. admin_sid64, "html") .. "(<code>" .. admin_sid .. "</code>)" .. "\n" .. "<b>🔣 Причина:</b> <code>" .. reason .. "</code>"
					AN(text, nil, "🔨 Автовыдача наказания", "html")
					-- RunConsoleCommand("ulx", "banid", ply_sid, "666", reason .. " + выход во время наказания.")
					reason = reason .. " + выход во время наказания."
					ULib.addBan(ply_sid, 666, reason, nil, admin_sid)
					disc_plys[ply_sid] = nil
				end
			end)
		end
	end)

	function JailRoomDisc(ply, info)
		local jail_time = info.jail_time
		local admin_name = info.admin_name
		local admin_sid = info.admin_sid
		local reason = info.reason
		ply:SetNW2String("JailedByName", admin_name)
		ply:SetNW2String("JailedBySID", admin_sid)
		ply:SetNW2String("JailReason", reason)
		disc_plys[ply:SteamID()] = nil
		JailRoom(ply, jail_time)
	end

	-- Нужно заменить на подобие PlayerInitialized при первом спавне.
	hook.Add("PlayerSpawn", "ulxInitialSpawn", function(ply)
		local tbl = disc_plys[ply:SteamID()]
		if not tbl then return end
		JailRoomDisc(ply, tbl)
	end)

	hook.Add("PlayerDisconnected", "_CuffsFuckup", function(ply)
		if ply:Alive() and ply:IsHandcuffed() then
			disc_plys[ply:SteamID()] = {
				admin_name = "Сервер",
				admin_sid = "STEAM_0:0:1",
				reason = "Релог с сервера в наручниках.",
				jail_time = 900
			}
		end
	end)

	hook.Add("ULib.addBan", "removeBanFromDiscList", function(steamid)
		timer.Simple(1, function()
			if disc_plys[steamid] then
				disc_plys[steamid] = nil
			end
		end)
	end)
end

if CLIENT then
	hook.Add("HUDPaint", "JailInfo", function()
		local ply = LocalPlayer()
		if not ply:GetNW2Bool("Jailed") then return end
		local time = math.floor(ply:GetNW2Int("jailtime") - CurTime())
		local text, timetext = "Вы попали в тюрьму: " .. ply:GetNW2String("JailReason"), "Осталось " .. time .. "сек"
		surface.SetFont("pd2_assault_text")
		local x, y = ScrW() * 0.5, 100
		local w, h = surface.GetTextSize(text)
		local w2, h2 = surface.GetTextSize(timetext)
		draw.RoundedBox(0, x - (w + 60) / 2, y, w + 61, 40, col.ba)
		draw.DrawText(text, "pd2_assault_text", x, y + 3, color_white, TEXT_ALIGN_CENTER)
		draw.RoundedBox(0, x - (w2 + 30) / 2, y + 40, w2 + 31, 40, col.ba)
		draw.DrawText(timetext, "pd2_assault_text", x, y + 43, color_white, TEXT_ALIGN_CENTER)
		surface.SetMaterial(Material("icon16/lock.png"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x - w / 2 - 20, y + 11, 16, 16)
		surface.SetMaterial(Material("icon16/lock.png"))
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(x + w / 2 + 5, y + 11, 16, 16)
	end)

	WebMats = WebMats or {}

	if not file.Exists("webtextures", "DATA") then
		file.CreateDir("webtextures")
	end

	function WebMats:Fetch(url, flags, callback)
		local uid = util.CRC(url) .. ".png"
		local iMat

		if file.Exists("webtextures/" .. uid, "DATA") then
			iMat = Material("../data/webtextures/" .. uid, flags)

			if callback then
				callback(iMat)
			end

			return iMat
		end

		http.Fetch(url, function(body, len, headers, code)
			file.Write("webtextures/" .. uid, body)
			iMat = Material("../data/webtextures/" .. uid, flags)

			if callback then
				callback(iMat)
			end

			return iMat
		end)
	end

	net.Receive("OpenURL", function()
		local url = net.ReadString() or "https://wiki.garrysmod.com"
		local desc = net.ReadString() or ""
		local frame = vgui.Create( "DFrame" )
		frame:SetTitle( desc )
		frame:SetSize( ScrW() * 0.75, ScrH() * 0.75 )
		frame:Center()
		frame:MakePopup()

		local html = vgui.Create( "HTML", frame )
		html:Dock( FILL )
		html:OpenURL( url )
		html:Center()
	end)
end