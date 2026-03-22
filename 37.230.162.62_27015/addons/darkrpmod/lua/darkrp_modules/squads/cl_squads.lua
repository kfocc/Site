DarkRP.Squads = DarkRP.Squads or {}

local Squads = DarkRP.Squads
Squads.List = Squads.List or {}

function Squads.MakeLeader(ply, squad)
	netstream.Start("Squads.MakeLeader", ply, squad)
end

function Squads.Move(ply, squad)
	netstream.Start("Squads.Move", ply, squad)
end

function Squads.Create(ply, name)
	netstream.Start("Squads.Create", ply, name)
end

function Squads.Disband(id)
	netstream.Start("Squads.Disband", id)
end

function Squads.SetProtocol(id, protocol)
	local players = Squads.GetMembers(id)
	netstream.Start("ota.SetProtocol", players, protocol)
end

function Squads.ToggleRadioSpeaker(id, should)
	local players = Squads.GetMembers(id)
	local mode = should and "turn_on" or "turn_off"
	netstream.Start("radio.admins", mode, players)
end

function Squads.ToggleRadioMicrophone(id, should)
	local players = Squads.GetMembers(id)
	local mode = should and "turn_off_force" or "turn_on_force"
	netstream.Start("radio.admins", mode, players)
end

function Squads.RenameGroup(id, name)
	netstream.Start("Squads.Rename", id, name)
end

function Squads.ResetProtocol(id)
	local players = {}
	for k, v in pairs(player.GetAll()) do
		if Squads.GetPlayerGroupID(v) == id then table.insert(players, v) end
	end

	netstream.Start("ota.ResetProtocol", players)
end

netstream.Hook("Squads.Sync", function(id, data) Squads.List[id] = data end)
