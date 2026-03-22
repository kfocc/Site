hook.Add("canMovePocketItem", "JSCanMovePocketItem", function(ply, from_ent, to_ent, from_slot, to_slot, item)
	if ply == to_ent and ply == from_ent then -- Двигает у себя
		return
	end

	local item_data = Storage.pocketable[item.class] or {}
	if not item_data.contraband and from_ent:IsPlayer() and from_ent:IsHandcuffed() then return false, "Это не контрабанда" end
	if ply ~= to_ent and to_ent:IsPlayer() and to_ent:IsHandcuffed() then return false, "Вы не можете передать контрабанду другому игроку" end
end)
