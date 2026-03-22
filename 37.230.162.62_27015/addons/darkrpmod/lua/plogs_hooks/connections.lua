plogs.Register('Подключения', true, Color(0, 255, 0))
plogs.AddHook('PlayerInitialSpawn', function(pl)
	plogs.PlayerLog(pl, 'Подключения', pl:NameID() .. ' зашёл', {
		['Name'] = pl:Name(),
		['SteamID'] = pl:SteamID()
	})

	if plogs.cfg.EnableMySQL then plogs.sql.LogIP(pl:SteamID64(), pl:IPAddress()) end
end)

plogs.AddHook('PlayerDisconnected', function(pl)
	plogs.PlayerLog(pl, 'Подключения', pl:NameID() .. ' вышел', {
		['Name'] = pl:Name(),
		['SteamID'] = pl:SteamID()
	})
end)
