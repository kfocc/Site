if SERVER then
	AddCSLuaFile()
	AddCSLuaFile("chess/sh_player_ext.lua")
	AddCSLuaFile("chess/cl_dermaboard.lua")

	include("chess/sh_player_ext.lua")
	include("chess/sv_player_ext.lua")
	include("chess/sv_sql.lua")
else
	include("chess/sh_player_ext.lua")
	include("chess/cl_dermaboard.lua")
end

if SERVER then
	CreateConVar("chess_wagers", 1, FCVAR_ARCHIVE, "Set whether players can wager on their chess games.")
	CreateConVar("chess_darkrp_wager", 1, FCVAR_ARCHIVE, "[DarkRP only] Wagers should use DarkRP wallet.")

	CreateConVar("chess_debug", 0, FCVAR_ARCHIVE, "Debug mode.")
	CreateConVar("chess_limitmoves", 1, FCVAR_ARCHIVE, "Enable 50 move rule.")
else -- CLIENT
	CreateConVar("chess_gridletters", 1, FCVAR_ARCHIVE, "Show grid letters.")
end

hook.Add(
	"canArrest",
	"Chess_PreventArrest",
	function(cop, target)
		if not (IsValid(target) and target:GetNetVar("IsInChess", false)) then
			return
		end

		local board = target:GetNetVar("ActiveChessBoard", nil)
		if not (IsValid(board) and board:GetPlaying()) then
			return
		end
		if target ~= board:GetWhitePlayer() and target ~= board:GetBlackPlayer() then
			return
		end

		return false, "Cannot arrest players during a game in progress" -- Prevent arrest during Chess
	end
)
