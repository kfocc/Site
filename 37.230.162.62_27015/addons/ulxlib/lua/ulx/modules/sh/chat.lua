-- This module holds any type of chatting functions
CATEGORY_NAME = "Chat"

------------------------------ Asay ------------------------------
local seeasayAccess = "ulx seeasay"
if SERVER then ULib.ucl.registerAccess( seeasayAccess, ULib.ACCESS_OPERATOR, "Ability to see 'ulx asay'", "Other" ) end -- Give operators access to see asays echoes by default

function ulx.asay( calling_ply, message )
	calling_ply:ChatPrint("Используйте << /// текст >> для вызова администратора ")
end
local asay = ulx.command( CATEGORY_NAME, "ulx asay", ulx.asay, "@", true, true )
asay:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
asay:defaultAccess( ULib.ACCESS_ALL )
asay:help( "Send a message to currently connected admins." )

------------------------------ Tsay ------------------------------
function ulx.tsay( calling_ply, message )
	ULib.tsay( _, message )

	if ULib.toBool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( string.format( "(tsay from %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message ) )
	end
end
local tsay = ulx.command( CATEGORY_NAME, "ulx tsay", ulx.tsay, "@@", true, true )
tsay:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
tsay:defaultAccess( ULib.ACCESS_ADMIN )
tsay:help( "Send a message to everyone in the chat box." )

------------------------------ Csay ------------------------------
function ulx.csay( calling_ply, message )
	ULib.csay( _, message )

	if ULib.toBool( GetConVarNumber( "ulx_logChat" ) ) then
		ulx.logString( string.format( "(csay from %s) %s", calling_ply:IsValid() and calling_ply:Nick() or "Console", message ) )
	end
end
local csay = ulx.command( CATEGORY_NAME, "ulx csay", ulx.csay, "@@@", true, true )
csay:addParam{ type=ULib.cmds.StringArg, hint="message", ULib.cmds.takeRestOfLine }
csay:defaultAccess( ULib.ACCESS_ADMIN )
csay:help( "Send a message to everyone in the middle of their screen." )

------------------------------ Thetime ------------------------------
local waittime = 60
local lasttimeusage = -waittime
function ulx.thetime( calling_ply )
	if lasttimeusage + waittime > CurTime() then
		ULib.tsayError( calling_ply, "I just told you what time it is! Please wait " .. waittime .. " seconds before using this command again", true )
		return
	end

	lasttimeusage = CurTime()
	ulx.fancyLog( "The time is now #s.", os.date( "%I:%M %p") )
end
local thetime = ulx.command( CATEGORY_NAME, "ulx thetime", ulx.thetime, "!thetime" )
thetime:defaultAccess( ULib.ACCESS_ALL )
thetime:help( "Shows you the server time." )


------------------------------ Adverts ------------------------------
ulx.adverts = ulx.adverts or {}
local adverts = ulx.adverts -- For XGUI, too lazy to change all refs

local function doAdvert( group, id )

	if adverts[ group ][ id ] == nil then
		if adverts[ group ].removed_last then
			adverts[ group ].removed_last = nil
			id = 1
		else
			id = #adverts[ group ]
		end
	end

	local info = adverts[ group ][ id ]

	local message = string.gsub( info.message, "%%curmap%%", game.GetMap() )
	message = string.gsub( message, "%%host%%", GetConVarString( "hostname" ) )
	message = string.gsub( message, "%%ulx_version%%", ULib.pluginVersionStr( "ULX" ) )

	if not info.len then -- tsay
		local lines = ULib.explode( "\\n", message )

		for i, line in ipairs( lines ) do
			local trimmed = line:Trim()
			if trimmed:len() > 0 then
				ULib.tsayColor( _, true, info.color, trimmed ) -- Delaying runs one message every frame (to ensure correct order)
			end
		end
	else
		ULib.csay( _, message, info.color, info.len )
	end

	ULib.queueFunctionCall( function()
		local nextid = math.fmod( id, #adverts[ group ] ) + 1
		timer.Remove( "ULXAdvert" .. type( group ) .. group )
		timer.Create( "ULXAdvert" .. type( group ) .. group, adverts[ group ][ nextid ].rpt, 1, function() doAdvert( group, nextid ) end )
	end )
end

-- Whether or not it's a csay is determined by whether there's a value specified in "len"
function ulx.addAdvert( message, rpt, group, color, len )
	local t

	if group then
		t = adverts[ tostring( group ) ]
		if not t then
			t = {}
			adverts[ tostring( group ) ] = t
		end
	else
		group = table.insert( adverts, {} )
		t = adverts[ group ]
	end

	local id = table.insert( t, { message=message, rpt=rpt, color=color, len=len } )

	if not timer.Exists( "ULXAdvert" .. type( group ) .. group ) then
		timer.Create( "ULXAdvert" .. type( group ) .. group, rpt, 1, function() doAdvert( group, id ) end )
	end
end

------------------------------ Gimp ------------------------------
ulx.gimpSays = ulx.gimpSays or {} -- Holds gimp says
local gimpSays = ulx.gimpSays -- For XGUI, too lazy to change all refs
local ID_GIMP = 1
local ID_MUTE = 2

function ulx.addGimpSay( say )
	table.insert( gimpSays, say )
end

function ulx.clearGimpSays()
	table.Empty( gimpSays )
end

function ulx.gimp( calling_ply, target_plys, time, reason, should_unmute )
	time = time or 60
	reason = reason or "Не указана"
	if not should_unmute then
		ulx.fancyLogAdmin( calling_ply, "#A отключил чат #T на #s. Причина: #s", target_plys, util.TimeToStr(time), reason )
		target_plys.gimp = ID_GIMP
		timer.Create("unmute_" .. target_plys:SteamID64(), time, 1, function()
			target_plys.gimp = nil
		end)
	elseif target_plys.gimp then
		ulx.fancyLogAdmin( calling_ply, "#A включил чат #T", target_plys )
		if timer.Exists("unmute_" .. target_plys:SteamID64()) then
			timer.Remove("unmute_" .. target_plys:SteamID64())
		end
		target_plys.gimp = nil
	else
		ULib.tsayError( calling_ply, "У игрока нету мута", true )
		return
	end
	target_plys:SetNW2Bool("ulx_muted", not should_unmute)
end
local gimp = ulx.command( CATEGORY_NAME, "ulx gimp", ulx.gimp, "!gimp" )
gimp:addParam{ type = ULib.cmds.PlayerArg }
gimp:addParam{ type = ULib.cmds.NumArg, hint = "секунд"}
gimp:addParam{ type = ULib.cmds.StringArg, hint = "Причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
gimp:addParam{ type = ULib.cmds.BoolArg, invisible = true }
gimp:defaultAccess( ULib.ACCESS_ADMIN )
gimp:help( "Цель начинает писать бред в чат" )
gimp:setOpposite( "ulx ungimp", {_, _, _, _, true}, "!ungimp" )

------------------------------ Mute ------------------------------
function ulx.mute( calling_ply, target_plys, time, reason, should_unmute )
	time = time or 60
	reason = reason or "Не указана"

	if not should_unmute and not target_plys.gimp then
		ulx.fancyLogAdmin(calling_ply, "#A отключил чат #T на #s. Причина: #s", target_plys, util.TimeToStr(time), reason)

		target_plys.gimp = ID_MUTE
		if time ~= 0 then
			timer.Create("unmute_" .. target_plys:SteamID64(), time, 1, function()
				target_plys.gimp = nil
			end)
		end

		target_plys:SetNW2Bool("ulx_muted", true)
		return
	elseif should_unmute and target_plys.gimp then
		ulx.fancyLogAdmin(calling_ply, "#A включил чат #T", target_plys)

		if timer.Exists("unmute_" .. target_plys:SteamID64()) then
			timer.Remove("unmute_" .. target_plys:SteamID64())
		end

		target_plys.gimp = nil

		target_plys:SetNW2Bool("ulx_muted", false)
		return
	end

	if target_plys.gimp then
		ULib.tsayError(calling_ply, "У игрока уже есть мут.", true)
	else
		ULib.tsayError(calling_ply, "У игрока нет мута.", true)
	end
end
local mute = ulx.command( CATEGORY_NAME, "ulx mute", ulx.mute, "!mute" )
mute:addParam{ type = ULib.cmds.PlayerArg }
mute:addParam{ type = ULib.cmds.NumArg, hint = "секунд"}
mute:addParam{ type = ULib.cmds.StringArg, hint = "Причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
mute:addParam{ type = ULib.cmds.BoolArg, invisible = true }
mute:defaultAccess( ULib.ACCESS_ADMIN )
mute:help( "Отключает чат игроку." )
mute:setOpposite( "ulx unmute", {_, _, _, _, true}, "!unmute" )

if SERVER then
	local function gimpCheck( ply, strText )
		if ply.gimp == ID_MUTE then
			return ""
		end
		if ply.gimp == ID_GIMP then
			if #gimpSays < 1 then
				return ""
			end
			return gimpSays[ math.random( #gimpSays ) ]
		end
	end
	hook.Add( "PlayerSay", "ULXGimpCheck", gimpCheck, HOOK_LOW )

	hook.Add( "PlayerDisconnected", "ULXGGCheck", function(ply)
		if not ply.gimp and not ply.ulx_gagged then
			return
		end
		if timer.Exists("unmute_" .. ply:SteamID64()) then
			timer.Remove("unmute_" .. ply:SteamID64())
		end
		if timer.Exists("ungag_" .. ply:SteamID64()) then
			timer.Remove("ungag_" .. ply:SteamID64())
		end
	end)
end

------------------------------ Gag ------------------------------
function ulx.gag(calling_ply, target_plys, time, reason, should_unmute)
	time = time or 60
	reason = reason or "Не указана"

	if not should_unmute and not target_plys.ulx_gagged then
		ulx.fancyLogAdmin(calling_ply, "#A отключил голос #T на #s. Причина: #s", target_plys, util.TimeToStr(time), reason)
		target_plys.ulx_gagged = true

		if time ~= 0 then
			timer.Create("ungag_" .. target_plys:SteamID64(), time, 1, function()
				target_plys.ulx_gagged = nil
			end)
		end

		target_plys:SetNW2Bool("ulx_gagged", true)
		return
	elseif should_unmute and target_plys.ulx_gagged then
		ulx.fancyLogAdmin(calling_ply, "#A включил голос #T", target_plys)

		if timer.Exists("ungag_" .. target_plys:SteamID64()) then
			timer.Remove("ungag_" .. target_plys:SteamID64())
		end

		target_plys.ulx_gagged = nil

		target_plys:SetNW2Bool("ulx_gagged", false)
		return
	end

	if target_plys.ulx_gagged then
		ULib.tsayError(calling_ply, "У игрока уже отключен голос.", true)
	else
		ULib.tsayError(calling_ply, "У игрока не отключен голос.", true)
	end
end
local gag = ulx.command( CATEGORY_NAME, "ulx gag", ulx.gag, "!gag" )
gag:addParam{ type = ULib.cmds.PlayerArg }
gag:addParam{ type = ULib.cmds.NumArg, hint = "секунд"}
gag:addParam{ type = ULib.cmds.StringArg, hint = "Причина", ULib.cmds.optional, ULib.cmds.takeRestOfLine }
gag:addParam{ type = ULib.cmds.BoolArg, invisible = true }
gag:defaultAccess( ULib.ACCESS_ADMIN )
gag:defaultAccess( ULib.ACCESS_ADMIN )
gag:help( "Отключение микрофона игроку" )
gag:setOpposite( "ulx ungag", {_, _, _, _, true}, "!ungag" )

local GetTable = FindMetaTable("Entity").GetTable
local function gagHook( listener, talker )
	if GetTable(talker).ulx_gagged then
		return false
	end
end
hook.Add( "PlayerCanHearPlayersVoice", "ULXGag", gagHook )

-- Anti-spam stuff
if SERVER then
	local chattime_cvar = ulx.convar( "chattime", "1.5", "<time> - Players can only chat every x seconds (anti-spam). 0 to disable.", ULib.ACCESS_ADMIN )
	local function playerSay( ply )
		if not ply.lastChatTime then ply.lastChatTime = 0 end

		local chattime = chattime_cvar:GetFloat()
		if chattime <= 0 then return end

		if ply.lastChatTime + chattime > CurTime() then
			return ""
		else
			ply.lastChatTime = CurTime()
			return
		end
	end
	hook.Add( "PlayerSay", "ulxPlayerSay", playerSay, HOOK_LOW )
end
