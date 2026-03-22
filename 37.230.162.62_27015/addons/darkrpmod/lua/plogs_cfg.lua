--
-- General configs
--
-- The chat command to open the menu, (DO NOT ADD A ! or /, it does this for you)
local prefixes = {"/", "!"}
plogs.cfg.Command = {
	['logs'] = true,
	['plogs'] = true,
	['логи'] = true
}

local fmtTab = {}
for k, v in pairs(plogs.cfg.Command) do
	for _, prefix in ipairs(prefixes) do
		fmtTab[prefix .. k] = v
	end
end

plogs.cfg.Command = fmtTab
fmtTab = nil
-- User groups that can access the logs.
plogs.cfg.UserGroups = {
	['owner'] = true,
	['superadmin'] = true,
	['operator'] = true,
	['operator_nabor'] = true,
	['administrator'] = true,
	['administrator_nabor'] = true,
	['head_admin_nabor'] = true,
	['administrator_custom'] = true,
	['advisor_nabor'] = true,
	['event_boss_nabor'] = true,
	['event_nabor'] = true,
	['assistant_nabor'] = true,
	['moderator'] = true,
	['moderator_nabor'] = true
}

-- User groups that can access IP logs
plogs.cfg.IPUserGroups = {
	['superadmin'] = true,
}

-- Window width percentage, I recomend no lower then 0.75
plogs.cfg.Width = 0.75
-- Window height percentage, I recomend no lower then 0.75
plogs.cfg.Height = 0.75
-- Some logs print to your client console. Enable this to print them to your server console too
plogs.cfg.EchoServer = false
-- Allow me to use logs on your server. (Disable if you're paranoid)
plogs.cfg.DevAccess = true
-- Do you want to store IP logs and playerevents? If enabled make sure to edit plogs_mysql_cfg.lua!
plogs.cfg.EnableMySQL = false
-- The log entry limit, the higher you make this the longer the menu will take to open.
plogs.cfg.LogLimit = 512
-- Format names with steamids? If true "aStoned(STEAMID)", if false just "aStoned"
plogs.cfg.ShowSteamID = true
-- Enable/Disable log types here. Set them to true to disable
plogs.cfg.LogTypes = {
	['chat'] = false,
	['commands'] = true,
	['connections'] = false,
	['kills'] = false,
	['union'] = false,
	['props'] = true,
	['tools'] = true,
	['darkrp'] = false,
	['ulx'] = true,
	['maestro'] = true,
	['pnlr'] = true, -- NLR Zones					|| 	https://scriptfodder.com/scripts/view/583
	['lac'] = true, -- Leys Serverside AntiCheat 	|| 	https://scriptfodder.com/scripts/view/1148
	['awarn2'] = true, -- AWarn2 						||	https://scriptfodder.com/scripts/view/629
	['hhh'] = true, -- HHH 							||	https://scriptfodder.com/scripts/view/3
	['hitmodule'] = true, -- Hitman Module				||	https://scriptfodder.com/scripts/view/1369
	['cuffs'] = false, -- Hand Cuffs 					||	https://scriptfodder.com/scripts/view/910
	['NLR'] = true,
}

--
-- Specific configs, if you disabled the log type that uses one of these the config it doesn't matter
--
-- Command log blacklist, blacklist commands here that dont need to be logged
plogs.cfg.CommandBlacklist = {
	['_sendDarkRPvars'] = true,
	['_sendAllDoorData'] = true,
	['ulib_update_cvar'] = true,
	['ulib_cl_ready'] = true,
	['_xgui'] = true,
	['ulx'] = true,
	['gm_spawn'] = true,
	['_u'] = true,
	['darkrp'] = true,
	['undo'] = true,
	['gmod_undo'] = true,
	['Job.Unlock'] = true,
	['gmod_tool'] = true,
	['_DarkRP_DoAnimation'] = true,
	['ans'] = true,
	['updateme'] = true,
	['pprotect_send_buddies'] = true,
}

-- Tool log blacklist, blacklist tools here that dont need to be logged
plogs.cfg.ToolBlacklist = {
	['myexampletool'] = true,
}
