do return end
SH_REWARDS = {}
SH_REWARDS.Rewards = {}

include("rewards/lib_easynet.lua")
include("rewards/lib_panelhook.lua")
include("rewards/sh_main.lua")
include("rewards_config.lua")
include("rewards_table.lua")

SH_REWARDS.Language = include("rewards/language/" .. (SH_REWARDS.LanguageName or "english") .. ".lua")

if (SERVER) then
	AddCSLuaFile("rewards_config.lua")
	AddCSLuaFile("rewards_table.lua")
	AddCSLuaFile("rewards/lib_loungeui.lua")
	AddCSLuaFile("rewards/lib_panelhook.lua")
	AddCSLuaFile("rewards/language/" .. (SH_REWARDS.LanguageName or "english") .. ".lua")
	AddCSLuaFile("rewards/sh_main.lua")
	AddCSLuaFile("rewards/cl_main.lua")
	AddCSLuaFile("rewards/cl_menu_main.lua")
	AddCSLuaFile("rewards/cl_menu_leaderboard.lua")
	AddCSLuaFile("rewards/cl_menu_referrals.lua")
	AddCSLuaFile("rewards/cl_menu_rewards.lua")
	AddCSLuaFile("rewards/cl_menu_steam.lua")

	include("rewards/lib_database.lua")
	include("rewards_config_sv.lua")

	include("rewards/sv_main.lua")
	include("rewards/sv_rewards.lua")
	include("rewards/sv_referrals.lua")
	include("rewards/sv_steamgroup.lua")
	include("rewards/sv_steamtag.lua")
	include("rewards/sv_leaderboard.lua")
else
	include("rewards/lib_loungeui.lua")

	include("rewards/cl_main.lua")
	include("rewards/cl_menu_main.lua")
	include("rewards/cl_menu_leaderboard.lua")
	include("rewards/cl_menu_referrals.lua")
	include("rewards/cl_menu_rewards.lua")
	include("rewards/cl_menu_steam.lua")
end