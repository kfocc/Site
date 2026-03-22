--------------------------------
--  LOAD SERVER/CLIENT FILES  --
--------------------------------
if SERVER then
	-- Create server-table
	sv_PProtect = {
		Settings = {},
		CollectEntities = {}
	}

	-- Include server-files
	include("patchprotect/server/config.lua")
	include("patchprotect/server/settings.lua")
	include("patchprotect/server/antispam.lua")
	include("patchprotect/server/propprotection.lua")
	include("patchprotect/server/cleanup.lua")
	include("patchprotect/server/buddy.lua")

	-- Force clients to download all client-files
	AddCSLuaFile()
	AddCSLuaFile("patchprotect/client/csettings.lua")
	AddCSLuaFile("patchprotect/client/fonts.lua")
	AddCSLuaFile("patchprotect/client/hud.lua")
	AddCSLuaFile("patchprotect/client/derma.lua")
	AddCSLuaFile("patchprotect/client/panel.lua")
	AddCSLuaFile("patchprotect/client/buddy.lua")
else
	-- Create client-table
	cl_PProtect = {
		Settings = {
			Antispam = {},
			Propprotection = {},
			CSettings = {}
		},
		Buddies = {}
	}

	-- Include client-files
	include("patchprotect/client/csettings.lua")
	include("patchprotect/client/fonts.lua")
	include("patchprotect/client/hud.lua")
	include("patchprotect/client/derma.lua")
	include("patchprotect/client/panel.lua")
	include("patchprotect/client/buddy.lua")
end

local naborGroups = {
	superadmin = true,
	overwatch = true,
	assistant_nabor = true,
	administrator_nabor = true,
	head_admin_nabor = true,
	advisor_nabor = true,
	event_boss_nabor = true,
	event_nabor = true,
	moderator_nabor = true,
	operator_nabor = true
}

local meta = FindMetaTable("Player")
function meta:IsNabor()
	return naborGroups[self:GetUserGroup()]
end
