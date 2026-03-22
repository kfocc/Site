local CATEGORY_NAME = "DarkRP"

function ulx.addMoney( calling_ply, target_ply, amount )
	target_ply:addMoney(amount)
	ulx.fancyLogAdmin( calling_ply, "#A gave #T $#i", target_ply, amount )
end
local addMoney = ulx.command( CATEGORY_NAME, "ulx addmoney", ulx.addMoney, "!addmoney" )
addMoney:addParam{ type=ULib.cmds.PlayerArg }
addMoney:addParam{ type=ULib.cmds.NumArg, hint="money" }
addMoney:defaultAccess( ULib.ACCESS_ADMIN )
addMoney:help( "Adds money to players DarkRP wallet." )


function ulx.setName(calling_ply, target_ply, name)
	name = utf8.force(name)
	local len = utf8.len(name)
	if not DarkRP.checkRPName(name) then
		DarkRP.notify(calling_ply, 1, 4, "Недопустимое имя")
		return
	end

	if len < GAMEMODE.Config.minPlayerNameLength then
		DarkRP.notify(calling_ply, 1, 4, DarkRP.getPhrase("too_short"))
		return
	end

	if len > GAMEMODE.Config.maxPlayerNameLength then
		DarkRP.notify(calling_ply, 1, 4, DarkRP.getPhrase("too_long"))
		return
	end

	target_ply:SetNW2Bool("ChangedName", false)

	ulx.fancyLogAdmin(calling_ply, "#A установил #T имя #s", target_ply, name)
	target_ply:setRPName(name)
end

local setName = ulx.command(CATEGORY_NAME, "ulx setname", ulx.setName, "!setname")
setName:addParam{ type=ULib.cmds.PlayerArg }
setName:addParam{ type=ULib.cmds.StringArg, hint="new name", ULib.cmds.takeRestOfLine }
setName:defaultAccess( ULib.ACCESS_ADMIN )
setName:help( "Sets target's RPName." )

-- !jobban
function ulx.jobBan( calling_ply, target_ply, job )
	local newnum = nil
    local newname = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.find( v.name, job ) != nil then
			newnum = i
			newname = v.name
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return
	end
	target_ply:teamBan( newnum, 0 )
	ulx.fancyLogAdmin( calling_ply, "#A has banned #T from job #s", target_ply, newname )
end
local jobBan = ulx.command( CATEGORY_NAME, "ulx jobban", ulx.jobBan, "!jobban" )
jobBan:addParam{ type=ULib.cmds.PlayerArg }
jobBan:addParam{ type=ULib.cmds.StringArg, hint="job" }
jobBan:defaultAccess( ULib.ACCESS_ADMIN )
jobBan:help( "Bans target from specified job." )

-- !jobunban
function ulx.jobUnBan( calling_ply, target_ply, job )
	local newnum = nil
    local newname = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.find( v.name, job ) != nil then
			newnum = i
			newname = v.name
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return
	end
	target_ply:teamUnBan( newnum )
	ulx.fancyLogAdmin( calling_ply, "#A has unbanned #T from job #s", target_ply, newname, time )
end
local jobUnBan = ulx.command( CATEGORY_NAME, "ulx jobunban", ulx.jobUnBan, "!jobunban" )
jobUnBan:addParam{ type=ULib.cmds.PlayerArg }
jobUnBan:addParam{ type=ULib.cmds.StringArg, hint="job" }
jobUnBan:defaultAccess( ULib.ACCESS_ADMIN )
jobUnBan:help( "Unbans target from specified job." )

-- !selldoor
function ulx.sellDoor( calling_ply )
	local trace = util.GetPlayerTrace( calling_ply )
	local traceRes = util.TraceLine( trace )
	local tEnt = traceRes.Entity
	if tEnt:isDoor() and tEnt:isKeysOwned() then
		tEnt:keysUnOwn( tEnt:getDoorOwner() )
		calling_ply:ChatPrint( "Door Sold!" )
	else
		ULib.tsayError( "The Entity must be a door, and it must be owned!" )
	end
end
local sellDoor = ulx.command( CATEGORY_NAME, "ulx selldoor", ulx.sellDoor, "!selldoor" )
sellDoor:defaultAccess( ULib.ACCESS_ADMIN )
sellDoor:help( "Unowns door you are looking at." )

-- !doorowner
function ulx.doorOwner( calling_ply, target_ply )
	local trace = util.GetPlayerTrace( calling_ply )
	local traceRes = util.TraceLine( trace )
	local tEnt = traceRes.Entity
	if tEnt:isDoor() then
		if tEnt:isKeysOwned() then tEnt:keysUnOwn( tEnt:getDoorOwner() ) end
		tEnt:keysOwn( target_ply )
	end
