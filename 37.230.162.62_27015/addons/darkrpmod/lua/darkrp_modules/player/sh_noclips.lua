hook.Add("PlayerNoClip", "AoDNoClip", function(ply, enable)
	if IsValid(ply) and (ply:CheckGroup("superadmin") or ply:Team() == TEAM_ADMIN) then
		hook.Run("PlayerNoCliped", ply, enable)
		return true
	end
end)

if CLIENT then
	hook.Add("PlayerFootstep", "DisableNoclipFoots", function(player, position, foot, sound, volume, recipientFilter)
		if player:GetNW2Bool("observer") == true then
			return true
		end
	end)
else
	hook.Add("PlayerFootstep", "DisableNoclipFoots", function(player, position, foot, sound, volume, recipientFilter)
		if player:GetNW2Bool("observer") == true then
			return true
		end
	end)
end
