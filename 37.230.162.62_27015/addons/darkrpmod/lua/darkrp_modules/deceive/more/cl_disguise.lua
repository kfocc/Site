net.Receive("deceive.disguise", function()
	local plyUID = net.ReadUInt(32)
	local targetUID = net.ReadUInt(32)
	local ply = Player(plyUID)
	local target = targetUID
	if target ~= 0 then
		ply.Disguised = ply
	else
		ply.Disguised = nil
	end
end)
