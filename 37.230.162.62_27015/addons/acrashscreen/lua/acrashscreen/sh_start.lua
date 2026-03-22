aCrashScreen = aCrashScreen or {}
local _this = aCrashScreen
_this.config = _this.config or {}

local include_cl = (SERVER) and AddCSLuaFile or include

include_cl("acrashscreen/cl_config.lua")
include_cl("acrashscreen/incl/cl_main.lua")
include_cl("acrashscreen/incl/cl_web.lua")
include_cl("acrashscreen/incl/cl_misc.lua")