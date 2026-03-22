local nul_vec = Vector()
hook.Add("CalcMainActivity", "anim.PlaySequence", function(ply, vel)
	local seq = ply:GetNetVar("current_sequence")
	if seq and vel == nul_vec then
		ply.CalcSeqOverride = seq
		ply.CalcIdeal = -1
		return -1, seq
	end
end)

local binds = {
	["+moveleft"] = true,
	["+moveright"] = true,
	["+back"] = true,
	["+forward"] = true,
	["+attack"] = true,
	["+attack2"] = true,
}

local nextc = 0
local function stop_sequence_on_move(ply, bind)
	if nextc > CurTime() then return end
	nextc = CurTime() + .5
	if not binds[bind] or not ply:GetNetVar("current_sequence") then return end
	netstream.Start("anims.StopSequence", ply:GetNetVar("current_sequence"))
end

hook.Add("PlayerBindPress", "anims.SequenceResetOnMove", stop_sequence_on_move)
