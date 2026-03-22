plogs.Register("Чат", false)
local format = "%s говорит \"%s\""
plogs.AddHook("PlayerSay", function(pl, text)
	if text == "" then return end
	text = utf8.force(text)
	if utf8.len(text) > 300 then text = utf8.sub(text, 0, 300) end
	if pl.last_text == text then return end
	pl.last_text = text
	local str = format:format(pl:NameID(), string.Trim(text))
	plogs.PlayerLog(pl, "Чат", str, {
		["Имя"] = pl:Name(),
		["SteamID"] = pl:SteamID()
	})
end)