end
local doorOwner = ulx.command( CATEGORY_NAME, "ulx doorowner", ulx.doorOwner, "!doorowner" )
doorOwner:addParam{ type=ULib.cmds.PlayerArg }
doorOwner:defaultAccess( ULib.ACCESS_ADMIN )
doorOwner:help( "Sets the door owner of the door you are looking at." )

-- !arrest
function ulx.arrest( calling_ply, target_ply, time )
	target_ply:arrest( time or GM.Config.jailtimer, calling_ply )
	ulx.fancyLogAdmin( calling_ply, "#A force arrested #T for #i seconds", target_ply, time or GAMEMODE.Config.jailtimer )
end
local Arrest = ulx.command( CATEGORY_NAME, "ulx arrest", ulx.arrest, "!arrest" )
Arrest:addParam{ type=ULib.cmds.PlayerArg }
Arrest:addParam{ type=ULib.cmds.NumArg, hint="arrest time", min=0, ULib.cmds.optional }
Arrest:defaultAccess( ULib.ACCESS_ADMIN )
Arrest:help( "Force arrest someone." )

-- !unarrest
function ulx.unArrest( calling_ply, target_ply )
	if target_ply:isArrested() then target_ply:unArrest( calling_ply ) else
		ULib.tsayError( calling_ply, "The target needs to be arrested in the first place!" )
		return
	end
	ulx.fancyLogAdmin( calling_ply, "#A force unarrested #T", target_ply )
end
local unArrest = ulx.command( CATEGORY_NAME, "ulx unarrest", ulx.unArrest, "!unarrest" )
unArrest:addParam{ type=ULib.cmds.PlayerArg }
unArrest:defaultAccess( ULib.ACCESS_ADMIN )
unArrest:help( "Force unarrest someone." )

function ulx.setdisease(calling_ply, target_ply, dis)

	local num = tonumber(dis)

	if isnumber(num) then dis = num end

	if IsValid(target_ply) and not target_ply._inHealBed then

		local ret = target_ply:SetDisease(dis, true)

		if ret then -- возвращает ошибку, при успехе - ничего.
			ULib.tsayError(calling_ply, ret, true)
			for k, v in ipairs(diseases.GetAll()) do
				calling_ply:ChatPrint(k .. " = " .. v.name)
			end
		end
	end

--	ulx.fancyLogAdmin( calling_ply, "#A установил #T болезнь #s", target_ply, dis )
end
local setdisease = ulx.command( CATEGORY_NAME, "ulx setdisease", ulx.setdisease, "!setdis" )
setdisease:addParam{ type=ULib.cmds.PlayerArg }
setdisease:addParam{ type=ULib.cmds.StringArg, hint="none" }
setdisease:defaultAccess( ULib.ACCESS_ADMIN )
setdisease:help( "Устанавливает болезнь игроку." )

function ulx.setcodename(calling_ply, target_ply, name)
	if not IsValid(target_ply) then return end
	local can, reason = DarkRP.Recognition.SetCodeName(target_ply, name)
	if can == false then
		ULib.tsayError(calling_ply, (reason or "unknownerror"), true)
		return
	end
	ulx.fancyLogAdmin(calling_ply, "#A установил #T кодовое имя #s", target_ply, name)
end
local setcodename = ulx.command(CATEGORY_NAME, "ulx setcodename", ulx.setcodename, "!setcodename")
setcodename:addParam{ type=ULib.cmds.PlayerArg }
setcodename:addParam{ type=ULib.cmds.StringArg, hint="name" }
setcodename:defaultAccess(ULib.ACCESS_ADMIN)
setcodename:help("Устанавливает кодовое имя игроку.")

------------------------------ Tcsay ------------------------------
function ulx.tcsay( calling_ply, target_ply, message )
	ULib.csay( target_ply, message )

	if ULib.toBool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( string.format( "(tcsay from %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message ) )
	end

	-- ulx.fancyLogAdmin(calling_ply, "#A отправил #T уведомление (#s)", target_ply, message)
	calling_ply:ChatPrint( "Вы отправили уведомление игроку!" )
	DarkRP.notify(target_ply, 1, 15, string.format("Администратор - %s (%s) прислал вам уведомление: %s", calling_ply:Nick(), calling_ply:SteamID(), message))
end
local tcsay = ulx.command( CATEGORY_NAME, "ulx tcsay", ulx.tcsay, "@@@@", true, true )
tcsay:addParam{type = ULib.cmds.PlayerArg}
tcsay:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
tcsay:defaultAccess( ULib.ACCESS_ADMIN )
tcsay:help( "Send a message to target player in the middle of their screen." )