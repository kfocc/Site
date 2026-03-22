--[[-------------------------------------------------------------------------
--  Please at least do not remove this comment
--  by chelog
---------------------------------------------------------------------------]]

include "cats/shared.lua"
include "cats/pon.lua"
include "utime/sh_utime.lua"

if SERVER then
	AddCSLuaFile "cats/client.lua"
	AddCSLuaFile "cats/shared.lua"
	AddCSLuaFile "cats/pon.lua"
	AddCSLuaFile "utime/sh_utime.lua"
	include "cats/server_additional.lua"
	include "cats/server.lua"
	include "utime/sv_utime.lua"
else
	include "cats/client.lua"
end

print("[CATS] Files loaded.")