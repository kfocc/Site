plogs.Register('Наручники', true, Color(0, 255, 0))
plogs.AddHook('OnHandcuffed', function(pl, targ, isScreeds)
	plogs.PlayerLog(pl, 'Наручники', pl:NameID() .. ' заковал в ' .. (isScreeds and 'стяжки ' or 'наручники ') .. targ:NameID(), {
		['Name'] = pl:Name(),
		['SteamID'] = pl:SteamID(),
		['Target Name'] = targ:Name(),
		['Target SteamID'] = targ:SteamID()
	})
end)

plogs.AddHook('OnHandcuffBreak', function(pl, cuffs, friend, isScreeds)
	if IsValid(friend) then
		plogs.PlayerLog(pl, 'Наручники', friend:NameID() .. ' снял ' .. (isScreeds and 'стяжки' or 'наручники') .. ' с ' .. pl:NameID(), {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID(),
			['Fried Name'] = friend:Name(),
			['Target SteamID'] = friend:SteamID()
		})
	else
		plogs.PlayerLog(pl, 'Наручники', pl:NameID() .. ' выбрался из своих ' .. (cuffs and 'стяжек' or 'наручников'), {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID()
		})
	end
end)

plogs.AddHook('PlayerDisconnected', function(pl)
	if pl:Alive() and pl:IsHandcuffed() then
		plogs.PlayerLog(pl, 'Наручники', pl:NameID() .. ' вышел с сервера в наручниках.', {
			['Name'] = pl:Name(),
			['SteamID'] = pl:SteamID()
		})
	end
end)

plogs.AddHook('playerWeaponsChecked', function(pl, targ)
	plogs.PlayerLog(pl, 'Наручники', pl:NameID() .. ' обыскал ' .. targ:NameID(), {
		['Name'] = pl:Name(),
		['SteamID'] = pl:SteamID(),
		['Target Name'] = targ:Name(),
		['Target SteamID'] = targ:SteamID()
	})
end)

plogs.AddHook('playerWeaponsReturned', function(pl, targ)
	if not IsValid(pl) then return end
	plogs.PlayerLog(pl, 'Наручники', pl:NameID() .. ' вернул конфискованное ' .. targ:NameID(), {
		['Name'] = pl:Name(),
		['SteamID'] = pl:SteamID(),
		['Target Name'] = targ:Name(),
		['Target SteamID'] = targ:SteamID()
	})
end)

plogs.AddHook('playerWeaponsConfiscated', function(pl, targ)
	plogs.PlayerLog(pl, 'Наручники', pl:NameID() .. ' конфисковал оружие у ' .. targ:NameID(), {
		['Name'] = pl:Name(),
		['SteamID'] = pl:SteamID(),
		['Target Name'] = targ:Name(),
		['Target SteamID'] = targ:SteamID()
	})
end)
