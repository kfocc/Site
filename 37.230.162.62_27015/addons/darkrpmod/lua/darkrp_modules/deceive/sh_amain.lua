AddCSLuaFile("darkrp_modules/deceive/more/sh_config.lua")

AddCSLuaFile("darkrp_modules/deceive/more/sh_translations.lua")
AddCSLuaFile("darkrp_modules/deceive/more/sh_disguise.lua")

AddCSLuaFile("darkrp_modules/deceive/more/cl_disguise.lua")
AddCSLuaFile("darkrp_modules/deceive/more/cl_interface.lua")

deceive = deceive or {}
local ok, err = pcall(include, "darkrp_modules/deceive/more/sh_config.lua")
if not ok then
	MsgC(Color(255, 255, 0), "\n----------------------------------------------------------------------------------------------------------\n")
	Msg("[Deceive] ")
	MsgC(Color(255, 92, 92), "ERROR WHILE LOADING CONFIG: " .. err .. "\n")
	MsgC(Color(255, 92, 92), "Unexpected behavior is to be expected! If you have no clue what you are doing, submit a support ticket with the error that your config produces.\n")
	MsgC(Color(255, 92, 92), "Deceive will not function in this state.\n")
	MsgC(Color(255, 255, 0), "----------------------------------------------------------------------------------------------------------\n\n")
	return
end

if not deceive.Config then
	MsgC(Color(255, 255, 0), "\n----------------------------------------------------------------------------------------------------------\n")
	Msg("[Deceive] ")
	MsgC(Color(255, 92, 92), "ERROR WHILE LOADING CONFIG: Config does not exist????\n")
	MsgC(Color(255, 92, 92), "Unexpected behavior is to be expected! If you have no clue what you are doing, submit a support ticket with the error that your config produces.\n")
	MsgC(Color(255, 92, 92), "Deceive will not function in this state.\n")
	MsgC(Color(255, 255, 0), "----------------------------------------------------------------------------------------------------------\n\n")
	return
end

include("darkrp_modules/deceive/more/sh_translations.lua")
include("darkrp_modules/deceive/more/sh_disguise.lua")

if SERVER then
	include("darkrp_modules/deceive/more/sv_disguise.lua")
	include("darkrp_modules/deceive/more/sv_interface.lua")
elseif CLIENT then
	include("darkrp_modules/deceive/more/cl_disguise.lua")
	include("darkrp_modules/deceive/more/cl_interface.lua")
end

Msg("[Deceive " .. (SERVER and "SERVER" or "CLIENT") .. "] ")
MsgC(Color(127, 192, 255), "Loaded successfully!\n")
