DarkRP.Squads = DarkRP.Squads or {}

local Squads = DarkRP.Squads
Squads.List = Squads.List or {}

function Squads.GetPlayerSquadID(ply)
	return ply:GetNetVar("squad_id")
end

function Squads.GetPlayerSquad(ply)
	local id = Squads.GetPlayerSquadID(ply)
	return Squads.GetSquad(id)
end

function Squads.GetSquads()
	return Squads.List
end

function Squads.GetSquad(squad)
	return squad and Squads.GetSquads()[squad]
end

function Squads.GetGroup(squad)
	return Squads.GetSquads()[squad]
end

function Squads.GetPlayerGroupID(ply)
	return ply:GetNetVar("squad_id")
end

function Squads.GetPlayerGroup(ply)
	local id = Squads.GetPlayerGroupID(ply)
	return Squads.GetGroup(id)
end

function Squads.IsLeader(ply)
	local group = Squads.GetPlayerGroup(ply)
	return group and group.leader == ply
end

function Squads.GetLeader(squad)
	local group = Squads.GetGroup(squad)
	return group and group.leader
end

function Squads.GetMembers(id)
	local players = {}
	for k, v in player.Iterator() do
		if Squads.GetPlayerGroupID(v) == id then
			table.insert(players, v)
		end
	end
	return players
end

local function can(ply, target)
	if not IsValid(ply) then return true end
	if not IsValid(target) then return false end
	if ply:isRebel() and target:isCP() then -- Барни
		return false
	end

	if ply:isCPCMD() or ply:isOTACMD() then return target:isCP() or target:isOTA() or target:isSynth() end -- КМД
	if ply:isOTA() or ply:isSynth() then return target:isOTA() or target:isSynth() end -- ОТА
	if ply:isCP() then return target:isCP() and not target:isOTA() end -- ГО
	if ply:isGSR() then return target:isGSR() end
	if ply:isRebel() then return target:isRebel() end
	return false
end

Squads.Can = can
