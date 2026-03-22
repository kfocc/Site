hook.Add("CalcMainActivity", "Vomit_Effect", function(ply, vel)
	local seq = ply:GetNetVar("vomit")
	if seq then return -1, seq end
end)
