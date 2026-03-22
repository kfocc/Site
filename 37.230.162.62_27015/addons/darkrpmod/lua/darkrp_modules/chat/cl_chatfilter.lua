local filters = {
	-- "шёпот",
	-- "крик",
	"[Реклама]",
	"[Передача!]",
	"радио",
	"(ЗАПРОС!)",
	"(группе)",
	"(УВОЛЬНЕНИЕ)",
	"OOC",
	"Радио %d",
	"(PM)",
}

local function filterText(prefix, text)
	for k, v in ipairs(filters) do
		if prefix:find(v, 1, true) then return util.FilterText(text, TEXT_FILTER_UNKNOWN) end
	end
	return text
end

local function AddToChat(bits)
	local col1 = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
	local prefixText = net.ReadString()
	local ply = net.ReadEntity()
	ply = IsValid(ply) and ply or LocalPlayer()

	if not IsValid(ply) then return end
	if prefixText == "" or not prefixText then
		prefixText = ply:Nick()
		prefixText = prefixText ~= "" and prefixText or ply:SteamName()
	end

	local col2 = Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))
	local text = net.ReadString()
	local shouldShow
	if text and text ~= "" then
		if IsValid(ply) then
			text = filterText(prefixText, text)
			shouldShow = hook.Call("OnPlayerChat", GAMEMODE, ply, text, false, not ply:Alive(), prefixText, col1, col2)
		end

		if shouldShow ~= true then chat.AddNonParsedText(col1, prefixText, col2, " " .. text) end
	else
		prefixText = filterText(prefixText, prefixText)
		shouldShow = hook.Call("ChatText", GAMEMODE, "0", prefixText, prefixText, "darkrp")
		if shouldShow ~= true then chat.AddNonParsedText(col1, prefixText) end
	end

	chat.PlaySound()
end

net.Receive("DarkRP_Chat", AddToChat)
