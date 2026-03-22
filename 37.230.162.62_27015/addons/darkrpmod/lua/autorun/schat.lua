if SERVER then
	AddCSLuaFile("schat2/schat2_config.lua")
	AddCSLuaFile("schat2/cl_schat2_cvars.lua")
	AddCSLuaFile("schat2/vgui/cl_basepanel.lua")
	AddCSLuaFile("schat2/cl_schat2.lua")

	include("schat2/schat2_config.lua")
	include("schat2/sv_schat2.lua")
else
	include("schat2/cl_schat2.lua")
end
