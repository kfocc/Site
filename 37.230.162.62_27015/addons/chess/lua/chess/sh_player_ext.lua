chess = chess or {}

local PLAYER = FindMetaTable("Player")
if not PLAYER then
	return
end

function PLAYER:GetChessElo()
	return self:GetNetVar("ChessElo", 1400)
end

function PLAYER:GetDraughtsElo()
	return self:GetNetVar("DraughtsElo", 1400)
end

function PLAYER:GetChessRank(isDraughts)
	if isDraughts then
		return self:GetNetVar("draughtsRank", 0)
	else
		return self:GetNetVar("chessRank", 0)
	end
end

function PLAYER:GetGamesCount(isDraughts)
	if isDraughts then
		return self:GetNetVar("draughtsGamesPlayed", 0)
	else
		return self:GetNetVar("chessGamesPlayed", 0)
	end
end
