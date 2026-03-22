arrestSystem = arrestSystem or {}

local arrestedPlayers = arrestSystem.arrestedPlayers or {}
arrestSystem.arrestedPlayers = arrestedPlayers

netstream.Hook("arrestSystem.UpdateRow", function(id, value)
	arrestedPlayers[id] = value
end)

netstream.Hook("arrestSystem.UpdateAllRows", function(syncTable)
	table.Merge(arrestedPlayers, syncTable)
end)

hook.Add("HUDPaint", "arrests.DrawArrestedInfo", function()
	local ply = LocalPlayer()
	if not ply:isArrested() then return end

	local row = arrestedPlayers[ply:SteamID()]
	local realeseTime = row.arrestedTime + row.time
	if not realeseTime or realeseTime < CurTime() then return end

	local w, h = ScrW(), ScrH()
	w = w - 15
	h = h * 0.15

	local _, th = draw.SimpleTextOutlined("Вы арестованы!", "NLR_Font", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
	h = h + th

	local arrestedReason = row.reason
	if arrestedReason then
		tw, th = draw.SimpleTextOutlined("Причина: " .. arrestedReason, "NLR_Font", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
		h = h + th
	end

	realeseTime = string.FormattedTime(math.max(realeseTime - CurTime(), 0), "%02i:%02i")
	draw.SimpleTextOutlined("Осталось: " .. realeseTime, "NLR_Font", w, h, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
end)

hook.Add("CanBuyEntity", "_arrest.DisableBuyShipment", function(shipment)
	if shipment.ent == "arrest_spawn_basket" and not LocalPlayer():isArrested() then
		return false, false
	end
end)
