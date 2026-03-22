local targets = {}

netstream.Hook("OTA.OutlinePlayer", function(ply, time)
	targets[ply] = CurTime() + time
end)

local outline_color = Color(255, 0, 0)
hook.Add("SetupOutlines", "OTA.OutlinePlayer", function()
	local now = CurTime()
	for ply, time in pairs(targets) do
		if not IsValid(ply) or not ply:Alive() or now > time then
			targets[ply] = nil
		else
			outline.Add({ply}, outline_color)
		end
	end
end)