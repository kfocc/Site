hook.Add("CanPlayerSuicide", "BlockSuicide", function(ply)
	if not (ply:isZombie() or ply:IsSuperAdmin()) then
		DarkRP.notify(ply, 0, 4, "На данной профессии эта команда отключена!")
		return false
	end
end)
